<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. TRAVEL)" %>
<%@ attribute name="rootPath" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}"  />
<c:set var="sessionId" 		value="${pageContext.session.id}" />
<c:set var="styleCode" 		value="CTM" />
<c:set var="status" 		value="" />

<c:set var="emailAddress"> 
	<c:if test="${not empty param.email}">${param.email}</c:if>
</c:set>

<%-- Previous transaction id is the last one for this session --%>

<sql:query var="results">
 	SELECT max(TransactionId) AS prevId, rootId 
 	FROM aggregator.transaction_header
 	WHERE sessionid = '${sessionId}' LIMIT 1; 
</sql:query>

<c:set var="previousId">
<c:choose>
	<c:when test="${results.rows[0].prevId!=null}">${results.rows[0].prevId}</c:when>
	<c:otherwise>0</c:otherwise>
</c:choose>
</c:set>
<c:set var="rootId">
<c:choose>
	<c:when test="${results.rows[0].rootId!=null}">${results.rows[0].rootId}</c:when>
	<c:otherwise>0</c:otherwise>
</c:choose>
</c:set>



<%-- Write Transaction Header --%>
<sql:update>
 	insert into aggregator.transaction_header 
 	(TransactionId,rootId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCode,advertKey,sessionId,status) 
 	values (
 		0,
	 	'${rootId}',
	 	'${previousId}',
	 	'${productType}',
	 	'${emailAddress}',
	 	'${ipaddress}',
	 	CURRENT_DATE,
	 	CURRENT_TIME,
	 	'${styleCode}',
	 	0,
	 	'${sessionId}',
	 	'${status}'
 	); 
</sql:update>

<%-- Fetch the transaction id back from MySQL - and store in data --%>
<sql:query var="results">
 	SELECT LAST_INSERT_ID() AS tranId 
 	FROM aggregator.transaction_header; 
</sql:query>

<c:set var="tranId" value="${results.rows[0].tranId}" />
<go:log>Last tranid=${tranId}</go:log>

<%-- Update the rootId if it has not been previously set --%>
<c:if test="${empty rootId or rootId == 0}">
	<sql:update>
		UPDATE aggregator.transaction_header
		SET rootId = '${tranId}'
		WHERE TransactionId = '${tranId}'
	</sql:update>
</c:if>

<go:setData dataVar="data" xpath="${rootPath}/transactionId" value="${tranId}" />
<go:setData dataVar="data" xpath="current/transactionId" value="${tranId}" />

<%-- Save the client values --%>
<c:set var="counter" value="0" />
<c:forEach var="item" items="${param}" varStatus="status">
	<c:set var="counter" value="${status.count}" />
	<c:set var="xpath" value="${go:xpathFromName(item.key)}" />
	
	<%--FIXME: Need to be reviewed and replaced with something nicer --%>
	<c:choose>
	<c:when test="${fn:contains(xpath,'credit/number')}"></c:when>
	<c:when test="${fn:contains(xpath,'bank/number')}"></c:when>
	<c:when test="${fn:contains(xpath,'claim/number')}"></c:when>
	<c:when test="${fn:contains(xpath,'payment/details/type')}"></c:when>
	<c:when test="${xpath=='/operatorid'}"></c:when>
	<c:otherwise>
	
	<sql:update>
 		INSERT INTO aggregator.transaction_details 
 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
 		values (
 			${tranId},
 			'${status.count}',
 			'${xpath}',
 			'${item.value}',
 			default,
 			default
 		); 
	</sql:update>
	</c:otherwise>
	</c:choose>
</c:forEach>

<%--Add the operator to the list details - if exists --%>
<c:if test="${not empty data['login/user/uid']}">
	<sql:update>
 		INSERT INTO aggregator.transaction_details 
 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
 		values (
 			${tranId},
 			'${counter + 1}',
 			'health/operatorId',
 			'${data['login/user/uid']}',
 			default,
 			default
 		); 
	</sql:update>
</c:if>
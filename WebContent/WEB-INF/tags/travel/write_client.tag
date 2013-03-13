<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. TRAVEL)" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}" />
<c:set var="sessionId" 		value="${pageContext.session.id}" />
<c:set var="styleCode" 		value="CTM" />
<c:set var="status" 		value="" />

<c:set var="emailAddress"> 
	<c:if test="${not empty param.email}">${param.email}</c:if>
</c:set>

<%-- Previous transaction id is the last one for this session --%>
<c:set var="previousId">
	<sql:query var="results">
	 	SELECT max(TransactionId) AS previd 
	 	FROM aggregator.transaction_header
	 	WHERE sessionid = '${sessionId}' LIMIT 1; 
	</sql:query>

	<c:choose>
		<c:when test="${results.rows[0].prevId!=null}">${results.rows[0].prevId}</c:when>
		<c:otherwise>0</c:otherwise>
	</c:choose>
</c:set>

<%-- Write Transaction Header --%>
<sql:update>
 	insert into aggregator.transaction_header 
 	(TransactionId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCode,advertKey,sessionId,status) 
 	values (
 		0,
	 	'${previousId}',
	 	'${productType}',
	 	'${emailAddress}',
	 	'${ipAddress}',
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

<go:setData dataVar="data" xpath="travel/transactionId" value="${tranId}" />

<%-- Save the client values --%>
<c:forEach var="item" items="${param}" varStatus="status">

	<c:set var="xpath" value="${go:xpathFromName(item.key)}" />
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
</c:forEach>
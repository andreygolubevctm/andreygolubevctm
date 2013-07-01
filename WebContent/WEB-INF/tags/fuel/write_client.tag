<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. FUEL)" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}" />
<c:set var="sessionId" 		value="${pageContext.session.id}" />
<c:set var="styleCode" 		value="" />
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
<sql:transaction>
<sql:update>
	INSERT into aggregator.transaction_header
 	(TransactionId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCode,advertKey,sessionId,status) 
	values (0,(?),(?),(?),(?),CURRENT_DATE,CURRENT_TIME,(?),0,(?),(?));
	<sql:param value="${previousId}" />
	<sql:param value="${productType}" />
	<sql:param value="${emailAddress}" />
	<sql:param value="${ipAddress}" />
	<sql:param value="${styleCode}" />
	<sql:param value="${sessionId}" />
	<sql:param value="${status}" />
</sql:update>

<%-- Fetch the transaction id back from MySQL - and store in data --%>
<sql:query var="results">
SELECT transactionId AS tranId FROM aggregator.transaction_header ORDER BY transactionId DESC LIMIT 1;
</sql:query>
</sql:transaction>
<c:set var="tranId" value="${results.rows[0].tranId}" />
<go:log>Last tranid=${tranId}</go:log>

<go:setData dataVar="data" xpath="fuel/transactionId" value="${tranId}" />

<%-- Save the client values --%>
<c:forEach var="item" items="${param}" varStatus="status">

	<c:set var="xpath" value="${go:xpathFromName(item.key)}" />
	<sql:update>
 		INSERT INTO aggregator.transaction_details 
 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
		values ((?),(?),(?),(?),default,default);
		<sql:param value="${tranId}" />
		<sql:param value="${status.count}" />
		<sql:param value="${xpath}" />
		<sql:param value="${item.value}" />
	</sql:update>
</c:forEach>
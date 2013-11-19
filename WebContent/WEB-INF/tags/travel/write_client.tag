<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. TRAVEL)" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}" />
<c:set var="sessionId" 		value="${pageContext.session.id}" />
<c:set var="styleCode" 		value="CTM" />
<c:set var="status" 		value="" />

<c:choose>
	<c:when test="${not empty param.email}">
		<c:set var="emailAddress" value="${param.email}" />
	</c:when>
	<c:otherwise>
		<c:set var="emailAddress" value="" />
	</c:otherwise>
</c:choose>

<%-- Previous transaction id is the last one for this session --%>
	<sql:query var="results">
	SELECT max(TransactionId) AS previd, max(rootId) as rootId
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

<go:log>previousId: ${previousId }</go:log>
<%-- Write Transaction Header --%>
<sql:transaction>
	<c:choose>

		<c:when test="${param.initialSort == true}">
			<sql:update>
				UPDATE aggregator.transaction_header SET
				PreviousId = ?,
				ProductType = ?,
				emailAddress = ?,
				ipAddress = ?,
				startDate = CURRENT_DATE,
				startTime = CURRENT_TIME,
				styleCode = ?,
				advertKey = 0,
				sessionId = ?,
				status = ?,
				rootId = ?
				WHERE TransactionId = ?;
				<sql:param value="${previousId}" />
				<sql:param value="${productType}" />
				<sql:param value="${emailAddress}" />
				<sql:param value="${ipAddress}" />
				<sql:param value="${styleCode}" />
				<sql:param value="${sessionId}" />
				<sql:param value="${status}" />
				<sql:param value="${rootId}" />
				<sql:param value="${previousId}" />
			</sql:update>
		</c:when>
		<c:otherwise>
	<sql:update>
				INSERT into aggregator.transaction_header
				(TransactionId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCode,advertKey,sessionId,status,rootId)
				values (0,(?),(?),(?),(?),CURRENT_DATE,CURRENT_TIME,(?),0,(?),(?),(?));
				<sql:param value="${previousId}" />
				<sql:param value="${productType}" />
				<sql:param value="${emailAddress}" />
				<sql:param value="${ipAddress}" />
				<sql:param value="${styleCode}" />
				<sql:param value="${sessionId}" />
				<sql:param value="${status}" />
				<sql:param value="${rootId}" />
	</sql:update>
		</c:otherwise>
	</c:choose>
	
	<%-- Fetch the transaction id back from MySQL - and store in data --%>
	<sql:query var="results">
		SELECT LAST_INSERT_ID() AS tranId;
	</sql:query>
</sql:transaction>

<c:set var="tranId" value="${results.rows[0].tranId}" />
<go:log>Last tranid=${tranId}</go:log>

<go:setData dataVar="data" xpath="current/transactionId" value="${tranId}" />
<go:setData dataVar="data" xpath="travel/transactionId" value="${tranId}" />
<go:log>*** DELETING DATA FOR ${tranId}***</go:log>
<sql:update>
	DELETE FROM aggregator.transaction_details
	WHERE transactionId = '${tranId}' AND sequenceNo > 0;
</sql:update>
<go:log>+++ ADDING DATA FOR ${tranId} +++</go:log>
<%-- Save the client values --%>
<c:forEach var="item" items="${param}" varStatus="status">

	<c:set var="xpath" value="${go:xpathFromName(item.key)}" />
	<sql:update>
 		INSERT INTO aggregator.transaction_details 
 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
		values ( ?, ?, ?, ?, default, Now()	);
		<sql:param value="${tranId}" />
		<sql:param value="${status.count}" />
		<sql:param value="${xpath}" />
		<sql:param value="${item.value}" />
	</sql:update>
</c:forEach>
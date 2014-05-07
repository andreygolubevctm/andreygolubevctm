<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- #WHITELABEL styleCodeID --%>
<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="styleCode">${pageSettings.getBrandCode()}</c:set>


<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. TRAVEL)" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}" />
<c:set var="sessionId" 		value="${pageContext.session.id}" />

<c:set var="status" 		value="" />

<security:populateDataFromParams rootPath="travel" delete="false" />

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
				advertKey = 0,
				sessionId = ?,
				status = ?,
				rootId = ?
				WHERE TransactionId = ?;
				<sql:param value="${previousId}" />
				<sql:param value="${productType}" />
				<sql:param value="${emailAddress}" />
				<sql:param value="${ipAddress}" />
				<sql:param value="${sessionId}" />
				<sql:param value="${status}" />
				<sql:param value="${rootId}" />
				<sql:param value="${previousId}" />
			</sql:update>
		</c:when>
		<c:otherwise>
	<sql:update>
				INSERT into aggregator.transaction_header
				(TransactionId,styleCodeId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCodeId,styleCode,advertKey,sessionId,status,rootId)
				values (0,(?),(?),(?),(?),(?),CURRENT_DATE,CURRENT_TIME,(?),0,(?),(?),(?));
				<sql:param value="${styleCodeId}" />
				<sql:param value="${previousId}" />
				<sql:param value="${productType}" />
				<sql:param value="${emailAddress}" />
				<sql:param value="${ipAddress}" />
				<sql:param value="${styleCodeId}" />
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

<%-- Save the client values --%>
<c:import url="/WEB-INF/xslt/toxpaths.xsl" var="toXpathXSL" />
<c:set var="dataXpaths">
	<x:transform xslt="${toXpathXSL}" xml="${go:getXml(data[rootPath])}"/>
</c:set>
<c:forEach items="${dataXpaths.split('#~#')}" var="xpathAndVal" varStatus="status" >
	<c:set var="xpath" value="${fn:substringBefore(xpathAndVal,'=')}" />
	<c:set var="xpath" value="${fn:substringAfter(xpathAndVal,'/')}" />
	<c:set var="rowVal" value="${fn:substringAfter(xpathAndVal,'=')}" />
	<c:set var="rowVal" value="${go:unescapeXml(rowVal)}" />
	<sql:update>
 		INSERT INTO aggregator.transaction_details 
 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
		values ( ?, ?, ?, ?, default, Now()	);
		<sql:param value="${tranId}" />
		<sql:param value="${status.count}" />
		<sql:param value="${xpath}" />
		<sql:param value="${rowVal}" />
	</sql:update>
</c:forEach>
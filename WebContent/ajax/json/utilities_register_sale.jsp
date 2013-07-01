<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="utilities" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Load the params into data --%>
		<go:setData dataVar="data" xpath="utilities" value="*DELETE" />
		<go:setData dataVar="data" value="*PARAMS" />
		
		<go:setData dataVar="data" xpath="utilities/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="utilities/clientUserAgent" value="${clientUserAgent}" />
		
		<c:set var="dateof"><core:mysql_now /></c:set>
		<c:set var="dateof">${fn:substring(dateof, 0, 19)}</c:set>
		<go:setData dataVar="data" xpath="utilities/order/dateof" value="${dateof}" />
		
		<%-- Save client data --%>
		<agg:write_quote productType="UTILITIES" rootPath="utilities"/>
		<c:set var="receiveInfo">
			<c:choose>
				<c:when test="${empty data['utilities/application/thingsToKnow/receiveInfo']}">N</c:when>
				<c:otherwise>${data['utilities/application/thingsToKnow/receiveInfo']}</c:otherwise>
			</c:choose>
		</c:set>		
		<agg:write_email
			brand="CTM"
			vertical="UTILITIES"
			source="QUOTE"
			emailAddress="${data['utilities/application/details/email']}"
			firstName="${data['utilities/application/details/firstName']}"
			lastName="${data['utilities/application/details/lastName']}"
			items="marketing=${receiveInfo}" />
		
		<%-- Inject the order date into the transaction details --%>
		
		<sql:setDataSource dataSource="jdbc/aggregator"/>
		
		<c:catch var="error">
			<sql:query var="lastSN">
				SELECT Max(sequenceNo) AS lastSN 
				FROM aggregator.transaction_details 
				WHERE transactionId = ?;
				<sql:param>${data.current.transactionId}</sql:param>
			</sql:query>
		</c:catch>
		
		<c:if test="${empty error && lastSN.rowCount > 0}">
			<sql:update>
				INSERT INTO aggregator.transaction_details
				(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
				values (
					?, ?, ?, ?, default, Now()
				) ON DUPLICATE KEY UPDATE
					xpath = ?, textValue = ?;
				<sql:param>${data.current.transactionId}</sql:param>
				<sql:param>${lastSN.rows[0].lastSN + 1}</sql:param>
				<sql:param>utilities/order/dateof</sql:param>
				<sql:param>${dateof}</sql:param>
				<sql:param>utilities/order/dateof</sql:param>
				<sql:param>${dateof}</sql:param>
			</sql:update>
		</c:if>
	</c:when>
	<c:otherwise><%-- IGNORE GRACEFULLY --%></c:otherwise>
</c:choose>
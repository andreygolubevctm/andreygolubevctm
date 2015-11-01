<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.utilities_register_sale')}" />

<session:get settings="true" authenticated="true" verticalCode="UTILITIES" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/utilities_register_sale.jsp" quoteType="utilities" />
</c:if>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="utilities" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		${logger.debug('PROCEEDINATOR PASSED')}
		<%-- Load the params into data --%>

		<security:populateDataFromParams rootPath="utilities" />


		<%-- Some form fields get updated after the response from Switchwise so save quote (because can't write once confirmed). --%>
		<c:set var="write_quote"><agg:write_quote productType="UTILITIES" rootPath="utilities" /></c:set>
		<%-- Confirmation --%>
		<core:transaction touch="C" noResponse="true" />

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
		<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
		<c:set var="tranID" value="${data.current.transactionId}" />

		<sql:transaction>
			<c:catch var="error">
				<sql:query var="lastSN">
					SELECT Max(sequenceNo) AS lastSN
					FROM aggregator.transaction_details
					WHERE transactionId = ?;
					<sql:param>${tranID}</sql:param>
				</sql:query>
			</c:catch>

			<c:if test="${empty error && lastSN.rowCount > 0}">
				<sql:update>
					INSERT INTO aggregator.transaction_details
					(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
					VALUES (?, ?, ?, NOW(), default, NOW())
					ON DUPLICATE KEY UPDATE xpath = ?, textValue = NOW();
					<sql:param>${tranID}</sql:param>
					<sql:param>${lastSN.rows[0].lastSN + 1}</sql:param>
					<sql:param>utilities/order/dateof</sql:param>
					<sql:param>utilities/order/dateof</sql:param>
				</sql:update>
			</c:if>
		</sql:transaction>
	</c:when>
	<c:otherwise><%-- IGNORE GRACEFULLY --%></c:otherwise>
</c:choose>
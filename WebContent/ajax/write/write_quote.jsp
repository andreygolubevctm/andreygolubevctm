<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_new:no_cache_header/>

<session:get settings="true" authenticated="true" />

<c:set var="errorPool" value="" />

<c:set var="quoteType" value="${fn:toLowerCase(param.quoteType)}" />

<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="source" value="QUOTE" />
<c:set var="vertical" value="${fn:toLowerCase(quoteType)}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log source="write_quote_jsp">WRITE QUOTE PROCEEDINATOR PASSED</go:log>

		<sql:setDataSource dataSource="jdbc/aggregator"/>

		<c:set var="sessionid" value="${pageContext.session.id}" />
		<%-- AGG-1521 changed from to pageContext.request.remoteAddr to sessionScope set by core:client_ip --%>
		<c:set var="ipaddress" value="${sessionScope.userIP}" />
		<c:set var="stylecode" value="${pageSettings.getBrandCode()}" />
		<c:set var="status" value="" />
		<c:set var="prodtyp" value="${quoteType} ${quoteType}" />

		<%-- Ensure the current transactionID is set --%>
		<go:log source="write_quote_jsp">write quote getTransactionId ${data.current.verticalCode}</go:log>
		<c:set var="sandpit">
			<core:get_transaction_id id_handler="preserve_tranId" quoteType="${quoteType}" />
		</c:set>
		<c:set var="transID" value="${data.current.transactionId}" />

		<%-- Save form optin overrides the questionset (although all verticals
			should be forward/reverse update this value.  --%>
		<c:if test="${not empty param.save_marketing}">
			<c:set var="optinMarketing" value="marketing=${param.save_marketing}" />
		</c:if>

		<c:if test="${not empty emailAddress}">
			<go:log source="write_quote_jsp">Email: ${emailAddress}</go:log>
			<%-- Add/Update the user record in email_master --%>
			<c:catch var="error">
				<agg:write_email
					brand="${brand}"
					vertical="${vertical}"
					source="${source}"
					emailAddress="${emailAddress}"
					emailPassword=""
					firstName="${firstName}"
					lastName="${lastName}"
					items="${optinMarketing}${optinPhone}" />
			</c:catch>
			<go:log source="write_quote_jsp">ERROR: ${error}</go:log>

			<%--Update the transaction header record with the user current email address --%>

			<c:catch var="error">
				<sql:update var="result">
					UPDATE aggregator.transaction_header
					SET EmailAddress = ?
					WHERE TransactionId = ?;
					<sql:param value="${emailAddress}" />
					<sql:param value="${transID}" />
				</sql:update>
			</c:catch>
		</c:if>
		<%-- Test for DB issue and handle - otherwise move on --%>
		<c:if test="${not empty error}">
			<c:if test="${not empty errorPool}">
				<c:set var="errorPool">${errorPool},</c:set>
			</c:if>
			<go:log error="${error}" level="ERROR" source="write_quote_jsp">Failed to update transaction_header: ${error.rootCause}</go:log>
			<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
		</c:if>

		<%-- Write transaction details table --%>
		<c:if test="${vertical != 'travel' }">
			<security:populateDataFromParams rootPath="${vertical}" />
			<c:set var="write_quote"><agg:write_quote productType="${fn:toUpperCase(quoteType)}" rootPath="${vertical}" /></c:set>
			<c:if test="${not empty write_quote}">
				<c:if test="${not empty errorPool}">
					<c:set var="errorPool">${errorPool},</c:set>
		</c:if>
				<c:set var="errorPool">${errorPool}{"error":"${write_quote}"}</c:set>
			</c:if>
			<%-- LETO
			TODO Looks like vertical and quoteType are the same variable
			TODO New touch 'W', or all this stuff should be handled differently.
			<c:set var="outcome"><core:transaction vertical="${vertical}" touch="W" /></c:set>
			--%>
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="errorPool">{"error":"This quote has been reserved by another user. Please try again later."}</c:set>
	</c:otherwise>
</c:choose>

<%-- JSON RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		<go:log level="ERROR" source="write_quote_jsp">SAVE ERRORS: ${errorPool}</go:log>
		{"result":"FAIL", "errors":[${errorPool}]}
	</c:when>
	<c:otherwise>
		{"result":"OK","transactionId":"${transID}"}</c:otherwise>
</c:choose>
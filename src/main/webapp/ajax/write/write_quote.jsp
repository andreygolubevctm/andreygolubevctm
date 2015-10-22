<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.write_quote')}" />

<core_new:no_cache_header/>

<session:get settings="true" authenticated="true" verticalCode="${fn:toUpperCase(param.quoteType)}" />

<c:set var="errorPool" value="" />

<c:set var="quoteType" value="${fn:toLowerCase(param.quoteType)}" />

<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="source" value="QUOTE" />
<c:set var="vertical" value="${fn:toLowerCase(quoteType)}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" /></c:set>

<%-- Check if the save was triggered by session pop --%>
<c:if test="${not empty param.triggeredsave && param.triggeredsave == 'sessionpop'}">
	${sessionDataService.setShouldEndSession(pageContext.request, true)}
</c:if>

<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		${logger.debug('WRITE QUOTE PROCEEDINATOR PASSED')}

		<sql:setDataSource dataSource="jdbc/ctm"/>

		<c:set var="sessionid" value="${pageContext.session.id}" />
		<c:set var="stylecode" value="${pageSettings.getBrandCode()}" />
		<c:set var="status" value="" />
		<c:set var="prodtyp" value="${quoteType} ${quoteType}" />

		<%-- Ensure the current transactionID is set --%>
		${logger.debug('write quote getTransactionId. {}', log:kv('verticalCode',data.current.verticalCode ))}
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
			${logger.error('Error calling write_email. {},{},{},{}', log:kv('brand',brand ), log:kv('vertical',vertical ), log:kv('source',source ), log:kv('emailAddress',emailAddress ), error)}

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
			${logger.error('Failed to update transaction_header. {}', log:kv('emailAddress',emailAddress ), error)}
				<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
		</c:if>

		<%-- Write transaction details table --%>
		<c:if test="${vertical != 'travel' }">
			<c:choose>
				<c:when test="${vertical eq 'car'}">
					<security:populateDataFromParams rootPath="quote" />
				</c:when>
				<c:otherwise>
			<security:populateDataFromParams rootPath="${vertical}" />
				</c:otherwise>
			</c:choose>

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
		${logger.info('Returning errors to the browser', log:kv('errorPool', errorPool))}
		{"result":"FAIL", "errors":[${errorPool}]}
	</c:when>
	<c:otherwise>
		<c:set var="transactionIdResponse">{"result":"OK","transactionId":"${transID}"}</c:set>
		${sessionDataService.updateTokenWithNewTransactionIdResponse(pageContext.request, transactionIdResponse, transID)}
	</c:otherwise>
</c:choose>
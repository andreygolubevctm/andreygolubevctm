<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="confirmationId" required="true" rtexprvalue="true" description="The confirmation id"%>

<c:set var="isValid" value="false" />

<%-- Only proceed if we have a confirmation reference --%>
<c:if test="${not empty confirmationId}">
	<jsp:useBean id="applicationService" class="com.ctm.services.ApplicationService" scope="application" />
	<c:set var="styleCodeId" value="${applicationService.getBrandFromRequest(pageContext.getRequest()).getId()}" />
	<%-- Attempt to find in confirmations table --%>
	<sql:setDataSource dataSource="${datasource:getDataSource()}" />
	<c:catch var="error">
		<sql:query var="confirmationQuery">
				SELECT c.TransID As transaction_id, KeyID as key_id, XMLdata AS xml_data, LOWER(h.ProductType) AS vertical
				FROM ctm.confirmations AS c
				RIGHT JOIN aggregator.transaction_header AS h
					ON h.TransactionId = c.TransID
				WHERE KeyID = ?
				AND h.styleCodeId = ?
				LIMIT 1
				<sql:param value="${confirmationId}" />
			<sql:param value="${styleCodeId}" />
		</sql:query>
	</c:catch>
	<c:choose>
		<c:when test="${empty error and confirmationQuery.rowCount > 0}">
			<%-- Update settings now vertical is known. --%>
			<settings:setVertical verticalCode="${confirmationQuery.rows[0].vertical}" />
			<c:set var="transactionId" value="${confirmationQuery.rows[0].transaction_id}" />
			<c:set var="data" value="${sessionDataService.getDataForTransactionId(pageContext.getRequest(), transactionId, false)}" scope="request"  />
			<go:setData dataVar="data" xpath="current/transactionId" value="${confirmationQuery.rows[0].transaction_id}" />
			<c:set var="isValid" value="true" />
		</c:when>
		<c:when test="${not empty error}">
			<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
				<c:param name="page" value="${pageContext.request.servletPath}" />
				<c:param name="message" value="Error occured validating a confirmation page request." />
				<c:param name="description" value="${error}" />
				<c:param name="data" value="confirmation_ref=${confirmationId}" />
			</c:import>
		</c:when>
		<c:otherwise>
			<error:non_fatal_error origin="confirmation.jsp"
				errorMessage="Invalid confirmation ID received (${confirmationId})."
				errorCode="INVALID_CONFIRMATIONID" />
		</c:otherwise>
	</c:choose>
</c:if>
${isValid}
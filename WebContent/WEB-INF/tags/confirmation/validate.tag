<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="The root xpath" %>

<%-- VARIABLES --%>
<c:set var="redirect">${true}</c:set><%-- If valid confirmation request then this will be set to true later --%>
<c:set var="confirmation_ref" scope="request"><c:out value="${param.ConfirmationID}" escapeXml="true" /></c:set>
<c:set var="redirect_url">${pageSettings.getSetting('exitUrl')}</c:set>
<%-- To be populated later --%>
<c:set var="brand" scope="request" />
<c:set var="vertical" scope="request" />
<c:set var="transaction_id" scope="request" />
<c:set var="email_address" scope="request" /><%-- Is populated separately by the verticals confirmation_update tag --%>


<%-- This is a fix for HomeLMI as it is not using the confirmation table. See PRJHNC-48--%>
<c:choose>

	<c:when test="${param.vertical == 'homelmi' }">
		<c:set var="redirect">${false}</c:set>
	</c:when>

<c:otherwise>

<%-- Only proceed if we have a confirmation reference --%>
			<c:if test="${not empty confirmation_ref }">

				<%-- Attempt to find in confirmations table --%>
				<sql:setDataSource dataSource="jdbc/ctm"/>
				<c:catch var="error">
					<sql:query var="confirmationQuery">
						SELECT c.TransID As transaction_id, KeyID as key_id, XMLdata AS xml_data, h.StyleCodeId AS brand, LOWER(h.ProductType) AS vertical
						FROM ctm.confirmations AS c
						RIGHT JOIN aggregator.transaction_header AS h
							ON h.TransactionId = c.TransID
						WHERE KeyID = ?
						LIMIT 1
						<sql:param value="${confirmation_ref}" />
					</sql:query>
				</c:catch>



				<c:choose>
					<c:when test="${empty error and confirmationQuery.rowCount > 0}">
						<c:set var="brand" value="${confirmationQuery.rows[0].brand}" scope="request" />
						<c:set var="vertical" value="${confirmationQuery.rows[0].vertical}" scope="request" />
						<c:set var="transaction_id" value="${confirmationQuery.rows[0].transaction_id}" scope="request" />
						<c:set var="redirect">${false}</c:set>
					</c:when>
					<c:when test="${not empty error}">
						<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
							<c:param name="transactionId" value="${transactionId}" />
							<c:param name="page" value="${pageContext.request.servletPath}" />
							<c:param name="message" value="Error occured validating a confirmation page request." />
							<c:param name="description" value="${error}" />
							<c:param name="data" value="confirmation_ref=${confirmation_ref}" />
						</c:import>
					</c:when>
					<c:otherwise>
						<error:non_fatal_error origin="confirmation.jsp"
							errorMessage="Invalid confirmation ID received (${confirmation_ref})." errorCode="INVALID_CONFIRMATIONID"
						/>
					</c:otherwise>
				</c:choose>
			</c:if>
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${redirect eq true}">
		<c:redirect url="${redirect_url}" />
	</c:when>
	<c:otherwise>
		<jsp:doBody/>
	</c:otherwise>
</c:choose>
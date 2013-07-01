<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="errorPool" value="" />

<c:set var="quoteType" value="${fn:toLowerCase(param.quoteType)}" />

<c:set var="brand" value="CTM" />
<c:set var="source" value="QUOTE" />
<c:set var="vertical" value="${fn:toLowerCase(quoteType)}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>WRITE QUOTE PROCEEDINATOR PASSED</go:log>

		<sql:setDataSource dataSource="jdbc/aggregator"/>

		<c:set var="sessionid" value="${pageContext.session.id}" />
		<c:set var="ipaddress" value="${pageContext.request.remoteAddr}" />
		<c:set var="stylecode" value="CTM" />
		<c:set var="status" value="" />
		<c:set var="prodtyp" value="${quoteType}" />

		<%-- Ensure the current transactionID is set --%>
		<c:set var="sandpit">
			<c:import var="getTransactionID" url="/ajax/json/get_transactionid.jsp?id_handler=preserve_tranId" />
		</c:set>
		<c:set var="transID" value="${data.current.transactionId}" />

		<%-- Save form optin overrides the questionset (although all verticals
			should be forward/reverse update this value.  --%>
		<c:if test="${not empty param.save_marketing}">
			<c:set var="optinMarketing" value="marketing=${param.save_marketing}" />
		</c:if>

		<%-- Capture the essential fields to update email table --%>
		<c:choose>
			<c:when test="${quoteType eq 'car'}">
				<c:set var="emailAddress" value="${param.quote_contact_email}" />
				<c:set var="firstName" value="${param.quote_drivers_regular_firstname}" />
				<c:set var="lastName" value="${param.quote_drivers_regular_surname}" />
				<c:set var="optinPhone" value=",okToCall=${param.quote_contact_oktocall}" />
				<c:if test="${empty optinMarketing}">
					<c:set var="optinMarketing">
						<c:choose>
							<c:when test="${empty param.quote_contact_marketing}">marketing=N</c:when>
							<c:otherwise>marketing=${param.quote_contact_marketing}</c:otherwise>
						</c:choose>
					</c:set>
				</c:if>
			</c:when>
			<c:when test="${quoteType eq 'utilities'}">
				<c:set var="emailAddress">
					<c:choose>
						<c:when test="${not empty param.utilities_application_details_email}">${param.utilities_application_details_email}</c:when>
						<c:otherwise>${param.utilities_resultsDisplayed_email}</c:otherwise>
					</c:choose>
				</c:set>
				<c:set var="firstName" value="${param.utilities_application_details_firstName}" />
				<c:set var="lastName" value="${param.utilities_application_details_lastName}" />
				<c:set var="optinPhone" value="" />
				<c:if test="${empty optinMarketing}">
					<c:set var="optinMarketing">
						<c:choose>
							<c:when test="${empty param.utilities_application_thingsToKnow_receiveInfo}">marketing=N</c:when>
							<c:otherwise>marketing=${param.utilities_application_thingsToKnow_receiveInfo}</c:otherwise>
						</c:choose>
					</c:set>
				</c:if>
			</c:when>
			<c:when test="${quoteType eq 'life'}">
				<c:set var="emailAddress" value="${param.life_contactDetails_email}" />
				<c:set var="firstName" value="${param.life_details_primary_firstName}" />
				<c:set var="lastName" value="${param.life_details_primary_lastname}" />
				<c:set var="optinPhone" value=",okToCall=${param.life_contactDetails_call}" />
				<c:if test="${empty optinMarketing}">
					<c:set var="optinMarketing">
						<c:choose>
							<c:when test="${empty param.life_contactDetails_optIn}">marketing=N</c:when>
							<c:otherwise>marketing=${param.life_contactDetails_optIn}</c:otherwise>
						</c:choose>
					</c:set>
				</c:if>
			</c:when>
			<c:when test="${quoteType eq 'ip'}">
				<c:set var="emailAddress" value="${param.ip_contactDetails_email}" />
				<c:set var="firstName" value="${param.ip_details_primary_firstName}" />
				<c:set var="lastName" value="${param.ip_details_primary_lastname}" />
				<c:set var="optinPhone" value=",okToCall=${param.ip_contactDetails_call}" />
				<c:if test="${empty optinMarketing}">
					<c:set var="optinMarketing">
						<c:choose>
							<c:when test="${empty param.ip_contactDetails_optIn}">marketing=N</c:when>
							<c:otherwise>marketing=${param.ip_contactDetails_optIn}</c:otherwise>
						</c:choose>
					</c:set>
				</c:if>
			</c:when>
			<c:when test="${quoteType eq 'health'}">
				<c:set var="emailAddress">
					<c:choose>
						<c:when test="${not empty param.health_application_email}">${param.health_application_email}</c:when>
						<c:otherwise>${param.health_contactDetails_email}</c:otherwise>
					</c:choose>
				</c:set>
				<c:set var="firstName" value="${param.health_contactDetails_firstName}" />
				<c:set var="lastName" value="${param.health_contactDetails_lastname}" />
				<c:set var="optinPhone" value=",okToCall=${param.health_contactDetails_call}" />
				<c:if test="${empty optinMarketing}">
					<c:set var="optinMarketing">
						<c:choose>
							<c:when test="${empty param.health_application_optInEmail}">marketing=N</c:when>
							<c:otherwise>marketing=${param.health_application_optInEmail}</c:otherwise>
						</c:choose>
					</c:set>
				</c:if>
			</c:when>
			<c:when test="${quoteType eq 'travel'}">
				<c:set var="emailAddress" value="${param.travel_email}" />
				<c:set var="firstName" value="${param.travel_firstName}" />
				<c:set var="lastName" value="${param.travel_surname}" />
				<c:set var="optinPhone" value="" />
				<c:set var="optinMarketing">
					<c:choose>
						<c:when test="${empty param.travel_marketing}">marketing=N</c:when>
						<c:otherwise>marketing=${param.travel_marketing}</c:otherwise>
					</c:choose>
				</c:set>
			</c:when>
			<c:otherwise>
				<c:set var="firstName" value="" />
				<c:set var="lastName" value="" />
				<c:set var="optinPhone" value="" />
				<c:set var="optinMarketing" value="" />
			</c:otherwise>
		</c:choose>

		<c:if test="${not empty emailAddress}">
			<go:log>Email: ${emailAddress}</go:log>
			<%-- Add/Update the user record in email_master --%>
			<c:catch var="error">




				<%-- AB:13-06-13 Waiting for new Email database
				<agg:write_email
					emailSource="HEALTH"
					emailAddress="${data.health.application.email}"
					firstName="${data.health.application.primary.firstName}"
					lastName="${data.health.application.primary.surname}"
					items="marketing=${marketing},okToCall=${data.health.contactDetails.call}" />
				--%>


				<%-- AB:13-06-13 Waiting for new Email database --%>
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
			<go:log>ERROR: ${error}</go:log>

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
			<go:log>Failed to update transaction_header: ${error.rootCause}</go:log>
			<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
		</c:if><%-- Save the client values --%>

		<%-- Write transaction details table --%>
		<c:if test="${vertical != 'travel' }">
			<agg:write_quote productType="${fn:toUpperCase(quoteType)}" rootPath="${quoteType}" />
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="errorPool">{"error":"This quote has been reserved by another user. Please try again later." />"}</c:set>
	</c:otherwise>
</c:choose>

<%-- JSON RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		<go:log>SAVE ERRORS: ${errorPool}</go:log>
		{[${errorPool}]}
	</c:when>
	<c:otherwise>
		{"result":"OK","transactionId":"${transID}"}</c:otherwise>
</c:choose>
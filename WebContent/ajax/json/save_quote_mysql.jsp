<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="errorPool" value="" /> 

<c:set var="quoteType" value="${param.quoteType}" />
<c:set var="brand" value="${fn:toUpperCase(param.brand)}" />
<c:set var="vertical" value="${param.vertical}" />

<c:set var="optinMarketing">
	<c:choose>
		<c:when test="${not empty param.save_marketing}">${param.save_marketing}</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>
<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<sql:setDataSource dataSource="jdbc/aggregator"/>
		
		<c:set var="sessionid" value="${pageContext.session.id}" />
		<c:set var="ipaddress" value="${pageContext.request.remoteAddr}" />
		<c:set var="stylecode" value="CTM" />
		<c:set var="status" value="" />
		<c:set var="prodtyp" value="${quoteType}" />
		<c:set var="source">
			<c:choose>
				<c:when test="${not empty param.emailCode}">${param.emailCode}</c:when>
				<c:otherwise>SAVE_QUOTE</c:otherwise>
			</c:choose>
		</c:set>

		<%-- Capture the first/last name fields to update email table --%>
		<c:choose>
			<c:when test="${quoteType eq 'car'}">
				<c:set var="firstName" value="${param.quote_drivers_regular_firstname}" />
				<c:set var="lastName" value="${param.quote_drivers_regular_surname}" />
				<c:set var="optinPhone" value=",okToCall=${param.quote_contact_oktocall}" />
			</c:when>
			<c:when test="${quoteType eq 'utilities'}">
				<c:set var="firstName" value="${param.utilities_application_details_firstName}" />
				<c:set var="lastName" value="${param.utilities_application_details_lastName}" />
				<c:set var="optinPhone" value="" />
			</c:when>
			<c:when test="${quoteType eq 'life'}">
				<c:set var="firstName" value="${param.life_details_primary_firstName}" />
				<c:set var="lastName" value="${param.life_details_primary_lastname}" />
				<c:set var="optinPhone" value=",okToCall=${param.life_contactDetails_call}" />
			</c:when>
			<c:when test="${quoteType eq 'ip'}">
				<c:set var="firstName" value="${param.ip_details_primary_firstName}" />
				<c:set var="lastName" value="${param.ip_details_primary_lastname}" />
				<c:set var="optinPhone" value=",okToCall=${param.ip_contactDetails_call}" />
			</c:when>
			<c:when test="${quoteType eq 'health'}">
				<c:set var="firstName" value="${param.health_contactDetails_firstName}" />
				<c:set var="lastName" value="${param.health_contactDetails_lastname}" />
				<c:set var="optinPhone" value="${health_contactDetails_call}" />
			</c:when>
			<c:when test="${quoteType eq 'travel'}">
				<c:set var="firstName" value="${param.travel_firstName}" />
				<c:set var="lastName" value="${param.travel_surname}" />
				<c:set var="optinPhone" value="" />
			</c:when>
			<c:when test="${fn:contains(quoteType,'reminder')}">
				<c:set var="firstName" value="${param.first_name}" />
				<c:set var="lastName" value="${param.last_name}" />
				<c:set var="optinPhone" value="" />
			</c:when>
			<c:otherwise>
		<c:set var="firstName" value="" />
		<c:set var="lastName" value="" />
				<c:set var="optinPhone" value="" />
			</c:otherwise>
		</c:choose>

		
		
		<%-- Update email_master for ordinary users --%>
		<%-- Confirm we have the email address and password values  --%>
		<c:choose>
			<c:when test="${not empty param.save_password and param.save_password != ''}">
				<c:set var="emailAddress" value="${param.save_email}" />
				<c:set var="emailPassword" value="${param.save_password}" />
			</c:when>
			<c:when test="${not empty data.save.password}">
				<c:set var="emailAddress" value="${param.save_email}" />
				<c:set var="emailPassword" value="${data['save/password']}" />
			</c:when>
			<c:otherwise>
				<c:set var="emailAddress" value="" />

			</c:otherwise>
		</c:choose>
		
		<%--Add save_email to the data bucket --%>
		<go:setData dataVar="data" xpath="${quoteType}/sendEmail" value="${param.save_email}" />
		
		<go:log>SAVE QUOTE: Email: ${emailAddress}, Password: ${emailPassword}, Params: ${param}</go:log>
		
		<c:choose>
			<c:when test="${empty emailAddress or empty emailPassword}">
				<c:set var="errorPool">{"error":"Insufficient credentials received to save the quote."}</c:set>
			</c:when>
			<c:otherwise>
				<%-- Add/Update the user record in email_master --%>	
				<c:catch var="error">	
					<agg:write_email
						brand="${brand}"
						vertical="${vertical}"
						source="${source}"
						emailAddress="${emailAddress}"
						emailPassword="${emailPassword}"
						firstName="${firstName}"
						lastName="${lastName}"
						items="marketing=${optinMarketing}${optinPhone}" />
				</c:catch>
					 
				 <%-- Test for DB issue and handle - otherwise move on --%>
				<c:choose>
					<c:when test="${not empty error}">
						<c:if test="${not empty errorPool}">
							<c:set var="errorPool">${errorPool},</c:set>
						</c:if>
						<go:log>Failed to add/update email_master: ${error.rootCause}</go:log>
						<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
					</c:when>
					<c:otherwise>
					
						<%-- Ensure the current transactionID is set --%>
						<c:set var="sandpit">
							<c:import var="getTransactionID" url="get_transactionid.jsp?quoteType=${quoteType}&id_handler=preserve_tranId" />
						</c:set>
						<c:set var="transID" value="${data.current.transactionId}" />
						 		
				 		<%--Update the transaction header record with the user current email address --%>
				 		<c:if test="${not empty emailAddress}">
							<c:catch var="error">	
								<sql:update var="result">
									UPDATE aggregator.transaction_header 
									SET EmailAddress = ?
									WHERE TransactionId = ?;
									<sql:param value="${emailAddress}" />
									<sql:param value="${transID}" />
								</sql:update>
							</c:catch>
							 
							<%-- Test for DB issue and handle - otherwise move on --%>
							<c:if test="${not empty error}">
								<c:if test="${not empty errorPool}">
									<c:set var="errorPool">${errorPool},</c:set>
								</c:if>
								<go:log>Failed to update transaction_header: ${error.rootCause}</go:log>
								<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
							</c:if><%-- Save the client values --%>
						</c:if>
						
						<%-- Write transaction details table --%>
						<agg:write_quote productType="${fn:toUpperCase(quoteType)}" rootPath="${quoteType}" />
												
						<%-- Send off the Email response via json/send.jsp --%>
						<c:set var="emailResponse">
							<c:import url="send.jsp">
								<c:param name="mode" value="quote" />
							</c:import>
						</c:set>
						
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:set var="errorPool">{"error":"This quote has been reserved by another user. Please try again later."}</c:set>
	</c:otherwise>
</c:choose>

<%-- JSON RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		<go:log>SAVE ERRORS: ${errorPool}</go:log>
		{[${errorPool}]}
	</c:when>
	<c:otherwise>
		<c:set var="ignore_me"><core:access_touch quoteType="${quoteType}" type="S" transaction_id="${transID}" /></c:set>
		{"result":"OK","transactionId":"${transID}"}</c:otherwise>
</c:choose>
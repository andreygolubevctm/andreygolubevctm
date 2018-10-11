<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" scope="application" />

<c:set var="logger" value="${log:getLogger('tag.agg.write_quote')}" />

<jsp:useBean id="now" class="java.util.Date" scope="request" />
<jsp:useBean id="tranDao" class="com.ctm.web.core.transaction.dao.TransactionDetailsDao" scope="request" />

<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. TRAVEL)" %>
<%@ attribute name="rootPath" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ attribute name="triggeredsave" 			required="false" rtexprvalue="true"	 description="If not empty will insert sticky data into the transaction details" %>
<%@ attribute name="triggeredsavereason"	required="false" rtexprvalue="true"	 description="Optional reason for triggeredsave" %>
<%@ attribute name="source"					required="false" rtexprvalue="true"	 description="Where we are writing the quote from (ie. QUOTE, SIGNUP, SAVE_QUOTE, etc.)" %>
<%@ attribute name="dataObject"	required="false" rtexprvalue="true"	 description="Pass through a data object to use instead of params" %>

<c:choose>
	<c:when test="${rootPath eq 'car'}">
		<c:set var="rootPathData">quote</c:set>
	</c:when>
	<c:otherwise>
<c:set var="rootPathData">${rootPath}</c:set>
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${not empty dataObject}">
		<go:setData dataVar="data" xml="${dataObject}" />
	</c:when>
	<c:otherwise>
<security:populateDataFromParams rootPath="save" />
<security:populateDataFromParams rootPath="saved" />
	</c:otherwise>
</c:choose>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="source">
	<c:choose>
		<c:when test="${source eq 'SAVE_QUOTE'}">${source}</c:when>
		<c:otherwise>QUOTE</c:otherwise>
	</c:choose>
</c:set>

<c:set var="outcome"><core_v1:get_transaction_id quoteType="${rootPath}" id_handler="preserve_tranId" /></c:set>
<c:set var="transactionId" value="${data.current.transactionId}" />


<%-- Capture the Client IP and User Agent AGG-1439 for any vertical--%>
<go:setData dataVar="data" xpath="${rootPathData}/clientIpAddress" value="${ipAddressHandler.getIPAddress(pageContext.request)}" />
<go:setData dataVar="data" xpath="${rootPathData}/clientUserAgent" value='<%=request.getHeader("user-agent")%>' />


<c:set var="operator">
	<c:choose>
		<c:when test="${not empty authenticatedData.login.user.uid}">${authenticatedData.login.user.uid}</c:when>
		<c:otherwise>ONLINE</c:otherwise>
	</c:choose>
</c:set>

<%-- Flag to indicate whether user accepted privacy terms - value refined later per vertical --%>
<c:set var="hasPrivacyOptin">${false}</c:set>

<c:set var="optinParam" value="${rootPath}_callmeback_optin" /><%-- callmeback_save_phone --%>
<c:if test="${not empty param[optinParam] and param[optinParam] eq 'Y'}">
	<c:set var="optinPhone" value=",okToCall=${param[optinParam]}" />
</c:if>

<%-- Capture the essential fields to update email table --%>
<c:choose>
	<c:when test="${fn:contains(param.quoteType, 'reminder')}">
		<c:set var="emailAddress" value="${data['reminder/email']}" />
		<c:set var="firstName" value="${data['reminder/firstName']}" />
		<c:set var="lastName" value="${data['reminder/lastName']}" />
		<c:set var="optinPhone" value="" />
		<c:set var="optinMarketing">
			<c:choose>
				<c:when test="${empty data['reminder/marketing']}">marketing=N</c:when>
				<c:otherwise>marketing=${data['reminder/marketing']}</c:otherwise>
			</c:choose>
		</c:set>
	</c:when>
	<c:when test="${rootPath eq 'car'}">
		<c:if test="${not empty data['quote/privacyoptin'] and data['quote/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>
		<c:set var="emailAddress" value="${data['quote/contact/email']}" />
		<c:set var="firstName" value="${data['quote/drivers/regular/firstname']}" />
		<c:set var="lastName" value="${data['quote/drivers/regular/surname']}" />
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing">
				<c:if test="${not empty data['quote/contact/marketing']}">marketing=${data['quote/contact/marketing']}</c:if>
			</c:set>
		</c:if>
		<c:if test="${empty optinPhone}">
			<c:if test="${not empty data['quote/contact/oktocall']}">
				<c:set var="optinPhone" value="okToCall=${data['quote/contact/oktocall']}" />
				<c:if test="${not empty optinMarketing}">
					<c:set var="optinPhone" value=",${optinPhone}" />
				</c:if>
			</c:if>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'utilities'}">
		<c:if test="${not empty data['utilities/privacyoptin'] and data['utilities/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>

		<c:set var="emailAddress">
			<c:choose>
				<c:when test="${not empty data['utilities/application/details/email']}">${data['utilities/application/details/email']}</c:when>
				<c:otherwise>${data['utilities/resultsDisplayed/email']}</c:otherwise>
			</c:choose>
		</c:set>
		
		<c:set var="firstName">${data['utilities/application/details/firstName']}</c:set>

		<c:set var="lastName">${data['utilities/application/details/lastName']}</c:set>

		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value=",okToCall=${data['utilities/resultsDisplayed/optinPhone']}" />
		</c:if>

		<c:set var="step1Email" value="${data['utilities/resultsDisplayed/email']}"/>
		<c:set var="step3Email" value="${data['utilities/application/details/email']}"/>
				
		<c:set var="optinMarketing">
			<c:choose>
				<c:when test="${emailAddress eq step1Email}">
					<c:choose>
						<c:when test="${data['utilities/resultsDisplayed/optinMarketing'] eq 'Y'}">marketing=Y</c:when>
						<c:otherwise>marketing=N</c:otherwise>
					</c:choose>
				</c:when>
				<c:when test="${emailAddress eq step3Email}">
					<c:choose>
						<c:when test="${data['utilities/application/thingsToKnow/receiveInfo'] eq 'Y'}">marketing=Y</c:when>
						<c:otherwise>marketing=N</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>marketing=N</c:otherwise>
			</c:choose>
		</c:set>

	</c:when>
	<c:when test="${rootPath eq 'life'}">
		<c:if test="${not empty data['life/privacyoptin'] and data['life/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>
		<c:set var="emailAddress" value="${data['life/contactDetails/email']}" />
		<c:set var="firstName" value="${data['life/primary/firstName']}" />
		<c:set var="lastName" value="${data['life/primary/lastname']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value=",okToCall=${data['life/contactDetails/call']}" />
		</c:if>
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing">
				<c:choose>
					<c:when test="${empty data['life/contactDetails/optIn']}">marketing=N</c:when>
					<c:otherwise>marketing=${data['life/contactDetails/optIn']}</c:otherwise>
				</c:choose>
			</c:set>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'ip'}">
		<c:if test="${not empty data['ip/privacyoptin'] and data['ip/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>
		<c:set var="emailAddress" value="${data['ip/contactDetails/email']}" />
		<c:set var="firstName" value="${data['ip/primary/firstName']}" />
		<c:set var="lastName" value="${data['ip/primary/lastname']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value=",okToCall=${data['ip/contactDetails/call']}" />
		</c:if>
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing">
				<c:choose>
					<c:when test="${not empty data['ip/contactDetails/optIn']}">marketing=${data['ip/contactDetails/optIn']}</c:when>
					<c:otherwise>marketing=N</c:otherwise>
				</c:choose>
			</c:set>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'health'}">

		<c:if test="${not empty data['health/privacyoptin'] and data['health/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>

		<%-- Questionset Primary Email - contains the latest email entered via the questionset --%>
		<c:set var="qs_emailAddress">
			<c:if test="${not empty data['health/contactDetails/email']}">${data['health/contactDetails/email']}</c:if>
		</c:set>
		<c:set var="qs_optinEmailAddress">${data['health/contactDetails/optInEmail']}</c:set>

		<%-- Questionset Secondary Email - contains the previous email that was opted in via the questionset (we don't want it opted out) --%>
		<c:set var="qs_emailAddressSecondary">
			<c:if test="${not empty data['health/contactDetails/emailSecondary']}">${data['health/contactDetails/emailSecondary']}</c:if>
		</c:set>

		<%-- Questionset Email History - contains a list of old emails entered via the questionset which need to be opted out (we only maintain the last 2 emails entered) --%>
		<c:set var="qs_optOutEmailHistory">
			<c:if test="${not empty data['health/contactDetails/emailhistory']}">${data['health/contactDetails/emailhistory']}</c:if>
		</c:set>

		<%-- Questionset Phone Optins --%>
		<c:set var="qs_phoneOther">${data['health/contactDetails/contactNumber/other']}</c:set>
		<c:set var="qs_phoneMobile">${data['health/contactDetails/contactNumber/mobile']}</c:set>
		<c:set var="qs_okToCall">${data['health/contactDetails/call']}</c:set>

		<%-- Application Primary Email - contains the latest email entered via the application --%>
		<c:set var="app_emailAddress">
			<c:if test="${not empty data['health/application/email'] and data['health/contactDetails/email'] ne data['health/application/email']}">${data['health/application/email']}</c:if>
		</c:set>
		<c:set var="app_optinEmailAddress">
				<c:choose>
				<c:when test="${empty data['health/application/optInEmail']}">N</c:when>
				<c:otherwise>${data['health/application/optInEmail']}</c:otherwise>
				</c:choose>
			</c:set>

		<%-- Application Secondary Email - contains the previous email that was opted in via the application (we don't want it opted out) --%>
		<c:set var="app_emailAddressSecondary">
			<c:if test="${not empty data['health/application/emailSecondary']}">${data['health/application/emailSecondary']}</c:if>
		</c:set>

		<%-- Application Email History - contains a list of old emails entered via the application which need to be opted out (we only maintain the last 2 emails entered) --%>
		<c:set var="app_optOutEmailHistory">
			<c:if test="${not empty data['health/application/emailhistory']}">${data['health/application/emailhistory']}</c:if>
		</c:set>

		<%-- Application Phone Optins --%>
		<c:set var="app_phoneOther">
			<%-- ignore if same phone as questionset --%>
			<c:if test="${not empty data['health/application/other'] and data['health/application/other'] ne data['health/contactDetails/contactNumber/other']}">${data['health/application/other']}</c:if>
		</c:set>
		<c:set var="app_phoneMobile">
			<%-- ignore if same mobile as questionset --%>
			<c:if test="${not empty data['health/application/mobile'] and data['health/application/mobile'] ne data['health/contactDetails/contactNumber/mobile']}">${data['health/application/mobile']}</c:if>
		</c:set>
		<c:set var="app_okToCall">
				<c:choose>
				<c:when test="${empty data['health/application/call']}">N</c:when>
				<c:otherwise>${data['health/application/call']}</c:otherwise>
				</c:choose>
			</c:set>

		<%-- Assign firstname/lastname - use questionset otherwise application values --%>
		<c:set var="firstName" value="${data['health/contactDetails/name']}" />
		<c:set var="lastName" value="" />
		<c:if test="${not empty data['health/application/primary/firstname']}">
			<c:set var="firstName" value="${data['health/application/primary/firstname']}" />
			<c:set var="lastName" value="${data['health/application/primary/surname']}" />
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'travel'}">
		<c:if test="${not empty data['travel/privacyoptin'] and data['travel/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>
		<c:set var="emailAddress" value="${data['travel/email']}" />
		<c:set var="firstName" value="${data['travel/firstName']}" />
		<c:set var="lastName" value="${data['travel/surname']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value="" />
		</c:if>

		<c:set var="optinMarketing">
			<c:choose>
				<c:when test="${not empty data['travel/marketing']}">marketing=${data['travel/marketing']}</c:when>
				<c:otherwise>marketing=N</c:otherwise>
			</c:choose>
		</c:set>
	</c:when>
	<c:when test="${rootPath eq 'home'}">
		<c:if test="${not empty data['home/privacyoptin'] and data['home/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>
		<c:set var="emailAddress" value="${data['home/policyHolder/email']}" />
		<c:set var="firstName" value="${data['home/policyHolder/firstName']}" />
		<c:set var="lastName" value="${data['home/policyHolder/lastName']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value=",okToCall=${data['home/policyHolder/oktocall']}" />
		</c:if>
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing" value ="marketing=${data['home/policyHolder/marketing']}"/>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'homeloan'}">
		<c:if test="${not empty data['homeloan/privacyoptin'] and data['homeloan/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>

		<c:set var="emailAddress">
			<c:choose>
				<c:when test="${not empty data['homeloan/enquiry/contact/email']}">${data['homeloan/enquiry/contact/email']}</c:when>
				<c:otherwise>${data['homeloan/contact/email']}</c:otherwise>
			</c:choose>
		</c:set>

		<c:set var="firstName" value="${data['homeloan/contact/firstName']}" />
		<c:set var="lastName" value="${data['homeloan/contact/lastName']}" />
		<c:if test="${not empty data['homeloan/contact/contactNumber']}">
			<c:set var="optinPhone" value=",okToCall=Y" />
		</c:if>
		<c:if test="${not empty data['homeloan/contact/optIn']}">
			<c:set var="optinMarketing" value ="marketing=${data['homeloan/contact/optIn']}"/>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'creditcard'}">
		<c:if test="${not empty data['creditcard/privacyoptin'] and data['creditcard/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>

		<c:set var="emailAddress" value="${data['creditcard/email']}" />

		<c:set var="firstName" value="${data['creditcard/name']}" />
		<c:set var="lastName" value="" />
		<c:if test="${not empty data['creditcard/marketing']}">
			<c:set var="optinMarketing" value ="marketing=${data['creditcard/marketing']}" />
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'competition'}">
		<c:if test="${not empty data['competition/privacyoptin'] and data['competition/privacyoptin'] eq 'Y'}">
			<c:set var="hasPrivacyOptin">${true}</c:set>
		</c:if>
		<c:set var="emailAddress" value="${data['competition/email']}" />
		<c:set var="firstName" value="${data['competition/firstName']}" />
		<c:set var="lastName" value="${data['competition/lastName']}" />
		<c:if test="${not empty data['competition/optIn']}">
			<c:set var="optinMarketing" value ="marketing=${data['competition/marketing']}"/>
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="firstName" value="" />
		<c:set var="lastName" value="" />
		<c:set var="optinPhone" value="" />
		<c:set var="optinMarketing" value="" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${not empty data['save/email']}">
		<c:set var="emailAddressHeader" value="${data['save/email']}" />
		<c:set var="emailAddress" value="${data['save/email']}" />
		<%-- Save form optin overrides the questionset  --%>
		<c:if test="${not empty data['save/marketing'] && data['save/marketing'] == 'Y'}">
			<c:set var="optinMarketing" value="marketing=Y" />
		</c:if>
	</c:when>
	<c:when test="${not empty data['saved/email']}">
		<c:set var="emailAddressHeader" value="${data['saved/email']}" />
		<%-- Save form optin overrides the questionset  --%>
		<c:if test="${(not empty data['saved/marketing']) && (data['saved/marketing'] == 'Y') && (data['saved/email'] == emailAddress)}">
			<c:set var="optinMarketing" value="marketing=Y" />
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="emailAddressHeader" value="${emailAddress}" />
	</c:otherwise>
</c:choose>

<%--Don't override if already opted in--%>
<c:if test="${not empty data['userData/optInMarketing'] and data['userData/optInMarketing'] and (data['userData/emailAddress'] == emailAddress)}">
	<c:if test="">
		<c:set var="optinMarketing" value="marketing=Y" />
	</c:if>
</c:if>

<%-- Check if transaction is confirmed or pending --%>
<sql:query var="confirmationQuery">
	SELECT COALESCE(t1.type,t2.type,1) AS editable FROM ctm.touches t0
	LEFT JOIN ctm.touches t1 ON t0.transaction_id = t1.transaction_id AND t1.type = 'C'
	LEFT JOIN ctm.touches t2 ON t0.transaction_id = t2.transaction_id AND t2.type = 'F'
	WHERE t0.transaction_id = ?
	LIMIT 1
	<sql:param value="${transactionId}" />
</sql:query>
<%-- confirmationResult will be empty string if safe to write to --%>
<c:set var="confirmationResult">
	<c:choose>
		<c:when test="${confirmationQuery.rowCount == 0}"></c:when>
		<%-- If transaction is Failed/Pending (F), only call centre can edit the transaction --%>
		<c:when test="${confirmationQuery.rows[0]['editable'] == 'F' and operator != 'ONLINE'}"></c:when>
		<c:when test="${confirmationQuery.rows[0]['editable'] == 'C'}">C</c:when>
	</c:choose>
</c:set>

<c:if test="${confirmationResult == ''}">
	<c:choose>
		<c:when test="${hasPrivacyOptin eq true and rootPath ne 'health' and not empty emailAddress}">
	<%-- Add/Update the user record in email_master --%>
	<c:catch var="error">
		<agg_v1:write_email
			brand="${brand}"
			vertical="${rootPath}"
			source="${source}"
			emailAddress="${emailAddress}"
			firstName="${firstName}"
			lastName="${lastName}"
			items="${optinMarketing}${optinPhone}" />
	</c:catch>
		</c:when>
		<c:when test="${hasPrivacyOptin eq true and rootPath eq 'health'}">
			<jsp:useBean id="userDetails" class="com.ctm.web.health.model.request.UserDetails" scope="page" />
			${userDetails.setFirstname(firstName)}
			${userDetails.setLastname(lastName)}
			${userDetails.setRootPath(rootPath)}
			${userDetails.questionSet.setEmailAddress(qs_emailAddress)}
			${userDetails.questionSet.setOptinEmailAddress(qs_optinEmailAddress)}
			${userDetails.questionSet.setEmailAddressSecondary(qs_emailAddressSecondary)}
			${userDetails.questionSet.setOptOutEmailHistory(qs_optOutEmailHistory)}
			${userDetails.questionSet.setPhoneOther(qs_phoneOther)}
			${userDetails.questionSet.setPhoneMobile(qs_phoneMobile)}
			${userDetails.questionSet.setOkToCall(qs_okToCall)}
			${userDetails.application.setEmailAddress(app_emailAddress)}
			${userDetails.application.setOptinEmailAddress(app_optinEmailAddress)}
			${userDetails.application.setEmailAddressSecondary(app_emailAddressSecondary)}
			${userDetails.application.setOptOutEmailHistory(app_optOutEmailHistory)}
			${userDetails.application.setPhoneOther(app_phoneOther)}
			${userDetails.application.setPhoneMobile(app_phoneMobile)}
			${userDetails.application.setOkToCall(app_okToCall)}
			<health_v1:write_optins
				userDetails = "${userDetails}"
			/>
		</c:when>
		<c:otherwise><%-- ignore --%></c:otherwise>
	</c:choose>
</c:if>

<c:if test="${hasPrivacyOptin eq true and confirmationResult == '' && not empty emailAddressHeader}">
	<%-- Update the transaction header record with the user current email address --%>
	<c:catch var="error">

		<%-- TODO Add emailId to transaction_header --%>
		<sql:update var="result">
			UPDATE aggregator.transaction_header
			SET EmailAddress = ?
			WHERE TransactionId = ?;
			<sql:param value="${emailAddressHeader}" />
			<sql:param value="${transactionId}" />
		</sql:update>
	</c:catch>
</c:if>

<c:if test="${hasPrivacyOptin eq true and rootPath eq 'health'}">
	<jsp:useBean id="leadService" class="com.ctm.web.health.services.HealthLeadService" scope="request" />

	<c:choose>
		<%-- If transaction is Failed/Pending (F), only call centre can edit the transaction --%>
		<c:when test="${confirmationQuery.rows[0]['editable'] == 'F'}">
			${leadService.sendLead(4, data, pageContext.getRequest(), 'PENDING', brand )}
		</c:when>
		<c:when test="${confirmationQuery.rows[0]['editable'] == 'C'}">
			${leadService.sendLead(4, data, pageContext.getRequest(), 'SOLD', brand)}
		</c:when>
		<c:when test="${not empty data['health/simples/contactType'] && data['health/simples/contactType'] == 'inbound'}">
			<%-- Consultant has flagged this transaction as an inbound call --%>
			${leadService.sendLead(4, data, pageContext.getRequest(), 'INBOUND_CALL', brand)}
		</c:when>
		<c:when test="${not empty data['health/simples/contactType'] && data['health/simples/contactType'] == 'cli'}">
			<%-- Consultant has flagged this transaction as an return cli --%>
			${leadService.sendLead(4, data, pageContext.getRequest(), 'RETURN_CLI', brand)}
		</c:when>
		<c:otherwise>
			${leadService.sendLead(4, data, pageContext.getRequest(), 'OPEN', brand)}
		</c:otherwise>
	</c:choose>
</c:if>

<%-- Test for DB issue and handle - otherwise move on --%>
<c:if test="${not empty error}">
	<c:if test="${not empty errorPool}">
		<c:set var="errorPool">${errorPool},</c:set>
	</c:if>
	${logger.error('Failed to update transaction_header. {}' , log:kv('transactionId',transactionId ), error)}
	<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
		<c:param name="transactionId" value="${transactionId}" />
		<c:param name="page" value="${pageContext.request.servletPath}" />
		<c:param name="message" value="agg:write_quote optin/email" />
		<c:param name="description" value="${error}" />
		<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
	</c:import>
	<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
</c:if>

<c:choose>
<%-- Do not write quote if this quote is already confirmed/finished --%>
	<c:when test="${confirmationResult == '' && transactionId.matches('^[0-9]+$') }">
		<c:catch var="error">
			<sql:transaction>
				<jsp:useBean id="insertParams" class="java.util.ArrayList" scope="request" />
				<c:set var="sandbox">${insertParams.clear()}</c:set>
				<c:set var="insertSQLSB" value="${go:getStringBuilder()}" />
				${go:appendString(insertSQLSB ,'INSERT INTO aggregator.transaction_details (transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) VALUES ')}

				<%-- Add sticky content to transaction details for triggered saves (Kampyle, SessionPop or FatalError) --%>
				<c:if test="${not empty param.triggeredsave or not empty triggeredsave}">
					<c:choose>
						<c:when test="${not empty triggeredsave}"><c:set var="trigger" value="${triggeredsave}" /></c:when>
						<c:otherwise><c:set var="trigger" value="${param.triggeredsave}" /></c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${not empty triggeredsavereason}"><c:set var="triggerreason" value="${triggeredsavereason}" /></c:when>
						<c:when test="${not empty param.triggeredsavereason}"><c:set var="triggerreason" value="${param.triggeredsavereason}" /></c:when>
					</c:choose>
					<c:set var="useragent" value="${header['User-Agent']}" scope="session"/>
					<c:if test="${not empty data[rootPathData].pendingID}">
						<c:set var="pendingID" value="${data[rootPathData].pendingID}" />
						<go:setData dataVar="data" xpath="${rootPathData}/pendingID" value="*DELETE" />
					</c:if>

					<%--
						-1 is reserved for confirmationCode/confirmationEmailCode
						-2 is reserved for policyNo
					--%>
					<c:if test="${not empty param.stage}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-3</sql:param>
							<sql:param>stage</sql:param>
							<sql:param>${param.stage}</sql:param>
						</sql:update>
					</c:if>
					<c:if test="${not empty useragent}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-4</sql:param>
							<sql:param>useragent</sql:param>
							<sql:param>${fn:substring(useragent, 0, 1000)}</sql:param>
						</sql:update>
					</c:if>
					<c:if test="${not empty trigger}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-5</sql:param>
							<sql:param>${trigger}</sql:param>
							<sql:param>${now}</sql:param>
						</sql:update>
					</c:if>
					<c:if test="${not empty triggerreason}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-6</sql:param>
							<sql:param>fatalerrorreason</sql:param>
							<sql:param>${fn:substring(triggerreason, 0, 1000)}</sql:param>
						</sql:update>
					</c:if>
					<c:if test="${not empty pendingID}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-7</sql:param>
							<sql:param>pendingID</sql:param>
							<sql:param>${pendingID}</sql:param>
						</sql:update>
					</c:if>
				</c:if>
				<%-- END STICKY CONTENT --%>

				<c:import url="/WEB-INF/xslt/toxpaths.xsl" var="toXpathXSL" />
				<c:set var="dataXpaths">
					<c:if test="${not empty data and not empty data[rootPathData]}">
					<x:transform xslt="${toXpathXSL}" xml="${go:getEscapedXml(data[rootPathData])}"/>
					<c:if test="${data['save'].size() > 0}"><x:transform xslt="${toXpathXSL}" xml="${go:getEscapedXml(data['save'])}"/></c:if>
					<c:if test="${data['saved'].size() > 0}"><x:transform xslt="${toXpathXSL}" xml="${go:getEscapedXml(data['saved'])}"/></c:if>
					<c:if test="${data['reminder'].size() > 0}"><x:transform xslt="${toXpathXSL}" xml="${go:getEscapedXml(data['reminder'])}"/></c:if>
					</c:if>
				</c:set>

				<c:choose>
					<%-- Only proceed if the transforms above have been successful --%>
					<c:when test="${not empty dataXpaths}">
						<c:set var="counter" value="0" />
						<c:forEach items="${dataXpaths.split('#~#')}" var="xpathAndVal" varStatus="status" >
							<c:set var="xpath" value="${fn:substringBefore(xpathAndVal,'=')}" />
							<c:set var="xpath" value="${fn:substringAfter(xpath,'/')}" />
							<c:set var="rowVal" value="${fn:substringAfter(xpathAndVal,'=')}" />
							<c:set var="rowVal" value="${go:unescapeXml(rowVal)}" />

							<%-- Cap the value to a certain length so we don't get database errors --%>
							<c:if test="${fn:length(rowVal) > 1000}"><c:set var="rowVal" value="${fn:substring(rowVal, 0, 1000)}" /></c:if>

							<c:choose>

								<%-- Ignore empty values first and foremost --%>
								<c:when test="${empty fn:trim(rowVal)}"></c:when>

								<%-- Ignore if field is blacklisted --%>
								<c:when test="${tranDao.isBlacklisted(xpath) eq true}"></c:when>
								<%-- Ignore if no privacy optin and is privacy optin dependant --%>
								<c:when test="${hasPrivacyOptin eq false and tranDao.isPersonallyIdentifiableInfo(xpath) eq true}"></c:when>

								<%-- Misc other fields/values to ignore --%>
								<c:when test="${fn:startsWith(rowVal, 'Please choose')}"></c:when>
								<c:when test="${fn:startsWith(rowVal, 'ignoreme')}"></c:when>
								<c:when test="${xpath=='/operatorid'}"></c:when>
								<c:when test="${fn:contains(rootPath,'frontend') and fn:contains(item.value,'json')}"></c:when>
								<c:when test="${fn:contains(rootPath,'frontend') and xpath == '/'}"></c:when>
								<c:when test="${fn:contains(rootPath,'frontend') and fn:contains(xpath,'sendConfirm')}"></c:when>

								<%-- Otherwise we're good to write --%>
								<c:otherwise>
									<c:set var="counter" value="${counter + 1}" />
									${go:appendString(insertSQLSB ,prefix)}
									<c:set var="prefix" value="," />
									${go:appendString(insertSQLSB , '(')}
									${go:appendString(insertSQLSB , transactionId)}
									${go:appendString(insertSQLSB , ', ?, ?, ?, default, Now()) ')}

									<%-- To avoid truncation errors we'll limit textValue to 1000 chars but will add an error log entry so can track --%>
									<c:set var="textValue" value="${tranDao.encryptBlacklistFields(transactionId, xpath, rowVal)}" />
									<c:if test="${fn:length(textValue) > 1000}">
										<c:set var="errorStr" value="Data Truncated - xpath (${xpath}) has textValue longer than 1000 chars: ${textValue}" />
										${logger.error(errorStr)}
										<c:set var="textValue" value="${fn:substring(textValue,0,1000)}" />
									</c:if>

									<c:set var="ignore">
										${insertParams.add(counter)};
										${insertParams.add(xpath)};
										${insertParams.add(textValue)};
									</c:set>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<c:if test="${not empty authenticatedData['login/user/uid']}">
							<c:set var="operatorIdXpath" value="${rootPath}/operatorId" />
							${go:appendString(insertSQLSB ,prefix)}
							${go:appendString(insertSQLSB , '(')}
							${go:appendString(insertSQLSB , transactionId)}
							${go:appendString(insertSQLSB , ', ?, ?, ?, default, Now()) ')}
							<c:set var="counter" value="${counter + 1}" />
							<c:set var="ignore">
								${insertParams.add(counter)};
								${insertParams.add(operatorIdXpath)};
								${insertParams.add(authenticatedData.login.user.uid)};
							</c:set>
						</c:if>
						${go:appendString(insertSQLSB ,'ON DUPLICATE KEY UPDATE xpath=VALUES(xpath), textValue=VALUES(textValue), dateValue=VALUES(dateValue); ')}
						<%--
							300 and up is the range for custom entered data that doesn't come from params
						--%>
						<c:if test="${insertParams.size() > 0}">
							<sql:update sql="${insertSQLSB.toString()}">
								<c:forEach var="item" items="${insertParams}">
									<sql:param value="${item}" />
								</c:forEach>
							</sql:update>
							<c:choose>
								<c:when test="${rootPath eq 'health'}">
									<sql:update>
										DELETE FROM aggregator.transaction_details
										WHERE transactionId = ${transactionId}
										AND sequenceNo > ${counter};
									</sql:update>
								</c:when>
								<c:otherwise>
									<sql:update>
										DELETE FROM aggregator.transaction_details

															WHERE transactionId = ${transactionId}
										AND sequenceNo > ${counter}
										AND sequenceNo < 300;
									</sql:update>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:when>
					<c:otherwise>
						${logger.error('WRITE_QUOTE FAILED.', error)}
						<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
							<c:param name="transactionId" value="${transactionId}" />
							<c:param name="page" value="${pageContext.request.servletPath}" />
							<c:param name="message" value="agg:write_quote could not determine dataXpaths" />
							<c:param name="description" value="Could not set dataXpaths as either data or data[${rootPathData}] was empty." />
							<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
						</c:import>
						FAILED: A fatal database error occurred - we hope to resolve this soon.
					</c:otherwise>
				</c:choose>
			</sql:transaction>
		</c:catch>
		<c:if test="${not empty error}">
			${logger.error('Write quote failed. {}', error)}
			<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
				<c:param name="transactionId" value="${transactionId}" />
				<c:param name="page" value="${pageContext.request.servletPath}" />
				<c:param name="message" value="agg:write_quote insert transaction details" />
				<c:param name="description" value="${error}" />
				<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
			</c:import>
			FAILED: A fatal database error occurred - we hope to resolve this soon.
		</c:if>

	</c:when>
	<c:when test="${empty transactionId}">
		${logger.info('write_quote: No transaction ID.')}
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="transactionId" value="${transactionId}" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="agg:write_quote confirmationResult" />
			<c:param name="description" value="No transaction ID." />
			<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
		</c:import>
		FAILED: No transaction ID.
	</c:when>
	<c:when test="${confirmationResult == 'F'}">
		${logger.info('write_quote: No because pending/failed')}
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="transactionId" value="${transactionId}" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="agg:write_quote confirmationResult" />
			<c:param name="description" value="Quote is pending/failed and operator=ONLINE" />
			<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
		</c:import>
		FAILED: Quote is pending/failed and operator=ONLINE.
	</c:when>
	<c:otherwise>
		${logger.info('write_quote: No because this quote is already confirmed.')}
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="transactionId" value="${transactionId}" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="agg:write_quote confirmationResult" />
			<c:param name="description" value="This quote is confirmed." />
			<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
		</c:import>
		FAILED: This quote is confirmed.
	</c:otherwise>
</c:choose>
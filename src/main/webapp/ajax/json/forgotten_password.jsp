<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<jsp:useBean id="authenticationService" class="com.ctm.services.AuthenticationService" scope="application" />
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.forgotten_password')}" />

<settings:setVertical verticalCode="GENERIC" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%--
	forgotten_password.jsp

	Calls the iSeries program NTAGGPRS which will send an email to the client containing a link that
	allows then to reset their password.
	The link is only active for around 30 minutes (or whatever the timeout is set to)

	@param email - The client's email address
--%>
<c:choose>
	<c:when test="${not empty param.email}">

		<%--
			From the outside looking in, it seems like disc currently makes a token IN THIS FILE and sends the email regardless. It must also go and look up the mysql database to see if one exists there too.

			Once we're in the /generic/reset_password.json, we'll send the token to disc again, and if it finds it in disc will handle it there... otherwise we'll get an error xml node back from disc and it contains the persons email address matching the token that disc created earlier, and we then overwrite the password on the mysql side. Disc is the lookup point to return the email address for a token, so this token creation, mailout, and then lookup before reset needs to be developed on our side now for the mysql setup.
		--%>

		<%-- Check email on MySQL --%> <%-- This seems like it's only to say, OK to the ajax request... we don't actually take any action to email or create a token here. I'm changing this now. --%>

		<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
		<sql:query var="emailMasterRecord">
			SELECT emailId, transactionId
			    FROM aggregator.email_master
			    WHERE emailAddress = ?
			    AND styleCodeId = ?
			    LIMIT 1;
			<sql:param><c:out value="${param.email}" escapeXml="true" /></sql:param>
			<sql:param value="${styleCodeId}" />
		</sql:query>
		<c:choose>
			<c:when test="${not empty(emailMasterRecord) and emailMasterRecord.rowCount == 1}">
				${logger.debug('Reset Email: MYSQL - Found! - Sending now...')}
				<%-- Send off the Email response via dreammail/send.jsp instead of json/ajax/send.jsp. Everything here is sufficient. --%>
				<c:catch var="error">
					<%-- Dial into the send script --%>
					<c:set var="token" value="${authenticationService.generateTokenForEmail(emailMasterRecord.rows[0].emailId,emailMasterRecord.rows[0].transactionId)}" />
					<c:set var="tokenUrl" value="${go:urlEncode(token)}" />

					<c:import url="${pageSettings.getSetting('sendUrl')}">
						<c:param name="Brand" value="${pageSettings.getBrandCode()}" />
						<%-- The mailout we're trying to do --%>
						<c:param name="MailingName" value="${pageSettings.getSetting('sendResetMailingName')}" />
						<c:param name="tmpl" value="${pageSettings.getSetting('sendResetTmpl')}" />

						<%-- The URL building details --%>
						<c:param name="baseURL" value="${pageSettings.getBaseUrl()}" />
						<c:param name="env" value="${pageSettings.getSetting('sendUrlEnv')}" />

						<%-- The URL building details --%>
						<c:param name="send" value="Y" />

						<c:param name="emailAddress" value="${param.email}" />

						<%-- This is new - the token for reset --%>
						<c:param name="token" value="${tokenUrl}" />

						<%-- Flag to not create email token --%>
						<c:param name="createUnsubscribeEmailToken" value="false" />
					</c:import>
				</c:catch>
				<c:if test="${error}">
					${logger.error('Reset Email Error. {}' , log:kv('param.email',param.email ) , error)}
				</c:if>
				${logger.debug('Reset Email: MYSQL - Code for send run.')}
				<%-- JSON result success --%>
				<json:object>
					<json:property name="result" value="OK"/>
				</json:object>
			</c:when>
			<c:otherwise>
				${logger.debug('Reset Email: Email Not Found')}
				<%-- JSON result failure --%>
				<json:object>
					<json:property name="result" value="INVALID_EMAIL"/>
					<json:property name="message" value="That email address was not found on file"/>
				</json:object>
			</c:otherwise>
		</c:choose>

	</c:when>
	<c:otherwise>
		<%-- JSON result failure --%>
		<json:object>
			<json:property name="result" value="MISSING_EMAIL"/>
			<json:property name="message" value="Did not receive an email address"/>
		</json:object>
	</c:otherwise>
</c:choose>

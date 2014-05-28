<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<jsp:useBean id="authenticationService" class="com.ctm.services.AuthenticationService" scope="application" />

<settings:setVertical verticalCode="GENERIC" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%--
	reset_password.jsp
	
	Calls iSeries program NTAGGPCF with the reset_id code (that was previously created by NTAGGPRS)
	and a new password.
	NTAGGPCF will return either a confirmation of an error which is supplied back to the page in JSON

	@param reset_id	- The temporary reset_id sent to the client in an email 
	@param reset_password - The client's desired new password. 

--%>

<%--
	From the outside looking in, it seems like disc currently makes a token in the ajax/json/forgotten_password.jsp and sends the email regardless. It must also go and look up the mysql database to see if one exists there too. 

	Once we're in THIS FILE, we'll send the token to disc again, and if it finds it in disc will handle it there... otherwise we'll get an error xml node back from disc and it contains the persons email address matching the token that disc created earlier, and we then overwrite the password on the mysql side. Disc is the lookup point to return the email address for a token, so this token creation, mailout, and then lookup before reset needs to be developed on our side now for the mysql setup.
--%>
<c:choose>
	<c:when test="${not empty param.reset_id or not empty param.reset_password}">
	
		<go:log>Password Reset Called with id: ${param.reset_id}</go:log>

		<c:set var="emailMasterId" value="${authenticationService.verifyTokenForEmail(param.reset_id)}" />
		<go:log>Email Master ID returned with: ${emailMasterId}</go:log>
		<c:choose>
			<c:when test="${not empty emailMasterId}">

	<sql:setDataSource dataSource="jdbc/aggregator"/>
				<sql:query var="emailAddressSQL">
					SELECT emailAddress
					FROM aggregator.email_master
					WHERE emailId = ?
					AND styleCodeId = ?
					LIMIT 1;
					<sql:param value="${emailMasterId}" />
					<sql:param value="${styleCodeId}" />
				</sql:query>

				<c:choose>
					<c:when test="${not empty(emailAddressSQL) and emailAddressSQL.rowCount == 1}">

						<c:set var="emailAddress" value="${emailAddressSQL.rows[0].emailAddress}" />

						<go:log>emailAddressSQL returned: ${emailAddress}</go:log>

						<c:set var="new_password"><go:HmacSHA256 username="${emailAddress}" password="${param.reset_password}" brand="${pageSettings.getBrandCode()}" /></c:set>

						<sql:update var="sqlUpdateCode">
		UPDATE aggregator.email_master 
		SET emailPword = ? 
		WHERE emailAddress = ?
			AND styleCodeId = ?
			<sql:param value="${new_password}" />
		<sql:param value="${emailAddress}" />
			<sql:param value="${styleCodeId}" />
	</sql:update>	

						<c:choose>
							<c:when test="${sqlUpdateCode == 1}">
								<%-- JSON result success --%>
								<json:object>
									<json:property name="result" value="OK"/>
									<json:property name="email" value="${emailAddress}"/>
								</json:object>
		<security:log_audit identity="${emailAddress}" action="RESET PASSWORD" result="SUCCESS" />
	</c:when>
	<c:otherwise>
								<%-- JSON result failure -the SQL update died --%>
								<json:object>
									<json:property name="result" value="DB_ERROR"/>
									<json:property name="message" value="Oops, something seems to have gone wrong! - Please try the reset proceedure again later."/>
								</json:object>
								<security:log_audit identity="Unavailable" action="RESET PASSWORD" result="FAIL" metadata="token: ${param.reset_id}, emailMasterId: ${emailMasterId}, the sqlUpdateCode indicated failure" />
	</c:otherwise>
</c:choose>
					</c:when>
					<c:otherwise>
						<%-- JSON result failure - no email was found --%>
						<json:object>
							<json:property name="result" value="INVALID_EMAIL"/>
							<json:property name="message" value="We can't seem to find your email address in our system. Sorry about that!"/>
						</json:object>
						<security:log_audit identity="Unavailable" action="RESET PASSWORD" result="FAIL" metadata="token: ${param.reset_id}, emailMasterId: ${emailMasterId}, no email address was found for the emailMasterId" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<%-- JSON result failure - no email master ID was returned --%>
				<json:object>
					<json:property name="result" value="INVALID_LINK"/>
					<json:property name="message" value="Oops! Your reset password link has expired. Sorry about that."/>
				</json:object>
				<security:log_audit identity="Unavailable" action="RESET PASSWORD" result="FAIL" metadata="token: ${param.reset_id}, no email master result was returned" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<%-- JSON result failure --%>
		<json:object>
			<json:property name="result" value="INVALID_TOKEN_OR_PASSWORD"/>
			<json:property name="message" value="Oops, something seems to have gone wrong! - Check that you have provided a new password, or request a new reset password email."/>
		</json:object>
		<security:log_audit identity="Unavailable" action="RESET PASSWORD" result="FAIL" metadata="token: ${param.reset_id}, no params for token or new pass" />
	</c:otherwise>
</c:choose>

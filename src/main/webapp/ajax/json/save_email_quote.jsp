<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger('save_email_quote_jsp')}" />

<session:get settings="true" authenticated="true" />

<c:set var="errorPool" value="" />

<c:set var="quoteType" value="${param.quoteType}" />
<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="vertical" value="${param.vertical}" />
<c:set var="callback" value="${param.callback}" />

<c:set var="isOperator">
	<c:choose>
		<c:when test="${not empty authenticatedData.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<c:set var="sendConfirmation">
	<c:choose>
		<c:when test="${not empty param.sendConfirm}">${param.sendConfirm}</c:when>
		<c:otherwise>yes</c:otherwise>
	</c:choose>
</c:set>
<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		${logger.debug('PROCEEDINATOR PASSED')}

		<c:set var="sessionid" value="${pageContext.session.id}" />
		<c:set var="ipaddress" value="${pageContext.request.remoteAddr}" />
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
				<security:populateDataFromParams rootPath="quote" />
				<c:set var="firstName" value="${data['quote/drivers/regular/firstname']}" />
				<c:set var="lastName" value="${data['quote/drivers/regular/surname']}" />
				<c:set var="optinPhone" value=",okToCall=${data['quote/contact/oktocall']}" />
			</c:when>
			<c:when test="${quoteType eq 'utilities'}">
				<security:populateDataFromParams rootPath="utilities" />
				<c:set var="firstName" value="${data['utilities/application/details/firstName']}" />
				<c:set var="lastName" value="${data['utilities/application/details/lastName']}" />
				<c:set var="optinPhone" value="" />
			</c:when>
			<c:when test="${quoteType eq 'life'}">
				<security:populateDataFromParams rootPath="life" />
				<c:set var="firstName" value="${data['life/primary/firstName']}" />
				<c:set var="lastName" value="${data['life/primary/lastname']}" />
				<c:set var="optinPhone" value=",okToCall=${data['life/contactDetails/call']}" />
			</c:when>
			<c:when test="${quoteType eq 'ip'}">
				<security:populateDataFromParams rootPath="ip" />
				<c:set var="firstName" value="${data['ip/primary/firstName']}" />
				<c:set var="lastName" value="${data['ip/primary/lastname']}" />
				<c:set var="optinPhone" value=",okToCall=${data['ip/contactDetails/call']}" />
			</c:when>
			<c:when test="${quoteType eq 'health'}">
				<security:populateDataFromParams rootPath="health" />
				<c:set var="firstName" value="${data['health/contactDetails/firstName']}" />
				<c:set var="lastName" value="${data['health/contactDetails/lastname']}" />
				<c:set var="optinPhone" value=",okToCall=${data['health/contactDetails/call']}" />
			</c:when>
			<c:when test="${quoteType eq 'travel'}">
				<security:populateDataFromParams rootPath="travel" />
				<c:set var="firstName" value="${data['travel/firstName']}" />
				<c:set var="lastName" value="${data['travel/surname']}" />
				<c:set var="optinPhone" value="" />
			</c:when>
			<c:otherwise>
				<c:set var="firstName" value="" />
				<c:set var="lastName" value="" />
				<c:set var="optinPhone" value="" />
			</c:otherwise>
		</c:choose>

		<c:set var="emailAddress" value="${param.save_email}" />
		<%-- Update email_master for ordinary users --%>
		<%-- Confirm we have the email address and password values  --%>
		<c:choose>
			<c:when test="${not empty param.save_password and param.save_password != ''}">
				<c:set var="emailPassword"><go:HmacSHA256 username="${emailAddress}" password="${param.save_password}" brand="${brand}" /></c:set>
			</c:when>
			<c:when test="${not empty data['save/password']}">
				<c:set var="emailPassword"><go:HmacSHA256 username="${emailAddress}" password="${data['save/password']}" brand="${brand}" /></c:set>
			</c:when>
		</c:choose>

		<%--Add save_email to the data bucket --%>
		<c:choose>
			<c:when test="${quoteType eq 'car'}">
				<go:setData dataVar="data" xpath="quote/sendEmail" value="${param.save_email}" />
			</c:when>
			<c:otherwise>
				<go:setData dataVar="data" xpath="${quoteType}/sendEmail" value="${param.save_email}" />
			</c:otherwise>
		</c:choose>

		<c:if test="${empty emailAddress}">
				<c:set var="errorPool">"Insufficient credentials received to save the quote."</c:set>
		</c:if>
		<c:if test="${!isOperator}">
			<security:authentication
				emailAddress="${param.save_email}"
				justChecking="true" />
			<go:setData dataVar="authenticatedData" xpath="userData/loginExists" value="${userData.loginExists}" />
			<go:setData dataVar="authenticatedData" xpath="userData/emailAddress" value="${userData.emailAddress}" />
			<go:setData dataVar="authenticatedData" xpath="userData/optInMarketing" value="${userData.optInMarketing}" />
			<go:setData dataVar="data" xpath="userData/loginExists" value="${userData.loginExists}" />
			<go:setData dataVar="data" xpath="userData/emailAddress" value="${userData.emailAddress}" />
			<go:setData dataVar="data" xpath="userData/optInMarketing" value="${userData.optInMarketing}" />
			<c:if test="${!userData.loginExists and empty emailPassword}">
				<c:set var="errorPool">"Password is required."</c:set>
			</c:if>
		</c:if>

		<c:set var="optinMarketing">
			<c:choose>
				<c:when test="${param.save_marketing == 'Y'}">Y</c:when>
				<c:when test="${userData.optInMarketing}">Y</c:when>
				<c:otherwise>N</c:otherwise>
			</c:choose>
		</c:set>
		<c:if test="${empty errorPool}">
			<%-- Add/Update the user record in email_master --%>
			<c:catch var="error">
				<c:if test="${!userData.loginExists && !isOperator}">
					<agg:write_email
						brand="${brand}"
						vertical="${vertical}"
						source="${source}"
						emailAddress="${emailAddress}"
						emailPassword="${emailPassword}"
						firstName="${firstName}"
						lastName="${lastName}"
						items="marketing=${optinMarketing}${optinPhone}" />
					<%--TODO: Remove this once off DISC --%>
					<go:setData dataVar="userData" xpath="password" value="${emailPassword}" />
				</c:if>

			</c:catch>

			<%-- Test for DB issue and handle - otherwise move on --%>
			<c:choose>
				<c:when test="${not empty error}">
					<go:setData dataVar="data" xpath="userData/loginExists" value="true" />
					<c:if test="${not empty errorPool}">
						<c:set var="errorPool">${errorPool},</c:set>
					</c:if>
					${logger.error('Failed to add/update email_master {},{},{},{}',log:kv('emailAddress',emailAddress ) , log:kv('brand',brand ), log:kv('vertical',vertical ), log:kv('source',source ) , error)}
					<c:set var="errorPool">${errorPool}"A fatal database error occurred - we hope to resolve this soon."</c:set>
				</c:when>
				<c:otherwise>
					<c:set var="ct_outcome">
						<core:transaction touch="S" noResponse="false" writeQuoteOverride="${writeQuoteOverride}" emailAddress="${emailAddress}" comment="${source}" />
					</c:set>

					${logger.info('Touch quote with S. {}',log:kv('outcome',ct_outcome ))}
					<c:if test="${fn:contains(ct_outcome,'FAILED:')}">
						<c:if test="${not empty errorPool}">
							<c:set var="errorPool">${errorPool},</c:set>
						</c:if>
						<c:set var="ct_outcome" value="${fn:substringAfter(ct_outcome, 'FAILED:')}" />
						<c:set var="ct_outcome">${fn:replace(ct_outcome, "\"", "\\\"")}</c:set>
						<c:set var="errorPool">${errorPool}"${ct_outcome}"</c:set>
					</c:if>

					<%-- Send off the Email response via json/ajax/send.jsp --%>
					<c:if test="${sendConfirmation == 'yes'}">
						<c:catch var="silentError">
							<c:set var="emailResponse">
								<c:import url="send.jsp">
									<c:param name="vertical" value="${vertical}" />
									<c:param name="mode" value="quote" />
									<c:param name="emailAddress" value="${emailAddress}" />
									<c:param name="transactionId" value="${data.current.transactionId}" /> <%-- CHECK / TODO: Would never get passed as send.jsp never looks for this as a param? --%>
								</c:import>
							</c:set>
						</c:catch>
					</c:if>
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="errorPool">"This quote has been reserved by another user. Please try again later."</c:set>
	</c:otherwise>
</c:choose>
<%-- JSON/JSONP RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		${logger.info('Returning save errors to the browser', log:kv('errorPool', errorPool))}
		<c:choose>
			<c:when test="${fn:contains(callback,'jsonp')}">
				${callback}({error:${errorPool}});
			</c:when>
			<c:otherwise>
				{"error":${errorPool}}
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:if test="${isOperator && param.save_unlock == 'Y'}">
			<core:transaction touch="X" noResponse="true" />
		</c:if>

		<c:choose>
			<c:when test="${fn:contains(callback,'jsonp')}">
				${callback}({"result":"OK","transactionId":"${data.current.transactionId}"});
			</c:when>
			<c:otherwise>
				{"result":"OK","transactionId":"${data.current.transactionId}"}
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
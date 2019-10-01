<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.send')}" />

<session:get settings="true" verticalCode="${fn:toUpperCase(param.vertical)}" />

<c:set var="emailAddress" value="${param.emailAddress}" />
<c:set var="emailSubscribed" value="${param.emailSubscribed}" />
<c:set var="hashedEmail" value="${param.hashedEmail}" />
<c:set var="ignoreEmailSendToUnsubscribed" value="${false}" />

<c:if test ="${not empty param.emailAddress && (empty hashedEmail or empty emailSubscribed)}">
	<security:authentication emailAddress="${param.emailAddress}" justChecking="true" />
	<c:if test="${empty hashedEmail}">
		<c:set var="hashedEmail" value="${userData.hashedEmail}" />
	</c:if>
	<c:if test="${empty emailSubscribed}">
		<c:set var="emailSubscribed" value="${userData.optInMarketing}" />
	</c:if>
	<c:if test="${empty hashedEmail}">
		${logger.error('BPEMAIL No Hashed Email: {}', log:kv('transactionId', data.current.transactionId))}
	</c:if>
</c:if>

<c:set var="verticalCode" value="${pageSettings.getVerticalCode()}" />

<c:if test="${empty emailSubscribed or emailSubscribed eq 'N'}">
	<c:choose>
		<c:when test="${verticalCode == 'car' and param.mode == 'bestprice'}">
		<%-- Set this to false, as we have an unresolved bug that doesn't write to the opt in table --%>
		<%-- The results logic dictates that if you gets to results you MUST opt in, so this should never be true --%>
			<c:set var="ignoreEmailSendToUnsubscribed" value="${false}" />
		</c:when>
		<c:when test="${verticalCode == 'home' and param.mode == 'bestprice'}">
		<%-- Set this to false, as we have an unresolved bug that doesn't write to the opt in table --%>
		<%-- The results logic dictates that if you gets to results you MUST opt in, so this should never be true --%>
			<c:set var="ignoreEmailSendToUnsubscribed" value="${false}" />
		</c:when>
		<c:otherwise><%-- Continue--%></c:otherwise>
	</c:choose>
</c:if>

<c:choose>
	<c:when test="${ignoreEmailSendToUnsubscribed eq true}">
		${logger.info('BPEMAIL Email skipped as user not subscribed. {} {}', log:kv('transactionId', data.current.transactionId))}
	</c:when>
	<c:otherwise>

		<%-- Choose which specific settings to pull out --%>
		<%-- Best price will have an additional mailing name --%>
		<c:set var="OptInMailingName" value=""/>

		<c:choose>
			<%-- Mode is the "type of mailout" in concert with a template --%>
			<c:when test="${param.mode == 'quote'}"> <%-- Used for saved quote --%>
				<c:choose>
					<c:when test="${pageSettings.hasSetting('sendQuoteMailingName') and pageSettings.hasSetting('sendQuoteTmpl')}">
						<c:set var="MailingName" value="${pageSettings.getSetting('sendQuoteMailingName')}" />
						<c:set var="tmpl" value="${pageSettings.getSetting('sendQuoteTmpl')}" />
						${logger.debug('BPEMAIL Email Mode is quote and mode is enabled. {} {} {}', log:kv('mode', param.mode), log:kv('MailingName', MailingName), log:kv('tmpl', tmpl))}
					</c:when>
					<c:otherwise>
						${logger.warn('BPEMAIL param.mode passed but missing required page settings. {}', log:kv('mode', param.mode))}
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:when test="${param.mode == 'app'}"> <%-- Used for confirmation --%>
				<c:choose>
					<c:when test="${pageSettings.hasSetting('sendAppMailingName') and pageSettings.hasSetting('sendAppTmpl')}">
						<c:set var="MailingName" value="${pageSettings.getSetting('sendAppMailingName')}" />
						<c:set var="tmpl" value="${pageSettings.getSetting('sendAppTmpl')}" />
						${logger.debug('BPEMAIL Mode. {} {} {}', log:kv('mode', param.mode), log:kv('MailingName', MailingName), log:kv('tmpl', tmpl))}
					</c:when>
					<c:otherwise>
						${logger.warn('BPEMAIL Mode passed but missing required page settings. {}', log:kv('mode', param.mode))}
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:when test="${param.mode == 'edm'}"> <%-- travel uses this for best price too --%>
				<c:choose>
					<c:when test="${pageSettings.hasSetting('sendEdmMailingName') and pageSettings.hasSetting('sendEdmTmpl')}">
						<c:set var="MailingName" value="${pageSettings.getSetting('sendEdmMailingName')}" />
						<c:set var="tmpl" value="${pageSettings.getSetting('sendEdmTmpl')}" />
						${logger.debug('BPEMAIL Email Mode is edm. {} {} {}', log:kv('mode', param.mode), log:kv('MailingName', MailingName), log:kv('tmpl', tmpl))}
					</c:when>
					<c:otherwise>
						${logger.warn('BPEMAIL Mode passed but missing required page settings. {}', log:kv('mode',param.mode ))}
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:when test="${param.mode == 'bestprice'}"> <%-- Health's best price email and future ones too --%>
				<c:choose>
					<c:when test="${pageSettings.hasSetting('sendBestPriceMailingName') and pageSettings.hasSetting('sendBestPriceOptInMailingName') and pageSettings.hasSetting('sendBestPriceTmpl')}">
						<c:set var="MailingName" value="${pageSettings.getSetting('sendBestPriceMailingName')}" />
						<c:set var="OptInMailingName" value="${pageSettings.getSetting('sendBestPriceOptInMailingName')}"/>
						<c:set var="tmpl" value="${pageSettings.getSetting('sendBestPriceTmpl')}" />
						${logger.debug('BPEMAIL Mode: {} {} {} {} {}', log:kv('mode', param.mode) , log:kv('MailingName', MailingName), log:kv('OptInMailingName', OptInMailingName), log:kv('tmpl', tmpl), log:kv('hashedEmail', hashedEmail))}
					</c:when>
					<c:otherwise>
						${logger.warn('BPEMAIL Mode passed but missing required page settings. {} {}', log:kv('mode', param.mode), log:kv('transactionId', data.current.transactionId))}
					</c:otherwise>
				</c:choose>
			</c:when>
			<%-- Reset password, called from forgotten_password.jsp --%>
			<c:otherwise>
				${logger.warn('BPEMAIL No matching mode passed. {} {}', log:kv('mode', param.mode), log:kv('transactionId', data.current.transactionId))}
			</c:otherwise>
		</c:choose>


		<c:set var="xSQL" value=""/>

		<c:choose> <%-- CHECK / TODO: Would this work reliably? we just defined the verticalCode on settings as something passed by param at page top! --%>
			<c:when test="${verticalCode == 'travel' and param.mode == 'edm'}">
				<c:set var="xSQL" value="${pageSettings.getSetting('sendEdmxSQL')}"/>
			</c:when>
			<c:when test="${verticalCode == 'health' and param.mode == 'bestprice'}">
				<c:set var="xSQL" value="${pageSettings.getSetting('sendBestPricexSQL')}"/>
			</c:when>
			<c:when test="${verticalCode == 'home' and param.mode == 'bestprice'}">
				<c:set var="xSQL" value="${pageSettings.getSetting('sendBestPricexSQL')}"/>
			</c:when>
			<c:when test="${verticalCode == 'car' and param.mode == 'bestprice'}">
				<c:set var="xSQL" value="${pageSettings.getSetting('sendBestPricexSQL')}"/>
			</c:when>
		</c:choose>

		<c:choose>
			<c:when test="${empty MailingName}">
				${logger.warn('BPEMAIL Mailing Name empty, no email found to be sent. {} {} {} {} {}', log:kv('transactionId', data.current.transactionId), log:kv('hashedEmail', hashedEmail), log:kv('OptInMailingName', OptInMailingName), log:kv('emailSubscribed', emailSubscribed))}
			</c:when>
			<c:otherwise>
				<%-- Dial into the send script --%>
				<c:import url="${pageSettings.getSetting('sendUrl')}">
				<%-- The URL building details --%>
					<c:param name="MailingName" value="${MailingName}" />
					<c:param name="OptInMailingName" value="${OptInMailingName}" />
					<c:param name="tmpl" value="${tmpl}" />
					<c:param name="server" value="${pageSettings.getRootUrl()}" />
					<c:param name="env" value="${pageSettings.getSetting('sendUrlEnv')}" />
					<c:param name="send" value="${pageSettings.getSetting('sendYN')}" />
					<c:param name="xSQL" value="${xSQL}" />
					<c:param name="SessionId" value="${pageContext.session.id}-${data.current.transactionId}" />
					<c:param name="tranId" value="${data.current.transactionId}" />
					<c:param name="hashedEmail" value="${hashedEmail}" />
					<c:param name="emailAddress" value="${emailAddress}" />
					<c:param name="emailSubscribed" value="${emailSubscribed}" />
					<c:param name="bccEmail" value="${param.bccEmail}" />
				</c:import>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

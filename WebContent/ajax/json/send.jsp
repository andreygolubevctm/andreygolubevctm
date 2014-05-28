<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" verticalCode="${param.vertical}" />
<go:log>#### SENT VERTICAL: ${param.vertical} ####</go:log>

<c:set var="hashedEmail" value="${param.hashedEmail}" />

<c:if test ="${not empty param.emailAddress && empty hashedEmail}">
	<security:authentication emailAddress="${param.emailAddress}" justChecking="true" />
	<c:set var="hashedEmail" value="${userData.hashedEmail}" />
</c:if>

<%-- Choose which specific settings to pull out --%>
<%-- Best price will have an additional mailing name --%>
<c:set var="OptInMailingName" value=""/>

<c:choose>
	<%-- Mode is the "type of mailout" in concert with a template --%>
	<c:when test="${param.mode == 'quote'}"> <%-- Used for saved quote --%>
		<c:set var="MailingName" value="${pageSettings.getSetting('sendQuoteMailingName')}" />
		<c:set var="tmpl" value="${pageSettings.getSetting('sendQuoteTmpl')}" />
	</c:when>
	<c:when test="${param.mode == 'app'}"> <%-- Used for confirmation --%>
		<c:set var="MailingName" value="${pageSettings.getSetting('sendAppMailingName')}" />
		<c:set var="tmpl" value="${pageSettings.getSetting('sendAppTmpl')}" />
	</c:when>
	<c:when test="${param.mode == 'edm'}"> <%-- travel uses this for best price too --%>
		<c:set var="MailingName" value="${pageSettings.getSetting('sendEdmMailingName')}" />
		<c:set var="tmpl" value="${pageSettings.getSetting('sendEdmTmpl')}" />
	</c:when>
	<c:when test="${param.mode == 'bestprice'}"> <%-- Health's best price email and future ones too --%>
		<c:set var="MailingName" value="${pageSettings.getSetting('sendBestPriceMailingName')}" />
		<c:set var="OptInMailingName" value="${pageSettings.getSetting('sendBestPriceOptInMailingName')}"/>
		<c:set var="tmpl" value="${pageSettings.getSetting('sendBestPriceTmpl')}" />
		<go:log>
---------------------------------------
EMAIL VIA ajax/json/send.jsp
---------------------------------------
Mode: ${param.mode},
MailingName: ${MailingName},
OptInMailingName: ${OptInMailingName},
tmpl: ${tmpl},
<c:choose><c:when test="${not empty param.emailAddress}">emailAddress was passed</c:when><c:otherwise>emailAddress not passed</c:otherwise></c:choose>,
<c:choose><c:when test="${not empty hashedEmail}">hashedEmail is available</c:when><c:otherwise>hashedEmail NOT available!</c:otherwise></c:choose>
---------------------------------------
		</go:log>
	</c:when>
	<%-- Reset password, called from forgotten_password.jsp --%>
	<c:otherwise>
		<go:log>/ajax/json/send.jsp - No matching mode passed. param.mode was: ${param.mode}</go:log>
	</c:otherwise>
</c:choose>


<c:set var="xSQL" value=""/>

<c:choose> <%-- CHECK / TODO: Would this work reliably? we just defined the verticalCode on settings as something passed by param at page top! --%>
	<c:when test="${pageSettings.getVerticalCode() == 'travel' and param.mode == 'edm'}">
		<c:set var="xSQL" value="${pageSettings.getSetting('sendEdmxSQL')}"/>
	</c:when>
	<c:when test="${pageSettings.getVerticalCode() == 'health' and param.mode == 'bestprice'}">
		<c:set var="xSQL" value="${pageSettings.getSetting('sendBestPricexSQL')}"/>
	</c:when>
</c:choose>

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
</c:import>
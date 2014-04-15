<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" />
<settings:setVertical verticalCode="${param.vertical}" />

<c:set var="hashedEmail" value="${param.hashedEmail}" />

<c:if test ="${not empty param.emailAddress && empty hashedEmail}">
	<security:authentication
				emailAddress="${param.emailAddress}" />
	<c:set var="hashedEmail" value="${userData.hashedEmail}" />
</c:if>

<%-- Choose which specific settings to pull out --%>

<c:choose>
	<c:when test="${param.mode == 'quote'}">
		<c:set var="MailingName" value="${pageSettings.getSetting('sendQuoteMailingName')}" />
		<c:set var="tmpl" value="${pageSettings.getSetting('sendQuoteTmpl')}" />
	</c:when>
	<c:when test="${param.mode == 'app'}">
		<c:set var="MailingName" value="${pageSettings.getSetting('sendAppMailingName')}" />
		<c:set var="tmpl" value="${pageSettings.getSetting('sendAppTmpl')}" />
	</c:when>
	<c:when test="${param.mode == 'edm'}">
		<c:set var="MailingName" value="${pageSettings.getSetting('sendEdmMailingName')}" />
		<c:set var="tmpl" value="${pageSettings.getSetting('sendEdmTmpl')}" />
	</c:when>
</c:choose>


<c:set var="xSQL" value=""/>


<c:if test="${pageSettings.getVerticalCode() == 'travel'}">
	<c:set var="xSQL" value="${pageSettings.getSetting('sendEdmxSQL')}"/>
</c:if>

<%-- Dial into the send script --%>
<c:import url="${pageSettings.getSetting('sendUrl')}">
	<c:param name="MailingName" value="${MailingName}" />
	<c:param name="tmpl" value="${tmpl}" />
	<c:param name="server" value="${pageSettings.getRootUrl()}" />
	<c:param name="env" value="${pageSettings.getSetting('sendUrlEnv')}" />
	<c:param name="send" value="${pageSettings.getSetting('sendYN')}" />
	<c:param name="xSQL" value="${xSQL}" />
	<c:param name="SessionId" value="${pageContext.session.id}-${data.current.transactionId}" />
	<c:param name="tranId" value="${data.current.transactionId}" />
	<c:param name="hashedEmail" value="${hashedEmail}" />
</c:import>

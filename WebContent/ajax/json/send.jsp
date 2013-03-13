<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Choose which specific settings to pull out --%>
<c:set var="main" value="${data.settings.send}" />
<c:choose>
	<c:when test="${param.mode == 'quote'}">
		<c:set var="parent" value="${main.quote}" />
	</c:when>
	<c:when test="${param.mode == 'app'}">
		<c:set var="parent" value="${main.app}" />
	</c:when>
</c:choose>

<go:log>
--c:import url="${main.sendUrl}">
	--c:param name="MailingName" value="${parent.MailingName}" />
	--c:param name="tmpl" value="${parent.tmpl}" />
	--c:param name="env" value="${main.sendUrlEnv}" />
	--c:param name="send" value="${main.sendYN}" />
	--c:param name="SessionId" value="${pageContext.session.id}-${data.current.transactionId}" />
	--c:param name="tranId" value="${data.current.transactionId}" />
--/c:import>
</go:log>


<%-- Dial into the send script --%>
<c:import url="${main.sendUrl}">
	<c:param name="MailingName" value="${parent.MailingName}" />
	<c:param name="tmpl" value="${parent.tmpl}" />
	<c:param name="env" value="${main.sendUrlEnv}" />
	<c:param name="send" value="${main.sendYN}" />
	<c:param name="SessionId" value="${pageContext.session.id}-${data.current.transactionId}" />
	<c:param name="tranId" value="${data.current.transactionId}" />
</c:import>

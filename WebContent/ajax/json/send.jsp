<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="hashedEmail" value="${param.hashedEmail}" />

<c:if test ="${not empty param.emailAddress && empty hashedEmail}">
	<security:authentication
				emailAddress="${param.emailAddress}" />
	<c:set var="hashedEmail" value="${userData.hashedEmail}" />
</c:if>

<%-- Choose which specific settings to pull out --%>
<c:set var="main" value="${data.settings.send}" />
<c:choose>
	<c:when test="${param.mode == 'quote'}">
		<c:set var="parent" value="${main.quote}" />
	</c:when>
	<c:when test="${param.mode == 'app'}">
		<c:set var="parent" value="${main.app}" />
	</c:when>
	<c:when test="${param.mode == 'edm'}">
		<c:set var="parent" value="${main.edm}" />
	</c:when>
</c:choose>

<go:log level="TRACE" source="send_jsp">
--c:import url="${main.sendUrl}">
	--c:param name="MailingName" value="${parent.MailingName}" />
	--c:param name="tmpl" value="${parent.tmpl}" />
	--c:param name="server" value="${data['settings/root-url']}" />
	--c:param name="env" value="${main.sendUrlEnv}" />
	--c:param name="send" value="${main.sendYN}" />
	--c:param name="xsql" value="${parent.xSQL}" />
	--c:param name="SessionId" value="${pageContext.session.id}-${data.current.transactionId}" />
	--c:param name="tranId" value="${data.current.transactionId}" />
	--c:param name="hashedEmail" value="${hashedEmail}" />
--/c:import>
</go:log>

<go:log source="send_jsp" level="DEBUG">${data.settings}</go:log>
<%-- Dial into the send script --%>
<c:import url="${main.sendUrl}">
	<c:param name="MailingName" value="${parent.MailingName}" />
	<c:param name="tmpl" value="${parent.tmpl}" />
	<c:param name="server" value="${data['settings/root-url']}" />
	<c:param name="env" value="${main.sendUrlEnv}" />
	<c:param name="send" value="${main.sendYN}" />
	<c:param name="xSQL" value="${parent.xSQL}" />
	<c:param name="SessionId" value="${pageContext.session.id}-${data.current.transactionId}" />
	<c:param name="tranId" value="${data.current.transactionId}" />
	<c:param name="hashedEmail" value="${hashedEmail}" />
</c:import>

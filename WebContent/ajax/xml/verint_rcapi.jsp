<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%--
***FIX: we normally would request parameters and ensure they are safe for output
We should also receive the PORT / Machine from configuration files
AND the extension from a Get Agent ID call.
***FIX: Note we also need to get the user's extension - set user's extension
--%>

<%-- Store flag as to whether Simples Operator or Other and protect page --%>
<c:set var="isOperator"><c:if test="${not empty data['login/user/uid']}">${data['login/user/uid']}</c:if></c:set>

<%-- Get the Operator's extension if not already recorded --%>
<c:if test="${empty data.login.user.extension}">
	<c:choose>
		<c:when test="${empty data.login.user.agentId or data.login.user.agentId eq ''}">
			<%  response.sendError(412, "Parameter preconditions failed, no Agent or Extension" ); if(true) return; %>
		</c:when>
		<c:otherwise>
			<%-- Capture the Extension Number --%>
			<c:catch var="getExtensionError">
				<c:set var="extension"><core:verint_rcapi_extension port="8778" machine="192.168.1.22" agentId="${data.login.user.agentId}" /></c:set>
				<go:setData dataVar="data" xpath="login/user/extension" value="${extension}" />
			</c:catch>
			<c:if test="${not empty getExtensionError or empty data.login.user.extension or data.login.user.extension eq ''}">
				<%  response.sendError(405, "Failed to retrieve the extension number"); if(true) return; %>
			</c:if>
		</c:otherwise>
	</c:choose>
</c:if>

<c:set var="audio"><c:out value="${param.audio}" escapeXml="true" /></c:set>

<c:choose>
	<c:when test="${empty isOperator}">
		<% response.sendError(401, "This page is protected." ); if(true) return; %>
	</c:when>
	<c:when test="${audio != '1' and audio != '0'}">
		<% response.sendError(412, "Parameter preconditions failed" ); if(true) return; %>
	</c:when>
	<c:otherwise>
		<core:verint_rcapi_mute port="8778" machine="192.168.1.22" audio="${param.audio}" extension="${data.login.user.extension}" />
	</c:otherwise>
</c:choose>
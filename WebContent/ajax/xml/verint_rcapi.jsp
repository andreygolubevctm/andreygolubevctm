<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:getAuthenticated  />

<%--
***FIX: we normally would request parameters and ensure they are safe for output
We should also receive the PORT / Machine from configuration files
AND the extension from a Get Agent ID call.
***FIX: Note we also need to get the user's extension - set user's extension
--%>

<%-- Store flag as to whether Simples Operator or Other and protect page --%>
<c:set var="isOperator"><c:if test="${not empty authenticatedData['login/user/uid']}">${authenticatedData['login/user/uid']}</c:if></c:set>

<%-- Get the Operator's extension if not already recorded --%>
<c:if test="${empty authenticatedData.login.user.extension}">
	<c:choose>
		<c:when test="${empty authenticatedData.login.user.agentId or authenticatedData.login.user.agentId eq ''}">
			<%  response.sendError(412, "Parameter preconditions failed, no Agent or Extension" ); if(true) return; %>
		</c:when>
		<c:otherwise>
			<%-- Capture the Extension Number --%>
			<c:catch var="getExtensionError">
				<c:set var="extension"><core:verint_rcapi_extension port="8778" machine="192.168.1.22" agentId="${authenticatedData.login.user.agentId}" /></c:set>
				<go:setData dataVar="authenticatedData" xpath="login/user/extension" value="${extension}" />
			</c:catch>
			<c:if test="${not empty getExtensionError or empty authenticatedData.login.user.extension or authenticatedData.login.user.extension eq ''}">
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
		<core:verint_rcapi_mute port="8778" machine="192.168.1.22" audio="${param.audio}" extension="${authenticatedData.login.user.extension}" />
	</c:otherwise>
</c:choose>
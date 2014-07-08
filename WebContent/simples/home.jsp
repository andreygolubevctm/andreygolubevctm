<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<%@ include file="/WEB-INF/security/core.jsp" %>

<layout:simples_page>
	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>

		<%-- Check settings for if the message queue feature is enabled --%>
		<c:catch var="settingError">
			<c:set var="messageQueueEnabled" value="${pageSettings.getSetting('messageQueueEnabled')}" />
			<c:set var="messageQueueRole"    value="${pageSettings.getSetting('messageQueueRole')}" />
		</c:catch>

		<c:if test="${not empty settingError}"><go:log level="INFO" source="simples_home_jsp">${settingError}</go:log></c:if>

		<c:choose>
			<%-- Check if queue is restricted to certain active directory groups --%>
			<c:when test="${messageQueueEnabled == 'Y' and (empty messageQueueRole or (not empty messageQueueRole and pageContext.request.isUserInRole(messageQueueRole)))}">
				<simples:home tranID="0" messageID="0" />
			</c:when>
			<c:otherwise>
				<p style="margin:3em 0 0; text-align:center">Hello!</p>
			</c:otherwise>
		</c:choose>

		<%-- Alert user if they're missing core data --%>
		<c:if test="${empty authenticatedData.login.user.agentId or authenticatedData.login.user.agentId eq ''}">
			<div class="alert alert-warning">
				<p>Your Agent ID was not supplied during Log In.</p>
				<p>An Agent ID is required to sell products. Please <strong>do not begin</strong> consulting without it.</p>
				<p>Contact your supervisor for further I.T. assistance.</p>
			</div>
		</c:if>

		<%-- Alert user if they're missing extension info --%>
		<c:if test="${empty authenticatedData.login.user.extension or authenticatedData.login.user.extension eq ''}">
			<div class="alert alert-warning">
				<p>Your phone extension is unknown.</p>
				<p>If you are consulting please log into your phone, then log into Simples again.</p>
			</div>
		</c:if>

	</jsp:body>
</layout:simples_page>

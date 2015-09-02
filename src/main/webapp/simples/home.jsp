<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp:simples.home')}" />

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<%@ include file="/WEB-INF/security/core.jsp" %>



<%-- Check settings for if the message queue feature is enabled --%>
<c:catch var="settingError">
	<c:set var="messageQueueEnabled" value="${pageSettings.getSetting('messageQueueEnabled')}" />
	<c:set var="messageQueueRole"    value="${pageSettings.getSetting('messageQueueRole')}" />
</c:catch>
<c:if test="${not empty settingError}">
	${logger.info('Error when getting if message queue enabled ',  settingError)}
</c:if>

<%-- Check if queue is restricted to certain active directory groups --%>
<c:if test="${messageQueueEnabled == 'Y' and (empty messageQueueRole or (not empty messageQueueRole and pageContext.request.isUserInRole(messageQueueRole)))}">
	<c:set var="hasMessageQueue" value="${true}" />
</c:if>




<layout:simples_page>
	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>

<div class="row">
	<div class="col-sm-8 simples-home">

		<c:if test="${hasMessageQueue}">
			<simples:message_queue_home />
		</c:if>

		<div class="simples-notice-board">
			<h2>Welcome to Simples</h2>

			<%-- Alert user if they're missing core data --%>
			<c:if test="${empty authenticatedData.login.user.agentId or authenticatedData.login.user.agentId eq ''}">
				<div class="alert alert-danger">
					<p>Your Agent ID was not supplied during Log In.</p>
					<p>An Agent ID is required to sell products. Please <strong>do not begin</strong> consulting without it.</p>
					<p>Contact your supervisor for further I.T. assistance.</p>
				</div>
			</c:if>

			<%-- Alert user if they're missing extension info --%>
			<c:if test="${empty authenticatedData.login.user.extension or authenticatedData.login.user.extension eq ''}">
				<div class="alert alert-danger">
					<p>Your phone extension is unknown.</p>
					<p>If you are consulting please log into your phone, then log into Simples again.</p>
				</div>
			</c:if>

			<c:if test="${hasMessageQueue}">
				<simples:user_stats />
			</c:if>
		</div><%-- /simples-notice-board --%>

	</div>
	<div class="col-sm-3 col-sm-push-1">

		<c:if test="${hasMessageQueue}">
			<simples:postponed_queue />
		</c:if>

	</div>
</div>

	</jsp:body>
</layout:simples_page>

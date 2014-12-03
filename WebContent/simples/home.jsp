<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<%@ include file="/WEB-INF/security/core.jsp" %>

<layout:simples_page>
	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>

<div class="row">
	<div class="col-sm-8 simples-home">

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
		</div><%-- /simples-notice-board --%>

		<simples:message_queue_home />

	</div>
	<div class="col-sm-3 col-sm-push-1">

		<simples:postponed_queue />

	</div>
</div>

	</jsp:body>
</layout:simples_page>

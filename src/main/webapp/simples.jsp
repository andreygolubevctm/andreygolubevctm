<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<settings:setVertical verticalCode="SIMPLES" />

<%-- Clear auth data --%>
<go:setData dataVar="authenticatedData" xpath="login" value="*DELETE" />
<go:setData dataVar="authenticatedData" xpath="messages" value="*DELETE" />

<%-- Log in / authenticate user --%>
<c:set var="login"><core:login uid="${param.uid}" /></c:set>
<c:set var="callCentre" scope="session"><simples:security key="callCentre" /></c:set>
<c:set var="isRoleSupervisor" scope="session"><simples:security key="supervisor" /></c:set>
<c:set var="isRoleIT" scope="session"><simples:security key="IT" /></c:set>

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}" />

<c:choose>
	<c:when test="${ sessionScope != null and not empty(sessionScope.isLoggedIn) and sessionScope.isLoggedIn == 'true' }">
		<c:set var="logoutText" value="Log Out" />
		<c:set var="userInfo" value="${sessionScope.userDetails['displayName']} (${pageContext.request.remoteUser})" />
	</c:when>
	<c:otherwise>
		<c:set var="logoutText" value="Clear Session Details" />
		<c:set var="userInfo" value="" />
	</c:otherwise>
</c:choose>



<c:choose>
	<c:when test="${empty callCentre or !callCentre}">
		<%@ include file="/security/simples_noaccess.jsp" %>
	</c:when>
	<c:otherwise>

		<layout:simples_page fullWidth="true">

			<jsp:attribute name="head">
				<script src="${assetUrl}framework/lib/js/Inspector-JSON-0.1.0/inspector-json.js"></script>
				<link rel="stylesheet" href="${assetUrl}framework/lib/js/Inspector-JSON-0.1.0/inspector-json.css">
			</jsp:attribute>

			<jsp:body>
						<simples:menu_bar bridgeToLive="N" />

						<iframe id="simplesiframe" name="simplesiframe" width="100%" height="200" src="${assetUrl}simples/home.jsp"></iframe>

						<simples:template_comments />
						<simples:template_messageaudit />
						<simples:template_messagedetail />
						<simples:template_moreinfo />
						<simples:template_postpone />
						<simples:template_quotedetails />
						<simples:template_search />
						<simples:template_touches />
						<simples:template_blacklist_add />
						<simples:template_blacklist_delete />
			</jsp:body>

		</layout:simples_page>

	</c:otherwise>
</c:choose>

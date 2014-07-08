<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<settings:setVertical verticalCode="${param.verticalCode}" />
<session:getAuthenticated />

<jsp:useBean id="callCentreService" class="com.ctm.services.CallCentreService" scope="application" />
<jsp:useBean id="authenticationService" class="com.ctm.services.AuthenticationService" scope="application" />


<%-- the following is for testing only --%>
<c:set var="brandCodeUrl">
	<c:if test="${environmentService.needsManuallyAddedBrandCodeParam()}">?brandCode=${pageSettings.getBrandCode()}</c:if>
</c:set>

<c:choose>
	<c:when test="${empty param.token && not empty sessionScope.isLoggedIn}">
		<c:set var="isAuthenticated" value="true"/>
	</c:when>
	<c:otherwise>
		<%-- Always consume token - because 1) it prevents the token from being used, and 2) it ensures the correct person is logged in --%>
		<c:set var="isAuthenticated" value="${authenticationService.authenticateWithTokenForSimplesUser(pageContext, param.token)}" />
	</c:otherwise>
</c:choose>



<c:choose>
	<c:when test="${isAuthenticated}">
		<c:set var="login"><core:login uid="" /></c:set>
		<c:choose>
			<c:when test="${empty param.transactionId}">
				<c:redirect url="${pageSettings.getBaseUrl()}${pageSettings.getSetting('quoteUrl')}${brandCodeUrl}"/>
			</c:when>
			<c:otherwise>
				<simples:load_quote />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<%-- TODO - DO PROPER ERROR HANDLING --%>
		ERROR
	</c:otherwise>
</c:choose>

<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="userAgentSniffer" class="com.ctm.services.UserAgentSniffer" />
<%-- Display Rules:
	0. Always load if forceOnSC = true
	1. Never display for operators.
	2. Never display if you have the disabledSC parameter.
	3. Only display if the pageSetting is activated.
	4. Only display if it matches the browser subset
--%>
<%-- Only render the code on NXS or localhost for now, and only if not an Operator --%>
<%-- Add ?disableSC=true if you want to not load this script. --%>
<c:set var="userAgent">${pageContext.getRequest().getHeader("user-agent")}</c:set>
<c:set var="isEnabledForBrowser">${userAgentSniffer.getDeviceType(userAgent) eq 'COMPUTER' && userAgentSniffer.getBrowserName(userAgent) eq 'CHROME'}</c:set>
<c:set var="isEnabledInDb"><content:get key="userTrackingEnabled"/></c:set>
<c:set var="isOperator">
	<c:choose>
		<c:when test="${not empty authenticatedData.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>
<c:out value="${param.forceOnSC == 'true' or (isEnabledInDb == 'Y' && isEnabledForBrowser && !isOperator && !param.disableSC)}" />
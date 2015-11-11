<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
<%-- Display Rules:
	0. Always load if forceOnSC = true
	1. Never display for operators.
	2. Never display if you have the disabledSC parameter.
	3. Only display if the pageSetting is activated.
	4. Only display if it matches the browser subset
--%>
<%-- Only render the code on NXS or localhost for now, and only if not an Operator --%>
<%-- Add ?disableSC=true if you want to not load this script. --%>
<c:set var="isEnabledInDb"><content:get key="userTrackingEnabled" /></c:set>
<%-- This will always return true if browser is > than current version,
even if you don't want it on, which is why it's inside this condition --%>
<c:set var="isEnabledForBrowserAndDevice">${isEnabledInDb == 'Y' && userAgentSniffer.isSupportedDevice(pageContext.getRequest(), 'userTrackingDeviceRules') eq true && userAgentSniffer.isSupportedBrowser(pageContext.getRequest(), 'userTrackingBrowserRules') eq true}</c:set>

<c:set var="isOperator">
	<c:choose>
		<c:when test="${not empty authenticatedData.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>
<c:out value="${param.forceOnSC == 'true' or (!param.preload && isEnabledForBrowserAndDevice && !isOperator && !param.disableSC)}" />
<%--
	Health quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="sessionUtils" class="com.ctm.web.core.utils.SessionUtils"/>
<session:new verticalCode="HEALTH" authenticated="true" />

<health_v1:redirect_rules />

<c:set var="journeyOverride" value="${pageSettings.getSetting('journeyOverride') eq 'Y'}" />

<c:set var="redirectURL" value="${pageSettings.getBaseUrl()}health_quote_v4.jsp?" />
<c:if test="${callCentre && journeyOverride eq true}">
    <c:set var="redirectURL" value="${pageSettings.getBaseUrl()}health_quote.jsp?" />
</c:if>
<c:forEach items="${param}" var="currentParam">
    <c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
</c:forEach>
<c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL) - 1)}" />

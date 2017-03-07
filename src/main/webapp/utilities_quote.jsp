<%--
	Utilities Quote Page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="sessionUtils" class="com.ctm.web.core.utils.SessionUtils"/>
<session:new verticalCode="UTILITIES" authenticated="true" />

<c:set var="redirectURL" value="${pageSettings.getRootUrl()}energy/journey/start?" />
<c:forEach items="${param}" var="currentParam">
    <c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
</c:forEach>
<c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL) - 1)}" />

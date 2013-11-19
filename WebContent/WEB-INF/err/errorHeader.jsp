<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<go:log>err/errorHeader.jsp START... request.servletPath:${pageContext.request.servletPath} forward.request_uri:${requestScope["javax.servlet.forward.request_uri"]}</go:log>

<%-- Don't override settings --%>
<c:set var="vertical">
	<c:if test="${not empty data.settings.vertical}">${data.settings.vertical}</c:if>
</c:set>

<c:catch var ="catchException">
	<core:load_settings vertical="${vertical}" conflictMode="false" />
</c:catch>

<c:if test = "${catchException != null}">
		<go:log>Load Setting Failed: ${catchException.message}</go:log>
		<go:setData dataVar="data" xpath="settings/stylesheet" value="ctm/style.css" />
		<go:setData dataVar="data" xpath="settings/error-stylesheet" value="ctm/error.css" />
		<go:setData dataVar="data" xpath="settings/privacy-policy-url" value="/ctm/legal/privacy_policy.pdf" />
		<go:setData dataVar="data" xpath="settings/website-terms-url" value="/ctm/legal/website_terms_of_use.pdf" />
</c:if>

<c:if test="${empty data['settings/stylesheet']}">
	<go:setData dataVar="data" xpath="settings/stylesheet" value="ctm/style.css" />
</c:if>
<c:if test="${empty data['settings/error-stylesheet']}">
	<go:setData dataVar="data" xpath="settings/error-stylesheet" value="ctm/error.css" />
</c:if>
<c:if test="${empty data['settings/privacy-policy-url']}">
	<go:setData dataVar="data" xpath="settings/privacy-policy-url" value="/ctm/legal/privacy_policy.pdf" />
</c:if>
<c:if test="${empty data['settings/website-terms-url']}">
	<go:setData dataVar="data" xpath="settings/website-terms-url" value="/ctm/legal/website_terms_of_use.pdf" />
</c:if>

<c:set var="defaultTitle" value="Error Page" />
<c:choose>
	<c:when test="${ empty(pageTitle) }">
		<c:set var="windowTitle" value="${defaultTitle}" />
		<c:set var="pageTitle" value="${defaultTitle}" />
	</c:when>
	<c:otherwise>
		<c:set var="windowTitle" value="${pageTitle} - ${defaultTitle}" />
	</c:otherwise>
</c:choose>

<!DOCTYPE html>
<!--[if IE 8]><html class='no-js lt-ie9' lang='en' > <![endif]-->
<!--[if gt IE 8]><!--> <html class='no-js' lang='en' > <!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
		<meta http-equiv="Expires" content="-1">
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no">
		<title><c:out value="${windowTitle}" /></title>
		<link rel="shortcut icon" type="image/x-icon" href="<c:url value="/common/images/favicon.ico" />">
		<link rel="stylesheet" href="<c:url value="/common/reset.css" />">
		<link rel="stylesheet" href="<c:url value="/common/base.css" />">
		<link rel="stylesheet" href="<c:url value="/brand/${data['settings/stylesheet']}" />">
		<link rel="stylesheet" href="<c:url value="/brand/${data['settings/error-stylesheet']}" />">
		<go:script>
			function showDoc(url,title){
				if (title) {
					title=title.replace(/ /g,"_");
				}
				window.open(url,title,"width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");
			}
		</go:script>
	</head>
	<body>
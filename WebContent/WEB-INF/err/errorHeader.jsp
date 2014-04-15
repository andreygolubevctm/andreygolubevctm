<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:log source="errorHeader_jsp" level="ERROR">START... request.servletPath:${pageContext.request.servletPath} forward.request_uri:${requestScope["javax.servlet.forward.request_uri"]}</go:log>


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
		<link rel="stylesheet" href="<c:url value="/brand/${pageSettings.getSetting('fontStylesheet')}" />">
		<link rel="stylesheet" href="<c:url value="/brand/${pageSettings.getSetting('stylesheet')}" />">
		<link rel="stylesheet" href="<c:url value="/brand/${pageSettings.getSetting('errorStylesheet')}" />">




		<script type="text/javascript" src="<c:url value="/common/js/jquery-${pageSettings.getSetting('jqueryVersion')}.js?ts="/>"></script>

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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.err.errorHeader')}" />
${logger.error('Start error header. {},{}', log:kv('servletPath',pageContext.request.servletPath ), log:kv('request_uri',requestScope["javax.servlet.forward.request_uri"] ))}
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
<!--[if IE 8]><html class='errorPage no-js lt-ie9' lang='en' > <![endif]-->
<!--[if gt IE 8]><!--> <html class='errorPage no-js' lang='en' > <!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
		<meta http-equiv="Expires" content="-1">
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no">
		<title><c:out value="${windowTitle}" /></title>

		<c:set var="baseUrl" value="${pageSettings.getBaseUrl()}" />

		<c:choose>
			<c:when test="${pageSettings.getBrandCode() != 'ctm'}">
				<%-- WHITELABEL The overriding head inclusions --%>
				<link rel="shortcut icon" type="image/x-icon" href="${baseUrl}brand/${pageSettings.getBrandCode()}/graphics/favicon.ico?new">

				<link rel="stylesheet" href="${baseUrl}brand/${pageSettings.getBrandCode()}/css/${pageSettings.getVerticalCode()}.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.css">
			</c:when>
			<c:otherwise>
				<link rel="shortcut icon" type="image/x-icon" href="${baseUrl}common/images/favicon.ico?new">
				<link rel="stylesheet" href="${baseUrl}common/reset.css">
				<link rel="stylesheet" href="${baseUrl}common/base.css">
				<link rel="stylesheet" href="${baseUrl}brand/${pageSettings.getSetting('stylesheet')}">
				<link rel="stylesheet" href="${baseUrl}brand/${pageSettings.getSetting('errorStylesheet')}">
			</c:otherwise>
		</c:choose>
	</head>
	<body>
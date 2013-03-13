<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/security/core.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Don't override settings --%>
<c:if test="${empty data.settings.styleCode}">
	<c:import url="/brand/ctm/settings.xml" var="settingsXml" />
	<go:setData dataVar="data" value="*DELETE" xpath="settings" />
	<go:setData dataVar="data" xml="${settingsXml}" />
</c:if>

<c:set var="defaultTitle" value="Simples" />
<c:choose>
	<c:when test="${ empty(pageTitle) }">
		<c:set var="windowTitle" value="${defaultTitle}" />
		<c:set var="pageTitle" value="${defaultTitle}" />
	</c:when>
	<c:otherwise>
		<c:set var="windowTitle" value="${pageTitle} - ${defaultTitle}" />
	</c:otherwise>
</c:choose>

<%
response.setHeader("Cache-Control", "no-store, no-cache, must-invalidate, max-age=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "-1");
response.setHeader("X-UA-Compatible", "IE=edge");
%>



<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title><c:out value="${windowTitle}" /></title>
		<link rel="shortcut icon" type="image/x-icon" href="<c:url value="/common/images/favicon.ico" />">
		<link rel="stylesheet" href="<c:url value="/common/reset.css" />">
		<link rel="stylesheet" href="<c:url value="/common/base.css" />">
		<link rel="stylesheet" href="<c:url value="/brand/${data['settings/stylesheet']}" />">
		<link rel="stylesheet" href="<c:url value="/brand/${data['settings/security-stylesheet']}" />">
	</head>
	<body>
		<div id="wrapper" class="login">
			<div id="page">
				<div id="content">
					<h2>Simples</h2>
					<div id="app" class="qe-window fieldset">
						<h4><c:out value="${pageTitle}" /></h4>
						<div class="content">

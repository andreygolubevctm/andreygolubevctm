<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/security/core.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<core:load_settings conflictMode="false" />

<%-- Don't override settings --%>

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



<core:doctype />
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title><c:out value="${windowTitle}" /></title>
		<link rel="shortcut icon" type="image/x-icon" href="<c:url value="/common/images/favicon.ico" />">
		<link rel="stylesheet" href="<c:url value="/common/reset.css" />">
		<link rel="stylesheet" href="<c:url value="/common/base.css" />">
		<link rel="stylesheet" href="<c:url value="/brand/${data['settings/stylesheet']}" />">
		<link rel="stylesheet" href="<c:url value="/brand/${data['settings/security-stylesheet']}" />">

		<script type="text/javascript" src="common/js/logging.js"></script>

	<%-- jQuery, jQuery UI and plugins --%>
	<%-- <script type="text/javascript" src="common/js/jquery-1.4.2.min.js"></script> --%>
	<script type="text/javascript" src="common/js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="common/js/jquery-ui-1.8.22.custom.min.js"></script>

	<%-- <script type="text/javascript" src="common/js/jquery-ui-1.8.custom.min.js"></script> --%>
	<script type="text/javascript" src="common/js/jquery.address-1.3.2.js"></script>
	<script type="text/javascript" src="common/js/quote-engine.js"></script>
	<script type="text/javascript" src="common/js/scrollable.js"></script>
	<script type="text/javascript" src="common/js/jquery.tooltip.min.js"></script>
	<script type="text/javascript" src="common/js/jquery.corner-2.11.js"></script>
	<script type="text/javascript" src="common/js/jquery.numeric.pack.js"></script>
	<script type="text/javascript" src="common/js/jquery.scrollTo.js"></script>
	<script type="text/javascript" src="common/js/jquery.maxlength.js"></script>
	<script type="text/javascript" src="common/js/jquery.number.format.js"></script>
	<script type="text/javascript" src="common/js/jquery.titlecase.js"></script>
	<script type="text/javascript" src="common/js/jquery.aihcustom.js"></script>
	<script type="text/javascript" src="common/js/jquery.pngFix.pack.js"></script>
	<script type="text/javascript" src="common/js/jquery.validate-1.11.1.js"></script>
	</head>
	<body>
		<div id="wrapper" class="login">
			<div id="page">
				<div id="content">
					<h2>Simples</h2>
					<div id="app" class="qe-window fieldset">
						<h4><c:out value="${pageTitle}" /></h4>
						<div class="content">

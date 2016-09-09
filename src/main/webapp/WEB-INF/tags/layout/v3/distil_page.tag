<%@ tag description="Template for Distil's Blocked and Captcha Pages" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request" />
<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
<jsp:useBean id="newPage" class="com.ctm.web.core.web.NewPage" />
${newPage.init(pageContext.request, pageSettings)}

<%@ attribute name="title"		required="false"  rtexprvalue="true"	 description="The title of the page" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="false" name="head_meta" %>
<%@ attribute fragment="true" required="false" name="body_end" %>
<%@ attribute fragment="true" required="false" name="additional_meerkat_scripts" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="header_button_left" %>

<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="navbar_outer" %>
<%@ attribute fragment="true" required="false" name="navbar_additional" %>
<%@ attribute fragment="true" required="false" name="progress_bar" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>

<%@ attribute fragment="true" required="false" name="vertical_settings" %>
<%@ attribute fragment="true" required="false" name="before_close_body" %>

<core_v2:no_cache_header/>

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/" />

<!DOCTYPE html>
<go:html>
	<head>
		<%-- Google Optimise 360 --%>
		<c:if test="${empty callCentre or not callCentre}">
			<content:get key="googleOptimise360" />
		</c:if>

		<title>${title} - ${pageSettings.getSetting('brandName')}</title>
		<meta charset='utf-8'>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"><%-- 'maximum-scale' will disable zooming but also assists with iOS Viewport Scaling Bug on rotation --%><%-- user-scalable=no--%>
		<jsp:invoke fragment="head_meta" />

		<link rel="shortcut icon" type="image/x-icon" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/favicon.ico">

		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">

		<c:if test="${pageSettings.getSetting('appleTouchIconsEnabled') eq 'Y'}">
			<link rel="apple-touch-icon" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/phone.png">
			<link rel="apple-touch-icon" sizes="76x76" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/tablet.png">
			<link rel="apple-touch-icon" sizes="120x120" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/phone@2x.png">
			<link rel="apple-touch-icon" sizes="152x152" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/tablet@2x.png">
			<link rel="apple-touch-icon" sizes="180x180" href="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/touch-icons/phone@3x.png">
		</c:if>

		<c:set var="browserName" value="${userAgentSniffer.getBrowserName(pageContext.getRequest().getHeader('user-agent'))}" />
		<c:set var="browserVersion" value="${userAgentSniffer.getBrowserVersion(pageContext.getRequest().getHeader('user-agent'))}" />

		<%--  Modernizr --%>
		<script src='${assetUrl}js/bundles/plugins/modernizr.min.js'></script>

		<jsp:invoke fragment="head" />

			<%-- There's a bug in the JSTL parser which eats up the spaces between dynamic classes like this so using c:out sorts it out --%>
		<c:set var="bodyClass">
			<c:out value="${pageSettings.getVerticalCode()} ${callCentre ? ' callCentre simples' : ''} ${body_class_name}" />
		</c:set>
	</head>

	<body class="jeinit">

		<!--  content -->
		<jsp:doBody />

		<!--[if lt IE 9]>
		<script src="${assetUrl}js/bundles/plugins/respond.min.js"></script>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-1.11.3${pageSettings.getSetting('minifiedFileString')}.js">\x3C/script>');</script>
		<![endif]-->
		<!--[if gte IE 9]><!-->
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
		<script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-2.1.4${pageSettings.getSetting('minifiedFileString')}.js">\x3C/script>');</script>

		<jsp:invoke fragment="before_close_body" />

		<go:script>
			$(document).ready(function() {
				<go:insertmarker format="SCRIPT" name="onready" />
			});
		</go:script>
	</body>
</go:html>
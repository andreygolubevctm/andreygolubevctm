<%@ tag description="Template for Distil's Blocked and Captcha Pages" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request" />
<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
<jsp:useBean id="newPage" class="com.ctm.web.core.web.NewPage" />
${newPage.init(pageContext.request, pageSettings)}

<%@ attribute name="brandCode"  required="true"	 rtexprvalue="true"	 description="The brand code applicable to the page" %>

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

<%-- Variables --%>
<c:choose>
	<c:when test="${brandCode eq 'choo'}">
		<%-- No brandCode available in production implementation of this page
			 for Choosi so hardcode values - otherwise causes fatal error --%>
		<c:set var="GTMEnabled" value="${false}" />
		<c:set var="GTMPropertyId" value="" />
		<c:set var="assetUrl" value="/app/assets/" />
		<c:set var="brandName" value="Choosi" />
		<c:set var="appleTouchIconsEnabled" value="${false}" />
		<c:set var="minifiedFileString" value=".min" />
	</c:when>
	<c:otherwise>
		<c:set var="GTMEnabled" value="${pageSettings.getSetting('GTMEnabled') eq 'Y'}" />
		<c:set var="GTMPropertyId">
			<c:if test="${GTMEnabled eq true and not empty pageSettings and pageSettings.hasSetting('GTMPropertyId')}">
				${pageSettings.getSetting('GTMPropertyId')}
			</c:if>
		</c:set>
		<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/" />
		<c:set var="brandName" value="${pageSettings.getSetting('brandName')}" />
		<c:set var="appleTouchIconsEnabled" value="${pageSettings.getSetting('appleTouchIconsEnabled') eq 'Y'}" />
		<c:set var="minifiedFileString" value="${pageSettings.getSetting('minifiedFileString')}" />
	</c:otherwise>
</c:choose>

<!DOCTYPE html>
<go:html>
	<head>
		<%-- Google Optimise 360 --%>
		<c:if test="${empty callCentre or not callCentre}">
			<content:get key="googleOptimise360" />
		</c:if>

		<title>${title} - ${brandName}</title>
		<meta charset='utf-8'>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"><%-- 'maximum-scale' will disable zooming but also assists with iOS Viewport Scaling Bug on rotation --%><%-- user-scalable=no--%>
		<jsp:invoke fragment="head_meta" />

		<link rel="shortcut icon" type="image/x-icon" href="${assetUrl}brand/${brandCode}/graphics/favicon.ico?new">

		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">

		<c:if test="${appleTouchIconsEnabled eq true}">
			<link rel="apple-touch-icon" href="${assetUrl}brand/${brandCode}/graphics/touch-icons/phone.png">
			<link rel="apple-touch-icon" sizes="76x76" href="${assetUrl}brand/${brandCode}/graphics/touch-icons/tablet.png">
			<link rel="apple-touch-icon" sizes="120x120" href="${assetUrl}brand/${brandCode}/graphics/touch-icons/phone@2x.png">
			<link rel="apple-touch-icon" sizes="152x152" href="${assetUrl}brand/${brandCode}/graphics/touch-icons/tablet@2x.png">
			<link rel="apple-touch-icon" sizes="180x180" href="${assetUrl}brand/${brandCode}/graphics/touch-icons/phone@3x.png">
		</c:if>

		<c:set var="browserName" value="${userAgentSniffer.getBrowserName(pageContext.getRequest().getHeader('user-agent'))}" />
		<c:set var="browserVersion" value="${userAgentSniffer.getBrowserVersion(pageContext.getRequest().getHeader('user-agent'))}" />

		<%--  Modernizr --%>
		<script src='${assetUrl}js/bundles/plugins/modernizr.min.js'></script>

		<jsp:invoke fragment="head" />

			<%-- There's a bug in the JSTL parser which eats up the spaces between dynamic classes like this so using c:out sorts it out --%>
		<c:set var="bodyClass">
			<c:out value="${body_class_name}" />
		</c:set>
	</head>

	<body class="jeinit ${brandCode}">

		<c:if test="${GTMEnabled eq true and not empty GTMPropertyId}">
			<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
					new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
					j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
					'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
			})(window,document,'script','CtMDataLayer','${GTMPropertyId}');</script>
		</c:if>

		<!--  content -->
		<jsp:doBody />

		<!--[if lt IE 9]>
		<script src="${assetUrl}js/bundles/plugins/respond.min.js"></script>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-1.11.3${minifiedFileString}.js">\x3C/script>');</script>
		<![endif]-->
		<!--[if gte IE 9]><!-->
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
		<script>window.jQuery && window.jQuery.each || document.write('<script src="${assetUrl}libraries/jquery/js/jquery-2.1.4${minifiedFileString}.js">\x3C/script>');</script>

		<jsp:invoke fragment="before_close_body" />

		<go:script>
			$(document).ready(function() {
				<go:insertmarker format="SCRIPT" name="onready" />
			});
		</go:script>
	</body>
</go:html>
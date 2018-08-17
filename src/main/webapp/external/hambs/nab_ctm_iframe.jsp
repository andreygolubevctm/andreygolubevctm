<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<settings:setVertical verticalCode="GENERIC" />

<%-- GET CTM HOST ORIGIN --%>
<c:set var="ctmHostOrigin">${pageSettings.getRootUrl()}</c:set>
<%-- Remove trailing slash if any --%>
<c:if test="${fn:endsWith(ctmHostOrigin, '/')}">
	<c:set var="ctmHostOrigin">${fn:substring( ctmHostOrigin, 0, fn:length(ctmHostOrigin)-1 )}</c:set>
</c:if>

<%-- GET HOST ORIGIN BASED ON RECEIVED BRAND --%>
<c:set var="originSettings" value="${settingsService.getPageSettingsByCode(param.b,'GENERIC')}"/>
<c:set var="hostOrigin">${originSettings.getRootUrl()}</c:set>
<%-- Remove trailing slash if any --%>
<c:if test="${fn:endsWith(hostOrigin, '/')}">
	<c:set var="hostOrigin">${fn:substring( hostOrigin, 0, fn:length(hostOrigin)-1 )}</c:set>
</c:if>

<%-- TODO: move this over to the database --%>
<c:if test="${not empty param.providerCode}">
	<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
	<c:set var="configUrl">/WEB-INF/aggregator/health_application/${param.providerCode}/config.xml</c:set>
	<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, configUrl)}" />
	<x:parse var="configXml" doc="${config}" />
	<c:set var="gatewayURL" scope="page" ><x:out select="$configXml//*[name()='nabGateway']/*[name()='gatewayURL']" /></c:set>
	<c:set var="gatewayDomain" scope="page"><x:out select="$configXml//*[name()='nabGateway']/*[name()='domain']" /></c:set>
</c:if>

<!DOCTYPE html>
<html>
	<head>
		<title>NAB Payment Gateway</title>

		<base href="${pageSettings.getBaseUrl()}" />

		<!--[if lt IE 9]>
			<script src="framework/lib/js/respond.ctm.js"></script>
			<script>window.jQuery && window.jQuery.each || document.write('<script src="framework/jquery/lib/jquery-1.10.2.min.js"><\/script>')</script>
		<![endif]-->
		<!--[if gte IE 9]><!-->
			<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
			<script>window.jQuery && window.jQuery.each || document.write('<script src="framework/jquery/lib/jquery-2.0.3.min.js">\x3C/script>')</script>
		<!--<![endif]-->

		<style>
			html,body{height:100%;}.spinner{margin:10px auto;width:50px;text-align:center}.spinner>div{width:10px;height:10px;background-color:#333;margin:auto 2px;border-radius:100%;display:inline-block;-webkit-animation:bouncedelay 1.4s infinite ease-in-out;animation:bouncedelay 1.4s infinite ease-in-out;-webkit-animation-fill-mode:both;animation-fill-mode:both}.spinner .bounce1{-webkit-animation-delay:-0.32s;animation-delay:-0.32s}.spinner .bounce2{-webkit-animation-delay:-0.16s;animation-delay:-0.16s}@-webkit-keyframes bouncedelay{0%,80%,100%{-webkit-transform:scale(0)}40%{-webkit-transform:scale(1)}}@keyframes bouncedelay{0%,80%,100%{transform:scale(0);-webkit-transform:scale(0)}40%{transform:scale(1);-webkit-transform:scale(1)}}
		</style>
	</head>

	<body>
		<div id="loadingMessage">
			<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>
		</div>
		<iframe id="hambsIframe" onload="loadComplete();" style="display:none;" src="${gatewayURL}?hostOrigin=${ctmHostOrigin}" width="100%" height="100%" frameBorder="0"></iframe>

		<script>
			if (window.addEventListener) {
				window.addEventListener("message", onMessageFromHambs, false);
			} else if (window.attachEvent) { // IE8
				window.attachEvent("onmessage", onMessageFromHambs);
			}

			function onMessageFromHambs(e){
				if(e.origin !== '${gatewayDomain}')
					return;

				parent.postMessage(
					e.data,
					'${hostOrigin}'
				);
			}

			function loadComplete() {
				$('#loadingMessage').hide();
				$('#hambsIframe').show();
			}
		</script>
	</body>
</html>

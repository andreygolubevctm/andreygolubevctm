<%@ tag description="The Page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="title"			required="false"  rtexprvalue="true"	 description="The title of the page" %>
<%@ attribute name="kampyle"		required="false"  rtexprvalue="true"	 description="Whether to display Kampyle or not" %>
<%@ attribute name="sessionPop"		required="false"  rtexprvalue="true"	 description="Whether to load the session pop" %>
<%@ attribute name="supertag"		required="false"  rtexprvalue="true"	 description="Whether to load supertag or not" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="body_end" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>

<core_new:no_cache_header/>

<%-- Variables --%>
<c:set var="isDev" value="${environmentService.getEnvironmentAsString() eq 'localhost' || environmentService.getEnvironmentAsString() eq 'NXI'}"/>

<!DOCTYPE html>
<go:html>
	<head >
		<title>${title} - ${pageSettings.getSetting('brandName')}</title>
		<meta charset='utf-8'>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"><%-- 'maximum-scale' will disable zooming but also assists with iOS Viewport Scaling Bug on rotation --%><%-- user-scalable=no--%>
		<jsp:invoke fragment="head_meta" />

		<link rel="shortcut icon" type="image/x-icon" href="brand/${pageSettings.getBrandCode()}/graphics/favicon.ico">
		<link rel="stylesheet" href="brand/${pageSettings.getBrandCode()}/css/${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.css" media="all">
		<link rel="stylesheet" href="brand/${pageSettings.getBrandCode()}/css/${pageSettings.getVerticalCode()}.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.css" media="all">

		<!--  Modernizr -->
			<c:if test="${isDev eq false}">
				<script src='//cdnjs.cloudflare.com/ajax/libs/modernizr/2.7.1/modernizr.min.js'></script>
			</c:if>
			<script>window.Modernizr || document.write('<script src="framework/lib/js/modernizr-2.7.1.min.js">\x3C/script>')</script>

		<!--[if lt IE 9]>
			<script src="framework/lib/js/respond.ctm.js"></script>
			<script>window.jQuery && window.jQuery.each || document.write('<script src="framework/jquery/lib/jquery-1.10.2.min.js"><\/script>')</script>
		<![endif]-->
		<!--[if gte IE 9]><!-->
			<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
			<script>window.jQuery && window.jQuery.each || document.write('<script src="framework/jquery/lib/jquery-2.0.3.min.js">\x3C/script>')</script>
		<!--<![endif]-->

		<script src="brand/${pageSettings.getBrandCode()}/js/bootstrap.${pageSettings.getBrandCode()}.min.js"></script>

		<script src="framework/jquery/plugins/jquery.validate-1.11.1.js"></script>


		<go:insertmarker format="HTML" name="js-href" />
		<go:script>
			<form_new:validation />
			<go:insertmarker format="SCRIPT" name="js-head" />
		</go:script>

		<go:script>
			$(document).ready(function(){
				<go:insertmarker format="SCRIPT" name="onready" />
			});
		</go:script>

		<jsp:invoke fragment="head" />

	</head>

	<body class="jeinit ${pageSettings.getVerticalCode()} ${callCentre ? ' callCentre simples' : ''}">

	<!-- body content -->

		<header>
			<nav class="navbar navbar-multi-collapse dropdown-interactive-base" role="navigation">

				<div class="container">

					<div class="col-sm-12">
						<%-- Brand and toggle get grouped for better mobile display --%>
						<div class="navbar-header header-buttons-logos">
							<button type="button" class="navbar-toggle contact collapsed pull-left" data-toggle="collapse" data-target=".header-collapse-contact">
								<span class="sr-only">Toggle Contact Us</span>
								<span class="icon icon-phone"></span>
								<span class="icon icon-cross"></span>
							</button>
							<button type="button" class="navbar-toggle hamburger collapsed xs-nav-bar-toggler" >
								<span class="sr-only">Toggle Navigation</span>
								<span class="icon icon-menu"></span>
								<span class="icon icon-cross"></span>
							</button>

								<span id="logo" class="navbar-brand text-hide">${pageSettings.getSetting('windowTitle')}</span>
						</div>

						<jsp:invoke fragment="header" />

					</div>

					<div class="collapse navbar-collapse">
						<ul class="journeyProgressBar"></ul>
					</div>

				</div>

				<div id="navbar-main" class="navbar-affix navbar-default navbar-collapse navbar-collapse-menu collapse">
					<div class="row">
						<div class="container">
							<jsp:invoke fragment="navbar" />
						</div>
					</div>
				</div>

			</nav>

			<%-- XS Results Pagination --%>
			<div class="navbar navbar-default xs-results-pagination visible-xs">
				<jsp:invoke fragment="xs_results_pagination" />
			</div>

		</header>

		<!--  Supertag -->
			<c:if test="${supertag eq true and not empty pageSettings}">
				<agg:supertag_top type="${go:TitleCase(pageSettings.getVerticalCode())}" initialPageName="${pageSettings.getSetting('supertagInitialPageName')}" useCustomJs="false"/>
			</c:if>

		<!--  content -->
			<jsp:doBody />

		<!--  Includes -->
			<agg:includes kampyle="${kampyle}" supertag="${supertag}" sessionPop="${sessionPop}" loading="false" fatalError="false"/>

	<!-- JS Libraries -->

		<!--  Underscore -->
			<c:if test="${isDev eq false}">
				<script src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min.js"></script>
			</c:if>
			<script>window._ || document.write('<script src="framework/lib/js/underscore-1.5.2.min.js">\x3C/script>')</script>

		<!-- Fastclick -->
			<c:if test="${isDev eq false}">
				<script src="//cdnjs.cloudflare.com/ajax/libs/fastclick/0.6.11/fastclick.min.js"></script>
			</c:if>
			<script>window.FastClick || document.write('<script src="framework/lib/js/fastclick-0.6.11.min.js">\x3C/script>')</script>

		<!-- Extras -->
			<script type="text/javascript" src="framework/jquery/plugins/typeahead-0.9.3_custom.js"></script>
			<script type="text/javascript" src="framework/jquery/plugins/qtip2/jquery.qtip.js"></script>
			<script src="common/javascript/utilities.js"></script>

		<!--  Meerkat -->
			<script src="brand/${pageSettings.getBrandCode()}/js/modules.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.js"></script>
			<script src="brand/${pageSettings.getBrandCode()}/js/${pageSettings.getVerticalCode()}.modules.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.js"></script>


			<script>

				;(function (meerkat) {

					var siteConfig = {
						title: '${title} - ${pageSettings.getSetting("windowTitle")}',
						name: '${pageSettings.getSetting("brandName")}',
						vertical: '${pageSettings.getVerticalCode()}',
						isDev: ${isDev}, //boolean determined from conditions above in this tag
						isCallCentreUser: <c:out value="${not empty callCentre}"/>,
						environment: '${fn:toLowerCase(environmentService.getEnvironmentAsString())}',
						//could be: localhost, integration, qa, staging, prelive, prod
						<c:if test="${not empty data.current.transactionId}">initialTransactionId: ${data.current.transactionId},</c:if>
						// DO NOT rely on this variable to get the transaction ID, it gets wiped by the transactionId module. Use transactionId.get() instead
						urls:{
							base: '${fn:toLowerCase(pageSettings.getBaseUrl())}',
							exit: '${fn:toLowerCase(pageSettings.getSetting("exitUrl"))}'
						}
					};
					var options = {};
					meerkat != null && meerkat.init(siteConfig, options);

				})(window.meerkat);

			</script>

			<script>
				// TODO PUT THIS SOMEWHERE ELSE
				_.templateSettings = {
				evaluate:    /\{\{(.+?)\}\}/g, // {{= console.log("blah") }}
				interpolate: /\{\{=(.+?)\}\}/g, // {{ title }}
				escape:      /\{\{-(.+?)\}\}/g // {{{ title }}}
				};

			</script>


		<!-- Body End Fragment -->
			<jsp:invoke fragment="body_end" />

		<div id="dynamic_dom">

		</div>

	</body>
</go:html>
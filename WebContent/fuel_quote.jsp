<%--
	FUEL quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="FUEL" authenticated="true" />

<core_new:quote_check quoteType="fuel" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="fuel" />
</c:if>

<%-- Check requests from IP and throw 429 if limit exceeded. --%>
<jsp:useBean id="sessionDataService" class="com.ctm.services.SessionDataService" />
<jsp:useBean id="ipCheckService" class="com.ctm.services.IPCheckService" />
<c:choose>
	<%-- Remove session and throw 429 error if request limit exceeded --%>
	<c:when test="${!ipCheckService.isWithinLimitAsBoolean(pageContext.request, pageSettings)}">
		<c:set var="removeSession" value="${sessionDataService.removeSessionForTransactionId(pageContext.request, data.current.transactionId)}" />
	<%	response.sendError(429, "Number of requests exceeded!" ); %>
	</c:when>
	<%-- Only proceed if number of requests not exceeded --%>
	<c:otherwise>
		<core_new:load_preload />

		<%-- HTML --%>
		<layout:journey_engine_page title="Fuel Quote">

			<jsp:attribute name="head"></jsp:attribute>

			<jsp:attribute name="head_meta">
				<meta name="apple-mobile-web-app-title" content="Fuel Prices">
			</jsp:attribute>

			<jsp:attribute name="header">
				<div class="navbar-collapse header-collapse-contact collapse">
					<ul class="nav navbar-nav navbar-right">
						<li class="navbar-text push-top">
							<div class="hidden-xs resultsSummaryContainer" data-livechat="target">
								<h5 class="hidden-sm">Fuel prices for</h5>
								<div id="resultsSummaryPlaceholder"></div>
							</div>
						</li>
					</ul>
				</div>
			</jsp:attribute>

			<jsp:attribute name="navbar">
				<ul class="nav navbar-nav" role="menu">
					<li class="visible-xs">
						<span class="navbar-text-block navMenu-header">Menu</span>
					</li>

					<li class="slide-feature-back">
						<a href="javascript:;" data-slide-control="previous" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
					</li>
					<li class="slide-feature-price-history view-price-history hidden-sm hidden-md hidden-lg">
						<a href="javascript:;" class="openPriceHistory needsclick btn-email">
							<span class="icon icon-clock"></span>
							<span>View Price History</span>
						</a>
					</li>
					<li class="dropdown dropdown-interactive slide-feature-emailquote" id="email-quote-dropdown">
						<a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;">
							<span class="icon icon-envelope"></span>
							<span>Sign Up for News and Offers!</span>
							<b class="caret"></b>
						</a>
						<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
							<div class="dropdown-container">
								<fuel_new:sign_up />
							</div>
						</div>
					</li>
				</ul>
				<div class="collapse navbar-collapse">
					<ul class="nav navbar-nav navbar-right">
						<li class="slide-feature-price-history view-price-history">
							<a href="javascript:;" class="openPriceHistory needsclick btn-email">
								<span class="icon icon-clock"></span>
								<span>View Price History</span>
							</a>
						</li>
					</ul>
				</div>
			</jsp:attribute>

			<jsp:attribute name="navbar_additional"></jsp:attribute>

			<jsp:attribute name="navbar_outer">
				<div class="row sortbar-container navbar-inverse">
					<div class="container">
						<ul class="sortbar-parent nav navbar-nav navbar-inverse col-sm-12 row">
							<li class="visible-xs">
								<a href="javascript:;" class="">
									<span class="icon icon-filter"></span> <span>Sort Results By</span>
								</a>
							</li>
							<li class="container row sortbar-children">
								<ul class="nav navbar-nav navbar-inverse col-sm-12">
									<li class="col-sm-3 col-sm-push-6 col-md-push-7 hidden-xs">
										<a href="javascript:;" class="sortbar-title force-no-hover"><span class="icon"></span> <span>Type</span></a>
									</li>
									<li class="col-sm-3 col-md-2 col-sm-push-6 col-md-push-7 active">
										<a href="javascript:;" data-sort-type="price.premium" data-sort-dir="asc"><span class="icon"></span> <span>Price</span></a>
									</li>
								</ul>
							</li>
						</ul>
					</div>
				</div>
			</jsp:attribute>

			<jsp:attribute name="results_loading_message"></jsp:attribute>


			<jsp:attribute name="form_bottom"></jsp:attribute>

			<jsp:attribute name="footer">
				<core:whitelabeled_footer />
			</jsp:attribute>

			<jsp:attribute name="vertical_settings">
				<fuel_new:settings />
			</jsp:attribute>
						 

			<jsp:attribute name="body_end">
				<script type="text/javascript" src="https://www.google.com/jsapi"></script>
			</jsp:attribute>

			<jsp:body>
				<%-- Slides --%>
				<fuel_new_layout:slide_details />
				<fuel_new_layout:slide_results />
					
					<form:help />

				<div class="hiddenFields">
					<form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
					<core:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
				</div>

				<input type="hidden" name="transcheck" id="transcheck" value="1" />
			</jsp:body>

		</layout:journey_engine_page>
	</c:otherwise>
</c:choose>
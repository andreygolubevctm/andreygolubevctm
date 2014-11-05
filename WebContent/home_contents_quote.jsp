<%--
	HOME quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="HOME" authenticated="true" />

<fmt:setLocale value="en_AU" scope="session" />

<core:quote_check quoteType="home" />
<core_new:load_preload />

<%-- Call centre numbers --%>
<c:set var="callCentreNumber" scope="request"><content:get key="homeCallCentreNumber"/></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="homeCallCentreHelpNumber"/></c:set>

<%-- HTML --%>
<layout:journey_engine_page title="Home & Contents Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
		<%-- Kitchen Sink Comment: If your vertical has no intention of having a call centre,
		empty the contents of this fragment. --%>
		<div class="navbar-collapse header-collapse-contact collapse">
			<ul class="nav navbar-nav navbar-right">
				<c:if test="${not empty callCentreNumber}">
					<li>
						<div class="navbar-text visible-xs">
							<h4>Do you need a hand?</h4>
							<h1>
								<a class="needsclick" href="tel:${callCentreNumber}">Call <span class="noWrap">${callCentreNumber}</span></a>
							</h1>
							<p class="small">Our Australian based call centre hours are</p>
							<p>
								<%-- Global chat open hours. Use content control if you wish to override. --%>
								<form:scrape id='135' />
							</p>
							${callCentreSpecialHoursContent}
						</div>
						<div class="navbar-text hidden-xs" data-livechat="target">
							<h4>Call us on</h4>
							<h1>
								<span class="noWrap">${callCentreNumber}</span>
							</h1>
						</div>
						<div class="navbar-text hidden-xs" data-poweredby="header">&nbsp;</div>
					</li>
				</c:if>
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

			<%-- Save quote for off canvas menu --%>
			<li class="slide-feature-emailquote hidden-lg hidden-md hidden-sm" data-openSaveQuote="true">
				<a href="javascript:;" class="save-quote-openAsModal"><span class="icon icon-envelope"></span> <span><c:choose>
							<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
							<c:otherwise>Save Quote</c:otherwise>
						</c:choose></span> <b class="caret"></b></a>
			</li>

			<li class="dropdown dropdown-interactive slide-edit-quote-dropdown" id="edit-details-dropdown">
				<a class="activator needsclick dropdown-toggle btn-back" data-toggle="dropdown" href="javascript:;"><span class="icon icon-cog"></span>
				<span>Edit Details</span> <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<div class="dropdown-container">
						<home_new:edit_details />
					</div>
				</div>
			</li>

			<li class="dropdown dropdown-interactive slide-feature-emailquote hidden-xs" id="email-quote-dropdown">
				<a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;"><span class="icon icon-envelope"></span> <span><c:choose>
							<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
							<c:otherwise>Save Quote</c:otherwise>
						</c:choose></span> <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<div class="dropdown-container">
						<agg_new:save_quote includeCallMeback="false" />
					</div>
				</div>
			</li>

			<li class="dropdown dropdown-interactive slide-feature-filters hidden-sm hidden-md hidden-lg" id="filters-dropdown">
				<a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-filter"></span> <span>Filter</span><span class="hidden-sm"> Results</span> <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
				</div>
			</li>

			<%-- Displays the Reference Number at the end of the menu. --%>
			<li class="navbar-text hidden">
				<form_new:reference_number />
			</li>
		</ul>
		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true">
				<li class="navbar-text hidden pagination-label">See more results</li>
			</ul>
		</div>

	</jsp:attribute>

	<jsp:attribute name="navbar_additional">
		<nav id="navbar-filter" class="navbar navbar-default navbar-affix navbar-inverse hidden hidden-xs" data-affix-after="#navbar-main">
			<div class="container">
				<ul class="nav navbar-nav">
					<li class="navbar-text filter-label">Payment Frequency</li>
					<li class="dropdown filter-frequency">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Freq</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu">
						</ul>
					</li>
					<li class="navbar-text filter-label homeExcessLabel">Home Excess</li>
					<li class="dropdown filter-excess homeExcess">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Home Excess</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu">
						</ul>
					</li>
					<li class="navbar-text filter-label contentsExcessLabel">Contents Excess</li>
					<li class="dropdown filter-excess contentsExcess">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Contents Excess</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu">
						</ul>
					</li>
					<li class="excess-update"><a href="javascript:void(0);" class="btn btn-hollow updateExcess" data-toggle="updateButton">update</a>
					</li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li class="filter-pricemode"><a href="javascript:void(0);"><span class="icon icon-th-list"></span> Quick price<span class="hidden-md hidden-sm"> view</span></a></li>
					<li class="filter-featuresmode"><a href="javascript:void(0);"><span class="icon icon-th-vert"></span> Product features<span class="hidden-md hidden-sm"> view</span></a></li>
					<li class="back-to-price-mode hidden"><a href="javascript:void(0);"><span class="icon icon-arrow-left"></span> Back</a></li>
				</ul>
			</div>
		</nav>
		<%-- The content of the container is appended only when a comparison is made. --%>
		<nav id="navbar-compare" class="navbar navbar-default navbar-affix navbar-additional hidden-xs" data-affix-after="#navbar-main">
			<div class="container compare-basket">
			</div>
		</nav>
	</jsp:attribute>

	<jsp:attribute name="navbar_outer">
	</jsp:attribute>

	<jsp:attribute name="results_loading_message">
		<%-- Kitchen Sink Comment: If you need to show a custom compliance message while loading results (see Car) --%>
	</jsp:attribute>


	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<home_new:footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<home_new:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:body>

		<div class="hiddenFields">
			<form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
			<core:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		</div>

		<%-- Slides --%>
		<home_new_layout:slide_cover_type />
		<home_new_layout:slide_occupancy />
		<home_new_layout:slide_your_property />
		<home_new_layout:slide_policy_holders />
		<home_new_layout:slide_history />
		<home_new_layout:slide_results />

		<input type="hidden" name="transcheck" id="transcheck" value="1" />

	</jsp:body>

</layout:journey_engine_page>
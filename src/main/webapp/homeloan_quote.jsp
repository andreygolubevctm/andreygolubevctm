<%--
	HOMELOAN quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="HOMELOAN" authenticated="true" />

<core_new:quote_check quoteType="homeloan" />
<core_new:load_preload />

<%-- Initialise Save Quote --%>
<c:set var="saveQuoteEnabled" scope="request">${pageSettings.getSetting('saveQuote')}</c:set>

<%-- HTML --%>
<layout:journey_engine_page title="Home Loan Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
		<div class="row navbar-collapse header-collapse-contact collapse">
			<div class="blank-enquire">
				<%-- <div class="col-sm-3 col-sm-offset-0 col-lg-offset-2">
					<h5 class="text-right">Need help choosing?</h5>
				</div> --%>
				<div class="col-sm-3 col-lg-2 col-sm-offset-3 col-lg-offset-5 pull-right">
					<a class="btn btn-cta btn-block btn-enquire-now hidden-xs" href="javascript:;">General enquiry <span class="icon icon-arrow-right"></span></a>
		</div>
			</div>
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

			<c:if test="${saveQuoteEnabled == 'Y'}">
				<li class="slide-feature-emailquote hidden-lg hidden-md hidden-sm" data-openSaveQuote="true">
					<a href="javascript:;" class="save-quote-openAsModal"><span class="icon icon-envelope"></span> <span><c:choose>
						<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
						<c:otherwise>Save Quote</c:otherwise>
					</c:choose></span> <b class="caret"></b></a>
				</li>
			</c:if>

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

			<li class="dropdown dropdown-interactive slide-feature-filters hidden-xs" id="filters-dropdown">
				<a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);">
				<span class="icon icon-filter"></span> Filter Results <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<homeloan:filters />
				</div>
			</li>

			<li class="slide-feature-filters hidden-sm hidden-md hidden-lg" id="filters-modal">
				<a href="javascript:;"><span class="icon icon-filter"></span> <span>Filter Results</span></a>
			</li>

			<%-- Displays the Reference Number at the end of the menu. --%>
			<li class="navbar-text hidden">
				<form_new:reference_number />
			</li>
		</ul>
		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
		</div>

	</jsp:attribute>

	<jsp:attribute name="navbar_additional">
	<%-- The content of the container is appended only when a comparison is made. --%>
		<nav id="navbar-compare" class="navbar navbar-default navbar-affix navbar-additional hidden-xs hidden" data-affix-after="#navbar-main">
			<div class="container compare-basket">
			</div>
		</nav>
	</jsp:attribute>

	<jsp:attribute name="navbar_outer">
	</jsp:attribute>

	<jsp:attribute name="results_loading_message">
	</jsp:attribute>


	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<homeloan:footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<homeloan:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:body>

		<div class="hiddenFields">
			<field:hidden xpath="homeloan/renderingMode" />
			<form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
			<core:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		</div>

		<%-- Slides --%>
		<homeloan_layout:slide_your_details />
		<homeloan_layout:slide_results />
		<homeloan_layout:slide_enquiry />
<%--		<homeloan_layout:slide_confirmation />
--%>

		<input type="hidden" name="transcheck" id="transcheck" value="1" />

	</jsp:body>

</layout:journey_engine_page>
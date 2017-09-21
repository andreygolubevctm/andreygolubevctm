<%--
	HOME quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="HOME" authenticated="true" />

<fmt:setLocale value="en_AU" scope="session" />

<core_v2:quote_check quoteType="home" />
<core_v2:load_preload />

<%-- Call centre numbers --%>
<c:set var="saveQuoteEnabled" scope="request">${pageSettings.getSetting('saveQuote')}</c:set>

<%-- Set global variable to flags for active split tests --%>
<home:splittest_helper />

<%-- Load in form values from brochure site --%>
<home:passed_params />

<%-- HTML --%>
<layout_v1:journey_engine_page title="Home & Contents Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>


	<jsp:attribute name="progress_bar">
      <div class="progress-bar-row collapse navbar-collapse">
		  <div class="container">
			  <ul class="journeyProgressBar_v2"></ul>
		  </div>
	  </div>
    </jsp:attribute>

	<jsp:attribute name="navbar">

		<ul class="nav navbar-nav" role="menu">
			<core_v2:offcanvas_header />

			<li class="slide-feature-back">
				<a href="javascript:;" data-slide-control="previous" class="btn-back" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />><span class="icon icon-arrow-left"></span> <span>Back</span></a>
			</li>

			<%-- Save quote for off canvas menu --%>
			<c:if test="${saveQuoteEnabled == 'Y'}">
			<li class="slide-feature-emailquote hidden-lg hidden-md hidden-sm" data-openSaveQuote="true">
				<a href="javascript:;" class="save-quote-openAsModal"><span class="icon icon-envelope"></span> <span><c:choose>
							<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
							<c:otherwise>Save Quote</c:otherwise>
						</c:choose></span> <b class="caret"></b></a>
			</li>
			</c:if>

			<li class="dropdown dropdown-interactive slide-edit-quote-dropdown" id="edit-details-dropdown">
				<a class="activator needsclick dropdown-toggle btn-back" data-toggle="dropdown" href="javascript:;" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />><span class="icon icon-cog"></span>
				<span>Edit Details</span> <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<div class="dropdown-container">
						<c:choose>
							<c:when test="${journeySplitTestActive eq true}">
								<home:edit_details_v2 />
							</c:when>
							<c:otherwise>
								<home:edit_details />
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</li>

			<c:if test="${saveQuoteEnabled == 'Y'}">
			<li class="dropdown dropdown-interactive slide-feature-emailquote hidden-xs" id="email-quote-dropdown">
				<a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" /> ><span class="icon icon-envelope"></span> <span><c:choose>
							<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
							<c:otherwise>Save Quote</c:otherwise>
						</c:choose></span> <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<div class="dropdown-container">
						<agg_v2:save_quote includeCallMeback="false" />
					</div>
				</div>
			</li>
			</c:if>

			<li class="dropdown dropdown-interactive slide-feature-filters hidden-sm hidden-md hidden-lg" id="filters-dropdown">
				<a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-filter"></span> <span>Filter</span><span class="hidden-sm"> Results</span> <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
				</div>
			</li>

			<%-- Displays the Reference Number at the end of the menu. --%>
			<li class="navbar-text hidden">
				<form_v2:reference_number />
			</li>
		</ul>
		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true">
				<li class="navbar-text hidden pagination-label">See more results</li>
			</ul>
		</div>

		<agg_v1:inclusive_gst className="nav navbar-right" />
	</jsp:attribute>

	<jsp:attribute name="navbar_additional">
		<nav id="navbar-filter" class="navbar navbar-default navbar-affix navbar-inverse hidden hidden-xs" data-affix-after="#navbar-main">
			<div class="container">
				<ul class="nav navbar-nav">
					<li class="dropdown filter-excess homeExcess">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Home Excess</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu">
						</ul>
					</li>
					<li class="dropdown filter-excess contentsExcess">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Contents Excess</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu">
						</ul>
					</li>
					<li class="dropdown landlordShowAll isLandlord">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Show all</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu landlord-filter-items">
							<li class="checkbox"><input type="checkbox" checked name="showall" id="showall" /> <label for="showall" class=""></label>Show All</li>
							<span>Only show products that include:</span>
							<li class="checkbox"><input type="checkbox" name="lossrent" id="lossrent" /> <label for="lossrent"></label>Loss of rent</li>
							<li class="checkbox"><input type="checkbox" name="malt" id="malt" /> <label for="malt"></label>Malicious damage</li>
							<li class="checkbox"><input type="checkbox" name="rdef" id="rdef" /> <label for="rdef"></label>Tenant default</li>
						</ul>
					</li>
					<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="nav button" quoteChar="\"" /></c:set>
					<li class="excess-update"><a href="javascript:void(0);" class="btn btn-hollow updateFilters hidden" data-toggle="updateButton" ${analyticsAttr}>update</a>
					</li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown filter-frequency">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Freq</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu">
						</ul>
					</li>
					<li class="filter-pricemode"><a href="javascript:void(0);" ${analyticsAttr}><span class="icon icon-th-list"></span> Quick price</a></li>
					<li class="filter-featuresmode"><a href="javascript:void(0);" ${analyticsAttr}><span class="icon icon-th-vert"></span> Product features</a></li>
					<li class="back-to-price-mode hidden"><a href="javascript:void(0);"><span class="icon icon-arrow-left"></span> Back</a></li>
				</ul>
			</div>
		</nav>

		<nav id="navbar-filter-labels" class="navbar hidden hidden-xs">
			<div class="container">
				<ul class="nav navbar-nav">
					<span class="isLandlord landlord-navbar-text">
						<li class="navbar-text filter-home-excess-label">Building Excess</li>
					</span>
					<span class="notLandlord landlord-navbar-text">
						<li class="navbar-text filter-home-excess-label">Home Excess</li>
					</span>
					<li class="navbar-text filter-contents-excess-label">Contents Excess</li>
					<span class="isLandlord landlord-navbar-text">
						<li class="navbar-text filter-contents-excess-label">Landlord Filters</li>
					</span>
					<li class="navbar-text filter-cancel-label"><a href="javascript:void(0);" class="hidden">Cancel</a></li>
				</ul>

				<ul class="nav navbar-nav navbar-right">
					<li class="navbar-text filter-frequency-label">Payment Frequency</li>
					<li class="navbar-text filter-view-label">View</li>
				</ul>
			</div>
		</nav>
		<%-- The content of the container is appended only when a comparison is made. --%>

		<nav id="navbar-compare" class="compare-v2 navbar hidden-xs hidden">
			<div class="navbar-additional clearfix compare-basket">
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
		<competition:mobileFooter vertical="home and/or contents" />
		<home:footer />
	</jsp:attribute>

    <jsp:attribute name="xs_results_pagination">
		<div class="navbar navbar-default xs-results-pagination navMenu-row-fixed visible-xs">
            <div class="container">
                <ul class="nav navbar-nav ">
                    <li class="navbar-text center hidden" data-results-pagination-pagetext="true"></li>

                    <li>
                        <a data-results-pagination-control="previous" href="javascript:;" class="btn-pagination" data-analytics="pagination previous"><span class="icon icon-arrow-left"></span>
                            Prev</a>
                    </li>

                    <li class="right">
                        <a data-results-pagination-control="next" href="javascript:;" class="btn-pagination " data-analytics="pagination next">Next <span class="icon icon-arrow-right"></span></a>
                    </li>
                </ul>
            </div>
        </div>
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<home:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:body>

		<div class="hiddenFields">
			<field_v1:hidden xpath="home/renderingMode" />
			<form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
			<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		</div>

		<c:if test="${simplifiedJourneySplitTestActive}">
			<agg_v1:button_tile_dropdown_selector_template />
		</c:if>

		<%-- Slides --%>
		<home_layout:slide_cover_type />
		<home_layout:slide_occupancy />
		<home_layout:slide_your_property />
		<home_layout:slide_policy_holders />
		<home_layout:slide_history />
		<home_layout:slide_results />

		<field_v1:hidden xpath="environmentOverride" />
		<input type="hidden" name="transcheck" id="transcheck" value="1" />

	</jsp:body>

</layout_v1:journey_engine_page>

<%--
	Car quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="CAR" authenticated="true" />

<core_v2:quote_check quoteType="car" />
<core_v2:load_preload />

<c:set var="trackLmiConversion" value="${data.carlmi.trackConversion}" />
<c:if test="${trackLmiConversion == true && param['int'] != null}">
	<go:setData dataVar="data" value="false" xpath="carlmi/trackConversion" />
	<core_v1:transaction touch="H" comment="getQuote" noResponse="true" writeQuoteOverride="N" />
</c:if>

<%-- Initialise Save Quote --%>
<c:set var="saveQuoteEnabled" scope="request">${pageSettings.getSetting('saveQuote')}</c:set>

<%-- Used to get a random quote out  --%>
<c:set var="selectQuote">
	quote<%= java.lang.Math.round(java.lang.Math.random() * 4) %>
</c:set>
<c:set var="quoteText" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "quoteText")}' />
<c:set var="quoteText" value="${quoteText.getSupplementaryValueByKey(selectQuote)}" />
<c:set var="quoteAuthor" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "quoteAuthor")}' />
<c:set var="quoteAuthor" value="${quoteAuthor.getSupplementaryValueByKey(selectQuote)}" />

<%-- Set global variable to flags for active split tests --%>
<car:splittest_helper />

<c:choose>
	<c:when test="${pageSettings.getBrandCode() eq 'ctm'}">
		<car:exotic_car_helper />
	</c:when>
	<c:otherwise>
		<c:set var="speechBubbleContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "speechBubbleContent")}' />
		<c:set var="normalHeading" value="${speechBubbleContent.getSupplementaryValueByKey('normalHeading')}" scope="request" />
		<c:set var="normalCopy" value="${speechBubbleContent.getSupplementaryValueByKey('normalCopy')}" scope="request" />
	</c:otherwise>
</c:choose>

<car:rego_lookup_helper />

<%-- HTML --%>
<layout_v1:journey_engine_page title="Car Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
		<c:choose>
			<c:when test="${octoberComp}">
				<competition:navSection vertical="car" />
			</c:when>
			<c:otherwise>
				<car:snapshot label="Vehicle Quoted" isHeader="true" />
			</c:otherwise>
		</c:choose>
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
			<li class="slide-feature-closeMoreInfo">
				<c:choose>
					<c:when test="${not empty moreInfoSplitTest and moreInfoSplitTest eq true}">
						<a href="javascript:;" class="btn btn-back">Back to results</a>
					</c:when>
					<c:otherwise>
						<a href="javascript:;" class="btn-back"><span class="icon icon-arrow-left" ></span> <span>Back</span></a>
					</c:otherwise>
				</c:choose>
			</li>
			<c:if test="${saveQuoteEnabled == 'Y'}">
			<li class="slide-feature-emailquote hidden-lg hidden-md hidden-sm" data-openSaveQuote="true">
				<a href="javascript:;" class="save-quote-openAsModal" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />><span class="icon icon-envelope"></span> <span><c:choose>
							<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
							<c:otherwise>Save Quote</c:otherwise>
						</c:choose></span> <b class="caret"></b></a>
			</li>
			</c:if>

			<li class="dropdown dropdown-interactive slide-edit-quote-dropdown" id="edit-details-dropdown">
				<a class="activator needsclick dropdown-toggle btn-back" data-toggle="dropdown" href="javascript:;" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />><span class="icon icon-cog"></span>
				<span>My Details</span> <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<div class="dropdown-container">
						<car:edit_details />
					</div>
				</div>
			</li>

			<c:if test="${saveQuoteEnabled == 'Y'}">
			<li class="dropdown dropdown-interactive slide-feature-emailquote hidden-xs" id="email-quote-dropdown">
				<a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />><span class="icon icon-envelope"></span> <span><c:choose>
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

			<li class="slide-feature-filters hidden-sm hidden-md hidden-lg" id="">
				<a href="javascript:;"><span class="icon icon-filter"></span> <span>Filter Results</span></a>
			</li>
		</ul>

		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
		</div>

        <agg_v1:inclusive_gst className="nav navbar-right" />
	</jsp:attribute>

	<jsp:attribute name="navbar_additional">
		<nav id="navbar-filter" class="navbar navbar-default navbar-affix navbar-inverse hidden hidden-xs" data-affix-after="#navbar-main">
			<div class="container">
				<ul class="nav navbar-nav">

					<c:if test="${pageSettings.getBrandCode() eq 'ctm'}">
						<li class="dropdown filter-cover-type">
							<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Comprehensive</span> <b class="icon icon-angle-down"></b></a>
							<ul class="dropdown-menu">
							</ul>
						</li>
					</c:if>

					<li class="dropdown filter-excess">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Excess</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu">
						</ul>
					</li>
					<li class="filter-update"><a href="javascript:void(0);" class="btn btn-hollow updateFilters hidden" data-toggle="updateButton">Update</a>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown filter-frequency">
						<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Freq</span> <b class="icon icon-angle-down"></b></a>
						<ul class="dropdown-menu">
						</ul>
					</li>
					<li class="filter-pricemode"><a href="javascript:void(0);"><span class="icon icon-th-list"></span> Quick price </a></li>
					<li class="filter-featuresmode"><a href="javascript:void(0);"><span class="icon icon-th-vert"></span> Product features</a></li>
						<li class="back-to-price-mode hidden"><a href="javascript:void(0);"><span class="icon icon-arrow-left"></span> Back</a></li>
				</ul>
			</div>
		</nav>

		<nav id="navbar-filter-labels" class="navbar hidden hidden-xs">
			<div class="container">
				<ul class="nav navbar-nav">
					<c:if test="${pageSettings.getBrandCode() eq 'ctm'}">
						<li class="navbar-text filter-type-of-cover-label">Type of Cover</li>
					</c:if>
					<li class="navbar-text filter-excess-label">Excess</li>
					<li class="navbar-text filter-cancel-label"><a href="javascript:void(0);" class="hidden">Cancel</a></li>
				</ul>

				<ul class="nav navbar-nav navbar-right">
					<li class="navbar-text filter-frequency-label">Payment Frequency</li>
					<li class="navbar-text filter-view-label">View</li>
				</ul>
			</div>
		</nav>

		<nav id="navbar-compare" class="compare-v2 navbar hidden-xs hidden">
			<div class="navbar-additional clearfix compare-basket">
			</div>
		</nav>

	</jsp:attribute>

	<jsp:attribute name="results_loading_message">
		<div class="row loadingDisclaimerText hidden">
			<div class="col-xs-12 col-sm-8 col-sm-offset-2 col-lg-6 col-lg-offset-3">
				<p>Each brand may have differing terms as well as price. Please consider the Product Disclosure Statement for each brand before making any decisions to buy.</p>
			</div>
		</div>
	</jsp:attribute>


	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<competition:mobileFooter vertical="car" />
		<car:footer />
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
		<car:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:body>

		<div class="hiddenFields">
			<%-- These should use pageSettings.getVerticalCode() but for now don't want to change xpaths --%>
			<form_v1:operator_id xpath="quote/operatorid" />
			<core_v1:referral_tracking vertical="quote" />
			<c:choose>
				<c:when test="${param['jrny'] == 1 or param['jrny'] == 2}">
					<c:set var="jrny" value = "${param['jrny']}"/>
				</c:when>
				<c:otherwise>
					<c:set var="jrny" value = "1"/>
				</c:otherwise>
			</c:choose>
			<field_v1:hidden xpath="quote/renderingMode" />
			<field_v1:hidden xpath="quote/journey/type" defaultValue="${jrny}" />
		</div>

		<%-- Slides --%>
		<car_layout:slide_your_car />
		<car_layout:slide_options />
		<car_layout:slide_your_details />
		<car_layout:slide_your_address />
		<car_layout:slide_results />

        <field_v1:hidden xpath="environmentOverride" />
		<input type="hidden" name="transcheck" id="transcheck" value="1" />

	</jsp:body>

</layout_v1:journey_engine_page>

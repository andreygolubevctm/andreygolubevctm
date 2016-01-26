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

<%-- HTML --%>
<layout_v1:journey_engine_page title="Car Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
		<car:snapshot label="Vehicle Quoted" className="hidden-xs"/>
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
			<li class="visible-xs">
				<span class="navbar-text-block navMenu-header">Menu</span>
			</li>
	
			<li class="slide-feature-back">
				<a href="javascript:;" data-slide-control="previous" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
			</li>
			<li class="slide-feature-closeMoreInfo">
				<a href="javascript:;" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
			</li>
			<c:if test="${saveQuoteEnabled == 'Y'}">
			<li class="slide-feature-emailquote hidden-lg hidden-md hidden-sm" data-openSaveQuote="true">
				<a href="javascript:;" class="save-quote-openAsModal"><span class="icon icon-envelope"></span> <span><c:choose>
							<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
							<c:otherwise>Save Quote</c:otherwise>
						</c:choose></span> <b class="caret"></b></a>
			</li>
			</c:if>

			<li class="dropdown dropdown-interactive slide-edit-quote-dropdown" id="edit-details-dropdown">
				<a class="activator needsclick dropdown-toggle btn-back" data-toggle="dropdown" href="javascript:;"><span class="icon icon-cog"></span>
				<span>My Details</span> <b class="caret"></b></a>
				<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<div class="dropdown-container">
						<car:edit_details />
					</div>
				</div>
			</li>
		
			<c:if test="${saveQuoteEnabled == 'Y'}">
			<li class="dropdown dropdown-interactive slide-feature-emailquote hidden-xs" id="email-quote-dropdown">
				<a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;"><span class="icon icon-envelope"></span> <span><c:choose>
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
				
			<%-- @todo = showReferenceNo needs to be an attribute, this tag should potentially be rewritten or moved in a different place + that script is loaded via a marker in the tag. Probably should be moved to journey_engine_page --%>
			<%-- Reference number is not visible on CAR yet, until the inbound call centre. --%>
			<li class="navbar-text hidden">
				<form_v2:reference_number />
			</li>
		</ul>
		<%-- Out of scope originally.
		<div>
			<ul>
			<li><span class="icon icon-info"></span> Need some help?</li>
			<li><span class="icon icon-thumbsup"></span> Got some feedback?</li>
			</ul>
		</div>
		--%>

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
				<li class="navbar-text filter-label">Excess</li>
				<li class="dropdown filter-excess">
					<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown"><span>Excess</span> <b class="icon icon-angle-down"></b></a>
					<ul class="dropdown-menu">
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="filter-pricemode"><a href="javascript:void(0);"><span class="icon icon-th-list"></span> Quick price view</a></li>
				<li class="filter-featuresmode"><a href="javascript:void(0);"><span class="icon icon-th-vert"></span> Product features<span class="hidden-sm"> view</span></a></li>
					<li class="back-to-price-mode hidden"><a href="javascript:void(0);"><span class="icon icon-arrow-left"></span> Back</a></li>
			</ul>
						</div>
		</nav>
		<nav id="navbar-compare" class="navbar navbar-default navbar-affix navbar-additional hidden-xs hidden" data-affix-after="#navbar-main">
			<div class="container compare-basket">
			</div>
		</nav>

	</jsp:attribute>

	<jsp:attribute name="results_loading_message">
		<div class="row loadingQuoteText hidden">
			<div class="col-xs-12 col-sm-8 col-sm-offset-2 col-lg-6 col-lg-offset-3">
				<div class="quoteContainer">
					<div class="quote">${quoteText}</div>
					<div class="quoteAuthor">${quoteAuthor}</div>
				</div>
			</div>
		</div>
		<div class="row loadingDisclaimerText hidden">
			<div class="col-xs-12 col-sm-8 col-sm-offset-2 col-lg-6 col-lg-offset-3">
				<p>Each brand may have differing terms as well as price. Please consider the Product Disclosure Statement for each brand before making any decisions to buy.</p>
						</div>
					</div>
	</jsp:attribute>

			
	<jsp:attribute name="form_bottom">
	</jsp:attribute>
			
	<jsp:attribute name="footer">
		<core_v1:whitelabeled_footer />
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

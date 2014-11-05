<%--
	Car quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="CAR" authenticated="true" />

<core:quote_check quoteType="car" />
<core_new:load_preload />

<c:set var="trackLmiConversion" value="${data.carlmi.trackConversion}" />
<c:if test="${trackLmiConversion == true && param['int'] != null}">
	<go:setData dataVar="data" value="false" xpath="carlmi/trackConversion" />
	<core:transaction touch="H" comment="getQuote" noResponse="true" writeQuoteOverride="N" />
</c:if>

<%-- Call centre numbers --%>
<c:set var="callCentreNumber" scope="request"><content:get key="carCallCentreNumber"/></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="carCallCentreHelpNumber"/></c:set>

<%-- HTML --%>
<layout:journey_engine_page title="Car Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
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
								<%-- Would this be correct for car? Probably needs a different id. --%>
								<form:scrape id='135' />
							</p>
							${callCentreSpecialHoursContent}
						</div>
						<div class="navbar-text hidden-xs" data-livechat="target">
							<h4>Call us on</h4>
							<h1>
								<span class="noWrap">${callCentreNumber}</span>
							</h1>
							<%-- Needs to be modularised out of health.
							<c:if test="${not empty callCentreSpecialHoursLink and not empty callCentreSpecialHoursContent}">
								${callCentreSpecialHoursLink}
								<div id="healthCallCentreSpecialHoursContent" class="hidden">
									<div class="row">
										<div class="col-sm-6">
											<h4>Normal Hours</h4>
											<p><form:scrape id='135'/></p>
										</div>
										<div class="col-sm-6">
											${callCentreSpecialHoursContent}
										</div>
									</div>
								</div>
							</c:if> --%>
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
						<car:edit_details />
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
			
			<li class="slide-feature-filters hidden-sm hidden-md hidden-lg" id="">
				<a href="javascript:;"><span class="icon icon-filter"></span> <span>Filter Results</span></a>
			</li>
				
			<%-- @todo = showReferenceNo needs to be an attribute, this tag should potentially be rewritten or moved in a different place + that script is loaded via a marker in the tag. Probably should be moved to journey_engine_page --%>
			<%-- Reference number is not visible on CAR yet, until the inbound call centre. --%>
			<li class="navbar-text hidden">
				<form_new:reference_number />
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
		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
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
			</ul>
						</div>
		</nav>
		<nav id="navbar-compare" class="navbar navbar-default navbar-affix navbar-additional hidden-xs" data-affix-after="#navbar-main">
			<div class="container compare-basket">
			</div>
		</nav>
	</jsp:attribute>
						 
	<jsp:attribute name="navbar_outer">
					
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
		<car:footer />
	</jsp:attribute>
			
	<jsp:attribute name="vertical_settings">
		<car:settings />
	</jsp:attribute>
		
	<jsp:attribute name="body_end">
		<script src="framework/jquery/plugins/jquery.scrollTo.min.js"></script>
	</jsp:attribute>
		
	<jsp:body>
		
		<div class="hiddenFields">
			<%-- These should use pageSettings.getVerticalCode() but for now don't want to change xpaths --%>
			<form:operator_id xpath="quote/operatorid" />
			<core:referral_tracking vertical="quote" />
			<c:choose>
				<c:when test="${param['jrny'] == 1 or param['jrny'] == 2}">
					<c:set var="jrny" value = "${param['jrny']}"/>
				</c:when>
				<c:otherwise>
					<c:set var="jrny" value = "1"/>
				</c:otherwise>
			</c:choose>
				<field:hidden xpath="quote/journey/type" defaultValue="${jrny}" />
		</div>
	
		<%-- Slides --%>
		<car_layout:slide_your_car />
		<car_layout:slide_options />
		<car_layout:slide_your_details />
		<car_layout:slide_your_address />
		<car_layout:slide_results />

		<input type="hidden" name="transcheck" id="transcheck" value="1" />

	</jsp:body>

</layout:journey_engine_page>
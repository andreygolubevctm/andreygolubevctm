<%--
	Health quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<health:redirect_rules />

<session:new verticalCode="HEALTH" authenticated="true" />

<core_new:quote_check quoteType="health" />
<core_new:load_preload />

<%-- Get data to build sections/categories/features on benefits and result pages. Used in results and benefits tags --%>
<jsp:useBean id="resultsService" class="com.ctm.services.results.ResultsService" scope="request" />
<jsp:useBean id="callCenterHours" class="com.disc_au.web.go.CallCenterHours" scope="page" />
<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" scope="request" />

<c:set var="resultTemplateItems" value="${resultsService.getResultsPageStructure('health')}" scope="request"  />

<%--TODO: turn this on and off either in a settings file or in the database --%>
<c:set var="showReducedHoursMessage" value="false" />

<%-- Call centre numbers --%>
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="callCentreNumberApplication" scope="request"><content:get key="callCentreNumberApplication"/></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber"/></c:set>
<c:set var="callCentreHelpNumberApplication" scope="request"><content:get key="callCentreHelpNumberApplication"/></c:set>

<c:set var="openingHoursHeader" scope="request" ><content:getOpeningHours/></c:set>
<c:set var="callCentreHoursModal" scope="request"><content:getOpeningHoursModal /></c:set>

<%-- HTML --%>
<layout:journey_engine_page title="Health Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header_button_left">
		<button type="button" class="navbar-toggle contact collapsed pull-left" data-toggle="collapse" data-target=".header-collapse-contact">
			<span class="sr-only">Toggle Contact Us</span>
			<span class="icon icon-phone"></span>
			<span class="icon icon-cross"></span>
		</button>
	</jsp:attribute>



	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
			<ul class="nav navbar-nav navbar-right callCentreNumberSection">
				<c:if test="${not empty callCentreNumber}">
			<li>
				<div class="navbar-text visible-xs">
						<h4>Do you need a hand?</h4>
							<h1><a class="needsclick callCentreNumberClick" href="tel:${callCentreNumber}">Call <span class="noWrap callCentreNumber">${callCentreNumber}</span></a></h1>
							${openingHoursHeader }
				</div>
				<div class="navbar-text hidden-xs" data-livechat="target">
					<h4>Call us on</h4>
							<h1><span class="noWrap callCentreNumber">${callCentreNumber}</span></h1>
							${openingHoursHeader }
						</div>
						<div id="view_all_hours" class="hidden">${callCentreHoursModal}</div>
						<div class="navbar-text hidden-xs" data-poweredby="header">&nbsp;</div>
			</li>
				</c:if>
		</ul>
		</div>
	</jsp:attribute>

	<jsp:attribute name="navbar">

		<ul class="nav navbar-nav">
		<li class="slide-feature-back">
				<a href="javascript:;" data-slide-control="previous" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
		</li>
					
		<li class="dropdown dropdown-interactive slide-feature-emailquote" id="email-quote-dropdown">
				<a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;"><span class="icon icon-envelope"></span> <span><c:choose><c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when><c:otherwise>Email Quote</c:otherwise></c:choose></span> <b class="caret"></b></a>
			<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
				<div class="dropdown-container">
					<agg_new:save_quote includeCallMeback="true" />
				</div>
			</div>
		</li>
						
		<li class="dropdown dropdown-interactive slide-feature-filters" id="filters-dropdown">
				<a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-filter"></span> <span>Filter</span><span class="hidden-sm"> Results</span> <b class="caret"></b></a>
			<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<health:filters />
			</div>
		</li>
		<li class="dropdown dropdown-interactive slide-feature-benefits" id="benefits-dropdown">
				<a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-cog"></span> <span>Customise</span><span class="hidden-sm"> Cover</span> <b class="caret"></b></a>
			<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
					<health:benefits />
			</div>
		</li>

		<%-- @todo = showReferenceNo needs to be an attribute, this tag should potentially be rewritten or moved in a different place + that script is loaded via a marker in the tag. Probably should be moved to journey_engine_page --%>
			<li class="navbar-text-block">
				<form_new:reference_number />
		</li>
		</ul>

		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
		</div>

	</jsp:attribute>
							
	<jsp:attribute name="form_bottom">
	</jsp:attribute>
							
	<jsp:attribute name="footer">
		<health:footer />
	</jsp:attribute>
							
	<jsp:attribute name="vertical_settings">
		<health:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">

		<jsp:useBean id="webUtils" class="com.ctm.web.Utils" scope="request" />
		<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />
	</jsp:attribute>

	<jsp:attribute name="additional_meerkat_scripts">
		<c:if test="${callCentre}">
			<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/" />
			<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />
			<script src="${assetUrl}js/bundles/simples_health${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
		</c:if>
	</jsp:attribute>

	<jsp:body>
		<health:product_title_search />
		<core:application_date />

		<%-- Product summary header for mobile --%>
		<div class="row productSummary-parent visible-xs">
			<div class="productSummary-affix affix-top visible-xs">
				<health:policySummary />
			</div>
		</div>
						
		<health:choices xpathBenefits="${pageSettings.getVerticalCode()}/benefits" xpathSituation="${pageSettings.getVerticalCode()}/situation" />
						 
		<%-- generate the benefit fields (hidden) for form selection. --%>
		<div class="hiddenFields">
			<c:forEach items="${resultTemplateItems}" var="selectedValue">
				<health:benefitsHiddenItem item="${selectedValue}" />
			</c:forEach>
					
			<field:hidden xpath="health/renderingMode" />
			<field:hidden xpath="health/rebate" />
			<field:hidden xpath="health/rebateChangeover" />
			<field:hidden xpath="health/loading" />
			<field:hidden xpath="health/primaryCAE" />
			<field:hidden xpath="health/partnerCAE" />
					
			<form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
			<core:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
			<core_new:authToken authToken="${param['authToken']}"/>
		</div>

		<%-- Slides --%>
		<health_layout:slide_all_about_you />
		<health_layout:slide_your_details />
		<health_layout:slide_your_contact />
		<health_layout:slide_results />
		<health_layout:slide_application_details />
		<health_layout:slide_payment_details />
					
		<input type="hidden" name="transcheck" id="transcheck" value="1" />
	</jsp:body>
</layout:journey_engine_page>
<%--
	Health quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- LOAD SETTINGS --%>
<%-- @TODO => <core_new:load_application_settings /> and get rid of line below once done --%>
<core_new:load_page_settings vertical="health" />
<core:load_settings conflictMode="false" vertical="${pageSettings.vertical}" />
<core:quote_check quoteType="health" />
<core_new:load_preload />


<%-- Get data to build sections/categories/features on benefits and result pages. Used in results and benefits tags --%>
<jsp:useBean id="resultsService" class="com.ctm.results.ResultsService" scope="request" />
<c:set var="resultTemplateItems" value="${resultsService.getResultsPageStructure('health')}" scope="request"  />
<%--TODO: turn this on and off either in a settings file or in the database --%>
<c:set var="showReducedHoursMessage" value="false" />
<%-- TODO: where do we get ${callCentre} from? --%>

<%-- HTML --%>
<layout:journey_engine_page title="Health Quote">

	<jsp:attribute name="head">
		<link rel='stylesheet' href='common/healthFunds.css'>
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="header_collapse_contact">
		<ul class="nav navbar-nav navbar-right">
			<li>
				<div class="navbar-text visible-xs">
					<h4>Need some help?</h4>
					<h1><a class="needsclick" href="tel:+1800777712">Call 1800 77 77 12</a></h1>
					<p class="small">Our Australian based call centre hours are</p>
					<p>Mon - Fri: 8:30am to 8pm &nbsp;<br />
					Sat: 10am to 4pm (AEST)</p>
				</div>
				<div class="navbar-text hidden-xs" data-livechat="target">
					<h4>Call us on</h4>
					<h1>1800 77 77 12</h1>
				</div>
			</li>
		</ul>
	</jsp:attribute>

	<jsp:attribute name="navbar">

		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true">

			</ul>
		</div>

	</jsp:attribute>

	<jsp:attribute name="navbar_collapse_menu">
		
		<li class="slide-feature-back">
			<a href="javascript:;" data-slide-control="previous" class="btn-default"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
		</li>
					
		<li class="dropdown dropdown-interactive slide-feature-emailquote" id="email-quote-dropdown">
			<a class="activator needsclick btn-tertiary dropdown-toggle" data-toggle="dropdown" href="javascript:;"><span class="icon icon-envelope"></span> <span>Email Quote</span></a>
			<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
				<div class="dropdown-container">
					<agg_new:save_quote includeCallMeback="true" />
				</div>
			</div>
		</li>
						
		<li class="dropdown dropdown-interactive slide-feature-filters" id="filters-dropdown">
			<a class="activator btn-secondary dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-filter"></span> <span>Filter</span><span class="hidden-sm"> Results</span> <b class="caret"></b></a>
			<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
				<health_new:filters />
			</div>
		</li>
		<li class="dropdown dropdown-interactive slide-feature-benefits" id="benefits-dropdown">
			<a class="activator btn-secondary dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-cog"></span> <span>Customise</span><span class="hidden-sm"> Cover</span> <b class="caret"></b></a>
			<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
				<health_new:benefits />
			</div>
		</li>

		<%-- @todo = showReferenceNo needs to be an attribute, this tag should potentially be rewritten or moved in a different place + that script is loaded via a marker in the tag. Probably should be moved to journey_engine_page --%>
		<li class="navbar-text">
			<form_new:reference_number quoteType="${vertical}" />
		</li>

	</jsp:attribute>
						
	<jsp:attribute name="journey_progress_bar">
		<div class="collapse navbar-collapse">
			<ul class="journeyProgressBar"></ul>
		</div>
	</jsp:attribute>
							
	<jsp:attribute name="form_bottom">
	</jsp:attribute>
							
	<jsp:attribute name="footer">
		<health:footer />
	</jsp:attribute>
							
	<jsp:attribute name="body_end">
							
		<health:simples_test />
		<health_new:settings />

		<%-- Call me back tab --%>
		<%--
		<agg_new:call_me_back_tab className="callmeback" />
		 --%>
	</jsp:attribute>

	<jsp:body>
						
		<%-- Product summary header for mobile --%>
		<div class="row productSummary-parent visible-xs">
			<div class="productSummary-affix affix-top visible-xs">
				<health_new:policySummary />
			</div>
		</div>
						
		<health:choices xpathBenefits="${pageSettings.vertical}/benefits" xpathSituation="${pageSettings.vertical}/situation" />
						 
		<%-- generate the benefit fields (hidden) for form selection. --%>
		<div class="hiddenFields">
			<c:forEach items="${resultTemplateItems}" var="selectedValue">
				<health_new:benefitsHiddenItem item="${selectedValue}" />
			</c:forEach>
					
			<field:hidden xpath="health/rebate" />
			<field:hidden xpath="health/loading" />
			<field:hidden xpath="health/primaryCAE" />
			<field:hidden xpath="health/partnerCAE" />
					
			<form:operator_id xpath="${pageSettings.vertical}/operatorid" />
			<core:referral_tracking vertical="${pageSettings.vertical}" />
		</div>

		<%-- Slides --%>
		<health_layout:slide_all_about_you />
		<health_layout:slide_your_details />
		<health_layout:slide_results />
		<health_layout:slide_application_details />
		<health_layout:slide_payment_details />
					
		<input type="hidden" name="transcheck" id="transcheck" value="1" />


		<%-- Dialog for when selected product not available --%>
		<%--
		@todo = replace with new dialog, will need to replace all the references that trigger the dialog to show i.e. Popup.show("#update-premium-error", "#loading-overlay") and Popup.hide("#update-premium-error"), etc.
		<style>#update-premium-error{display: none;}</style>
		<core:popup id="update-premium-error" title="Policy not available">
			<p>Unfortunately, no pricing is available for this fund.</p>
			<p>Click the button below to return to your application and try again or alternatively <i>save your quote</i> and call us on <b>1800 77 77 12</b>.</p>
			<div class="popup-buttons">
				<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
			</div>
		</core:popup>
		--%>

		
	</jsp:body>
		
</layout:journey_engine_page>
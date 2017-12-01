<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="TRAVEL" authenticated="true" />
<jsp:useBean id="serviceConfigurationService" class="com.ctm.web.core.services.ServiceConfigurationService" scope="session"/>

<core_v2:quote_check quoteType="travel" />
<core_v2:load_preload />

<%-- Set global variable to flags for active split tests --%>
<travel:splittest_helper />

<%-- HTML --%>
<layout_v1:journey_engine_page title="Travel Quote">

	<jsp:attribute name="head"></jsp:attribute>
	<jsp:attribute name="head_meta"></jsp:attribute>
	<jsp:attribute name="header_button_left"></jsp:attribute>

	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
			<ul class="nav navbar-nav navbar-right">
				<li class="navbar-text slide-feature-back push-top">
					<a href="javascript:;" data-slide-control="previous" class="btn btn-back">
						<span class="icon icon-arrow-left"></span> <span>Revise <span class="hidden-sm">Your</span> Details</span>
					</a>
				</li>
				<li class="navbar-text push-top">
					<div class="hidden-xs resultsSummaryContainer" data-livechat="target">
						<h5 class="hidden-sm">Your quote is based on</h5>
						<div class="resultsSummary">
							<div class="resultsSummaryPlaceholder"></div>
						</div>
					</div>
					<div class="navbar-text hidden-xs" data-poweredby="header">&nbsp;</div>
				</li>
			</ul>
		</div>
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
			<li class="slide-feature-back visible-xs">
				<a href="javascript:;" data-slide-control="previous" class="btn-back">
					<span class="icon icon-arrow-left"></span> <span>Revise Your Details</span></a>
			</li>
		</ul>

		<div class="navbar-desktop coverLevelTabs hidden-xs">
			<div class="col-sm-9 currentTabsContainer"></div>
			<div class="col-xs-2 col-sm-1 clt-trip-filter hidden-xs">
				<travel_results_filter_types:more_filters />
			</div>
			<div class="col-xs-5 col-sm-2 clt-trip-filter hidden-xs">
				<travel_results_filter_types:excess_filter />
			</div>
		</div>
	</jsp:attribute>

	<jsp:attribute name="navbar_outer">

 		<div class="row sortbar-container navbar-inverse">
			<div class="container">
				<ul class="sortbar-parent nav navbar-nav navbar-inverse col-sm-12 row">
					<li class="container row sortbar-children">
						<ul class="nav navbar-nav navbar-inverse col-sm-12">
							<li class="hidden-xs hidden-sm hidden-md col-sm-1 col-lg-3">
								<span class="navbar-brand navbar-cover-text"></span>
							</li>
							<li class="col-sm-2 col-lg-1 hidden-xs">
								<span class="navbar-brand"><span class="icon-travel-filters-sort"></span> Sort</span>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.excess" data-sort-dir="asc"> <span>Excess</span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.medical" data-sort-dir="desc"> <span>O.S. Medical <span class="">Expenses</span></span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.cxdfee" data-sort-dir="desc"> <span>Cancellation Fee&nbsp;Cover</span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.luggage" data-sort-dir="desc"> <span>Luggage</span></a>
							</li>
							<li class="col-sm-2 col-lg-2 active">
								<a href="javascript:;" data-sort-type="price.premium" data-sort-dir="asc"> <span>Price</span></a>
							</li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</jsp:attribute>

	<jsp:attribute name="form_bottom"></jsp:attribute>

	<jsp:attribute name="footer">
		<core_v1:whitelabeled_footer />
	</jsp:attribute>
			
	<jsp:attribute name="vertical_settings">
		<travel:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">

	</jsp:attribute>
				
	<jsp:body>
		<travel:parameter/>
		<%-- Slides --%>
		<travel_layout:slide_your_details />
		<travel_layout:slide_results />

		<%-- Hidden Fields --%>
		<field_v1:hidden xpath="transcheck" constantValue="1" />
		<field_v1:hidden xpath="travel/renderingMode" />
        <field_v1:hidden xpath="environmentOverride" />
		<%-- generate the benefit fields (hidden) for form selection. --%>
		<div class="hiddenFields">
			<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		    <core_v2:excluded_providers_list/>
		</div>
	</jsp:body>
	
</layout_v1:journey_engine_page>
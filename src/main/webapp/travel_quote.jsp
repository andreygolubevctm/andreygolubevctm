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
					<div class="resultsSummaryPlaceholder"></div>
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

		<div class="coverLevelTabs hidden-xs">
			<div class="currentTabsContainer"></div>
			<div class="col-xs-5 col-sm-3 col-md-3 clt-trip-filter">
				<div class="col-xs-12 col-md-7 text-right"><b>Excess up to</b></div>
				<div class="col-xs-5 col-md-3 text-left selected-excess-value"></div>
				<div class="col-xs-5 col-md-2 text-left">
					<a type="button" id="excessFilterDropdownBtn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<i class="icon icon-angle-down"></i>
					</a>
					<div class="dropdown-menu dropdown-menu-excess-filter" aria-labelledby="excessFilterDropdownBtn">
						<travel_results_filters:excess />
					</div>
				</div>
			</div>
			<div class="col-xs-2 col-sm-2 col-md-2 clt-trip-filter hidden-xs text-right">
				<div class="col-xs-12">
					<a type="button" id="moreFiltersDropdownBtn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						More filters&nbsp;<i class="icon icon-angle-down"></i>
					</a>
					<div class="dropdown-menu dropdown-menu-more-filters" aria-labelledby="moreFiltersDropdownBtn">
						<div class="row">
							<div class="col-sm-3 text-center travel-filters-cover-tabs"></div>
							<div class="col-sm-2 text-left">
								<div class="dropdown-item">
									<b>Excess</b>
									<field_v2:help_icon helpId="280" tooltipClassName="" />
								</div>
								<travel_results_filters:excess />
							</div>
							<div class="col-sm-3 text-left">
								<div class="dropdown-item">
									<b>Minimum luggage cover</b>
									<field_v2:help_icon helpId="280" tooltipClassName="" />
								</div>
								<travel_results_filters:minimum_luggage />
								<div class="dropdown-item">
									<b>Minimum cancellation cover</b>
									<field_v2:help_icon helpId="280" tooltipClassName="" />
								</div>
								<travel_results_filters:minimum_cancellation />
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</jsp:attribute>

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
							<li class="hidden-xs hidden-sm hidden-md col-sm-1 col-lg-3">
								<span class="navbar-brand navbar-cover-text"></span>
							</li>
							<li class="col-sm-2 col-lg-1">
								<span class="navbar-brand"><span class="icon-travel-filters-sort"></span> Sort</span>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.excess" data-sort-dir="asc"><span class="icon"></span> <span>Excess</span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.medical" data-sort-dir="desc"><span class="icon"></span> <span>O.S. Medical <span class="">Expenses</span></span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.cxdfee" data-sort-dir="desc"><span class="icon"></span> <span>Cancellation Fee&nbsp;Cover</span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.luggage" data-sort-dir="desc"><span class="icon"></span> <span>Luggage</span></a>
							</li>
							<li class="col-sm-2 col-lg-2 active">
								<a href="javascript:;" data-sort-type="price.premium" data-sort-dir="asc"><span class="icon"></span> <span>Price</span></a>
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
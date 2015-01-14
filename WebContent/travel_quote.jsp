<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="TRAVEL" authenticated="true" />

<core:quote_check quoteType="travel" />
<core_new:load_preload />

<%-- HTML --%>
<layout:journey_engine_page title="Travel Quote">

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

	<jsp:attribute name="navbar">
		<ul class="nav navbar-nav" role="menu">
			<li class="visible-xs">
				<span class="navbar-text-block navMenu-header">Menu</span>
			</li>
			<li class="slide-feature-back visible-xs">
				<a href="javascript:;" data-slide-control="previous" class="btn-back">
					<span class="icon icon-arrow-left"></span> <span>Revise Your Details</span></a>
			</li>
		</ul>

		<div class="coverLevelTabs hidden-xs">
			<div class="currentTabsContainer">
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
							<li class="hidden-xs col-sm-2 col-lg-4">
								<span class="navbar-brand">Sort <span class="optional-lg">your</span> <span class="optional-md">results</span> by</span>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.excess" data-sort-dir="asc"><span class="icon"></span> <span>Excess</span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.medical" data-sort-dir="asc"><span class="icon"></span> <span>O.S. Medical <span class="">Expenses</span></span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.cxdfee" data-sort-dir="asc"><span class="icon"></span> <span>Cancellation Fee&nbsp;Cover</span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.luggage" data-sort-dir="asc"><span class="icon"></span> <span>Luggage</span></a>
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
					
					
	<jsp:attribute name="xs_results_pagination"></jsp:attribute>
				
	<jsp:attribute name="form_bottom"></jsp:attribute>
			
	<jsp:attribute name="footer">
		<travel:footer />
	</jsp:attribute>
			
	<jsp:attribute name="vertical_settings">
		<travel:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>
				
	<jsp:body>
		<%-- Slides --%>
		<travel_layout:slide_your_details />
		<travel_layout:slide_results />

		<%-- Hidden Fields --%>
		<field:hidden xpath="transcheck" constantValue="1" />
		<field:hidden xpath="travel/renderingMode" />
		<%-- generate the benefit fields (hidden) for form selection. --%>
		<div class="hiddenFields">
			<core:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		</div>
	</jsp:body>
	
</layout:journey_engine_page>
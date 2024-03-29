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

	<jsp:attribute name="header"></jsp:attribute>

	<jsp:attribute name="header_nav_section">
		<c:if test="${not empty customerAccountsAuthHeaderSplitTest and customerAccountsAuthHeaderSplitTest eq true}">
			<c:if test="${pageSettings.getBrandCode() eq 'ctm'}">

				<div class="authHeaderContainer smallAuth">
					<div data-microui-component="AuthHeader" class="authHeaderSmall authHeaderElement"></div>
					<script type="application/javascript">
						// @param n = UMD library name ie soarExampleMicroUI
						// @param c = component name ie Foo
						// @param p = props to be passed to mounted component
						(function(n, c, p) {
							var w = window, m = function(e){
								if (e.detail.name === n) {
									var env = w['__MicroUIcustomerAccountsMicroUIEnvironment__'];
									w[n].Render(document.querySelector('div.authHeaderSmall[data-microui-component="' +c +'"]'),c, { env: env });
								}
							};
							if (w[n]) {
								m();
							} else {
								w.addEventListener('microUILoaded', m);
							}
						})('customerAccountsMicroUI', 'AuthHeader', {});
					</script>
				</div>
			</c:if>
		</c:if>

	</jsp:attribute>

	<jsp:attribute name="navbar">
		<div class="hidden-sm hidden-md hidden-lg">
			<div class="filters-row flex-center-align flex-right-align">
				<a class="revise-details-link" href="javascript:;" data-slide-control="previous">
					<span class="icon icon-arrow-left"></span>
					<span>Revise details</span>
				</a>
				<a class="edit-details-travel-mobile" href="javascript:;">Edit details</a>
				<a class="sort-results-travel-mobile" href="javascript:;">Sort</a>
			</div>
		</div>
		<div class="main-filter-buttons flex-center-align">
			<div class="hidden-md hidden-lg hidden-xs col-sm-4">
				<a href="javascript:;" data-slide-control="previous">
					<span class="icon icon-arrow-left"></span>
					<span>Revise details</span>
				</a>
			</div>
			<div class="col-xs-6 col-sm-7 col-md-12">
				<div class="flex-center-align hidden-xs hidden-sm">
					<div><a href="javascript:;" data-slide-control="previous"><span class="icon icon-arrow-left"></span> <span>Revise details</span></a></div>
					<div class="col-xs-9 col-md-10">
						<div class="navbar-desktop-travel coverLevelTabs" style="align-items: center">
							<div class="currentTabsContainer"></div>
						</div>
					</div>
				</div>
				<div class="hidden-md hidden-lg">
					<div class="navbar-mobile-travel coverLevelTabs">
						<div class="row">
							<div class="col-xs-12 clt-trip-filter">
								<div class="dropdown cover-type-mobile-active open">
									<a type="button" id="coverTypeDropdownBtn"
									   data-toggle="dropdown" aria-haspopup="true"
									   aria-expanded="false">
										<span class="mobile-active-cover-type"></span>
										<i class="icon icon-angle-down"></i>
									</a>
									<div class="dropdown-menu dropdown-menu-excess-filter dropdown-menu-mobile-cover-types" aria-labelledby="coverTypeDropdownBtn">
										<div class="mobile-cover-types"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-xs-6 col-sm-5 col-md-2 coverLevelTabs">
				<div class="navbar-mobile-travel filters-buttons flex-center-align flex-right-align">
					<div class="clt-trip-filter"><travel_results_filter_types:more_filters /></div>
					<div class="clt-trip-filter"><travel_results_filter_types:excess_filter /></div>
				</div>
			</div>
		</div>
	</jsp:attribute>

	<jsp:attribute name="navbar_outer">

 		<div class="sortbar-container navbar-inverse">
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
								<a href="javascript:;" data-sort-type="benefits.excess" data-sort-dir="asc"> <span class="results-benefits-excess">Excess</span></a>
							</li>
							<li class="col-sm-2 col-lg-1 os-medical-col">
								<a href="javascript:;" data-sort-type="benefits.medical" data-sort-dir="desc"><span class="results-benefits-os-medical">O.S. Medical <span class="oSMedical2ColText">Excess</span></span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.cxdfee" data-sort-dir="desc"> <span class="cancelFeeColText results-benefits-cancellation-cover">Cancellation Fee&nbsp;Cover</span></a>
							</li>
							<li class="col-sm-2 col-lg-1">
								<a href="javascript:;" data-sort-type="benefits.luggage" data-sort-dir="desc"><span class="luggageColText results-benefits-luggage">Luggage</span></a>
							</li>
							<li class="col-sm-2 col-lg-1 rental-vehicle-col">
								<a href="javascript:;" data-sort-type="benefits.rentalVehicle" data-sort-dir="desc"><span class="RentalVehicleColText results-benefits-rental-vehicle">Rental Vehicle <span class="">Excess Cover</span></span></a>
							</li>
							<li class="col-sm-2 col-lg-2 active">
								<a href="javascript:;" data-sort-type="price.premium" data-sort-dir="asc"><span>Price</span></a>
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

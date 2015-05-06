<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filters group" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	This tag has corresponding module: framework/modules/js/vertical/healthFilters.js

	INSTRUCTIONS:
		- Each filter needs a filter wrapper
		- The wrapper needs an attribute 'data-filter-type' so the module knows how to read the filter's value e.g. 'radio' for a radio group
		- The wrapper needs an ID so values can be restored on a Cancel.

	EXAMPLE:
		<div id="myFilter" data-filter-type="select">
			<select>...</select>
		</div>
--%>

<jsp:useBean id="healthApplicationService" class="com.ctm.services.health.HealthApplicationService" scope="page" />
<div class="dropdown-container">
	<form class="filters-component">
		<div class="scrollable filters clearfix">
			<div class="heading col-sm-12">
				<h5>Filter your results by choosing from the following:</h5>
			</div>

			<%-- Sort --%>
			<%-- Currently disabled, see the hidden class being used --%>
			<div class="col-md-6 filter hidden">
				<div class="row">
					<div class="filter-label col-sm-3">
						<label>Sort By</label>
					</div>
					<div id="filter-sort" data-filter-type="radio" class="col-sm-9">
						<field_new:array_radio xpath="health/rank-by" title="Sort By" items="B=Benefits,L=Price" required="false" />
					</div>
				</div>
			</div>

			<%-- Frequency --%>
			<div class="col-md-6 filter">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Payment Frequency</label></div>
					</div>
					<div id="filter-frequency" data-filter-type="radio" class="col-sm-9">
						<field_new:array_radio xpath="health/show-price" title="Repayments" items="F=Fortnightly,M=Monthly,A=Annually" required="false" />
					</div>
				</div>
			</div>

			<%-- Excess --%>
			<div class="col-md-6 filter">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Excess</label></div>
					</div>
					<div id="filter-excess" data-filter-type="slider" data-filter-serverside="true" class="col-sm-9 col-md-8">
						<health:filter_excess />
					</div>
				</div>
			</div>

			<%-- Price --%>
			<div class="col-md-6 filter">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Premium Price</label></div>
					</div>
					<div id="filter-price"
							data-filter-type="slider"
							data-filter-serverside="true"
							class="col-sm-9">
						<health:filter_price />
					</div>
				</div>
			</div>

			<%-- Call centre filter only (not public yet) --%>
			<%-- If any of these get activated for ONLINE, check results.tag for the associated hidden field. --%>
			<c:if test="${callCentre}">

				<div class="col-md-6 filterLevelOfCover filter">
					<div class="row">
						<div class="filter-label col-sm-3">
							<div><label style="margin-top:0">Level of cover</label></div>
						</div>
						<div id="filter-tierHospital" data-filter-type="select" data-filter-serverside="true" class="col-xs-6 col-sm-4">
							<field_new:array_select items="=Hospital level...,1=Public,2=Budget,3=Medium,4=Top" xpath="filters_tierHospital" title="" required="false" />
						</div>
						<div id="filter-tierExtras" data-filter-type="select" data-filter-serverside="true" class="col-xs-6 col-sm-4">
							<field_new:array_select items="=Extras level...,1=Budget,2=Medium,3=Comprehensive" xpath="filters_tierExtras" title="" required="false" />
						</div>
					</div>
				</div>

			</c:if>

			<%-- Brand/Provider --%>
			<c:set var="providerList" value="${healthApplicationService.getAllProviders(styleCodeId)}"  scope="request"/>
			<div class="filterProvider col-md-12" id="filter-provider" data-filter-type="checkbox" data-filter-serverside="true">
				<div class="col-md-8 filter">
					<div class="row">
						<div class="filter-label col-sm-3 col-md-2">
							<div><label>Brands</label></div>
						</div>
						<div class="col-sm-9 col-md-10">
							<button type="button" class="btn btn-form selectNotRestrictedBrands">Select All</button>
							<button type="button" class="btn btn-default unselectNotRestrictedBrands">Unselect All</button>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-offset-3 col-sm-9 col-md-offset-2 col-md-10 notRestrictedBrands">
							<health:filter_provider xpath="health/brandFilter" providersList="${providerList}"  fundType="notRestricted" />
						</div>
					</div>
				</div>
				<div class="col-md-4 filter">
					<div class="row">
						<div class="filter-label col-sm-3 col-md-4 col-lg-3">
							<div><label>Restricted Brands</label></div>
						</div>
						<div class="col-sm-9 col-md-8 col-lg-9">
							<button type="button" class="btn btn-form selectRestrictedBrands">Select All</button>
							<button type="button" class="btn btn-default unselectRestrictedBrands">Unselect All</button>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-offset-3 col-sm-9 col-md-offset-4 col-md-8 col-lg-offset-3 col-lg-9 restrictedBrands">
							<health:filter_provider xpath="health/brandFilter" providersList="${providerList}" fundType="restricted" />
						</div>
					</div>
				</div>
			</div>

		</div><%-- /scrollable --%>

		<div class="footer">
			<button type="button" class="btn btn-cancel popover-mode">Cancel</button>
			<button type="button" class="btn btn-save popover-mode">Save changes</button>
		</div>

	</form>
</div>
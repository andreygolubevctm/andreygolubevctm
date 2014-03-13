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

<div class="dropdown-container">
	<form class="filters-component ">
		<div class="scrollable row filters">
			
			<div class="filter-label col-lg-1 col-sm-2">
				<label>Sort By</label>
			</div>
			<div id="filter-sort"
					data-filter-type="radio"
					class="col-lg-2 col-md-4 col-sm-10">
				<field_new:array_radio xpath="health/rank-by" title="Sort By" items="B=Benefits,L=Price" required="false" />
			</div>

			<div class="filter-label col-lg-1 col-sm-2">
				<label>Repayments</label>
			</div>
			<div id="filter-frequency"
					data-filter-type="radio"
					class="col-lg-3 col-md-4 col-sm-10">
				<field_new:array_radio xpath="health/show-price" title="Repayments" items="F=Fortnightly,M=Monthly,A=Annually" required="false" />
			</div>

			<div class="filter-label col-lg-1 col-sm-2">
				<label>Excess</label>
			</div>
			<div id="filter-excess"
					data-filter-type="slider"
					data-filter-serverside="true"
					class="col-lg-4 col-md-4 col-sm-10">
				<health_new:filter_excess />
			</div>

			<%-- Call centre filters (not public yet) --%>
			<%-- If any of these get activated for ONLINE, check results.tag for the associated hidden field. --%>
			<c:if test="${callCentre}">
				<div class="filter-label col-lg-1 col-sm-2">
					<label>Price</label>
				</div>
				<div id="filter-price"
						data-filter-type="slider"
						data-filter-serverside="true"
						class="col-lg-3 col-md-4 col-sm-10">
					<health_new:filter_price />
				</div>

				<div class="col-md-6 col-sm-9">
					<div class="row">
						<div class="filter-label col-lg-3 col-md-4 col-sm-2">
							<label style="margin-top:0">Level of cover</label>
						</div>
						<div id="filter-tierHospital"
								data-filter-type="select"
								data-filter-serverside="true"
								class="col-sm-4">
							<field_new:array_select items="=Hospital level...,0=None,1=Public,2=Budget,3=Medium,4=Top" xpath="filters_tierHospital" title="" required="false" />
						</div>
						<div id="filter-tierExtras"
								data-filter-type="select"
								data-filter-serverside="true"
								class="col-sm-4">
							<field_new:array_select items="=Extras level...,0=None,1=Budget,2=Medium,3=Comprehensive" xpath="filters_tierExtras" title="" required="false" />
						</div>
					</div>
				</div>

				<div id="filter-provider" class="clearfix"
						data-filter-type="checkbox"
						data-filter-serverside="true">
					<health_new:filter_provider xpath="health/brandFilter" />
				</div>
			</c:if>

		</div><%-- /scrollable --%>

		<div class=" footer">

				<button type="button" class="btn btn-default btn-cancel popover-mode">Cancel</button>
				<button type="button" class="btn btn-primary btn-save popover-mode">Save changes</button>

		</div>

	</form>
</div>
<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRODUCT BENEFITS TEMPLATE --%>
<core:js_template id="more-info-product-benefits-template">

	<div class="row">

		{{ if(typeof hospitalCover !== 'undefined') { }}
		<div class="col-xs-6">

			<h2 class="text-hospital-benefits">Hospital Benefits</h2>
			{{ if(hospitalCover.inclusions.length > 0) { }}
			<h5>You are covered for:</h5>
			<ul class="indent">
				{{ _.each(hospitalCover.inclusions, function(inclusion){ }}
				<li>{{= inclusion }}</li>
				{{ }) }}
			</ul>
			{{ } }}

			{{ if(hospitalCover.restrictions.length > 0) { }}
			<h5>You have restricted cover for:</h5>
			<ul class="indent">
				{{ _.each(hospitalCover.restrictions, function(restriction){ }}
				<li>{{= restriction }}</li>
				{{ }) }}
			</ul>
			<span class="text-italic small">Limits may apply. See policy brochure for more details.</span>
			{{ } }}

		</div>
		{{ } }}

		{{ if(typeof extrasCover !== 'undefined') { }}
		<div class="col-xs-6">
			<h2 class="text-extras">Extras Benefits</h2>
			{{ if(extrasCover.inclusions.length > 0) { }}
			<h5>You are covered for:</h5>
			<ul class="indent">
				{{ _.each(extrasCover.inclusions, function(inclusion){ }}
				<li>{{= inclusion }}</li>
				{{ }) }}
			</ul>
			<span class="text-italic small">Limits may apply. See policy brochure for more details.</span>
			{{ } }}
		</div>
		{{ } }}

	</div>

	{{ if(typeof hospital.inclusions !== 'undefined') { }}
	<div class="row moreInfoExcesses">
		<div class="col-xs-12">
			<p><strong>Excess:</strong> {{= hospital.inclusions.excess }}</p>
			<p><strong>Excess Waivers:</strong> {{= hospital.inclusions.waivers }}</p>
			<p><strong>Co-payment / % Hospital Contribution:</strong> {{= hospital.inclusions.copayment }}</p>
		</div>
	</div>
	{{ } }}

	{{ if(typeof hospitalCover !== 'undefined' && hospitalCover.exclusions.length > 0) { }}
	<div class="row moreInfoExclusions">
		<div class="col-xs-12">
			<h5 class="text-hospital">Your Hospital Exclusions:</h5>
			<ul class="exclusions">
				{{ _.each(hospitalCover.exclusions, function(exclusion){ }}
				<li><span class="icon-cross"></span>{{= exclusion }}</li>
				{{ }) }}
				<c:if test="${not empty callCentre}">
					{{ if (typeof custom !== 'undefined' && custom.info && custom.info.exclusions && custom.info.exclusions.cover) { }}
					<li class="text-danger"><span class="icon-cross" /></span>{{= custom.info.exclusions.cover }}</li>
					{{ } }}
				</c:if>
			</ul>
		</div>
	</div>
	{{ }else{ }}
	<c:if test="${not empty callCentre}">
		{{ if (typeof custom !== 'undefined' && custom.info && custom.info.exclusions && custom.info.exclusions.cover) { }}
		<div class="row moreInfoExclusions">
			<div class="col-xs-12">
				<h5 class="text-hospital">Your Hospital Exclusions:</h5>
				<ul class="exclusions">
					<li class="text-danger"><span class="icon-cross" /></span>{{= custom.info.exclusions.cover }}</li>
				</ul>
			</div>
		</div>
		{{ } }}
	</c:if>
	{{ } }}
</core:js_template>
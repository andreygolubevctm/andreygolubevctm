<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRODUCT BENEFITS TEMPLATE --%>
<core:js_template id="more-info-product-benefits-template-xs">
	{{ var extrasPDF = ""; }}
	{{ var hospitalPDF = ""; }}
	{{ var singlePDF = ""; }}

		{{ if(typeof hospitalCover !== 'undefined' && typeof extrasCover !== 'undefined' && promo.hospitalPDF == promo.extrasPDF) { }}
			{{ singlePDF = '<a href="${pageSettings.getBaseUrl()}'+ promo.hospitalPDF +'" target="_blank" class="btn btn-download download-policy-brochure">Download Brochure</a>'; }}

		{{ } else { }}

		{{ if(typeof hospitalCover !== 'undefined') { }}
			{{ hospitalPDF = '<a href="${pageSettings.getBaseUrl()}'+ promo.hospitalPDF +'" target="_blank" class="btn btn-download download-hospital-brochure">Hospital Brochure</a>'; }}

		{{ } }}

			{{ if(typeof extrasCover !== 'undefined') { }}
				{{ extrasPDF ='<a href="${pageSettings.getBaseUrl()}'+ promo.extrasPDF +'" target="_blank" class="btn btn-download download-extras-brochure">Extras Brochure</a>'; }}
			{{ } }}
		{{ } }}

	<div class="row">

		{{ if(typeof hospitalCover !== 'undefined') { }}
		<div class="col-xs-6">

			<h2 class="text-hospital-benefits">Hospital<span class="hidden-xs"> Benefits</span></h2>
			<div class="row-content brochureButtons visible-xs col-xs-12">
				{{= hospitalPDF }}
			</div>
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
			<h2 class="text-extras">Extras<span class="hidden-xs"> Benefits</span></h2>
			<div class="row-content brochureButtons visible-xs col-xs-12">
			{{= extrasPDF }}
			</div>
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
	{{ } }}
</core:js_template>
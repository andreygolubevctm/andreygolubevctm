<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>



<c:set var="emailPlaceHolder">
	<content:get key="emailPlaceHolder"/>
</c:set>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />

<c:if test="${healthAlternatePricingActive eq true}">
	<c:set var="healthAlternatePricingMonth" value="${healthPriceDetailService.getAlternatePriceMonth(pageContext.getRequest())}" />
</c:if>

<%-- MORE INFO CALL TO ACTION BAR TEMPLATE --%>
<%-- MORE INFO FOOTER --%>
<script id="more-info-call-to-action-template" type="text/html">

	<div class="moreInfoCallToActionBar row">
		<div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
			<p>Found the right product for you?</p>
		</div>
		<div class="col-xs-12 col-sm-4 col-md-5 col-lg-6">
			<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now<span class="icon-arrow-right" /></a>
		</div>
	</div>

</script>

<%-- MORE INFO TEMPLATE --%>
<script id="more-info-template" type="text/html">
	<%-- Prepare the price and dual price templates --%>
	{{ obj._selectedFrequency = Results.getFrequency(); }}
	{{ obj.mode = ''; }}
	{{ obj.displayLogo = false; }} <%-- Turns off the logo from the template --%>

	<%-- If dual pricing is enabled, update the template --%>
	{{ if (meerkat.site.healthAlternatePricingActive === true) { }}
	{{ obj.renderedDualPricing = meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false); }}
	{{ } else { }}
	{{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); }}
	{{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}

	{{ obj.showAltPremium = false; obj.renderedPriceTemplate = logoTemplate(obj) + priceTemplate(obj); }}
	{{ } }}

	<%-- Prepare the call to action bar template. --%>
	{{ var template = $("#more-info-call-to-action-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var callToActionBarHtml = htmlTemplate(obj); }}

	<c:set var="buyNowHeadingClass">
		<c:choose>
			<c:when test="${healthAlternatePricingActive eq true}">hidden-xs</c:when>
			<c:otherwise>visible-xs</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="variantClassName">
		<c:if test="${moreinfo_splittest_default eq false}">more-info-content-variant</c:if>
	</c:set>
	<div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content col-xs-12 ${variantClassName}">

		<div class="fieldset-card row price-card <c:if test="${healthAlternatePricingActive eq true}">hasDualPricing</c:if>">
			<div class="col-xs-12 col-sm-9 moreInfoTopLeftColumn">
				<health_v4_moreinfo:more_info_product_summary />
				<health_v4_moreinfo:more_info_product_extra_info />
				<!-- Hospital and Extras -->
				<div class="row">
					<div class="col-sm-6 col-xs-12 HospitalBenefits">
						<!-- Hospital Benefits Heading + Brochure -->
						<div class="row">
							<div class="col-xs-12">
								{{ if(typeof hospitalCover !== 'undefined') { }}
								<div class="row row-eq-height">
									<div class="col-sm-6">
									{{ } }}
								<h3>Hospital</h3>
								{{ if(typeof hospitalCover !== 'undefined') { }}
									</div>
									<div class="{{ if(typeof extrasCover !== 'undefined'){ }}col-sm-6{{ } }} col-xs-12">
										<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-hospital-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Download Brochure</a>
									</div>
								</div>
								{{ } }}
							</div>
						</div>

						<!-- Hospital Benefits -->
						<div class="row">
							<div class="col-xs-12">
								<h3>Excess</h3>
								{{= hospital.inclusions.excess }}
							</div>
							{{ var benefitTemplate = meerkat.modules.templateCache.getTemplate($("#benefitRowTemplate")); }}
							{{ var benefitData = [{"Co-Payment/ % Hospital Contribution": hospital.inclusions.copayment},  {"Excess Waivers": hospital.inclusions.waivers }]; }}

							{{= benefitTemplate(benefitData) }}
							<h3>Waiting Periods</h3>
							{{  benefitData = [{"Pre-existing Conditions": hospital.inclusions.waitingPeriods.PreExisting},  {"All other conditions": hospital.inclusions.waitingPeriods.Other }]; }}
							{{= benefitTemplate(benefitData) }}


							{{ if(typeof hospitalCover !== 'undefined') { }}
								<div class="col-xs-12" class="secondaryBrochureLink">
									<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-hospital-brochure col-xs-12 leftAlignedLink" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Please download and refer to the Policy Brochure for details</a>
								</div>
							{{ } }}
						</div>

						<div class="row">
							<div class="col-xs-12 moreInfoHospitalTab">
								<ul class="nav nav-tabs">
									<li>
										<a href="javascript" data-target=".hospitalCoveredPane"><h3>Covered <span class="benefitCount">{{= hospitalCover.inclusions.length }}</span></h3></a>
									</li>
									<li>
										<a href="javascript" data-target=".hospitalNotCoveredPane"><h3>Not Covered <span class="benefitCount pink">{{= hospitalCover.exclusions.length }}</span></h3></a>
									</li>
								</ul>
							</div>
						</div>

						{{ var benefitTemplate = meerkat.modules.templateCache.getTemplate($("#healthBenefitsIconRowTemplate")); }}
						<!-- Inclusions / Exclusions -->
						<div class="row tab-content">
							<div class="col-xs-12 tab-pane hospitalCoveredPane">
								{{ benefitData = {}; }}
								{{ benefitData.isSelected = true; }}
								{{ benefitData.items = hospitalCover.inclusions; }}
								{{ benefitData.keys = [{"WaitingPeriod": "Waiting Period"}, {"benefitLimitationPeriod": "Benefit Limitation Period"}]; }}
								{{ benefitData.notCovered = false; }}
								{{= benefitTemplate(benefitData) }}
							</div>
							<div class="col-xs-12 tab-pane hospitalNotCoveredPane">
								{{ benefitData.items = hospitalCover.exclusions; }}
								{{ benefitData.notCovered = true; }}
								{{= benefitTemplate(benefitData) }}
							</div>
						</div>

						<!-- Restricted Benefits -->
						{{ if (hospitalCover.restrictions.length > 0) { }}
						<div class="row">
							<div class="col-xs-12">
								<h3 class="heading">Restricted Benefits <span class="benefitCount gray">{{= hospitalCover.restrictions.length }}</span></h3>
								<p>These treatements are limited to the same amount you would receive in a public hoslita for those treatements.</p>
								{{ if(typeof hospitalCover !== 'undefined') { }}
									<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-hospital-brochure col-xs-12 leftAlignedLink" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Please download and refer to the Policy Brochure</a>
								{{ } }}
								<p>Unsure? <span>Have a quick chat with our Experts</span></p>
							</div>
							{{ benefitData.isSelected = false; }}
							{{ benefitData.items = hospitalCover.restrictions; }}
							{{= benefitTemplate(benefitData) }}
						</div>
						{{ } }}
					</div>
					<div class="col-sm-6 col-xs-12 ExtrasBenefits">
						<!-- Extras Benefits Heading + Brochure -->
						<div class="row row-eq-height">
							{{ if(typeof extrasCover !== 'undefined') { }}
							<div class="col-sm-6">
							{{ } }}
							<h3>Extras</h3>
							{{ if(typeof extrasCover !== 'undefined') { }}
							</div>
							<div class="{{ if(typeof hospitalCover !== 'undefined'){ }}col-sm-6{{ } }} col-xs-12 ">
								<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="btn download-extras-brochure col-xs-12">Download brochure</a>
							</div>
							{{ } }}
						</div>

						<div class="row">
							<div class="col-xs-12 moreInfoExtrasTab">
								<ul class="nav nav-tabs">
									<li>
										<a href="javascript" data-target=".extrasCoveredPane"><h3>Covered <span class="benefitCount">{{= extrasCover.inclusions.length }}</span></h3></a>
									</li>
									<li>
										<a href="javascript" data-target=".extrasNotCoveredPane"><h3>Not Covered <span class="benefitCount pink">{{= extrasCover.exclusions.length }}</span></h3></a>
									</li>
								</ul>
							</div>
						</div>

						<!-- Inclusions / Exclusions -->
						<div class="row tab-content">
							<div class="col-xs-12 tab-pane extrasCoveredPane">
								{{ var benefitTemplate = meerkat.modules.templateCache.getTemplate($("#extrasLimitsTemplate")); }}
								{{ var product = Results.getSelectedProduct(); }}
								{{ product.showNotCoveredBenefits = false; }}
								{{ product.ignoreLimits = false; }}
								{{= benefitTemplate(product) }}
							</div>
							<div class="col-xs-12 tab-pane extrasNotCoveredPane">
								{{ product.showNotCoveredBenefits = true; }}
								{{ product.ignoreLimits = true; }}
								{{= benefitTemplate(product) }}
							</div>
						</div>


					</div>
				</div>
			</div>
			<!-- CTA BUTTON -->
			<div class="col-sm-3 hidden-xs moreInfoTopRightColumn">
				<div class="row">
					<div class="col-xs-12">
						<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now<span class="icon-arrow-right" /></a>
					</div>
				</div>
			</div>
		</div>
	</div>
</script>

<script id="benefitRowTemplate" type="text/html">
	{{ _.each(obj, function(el, i) { }}
		{{ var keys = Object.keys(el); }}
	<div class="col-xs-8">
		{{= keys[0] }}
	</div>
	<div class="col-xs-4">
		{{= el[keys[0]] }}
	</div>
	{{ }); }}
</script>
<script id="healthBenefitsIconRowTemplate" type="text/html">
	{{ var selectedClass = obj.isSelected ? 'selected' : ''; }}
	{{ _.each(obj.items, function(el, i) { }}
	<div class="row {{= selectedClass}} {{=el.className}}">
		<div class="col-xs-12">
			<p>{{= el.name }}</p>
		</div>

		{{ if (obj.notCovered === false) { }}
			{{ _.each(obj.keys, function(item, i) { }}
				{{ var key = Object.keys(item); }}
			<div class="col-xs-8">
				{{= item[key[0]] }}
			</div>
			<div class="col-xs-4">
				{{= el[key[0]] === '-' ? 'None' : el[key[0]] }}
			</div>
			{{ }); }}
		{{ } }}
	</div>
	{{ }); }}
</script>

<health_v4_moreinfo:more_info_affixed_header />
<health_v4_moreinfo:more_info_affixed_header_mobile />
<health_v4_moreinfo:more_info_extras_limits />
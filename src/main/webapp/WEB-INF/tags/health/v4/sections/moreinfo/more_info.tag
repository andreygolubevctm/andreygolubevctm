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
	<a data-slide-control="prev" href="javascript:;" class="hidden-xs btn btn-tertiary btn-close-more-info" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />><span class="icon icon-arrow-left"></span> Back to all results</a>

	<c:if test="${empty callCentre}">
		<form_v3:save_results_button />
	</c:if>
	affixOnScroll
	<div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content col-xs-12 ${variantClassName}">

		<div class="fieldset-card row price-card <c:if test="${healthAlternatePricingActive eq true}">hasDualPricing</c:if>">
			<div class="col-xs-9 moreInfoTopLeftColumn">
				<!-- Product Summary. Logo, price, LHC etc... -->
				<div class="row priceRow productSummary hidden-xs affixOnScroll">
					<div class="col-xs-12">
						<div class="row">
							<div class="col-xs-8">
								<div class="companyLogo {{= info.provider }}-mi"></div>
								<h3 class="noTopMargin productName hidden-xs">{{= info.productTitle }}</h3>
							</div>
							<div class="col-xs-4">
								{{= renderedPriceTemplate }}
							</div>
							<h3 class="noTopMargin productName visible-xs">{{= info.productTitle }}</h3>
						</div>
					</div>
				</div>
				<!-- Product extra info -->
				<div class="row hidden-xs productExtraInfo">
					{{ if (promo.promoText !== ''){ }}
					<div class="col-sm-3 promoText">{{= promo.promoText }}</div>
					{{ } }}
					<div class="col-sm-3">Buy online to get a to text</div>
					{{ if (promo.discountText !== ''){ }}
					<div class="col-sm-3 discountText">{{= promo.discountText }}</div>
					{{ } }}
					<div class="col-sm-3">Restricted fund product text</div>
				</div>

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
						{{ var benefitTemplate = meerkat.modules.templateCache.getTemplate($("#extrasBenefitsIconRowTemplate")); }}
						<div class="row tab-content">
							<div class="col-xs-12 tab-pane extrasCoveredPane">
								{{ benefitData.isSelected = true; }}
								{{ benefitData.keys = [{"annualLimit": "Annual Limit"}, {"combinedLimit": "Combined Limit"}, {"lifetime": "Lifetime Limit"}, {"perPerson": "Per Person"}, {"perPolicy": "Per Policy"}, {"serviceLimit": "Service Limit"}]; }}
								{{ benefitData.items = extrasCover.inclusions; }}
								{{ benefitData.notCovered = false; }}
								{{= benefitTemplate(benefitData) }}
							</div>
							<div class="col-xs-12 tab-pane extrasNotCoveredPane">
								{{ benefitData.items = extrasCover.exclusions; }}
								{{ benefitData.notCovered = true; }}
								{{= benefitTemplate(benefitData) }}
							</div>
						</div>

						{{ benefitTemplate = meerkat.modules.templateCache.getTemplate($("#extras-limits-template")); }}
						{{= benefitTemplate(Results.getSelectedProduct()) }}

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
<script id="extrasBenefitsIconRowTemplate" type="text/html">
	{{ var selectedClass = obj.isSelected ? 'selected' : ''; }}
	{{ _.each(obj.items, function(el, i) { }}
	<div class="row {{= selectedClass}} {{=el.className}}">
		<div class="col-xs-12">
			<p>{{= el.name }}</p>
		</div>
		{{ if (obj.notCovered === false) { }}
			{{ _.each(obj.keys, function(item, i) { }}
				{{ var key = Object.keys(item); }}
				{{ if (!_.isNull(el.benefitLimits[key[0]]) && !_.isUndefined(el.benefitLimits[key[0]])) { }}
					{{ var benefitValue = el.benefitLimits[key[0]]; }}
					{{ var isGroupLimit = benefitValue.indexOf("Group") >= 0; }}
					<div class="col-xs-8">
						{{ if (key[0] === 'combinedLimit' && isGroupLimit) { }}
							Group Limit
						{{ } else { }}
							{{= item[key[0]] }}
						{{ } }}
					</div>
					<div class="col-xs-4">
						{{ if (key[0] === 'combinedLimit' && isGroupLimit) { }}
							{{= benefitValue.replace('Group Limit: ' ,'') }}
						{{ } else { }}
							{{= benefitValue === '-' ? 'None' : benefitValue }}
						{{ } }}
					</div>
				{{ } }}
			{{ }); }}
		{{ } }}
	</div>
	{{ }); }}
</script>
<%-- MORE INFO TEMPLATE --%>
<script id="more-info-templatexxxx" type="text/html">

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
	<c:set var="moreInfoTopLeftColumnWidth">
		<c:choose>
			<c:when test="${healthAlternatePricingActive eq true}">col-md-7</c:when>
			<c:otherwise>col-sm-8</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="variantClassName">
		<c:if test="${moreinfo_splittest_default eq false}">more-info-content-variant</c:if>
	</c:set>
	<a data-slide-control="prev" href="javascript:;" class="hidden-xs btn btn-tertiary btn-close-more-info" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />><span class="icon icon-arrow-left"></span> Back to all results</a>

	<c:if test="${empty callCentre}">
		<form_v3:save_results_button />
	</c:if>

	<div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content col-xs-12 ${variantClassName}">

		<div class="fieldset-card row price-card <c:if test="${healthAlternatePricingActive eq true}">hasDualPricing</c:if>">
			<div class="${moreInfoTopLeftColumnWidth} moreInfoTopLeftColumn">
				<div class="row hidden-sm hidden-md hidden-lg">
					<div class="col-xs-3">
						<div class="companyLogo {{= info.provider }}-mi"></div>
					</div>
					<div class="col-xs-9 <c:if test="${healthAlternatePricingActive eq true}">productDetails</c:if>">
						<h1 class="noTopMargin productName">{{= info.productTitle }}</h1>
					</div>
				</div>
				<div class="row priceRow productSummary hidden-xs">
					<div class="col-xs-12">
						{{= renderedPriceTemplate }}
					</div>
				</div>
				<div class="row hidden-xs">
					<div class="col-xs-12 <c:if test="${healthAlternatePricingActive eq true}">productDetails</c:if>">
						<h1 class="noTopMargin productName">{{= info.productTitle }}</h1>

						<div class="hidden-xs">
							{{ if (promo.promoText !== ''){ }}
							<p class="promoHeading">Buy now and benefit from these promotions</p>
							<p>{{= promo.promoText }}</p>
							{{ } else { }}
							<p class="promoHeading">Great choice!</p>
							<p class="noPromoText">This policy covers all of the things that you said were important to you.
								Also, because health insurance prices are regulated, you’re paying no more through us than if you went directly to {{= info.providerName }}.</p>
							{{ }  }}
						</div>
					</div>
				</div>
				<c:choose>
				<c:when test="${healthAlternatePricingActive eq true}">
					<div class="row priceRow productSummary">
						<div class="col-xs-12 hidden-md hidden-lg">
							{{= renderedDualPricing }}
						</div>
						<div class="col-md-12 insureNowContainer hidden-xs hidden-sm">
						<c:choose>
							<c:when test="${moreinfo_splittest_default eq false}">
								<div class="col-xs-3"></div>
								<div class="col-xs-9">
									<h3 class="text-dark">Need help? Call <span class="text-secondary">${callCentreNumber}</span></h3>
								</div>
							</c:when>
							<c:otherwise>
								<div class="insureNow">
									<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now<span class="icon-arrow-right" /></a>
								</div>
								<h3 class="text-dark">Need help? Call <span class="text-secondary">${callCentreNumber}</span></h3>
							</c:otherwise>
						</c:choose>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="row priceRow productSummary hidden-sm hidden-md hidden-lg">
						<div class="col-xs-12 col-sm-8">
							{{= renderedPriceTemplate }}
						</div>
						<div class="col-xs-12 col-sm-4 text-right">
							<c:choose>
								<c:when test="${moreinfo_splittest_variant1 eq true}">
									<a href="javascript:;" class="btn btn-cta old-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Buy Now</a>
								</c:when>
								<c:when test="${moreinfo_splittest_variant2 eq true}">
									<a href="javascript:;" class="btn btn-cta old-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get insured now <span class="icon-arrow-right" /></a>
								</c:when>
								<c:when test="${moreinfo_splittest_variant3 eq true}">
									<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Buy Now</a>
								</c:when>
								<c:otherwise>
							<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now<span class="icon-arrow-right" /></a>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:otherwise>
				</c:choose>

				<div class="row ${buyNowHeadingClass} hidden-sm hidden-md hidden-lg">
					<div class="col-xs-12">
						{{ if (promo.promoText !== ''){ }}
						<h2>Buy now and benefit from these promotions</h2>
						<p>{{= promo.promoText }}</p>
						{{ } }}
					</div>
				</div>

			</div>
			<c:choose>
				<c:when test="${healthAlternatePricingActive eq true}">
					<div class="col-md-5 hidden-xs moreInfoTopRightColumn">
						<div class="companyLogo {{= info.provider }}-mi"></div>
						<c:choose>
							<c:when test="${moreinfo_splittest_variant1 eq true}">
								<a href="javascript:;" class="btn btn-cta old-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Buy Now</a>
							</c:when>
							<c:when test="${moreinfo_splittest_variant2 eq true}">
								<a href="javascript:;" class="btn btn-cta old-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get insured now <span class="icon-arrow-right" /></a>
							</c:when>
						</c:choose>
						{{= renderedDualPricing }}
						<c:if test="${moreinfo_splittest_variant3 eq true}">
							<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Buy Now</a>
						</c:if>
					</div>
				</c:when>
				<c:otherwise>
					<div class="col-sm-4 hidden-xs moreInfoTopRightColumn">
						<div class="companyLogo {{= info.provider }}-mi"></div>
						<c:choose>
							<c:when test="${moreinfo_splittest_variant1 eq true}">
								<a href="javascript:;" class="btn btn-cta old-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Buy Now</a>
							</c:when>
							<c:when test="${moreinfo_splittest_variant2 eq true}">
								<a href="javascript:;" class="btn btn-cta old-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get insured now <span class="icon-arrow-right" /></a>
							</c:when>
						</c:choose>
						<c:if test="${not empty callCentre or moreinfo_splittest_default eq true}">
						<div class="row">
							<div class="col-xs-12">
								<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now<span class="icon-arrow-right" /></a>
							</div>
						</div>
						</c:if>
						<c:if test="${moreinfo_splittest_variant3 eq true}">
							<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Buy Now</a>
						</c:if>

						<p class="needHelp">or need help? Call <span>${callCentreNumber}</span></p>
						<p class="referenceNo">Quote reference number <span>{{= transactionId }}</span></p>
					</div>
				</c:otherwise>
			</c:choose>

		</div>

		<div class="fieldset-card row cover-card ${moreinfolayout_splittest_variant1 eq true ? 'moreinfolayout-splittest' : ''}">

			<c:if test="${moreinfolayout_splittest_variant1 eq true}">
			<div class="col-xs-12 col-md-6 aboutTheFund">
				<h2>About {{= info.productTitle }}</h2>
				{{= aboutFund }}
			</div>
			</c:if>

			<c:if test="${moreinfolayout_splittest_variant1 eq true}">
			<div class="col-xs-12 col-md-6 whatsNext">
				<h2>Next Steps</h2>
				{{= whatHappensNext }}
			</div>
			</c:if>

			<c:if test="${moreinfolayout_splittest_default eq true}">
			{{ if(typeof hospital !== 'undefined' && typeof hospitalCover !== 'undefined') { }}
			<div class="col-xs-12 col-md-6 hospitalCover">
				{{ if(typeof hospital.inclusions !== 'undefined') { }}
				<h2>Hospital cover</h2>
				<p><strong>Hospital Excess:</strong> {{= hospital.inclusions.excess }}</p>
				<p><strong>Excess Waivers:</strong> {{= hospital.inclusions.waivers }}</p>
				<p><strong>Co-payment / % Hospital Contribution:</strong> {{= hospital.inclusions.copayment }}</p>
				<p><strong>Hospital waiting period for pre-existing conditions:</strong> 12 months. For all other conditions: 2 months. See policy brochure for more details</p>
				{{ } }}
				{{ if(hospitalCover.inclusions.length > 0) { }}
				<h5>You will be covered for the following services</h5>

				<ul class="benefitsIcons inclusions">
					{{ _.each(hospitalCover.inclusions, function(inclusion){ }}
					<li class="{{= inclusion.className }}"><span>{{= inclusion.name }}</span></li>
					{{ }) }}
				</ul>
				{{ } }}

				{{ if(hospitalCover.restrictions.length > 0) { }}
				<h5>You will have restricted cover for the following services</h5>
				<ul class="benefitsIcons restrictions">
					{{ _.each(hospitalCover.restrictions, function(restriction){ }}
					<li class="{{= restriction.className }}"><span>{{= restriction.name }}</span></li>
					{{ }) }}
				</ul>
				<span class="text-italic small">Limits may apply. See policy brochure for more details.</span>
				{{ } }}

				{{ if(hospitalCover.exclusions.length > 0) { }}
				<h5>You will not be covered for the following services</h5>
				<ul class="exclusions">
					{{ _.each(hospitalCover.exclusions, function(exclusion){ }}
					<li>{{= exclusion.name }}</li>
					{{ }) }}

						{{ if (typeof custom !== 'undefined' && custom.info && custom.info.exclusions && custom.info.exclusions.cover) { }}
						<li class="text-danger"><span class="icon-cross" /></span>{{= custom.info.exclusions.cover }}</li>
						{{ } }}
				</ul>
				<content:get key="hospitalExclusionsDisclaimer"/>
				{{ } }}
			</div>
			{{ } }}
			</c:if>

			<c:if test="${moreinfolayout_splittest_default eq true}">
			{{ if(typeof extrasCover !== 'undefined') { }}
			<div class="col-xs-12 col-md-6 extrasCover">
            <c:choose>
                <c:when test="${callCentre}">
                <h2>Extras cover</h2>
                <p>Please refer to the Policy Brochure or the previous page</p>
                </c:when>
                <c:otherwise>
                {{ if (custom.info && custom.info.content && custom.info.content.moreInfo && custom.info.content.moreInfo.extras) { }}
                <h2>{{= custom.info.content.moreInfo.extras.label}}</h2>
                <p>{{= custom.info.content.moreInfo.extras.text}}</p>
                {{ } else { }}
				<h2>Extras cover</h2>
				<p>Please note that the below amounts are individual limits for each benefit. Group limits may apply to restrict these individual limits, meaning that the more you claim on one benefit, the less you might be able to claim on another benefit in the same group. Please refer to the Policy Brochure or the previous page for details.</p>
				<table class="extrasTable table table-bordered table-striped">
					<thead>
						<tr>
							<th>&nbsp;</th>
							<th>PER PERSON</th>
							<th>PER POLICY</th>
							<th>WAITING PERIOD</th>
						</tr>
					</thead>
					<tbody>
						{{ _.each(extrasCover.inclusions, function(inclusion){ }}
							<tr>
								<th>{{= inclusion.name }}</th>
								<td>{{= inclusion.benefitLimits.perPerson }}</td>
								<td>{{= inclusion.benefitLimits.perPolicy }}</td>
								<td>{{= inclusion.waitingPeriod }}</td>
							</tr>
						{{ }) }}
					</tbody>
				</table>
				{{ } }}
                </c:otherwise>
            </c:choose>
			</div>
			{{ } }}
			</c:if>

			<div class="policyBrochures col-xs-12">
				<div class="col-xs-12">
					<h2>Policy brochures</h2>
					<p>See your policy brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }} below for the full guide on policy limits, inclusions and exclusions</p>
				</div>

				<div class="col-xs-12 col-md-6">

					<div class="row">
						{{ if(typeof hospitalCover !== 'undefined' && typeof extrasCover !== 'undefined' && promo.hospitalPDF == promo.extrasPDF) { }}
						<div class="col-xs-12">
							<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-policy-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Policy Brochure</a>
						</div>
						{{ } else { }}

						{{ if(typeof hospitalCover !== 'undefined') { }}
						<div class="{{ if(typeof extrasCover !== 'undefined'){ }}col-sm-6{{ } }} col-xs-12">
							<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-hospital-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Hospital Policy Brochure</a>
						</div>
						{{ } }}

						{{ if(typeof extrasCover !== 'undefined') { }}
						<div class="{{ if(typeof hospitalCover !== 'undefined'){ }}col-sm-6{{ } }} col-xs-12 ">
							<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="btn download-extras-brochure col-xs-12">Extras Policy Brochure</a>
						</div>
						{{ } }}
						{{ } }}
					</div>

				</div>
				<div class="col-xs-12 col-md-6 moreInfoEmailBrochures" novalidate="novalidate">

					<div class="row formInput">
						<div class="col-sm-7 col-xs-12">
							<field_v2:email xpath="emailAddress"  required="true"
											 className="sendBrochureEmailAddress"
											 placeHolder="${emailPlaceHolder}" />
						</div>
						<div class="col-sm-5 hidden-xs">
							<a href="javascript:;" class="btn btn-save disabled btn-email-brochure" <field_v1:analytics_attr analVal="email button" quoteChar="\"" />>Email Brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }}</a>
						</div>
					</div>
					<div class="row row-content formInput optInMarketingRow">
						<div class="col-xs-12">
							<field_v2:checkbox className="optInMarketing checkbox-custom"
												xpath="health/sendBrochures/optInMarketing" required="false"
												value="Y" label="true"
												title="Stay up to date with news and offers direct to your inbox" />
						</div>
					</div>

					<div class="row row-content formInput hidden-sm hidden-md hidden-lg emailBrochureButtonRow">
						<div class="col-xs-12">
							<a href="javascript:;" class="btn btn-save disabled btn-email-brochure" <field_v1:analytics_attr analVal="email button" quoteChar="\"" />>Email Brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s" : "" }}</a>
						</div>
					</div>
					<div class="row row-content moreInfoEmailBrochuresSuccess hidden">
						<div class="col-xs-12">
							<div class="success alert alert-success">
								Success! Your policy brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s have" : " has" }} been emailed to you.
							</div>
						</div>
					</div>

				</div>
			</div>

			<div class="col-xs-12 switching">
				<h2>Switching is simple</h2>
				<ol>
					<li>You can change your fund whenever you like</li>
					<li>We'll pass your current fund details to your new fund, to transfer
						any hospital waiting periods that have already been served</li>
					<li>Most funds will give you immediate cover for the same extras benefits
						you were able to claim previously. Your old fund will reimburse any
						premiums paid in advance.</li>
				</ol>
			</div>
			<div class="col-xs-12 testimonials">
				<h2>Join the thousands of Australians who already have compared and saved</h2>
				<blockquote>
					<span class="openQuote">“</span>{{= testimonial.quote }}<span class="closeQuote">”</span>
				</blockquote>
				<p class="testimonialAuthor">{{= testimonial.author }}</p>
			</div>
		</div>

		<div class="hidden-xs hiddenInMoreDetails">
			{{= callToActionBarHtml }}
		</div>

	</div>

</script>

<health_v4_moreinfo:more_info_extras_limits />
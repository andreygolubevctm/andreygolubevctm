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
			<div class="col-xs-12 col-sm-9 moreInfoTopLeftColumn Hospital_container">
				<health_v4_moreinfo:more_info_product_summary />
				<health_v4_moreinfo:more_info_product_extra_info />
				<!-- Hospital and Extras -->
				<div class="benefitsOverflow">
					<div class="row">
						<div class="benefitsColumn">
							<div class="col-sm-6 col-xs-12 HospitalBenefits">
								<!-- Hospital Benefits Heading + Brochure -->
								<div class="row">
									<div class="col-xs-12">
										{{ if(typeof hospitalCover !== 'undefined') { }}
										<div class="row row-eq-height">
											<div class="col-xs-6">
											{{ } }}
										<h2>Hospital</h2>
										{{ if(typeof hospitalCover !== 'undefined') { }}
											</div>
											<div class="{{ if(typeof extrasCover !== 'undefined'){ }}col-xs-6{{ } }}">
												<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Download Brochure</a>
											</div>
										</div>
										{{ } }}
									</div>
								</div>

								<!-- Hospital Benefits -->
								<div class="row">
									<div class="col-xs-12 addBottomMargin">
										<h3>Excess</h3>
										{{= hospital.inclusions.excess }}
									</div>

									{{ if(typeof hospital.inclusions !== 'undefined') { }}
										<div class="col-xs-8 limitTitleLG">
											Co-Payment/ % Hospital Contribution
										</div>
										<div class="col-xs-4">
											{{= hospital.inclusions.copayment == '-' ? 'None' : hospital.inclusions.copayment }}
										</div>
										<div class="col-xs-8 limitTitleLG addTopMargin">
											Excess Waivers
										</div>
										<div class="col-xs-4 addTopMargin">
											{{= hospital.inclusions.waivers == '-' ? 'None' : hospital.inclusions.waivers }}
										</div>
									{{ } }}

									<div class="col-xs-12">
										<h3>Waiting Periods</h3>
									</div>

									{{ if(typeof hospital.inclusions !== 'undefined') { }}
										<div class="col-xs-8 limitTitleLG">
											Pre-existing conditions
										</div>
										<div class="col-xs-4">
											{{= hospital.inclusions.waitingPeriods.PreExisting }}
										</div>
										<div class="col-xs-8 limitTitleLG addTopMargin">
											All other conditions
										</div>
										<div class="col-xs-4 addTopMargin">
											{{= hospital.inclusions.waitingPeriods.Other }}
										</div>
									{{ } }}

									{{ if(typeof hospitalCover !== 'undefined') { }}
										<div class="col-xs-12 secondaryBrochureLink addTopMargin">
											<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12 leftAlignedLink" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Please download and refer to the Policy Brochure for details</a>
										</div>
									{{ } }}
								</div>

								<div class="row hospitalTabContainer">
									<div class="col-xs-12 moreInfoHospitalTab">
										<ul class="nav nav-tabs">
											<li>
												<a href="javascript:;" data-target=".hospitalCoveredPane"><h3>Covered <span class="benefitCount">{{= hospitalCover.inclusions.length }}</span></h3></a>
											</li>
											<li>
												<a href="javascript:;" data-target=".hospitalNotCoveredPane"><h3>Not Covered <span class="benefitCount pink">{{= hospitalCover.exclusions.length }}</span></h3></a>
											</li>
										</ul>
									</div>
								</div>

								<!-- Inclusions / Exclusions -->
								<div class="row tab-content">
									<div class="col-xs-12 tab-pane hospitalCoveredPane">
										{{ var benefitTemplate = meerkat.modules.templateCache.getTemplate($("#benefitLimitsTemplate")); }}
										{{ var product = Results.getSelectedProduct(); }}
										{{ product.structureIndex = 4; }}
										{{ product.showNotCoveredBenefits = false; }}
										{{ product.ignoreLimits = false; }}
										{{= benefitTemplate(product) }}
									</div>
									<div class="col-xs-12 tab-pane hospitalNotCoveredPane">
										{{ product.showNotCoveredBenefits = true; }}
										{{ product.ignoreLimits = true; }}
										{{= benefitTemplate(product) }}
									</div>
								</div>

								<!-- Restricted Benefits -->
								{{ if (hospitalCover.restrictions.length > 0) { }}
								<div class="row restrictedContainer">
									<div class="col-xs-12">
										<h3 class="heading">Restricted Benefits <span class="benefitCount gray">{{= hospitalCover.restrictions.length }}</span></h3>
										<p>These treatements are limited to the same amount you would receive in a public hoslita for those treatements.</p>
										{{ if(typeof hospitalCover !== 'undefined') { }}
											<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12 leftAlignedLink" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Please download and refer to the Policy Brochure</a>
										{{ } }}
										<p>Unsure? <span>Have a quick chat with our Experts</span></p>

										{{ _.each(hospitalCover.restrictions, function(restriction){ }}
										<div class="row {{= restriction.className }} benefitRow restricted">
											<div class="benefitContent">
												<div class="col-xs-12 benefitTitle">
													<p>{{= restriction.name }}</p>
												</div>
												<div class="col-xs-8 limitTitle">Waiting period</div><div class="col-xs-4 limitValue">{{= restriction.WaitingPeriod }}</div>
												<div class="col-xs-8 limitTitle">Benefit Limitation Period</div><div class="col-xs-4 limitValue">{{= restriction.benefitLimitationPeriod }}</div>
											</div>
										</div>
										{{ }) }}
									</div>
								</div>
								{{ } }}
							</div>
						</div>
						<div class="benefitsColumn">
							<div class="col-sm-6 col-xs-12 ExtrasBenefits">
								<!-- Extras Benefits Heading + Brochure -->
								<div class="row row-eq-height">
									{{ if(typeof extrasCover !== 'undefined') { }}
									<div class="col-xs-6">
									{{ } }}
									<h2>Extras</h2>
									{{ if(typeof extrasCover !== 'undefined') { }}
									</div>
									<div class="{{ if(typeof hospitalCover !== 'undefined'){ }}col-xs-6 {{ } }} ">
										<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="download-extras-brochure col-xs-12">Download brochure</a>
									</div>
									{{ } }}
								</div>

								<div class="row">
									<div class="col-xs-12 moreInfoExtrasTab">
										<ul class="nav nav-tabs">
											<li>
												<a href="javascript:;" data-target=".extrasCoveredPane"><h3>Covered <span class="benefitCount">{{= extrasCover.inclusions.length }}</span></h3></a>
											</li>
											<li>
												<a href="javascript:;" data-target=".extrasNotCoveredPane"><h3>Not Covered <span class="benefitCount pink">{{= extrasCover.exclusions.length }}</span></h3></a>
											</li>
										</ul>
									</div>
								</div>

								<!-- Inclusions / Exclusions -->
								<div class="row tab-content">
									<div class="col-xs-12 tab-pane extrasCoveredPane">
										{{ product.structureIndex = 5; }}
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

<health_v4_moreinfo:more_info_affixed_header />
<health_v4_moreinfo:more_info_affixed_header_mobile />
<health_v4_moreinfo:more_info_benefit_limits />
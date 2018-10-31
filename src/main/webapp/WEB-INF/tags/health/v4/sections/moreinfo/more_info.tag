<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="emailPlaceHolder">
	<content:get key="emailPlaceHolder"/>
</c:set>

<%-- Setup variables needed for dual pricing --%>
<health_v1:dual_pricing_settings />
<health_v4:pyrr_campaign_settings />

<c:if test="${isDualPriceActive eq true}">
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
			<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
		</div>
	</div>

</script>

<%-- MORE INFO TEMPLATE --%>
<script id="more-info-template" type="text/html">
	<%-- Prepare the price and dual price templates --%>
	{{ obj._selectedFrequency = Results.getFrequency(); }}
	{{ obj.mode = ''; }}
	{{ obj.renderedDualPricing = ''; }}
	{{ obj.displayLogo = false; }} <%-- Turns off the logo from the template --%>

	<%-- If dual pricing is enabled, update the template --%>
	{{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true && meerkat.modules.deviceMediaState.get() !== 'xs') { }}
		{{ obj.renderedDualPricing = meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false); }}
		{{ _.delay(function() { $('.dualPricingAffixedHeader').html(obj.renderedDualPricing);}); }}
	{{ } else if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
		{{ obj.renderedPyrrCampaign = meerkat.modules.healthPyrrCampaign.renderTemplate('', obj, true, false); }}
	{{ } else { }}
		{{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); }}
		{{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
		{{ obj.showAltPremium = false; obj.priceBreakdown = false; obj.renderedPriceTemplate = logoTemplate(obj) + priceTemplate(obj); }}
	{{ } }}

	<%-- Prepare the call to action bar template. --%>
	{{ var template = $("#more-info-call-to-action-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var callToActionBarHtml = htmlTemplate(obj); }}
	{{ var product = Results.getSelectedProduct(); }}
	{{ var benefitTemplate = meerkat.modules.templateCache.getTemplate($("#benefitLimitsTemplate")); }}

	<%-- Get the HTML header for mobile --%>
	{{ var headerMobileHtml = meerkat.modules.healthMoreInfo.getAffixedMobileHeaderData(); }}

	<c:set var="buyNowHeadingClass">
		<c:choose>
			<c:when test="${isDualPriceActive eq true}">hidden-xs</c:when>
			<c:otherwise>visible-xs</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="variantClassName">
		<c:if test="${moreinfo_splittest_default eq false}">more-info-content-variant</c:if>
	</c:set>

	{{= headerMobileHtml }}

	<div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content ${variantClassName}">

		<div class="fieldset-card row price-card <c:if test="${isDualPriceActive eq true}">hasDualPricing</c:if>">
				<health_v4_moreinfo:more_info_dual_pricing_header />
			<div class="moreInfoTopLeftColumn Hospital_container">
				<health_v4_moreinfo:more_info_product_summary />
                <health_v4_moreinfo:more_info_product_extra_info />
				<!-- Hospital and Extras -->
				<div class="benefitsOverflow">
					<div class="row">
						{{ if(typeof hospitalCover !== 'undefined') { }}
						<div class="benefitsColumn">
							<div class="col-sm-12 col-xs-12 HospitalBenefits">
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
											<div class="{{ if(typeof extrasCover !== 'undefined'){ }}col-xs-6{{ } }} text-right">
												<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn btn-secondary btn-sm btn-block download-hospital-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>View brochure</a>
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
										<div class="col-xs-6 limitTitleLG">
											Co-Payment/ % Hospital Contribution
										</div>
										<div class="col-xs-6">
											{{= hospital.inclusions.copayment == '-' ? 'None' : hospital.inclusions.copayment }}
										</div><div class="clearfix"></div>
										<div class="col-xs-6 limitTitleLG addTopMargin">
											Excess Waivers
										</div>
										<div class="col-xs-6 addTopMargin">
											{{= hospital.inclusions.waivers == '-' ? 'None' : hospital.inclusions.waivers }}
										</div><div class="clearfix"></div>
									{{ } }}

									<div class="col-xs-12">
										<h3>Waiting Periods</h3>
									</div>

									{{ if(typeof hospital.inclusions !== 'undefined') { }}
										<div class="col-xs-6 limitTitleLG">
											Pre-existing conditions
										</div>
										<div class="col-xs-6">
											{{= hospital.inclusions.waitingPeriods.PreExisting }}
										</div><div class="clearfix"></div>
										<div class="col-xs-6 limitTitleLG addTopMargin">
											All other conditions
										</div>
										<div class="col-xs-6 addTopMargin">
											{{= hospital.inclusions.waitingPeriods.Other }}
										</div><div class="clearfix"></div>
									{{ } }}

									{{ if(typeof hospitalCover !== 'undefined') { }}
										<div class="col-xs-12 secondaryBrochureLink addTopMargin">
											<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12 leftAlignedLink" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Download the policy brochure for more information.</a>
										</div>
									{{ } }}
								</div>

								<div class="row hospitalTabContainer">
									<div class="col-xs-12 moreInfoHospitalTab">
										<ul class="nav nav-tabs">
											<li>
												<a href="javascript:;" data-target=".hospitalCoveredPane"><h3 <field_v1:analytics_attr analVal="hospital - covered pane" quoteChar="\"" />>Covered <span class="benefitCount">{{= hospitalCover.inclusions.length }}</span></h3></a>
											</li>
											<li>
												<a href="javascript:;" data-target=".hospitalNotCoveredPane"><h3 <field_v1:analytics_attr analVal="hospital - covered pane" quoteChar="\"" />>Not Covered <span class="benefitCount pink">{{= hospitalCover.exclusions.length }}</span></h3></a>
											</li>
										</ul>
									</div>
								</div>

								<!-- Inclusions / Exclusions -->
								<div class="row tab-content">
									<div class="col-xs-12 tab-pane hospitalCoveredPane">
										{{ product.structureIndex = 4; }}
										{{ product.showNotCoveredBenefits = false; }}
										{{ product.ignoreLimits = false; }}
								        {{ if(meerkat.modules.healthMoreInfo.hasPublicHospital(hospitalCover.inclusions)) { }}
										<div class="row HLTicon-hospital benefitRow">
											<div class="benefitContent">
											<div class="col-xs-12 benefitTitle">
												<p>Public Hospital</p>
											</div>
										</div>
										</div>
								        {{ } }}
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
										<p>These treatments are limited to the same amount you would receive in a public hospital for those treatments.</p>
										{{ if(typeof hospitalCover !== 'undefined') { }}
											<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12 leftAlignedLink" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Download the policy brochure for more information.</a>
										{{ } }}

										{{ _.each(hospitalCover.restrictions, function(restriction){ }}
										<div class="row {{= restriction.className }} benefitRow restricted">
											<div class="benefitContent">
												<div class="col-xs-12 benefitTitle">
													<p>{{= restriction.name }}</p>
												</div>
												<div class="col-xs-6 limitTitle">Waiting period</div><div class="col-xs-6 limitValue">{{= restriction.WaitingPeriod }}</div>
												<div class="col-xs-6 limitTitle">Benefit Limitation Period</div><div class="col-xs-6 limitValue">{{= restriction.benefitLimitationPeriod }}</div>
												<div class="clearfix"></div>
											</div>
										</div>
										{{ }) }}
									</div>
								</div>
								{{ } }}
							</div>
						</div>
						{{ } }}
						{{ if(typeof extrasCover !== 'undefined') { }}
						<div class="benefitsColumn">
							<div class="col-sm-12 col-xs-12 ExtrasBenefits">
								<!-- Extras Benefits Heading + Brochure -->
								<div class="row row-eq-height">
									{{ if(typeof extrasCover !== 'undefined') { }}
									<div class="col-xs-6">
									{{ } }}
									<h2>Extras</h2>
									{{ if(typeof extrasCover !== 'undefined') { }}
									</div>
									<div class="{{ if(typeof hospitalCover !== 'undefined'){ }}col-xs-6 {{ } }} text-right">
										<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="btn btn-secondary btn-sm btn-block download-extras-brochure col-xs-12">View brochure</a>
									</div>
									{{ } }}
								</div>

								<div class="row">
									<div class="col-xs-12 moreInfoExtrasTab">
										<ul class="nav nav-tabs">
											<li>
												<a href="javascript:;" data-target=".extrasCoveredPane"><h3 <field_v1:analytics_attr analVal="extras - covered pane" quoteChar="\"" />>Covered <span class="benefitCount">{{= extrasCover.inclusions.length }}</span></h3></a>
											</li>
											<li>
												<a href="javascript:;" data-target=".extrasNotCoveredPane"><h3 <field_v1:analytics_attr analVal="extras - covered pane" quoteChar="\"" />>Not Covered <span class="benefitCount pink">{{= extrasCover.exclusions.length }}</span></h3></a>
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
						{{ } }}
					</div>
				</div>
                <reward:campaign_tile_container_xs />

				<div class="row">
					<div class="col-sm-4 col-sm-push-4">
						<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
					</div>
				</div>
			</div>
			<!-- CTA BUTTON -->
			<div class="hidden-xs moreInfoTopRightColumn">
                <div class="sidebar-widget">
					<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
				</div>

				<ad_containers:sidebar_top />

                <reward:campaign_tile_container />

				<health_v4:price_promise step="results/moreinfo" />

                <div class="sidebar-widget sidebar-widget-padded sidebar-widget-background-contained">
                    <h3>Switching is simple!</h3>
                    <ul>
                        <li>You can change funds whenever you like.</li>
                        <li>We'll pass your current insurance details to your new fund, to transfer any hospital waiting periods you've already served.</li>
                        <li>Every fund will give you immediate cover for the same extras benefits you were able to claim previously.</li>
                        <li>Your old fund will reimburse any premiums you've already paid in advance.</li>
                    </ul>
                </div>

				<ad_containers:sidebar_bottom />

            </div>
		</div>
	</div>
</script>

<health_v4_moreinfo:more_info_affixed_header />
<health_v4_moreinfo:more_info_affixed_header_mobile />
<health_v4_moreinfo:more_info_benefit_limits />
<health_v4_moreinfo:more_info_email_brochures />

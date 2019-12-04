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
			<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now<span class="icon-arrow-right" /></a>
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
	{{ obj.renderedAffixedHeaderPriceTemplate = meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false, null, true); }}
		{{ _.delay(function() { $('.dualPricingAffixedHeader').html(obj.renderedAffixedHeaderPriceTemplate);}); }}
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
            <div class="moreInfoSummaryContainer">
                <div class="container">
                    <div class="moreInfoTopLeftColumn Hospital_container">
                        <health_v4_moreinfo:more_info_product_summary />
                    </div>
					<div class="moreInfoTopRightColumn">
						<health_v4_moreinfo:more_info_product_widget />
					</div>
                </div>
            </div>
			<div class="moreInfoTopLeftColumn Hospital_container">
				<!-- Hospital and Extras -->
				<div class="benefitsOverflow">
					<div class="row">
						{{ if(hospital && typeof hospitalCover !== 'undefined') { }}
						<div class="benefitsColumn">
							<div class="col-sm-12 col-xs-12 HospitalBenefits">
								<!-- Hospital Benefits Heading + Brochure -->
									<c:set var="onlineHealthReformMessaging" scope="request"><content:get key="onlineHealthReformMessaging" /></c:set>
    							<c:if test="${onlineHealthReformMessaging eq 'Y'}">
    							<div class="reformHospitalTabs">
										{{ if (product.custom.reform.tab2.benefits && product.custom.reform.tab2.benefits.length > 0) { }}
										<button type="button" class="reformHospitalTabLink preAprilReformLink active">Covered now</button>
										<button type="button" class="reformHospitalTabLink postAprilReformLink">Covered from {{= custom.reform.changeDate }}</button>
										{{ } }}
									</div>
    							</c:if>
								<div class="row hospitalInfo">
									<div class="col-xs-12">
										<div class="row row-eq-height">
											<div class="col-xs-12 col-sm-6">
												<h2>Hospital cover</h2>
											</div>
											<div class="col-xs-12 col-sm-6 heading-brochure no-padding">
											{{ if(promo.hospitalPDF.indexOf('http') === -1) { }}
												<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />><img src="assets/brand/ctm/images/icons/brochure_icon.svg" width="11" height="13">&nbsp;View hospital brochure</a>
											{{ } else { }}
												<a href="{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />><img src="assets/brand/ctm/images/icons/brochure_icon.svg" width="11" height="13">&nbsp;View hospital brochure</a>
											{{ } }}
											</div>
										</div>
									</div>
								</div>

								<!-- Hospital Benefits -->
								<div class="row excessCoPayment">
									<div class="col-xs-12 col-sm-6 excessInfo hospitalCoverDetails">
										<div class="row preAprilReformContent">
											<div class="col-xs-8 hidden-xs">
												<h3>Excess</h3>
												<p class="hidden-xs">{{= custom.reform.tab1.excess }}</p><br/><br/>
												<h3>Excess Waivers</h3>
												<p class="hidden-xs">{{= hospital.inclusions.waivers }}</p>
											</div>
											<div class="col-xs-4">&nbsp;</div>
											<div class="col-xs-12 visible-xs">
												<h3>Excess</h3>
												<div>{{= custom.reform.tab1.excess }}</div><br/><br/>
												<h3>Excess Waivers</h3>
												<div>{{= hospital.inclusions.waivers }}</div>
											</div>
										</div>
										<div class="row postAprilReformContent">
											<div class="col-xs-8 hidden-xs">
												<h3>Excess</h3>
												<p class="hidden-xs">{{= custom.reform.tab2.excess }}</p><br/><br/>
												<h3>Excess Waivers</h3>
												<p class="hidden-xs">{{= hospital.inclusions.waivers }}</p>
											</div>
											<div class="col-xs-4">&nbsp;</div>
											<div class="col-xs-12 visible-xs">
												<h3>Excess</h3>
												<div>{{= custom.reform.tab2.excess }}</div><br/><br/>
												<h3>Excess Waivers</h3>
												<div>{{= hospital.inclusions.waivers }}</div>
											</div>
										</div>
									</div>

									{{ if(typeof hospital.inclusions !== 'undefined') { }}
									<div class="col-xs-12 col-sm-6 hospitalCoverDetails">
										<div class="row">
											<div class="col-xs-8">
												<h3>Co-payments</h3>
												<p>{{= hospital.inclusions.copayment }}</p>
											</div>
											<div class="col-xs-4">
												{{ if (hospital.inclusions.copayments.type == 'shared') { }}
													<span class="dollarValue">{{= hospital.inclusions.copayments.shared }}</span><br/>
													<span class="valueUnit">per day/night</span>
												{{ } }}

												{{ if (hospital.inclusions.copayments.type == 'private') { }}
													<span class="dollarValue">{{= hospital.inclusions.copayments.private }}</span><br/>
													<span class="valueUnit">per day/night</span>
												{{ } }}
											</div>
										</div>
									</div>
									{{ } }}
								</div>

								<div class="row preAprilReformContent">
									<div class="col-xs-12 tab-pane benefitTable">
										{{ product.structureIndex = 4; }}
										{{ product.showNotCoveredBenefits = false; }}
										{{ product.ignoreLimits = false; }}
										{{ var isMobile = meerkat.modules.deviceMediaState.get() === "xs"; }}
										{{ if(hospital && meerkat.modules.healthMoreInfo.hasPublicHospital(hospitalCover.inclusions)) { }}
										<div class="row benefitRow benefitRowHeader">
											<div class="col-xs-9 col-md-10 col-sm-10 col-lg-7 newBenefitRow benefitHeaderTitle">
												<div class="benefitRowTableCell">
													Hospital cover benefits
												</div>
											</div>
											<div class="col-xs-3 col-md-2 col-sm-2 newBenefitRow benefitHeaderTitle align-center">
												<div class="benefitRowTableCell">
													Included
												</div>
											</div>
											<div class="col-xs-3 col-sm-3 newBenefitRow benefitHeaderTitle align-center hidden-xs hidden-sm hidden-md">
												<div class="benefitRowTableCell">
													Waiting period
												</div>
											</div>
										</div>
										{{ } }}
										{{ _.each(product.custom.reform.tab1.benefits, function(benefit, key) { }}
										<div class="row benefitRow">
											<div class="col-xs-9 col-md-10 col-sm-10 col-lg-7 newBenefitRow benefitRowTitle">
												{{ var expanded = false; }}
												<div class="benefitRowTableCell">
													{{= benefit.category }}
													{{ if ((benefit.isclinicalcategory !== undefined && benefit.isclinicalcategory.toLowerCase() === "true") || isMobile) { }}
														<a class="extrasCollapseContentLink" data-toggle="collapse" href="#clinicalTab1CategoriesCollapsedContent-{{= key }}" aria-expanded="{{= expanded}}" aria-controls="collapseExample">
															<span class="{{= expanded ? 'icon-angle-up' : 'icon-angle-down' }}"></span>
															<span class="hidden-xs">{{= expanded ? '&nbsp;Less details' : '&nbsp;More details' }}</span>
														</a>
													{{ } }}
												</div>
											</div>
											<div class="col-xs-3 col-md-2 col-sm-2 newBenefitRow benefitRowTitle">
												<div class="benefitRowTableCell">
													<span class="newBenefitStatus benefitStatusIcon_{{= benefit.covered}}"></span>
												</div>
											</div>
											<div class="col-xs-3 col-sm-3 newBenefitRow benefitRowTitle align-center hidden-xs hidden-sm hidden-md">
												<div class="benefitRowTableCell">
													{{= benefit.waitingperiod}}
												</div>
											</div>
										</div>
										{{ if ((benefit.isclinicalcategory !== undefined && benefit.isclinicalcategory.toLowerCase() === "true") || isMobile) { }}
											<div class="row collapse benefitCollapsedContent" id="clinicalTab1CategoriesCollapsedContent-{{= key }}">
												<div class="col-xs-12 col-sm-8 visible-xs">
													<div class="row">
														<div class="col-xs-12 extraBenefitSubHeading"><strong>Waiting period</strong></div>
														<div class="col-xs-12 extraBenefitOption">{{= benefit.waitingperiod }}</div>
													</div>
												</div>
												{{ if (benefit.isclinicalcategory !== undefined && benefit.isclinicalcategory.toLowerCase() === "true") { }}
												<div class="col-xs-12 col-sm-12 extraBenefitSection">
													<div class="row">
														<div class="col-xs-12 extraBenefitSubHeading"><strong>Scope of cover:</strong></div>
														<div class="col-xs-12 extraBenefitOption">{{= benefit.scopeofcover }}</div>
													</div>
												</div>
												{{ } }}
											</div>
										{{ } }}
										{{ }); }}
									</div>
								</div>

								{{ if (!_.isNull(product.custom.reform.tab2.benefits) && product.custom.reform.tab2.benefits.length > 0) { }}
								<div class="row postAprilReformContent">
									<div class="col-xs-12 tab-pane benefitTable">
										{{ product.structureIndex = 4; }}
										{{ product.showNotCoveredBenefits = false; }}
										{{ product.ignoreLimits = false; }}
										<div class="row benefitRow benefitRowHeader">
											<div class="col-xs-9 col-md-10 col-sm-10 col-lg-7 newBenefitRow benefitHeaderTitle">
												<div class="benefitRowTableCell">
													Hospital cover benefits
												</div>
											</div>
											<div class="col-xs-3 col-md-2 col-sm-2 newBenefitRow benefitHeaderTitle align-center">
												<div class="benefitRowTableCell">
													Included
												</div>
											</div>
											<div class="col-xs-3 col-sm-3 newBenefitRow benefitHeaderTitle align-center hidden-xs hidden-sm hidden-md">
												<div class="benefitRowTableCell">
													Waiting period
												</div>
											</div>
										</div>
										{{ _.each(product.custom.reform.tab2.benefits, function(benefit, key){ }}
										<div class="row benefitRow">
											<div class="col-xs-9 col-md-10 col-sm-10 col-lg-7 newBenefitRow benefitRowTitle">
												{{ var expanded = false; }}
												<div class="benefitRowTableCell">
													{{= benefit.category }}
													{{ if ((benefit.isclinicalcategory !== undefined && benefit.isclinicalcategory.toLowerCase() === "true") || isMobile) { }}
													<a class="extrasCollapseContentLink" data-toggle="collapse" href="#clinicalTab2CategoriesCollapsedContent-{{= key }}" aria-expanded="{{= expanded}}" aria-controls="collapseExample">
														<span class="{{= expanded ? 'icon-angle-up' : 'icon-angle-down' }}"></span>
														<span class="hidden-xs">{{= expanded ? '&nbsp;Less details' : '&nbsp;More details' }}</span>
													</a>
													{{ } }}
												</div>
											</div>
											<div class="col-xs-3 col-md-2 col-sm-2 newBenefitRow benefitRowTitle">
												<div class="benefitRowTableCell">
													<span class="newBenefitStatus benefitStatusIcon_{{= benefit.covered}}"></span>
												</div>
											</div>
											<div class="col-xs-3 col-sm-3 newBenefitRow benefitRowTitle align-center hidden-sm hidden-md hidden-xs">
												<div class="benefitRowTableCell">
													{{= benefit.waitingperiod}}
												</div>
											</div>
										</div>
										{{ if (benefit.isclinicalcategory !== undefined && benefit.isclinicalcategory.toLowerCase() === "true") { }}
											<div class="row collapse benefitCollapsedContent" id="clinicalTab2CategoriesCollapsedContent-{{= key }}">
												<div class="col-xs-12 col-sm-8 visible-xs">
													<div class="row">
														<div class="col-xs-12 extraBenefitSubHeading"><strong>Waiting period</strong></div>
														<div class="col-xs-12 extraBenefitOption">{{= benefit.waitingperiod }}</div>
													</div>
												</div>
												{{ if (benefit.isclinicalcategory !== undefined && benefit.isclinicalcategory.toLowerCase() === "true") { }}
												<div class="col-xs-12 col-sm-12 extraBenefitSection">
													<div class="row">
														<div class="col-xs-12 extraBenefitSubHeading"><strong>Scope of cover:</strong></div>
														<div class="col-xs-12 extraBenefitOption">{{= benefit.scopeofcover }}</div>
													</div>
												</div>
												{{ } }}
											</div>
										{{ } }}
										{{ }) }}
									</div>
								</div>
								{{ } }}

								<!-- Restricted Benefits -->
								{{ if (hospital && hospitalCover.restrictions.length > 0) { }}
								<div class="row restrictedContainer">
									<div class="col-xs-12">
										<h3 class="heading">Restricted Benefits <span class="benefitCount gray">{{= hospitalCover.restrictions.length }}</span></h3>
										<p>These treatments are limited to the same amount you would receive in a public hospital for those treatments.</p>
										{{ if(hospital && typeof hospitalCover !== 'undefined') { }}
											{{ if(promo.hospitalPDF.indexOf('http') === -1) { }}
												<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12 leftAlignedLink" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Download the policy brochure for more information.</a>
											{{ } else { }}
												<a href="{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure col-xs-12 leftAlignedLink" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Download the policy brochure for more information.</a>
											{{ } }}
										{{ } }}
										{{ if(hospital) { }}
										{{ _.each(hospitalCover.restrictions, function(restriction){ }}
										<div class="row {{= restriction.className }} benefitRow restricted">
											<div class="benefitContent">
												<div class="col-xs-12 benefitTitle">
													<p>{{= restriction.name }}</p>
												</div>
												<div class="col-xs-6 limitTitle">Waiting period</div><div class="col-xs-6 limitValue">{{= restriction.waitingperiod }}</div>
												<div class="col-xs-6 limitTitle">Benefit Limitation Period</div><div class="col-xs-6 limitValue">{{= restriction.benefitLimitationPeriod }}</div>
												<div class="clearfix"></div>
											</div>
										</div>
										{{ }) }}
										{{ } }}
									</div>
								</div>
								{{ } }}
							</div>
						</div>
						{{ } }}
						{{ if(typeof extrasCover !== 'undefined') { }}
						<div class="benefitsColumn">
							<div class="col-xs-12 col-sm-12 ExtrasBenefits">
								<!-- Extras Benefits Heading + Brochure -->
								{{ if(typeof extrasCover !== 'undefined') { }}
								<div class="row row-eq-height">
									<div class="col-xs-12 col-sm-6 no-padding">
										<h2>Extras cover</h2>
									</div>
									<div class="col-xs-12 col-sm-6 heading-brochure no-padding">
										{{ if(promo.extrasPDF.indexOf('http') === -1) { }}
											<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="download-extras-brochure"><img src="assets/brand/ctm/images/icons/brochure_icon.svg" width="11" height="13">&nbsp;View extras brochure</a>
										{{ } else { }}
											<a href="{{= promo.extrasPDF }}" target="_blank" class="download-extras-brochure"><img src="assets/brand/ctm/images/icons/brochure_icon.svg" width="11" height="13">&nbsp;View extras brochure</a>
										{{ } }}
									</div>
								</div>
								{{ } }}

								<div class="row">
									<div class="col-xs-12 tab-pane benefitTable">
										{{ product.structureIndex = 5; }}
										{{ product.showNotCoveredBenefits = false; }}
										{{ product.ignoreLimits = false; }}
										{{ var featureIterator = product.childFeatureDetails || Features.getPageStructure(product.structureIndex); }}
										{{ if(hospital && meerkat.modules.healthMoreInfo.hasPublicHospital(hospitalCover.inclusions)) { }}
										<div class="row benefitRow benefitRowHeader">
											<div class="col-xs-9 col-md-10 col-sm-10 col-lg-7 newBenefitRow benefitHeaderTitle">
												<div class="benefitRowTableCell">
													Extras services
												</div>
											</div>
											<div class="col-sm-2 newBenefitRow benefitHeaderTitle align-center hidden-xs hidden-sm hidden-md">
												<div class="benefitRowTableCell">
													Annual limit
												</div>
											</div>
											<div class="col-xs-3 col-md-2 col-sm-2 col-lg-1 newBenefitRow benefitHeaderTitle align-center">
												<div class="benefitRowTableCell">
													Included
												</div>
											</div>
											<div class="col-sm-2 newBenefitRow benefitHeaderTitle align-center hidden-xs hidden-sm hidden-md">
												<div class="benefitRowTableCell">
													Waiting period
												</div>
											</div>
										</div>
										{{ } }}
										<%-- Refer to https://ctmaus.atlassian.net/browse/HREFORM-529. We are hiding naturopathy until this value is no longer sent from PHIO --%>
										{{ _.each(product.extras, function(benefit, key){ }}
										{{ if(!benefit || key.toLowerCase() === 'naturopathy') { }}
											{{ return; }}
										{{ } }}
										{{ if (typeof benefit === 'object') { }}
										{{ var benefitName = ''; }}
										{{ var featureIteratorChild; }}
										{{_.each(featureIterator[0].children, function(child) { }}
											{{ if (child.shortlistKey === key || child.name === key) { }}
												{{ featureIteratorChild = child; }}
												{{ benefitName = child.safeName; }}
											{{ } }}
										{{ }); }}
										<div class="row benefitRow">
											<div class="col-xs-9 col-md-10 col-sm-10 col-lg-7 newBenefitRow benefitRowTitle">
												<div class="benefitRowTableCell">
													{{= benefitName || key.replace(/([A-Z])/g, ' $1').trim() }}
													<a class="extrasCollapseContentLink" data-toggle="collapse" href="#extrasCollapsedContent-{{= key }}" aria-expanded="false" aria-controls="collapseExample">
														<span class="icon-angle-down"></span>
														<span class="hidden-xs">&nbsp;More details</span>
													</a>
												</div>
											</div>
											<div class="col-sm-2 newBenefitRow benefitRowTitle align-center hidden-xs hidden-sm hidden-md">
												<div class="benefitRowTableCell">
												{{ var coverType = window.meerkat.modules.healthSituation.getSituation(); }}
													{{ if((coverType === 'C' || coverType === 'SPF' || coverType === 'F') && benefit.benefitLimits.perPerson && benefit.benefitLimits.perPerson !== '-') { }}
														<div>per person: {{= benefit.benefitLimits.perPerson ? benefit.benefitLimits.perPerson : '' }}</div>
													{{ } }}
													
        								{{ if(benefit.benefitLimits.perPolicy !== '-' || benefit.benefitLimits.perPerson !== '-') { }}
        								    {{ if((coverType === 'SM' || coverType === 'SF') && benefit.benefitLimits.perPerson && benefit.benefitLimits.perPerson !== '-') { }}
        								        <div>per policy: {{= benefit.benefitLimits.perPerson ? benefit.benefitLimits.perPerson : '' }}</div>
        								    {{ }else{ }}
        								        <div>per policy: {{= benefit.benefitLimits.perPolicy ? benefit.benefitLimits.perPolicy : '' }}</div>
        								    {{ } }}
        								{{ } }}
												</div>
											</div>
											<div class="col-xs-3 col-md-2 col-sm-2 col-lg-1 newBenefitRow benefitRowTitle">
												<div class="benefitRowTableCell">
													<span class="newBenefitStatus benefitStatusIcon_{{= benefit.covered}}"></span>
												</div>
											</div>
											<div class="col-sm-2 newBenefitRow benefitRowTitle align-center hidden-xs hidden-sm hidden-md">
												<div class="benefitRowTableCell">
													{{= benefit.waitingPeriod.substring(0, 20) }}
												</div>
											</div>
										</div>
										<div class="row collapse benefitCollapsedContent" id="extrasCollapsedContent-{{= key }}">
											<div class="col-xs-12 visible-xs">
												<div class="row extraBenefitSubHeading">
													<div class="col-xs-9 extraBenefitOption">
														<strong>Waiting period</strong>
													</div>
													<div class="col-xs-3 extraBenefitOption align-center">
														{{= benefit.waitingPeriod.substring(0, 20) }}
													</div>
												</div>
											</div>
											<div class="col-xs-12 col-sm-12">
												<div class="row">
													<div class="col-xs-12 col-sm-6 extraBenefitSection">
														<div class="row">
															<div class="col-xs-12 col-sm-12 extraBenefitSubHeading"><strong>Claim Benefit:</strong></div>
															<div class="col-xs-12 col-sm-12">
																{{ if (benefit.benefits !== undefined) { }}
																	{{ _.each(benefit.benefits, function (option, key) { }}
																	<div class="row">
																		<div class="col-xs-9 col-sm-6 extraBenefitOption">
																		{{ if(featureIteratorChild) { }}
																			{{ var benefitLimitsName = ''; }}
																				{{ _.each(featureIteratorChild.children, function (child) { }}
																					{{ if(child.resultPath.substr(child.resultPath.lastIndexOf('.') + 1) === key) { }}
																						{{ benefitLimitsName = child.safeName; }}
																					{{ } }}
																				{{ }); }}
																			{{= benefitLimitsName }}
																		{{ } }}
																		</div>
																		<div class="col-xs-3 col-sm-6 extraBenefitOption align-center">
																			{{= option }}
																		</div>
																	</div>
																	{{ }); }}
																{{ } }}
																{{ _.each(benefit, function (option, key) { }}
																	{{ if ((key === 'benefitPayableInitial' || key === 'benefitpayableSubsequent' || key === 'listBenefitExample') && option) { }}
																	<div class="row">
																		<div class="col-xs-6 col-sm-6 extraBenefitOption">
																			{{ if(featureIteratorChild) { }}
																				{{ var benefitLimitsName = ''; }}
																				{{ _.each(featureIteratorChild.children, function (child) { }}
																					{{ if(child.resultPath.substr(child.resultPath.lastIndexOf('.') + 1) === key) { }}
																						{{ benefitLimitsName = child.safeName; }}
																					{{ } }}
																				{{ }); }}
																				{{= benefitLimitsName }}
																			{{ } }}
																		</div>
																		<div class="col-xs-6 col-sm-6 extraBenefitOption align-center">
																			{{ if(!option || option.trim() === '-') { }}
																				None
																			{{ } else { }}
																				{{= option }}
																			{{ } }}
																		</div>
																	</div>
																	{{ } }}
																{{ }); }}
															</div>
														</div>
													</div>
													<div class="col-xs-12 col-sm-6 extraBenefitSection">
														<div class="row">
															<div class="col-xs-12 extraBenefitSubHeading"><strong>Annual Limits:</strong></div>
															{{ if (benefit.benefitLimits !== undefined) { }}
															<div class="col-xs-12 col-sm-12">
																{{ _.each(benefit.benefitLimits, function (option, key) { }}
																	{{ var situation = window.meerkat.modules.healthSituation.getSituation(); }}
																	{{ var isSingle = situation === 'SM' || situation === 'SF'; }}
																	{{ var trimmedKey = key.replace(/([A-Z])/g, ' $1').trim().toLowerCase(); }}
																	{{ if(isSingle && trimmedKey === 'per person') { }}
																		{{ return; }}
																	{{ } }}
																{{ if(key !== 'annualLimit' && option) { }}
																<div class="row">
																	<div class="col-xs-9 col-sm-6 extraBenefitOption">
																	{{ var benefitLimitsName = key.replace(/([A-Z])/g, ' $1').trim(); }}
																	{{ if(featureIteratorChild) { }}
																		{{ _.each(featureIteratorChild.children, function (child) { }}
																			{{ if(child.resultPath.substr(child.resultPath.lastIndexOf('.') + 1) === key) { }}
																				{{ benefitLimitsName = child.safeName; }}
																			{{ } }}
																		{{ }); }}
																		{{= benefitLimitsName }}
																	{{ } else { }}
																		{{= benefitLimitsName }}
																	{{ } }}
																	</div>
																	<div class="col-xs-3 col-sm-6 extraBenefitOption align-center">
																		{{ if(!option || option.trim() === '-') { }}
																			None
																		{{ } else { }}
																			{{= option }}
																		{{ } }}
																	</div>
																</div>
																{{ } }}
																{{ }); }}
																{{ if(benefit.groupLimit) { }}
																{{ _.each(benefit.groupLimit, function (option, key) { }}
																{{ if(key !== 'annualLimit' && option) { }}
																<div class="row">
																	<div class="col-xs-9 col-sm-6 extraBenefitOption">
																	{{ var benefitGroupLimitName = key.replace(/([A-Z])/g, ' $1').trim(); }}
																	{{ if(featureIteratorChild) { }}
																		{{ _.each(featureIteratorChild.children, function (child) { }}
																			{{ if(child.resultPath.substr(child.resultPath.lastIndexOf('.') + 1) === key) { }}
																				{{ benefitGroupLimitName = child.safeName; }}
																			{{ } }}
																		{{ }); }}
																		{{= benefitGroupLimitName }}
																	{{ } else { }}
																		{{= benefitGroupLimitName }}
																	{{ } }}
																	</div>
																	<div class="col-xs-3 col-sm-6 extraBenefitOption align-center">
																		{{ if(!option || option.trim() === '-') { }}
																			None
																		{{ } else { }}
																			{{= option }}
																		{{ } }}
																	</div>
																</div>
																{{ } }}
																{{ }); }}
																{{ } }}
															</div>
															{{ } }}
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-4 hidden-xs">&nbsp;</div>

											{{ if (benefit.hasSpecialFeatures) { }}
											<div class="col-xs-12 col-sm-12 extraBenefitSection">
												<div class="row">
													<div class="col-xs-12 col-sm-12 extraBenefitSubHeading"><strong>Extra info:</strong></div>
													<div class="col-xs-12 col-sm-12 extraBenefitOption">{{= benefit.hasSpecialFeatures }}</div>
												</div>
											</div>
											{{ } }}
										</div>
										{{ } }}
										{{ }); }}
									</div>
								</div>
							</div>
						</div>
						{{ } }}
					</div>

					<health_v4_moreinfo:more_info_ambulance_cover />
				</div>
                <reward:campaign_tile_container_xs />

				<div class="row">
					<div class="col-sm-4 col-sm-push-4">
						<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now<span class="icon-arrow-right" /></a>
					</div>
				</div>
			</div>
			<!-- CTA BUTTON -->
			<div class="hidden-xs moreInfoTopRightColumn">

				<ad_containers:sidebar_top />

                <reward:campaign_tile_container />

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

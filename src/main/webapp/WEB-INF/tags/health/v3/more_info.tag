<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="emailPlaceHolder">
	<content:get key="emailPlaceHolder"/>
</c:set>

<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="simplesHealthReformMessaging" scope="request"><content:get key="simplesHealthReformMessaging" /></c:set>

<%-- Setup variables needed for dual pricing --%>
<health_v1:dual_pricing_settings />
<health_v1:pyrr_campaign_settings />

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
	{{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }}
		{{ obj.renderedDualPricing = meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false); }}
	{{ } else { }}
		{{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); }}
		{{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}

		{{ obj.showAltPremium = false; obj.renderedPriceTemplate = logoTemplate(obj) + priceTemplate(obj); }}
	{{ } }}

	{{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive(true) === true) { }}
		{{ obj.renderedPyrrCampaign = meerkat.modules.healthPyrrCampaign.renderTemplate('', obj, true, false); }}
	{{ } }}

	<%-- Check if drop dead date has passed --%>
	{{ var dropDatePassed = meerkat.modules.dropDeadDate.getDropDatePassed(obj); }}

	<%-- Prepare the call to action bar template. --%>
	{{ var template = $("#more-info-call-to-action-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var callToActionBarHtml = htmlTemplate(obj); }}

	{{ var comingSoonClass = ''; var priceContainerWidth = 'col-xs-6'; }}
	{{ if (!_.isUndefined(obj.altPremium[obj._selectedFrequency])) { }}
		{{ var productPremium = obj.altPremium[obj._selectedFrequency] }}
		{{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
	{{ } }}

	<c:set var="buyNowHeadingClass">
		<c:choose>
			<c:when test="${isDualPriceActive eq true}">hidden-xs</c:when>
			<c:otherwise>visible-xs</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="moreInfoTopLeftColumnWidth">
		<c:choose>
			<c:when test="${isDualPriceActive eq true}">col-md-9</c:when>
			<c:otherwise>col-sm-8</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="variantClassName">
		<c:if test="${moreinfo_splittest_default eq false}">more-info-content-variant</c:if>
	</c:set>
	<a data-slide-control="prev" href="javascript:;" class="hidden-xs btn btn-tertiary btn-close-more-info" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>< Back to results</a>
	<p class="referenceNo">Quote reference number <span>{{= transactionId }}</span></p>

	<c:if test="${empty callCentre}">
		<form_v3:save_results_button />
	</c:if>

	<div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content col-xs-12 ${variantClassName} {{= comingSoonClass }}">

		<div class="row price-card <c:if test="${isDualPriceActive eq true}">hasDualPricing</c:if> {{= dropDatePassed ? 'dropDatePassedContainer' : ''}}">
			<div class="${moreInfoTopLeftColumnWidth} moreInfoTopLeftColumn">
				<div class="row hidden-sm hidden-md hidden-lg">
					<div class="col-xs-3">
						<div class="companyLogo {{= info.provider }}-mi"></div>
					</div>
					<div class="col-xs-9 <c:if test="${isDualPriceActive eq true}">productDetails</c:if>">
						<h1 class="noTopMargin productName">{{= info.productTitle }}</h1>
					</div>
				</div>
				<div class="row priceRow productSummary hidden-xs">
					<div class="col-xs-12">
						<c:choose>
							<c:when test="${isDualPriceActive eq true}">
								{{= renderedDualPricing }}
							</c:when>
							<c:otherwise>
								<c:if test="${isPyrrActive eq true}">
									{{= renderedPyrrCampaign }}
								</c:if>
								{{= renderedPriceTemplate }}
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				<div class="row hidden-xs">
					<div class="col-xs-12 <c:if test="${isDualPriceActive eq true}">productDetails</c:if>">
						<h1 class="noTopMargin productName">{{= info.productTitle }}</h1>

						<div class="hidden-xs">
							{{ if (promo.promoText !== ''){ }}
							<p class="promoHeading">Buy now and benefit from these promotions</p>
							<p>{{= promo.promoText }}</p>
							{{ } else { }}
							<p class="promoHeading">Great choice!</p>
							<p class="noPromoText">This policy covers all of the things that you said were important to you.
								<span>Also, because health insurance prices are regulated, you’re paying no more through us than if you went directly to {{= info.providerName }}.</span></p>
							{{ }  }}
						</div>
                        <c:if test="${empty callCentre or not callCentre}">
                            {{= meerkat.modules.rewardCampaign.getCampaignContentHtml().find('.reward-more-info').prop('outerHTML') }}
                        </c:if>
					</div>
				</div>

					<div class="row priceRow productSummary hidden-sm hidden-md hidden-lg">
						<div class="col-xs-12 col-sm-8">
							<c:choose>
								<c:when test="${isDualPriceActive eq true}">
									{{= renderedDualPricing }}
								</c:when>
								<c:otherwise>
									{{= renderedPriceTemplate }}
								</c:otherwise>
							</c:choose>
						</div>
						<div class="col-xs-12 col-sm-4 text-right">
							<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now<span class="icon-arrow-right" /></a>
							</div>
					</div>

				<div class="row ${buyNowHeadingClass} hidden-sm hidden-md hidden-lg">
					<div class="col-xs-12">
						{{ if (promo.promoText !== ''){ }}
						<h2>Buy now and benefit from these promotions</h2>
						<p>{{= promo.promoText }}</p>
						{{ } }}
					</div>
				</div>

			</div>
			{{ var classification = meerkat.modules.healthResultsTemplate.getClassification(obj); }}
			<c:choose>
				<c:when test="${isDualPriceActive eq true}">
					<div class="col-md-3 hidden-xs moreInfoTopRightColumn">
						<div class="companyLogo {{= info.provider }}-mi"></div>
							<div class="insureNow">
								<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now ></a>
							</div>
							<c:if test="${simplesHealthReformMessaging eq 'active'}">
								<img class="simplesMoreInfoTierLogo" src="assets/graphics/health_classification/{{= classification.icon}}" height="42" />
							</c:if>
					</div>
				</c:when>
				<c:otherwise>
					<div class="col-sm-4 hidden-xs moreInfoTopRightColumn">
						<div class="companyLogo {{= info.provider }}-mi"></div>
						<div class="row">
							<div class="col-xs-12">
								<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now ></a>
								<c:if test="${simplesHealthReformMessaging eq 'active'}">
									<img class="simplesMoreInfoTierLogo" src="assets/graphics/health_classification/{{= classification.icon}}" height="42" />
								</c:if>
							</div>
						</div>
					</div>
				</c:otherwise>
			</c:choose>

			<div class="col-xs-12">
				<simples:dialogue id="99" vertical="health" />
			</div>

			<c:if test="${brand eq 'ctm'}">
				<div class="col-xs-12">
					<simples:dialogue id="100" vertical="health" />
				</div>
			</c:if>

			<div class="col-xs-12">
				<simples:dialogue id="84" vertical="health" />
			</div>

		</div>

		<div class="simplesMoreInfoReformTabs row">
			<button class="simplesMoreInfoTabLink simplesMoreInfoBeforeTab active" type="button">Health brochures before *date*</button>
			<button class="simplesMoreInfoTabLink simplesMoreInfoAfterTab" type="button">Health brochures after *date*</button>
		</div>
		<div class="fieldset-card row cover-card simplesMoreInfoHospitalCover simplesMoreInfoBeforeContent ${moreinfolayout_splittest_variant1 eq true ? 'moreinfolayout-splittest' : ''}">
			<c:if test="${moreinfolayout_splittest_default eq true}">
			{{ if(typeof hospital !== 'undefined' && typeof hospitalCover !== 'undefined') { }}
			<div class="col-xs-12 col-md-6 hospitalCover">
				{{ if(typeof hospital.inclusions !== 'undefined') { }}
				<h2>Hospital cover</h2>
				<p><strong>Hospital Excess:</strong><br>{{= hospital.inclusions.excess }}</p>
				<p><strong>Excess Waivers:</strong><br>{{= hospital.inclusions.waivers }}</p>
				<p><strong>Co-payment / % Hospital Contribution:</strong><br>{{= hospital.inclusions.copayment }}</p>

				<p><strong>Accident Override:</strong><br>
					{{ if(!_.isEmpty(obj.accident) && obj.accident.covered === 'Y') { }}
					{{= obj.accident.overrideDetails }}</p>
					{{ }else{ }}
						<strong>Covered: No</strong><br>
						{{= obj.accident.overrideDetails }}</p>
					{{ } }}
				{{ } }}
			</div>
			{{ } }}
			</c:if>

			<c:if test="${moreinfolayout_splittest_default eq true}">
				<div class="col-xs-12 col-md-6 extrasCover">
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits.length > 0) { }}
						<h5>Inclusions</h5>
						<ul>
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'Y') { }}
									<li class="simplesMoreInfoInclusions"><span>{{= benefit.name }}</span></li>
								{{ } }}
							{{ }) }}
						</ul>

						<h5>Restrictions</h5>
						<ul>
							{{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'R') { }}
									<li class="simplesMoreInfoInclusions"><span>{{= benefit.name }}</span></li>
								{{ } }}
							{{ }) }}
						</ul>

						<h5>Exclusions</h5>
						<ul>
							{{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
									<li class="simplesMoreInfoInclusions"><span>{{= benefit.name }}</span></li>
								{{ } }}
							{{ }) }}
						</ul>
					{{ } }}
				</div>
			</c:if>

            <c:if test="${empty callCentre or not callCentre}">
                <div class="col-xs-12">
                    <reward:campaign_tile_container_xs />
                </div>
            </c:if>
		</div>

		<div class="fieldset-card row cover-card simplesMoreInfoHospitalCover simplesMoreInfoAfterContent ${moreinfolayout_splittest_variant1 eq true ? 'moreinfolayout-splittest' : ''}">
			<c:if test="${moreinfolayout_splittest_default eq true}">
				{{ if(typeof hospital !== 'undefined' && typeof hospitalCover !== 'undefined') { }}
				<div class="col-xs-12 col-md-6 hospitalCover">
					{{ if(typeof hospital.inclusions !== 'undefined') { }}
					<h2>Hospital cover</h2>
					<p><strong>Hospital Excess:</strong><br>{{= hospital.inclusions.excess }}</p>
					<p><strong>Excess Waivers:</strong><br>{{= hospital.inclusions.waivers }}</p>
					<p><strong>Co-payment / % Hospital Contribution:</strong><br>{{= hospital.inclusions.copayment }}</p>

					<p><strong>Accident Override:</strong><br>
						{{ if(!_.isEmpty(obj.accident) && obj.accident.covered === 'Y') { }}
						{{= obj.accident.overrideDetails }}</p>
					{{ }else{ }}
					<strong>Covered: No</strong><br>
					{{= obj.accident.overrideDetails }}</p>
					{{ } }}
					{{ } }}
				</div>
				{{ } }}
			</c:if>

			<c:if test="${moreinfolayout_splittest_default eq true}">
				<div class="col-xs-12 col-md-6 extrasCover">
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits.length > 0) { }}
					<h5>Inclusions</h5>
					<ul>
						{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
						{{ if (benefit.covered === 'Y') { }}
						<li class="simplesMoreInfoInclusions"><span>{{= benefit.name }}</span></li>
						{{ } }}
						{{ }) }}
					</ul>

					<h5>Restrictions</h5>
					<ul>
						{{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
						{{ if (benefit.covered === 'R') { }}
						<li class="simplesMoreInfoInclusions"><span>{{= benefit.name }}</span></li>
						{{ } }}
						{{ }) }}
					</ul>

					<h5>Exclusions</h5>
					<ul>
						{{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
						{{ if (benefit.covered === 'N') { }}
						<li class="simplesMoreInfoInclusions"><span>{{= benefit.name }}</span></li>
						{{ } }}
						{{ }) }}
					</ul>
					{{ } }}
				</div>
			</c:if>

			<c:if test="${empty callCentre or not callCentre}">
				<div class="col-xs-12">
					<reward:campaign_tile_container_xs />
				</div>
			</c:if>
		</div>

        <div class="row ambulanceCoverSection">
            <h2 class="text-dark">Ambulance cover</h2>
            <div class="col-xs-12 benefitTable">
                <div class="row benefitRow benefitRowHeader">
                    <div class="col-xs-8 newBenefitRow benefitHeaderTitle">
                        Ambulance service
                    </div>
                    <div class="col-xs-4 newBenefitRow benefitHeaderTitle align-center">
                        Waiting period
                    </div>
                </div>
                <div class="row benefitRow">
                    <div class="col-xs-8 newBenefitRow benefitRowTitle">
                        {{= obj.ambulance.otherInformation }}
                    </div>
                    <div class="col-xs-4 newBenefitRow benefitRowTitle align-center">
                        {{= obj.ambulance.waitingPeriod }}
                    </div>
                </div>
            </div>
        </div>

		<div class="row policyBrochures">
			<div class="col-xs-12">
				<h2 class="text-dark">Policy brochures</h2>
				<p class="text-bold">See your policy brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }} below for the full guide on policy limits, inclusions and exclusions</p>
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

				<div class="row">
					<div class="col-xs-12">
						<textarea rows="10" id="selectedProductUrlTextArea" class="col-xs-12 hidden addTopMargin" aria-invalid="false"></textarea>
					</div>
				</div>

				<div class="row hidden copy-append-offer-row addTopMargin">
					<div class="col-xs-6">
						<a href="javascript:;" class="btn btn-save btn-copy-selected-product-url" <field_v1:analytics_attr analVal="Copy Product Link button" quoteChar="\"" />>Copy Link</a>
					</div>
					<div class="col-xs-6">
						<field_v2:checkbox className="checkbox-custom pull-right hidden"
										   xpath="health/sendBrochures/appendOffer" required="false"
										   value="Y" label="true"
										   title="Append Offer" />
					</div>
				</div>

			</div>

			<div class="col-xs-12 col-md-6 moreInfoEmailBrochures" novalidate="novalidate">

				<div class="row formInput">
					<div class="col-sm-7 col-xs-12">
						<field_v2:email xpath="emailAddress"  required="false"
										className="sendBrochureEmailAddress"
										placeHolder="${emailPlaceHolder}" />
					</div>
					<div class="col-sm-5 hidden-xs">
						<a href="javascript:;" class="btn btn-save disabled btn-email-brochure btn-block" <field_v1:analytics_attr analVal="email button" quoteChar="\"" />>Email Brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }}</a>
					</div>

					<div class="col-sm-5 hidden-xs">
						<a href="javascript:;" class="btn btn-save disabled btn-get-selected-product-url btn-block addTopMargin" <field_v1:analytics_attr analVal="Get Product Link button" quoteChar="\"" />>Get Product Link</a>
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
				<div class="row row-content moreInfoEmailBrochuresSuccess hidden addTopMargin">
					<div class="col-xs-12">
						<div class="success alert alert-success">
							Success! Your policy brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s have" : " has" }} been emailed to you.
						</div>
					</div>
				</div>

			</div>
		</div>

		<div class="hidden-xs hiddenInMoreDetails">
			{{= callToActionBarHtml }}
		</div>

	</div>

</script>

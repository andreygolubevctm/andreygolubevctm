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
    {{ var product = Results.getSelectedProduct(); }}

    {{ var comingSoonClass = ''; var priceContainerWidth = 'col-xs-6'; }}
    {{ if (!_.isUndefined(obj.altPremium[obj._selectedFrequency])) { }}
    {{ var productPremium = obj.altPremium[obj._selectedFrequency] }}
    {{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
    {{ } }}

    <%-- Vars for custom Ambulance and Accident scripting --%>
    {{ var ambulanceSelected = meerkat.modules.healthBenefitsStep.isAmbulanceSelected(); }}
    {{ var accidentSelected = meerkat.modules.healthBenefitsStep.isAccidentSelected(); }}

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

    {{ if((product.info.providerName === 'TUH') || (product.info.providerName === 'Union Health')) { }}
        <simples:dialogue id="224" vertical="health" />
    {{ } }}

    <div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content col-xs-12 ${variantClassName} {{= comingSoonClass }}">

        <div class="row price-card <c:if test="${isDualPriceActive eq true}">hasDualPricing</c:if> {{= dropDatePassed ? 'dropDatePassedContainer' : ''}}">
            <div class="${moreInfoTopLeftColumnWidth} moreInfoTopLeftColumn">
                <div class="row hidden-sm hidden-md hidden-lg">
                    <div class="col-xs-3">
                        <div class="companyLogo {{= info.provider }}-mi"></div>
                    </div>
                    <div class="col-xs-9 <c:if test="${isDualPriceActive eq true}">productDetails</c:if>">
                        <h1 class="noTopMargin productName">{{= info.productTitle }}</h1>
                        <div class="about-this-fund-row">
                            <a href="javascript:;" class="about-this-fund">About this fund</a>
                        </div>
                    </div>
                </div>
                <div class="row priceRow productSummary">
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
                        <div class="about-this-fund-row">
                            <a href="javascript:;" class="about-this-fund">About this fund</a>
                        </div>
                        <div class="hidden-xs">
                            {{ if (promo.promoText !== ''){ }}
                            <p class="promoHeading">Buy now and benefit from these promotions</p>
                            <p>{{= promo.promoText }}</p>
                            {{ } else { }}
                            <p class="promoHeading">Great choice!</p>
                            <p class="noPromoText">This policy covers all of the things that you said were important to you. Also, because health insurance prices are regulated, you&apos;re paying no more through us than if you went directly to {{= info.providerName }}.</p>
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
            {{ var isExtrasOnly = info.ProductType === 'Ancillary' || info.ProductType === 'GeneralHealth'; }}
            {{ var icon = isExtrasOnly ? 'small-height' : classification.icon; }}
            {{ var classificationDate = ''; }}

            {{ if(classification.date && classification.icon !== 'gov-unclassified') { }}
            {{ classificationDate = 'As of ' + classification.date; }}
            {{ } }}

            <c:choose>
                <c:when test="${isDualPriceActive eq true}">
            <div class="col-md-3 hidden-xs moreInfoTopRightColumn">
                <div class="companyLogo {{= info.provider }}-mi"></div>
                <div class="insureNow">
                    <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now <span class="icon-arrow-right" /></a>
                </div>
                <c:if test="${simplesHealthReformMessaging eq 'Y'}">
                    {{ if(!isExtrasOnly) { }}
                <div class="results-header-classification">
                    <div class="simplesMoreInfoTierLogo {{= icon}}"></div>
                </div>
                    {{ } }}
                </c:if>
            </div>
                </c:when>
                <c:otherwise>
            <div class="col-sm-4 hidden-xs moreInfoTopRightColumn">
                <div class="companyLogo {{= info.provider }}-mi"></div>
                <div class="row">
                    <div class="col-xs-12">
                        <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now <span class="icon-arrow-right" /></a>
                        <c:if test="${simplesHealthReformMessaging eq 'Y'}">
                            {{ if(!isExtrasOnly) { }}
                            <div class="results-header-classification">
                                <div class="simplesMoreInfoTierLogo {{= icon}}"></div>
                            </div>
                            {{ } }}
                        </c:if>
                    </div>
                </div>
            </div>
                </c:otherwise>
            </c:choose>
        </div>

        {{ var coverType = meerkat.modules.healthBenefitsStep.getCoverType(); }}
        {{ var limitedCover = meerkat.modules.healthBenefitsStep.getLimitedCover() == "Y" ? true : false; }}
        {{ var isLimitedProduct = !_.isUndefined(hospital.inclusions) && hospital.inclusions.LimitedProduct === true; }}
        {{ var isOutbound = meerkat.modules.healthContactType.is('outbound'); }}
        {{ var isInbound = meerkat.modules.healthContactType.is('inbound'); }}
        {{ var isEnergyCrossSell = meerkat.modules.healthContactType.is('energyCrossSell'); }}
        {{ var isEnergyTransfer = meerkat.modules.healthContactType.is('energyTransfer'); }}
        {{ var isNextGenOutbound = meerkat.modules.healthContactType.is('nextgenOutbound'); }}
        {{ var isNextGenCli = meerkat.modules.healthContactType.is('nextgenCLI'); }}
        {{ var isCLI = meerkat.modules.healthContactType.is('cli'); }}
        {{ var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits(); }}
        {{ var selectedBenefits = meerkat.modules.healthBenefitsStep.getHospitalBenefitsModel().filter(function(benefit) { return selectedBenefitsList.indexOf(benefit.value) > -1; }); }}
        {{ var scriptTerm = 'everything'; }}
        {{ var isBasic = custom.reform.tier && custom.reform.tier.toLowerCase().indexOf('basic') > -1; }}
        {{ if(!limitedCover || (limitedCover && !isLimitedProduct)) { }}
        <simples:dialogue id="126" vertical="health" dynamic="true" />
        {{ } }}
        {{ if(isOutbound || isNextGenOutbound || isInbound || isEnergyCrossSell || isEnergyTransfer || isCLI) { }}
            {{ scriptTerm = 'anything'; }}
            {{ if(custom.reform.scripting !== 'D') { }}
                {{ if(coverType !== 'c' && coverType !== 'h') { }}
        <simples:dialogue id="127" vertical="health" dynamic="true" />
                {{ } }}
            {{ } }}
        {{ } }}

        {{ if (['A', 'B1', 'B2', 'C'].includes(custom.reform.scripting)) { }}

            {{ var exclusionsListArr = []; }}
            {{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
                {{ if (benefit.covered === 'N') { }}
                    {{ exclusionsListArr.push(benefit.category); }}
                {{ } }}
            {{ }); }}
            {{ var exclusionsList = exclusionsListArr.join(", "); }}

            {{ var restrictionsListArr = []; }}
            {{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
                {{ if (benefit.covered === 'R') { }}
                    {{ restrictionsListArr.push(benefit.category); }}
                {{ } }}
            {{ }); }}
            {{ var restrictionsList = restrictionsListArr.join(", "); }}

            {{ if(classification.icon !== 'gov-gold') { }}
                <simples:dialogue id="217" vertical="health" />
            {{ } }}
        {{ } }}

        <div class="fieldset-card row cover-card simplesMoreInfoHospitalCover simplesMoreInfoBeforeContent ${moreinfolayout_splittest_variant1 eq true ? 'moreinfolayout-splittest' : ''}">
        <c:if test="${moreinfolayout_splittest_default eq true}">

            {{ if (custom.reform.scripting === 'D') { }}
                {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && custom.reform.tab1.limited  !== null) { }}
                    {{ if(classification.icon === 'gov-basic') { }}
                        <simples:dialogue id="216" vertical="health" />
                    {{ } }}
                    {{ if(classification.icon === 'gov-basic-plus') { }}
                        <simples:dialogue id="227" vertical="health" />
                    {{ } }}
                {{ } }}
            {{ } }}

            {{ if(typeof hospital !== 'undefined' && typeof hospitalCover !== 'undefined') { }}
            <div class="col-xs-12 col-md-6 hospitalCover">
                {{ if(typeof hospital.inclusions !== 'undefined') { }}
                <h2>Hospital cover</h2>
                <p class="red"><strong>Hospital Excess:</strong><br>{{= custom.reform.tab1.excess }}</p>
                <p><strong>Excess Waivers:</strong><br>{{= hospital.inclusions.waivers }}</p>

                {{ if(custom.reform.tab1.coPayment !== 'No Co-Payment') { }}
                    <p class="red"><strong>Co-payment / % Hospital Contribution:</strong><br>{{= custom.reform.tab1.coPayment }}</p>
                {{ }else { }}
                    <p><strong>Co-payment / % Hospital Contribution:</strong><br>{{= custom.reform.tab1.coPayment }}</p>
                {{ } }}

                <p class="{{= !_.isEmpty(obj.accident) && obj.accident.covered === 'Y' && ['gov-basic-plus', 'gov-basic'].includes(classification.icon) ? 'red' : '' }}">
                    <strong>Accident Override:</strong>
                    {{ if(accidentSelected) { }}
                    <span class="checkbox ambulanceAccidentCoverCheckbox">
						<input type="checkbox" name="health_simples_dialogue-radio-accidentcover" id="health_simples_dialogue-radio-accidentcover" class="checkbox-custom checkbox" value="READNOW" data-msg-required="Please confirm you have read the Accident Override copy" required="required">
						<label for="health_simples_dialogue-radio-accidentcover"></label>
					</span>
                    {{ } }}
                    <br>
                    {{ if(accidentSelected) { }}<span class="highlight">{{ } }}
					{{ if(!_.isEmpty(obj.accident) && obj.accident.covered === 'Y') { }}
					{{= obj.accident.overrideDetails }}
					{{ }else{ }}
						<strong>Covered: No</strong><br>
						{{= obj.accident.overrideDetails }}
					{{ } }}
					{{ if(accidentSelected) { }}
					</span>
                    {{ } }}
                </p>
                {{ } }}
            </div>
            {{ } }}
            </c:if>

            <c:if test="${moreinfolayout_splittest_default eq true}">
                <div class="col-xs-12 col-md-6 extrasCover">
                    {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && custom.reform.tab1.limited  !== null) { }}
                    <div class="checkbox scripting-text"><input type="checkbox" name="health_simples_dialogue-radio-810-2" id="limited_cover_scripting_tab_1" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="" required="required"><label for="limited_cover_scripting_tab_1">{{= custom.reform.tab1.limited }}</label></div><br/><br/>
                    {{ } else { }}
                    {{ if (custom.reform.tab1 && custom.reform.tab1.benefits && custom.reform.tab1.benefits.length > 0) { }}
                    {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && meerkat.modules.healthBenefitsStep.showTabOneCheckboxes(custom.reform)) { }}
                    <div class="checkbox"><input type="checkbox" name="health_simples_dialogue-radio-911" id="limited_cover_scripting_tab_1_inclusions_checkbox" class="checkbox-custom checkbox" value="" data-msg-required="" required="required">
                        <label for="limited_cover_scripting_tab_1_inclusions_checkbox">Inclusions</label>
                    </div><br/>
                    {{ } else { }}
                    <h5>Inclusions</h5>
                    {{ } }}
                    <ul>
                        {{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
                        {{ if (benefit.covered === 'Y') { }}
                        <li class="simplesMoreInfoInclusions"><span>{{= benefit.category }}</span></li>
                        {{ } }}
                        {{ }) }}
                    </ul>

                    {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && meerkat.modules.healthBenefitsStep.showTabOneCheckboxes(custom.reform)) { }}
                    <div class="checkbox"><input type="checkbox" name="health_simples_dialogue-radio-912" id="limited_cover_scripting_tab_1_restrictions_checkbox" class="checkbox-custom checkbox" value="" data-msg-required="" required="required">
                        <label for="limited_cover_scripting_tab_1_restrictions_checkbox">Restrictions</label>
                    </div><br/>
                    {{ } else { }}
                    <h5>Restrictions</h5>
                    {{ } }}
                    <ul>
                        {{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
                        {{ if (benefit.covered === 'R') { }}
                        <li class="simplesMoreInfoInclusions"><span>{{= benefit.category }}</span></li>
                        {{ } }}
                        {{ }); }}
                    </ul>

                    {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && meerkat.modules.healthBenefitsStep.showTabOneCheckboxes(custom.reform)) { }}
                    <div class="checkbox"><input type="checkbox" name="health_simples_dialogue-radio-913" id="limited_cover_scripting_tab_1_exclusions_checkbox" class="checkbox-custom checkbox" value="" data-msg-required="" required="required">
                        <label for="limited_cover_scripting_tab_1_exclusions_checkbox">Exclusions</label>
                    </div><br/>
                    {{ } else { }}
                    <h5>Exclusions</h5>
                    {{ } }}
                    <ul>
                        {{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
                        {{ if (benefit.covered === 'N') { }}
                        <li class="simplesMoreInfoInclusions"><span>{{= benefit.category }}</span></li>
                        {{ } }}
                        {{ }); }}
                    </ul>
                    {{ } }}
                    {{ } }}
                </div>
            </c:if>

            <c:if test="${empty callCentre or not callCentre}">
                <div class="col-xs-12">
                    <reward:campaign_tile_container_xs />
                </div>
            </c:if>
        </div>

        <c:if test="${simplesHealthReformMessaging eq 'Y'}">
            <div class="fieldset-card row cover-card simplesMoreInfoHospitalCover simplesMoreInfoAfterContent ${moreinfolayout_splittest_variant1 eq true ? 'moreinfolayout-splittest' : ''}">
                <c:if test="${moreinfolayout_splittest_default eq true}">
                    {{ if (custom.reform.scripting === 'C') { }}
                    <div class="simplesReformScriptingBox scriptingFlagContent row">
                        {{ if (custom.reform.tab2 && custom.reform.tab2.benefits && custom.reform.tab2.benefits.length > 0) { }}
                        <div class="readInclusionsFlag row row-content">
                            <div class="col-sm-1 no-padding">
                                <div class="checkbox">
                                    <input type="checkbox" name="health_simples_dialogue-radio-761" id="after_read_inclusions_scripting_C" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" data-attach="true" value="READNOW" data-msg-required="{{= readInclusionScriptingValidationMessage }}" required="required">
                                    <label for="after_read_inclusions_scripting_C"></label>
                                </div>
                            </div>
                            <div class="col-sm-11 padding">
								<span class="clinicalCatInfo">
									But the changes on {{= custom.reform.changeDate }} mean your hospital policy

									{{ var tab2exclusions = ''; var tab2exclusionsIndex = 0; }}
									{{ var tab2restrictions = ''; var tab2restrictionsIndex = 0; }}

									{{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
										{{ if (benefit.covered === 'N') { }}
											{{ tab2exclusions += (tab2exclusionsIndex > 0 ? ', ' : '') + benefit.category; tab2exclusionsIndex++; }}
										{{ } else if (benefit.covered === 'R') { }}
											{{ tab2restrictions += (tab2restrictionsIndex > 0 ? ', ' : '') + benefit.category; tab2restrictionsIndex++; }}
										{{ } }}
									{{ }); }}

									{{ if (tab2exclusions.length) { }}
										will then exclude
										{{= tab2exclusions }}
									{{ } else { }}
									 	<b>will have no exclusions</b>
									{{ } }}

									{{ if (tab2restrictions.length) { }}
										and have restricted cover for
										{{= tab2restrictions }}
									{{ } else { }}
										<b>and will have no restrictions.</b>
									{{ } }}
									every other category is covered. Does that make sense?
								</span>
                            </div>
                        </div>
                        {{ } }}

                        <div class="readWelcomeFlag">
                            Great, we'll send the full documents at the end of the call, but based on what you've told me, you are covered for all the things you said are most important.
                        </div>
                    </div>
                    {{ } }}

                    {{ if (custom.reform.scripting === 'D') { }}
                    {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && custom.reform.tab1.limited === null && custom.reform.tab2.limited  !== null) { }}
                    {{ if(classification.icon === 'gov-basic') { }}
                        <simples:dialogue id="216" vertical="health" />
                    {{ } }}
                    {{ if(classification.icon === 'gov-basic-plus') { }}
                        <simples:dialogue id="227" vertical="health" />
                    {{ } }}
                    {{ } }}
                    {{ } }}

                    {{ if(typeof hospital !== 'undefined' && typeof hospitalCover !== 'undefined') { }}
                    <div class="col-xs-12 col-md-6 hospitalCover">
                        {{ if(typeof hospital.inclusions !== 'undefined') { }}
                        <h2>Hospital cover</h2>

                        <p class="red">
                            <strong>Hospital Excess:</strong><br>
                            {{ if(custom.reform.tab2.excess !== custom.reform.tab1.excess) { }}
                            <span class="scripting-text"><strong>{{= custom.reform.tab2.excess }}</strong></span>
                            {{ }else { }}
                            <span>{{= custom.reform.tab2.excess }}</span>
                            {{ } }}
                        </p>

                        <p><strong>Excess Waivers:</strong><br>{{= hospital.inclusions.waivers }}</p>

                        {{ if(custom.reform.tab1.coPayment !== 'No Co-Payment') { }}
                            <p class="red"><strong>Co-payment / % Hospital Contribution:</strong><br>
                        {{ }else { }}
                            <p><strong>Co-payment / % Hospital Contribution:</strong><br>
                        {{ } }}

                            {{ if(custom.reform.tab2.coPayment !== custom.reform.tab1.coPayment) { }}
                            <span class="scripting-text"><strong>{{= custom.reform.tab2.coPayment }}</strong></span>
                            {{ }else { }}
                            <span>{{= custom.reform.tab2.coPayment }}</span>
                            {{ } }}
                        </p>

                        <p class="{{= !_.isEmpty(obj.accident) && obj.accident.covered === 'Y' && ['gov-basic-plus', 'gov-basic'].includes(classification.icon) ? 'red' : '' }}">
                            <strong>Accident Override:</strong>
                            {{ if(accidentSelected) { }}
                            <span class="checkbox ambulanceAccidentCoverCheckbox">
							<input type="checkbox" name="health_simples_dialogue-radio-accidentcover" id="health_simples_dialogue-radio-accidentcover" class="checkbox-custom checkbox" value="READNOW" data-msg-required="Please confirm you have read the Accident Override copy" required="required">
							<label for="health_simples_dialogue-radio-accidentcover"></label>
						</span>
                            {{ } }}
                            <br>
                            {{ if(accidentSelected) { }}<span class="highlight">{{ } }}
						{{ if(!_.isEmpty(obj.accident) && obj.accident.covered === 'Y') { }}
						{{= obj.accident.overrideDetails }}
						{{ }else{ }}
						<strong>Covered: No</strong><br>
						{{= obj.accident.overrideDetails }}
						{{ } }}
						{{ } }}
						{{ if(accidentSelected) { }}
						</span>
                            {{ } }}
                        </p>
                    </div>
                    {{ } }}
                </c:if>

                <c:if test="${moreinfolayout_splittest_default eq true}">
                    <div class="col-xs-12 col-md-6 extrasCover">
                        {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && custom.reform.tab2.limited  !== null) { }}
                        <div class="checkbox scripting-text"><input type="checkbox" name="health_simples_dialogue-radio-810-1" id="limited_cover_scripting_tab_2" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="" required="required">
                            <label for="limited_cover_scripting_tab_2">{{= custom.reform.tab2.limited }}</label>
                        </div><br/>
                        {{ } else { }}
                        {{ if (custom.reform.tab2 && custom.reform.tab2.benefits && custom.reform.tab2.benefits.length > 0) { }}
                        {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && meerkat.modules.healthBenefitsStep.showTabTwoCheckboxes(custom.reform)) { }}
                        <div class="checkbox"><input type="checkbox" name="health_simples_dialogue-radio-911" id="limited_cover_scripting_tab_2_inclusions_checkbox" class="checkbox-custom checkbox" value="" data-msg-required="" required="required">
                            <label for="limited_cover_scripting_tab_2_inclusions_checkbox">Inclusions</label>
                        </div><br/>
                        {{ } else { }}
                        <h5>Inclusions</h5>
                        {{ } }}

                        <ul>
                            {{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
                            {{ if (benefit.covered === 'Y') { }}
                            <li class="simplesMoreInfoInclusions"><span>{{= benefit.category }}</span></li>
                            {{ } }}
                            {{ }) }}
                        </ul>

                        {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && meerkat.modules.healthBenefitsStep.showTabTwoCheckboxes(custom.reform)) { }}
                        <div class="checkbox"><input type="checkbox" name="health_simples_dialogue-radio-911" id="limited_cover_scripting_tab_2_restrictions_checkbox" class="checkbox-custom checkbox" value="" data-msg-required="" required="required">
                            <label for="limited_cover_scripting_tab_2_restrictions_checkbox">Restrictions</label>
                        </div><br/>
                        {{ } else { }}
                        <h5>Restrictions</h5>
                        {{ } }}

                        <ul>
                            {{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
                            {{ if (benefit.covered === 'R') { }}
                            <li class="simplesMoreInfoInclusions"><span>{{= benefit.category }}</span></li>
                            {{ } }}
                            {{ }) }}
                        </ul>

                        {{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && meerkat.modules.healthBenefitsStep.showTabTwoCheckboxes(custom.reform)) { }}
                        <div class="checkbox"><input type="checkbox" name="health_simples_dialogue-radio-911" id="limited_cover_scripting_tab_2_exclusions_checkbox" class="checkbox-custom checkbox" value="" data-msg-required="" required="required">
                            <label for="limited_cover_scripting_tab_2_exclusions_checkbox">Exclusions</label>
                        </div><br/>
                        {{ } else { }}
                        <h5>Exclusions</h5>
                        {{ } }}

                        <ul>
                            {{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
                            {{ if (benefit.covered === 'N') { }}
                            <li class="simplesMoreInfoInclusions"><span>{{= benefit.category }}</span></li>
                            {{ } }}
                            {{ }) }}
                        </ul>
                        {{ } }}
                        {{ } }}
                    </div>
                </c:if>

                <c:if test="${empty callCentre or not callCentre}">
                    <div class="col-xs-12">
                        <reward:campaign_tile_container_xs />
                    </div>
                </c:if>
            </div>
        </c:if>

        <simples:dialogue id="128" vertical="health" />

        {{ if (['c', 'e'].includes(coverType)) { }}
        <div class="row extrasCoverSection">
            <h2 class="text-dark">Extras cover</h2>
            <h3 class="text-dark">(&nbsp;<img src="assets/brand/ctm/images/icons/selected_extras_fav.svg" width="26" height="26" />&nbsp;selected extras)</h3>
            <div class="col-xs-12 benefitTable">
                {{ product.structureIndex = 5; }}
                {{ product.showNotCoveredBenefits = false; }}
                {{ product.ignoreLimits = false; }}
                {{ var featureIterator = product.childFeatureDetails || Features.getPageStructure(product.structureIndex); }}
                <div class="row benefitRow benefitRowHeader">
                    <div class="col-xs-7 newBenefitRow benefitHeaderTitle">
                        Extras services
                    </div>
                    <div class="col-xs-2 newBenefitRow benefitHeaderTitle align-center">
                        Annual Limit
                    </div>
                    <div class="col-xs-1 newBenefitRow benefitHeaderTitle align-center">
                        Included
                    </div>
                    <div class="col-xs-2 newBenefitRow benefitHeaderTitle align-center">
                        Waiting period
                    </div>
                </div>
                {{ _.each(extras, function(benefit, key){ }}
                <%-- Refer to https://ctmaus.atlassian.net/browse/HREFORM-529. We are hiding naturopathy until this value is no longer sent from PHIO --%>
                {{ if(!benefit || key.toLowerCase() === 'naturopathy') { }}
                {{ return; }}
                {{ } }}
                {{ if (typeof benefit === 'object') { }}
                {{ var benefitName = ''; }}
                {{ var featureIteratorChild; }}
                {{_.each(featureIterator[0].children, function(child) { }}
                {{ if (child.shortlistKey === key || child.name === key) { }}
                {{ featureIteratorChild = child; }}
                {{ benefitName = child.safeName }}
                {{ } }}
                {{ }); }}
                {{ var expanded = false; }}
                {{ var selectedExtrasBenefits = meerkat.modules.healthBenefitsStep.getSelectedBenefits(); }}
                {{ if (selectedExtrasBenefits.indexOf(key) !== -1) { }}
                {{ expanded = true; }}
                <health_v3:selected_extras_template />
                {{ } }}
                {{ } }}
                {{ }); }}

                {{ _.each(extras, function(benefit, key){ }}
                <%-- Refer to https://ctmaus.atlassian.net/browse/HREFORM-529. We are hiding naturopathy until this value is no longer sent from PHIO --%>
                {{ if(!benefit || key.toLowerCase() === 'naturopathy') { }}
                {{ return; }}
                {{ } }}
                {{ if (typeof benefit === 'object') { }}
                {{ var benefitName = ''; }}
                {{ var featureIteratorChild; }}
                {{_.each(featureIterator[0].children, function(child) { }}
                {{ if (child.shortlistKey === key || child.name === key) { }}
                {{ featureIteratorChild = child; }}
                {{ benefitName = child.safeName }}
                {{ } }}
                {{ }); }}
                {{ var expanded = false; }}
                {{ var selectedExtrasBenefits = meerkat.modules.healthBenefitsStep.getSelectedBenefits(); }}
                {{ if (selectedExtrasBenefits.indexOf(key) === -1) { }}
                <health_v3:selected_extras_template />
                {{ } }}
                {{ } }}
                {{ }); }}
            </div>
        </div>
        {{ } }}

        <simples:dialogue id="130" vertical="health" mandatory="true" dynamic="true" />

        <div class="row ambulanceCoverSection">
            <h2 class="text-dark">Ambulance cover
                {{ var isSpecialCaseAIA = obj.info.FundCode === 'MYO' && !['QLD', 'TAS'].includes(obj.info.State); }} <%-- MYO is AIA --%>
                {{ if(ambulanceSelected || isSpecialCaseAIA) { }}
                <span class="checkbox ambulanceAccidentCoverCheckbox">
					<input type="checkbox" name="health_simples_dialogue-radio-ambulancecover" id="health_simples_dialogue-radio-ambulancecover" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="Please confirm you have read the Ambulance Cover copy" required="required">
					<label for="health_simples_dialogue-radio-ambulancecover"></label>
	            </span>
                {{ } }}
            </h2>
            <div class="col-xs-12 benefitTable">
                <div class="row benefitRow benefitRowHeader">
                    <div class="col-xs-8 newBenefitRow benefitHeaderTitle">
                        Ambulance service
                    </div>
                    <div class="col-xs-4 newBenefitRow benefitHeaderTitle align-center">
                        Waiting period
                    </div>
                </div>
                <div class="row benefitRow {{ if(ambulanceSelected || isSpecialCaseAIA) { }}highlight{{ } }}">
                    <div class="col-xs-8 newBenefitRow benefitRowTitle">
                        {{= obj.ambulance.otherInformation }}
                    </div>
                    <div class="col-xs-4 newBenefitRow benefitRowTitle align-center">
                        {{= obj.ambulance.waitingPeriod }}
                    </div>
                </div>
            </div>
        </div>

        <div>
            <simples:dialogue id="129" vertical="health" dynamic="true" />
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
                        {{ if(promo.hospitalPDF.indexOf('http') === -1) { }}
                        <a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-policy-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Policy Brochure</a>
                        {{ } else { }}
                        <a href="{{= promo.hospitalPDF }}" target="_blank" class="btn download-policy-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Policy Brochure</a>
                        {{ } }}
                    </div>
                    {{ } else { }}

                    {{ if(typeof hospitalCover !== 'undefined') { }}
                    <div class="{{ if(typeof extrasCover !== 'undefined'){ }}col-sm-6{{ } }} col-xs-12">
                        {{ if(promo.hospitalPDF.indexOf('http') === -1) { }}
                        <a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-hospital-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Hospital Policy Brochure</a>
                        {{ } else { }}
                        <a href="{{= promo.hospitalPDF }}" target="_blank" class="btn download-hospital-brochure col-xs-12" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>Hospital Policy Brochure</a>
                        {{ } }}
                    </div>
                    {{ } }}

                    {{ if(typeof extrasCover !== 'undefined') { }}
                    <div class="{{ if(typeof hospitalCover !== 'undefined'){ }}col-sm-6{{ } }} col-xs-12 ">
                        {{ if(promo.extrasPDF.indexOf('http') === -1) { }}
                        <a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="btn download-extras-brochure col-xs-12">Extras Policy Brochure</a>
                        {{ } else { }}
                        <a href="{{= promo.extrasPDF }}" target="_blank" class="btn download-extras-brochure col-xs-12">Extras Policy Brochure</a>
                        {{ } }}
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

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
							<div class="about-this-fund-row">
        				<a href="javascript:;" class="about-this-fund">About this fund</a>
    					</div>
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
							<div class="about-this-fund-row">
        				<a href="javascript:;" class="about-this-fund">About this fund</a>
    					</div>
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
								<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now <span class="icon-arrow-right" /></a>
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
								<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now <span class="icon-arrow-right" /></a>
								<c:if test="${simplesHealthReformMessaging eq 'active'}">
									<img class="simplesMoreInfoTierLogo" src="assets/graphics/health_classification/{{= classification.icon}}" height="42" />
								</c:if>
							</div>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>

		{{ if (['A', 'B1', 'B2', 'C'].includes(custom.reform.scripting)) { }}
		<div class="simplesReformScriptingBox row">
			<div class="col-sm-12 no-padding">
				{{ if (['A', 'B1'].includes(custom.reform.scripting)) { }}
				<p>So with the hospital cover, we have made sure <strong>everything you</strong> mentioned as important will be covered, like most policies there are some additional services covered as well as services that are excluded or restricted. We will send those across in a welcome pack, I can either read the exclusions and restrictions now or are you happy to just look through those in your own time?</p>
				{{ } }}

				{{ if (['B2'].includes(custom.reform.scripting)) { }}
				<p>So with the hospital cover, we have made sure <strong>everything</strong> mentioned as important will be covered, like most policies there are some services that are excluded or restricted, <strong>nothing</strong> you’ve mentioned as important, we will send those across in a welcome pack, I can either read them now or are you happy to just look through those in your own time?</p>
				{{ } }}

				{{ if (['C'].includes(custom.reform.scripting)) { }}
				<p>So with this hospital policy, <strong>everything</strong> mentioned as important is covered. This policy will have <strong>some</strong> changes on {{= custom.reform.changeDate }}  to services that you <strong>haven’t</strong> mentioned as important. We will send those changes across in a welcome pack and I can read these for you now, or keeping in mind that the <strong>important</strong> services will continue to be covered, are you happy to just look through those in your own time?</p>
				{{ } }}
			</div>
			<div class="scriptingOptions col-sm-12 no-padding">
				<div class="row">
					<div class="col-sm-4 no-padding">&nbsp;</div>
					<div class="col-sm-8 no-padding">
						<div class="row row-content">
							<div class="col-sm-6 no-padding">
								<div class="checkbox">
									<input type="radio" name="health_simples_dialogue-radio-76" id="checkbox_inclusion_details" class="checkbox-custom checkbox" value="READNOW" data-msg-required="Please choose the method that the client would like to be informed of the inclusions and exclusions." required="required">
									<label for="checkbox_inclusion_details">Read me inclusion/exclusion details</label>
								</div>
							</div>
							<div class="col-sm-6 no-padding">
								<div class="checkbox">
									<input type="radio" name="health_simples_dialogue-radio-76" id="checkbox_welcome_pack" class="checkbox-custom checkbox" value="READNOW" data-msg-required="Please choose the method that the client would like to be informed of the inclusions and exclusions." required="required">
									<label for="checkbox_welcome_pack">Read me the welcome pack</label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		{{ } }}

		<div class="simplesMoreInfoReformTabs row">
			{{ if (custom.reform.tab2.benefits && custom.reform.tab2.benefits.length === 0) { }}
				<button class="simplesMoreInfoTabLink simplesMoreInfoBeforeTab active" type="button">
					 Cover Details
				</button>
			{{ } else if (custom.reform.tab2.benefits && custom.reform.tab2.benefits.length > 0) { }}
				<button class="simplesMoreInfoTabLink simplesMoreInfoBeforeTab active" type="button">
					Cover before {{= custom.reform.changeDate }}
				</button>
			{{ } }}

			{{ if (custom.reform.tab2.benefits && custom.reform.tab2.benefits.length > 0) { }}
				<button class="simplesMoreInfoTabLink simplesMoreInfoAfterTab" type="button">
					Cover after {{= custom.reform.changeDate }}
				</button>
			{{ } }}
		</div>
		<div class="fieldset-card row cover-card simplesMoreInfoHospitalCover simplesMoreInfoBeforeContent ${moreinfolayout_splittest_variant1 eq true ? 'moreinfolayout-splittest' : ''}">
			<c:if test="${moreinfolayout_splittest_default eq true}">
			{{ if (custom.reform.tab2 && custom.reform.tab2.benefits && custom.reform.tab2.benefits.length > 0) { }}
				{{ var readInclusionScriptingValidationMessage = 'Please confirm that script on tab Cover before ' + custom.reform.changeDate + ' and tab Cover after ' + custom.reform.changeDate + ' has been read out to the customer.'; }}
			{{ } else { }}
				{{ var readInclusionScriptingValidationMessage = 'Please confirm that this script has been read out to the customer.'; }}
			{{ } }}

			<div class="simplesReformScriptingBox scriptingFlagContent row">
				{{ if (custom.reform.scripting === 'A') { }}
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits && custom.reform.tab1.benefits.length > 0) { }}
					<div class="readInclusionsFlag row-content row">
						<div class="col-sm-1 no-padding">
							<div class="checkbox">
								<input type="checkbox" name="health_simples_dialogue-radio-760" id="read_inclusions_scripting_A" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="{{= readInclusionScriptingValidationMessage }}" required="required">
								<label for="read_inclusions_scripting_A"></label>
							</div>
						</div>
						<div class="col-sm-11 no-padding">
							<span class="clinicalCatInfo">
							There are 38 clinical categories a policy can cover, out of those this policy does not pay benefits towards
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
									{{= benefit.category }},
								{{ } }}
							{{ }); }}
							and pays restricted benefits for
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'R') { }}
									{{= benefit.category }},
								{{ } }}
							{{ }); }}
							every other category is covered.</span><br/><br/>
							Based on our conversation these restrictions and exclusions are there to ensure you are not paying for things you don't need, should that change in the future you can add any of those additional services at any time, and you'll just need to serve the relevant waiting periods.
						</div>
					</div>
					{{ } }}

					<div class="readWelcomeFlag row">
						Great, we'll send the full documents at the end of the call, but based on what you've told me, you are covered for all the things you said are most important.
					</div>
				{{ } }}

				{{ if (custom.reform.scripting === 'B1') { }}
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits && custom.reform.tab1.benefits.length > 0) { }}
					<div class="readInclusionsFlag row row-content">
						<div class="col-sm-1 no-padding">
							<div class="checkbox">
								<input type="checkbox" name="health_simples_dialogue-radio-760" id="read_inclusions_scripting_B1" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="{{= readInclusionScriptingValidationMessage }}" required="required">
								<label for="read_inclusions_scripting_B1"></label>
							</div>
						</div>
						<div class="col-sm-11 no-padding">
							<span class="clinicalCatInfo">
								{{ var exclusions = ''; var exclusionsIndex = 0; }}
								{{ var restrictions = ''; var restrictionsIndex = 0; }}

								{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
										{{ exclusions += (exclusionsIndex > 0 ? ', ' : '') + benefit.category; exclusionsIndex++; }}
									{{ } else if (benefit.covered === 'R') { }}
										{{ restrictions += (restrictionsIndex > 0 ? ', ' : '') + benefit.category; restrictionsIndex++; }}
								{{ } }}
								{{ }); }}

								{{ if(exclusions.length) { }}
								This policy excludes
								{{= exclusions }}
								{{ } else { }}
									This policy excludes <b>no exclusions </b>
								{{ } }}

							{{ if(restrictions.length) { }}
								and there is restricted cover for
								{{= restrictions }}
								{{ } else { }}
								and there is restricted cover for <b>no restrictions </b>
							{{ } }}
							</span><br/><br/>
							Based on our conversation these restrictions and exclusions are there to ensure you are not paying for things you don't need, should that change in the future you can add any of those additional services at any time, and you'll just need to serve the relevant waiting periods. <br/><br/>

							<b>ONLY READ IF CUSTOMER ASKS THE FOLLOWING QUESTIONS</b><br/>
							<b>What’s the product changing to? (if we know customer’s needs are within the CTM benefit)</b><br/>
							<span class="clinicalCatInfo">
								I can’t tell you exactly what the changes are, but I can tell you <strong>everything</strong> you’ve mentioned as important <strong>will continue to be covered</strong>, the only changes may be to services that you haven’t mentioned as important, and the health fund is <strong>required</strong> to tell you well in <strong>advance</strong> of any changes.
							</span><br/><br/>

							<b>What’s the product changing to? (if we know customer’s needs are outside the CTM benefits)</b><br/>
							<span class="clinicalCatInfo">
								The fund hasn’t released the changes on this policy <strong>just yet</strong>, the health funds are <strong>required</strong> to tell you <strong>well in advance</strong> of any changes, but until then, you have the peace of mind to know <strong>everything</strong> you’ve mentioned as important to you is covered.
							</span>
						</div>
					</div>
					{{ } }}

					<div class="readWelcomeFlag">
						Great, we'll send the full documents at the end of the call, but based on what you've told me,
						you are covered for all the things you said are most important.<br/><br/>

						<b>ONLY READ IF CUSTOMER ASKS THE FOLLOWING QUESTIONS</b><br/>
						<b>What’s the product changing to? (if we know customer’s needs are within the CTM benefit)</b><br/>
						<span class="clinicalCatInfo">
							I can’t tell you exactly what the changes are, but I can tell you <strong>everything</strong> you’ve mentioned as important <strong>will continue to be covered</strong>, the only changes may be to services that you haven’t mentioned as important, and the health fund is required to tell you <strong>well in advance</strong> of any changes.
						</span><br/><br/>

						<b>What’s the product changing to? (if we know customer’s needs are outside the CTM benefits)</b><br/>
						<span class="clinicalCatInfo">
							The fund hasn’t released the changes on this policy <strong>just yet</strong>, the health funds are <strong>required</strong> to tell you <strong>well in advance</strong> of any changes, but until then, you have the peace of mind to know <strong>everything</strong> you’ve mentioned as important to you is covered.
						</span>
					</div>
				{{ } }}

				{{ if (custom.reform.scripting === 'B2') { }}
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits && custom.reform.tab1.benefits.length > 0) { }}
					<div class="readInclusionsFlag row row-content">
						<div class="col-sm-1 no-padding">
							<div class="checkbox">
								<input type="checkbox" name="health_simples_dialogue-radio-760" id="read_inclusions_scripting_B2" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="{{= readInclusionScriptingValidationMessage }}" required="required">
								<label for="read_inclusions_scripting_B2"></label>
							</div>
						</div>
						<div class="col-sm-11 no-padding">
							<span class="clinicalCatInfo">
								{{ var exclusions = ''; var exclusionsIndex = 0; }}
								{{ var restrictions = ''; var restrictionsIndex = 0; }}

								{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
										{{ exclusions += (exclusionsIndex > 0 ? ', ' : '') + benefit.category; exclusionsIndex++; }}
									{{ } else if (benefit.covered === 'R') { }}
										{{ restrictions += (restrictionsIndex > 0 ? ', ' : '') + benefit.category; restrictionsIndex++; }}
								{{ } }}
								{{ }); }}

								{{ if(exclusions.length) { }}
								This policy excludes
								{{= exclusions }}
								{{ } else { }}
								This policy excludes <b>no exclusions </b>
								{{ } }}

							{{ if(restrictions.length) { }}
								and there is restricted cover for
								{{= restrictions }}
								{{ } else { }}
								and there is restricted cover for <b>no restrictions </b>
							{{ } }}
							</span><br/><br/>
							Based on our conversation these restrictions and exclusions are there to ensure you are not paying for things you don't need, should that change in the future you can add any of those additional services at any time, and you'll just need to serve the relevant waiting periods. <br/><br/>

							<b>ONLY READ IF CUSTOMER ASKS THE FOLLOWING QUESTIONS</b><br/>
							<b>What’s the product changing to?</b><br/>
							<span class="clinicalCatInfo">
								The fund hasn’t released the changes on this policy <strong>just yet</strong>, the health funds are <strong>required</strong> to tell you <strong>well in advance</strong> of any changes, but until then, you have the peace of mind to know <strong>everything</strong> you’ve mentioned as important to you is covered.
							</span>
						</div>
					</div>
					{{ } }}

				<div class="readWelcomeFlag">
					Great, we'll send the full documents at the end of the call, but based on what you've told me, you
					are covered for all the things you said are most important.<br/><br/>

					<b>ONLY READ IF CUSTOMER ASKS THE FOLLOWING QUESTIONS</b><br/>
					<b>What’s the product changing to?</b><br/>
					<span class="clinicalCatInfo">
						The fund hasn’t released the changes on this policy <strong>just yet</strong>, the health funds are <strong>required</strong> to tell you <strong>well in advance</strong> of any changes, but until then, you have the peace of mind to know <strong>everything</strong> you’ve mentioned as important to you is covered.
					</span>
				</div>
				{{ } }}

				{{ if (custom.reform.scripting === 'C') { }}
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits && custom.reform.tab1.benefits.length > 0) { }}
					<div class="readInclusionsFlag row row-content">
						<div class="col-sm-1 no-padding">
							<div class="checkbox">
								<input type="checkbox" name="health_simples_dialogue-radio-760" id="before_read_inclusions_scripting_C" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="{{= readInclusionScriptingValidationMessage }}" required="required">
								<label for="before_read_inclusions_scripting_C"></label>
							</div>
						</div>
						<div class="col-sm-11 no-padding">
							<span class="clinicalCatInfo">
								So prior to the changes on {{= custom.reform.changeDate }} 

								{{ var exclusions = ''; var exclusionsIndex = 0; }}
								{{ var restrictions = ''; var restrictionsIndex = 0; }}

								{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
										{{ exclusions += (exclusionsIndex > 0 ? ', ' : '') + benefit.category; exclusionsIndex++; }}
									{{ } else if (benefit.covered === 'R') { }}
										{{ restrictions += (restrictionsIndex > 0 ? ', ' : '') + benefit.category; restrictionsIndex++; }}
								{{ } }}
								{{ }); }}

								{{ if(exclusions.length) { }}
								this policy excludes
								{{= exclusions }}
								{{ } else { }}
								This policy excludes <b>no exclusions </b>
								{{ } }}

							{{ if(restrictions.length) { }}
								and there is restricted cover for
								{{= restrictions }}
								{{ } else { }}
								and there is restricted cover for <b>no restrictions </b>
							{{ } }}
							</span>
						</div>
					</div>
					{{ } }}

					<div class="readWelcomeFlag">
						Great, we'll send the full documents at the end of the call, but based on what you've told me, you are covered for all the things you said are most important.
					</div>
				{{ } }}
			</div>

			{{ if (custom.reform.scripting === 'D') { }}
			<div class="simplesReformScriptingBox row row-content">
				{{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && custom.reform.tab1.limited  !== null) { }}
				<div class="row">
					<div class="col-sm-1 no-padding">
						<div class="checkbox">
							<input type="checkbox" name="health_simples_dialogue-radio-810" id="limited_cover_scripting_tab_1_not_null" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="{{= readInclusionScriptingValidationMessage }}" required="required">
							<label for="limited_cover_scripting_tab_1_not_null"></label>
						</div>
					</div>
					<div class="col-sm-11 no-padding">
							<span class="clinicalCatInfo">
							A limited hospital product is one that coves only 10 or less of the items for which Medicare pays a benefit. These policies provide lower than average cover and in some instances will only cover treatment as a result of an accident. Considering what we have discussed would you be comfortable with this level of cover?
							</span><br/><br/>
					</div>
				</div>
				{{ } }}
			</div>
			{{ } }}

			{{ if(typeof hospital !== 'undefined' && typeof hospitalCover !== 'undefined') { }}
			<div class="col-xs-12 col-md-6 hospitalCover">
				{{ if(typeof hospital.inclusions !== 'undefined') { }}
				<h2>Hospital cover</h2>
				<p><strong>Hospital Excess:</strong><br>{{= custom.reform.tab1.excess }}</p>
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
					{{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && custom.reform.tab1.limited  !== null) { }}
						<div class="checkbox"><input type="checkbox" name="health_simples_dialogue-radio-810-2" id="limited_cover_scripting_tab_1" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="" required="required"><label for="limited_cover_scripting_tab_1">{{= custom.reform.tab1.limited }}</label></div><br/><br/>
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
				<div class="row row-content">
					<div class="col-sm-1 no-padding">
						<div class="checkbox">
							<input type="checkbox" name="health_simples_dialogue-radio-810-3" id="limited_cover_scripting_tab_2_not_null" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="{{= readInclusionScriptingValidationMessage }}" required="required">
							<label for="limited_cover_scripting_tab_2_not_null"></label>
						</div>
					</div>
					<div class="col-sm-11 no-padding">
						<span class="clinicalCatInfo">
							A limited hospital product is one that coves only 10 or less of the items for which Medicare pays a benefit. These policies provide lower than average cover and in some instances will only cover treatment as a result of an accident. Considering what we have discussed would you be comfortable with this level of cover?
						</span><br/><br/>
					</div>
				</div>
				{{ } }}
				{{ } }}

				{{ if(typeof hospital !== 'undefined' && typeof hospitalCover !== 'undefined') { }}
				<div class="col-xs-12 col-md-6 hospitalCover">
					{{ if(typeof hospital.inclusions !== 'undefined') { }}
					<h2>Hospital cover</h2>
					{{ if (custom.reform.tab1.excess === custom.reform.tab2.excess) { }}
						<p>
							<strong>Hospital Excess:</strong><br>
							<span class="scripting-text"><strong>{{= custom.reform.tab2.excess }}</strong></span>
						</p>
					{{ } else { }}
						<p><strong>Excess Waivers:</strong><br>{{= hospital.inclusions.waivers }}</p>
					{{ } }}
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
					{{ if (meerkat.modules.healthBenefitsStep.getLimitedCover() === 'Y' && custom.reform.tab2.limited  !== null) { }}
						<div class="checkbox"><input type="checkbox" name="health_simples_dialogue-radio-810-1" id="limited_cover_scripting_tab_2" class="checkbox-custom simples-more-info-scripting-checkbox checkbox" value="READNOW" data-msg-required="" required="required">
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

		{{ if (['c', 'e'].includes(meerkat.modules.healthBenefitsStep.getCoverType())) { }}
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
				{{ if(!benefit) { }}
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
				<div class="row benefitRow">
					<div class="col-xs-7 newBenefitRow benefitRowTitle">
						{{ var expanded = false; }}
						{{ _.each(meerkat.modules.healthBenefitsStep.getSelectedBenefits(), function(benefitKey) { }}
							{{ if (benefitKey === key) { }}
							{{ expanded = true; }}
							<span class="selectedExtrasIcon"></span>
							{{ } }}
						{{ }); }}
						<div class="benefitRowTableCell">
							{{= benefitName || key.replace(/([A-Z])/g, ' $1').trim() }}
						<a class="extrasCollapseContentLink" data-toggle="collapse" href="#extrasCollapsedContent-{{= key }}" aria-expanded="{{= expanded}}" aria-controls="collapseExample">
							<span class="{{= expanded ? 'icon-angle-up' : 'icon-angle-down' }}"></span><span>{{= expanded ? '&nbsp;Less details' : '&nbsp;More details' }}</span>
						</a>
						</div>
					</div>
					<div class="col-xs-2 newBenefitRow benefitRowTitle align-center">
						{{ var coverType = window.meerkat.modules.healthAboutYou.getSituation(); }}
							{{ if((coverType === 'C' || coverType === 'SPF' || coverType === 'F') && benefit.benefitLimits.perPerson && (benefit.benefitLimits.perPerson !== '-')) { }}
								<div>per person: {{= benefit.benefitLimits.perPerson ? benefit.benefitLimits.perPerson : '' }}</div>
							{{ } }}
							{{ if(benefit.benefitLimits.perPolicy !== '-') { }}
							<div>per policy: {{= benefit.benefitLimits.perPolicy ? benefit.benefitLimits.perPolicy : '' }}</div>
							{{ } }}
					</div>
					<div class="col-xs-1 newBenefitRow benefitRowTitle">
						<span class="newBenefitStatus benefitStatusIcon_{{= benefit.covered}}"></span>
					</div>
					<div class="col-xs-2 newBenefitRow benefitRowTitle align-center">
						{{= benefit.waitingPeriod.substring(0, 20) }}
					</div>
				</div>
				<div class="row collapse benefitCollapsedContent {{= expanded ? 'in' : '' }}" id="extrasCollapsedContent-{{= key }}" aria-expanded="{{= expanded}}">
					<div class="col-xs-8">
						<div class="row">
							<div class="col-xs-6">
								<div class="row extraBenefitSection">
									<div class="col-xs-12 extraBenefitSubHeading"><strong>Claim Benefit:</strong></div>
									<div class="col-xs-12">
										{{ if (benefit.benefits !== undefined) { }}
											{{ var dentalBenefitsTotalCost = 0; }}
											{{ _.each(benefit.benefits, function (option, key) { }}
												{{ var situation = window.meerkat.modules.health.getSituation(); }}
												{{ var isSingle = situation[0] === 'S' || situation === 'ESF'; }}
												{{ var trimmedKey = key.replace(/[0-9]/g, '').replace(/([A-Z])/g, ' $1').trim(); }}
												{{ if(isSingle && trimmedKey === 'per person') { }}
													{{ return; }}
												{{ } }}
											<div class="row">
												<div class="col-xs-9 extraBenefitOption">
													{{ if(featureIteratorChild) { }}
														{{ var benefitLimitsName = ''; }}
														{{ _.each(featureIteratorChild.children, function (child) { }}
															{{ if(child.resultPath.indexOf(key) > -1) { }}
																{{ benefitLimitsName = child.safeName; }}
															{{ } }}
														{{ }); }}
														{{= benefitLimitsName }}
													{{ } }}
												</div>
												<div class="col-xs-3 extraBenefitOption align-center">
													{{ if(!option) { }}
														None
													{{ } else { }}
														{{= option }}
													{{ } }}
												</div>
											</div>
											{{ }); }}
											{{ if(benefitName === 'General Dental') { }}
												{{ if(benefit.benefits.DentalGeneral012PeriodicExam.indexOf('$') !== -1) { }}
													{{ if(benefit.benefits.DentalGeneral012PeriodicExam) { }}
														{{ dentalBenefitsTotalCost += parseFloat(benefit.benefits.DentalGeneral012PeriodicExam.replace('$', '')); }}
													{{ } }}
													{{ if(benefit.benefits.DentalGeneral114ScaleClean) { }}
														{{ dentalBenefitsTotalCost += parseFloat(benefit.benefits.DentalGeneral114ScaleClean.replace('$', '')); }}
													{{ } }}
													{{ if(benefit.benefits.DentalGeneral121Fluoride) { }}
														{{ dentalBenefitsTotalCost += parseFloat(benefit.benefits.DentalGeneral121Fluoride.replace('$', '')); }}
													{{ } }}
													{{ dentalBenefitsTotalCost = '$' + String(dentalBenefitsTotalCost); }}
												{{ } }}
												{{ if(benefit.benefits.DentalGeneral012PeriodicExam.indexOf('%') !== -1) { }}
													{{ dentalBenefitsTotalCost = benefit.benefits.DentalGeneral012PeriodicExam; }}
												{{ } }}
												<div class="row">
													<div class="col-xs-9 extraBenefitOption">
														So for your periodic check-up, scale and clean, and fluoride treatment, you'll receive:
													</div>
													<div class="col-xs-3 extraBenefitOption align-center">
														{{= dentalBenefitsTotalCost }}
													</div>
												</div>
											{{ } }}
										{{ } }}
										{{ _.each(benefit, function (option, key) { }}
											{{ if (key === 'benefitPayableInitial' || key === 'benefitpayableSubsequent') { }}
												<div class="row">
													<div class="col-xs-9 extraBenefitOption">
														{{ if(featureIteratorChild) { }}
															{{ var benefitLimitsName = ''; }}
															{{ _.each(featureIteratorChild.children, function (child) { }}
																{{ if(child.resultPath.indexOf(key) > -1) { }}
																	{{ benefitLimitsName = child.safeName; }}
																{{ } }}
															{{ }); }}
															{{= benefitLimitsName }}
														{{ } }}
													</div>
													<div class="col-xs-3 extraBenefitOption align-center">
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
							<div class="col-xs-6">
								<div class="row">
									<div class="col-xs-12 extraBenefitSubHeading"><strong>Annual Limits:</strong></div>
									{{ if (benefit.benefitLimits !== undefined) { }}
									<div class="col-xs-12">
										{{ _.each(benefit.benefitLimits, function (option, key) { }}
											{{ var situation = window.meerkat.modules.health.getSituation(); }}
											{{ var isSingle = situation[0] === 'S' || situation === 'ESF'; }}
											{{ var trimmedKey = key.replace(/([A-Z])/g, ' $1').trim().toLowerCase(); }}
											{{ if(isSingle && trimmedKey === 'per person') { }}
												{{ return; }}
											{{ } }}
										{{ if(key !== 'annualLimit') { }}
											<div class="row">
												<div class="col-xs-9 extraBenefitOption">
													{{ var benefitLimitsName = key.replace(/([A-Z])/g, ' $1').trim(); }}
													{{ if(featureIteratorChild) { }}
														{{ _.each(featureIteratorChild.children, function (child) { }}
															{{ if(child.resultPath.indexOf(key) > -1) { }}
																{{ benefitLimitsName = child.safeName; }}
															{{ } }}
														{{ }); }}
														{{= benefitLimitsName }}
													{{ } else { }}
														{{= benefitLimitsName }}
													{{ } }}
												</div>
												<div class="col-xs-3 extraBenefitOption align-center">
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
										{{ if(key !== 'annualLimit') { }}
										<div class="row">
											<div class="col-xs-9 extraBenefitOption">
												{{ var benefitGroupLimitName = key.replace(/([A-Z])/g, ' $1').trim(); }}
												{{ if(featureIteratorChild) { }}
													{{ _.each(featureIteratorChild.children, function (child) { }}
														{{ if(child.resultPath.indexOf(key) > -1) { }}
															{{ benefitGroupLimitName = child.safeName; }}
														{{ } }}
													{{ }); }}
													{{= benefitGroupLimitName  }}
												{{ } else { }}
													{{= benefitGroupLimitName }}
												{{ } }}
											</div>
											<div class="col-xs-3 extraBenefitOption align-center">
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
					<div class="col-xs-4">&nbsp;</div>

					{{ if (benefit.hasSpecialFeatures) { }}
					<div class="col-xs-8">
						<div class="row">
							<div class="col-xs-12 extraBenefitSubHeading"><strong>Extra info:</strong></div>
							<div class="col-xs-12 extraBenefitOption">{{= benefit.hasSpecialFeatures }}</div>
						</div>
					</div>
					{{ } }}
				</div>
				{{ } }}
				{{ }); }}
			</div>
		</div>
		{{ } }}

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

		<div>
			<simples:dialogue id="99" vertical="health" />
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

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
		</div>

		{{ if (['A', 'B1', 'B2', 'C'].includes(custom.reform.scripting)) { }}
		<div class="simplesReformScriptingBox row">
			<div class="col-sm-1 no-padding">
				<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-765" id="more_info_scripting_box" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="more_info_scripting_box"></label></div>
			</div>
			<div class="col-sm-11 no-padding">
				{{ if (['A', 'B1'].includes(custom.reform.scripting)) { }}
				<p>So with the hospital cover, we have made sure everything you mentioned as important will be covered, like most policies there are some additional services covered as well as services that are excluded or restricted. We will send those across in a welcome pack, I can either read the exclusions and restrictions now or are you happy to just look through those in your own time?</p>
				{{ } }}

				{{ if (['B2'].includes(custom.reform.scripting)) { }}
				<p>So with the hospital cover, we have made sure everything mentioned as important will be covered, like most policies there are some services that are excluded or restricted, nothing you’ve mentioned as important, we will send those across in a welcome pack, I can either read them now or are you happy to just look through those in your own time?</p>
				{{ } }}

				{{ if (['C'].includes(custom.reform.scripting)) { }}
				<p>So with this hospital policy, everything mentioned as important is covered. This policy will have some changes on {date of change per rate sheet}  to services that you haven’t mentioned as important. We will send those changes across in a welcome pack and I can read these for you now, or keeping in mind that the important services will continue to be covered, are you happy to just look through those in your own time?</p>
				{{ } }}
			</div>

			<div class="scriptingOptions">
				<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-76" id="checkbox_welcome_pack" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="checkbox_welcome_pack">Read in the welcome pack</label></div>
				<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-76" id="checkbox_inclusion_details" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="checkbox_inclusion_details">Read me inclusion details</label></div>
			</div>
		</div>
		{{ } }}

		<div class="simplesMoreInfoReformTabs row">
			<button class="simplesMoreInfoTabLink simplesMoreInfoBeforeTab active" type="button">Health brochures before {{= custom.reform.changeDate }}</button>
			<button class="simplesMoreInfoTabLink simplesMoreInfoAfterTab" type="button">Health brochures after {{= custom.reform.changeDate }}</button>
		</div>
		<div class="fieldset-card row cover-card simplesMoreInfoHospitalCover simplesMoreInfoBeforeContent ${moreinfolayout_splittest_variant1 eq true ? 'moreinfolayout-splittest' : ''}">
			<c:if test="${moreinfolayout_splittest_default eq true}">

			<div class="simplesReformScriptingBox scriptingFlagContent row">
				{{ if (custom.reform.scripting === 'A') { }}
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits.length > 0) { }}
					<div class="readInclusionsFlag">
						<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="read_inclusions_scripting_A" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="read_inclusions_scripting_A">Pre script needs to be read</label></div><br/><br/>
						<span class="clinicalCatInfo">
							There are 38 clinical categories a policy can cover, out of those this policy does not pay benefits towards
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
									{{= benefit.name }},
								{{ } }}
							{{ }); }}
							and pays restricted benefits for
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'R') { }}
									{{= benefit.name }},
								{{ } }}
							{{ }); }}
							every other category is covered.</span><br/><br/>
						Based on our conversation these restrictions and exclusions are there to ensure you are not paying for things you don't need, should that change in the future you can add any of those additional services at any time, and you'll just need to serve the relevant waiting periods.
					</div>
					{{ } }}

					<div class="readWelcomeFlag">
						<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="read_welcome_scripting_A" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="read_welcome_scripting_A">Pre script needs to be read</label></div><br/><br/>
						Great, we'll send the full documents at the end of the call, but based on what you've told me, you are covered for all the things you said are most important.
					</div>
				{{ } }}

				{{ if (custom.reform.scripting === 'B1') { }}
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits.length > 0) { }}
					<div class="readInclusionsFlag">
						<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="read_inclusions_scripting_B1" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="read_inclusions_scripting_B1">Pre script needs to be read</label></div><br/><br/>
						<span class="clinicalCatInfo">
							This policy excludes
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
									{{= benefit.name }},
								{{ } }}
							{{ }); }}
							and there is restricted cover for
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'R') { }}
									{{= benefit.name }},
								{{ } }}
							{{ }); }}
							every other category is covered.
						</span><br/><br/>
						Based on our conversation these restrictions and exclusions are there to ensure you are not paying for things you don't need, should that change in the future you can add any of those additional services at any time, and you'll just need to serve the relevant waiting periods. <br/><br/>

						<b>What’s the product changing to? (within CTM benefits)</b>
						<span class="clinicalCatInfo">
							I can’t tell you exactly what the changes are, but I can tell you everything you’ve mentioned as important will continue to be covered, the only changes may be to services that you haven’t mentioned as important, and the health fund is required to tell you well in advance of any changes.
						</span><br/><br/>

						<b>What’s the product changing to? (outside of CTM benefits)</b>
						<span class="clinicalCatInfo">
							The fund hasn’t released the changes on this policy just yet, the health funds are required to tell you well in advance of any changes, but until then, you have the peace of mind to know everything you’ve mentioned as important to you is covered.
						</span>
					</div>
					{{ } }}

					<div class="readWelcomeFlag">
						<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="read_welcome_scripting_B1" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="read_welcome_scripting_B1">Pre script needs to be read</label></div><br/><br/>
						Great, we'll send the full documents at the end of the call, but based on what you've told me, you are covered for all the things you said are most important.<br/><br/>

						<b>What’s the product changing to? (within CTM benefits)</b>
						<span class="clinicalCatInfo">
							I can’t tell you exactly what the changes are, but I can tell you everything you’ve mentioned as important will continue to be covered, the only changes may be to services that you haven’t mentioned as important, and the health fund is required to tell you well in advance of any changes.
						</span><br/><br/>

						<b>What’s the product changing to? (outside of CTM benefits)</b>
						<span class="clinicalCatInfo">
							The fund hasn’t released the changes on this policy just yet, the health funds are required to tell you well in advance of any changes, but until then, you have the peace of mind to know everything you’ve mentioned as important to you is covered.
						</span>
					</div>
				{{ } }}

				{{ if (custom.reform.scripting === 'B2') { }}
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits.length > 0) { }}
					<div class="readInclusionsFlag">
						<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="read_inclusions_scripting_B2" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="read_inclusions_scripting_B2">Pre script needs to be read</label></div><br/><br/>
						<span class="clinicalCatInfo">
							This policy excludes
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
									{{= benefit.name }},
								{{ } }}
							{{ }); }}
							and there is restricted cover for
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'R') { }}
									{{= benefit.name }},
								{{ } }}
							{{ }); }}
							every other category is covered.
						</span><br/><br/>
						Based on our conversation these restrictions and exclusions are there to ensure you are not paying for things you don't need, should that change in the future you can add any of those additional services at any time, and you'll just need to serve the relevant waiting periods. <br/><br/>

						<b>What’s the product changing to?</b>
						<span class="clinicalCatInfo">
							The fund hasn’t released the changes on this policy just yet, the health funds are required to tell you well in advance of any changes, but until then, you have the peace of mind to know everything you’ve mentioned as important to you is covered.
						</span>
					</div>
					{{ } }}

					<div class="readWelcomeFlag">
						<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="read_welcome_scripting_B2" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="read_welcome_scripting_B2">Pre script needs to be read</label></div><br/><br/>
						Great, we'll send the full documents at the end of the call, but based on what you've told me, you are covered for all the things you said are most important.<br/><br/>

						<b>What’s the product changing to?</b>
						<span class="clinicalCatInfo">
							The fund hasn’t released the changes on this policy just yet, the health funds are required to tell you well in advance of any changes, but until then, you have the peace of mind to know everything you’ve mentioned as important to you is covered.
						</span>
					</div>
				{{ } }}

				{{ if (custom.reform.scripting === 'C') { }}
					{{ if (custom.reform.tab1 && custom.reform.tab1.benefits.length > 0) { }}
					<div class="readInclusionsFlag">
						<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="before_read_inclusions_scripting_C" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="before_read_inclusions_scripting_C">Pre script needs to be read</label></div><br/><br/>
						<span class="clinicalCatInfo">
							So prior to the changes on {{= custom.reform.changeDate }} this policy excludes
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
									{{= benefit.name }},
								{{ } }}
							{{ }); }}
							and there is restricted cover for
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'R') { }}
									{{= benefit.name }},
								{{ } }}
							{{ }); }}
						</span><br/><br/>
						Based on our conversation these restrictions and exclusions are there to ensure you are not paying for things you don't need, should that change in the future you can add any of those additional services at any time, and you'll just need to serve the relevant waiting periods. <br/><br/>

						<b>What’s the product changing to?</b>
						<span class="clinicalCatInfo">
							The fund hasn’t released the changes on this policy just yet, the health funds are required to tell you well in advance of any changes, but until then, you have the peace of mind to know everything you’ve mentioned as important to you is covered.
						</span>
					</div>
					{{ } }}

					<div class="readWelcomeFlag">
						<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="before_read_welcome_scripting_C" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="before_read_welcome_scripting_C">Pre script needs to be read</label></div><br/><br/>
						Great, we'll send the full documents at the end of the call, but based on what you've told me, you are covered for all the things you said are most important.
					</div>
				{{ } }}
			</div>

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
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'R') { }}
									<li class="simplesMoreInfoInclusions"><span>{{= benefit.name }}</span></li>
								{{ } }}
							{{ }); }}
						</ul>

						<h5>Exclusions</h5>
						<ul>
							{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
								{{ if (benefit.covered === 'N') { }}
									<li class="simplesMoreInfoInclusions"><span>{{= benefit.name }}</span></li>
								{{ } }}
							{{ }); }}
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
				<div class="simplesReformScriptingBox scriptingFlagContent row">

					{{ if (custom.reform.scripting === 'C') { }}
						{{ if (custom.reform.tab2 && custom.reform.tab2.benefits.length > 0) { }}
						<div class="readInclusionsFlag">
							<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="after_read_inclusions_scripting_C" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="after_read_inclusions_scripting_C">Pre script needs to be read</label></div><br/><br/>
							<span class="clinicalCatInfo">
								But the changes on {{= custom.reform.changeDate }} mean your hospital policy will then exclude
								{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
									{{ if (benefit.covered === 'N') { }}
										{{= benefit.name }},
									{{ } }}
								{{ }); }}
								and have restricted cover for
								{{ _.each(custom.reform.tab1.benefits, function(benefit){ }}
									{{ if (benefit.covered === 'R') { }}
										{{= benefit.name }},
									{{ } }}
								{{ }); }}
								every other category is covered. Does that make sense?
							</span>
						</div>
						{{ } }}

						<div class="readWelcomeFlag">
							<div class="checkbox"><input type="radio" name="health_simples_dialogue-radio-760" id="after_read_welcome_scripting_C" class="checkbox-custom checkbox" value="READNOW" data-msg-required="" required="required"><label for="after_read_welcome_scripting_C">Pre script needs to be read</label></div><br/><br/>
							Great, we'll send the full documents at the end of the call, but based on what you've told me, you are covered for all the things you said are most important.
						</div>
					{{ } }}

				</div>
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
					{{ if (custom.reform.tab2 && custom.reform.tab2.benefits.length > 0) { }}
					<h5>Inclusions</h5>
					<ul>
						{{ _.each(custom.reform.tab2.benefits, function(benefit){ }}
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

		<div class="hidden-xs hiddenInMoreDetails">
			{{= callToActionBarHtml }}
		</div>

	</div>

</script>
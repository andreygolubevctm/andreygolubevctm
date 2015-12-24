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

<%-- MORE INFO TEMPLATE --%>

<script id="more-info-template" type="text/html">

	<%-- Prepare the price and dual price templates --%>
	{{ var logoPriceTemplate = $("#logo-price-template").html(); }}
	{{ var htmlTemplatePrice = _.template(logoPriceTemplate); }}
	{{ obj._selectedFrequency = Results.getFrequency(); }}
	{{ obj.mode = ''; }}
	{{ obj.displayLogo = false; }} <%-- Turns off the logo from the template --%>
	{{ obj.showAltPremium = false; obj.renderedPriceTemplate = htmlTemplatePrice(obj); }}
	{{ obj.showAltPremium = true;  obj.renderedAltPriceTemplate = htmlTemplatePrice(obj); }}

	<%-- Prepare the call to action bar template --%>
	{{ var template = $("#more-info-call-to-action-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var callToActionBarHtml = htmlTemplate(obj); }}

	<div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content col-xs-12">

		<div class="modal-closebar">
			<a href="javascript:;" class="btn btn-close-dialog btn-close-more-info"><span class="icon icon-cross"></span></a>
		</div>

		<div class="fieldset-card row price-card">

			<div class="col-xs-12 hidden-xs">
				<p>Quote reference number <span class="text-secondary">{{= transactionId }}</span></p>
			</div>
			<div class="col-md-8">

				<div class="row">
					<div class="col-xs-3">
						<div class="companyLogo {{= info.provider }}-mi"></div>
					</div>
					<div class="col-xs-9">
						<h1 class="noTopMargin productName">{{= info.productTitle }}</h1>

						<div class="hidden-xs">
							{{ if (promo.promoText !== ''){ }}
							<h2>Buy now and save with these promotions</h2>
							<p>{{= promo.promoText }}</p>
							{{ } }}
						</div>
					</div>
				</div>

				<div class="row priceRow">
					<div class="col-xs-12 col-sm-6">
						{{= renderedPriceTemplate }}
					</div>
					<div class="col-sm-6 col-md-12">
						<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}">Get Insured Now<span class="icon-arrow-right" /></a>
					</div>
				</div>

				<div class="row visible-xs">
					<div class="col-xs-12">
						{{ if (promo.promoText !== ''){ }}
						<h2>Buy now and save with these promotions</h2>
						<p>{{= promo.promoText }}</p>
						{{ } }}
					</div>
				</div>

			</div>

			<div class="col-md-4 hidden-xs hidden-sm">
				<h2 class="noTopMargin">You're nearly insured</h2>
				<div class="moreInfoProgress row">
					<div class="col-sm-2">
						<div class="moreInfoProgressBarLeft"></div>
						<div class="moreInfoProgressDone">75%</div>
					</div>
					<div class="col-sm-10">
						<p class="text-bold">Buy through comparethemarket</p>
						<p>Your chosen product</p>
						<p>Your cover preferences</p>
						<p>About you</p>
					</div>
				</div>

				<h3 class="text-dark">Need help?</h3>
				<p>Speak to one of our health insurance specialist on <span class="noWrap text-secondary">${callCentreNumber}</span></p>
				<p>Quote your reference number <span class="text-secondary">{{= transactionId }}</span></p>
			</div>

		</div>

		<div class="fieldset-card row cover-card">
			<div class="col-xs-12 col-md-6">
				{{ if(typeof hospital.inclusions !== 'undefined') { }}
				<h1 class="text-dark">Hospital cover</h1>
				<p><strong>Hospital Excess:</strong> {{= hospital.inclusions.excess }}</p>
				<p><strong>Excess Waivers:</strong> {{= hospital.inclusions.waivers }}</p>
				<p><strong>Co-payment / % Hospital Contribution:</strong> {{= hospital.inclusions.copayment }}</p>
				{{ } }}

				{{ if(hospitalCover.inclusions.length > 0) { }}
				<h5>You will be covered for the following services</h5>

				<ul class="indent benefitsIcons inclusions">
					{{ _.each(hospitalCover.inclusions, function(inclusion){ }}
					<li class="{{= inclusion.className }}">{{= inclusion.name }}</li>
					{{ }) }}
				</ul>
				{{ } }}

				{{ if(hospitalCover.restrictions.length > 0) { }}
				<h5>You will have restricted cover for the following services</h5>
				<ul class="indent benefitsIcons restrictions">
					{{ _.each(hospitalCover.restrictions, function(restriction){ }}
					<li class="{{= restriction.className }}">{{= restriction.name }}</li>
					{{ }) }}
				</ul>
				<span class="text-italic small">Limits may apply. See policy brochure for more details.</span>
				{{ } }}

				{{ if(hospitalCover.exclusions.length > 0) { }}
				<h5>You will not be covered for the following services</h5>
				<ul class="indent benefitsIcons exclusions">
					{{ _.each(hospitalCover.exclusions, function(exclusion){ }}
					<li class="{{= exclusion.className }}">{{= exclusion.name }}</li>
					{{ }) }}

					<c:if test="${not empty callCentre}">
						{{ if (typeof custom !== 'undefined' && custom.info && custom.info.exclusions && custom.info.exclusions.cover) { }}
						<li class="text-danger"><span class="icon-cross" /></span>{{= custom.info.exclusions.cover }}</li>
						{{ } }}
					</c:if>
				</ul>
				{{ } }}

			</div>

			<div class="visible-sm col-sm-12">
				{{= callToActionBarHtml }}
			</div>

			{{ if(typeof extrasCover !== 'undefined') { }}
			<div class="col-xs-12 col-md-6">
				<h1 class="text-dark extrasCoverTitle">Extras cover</h1>
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
			</div>
			{{ } }}
		</div>

		{{= callToActionBarHtml }}

		<div class="policyBrochures row">
			<div class="col-xs-12">
				<h2 class="policyBrochuresTitle">Policy brochures</h2>
				<p>See your policy brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }} below for the full guide on policy limits, inclusions and exclusions</p>
			</div>

			<div class="col-xs-12 col-md-6">

				<div class="row">
					{{ if(typeof hospitalCover !== 'undefined' && typeof extrasCover !== 'undefined' && promo.hospitalPDF == promo.extrasPDF) { }}
					<div class="col-sm-6 col-xs-12">
						<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-policy-brochure col-xs-12">Download <br class="hidden-xs hidden-lg"/>Policy Brochure</a>
					</div>
					{{ } else { }}

					{{ if(typeof hospitalCover !== 'undefined') { }}
					<div class="col-sm-6 col-xs-12">
						<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-hospital-brochure col-xs-12">Download Hospital <br class="hidden-xs hidden-sm hidden-lg"/>Policy Brochure</a>
					</div>
					{{ } }}

					{{ if(typeof extrasCover !== 'undefined') { }}
					<div class="col-sm-6 col-xs-12 ">
						<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="btn download-extras-brochure col-xs-12">Download Extras <br class="hidden-xs hidden-sm hidden-lg"/>Policy Brochure</a>
					</div>
					{{ } }}
					{{ } }}
				</div>

			</div>
			<div class="col-xs-12 col-md-6 moreInfoEmailBrochures" novalidate="novalidate">

				<div class="row formInput">
					<div class="col-sm-7 col-xs-12">
						<field_new:email xpath="emailAddress"  required="true"
										 className="sendBrochureEmailAddress"
										 placeHolder="${emailPlaceHolder}" />
					</div>
					<div class="col-sm-5 hidden-xs">
						<a href="javascript:;" class="btn btn-save disabled btn-email-brochure">Email Brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }}</a>
					</div>
				</div>
				<div class="row row-content formInput optInMarketingRow">
					<div class="col-xs-12">
						<field_new:checkbox className="optInMarketing checkbox-custom"
											xpath="health/sendBrochures/optInMarketing" required="false"
											value="Y" label="true"
											title="Stay up to date with news and offers direct to your inbox" />
					</div>
				</div>

				<div class="row row-content formInput hidden-sm hidden-md hidden-lg emailBrochureButtonRow">
					<div class="col-xs-12">
						<a href="javascript:;" class="btn btn-save disabled btn-email-brochure">Email Brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s" : "" }}</a>
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


		<div class="fieldset-card row switching-card">
			<div class="col-md-8">
				<h1 class="text-dark">Switching is simple</h1>
				<ol>
					<li>You can change your fund whenever you like</li>
					<li>We'll pass your current fund details to your new fund, to transfer
						any hospital waiting periods that have already been served</li>
					<li>Most funds will give you immediate cover for the same extras benefits
						you were able to claim previously . Your old fund will reimburse any
						premiums paid in advance.</li>
				</ol>
			</div>
			<div class="col-md-4 hidden-xs hidden-sm pricePromise">
				<div class="row">
					<div class="col-md-5">
						<div class="pricePromiseLogo"></div>
					</div>
					<div class="col-md-7"><h4>You won't pay extra when you buy through comparethemarket</h4></div>
				</div>
				<p>Buy health insurance through us and if you find a better price on the same policy with the same health fund within 30 days, we'll give you $50*</p>
			</div>
			<div class="col-xs-12 testimonials">
				<h2>Join the thousands of Australians who already have compared and saved</h2>
				<blockquote>
					<span class="openQuote">“</span>{{= testimonial.quote }}<span class="closeQuote">”</span>
				</blockquote>
				<p class="testimonialAuthor">{{= testimonial.author }}</p>
			</div>
		</div>

		<div class="hidden-xs">
			{{= callToActionBarHtml }}
		</div>

	</div>

</script>

<script id="more-info-call-to-action-template" type="text/html">

	<div class="moreInfoCallToActionBar row">
		<div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
			<p>Found the right product for you?</p>
		</div>
		<div class="col-xs-12 col-sm-4 col-md-5 col-lg-6">
			<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}">Get Insured Now<span class="icon-arrow-right" /></a>
		</div>
	</div>

</script>

<script id="more-info-template-old" type="text/html">

	<div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content">

		<div class="col-sm-6 paragraphedContent">

			<div class="moreInfoMainDetails">

				<div class="productSummary horizontal visible-xs clearfix">

					{{ var logoPriceTemplate = $("#logo-price-template").html(); }}
					{{ var htmlTemplatePrice = _.template(logoPriceTemplate); }}
					{{ obj._selectedFrequency = Results.getFrequency(); }}
					{{ obj.mode = ''; }}
					{{ obj.showAltPremium = false; obj.htmlString = htmlTemplatePrice(obj); }}
					{{ obj.showAltPremium = true;  obj.htmlStringAlt = htmlTemplatePrice(obj); }}
					{{= htmlString }}

				</div>

				<div class="modal-closebar">
					<a href="javascript:;" class="btn btn-close-dialog btn-close-more-info"><span class="icon icon-cross"></span></a>
				</div>

				<h1 class="productName">{{= info.productTitle }}</h1>

				<div class="visible-xs">
					{{ if (showApply === true) { }}<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply old-cta" data-productId="{{= productId }}">Apply Online</a>{{ } }}
					<c:if test="${not empty callCentreNumber}">
					<a href="tel:${callCentreNumber}" class="needsclick btn btn-form btn-block phone callCentreNumberSection" data-productId="{{= productId }}">
						<h5 class="moreInfoCallUs">Call us now on <span class="noWrap callCentreNumber">${callCentreNumber}</span></h5>
						<span class="moreInfoReferenceNoText">Quote your reference number <span class="moreInfoReferenceNo">{{= transactionId }}</span></span>
					</a>
					</c:if>
				</div>
			</div>
			{{ if (promo.promoText !== ''){ }}
				<h2 class="more-info-promotion">Promotions &amp; Offers</h2>
				{{= promo.promoText }}
			{{ } }}

			<h2 class="more-info-about">About the fund</h2>
			<div class="about-the-fund">{{= aboutFund }}</div>

			<h2 class="more-info-nextsteps">Once you press the submit button...</h2>
			<div class="next-info">{{= whatHappensNext }}</div>

		</div>

		<div class="col-sm-6 moreInfoRightColumn">

		<%-- DUAL PRICING START --%>
		<c:if test="${healthAlternatePricingActive eq true}">
			{{ if (showApply === true) { }}
				<div class="dualPricing">
					<ui:bubble variant="chatty" className="moreInfoBubble">
						<div class="row">
							<div class="col-xs-5 productSummary vertical">
								<h5>Current</h5>
								{{= htmlString }}
							</div>
							<div class="col-xs-2 col-sm-1 arrow-column">
								<span class="icon icon-arrow-thick-right"></span>
							</div>
							<div class="col-xs-5 col-sm-6 productSummary vertical altPremium">
								<h5>1 <c:out value="${healthAlternatePricingMonth}" /> 2015</h5>
								{{= htmlStringAlt }}
							</div>
						</div>
					</ui:bubble>
					<ui:bubble variant="chatty" className="moreInfoBubble contactBlock">
						<div class="row">
							<div class="col-xs-5">
								<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply old-cta" data-productId="{{= productId }}">Apply Now<span class="icon-arrow-right" /></a>
				</div>
							<c:if test="${not empty callCentreNumber}">
								<div class="col-xs-6 callCentreNumberSection">
									<h5 class="moreInfoCallUs">Or call <span class="noWrap callCentreNumber">${callCentreNumber}</span></h5>
									<span class="moreInfoReferenceNoText">Quote your reference number <span class="moreInfoReferenceNo">{{= transactionId }}</span></span>
								</div>
							</c:if>
						</div>
					</ui:bubble>
					<div class="payAdvance">
						<h2>Buy now and beat the 1 April rate rise</h2>
						<p>Did you know, if you buy now and <strong>pay up to 12 months in advance</strong> before the rate rise applies, you can <strong>lock in the current price.</strong></p>
					</div>
				</div>
			{{ } }}
		</c:if>
		<%-- DUAL PRICING END --%>
		<c:if test="${healthAlternatePricingActive eq false}">
			{{ if (showApply === true) { }}

			<c:choose>
				<c:when test="${useOldCtaBtn}">
					<ui:bubble variant="info" className="moreInfoBubble hidden-xs">
						<div class="row">
							<c:if test="${not empty callCentreNumber}">
							<div class="col-xs-6 callCentreNumberSection">
								<h5 class="moreInfoCallUs">Call us now on <span class="noWrap callCentreNumber">${callCentreNumber}</span></h5>
								<span class="moreInfoReferenceNoText">Quote your reference number <span class="moreInfoReferenceNo">{{= transactionId }}</span></span>
							</div>
							</c:if>

							<c:if test="${not empty callCentreNumber}">
							<div class="col-xs-1 moreInfoOr">
								OR
							</div>
							</c:if>

							<div class="col-xs-5">
								<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply old-cta" data-productId="{{= productId }}">Apply Now<span class="icon-arrow-right" /></a>
							</div>
						</div>
					</ui:bubble>
				</c:when>
				<c:otherwise>
				<div class="row moreInfoCallUsContainer hidden-xs">
					<c:if test="${not empty callCentreNumber}">
						<div class="col-xs-6 callCentreNumberSection">
						<h5 class="moreInfoCallUs">Call us now on <span class="noWrap callCentreNumber">${callCentreNumber}</span></h5>
						<span class="moreInfoReferenceNoText">Quote your reference number <span class="moreInfoReferenceNo">{{= transactionId }}</span></span>
					</div>
					</c:if>
					<div class="col-xs-5">
						<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply" data-productId="{{= productId }}">Apply Now<span class="icon-arrow-right" /></a>
					</div>
				</div>
				</c:otherwise>
			</c:choose>
			{{ } }}
		</c:if>

			<c:set var="pricePromiseEnabled">
				<content:get key="healthPricePromiseEnabled" />
			</c:set>

			<c:if test="${pricePromiseEnabled eq 'Y'}">
				<div class="row pricepromise paragraphedContent">
					<div class="col-xs-4 col-sm-4 col-lg-5 pricePromiseLogo"></div>
					<div class="col-xs-8 col-sm-8 col-lg-7">
						<h2 class="more-info-promotion">Our Price Promise To You</h2>
						<p>
							Buy health insurance through us and if you find a better price on the same policy within 30 days, <strong>we'll give you $50*</strong>
							<br><small><a href="http://www.comparethemarket.com.au/health-insurance/price-promise/" target="_blank">*terms and conditions</a></small>
						</p>
					</div>
				</div>
			</c:if>

			<health:competition_jeep />

			<div class="row row-content brochureButtons">
				{{ if(typeof hospitalCover !== 'undefined' && typeof extrasCover !== 'undefined' && promo.hospitalPDF == promo.extrasPDF) { }}
					<div class="col-sm-6 col-xs-12">
						<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn btn-download download-policy-brochure col-xs-12">Download <br class="hidden-xs hidden-lg"/> Policy Brochure</a>
					</div>
				{{ } else { }}

					{{ if(typeof hospitalCover !== 'undefined') { }}
						<div class="col-sm-6 col-xs-12">
							<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn btn-download download-hospital-brochure col-xs-12">Download Hospital <br class="hidden-xs hidden-lg"/> Policy Brochure</a>
						</div>
					{{ } }}

					{{ if(typeof extrasCover !== 'undefined') { }}
						<div class="col-sm-6 col-xs-12 ">
							<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="btn btn-download download-extras-brochure col-xs-12">Download Extras <br class="hidden-xs hidden-lg"/>Policy Brochure</a>
						</div>
					{{ } }}
				{{ } }}
			</div>

			<div class="row moreInfoEmailBrochures" novalidate="novalidate">
				<div class="col-xs-12">
					<div class="row row-content formInput">
						<div class="col-sm-7 col-xs-12">
							<field_new:email xpath="emailAddress"  required="true"
									className="sendBrochureEmailAddress"
									placeHolder="${emailPlaceHolder}" />
						</div>
						<div class="col-sm-5 hidden-xs">
							<a href="javascript:;" class="btn btn-save btn-block disabled btn-email-brochure">Email Brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s" : "" }}</a>
						</div>
					</div>
					<div class="row row-content formInput optInMarketingRow">
						<div class="col-xs-12">
							<field_new:checkbox className="optInMarketing checkbox-custom"
											xpath="health/sendBrochures/optInMarketing" required="false"
											value="Y" label="true"
											title="Stay up to date with news and offers direct to your inbox" />
						</div>
					</div>

					<div class="row row-content formInput hidden-sm hidden-md hidden-lg emailBrochureButtonRow">
						<div class="col-xs-12">
							<a href="javascript:;" class="btn btn-save btn-block disabled btn-email-brochure">Email Brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s" : "" }}</a>
						</div>
					</div>
					<div class="row row-content moreInfoEmailBrochuresSuccess">
						<div class="col-xs-12">
							<div class="success alert alert-success">
								Success! Your policy brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s have" : " has" }} been emailed to you.
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row">

			{{ if(typeof hospitalCover !== 'undefined') { }}
				<div class="col-xs-6">

					<h2 class="text-hospital-benefits">Hospital Benefits</h2>

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
					<h2 class="text-extras">Extras Benefits</h2>

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
			{{ }else{ }}
				<c:if test="${not empty callCentre}">
					{{ if (typeof custom !== 'undefined' && custom.info && custom.info.exclusions && custom.info.exclusions.cover) { }}
						<div class="row moreInfoExclusions">
							<div class="col-xs-12">
								<h5 class="text-hospital">Your Hospital Exclusions:</h5>
								<ul class="exclusions">
									<li class="text-danger"><span class="icon-cross" /></span>{{= custom.info.exclusions.cover }}</li>
								</ul>
							</div>
						</div>
					{{ } }}
				</c:if>
			{{ } }}





		</div>

	</div>

</script>
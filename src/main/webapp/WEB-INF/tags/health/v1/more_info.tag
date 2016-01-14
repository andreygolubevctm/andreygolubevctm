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

		<div class="fieldset-card row price-card">

			<div class="col-xs-12 hidden-xs">
				<p>Quote reference number <span class="text-secondary">{{= transactionId }}</span></p>
			</div>
			<div class="col-md-8 moreInfoTopLeftColumn">

				<div class="row">
					<div class="col-xs-3">
						<div class="companyLogo {{= info.provider }}-mi"></div>
					</div>
					<div class="col-xs-9">
						<h1 class="noTopMargin productName">{{= info.productTitle }}</h1>

						<div class="hidden-xs">
							{{ if (promo.promoText !== ''){ }}
							<h2>Buy now and benefit from these promotions</h2>
							<p>{{= promo.promoText }}</p>
							{{ } }}
						</div>
					</div>
				</div>

				<div class="row priceRow">
					<div class="col-xs-12 col-sm-6">
						{{= renderedPriceTemplate }}
					</div>
					<div class="col-xs-12 col-sm-6 col-md-12">
						<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}">Get Insured Now<span class="icon-arrow-right" /></a>
					</div>
				</div>

				<div class="row visible-xs">
					<div class="col-xs-12">
						{{ if (promo.promoText !== ''){ }}
						<h2>Buy now and benefit from these promotions</h2>
						<p>{{= promo.promoText }}</p>
						{{ } }}
					</div>
				</div>

			</div>

			<div class="col-md-4 hidden-xs hidden-sm moreInfoTopRightColumn">
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
				<p>Speak to one of our health insurance specialists on <span class="noWrap text-secondary">${callCentreNumber}</span></p>
				<p>Quote your reference number <span class="text-secondary">{{= transactionId }}</span></p>
			</div>

		</div>

		<div class="fieldset-card row cover-card">
			{{ if(typeof hospital !== 'undefined' && typeof hospitalCover !== 'undefined') { }}
			<div class="col-xs-12 col-md-6">
				{{ if(typeof hospital.inclusions !== 'undefined') { }}
				<h1 class="text-dark">Hospital cover</h1>
				<p><strong>Hospital Excess:</strong> {{= hospital.inclusions.excess }}</p>
				<p><strong>Excess Waivers:</strong> {{= hospital.inclusions.waivers }}</p>
				<p><strong>Co-payment / % Hospital Contribution:</strong> {{= hospital.inclusions.copayment }}</p>
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

					<c:if test="${not empty callCentre}">
						{{ if (typeof custom !== 'undefined' && custom.info && custom.info.exclusions && custom.info.exclusions.cover) { }}
						<li class="text-danger"><span class="icon-cross" /></span>{{= custom.info.exclusions.cover }}</li>
						{{ } }}
					</c:if>
				</ul>
				{{ } }}

			</div>

			<div class="hidden-xs hidden-md hidden-lg col-sm-12">
				{{= callToActionBarHtml }}
			</div>
			{{ } }}

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

		<div class="hiddenInMoreDetails">
			{{= callToActionBarHtml }}
		</div>

		<div class="policyBrochures row">
			<div class="col-xs-12">
				<h2>Policy brochures</h2>
				<p>See your policy brochure{{= typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }} below for the full guide on policy limits, inclusions and exclusions</p>
			</div>

			<div class="col-xs-12 col-md-6">

				<div class="row">
					{{ if(typeof hospitalCover !== 'undefined' && typeof extrasCover !== 'undefined' && promo.hospitalPDF == promo.extrasPDF) { }}
					<div class="col-xs-12">
						<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-policy-brochure col-xs-12">Policy Brochure</a>
					</div>
					{{ } else { }}

					{{ if(typeof hospitalCover !== 'undefined') { }}
					<div class="{{ if(typeof extrasCover !== 'undefined'){ }}col-sm-6{{ } }} col-xs-12">
						<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn download-hospital-brochure col-xs-12">Hospital Policy Brochure</a>
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


		<div class="fieldset-card row switching-card hiddenInMoreDetails">
			<div class="col-md-8">
				<h1 class="text-dark">Switching is simple</h1>
				<ol>
					<li>You can change your fund whenever you like</li>
					<li>We'll pass your current fund details to your new fund, to transfer
						any hospital waiting periods that have already been served</li>
					<li>Most funds will give you immediate cover for the same extras benefits
						you were able to claim previously. Your old fund will reimburse any
						premiums paid in advance.</li>
				</ol>
			</div>

			{{ if(meerkat.site.tracking.brandCode === 'ctm') { }}
			<div class="col-md-4 hidden-xs hidden-sm pricePromise">
				<div class="row">
					<div class="col-md-5">
						<div class="pricePromiseLogo"></div>
					</div>
					<div class="col-md-7"><h4>You won't pay extra when you buy through comparethemarket</h4></div>
				</div>
				<p>Buy health insurance through us and if you find a better price on the same policy with the same health fund within 30 days, we'll give you $50*</p>
			</div>
			{{ } }}
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
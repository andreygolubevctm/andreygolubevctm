<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="emailPlaceHolder">
	<content:get key="emailPlaceHolder"/>
</c:set>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.services.health.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />
<c:if test="${healthAlternatePricingActive eq true}">
	<c:set var="healthAlternatePricingMonth" value="${healthPriceDetailService.getAlternatePriceMonth(pageContext.getRequest())}" />
</c:if>

<%-- MORE INFO TEMPLATE --%>
<script id="more-info-template" type="text/html">

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

				<h1 class="productName">{{= info.productTitle }}</h1>

				<div class="visible-xs">
					{{ if (showApply === true) { }}<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply ${oldCtaClass}" data-productId="{{= productId }}">Apply Online</a>{{ } }}
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
			{{= aboutFund }}

			<h2 class="more-info-nextsteps">Once you press the submit button...</h2>
			{{= whatHappensNext }}

			<span class="hidden next-steps-all-funds-source">If you have a direct debit set up with your current fund we suggest that you cancel the request as soon as possible. You may be able do this through your fund&#39;s online member service area.</span>

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
								<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply ${oldCtaClass}" data-productId="{{= productId }}">Apply Now<span class="icon-arrow-right" /></a>
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
								<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply ${oldCtaClass}" data-productId="{{= productId }}">Apply Now<span class="icon-arrow-right" /></a>
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
						<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn btn-download col-xs-12">Download <br class="hidden-xs hidden-lg"/> Policy Brochure</a>
					</div>
				{{ } else { }}

					{{ if(typeof hospitalCover !== 'undefined') { }}
						<div class="col-sm-6 col-xs-12">
							<a href="{{= promo.hospitalPDF }}" target="_blank" class="btn btn-download col-xs-12">Download Hospital <br class="hidden-xs hidden-lg"/> Policy Brochure</a>
						</div>
					{{ } }}

					{{ if(typeof extrasCover !== 'undefined') { }}
						<div class="col-sm-6 col-xs-12 ">
							<a href="{{= promo.extrasPDF }}" target="_blank" class="btn btn-download col-xs-12">Download Extras <br class="hidden-xs hidden-lg"/>Policy Brochure</a>
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
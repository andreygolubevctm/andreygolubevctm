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
	{{ var productBenefitsTemplate = $("#more-info-product-benefits-template").html(); }}
	{{ var htmlTemplate = _.template(productBenefitsTemplate); }}
	{{ obj.benefitsTemplate = htmlTemplate(obj); }}

	{{ var productBenefitsTemplate = $("#more-info-product-benefits-template-xs").html(); }}
	{{ var htmlTemplate = _.template(productBenefitsTemplate); }}
	{{ obj.benefitsTemplateXS = htmlTemplate(obj); }}

	<div data-product-type="{{= info.ProductType }}" class="displayNone more-info-content">
		<div class="col-xs-12 more-info-blue-header">
			<div class="row">
				<div class="col-xs-12 col-md-9">
					<div class="row">
						<div class="visible-xs col-xs-12 xs-productName-container">
							<div class="row">
								<div class="col-xs-8">
									<div class="productName">{{= info.productTitle }}</div>
								</div>
								<div class=" col-xs-4">
									<div class="companyLogo {{= info.FundCode}}"></div>
								</div>
							</div>
						</div>
						<div class="col-sm-12 hidden-xs">
							<div class="productName">{{= info.productTitle }}</div>
						</div>
						<div class="col-sm-9 col-md-12">
							<div class="row">
								<div class="col-md-5 col-xs-12">{{ var logoPriceTemplate = $("#more-info-logo-price-template").html(); }}
									{{ var htmlTemplatePrice = _.template(logoPriceTemplate); }}
									{{ obj._selectedFrequency = Results.getFrequency(); }}
									{{ obj.mode = ''; }}
									{{ obj.showAltPremium = false; obj.htmlString = htmlTemplatePrice(obj); }}
									{{ obj.showAltPremium = true;  obj.htmlStringAlt = htmlTemplatePrice(obj); }}
									{{= htmlString }}</div>
								<div class="col-xs-12 col-md-7">
									<div class="row">
										<div class="col-lg-5 col-md-12 col-xs-12 col-sm-6 pull-left more-info-apply-container"><a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply" data-productId="{{= productId }}">Apply Now<span class="icon-arrow-right" /></a></div>
										<div class="col-lg-7 col-md-12 col-xs-12 moreInfoCallRefNo"><span class="moreInfoCallUs">or Call <span class="noWrap callCentreNumber">${callCentreNumber}</span></span>
											<p class="moreInfoReferenceNoText">quote your reference number <span class="moreInfoReferenceNo">{{= transactionId }}</span></p></div>
									</div>
								</div>
							</div>
						</div>
						<div class="visible-sm col-sm-3"><div class="companyLogo {{= info.FundCode}}"></div></div>
					</div>
				</div>
				<div class="hidden-xs hidden-sm col-md-3"><div class="companyLogo {{= info.FundCode}}"></div></div>
			</div>
		</div>

		<div class="col-sm-6 paragraphedContent">

			{{ if (promo.promoText !== ''){ }}
				<h2 class="more-info-promotion">Promotions &amp; Offers</h2>
				{{= promo.promoText }}
			{{ } }}

			<h2 class="more-info-about">About the fund</h2>
			<div class="about-the-fund">{{= aboutFund }}</div>

			<div class="visible-xs">
				{{ print(benefitsTemplateXS); }}
			</div>


			<h2 class="more-info-nextsteps">Once you press the submit button...</h2>
			<div class="next-info">{{= whatHappensNext }}</div>

			<c:set var="pricePromiseEnabled">
				<content:get key="healthPricePromiseEnabled" />
			</c:set>

			<c:if test="${pricePromiseEnabled eq 'Y'}">
				<div class="row pricepromise paragraphedContent hidden-xs">
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
			</c:choose>
			{{ } }}
		</c:if>

			<health:competition_jeep />

			<div class="row row-content brochureButtons hidden-xs">
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

			<div class="row moreInfoEmailBrochures hidden-xs" novalidate="novalidate">
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
			<div class="hidden-xs">
			{{ print(benefitsTemplate); }}
			</div>

		</div>

	</div>
	</div>
</script>
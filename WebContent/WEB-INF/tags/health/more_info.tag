<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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
					{{ if (showApply === true) { }}<a href="javascript:;" class="btn btn-primary btn-block btn-more-info-apply" data-productId="{{= productId }}">Apply Online</a>{{ } }}
					<a href="tel:+1800777712" class="needsclick btn btn-secondary btn-block phone" data-productId="{{= productId }}">
						<h5 class="moreInfoCallUs">Call us now on 1800 77 77 12</h5>
						<span class="moreInfoReferenceNoText">Quote your reference number <span class="moreInfoReferenceNo">{{= transactionId }}</span></span>
					</a>
				</div>
			</div>

			<h2 class="text-primary">Promotions &amp; Offers</h2>
			{{= promo.promoText }}

			<h2 class="text-hospital">About the fund</h2>
			{{= aboutFund }}

			<h2 class="text-extras">Once you press the submit button...</h2>
			{{= whatHappensNext }}

			<span class="hidden next-steps-all-funds-source">If you have a direct debit set up with your current fund we suggest that you cancel the request as soon as possible. You may be able do this through your fund&#39;s online member service area.</span>

		</div>

		<div class="col-sm-6 moreInfoRightColumn">

		<%-- DUAL PRICING START --%>
		<c:if test="${not empty healthDualpricing and healthDualpricing != '0'}">
			{{ if (showApply === true) { }}
				<div class="dualPricing">
					<h2><c:out value="${healthDualpricing}" /> Rate Rise</h2>

					<ui:bubble variant="chatty" className="moreInfoBubble">
						<div class="row">
							<div class="col-xs-5 productSummary vertical">
								<h5>Current Pricing</h5>
								{{= htmlString }}
							</div>
							<div class="col-xs-2 col-sm-1 arrow-column">
								<span class="icon icon-arrow-right"></span>
							</div>
							<div class="col-xs-5 col-sm-6 productSummary vertical altPremium">
								<h5>Pricing from <c:out value="${healthDualpricing}" /></h5>
								{{= htmlStringAlt }}
							</div>
						</div>
					</ui:bubble>
				</div>
			{{ } }}
		</c:if>
		<%-- DUAL PRICING END --%>

			<ui:bubble variant="info" className="moreInfoBubble hidden-xs">
				<div class="row">
					<div class="col-xs-6">
						<h5 class="moreInfoCallUs">Call us now on 1800 77 77 12</h5>
						<span class="moreInfoReferenceNoText">Quote your reference number <span class="moreInfoReferenceNo">{{= transactionId }}</span></span>
					</div>
					{{ if (showApply === true) { }}
						<div class="col-xs-1 moreInfoOr">
							OR
						</div>
						<div class="col-xs-5">
							<a href="javascript:;" class="btn btn-primary btn-block btn-more-info-apply" data-productId="{{= productId }}">Apply Now<span class="icon-arrow-right" /></a>
						</div>
					{{ } }}
				</div>
			</ui:bubble>

			<div class="row pricepromise paragraphedContent">
				<div class="col-xs-3">
					<img src="brand/ctm/graphics/health/price_promise.png" alt=""> <%-- #WHITELABEL CONTENT --%>
				</div>
				<div class="col-xs-9">
					<h2>Our Price Promise To You</h2>
					<p>
						Buy health insurance through us and if you find a better price on the same policy within 30 days, <strong>we'll give you $50*</strong>
						<br><small><a href="http://www.comparethemarket.com.au/health-insurance/price-promise/" target="_blank">*terms and conditions</a></small>
					</p>
				</div>
			</div>

			<div class="row">

			{{ if(typeof hospitalCover !== 'undefined') { }}
				<div class="col-xs-6">

					<h2 class="text-hospital">Hospital Benefits</h2>
					<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn btn-hospital-light">Hospital Policy Brochure</a>

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
					<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="btn btn-extras-light">Extras Policy Brochure</a>

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
						<h5>Your Hospital Exclusions:</h5>
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
			{{ } }}

		</div>

	</div>

</script>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dual pricing templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="thisYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>

<core_v1:js_template id="price-frequency-template">
	<content:get key="frequencyWarning"/>
</core_v1:js_template>

<%-- Working on the assumption there's going to be text changes so put this in the db --%>
<core_v1:js_template id="more-info-why-price-rise-template">
	<content:get key="moreInfoWhyPricesRising"/>
</core_v1:js_template>

<core_v1:js_template id="sideBarFrequency">
	{{ if (obj.frequency !== 'annually') { }}
	<h5 class="heading">If you pay {{= obj.frequency }} before {{= obj.dropDeadDateFormatted }}:</h5>
	<p><span class="title">First Premium:</span> {{= obj.firstPremium}}</p>
	<p><span class="title">Remaining Premiums:</span> {{= obj.remainingPremium}}</p>
	{{ } else { }}
	<h5 class="heading">If you pay your annual premium before {{= obj.dropDeadDateFormatted }}:</h5>
	<p><span class="title">Premium:</span> {{= obj.firstPremium}}</p>
	{{ } }}
</core_v1:js_template>

<c:set var="note">You must purchase before {{= obj.dropDeadDateFormatted }}.</c:set>
<c:set var="heading">Premiums are rising April 1</c:set>
<c:set var="whyPremiumsRising"><a href="javascript:;" class="why-rising-premiums">Why are premiums rising?</a></c:set>
<c:set var="april1Header">Pricing on 1 April ${thisYear}</c:set>

<core_v1:js_template id="dual-pricing-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			<h2>${heading}</h2>
			${whyPremiumsRising}
			<h3>Current Pricing</h3>
			{{= renderedPriceTemplate }}
			<div class="note hidden-xs">${note}</div>
		</div>
		<div class="dual-pricing-border"></div>
		<div class="april-pricing">
			<h3>${april1Header}</h3>
			{{= renderedAltPriceTemplate }}
		</div>
		<div class="why-rising-premiums-container hidden-md hidden-lg">${whyPremiumsRising}</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-template-sm">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<c:choose>
			<c:when test="${moreinfo_splittest_variant1 eq true or moreinfo_splittest_variant2 eq true}">
				<div class="col-sm-12 insureNowContainer">
					<div class="col-sm-6">
						<h3 class="text-dark">Need help? Call <span class="text-secondary">${callCentreNumber}</span></h3>
					</div>
					<div class="col-sm-6">
						<c:choose>
							<c:when test="${moreinfo_splittest_variant1 eq true}">
								<a href="javascript:;" class="btn btn-cta old-cta btn-block btn-more-info-apply btn-big-text" data-productId="{{= productId }}">Buy Now</a>
							</c:when>
							<c:otherwise>
								<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply btn-big-text" data-productId="{{= productId }}">Get Insured Now</a>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</c:when>
		</c:choose>
		<div class="heading-row">
			<h2>${heading}</h2>
			${whyPremiumsRising}
		</div>
		<div class="pricing-row">
			<div class="current-pricing">
				<h3>Current Pricing</h3>
				{{= renderedPriceTemplate }}
			</div>
			<div class="icon icon-arrow-thick-right"></div>
			<div class="april-pricing">
				<h3>${april1Header}</h3>
				{{= renderedAltPriceTemplate }}
			</div>
		</div>
		<div class="note">${note}</div>
	</div>
	<c:choose>
		<c:when test="${moreinfo_splittest_default eq true}">
			<div class="col-sm-12 insureNowContainer">
				<div class="insureNow">
					<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}">Get Insured Now<span class="icon-arrow-right" /></a>
				</div>
				<h3 class="text-dark">Need help? Call <span class="text-secondary">${callCentreNumber}</span></h3>
			</div>
		</c:when>
		<c:when test="${moreinfo_splittest_variant3}">
			<div class="col-sm-12 insureNowContainer">
				<div class="col-sm-6">
					<h3 class="text-dark">Need help? Call <span class="text-secondary">${callCentreNumber}</span></h3>
				</div>
				<div class="col-sm-6">
					<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply btn-big-text" data-productId="{{= productId }}">Buy Now</a>
				</div>
			</div>
		</c:when>
	</c:choose>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-template-xs">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			<h3>Current Pricing</h3>
			{{= renderedPriceTemplate }}
		</div>

		<c:choose>
			<c:when test="${moreinfo_splittest_default eq true}">
				<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}">Get Insured Now<span class="icon-arrow-right" /></a>
			</c:when>
			<c:when test="${moreinfo_splittest_variant1 eq true}">
				<a href="javascript:;" class="btn btn-cta old-cta btn-more-info-apply btn-big-text" data-productId="{{= productId }}">Buy now</a>
			</c:when>
			<c:when test="${moreinfo_splittest_variant2 eq true}">
				<a href="javascript:;" class="btn btn-cta btn-more-info-apply btn-big-text" data-productId="{{= productId }}">Get insured now<span class="icon-arrow-right" /></a>
			</c:when>
			<c:when test="${moreinfo_splittest_variant3 eq true}">
			</c:when>
		</c:choose>
		<h3>Need help? Call <span class="text-secondary">${callCentreNumber}</span></h3>

		<div class="promo">
			{{ if (promo.promoText !== ''){ }}
			<h2>Buy now and benefit from these promotions</h2>
			<p>{{= promo.promoText }}</p>
			{{ } }}
		</div>
		<hr />
		<h2>${heading}</h2>
		<div class="april-pricing">
			<h3>${april1Header} will be</h3>
			{{= renderedAltPriceTemplate }}
		</div>
		<div class="note">${note}</div>
		<c:if test="${moreinfo_splittest_variant3 eq true}">
			<div class="trailing-no-margin">
				<a href="javascript:;" class="btn btn-cta btn-more-info-apply btn-big-text" data-productId="{{= productId }}">Buy now</a>
			</div>
		</c:if>
		${whyPremiumsRising}
	</div>
</core_v1:js_template>
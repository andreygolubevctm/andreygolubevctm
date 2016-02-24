<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dual pricing templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />

<c:set var="thisYear"><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<core_v1:js_template id="price-frequency-template">
	<content:get key="frequencyWarning"/>
</core_v1:js_template>

<%-- Working on the assumption there's going to be text changes so put this in the db --%>
<core_v1:js_template id="more-info-why-price-rise-template">
	<content:get key="moreInfoWhyPricesRising"/>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-template">
	<div class="dual-pricing-container">
		<div class="current-pricing">
			<h2>Premiums are rising April 1</h2>
			<div><a href="javascript:;" class="why-rising-premiums">Why are premiums rising?</a></div>
			<h3>Current Pricing</h3>
			{{= renderedPriceTemplate }}
			<div class="note hidden-xs">Advance payments before 30 March ${thisYear} will be at the current price. Applications close on {{= obj.dropDeadDate }} to allow for processing</div>
		</div>
		<div class="dual-pricing-border"></div>
		<div class="april-pricing">
			<h3>Pricing on 1 April ${thisYear}</h3>
			{{= renderedAltPriceTemplate }}
		</div>
	</div>
</core_v1:js_template>
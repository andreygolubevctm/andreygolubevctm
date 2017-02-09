<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />

<script id="moreInfoAffixedHeaderMobileTemplate" type="text/html">
	<div class="container <c:if test="${healthAlternatePricingActive eq true}">hasDualPricing</c:if>">
		<div class="row">
			<div class="col-xs-6 logo-header">
				<div class="companyLogo {{= info.provider }}"></div>
			</div>
			<div class="col-xs-6 text-center mobile-pricing">
				{{= renderedPriceTemplate }}
			</div>
			<div class="col-xs-12">
				<h5 class="noTopMargin productName text-center">{{= info.productTitle }}</h5>
			</div>
			<div class="col-xs-12 text-center printableBrochuresLink">
				<a href="javascript:;" class="getPrintableBrochures">Get printable brochures in your email inbox</a>
			</div>
			<div class="col-xs-12 text-center">
				<div class="quote-reference-number"><h3>Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></h3></div>
				<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
			</div>
		</div>
	</div>
	<%-- Toggle for benefits --%>
	<div class="hidden-sm hidden-md hidden-lg toggleBar">
		<div class="selectionStatus extras">Your extras <span>0</span></div>
		<div class="selectionStatus hospital">Your hospital <span>0</span></div>
	</div>
</script>
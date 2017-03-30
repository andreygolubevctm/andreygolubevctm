<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<health_v1:dual_pricing_settings />

<script id="moreInfoAffixedHeaderMobileTemplate" type="text/html">
	<div class="container <c:if test="${isDualPriceActive eq true}">hasDualPricing</c:if>">
		<div class="row">
			<div class="col-xs-6 logo-header">
				<div class="companyLogo {{= info.provider }}"></div>
			</div>
			<div class="col-xs-6 text-center mobile-pricing">
				{{= renderedPriceTemplate }}
			</div>
			<c:if test="${isPyrrActive eq true}">
				{{= renderedPyrrCampaign }}
			</c:if>
			<div class="col-xs-12 productTitleText">
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
</script>
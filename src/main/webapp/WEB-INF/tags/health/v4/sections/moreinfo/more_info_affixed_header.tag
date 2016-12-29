<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="moreInfoAffixedHeaderTemplate" type="text/html">
	{{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
	{{ obj.showAltPremium = false; obj.renderedPriceTemplate =  priceTemplate(obj); }}

		<div class="col-xs-2">
			<div class="companyLogo {{= info.provider }}"></div>
		</div>
		<div class="col-xs-4 text-center">
			<h3 class="noTopMargin productNames vertical-align">{{= info.productTitle }}</h3>
		</div>
		<div class="col-xs-3 text-center">
			<div class="vertical-align">
			{{= renderedPriceTemplate }}
			{{= obj._selectedFrequency }}
			</div>
		</div>
		<div class="col-xs-3 text-center">
			<div class="quote-reference-number"><p>Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></p></div>
			<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Get Insured Now<span class="icon-arrow-right" /></a>
		</div>
</script>
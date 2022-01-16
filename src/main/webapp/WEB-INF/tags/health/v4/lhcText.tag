<%@ tag description="Returns lhcText"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ var frequency = obj._selectedFrequency; }}
{{ var prem = obj.premium[frequency]; }}
{{ var textLhcFreePricing = 'LHC loading may increase the premium.'; }}
{{ if (prem.lhcfreepricing.indexOf('premium') === -1) { textLhcFreePricing = ''; } }}
{{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;}}
{{ if (!isDualPricingActive && textLhcFreePricing !== '') { }}
<div class="lhcStaticText">{{= textLhcFreePricing}}</div>
{{ } }}
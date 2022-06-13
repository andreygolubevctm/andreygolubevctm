<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="price-breakdown-wrapper hidden-lg hidden-md hidden-sm">
    {{ if (obj.hasValidDualPricingDate) { }}
    <health_v4:price_breakdown_accordion_for_dual_price id="price-breakdown-accordion-mobile" hidden="false" title="PRICE BREAKDOWN"/>
    {{ } else { }}
    <health_v4:price_breakdown_accordion id="price-breakdown-accordion-mobile" hidden="false" title="PRICE BREAKDOWN" mobileAltPremium="false"/>
    {{ } }}
</div>
<div class="hidden-xs">
    <health_v4:policy_details/>
</div>
<div class="policy-details hidden-lg hidden-md hidden-sm">
    <health_v4:policy_details_accordion id="policy_details_accordion" hidden="false" title="POLICY DETAILS"/>
</div>

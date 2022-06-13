<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="id"	 rtexprvalue="true"	 description="accordion's id" %>
<%@ attribute name="hidden"	 rtexprvalue="true"	 description="should the accordion start in a hidden state" %>
<%@ attribute name="title"	 rtexprvalue="true"	 description="title" %>

{{ var showAltPremium = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true; }}
{{ var property = premium; }}
{{ if (showAltPremium) { property = altPremium; } }}
{{ var showFromDate = false; }}
{{ function showPriceAndFrequency(premium) { return ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)); } }}
{{ if(typeof property[obj._selectedFrequency] !== "undefined") { }}
    {{ if (showPriceAndFrequency(property[obj._selectedFrequency])) { }}
        {{ showFromDate = true; }}
    {{ } }}
{{ } }}
<health_v4:accordion id="${id}" hidden="${hidden}">
    <jsp:attribute name="title">
        ${title}
    </jsp:attribute>
    <jsp:body>
        <div class="price-breakdown-accordions-wrapper">
            {{ if(showPriceAndFrequency(property[obj._selectedFrequency])) { }}
            <health_v4:price_breakdown_accordion id="price-breakdown-accordion-single-combined" hidden="false" title="Current price breakdown" iconClass="plus" mobileAltPremium="false"/>
            <health_v4:price_breakdown_accordion id="price-breakdown-accordion-dual-combined" hidden="false" title="{{= obj.dualPricingDateOnlyMonth}} price breakdown" showPriceRiseBanner="true" iconClass="plus" mobileAltPremium="true"/>
            {{ } else { }}
            <health_v4:price_breakdown_accordion id="price-breakdown-accordion-single-combined" hidden="false" title="Current price breakdown" iconClass="plus" mobileAltPremium="false"/>
            {{ } }}
        </div>
    </jsp:body>
</health_v4:accordion>

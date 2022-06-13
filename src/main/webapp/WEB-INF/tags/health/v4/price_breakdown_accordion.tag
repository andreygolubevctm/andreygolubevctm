<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="id"	 rtexprvalue="true"	 description="accordion's id" %>
<%@ attribute name="hidden"	 rtexprvalue="true"	 description="should the accordion start in a hidden state" %>
<%@ attribute name="title"	 rtexprvalue="true"	 description="title" %>
<%@ attribute name="showPriceRiseBanner" rtexprvalue="true"	 description="overrides default hidden state for price-rise banner" %>
<%@ attribute name="iconClass"	 rtexprvalue="true"	 description="overrides default expand icon" %>
<%@ attribute name="mobileAltPremium" rtexprvalue="true" description="show AltPremium for mobile" %>

<health_v4:accordion id="${id}" hidden="${hidden}" iconClass="${iconClass}">
    <jsp:attribute name="title">
        ${title}
    </jsp:attribute>
    <jsp:body>
        {{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
        <c:if test="${not empty mobileAltPremium and mobileAltPremium eq true}">
        {{ availablePremiums = obj.altPremium; }}
        </c:if>
        <c:if test="${not empty mobileAltPremium and mobileAltPremium eq false}">
            {{ availablePremiums = obj.premium; }}
        </c:if>
        <div class="accordion-content">
            <div class="accordion-content-header">HOW YOUR PREMIUM IS CALCULATED</div>
            <div class="accordion-content-body"><span class="content-title">Cost of policy</span><span class="content-value">{{= availablePremiums[obj._selectedFrequency].grossPremium }}</span></div>
            <div class="accordion-content-body"><span class="content-title">Australian Govt Rebate <span class="value-in-content-title">{{= availablePremiums[obj._selectedFrequency].rebate }}%</span></span><span class="content-value">-{{= typeof availablePremiums[obj._selectedFrequency].rebateValue !== 'undefined' ? availablePremiums[obj._selectedFrequency].rebateValue : availablePremiums[obj._selectedFrequency].rebateAmount }}</span></div>
            {{ if(obj._selectedFrequency && availablePremiums[obj._selectedFrequency] && availablePremiums[obj._selectedFrequency].lhcPercentage !== 0) { }}
            <div class="accordion-content-body"><span class="content-title">LHC Loading based on <span class="value-in-content-title">{{= availablePremiums[obj._selectedFrequency].lhcPercentage }}%</span></span><span class="content-value">+{{= typeof availablePremiums[obj._selectedFrequency].lhc  !== 'undefined' ? availablePremiums[obj._selectedFrequency].lhc : availablePremiums[obj._selectedFrequency].lhcAmount }}</span></div>
            {{ } }}
            {{ if(obj._selectedFrequency && availablePremiums[obj._selectedFrequency] && typeof availablePremiums[obj._selectedFrequency].abdValue  !== 'undefined' && availablePremiums[obj._selectedFrequency].abd !== 0 ) { }}
                <div class="accordion-content-body"><span class="content-title"><health_v4:abd_badge_with_link_side_bar/></span><span class="content-value">-{{= '$' + availablePremiums[obj._selectedFrequency].abdValue }}</span></div>
            {{ } }}
            <c:if test="${not empty showPriceRiseBanner and showPriceRiseBanner eq true}">
                <div class="accordion-content-footer hidden-lg">
                    <health_v4_results:price_rise_banner showHelpIcon="false" textType="rateRiseBannerSideBar" isHiddenByDefault="false"/>
                </div>
            </c:if>
        </div>
    </jsp:body>
</health_v4:accordion>

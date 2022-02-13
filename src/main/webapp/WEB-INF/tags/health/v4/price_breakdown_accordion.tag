<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="id"	 rtexprvalue="true"	 description="accordion's id" %>
<%@ attribute name="hidden"	 rtexprvalue="true"	 description="should the accordion start in a hidden state" %>
<%@ attribute name="title"	 rtexprvalue="true"	 description="title" %>
<%@ attribute name="showPriceRiseBanner" rtexprvalue="true"	 description="overrides default hidden state for price-rise banner" %>
<%@ attribute name="iconClass"	 rtexprvalue="true"	 description="overrides default expand icon" %>

<health_v4:accordion id="${id}" hidden="${hidden}" iconClass="${iconClass}">
    <jsp:attribute name="title">
        ${title}
    </jsp:attribute>
    <jsp:body>
        <div class="accordion-content">
            <div class="accordion-content-header">HOW YOUR PREMIUM IS CALCULATED</div>
            <div class="accordion-content-body"><span class="content-title">Cost of policy</span><span class="content-value">{{= obj.premium[obj._selectedFrequency].grossPremium }}</span></div>
            <div class="accordion-content-body"><span class="content-title">Australian Govt Rebate <span class="value-in-content-title">{{= obj.premium[obj._selectedFrequency].rebate }}%</span></span><span class="content-value">-{{= obj.premium[obj._selectedFrequency].rebateValue }}</span></div>
            {{ if(obj._selectedFrequency && obj.premium[obj._selectedFrequency] && obj.premium[obj._selectedFrequency].lhcPercentage !== 0) { }}
            <div class="accordion-content-body"><span class="content-title">LHC Loading based on <span class="value-in-content-title">{{= obj.premium[obj._selectedFrequency].lhcPercentage }}%</span></span><span class="content-value">+{{= obj.premium[obj._selectedFrequency].lhc }}</span></div>
            {{ } }}
            {{ if(obj._selectedFrequency && obj.premium[obj._selectedFrequency] && obj.premium[obj._selectedFrequency].abdValue !== 0) { }}
                <div class="accordion-content-body"><span class="content-title"><health_v4:abd_badge_with_link_side_bar/></span><span class="content-value">-{{= '$' + obj.premium[obj._selectedFrequency].abdValue }}</span></div>
            {{ } }}
            <c:if test="${not empty showPriceRiseBanner and showPriceRiseBanner eq true}">
                <div class="accordion-content-footer hidden-lg">
                    <health_v4_results:price_rise_banner showHelpIcon="false" textType="rateRiseBannerSideBar" isHiddenByDefault="false"/>
                </div>
            </c:if>
        </div>
    </jsp:body>
</health_v4:accordion>

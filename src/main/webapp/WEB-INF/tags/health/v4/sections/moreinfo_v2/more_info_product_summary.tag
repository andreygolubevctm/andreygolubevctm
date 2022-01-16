<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<health_v1:dual_pricing_settings />
<c:set var="oldClass">
    <c:if test="${resultsHeaderMoreInfoLinkSplitTest eq false}">-old</c:if>
</c:set>
<c:set var="hiddenTitleClass">
    <c:if test="${resultsHeaderMoreInfoLinkSplitTest eq false}">hidden-xs</c:if>
</c:set>
<!-- Product Summary. Logo, price, LHC etc... -->
<div class="row priceRow productSummary">
    <div class="col-xs-12">
        {{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
            {{= renderedPyrrCampaign }}
        {{ } }}
        <div class="noTopMargin productName ${hiddenTitleClass}"><span class="productTitle${oldClass}">{{= info.productTitle }}</span></div>
    </div>
    <div class="col-xs-12 about-this-fund-row${oldClass}">
        <div class="fundDescription${oldClass}">
            <div>
            {{= product.aboutFund}}
            </div>
        </div>
        <c:if test="${resultsHeaderMoreInfoLinkSplitTest eq true}">
            <div class="readMoreFundDescription hidden">
                <a class="readMoreDescriptionLink" data-toggle="collapse" aria-expanded="false" aria-controls="collapseExample">Read more&nbsp;</a>
                <span class="icon-angle-down"/>
            </div>
        </c:if>
    </div>
    <c:if test="${resultsHeaderMoreInfoLinkSplitTest eq false}">
        <div class="col-xs-12 aboutThisFundLink">
            <a href="javascript:;" class="about-this-fund"><span class="help-icon icon-info"></span>About this fund</a>
        </div>
    </c:if>
    <div class="col-xs-12">
        <c:choose>
            <c:when test="${!isDualPriceActive eq true}">
            	{{ var prem = obj.premium[obj._selectedFrequency] }}
	            {{ var textLhcFreePricing = prem.lhcfreepricing ? prem.lhcfreepricing : '+ ' + formatCurrency(prem.lhcAmount) + ' LHC inc ' + formatCurrency(prem.rebateAmount) + ' Government Rebate' }}
	            {{ var textPricing = prem.pricing ? prem.pricing : 'Includes rebate of ' + formatCurrency(prem.rebateAmount) + ' & LHC loading of ' + formatCurrency(prem.lhcAmount) }}

            <div class="row moreInfoPricingSingle">
                <div class="moreInfoPriceWrapper">
                    <div class="moreInfoPriceContainer">
                        <div class="moreInfoPriceHeading">Current price</div>
                        <div class="moreInfoPrice">
                            {{= renderedPriceTemplate }}
                            <health_v4:abd_badge_with_link />
                        </div>
                    </div>
                </div>
            </div>
            </c:when>
            <c:otherwise>
                <health_v4_moreinfo_v2:more_info_dual_pricing_header />
            </c:otherwise>
        </c:choose>
    </div>
</div>

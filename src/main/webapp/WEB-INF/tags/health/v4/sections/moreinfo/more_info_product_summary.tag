<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<health_v1:dual_pricing_settings />

<!-- Product Summary. Logo, price, LHC etc... -->
<div class="row priceRow productSummary hidden-xs">
    <div class="col-xs-12">
        {{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
            {{= renderedPyrrCampaign }}
        {{ } }}
        <h2 class="noTopMargin productName hidden-xs">{{= info.productTitle }}</h2>
    </div>
    <div class="col-xs-12 about-this-fund-row">
        <div class="fundDescription">
            {{= product.aboutFund}}
        </div>
    </div>
    <div class="col-xs-12 aboutThisFundLink">
        <a href="javascript:;" class="about-this-fund"><img class="aboutIcon" src="assets/brand/ctm/images/icons/down_arrow.svg" />About this fund</a>
    </div>
    <div class="col-xs-12">
        <c:choose>
            <c:when test="${!isDualPriceActive eq true}">
            	{{ var prem = obj.premium[obj._selectedFrequency] }}
	            {{ var textLhcFreePricing = prem.lhcfreepricing ? prem.lhcfreepricing : '+ ' + formatCurrency(prem.lhcAmount) + ' LHC inc ' + formatCurrency(prem.rebateAmount) + ' Government Rebate' }}
	            {{ var textPricing = prem.pricing ? prem.pricing : 'Includes rebate of ' + formatCurrency(prem.rebateAmount) + ' & LHC loading of ' + formatCurrency(prem.lhcAmount) }}

            <div class="row hidden-xs moreInfoPricingSingle">
                <div class="moreInfoPriceWrapper">
                    <div class="moreInfoPriceContainer">
                        <div class="moreInfoPriceHeading">NOW</div>
                        <div class="moreInfoPrice">
                            {{= renderedPriceTemplate }}
                        </div>
                    </div>
                </div>
            </div>
            </c:when>
            <c:otherwise>
                <health_v4_moreinfo:more_info_dual_pricing_header />
            </c:otherwise>
        </c:choose>
    </div>
    <health_v4_moreinfo:more_info_product_extra_info />
</div>

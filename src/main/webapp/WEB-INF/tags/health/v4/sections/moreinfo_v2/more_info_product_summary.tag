<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<health_v1:dual_pricing_settings />
<!-- Product Summary. Logo, price, LHC etc... -->
<div class="row priceRow productSummary">
    <div class="col-xs-12">
        {{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
            {{= renderedPyrrCampaign }}
        {{ } }}
        <div class="noTopMargin productName"><span class="productTitle">{{= info.productTitle }}</span></div>
    </div>
    <div class="col-xs-12 about-this-fund-row">
        <div class="fundDescription">
            {{ var content = product.aboutFund; }}
            {{ content = content.replaceAll('<p>', ''); }}
            {{ content = content.replaceAll('</p>', '<br />');}}
            {{= content}}
        </div>
        <div class="readMoreFundDescription hidden">
            <a class="readMoreDescriptionLink" data-toggle="collapse" aria-expanded="false" aria-controls="collapseExample">Read more&nbsp;</a>
            <span class="icon-angle-down"/>
        </div>
    </div>
    <div class="col-xs-12">
        {{ if (meerkat.modules.healthDualPricing.validateAndGetDualPricingDate(obj)) { }}
            <health_v4_moreinfo_v2:more_info_dual_pricing_header />
        {{ } else { }}
            <div class="row moreInfoPricingSingle">
                <div class="moreInfoPriceWrapper">
                    <div class="moreInfoPriceContainer">
                        <div class="moreInfoPriceHeading">Current price</div>
                        <div class="moreInfoPrice">
                            {{= renderedMoreInfoSinglePriceTemplate }}
                            <health_v4:abd_badge_with_link />
                            <health_v4:lhcText />
                        </div>
                    </div>
                </div>
            </div>
        {{ } }}
    </div>
</div>

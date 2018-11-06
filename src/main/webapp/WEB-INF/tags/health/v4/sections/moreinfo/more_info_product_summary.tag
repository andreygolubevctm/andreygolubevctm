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
        <a href="javascript:;" class="about-this-fund">&or; About this fund</a>
    </div>
    <div class="col-xs-12">
        <c:choose>
            <c:when test="${!isDualPriceActive eq true}">
            <div class="row hidden-xs moreInfoPricing">
                <div class="moreInfoPriceWrapper singlePriceWrapper">
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

    <%--<div class="col-xs-12 printableBrochuresLink">--%>
        <%--<a href="javascript:;" class="btn btn-secondary btn-sm btn-block narrowMarginTop getPrintableBrochures">Email myself brochures</a>--%>
    <%--</div>--%>

</div>

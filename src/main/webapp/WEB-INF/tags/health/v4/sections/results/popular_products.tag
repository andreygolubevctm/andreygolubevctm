<%@ tag description="The Health Top 3 banner" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<agg_v1:popular_products_settings vertical="health" />

<c:if test="${not empty showPopularProducts and showPopularProducts eq true}">
    <core_v1:js_template id="results-popular-products-banner-template">
        <c:set var="popularProductsText">
            Here are the most popular product people like you buy
        </c:set>
        <div class="results-popular-products-banner invisible">
            <div class="container">
                <div class="row">
                    <div class="col-sm-6 col-md-7 col-lg-8 col-sm-push-6 col-md-push-5 col-lg-push-4">
                        <div class="popular-products-text hidden">
                            ${popularProductsText}
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-5 col-lg-4 col-sm-pull-6 col-md-pull-7 col-lg-pull-8">
                        <ul class="nav nav-tabs">
                            <li class="active">
                                <a href="javascript:;" data-popular-products="N" <field_v1:analytics_attr analVal="popular filter" quoteChar="\"" />>All products</a>
                            </li>
                            <li>
                                <a href="javascript:;" data-popular-products="Y" <field_v1:analytics_attr analVal="popular undo" quoteChar="\"" />>Popular products <span class="icon icon-info" <field_v1:analytics_attr analVal="popular help" quoteChar="\"" />></span></a>
                            </li>
                        </ul>
                    </div>
                </div>


            </div>
        </div>
    </core_v1:js_template>

    <core_v1:js_template id="results-popular-products-tag-template">
        {{ var popularProductTextTag = rankPos === 1 ? 'Most popular product' : 'Popular product ' + rankPos; }}
        <div class="result-popular-products-tag">{{= popularProductTextTag }}</div>
    </core_v1:js_template>
</c:if>

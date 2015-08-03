<%@ tag description="Fuel Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="resultsHeadersBg"></div>

<agg_new_results:results vertical="${pageSettings.getVerticalCode()}">
    <div class="resultsContainer v2 results-columns-sm-3 results-columns-md-3 results-columns-lg-3">
        <div class="featuresHeaders featuresElements">
            <div class="result headers">
                <div class="resultInsert"></div>
            </div>

            <%-- Feature headers --%>
            <div class="featuresList featuresTemplateComponent"></div>
        </div>

        <div class="resultsOverflow">
            <div class="results-table">
                <core_new:show_more_quotes_button />
            </div>
        </div>

        <core:clear />

        <div id="provider-disclaimer" class="short-disclaimer">
            <p><span class="hidden">Last updated <span class="time"></span> ago. </span><span class="supplier">Data supplied by Motormouth</span></p>
        </div>

        <div class="featuresFooterPusher"></div>
    </div>

    <core:js_template id="result-template">
        <div class="result-row available result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="Y">
            <div class="result">
                <div class="resultInsert priceMode">
                    <%-- START SM and Greater --%>
                    <div class="row column-banded-row vertical-center-row hidden-xs">
                        <div class="col-sm-6 col-md-7 productTitleCell">
                            <h2 class="productTitle">{{= obj.name }}</h2>
                            <div class="address">
                                <a href="javascript:;" data-productid="{{= obj.productId }}" data-siteid="{{= obj.siteid }}" data-lat="{{= obj.lat }}" data-lng="{{= obj.long }}" class="left map-open icon icon-location-pin needsclick"></a>
                                <p>
                                    {{= obj.address }} <br>
                                    {{= obj.suburb }} {{= obj.postcode }}
                                </p>
                            </div>
                        </div>
                        <div class="col-sm-3 fuelCell">
                            <div class="dataColumn"><span>{{= obj.fuelText }}</span></div>
                        </div>
                        <div class="col-sm-3 col-md-2 priceCell">
                            <div class="dataColumn">
                                <p class="price">{{= obj.priceText }}</p>
                                <p class="time-ago">{{= meerkat.modules.fuelResults.getFormattedTimeAgo(obj.createdFormatted) }}</p>
                            </div>
                        </div>
                    </div><%-- END SM and Greater --%>

                    <%-- START XS Top Row --%>
                    <div class="row visible-xs">
                        <div class="clearfix">
                            <div class="col-xs-7">
                                <h2 class="productTitle">{{= obj.name }}</h2>
                                <p class="address">
                                    {{= obj.address }} <br>
                                    {{= obj.suburb }} {{= obj.postcode }}
                                </p>
                            </div>
                            <div class="col-xs-5">
                                <p class="price">{{= obj.priceText }}</p>
                                <strong>{{= obj.fuelText }}</strong>
                                <p class="time-ago">{{= meerkat.modules.fuelResults.getFormattedTimeAgo(obj.createdFormatted) }}</p>
                            </div>
                        </div>
                    </div><%-- END XS Top Row --%>

                </div><%-- /resultInsert --%>
                    <%-- START XS Bottom Row --%>
            </div>
            <%-- END XS Bottom Row --%>
        </div>
    </core:js_template>

    <core:js_template id="unavailable-combined-template">
        <div class="result-row result_unavailable_combined notfiltered" data-available="N" style="display:block" data-position="{{= obj.length }}" data-sort="{{= obj.length }}">
            <div class="result"></div>
        </div>
    </core:js_template>

    <core:js_template id="error-template">
        <div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="E">
            <div class="result">
                <div class="resultInsert featuresMode">
                    <div class="productSummary results">
                        <p>We're sorry but this provider chose not to quote.</p>
                    </div>
                </div>

                <div class="resultInsert priceMode"></div>
            </div>
        </div>
    </core:js_template>

    <core:js_template id="snapshot-template">
        {{= data.fuelTypes }} in and around <br> <strong>{{= data.location }}</strong>
    </core:js_template>

    <%-- NO RESULTS --%>
    <div class="hidden">
        <c:set var="heading"><content:get key="blockedIPHeading" /></c:set>
        <c:set var="copy"><content:get key="blockedIPCopy" /></c:set>
        <confirmation:other_products heading="${heading}" copy="${copy}" id="blocked-ip-address" />

        <agg_new_results:results_none />
    </div>

    <%-- FETCH ERROR --%>
    <div class="resultsFetchError displayNone">
        Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later</a>.
    </div>
</agg_new_results:results>

<fuel_new:regional_results />
<fuel_new:fuel_map />
<fuel_new:chart />
<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" scope="request"/>

<div class="resultsHeadersBg">
</div>

<agg_new_results:results vertical="${pageSettings.getVerticalCode()}">
    <utilities_new:more_info/>

    <%-- RESULTS TABLE --%>

    <div class="bridgingContainer"></div>
    <div class="resultsContainer v2 results-columns-sm-3 results-columns-md-3 results-columns-lg-3">
        <div class="featuresHeaders featuresElements">
            <div class="result headers">

                <div class="resultInsert">
                </div>

            </div>

                <%-- Feature headers --%>
            <div class="featuresList featuresTemplateComponent">

            </div>
        </div>


        <div class="resultsOverflow">
            <div class="results-table">
                <core_new:show_more_quotes_button />
            </div>
        </div>
        <p class="utils-disclaimer">
            Estimated annual savings are based upon you currently paying the standard rate on a peak meter within your
            postcode and energy network.
            Costs and savings include GST & are effective as at <fmt:formatDate value="${now}" pattern="dd/MM/yyyy"/>.
        </p>
        <core:clear/>

        <div class="featuresFooterPusher"></div>
    </div>


    <%-- DEFAULT RESULT ROW --%>
    <core:js_template id="result-template">
        {{ var productBrand = (typeof obj.retailerName !== 'undefined') ? obj.retailerName : 'Unknown brand name'; }}
        {{ var productTitle = (typeof obj.planName !== 'undefined') ? obj.planName : 'Unknown product name'; }}

        {{ var template = $("#provider-logo-template").html(); }}
        {{ var logo = _.template(template); }}
        {{ logo = logo(obj); }}

        {{ var yearlySavingsLabel = yearlySavingsValue < 0 ? "extra cost up to $" + (yearlySavingsValue*-1) : "$" + yearlySavingsValue.toFixed(2); }}
        {{ var showYearlySavings = meerkat.modules.utilitiesResults.showYearlySavings(); }}

        {{ var smColCountContract = showYearlySavings ? 3 : 5; }}
        {{ var lgColCountContract = showYearlySavings ? 1 : 2; }}
        {{ var smColCountDiscounts = showYearlySavings ? 4 : 5; }}
        {{ var lgColCountDiscounts = showYearlySavings ? 2 : 3; }}
        <div class="result-row available result_{{= obj.productId }}" data-productId="{{= obj.productId }}"
             data-available="Y">
            <div class="result">
                <div class="resultInsert priceMode">
                        <%-- START SM and Greater --%>
                    <div class="row column-banded-row vertical-center-row hidden-xs">
                        <div class="col-sm-12 hidden-lg productTitleCell">

                            <div class="col-sm-8">
                                <h2 class="productTitle">{{= productBrand }}</h2>

                                <div class="productSubTitle">{{= productTitle }}</div>
                                {{ if (typeof obj.discountDetails !== 'undefined' && obj.discountDetails.length > 0) { }}
                                    <div class="promotion small">
                                        <strong>Discounts:</strong>
                                        {{ if(obj.discountDetails.length > 190) { }}
                                            {{= obj.discountDetails.substring(0, 190) }} <span title="Click More Info to see extra details">...</span>
                                        {{ } else { }}
                                            {{= obj.discountDetails }}
                                        {{ } }}
                                    </div>
                                {{ } }}
                            </div>
                            <div class="col-sm-3 col-sm-offset-1 cta">
                                <div class="buyNow">
                                    <a class="btn btn-primary btn-block btn-apply" href="javascript:;"
                                       data-productId="{{= obj.productId }}">
                                        <span>Apply Now</span> <span class="icon icon-arrow-right"/>
                                    </a>
                                </div>
                                <div class="moreInfo">
                                    <a href="javascript:;" class="btn-more-info"
                                       data-available="{{= obj.productAvailable }}"
                                       data-productId="{{= obj.productId }}">More
                                        Info</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-2 col-lg-1 lg-logo">
                            {{= logo }}
                        </div>
                        <div class="col-lg-4 visible-lg productTitleCell">
                            <div>
                                <h2 class="productTitle">{{= productBrand }}</h2>

                                <div class="productSubTitle">{{= productTitle }}</div>
                                {{ if (typeof obj.discountDetails !== 'undefined' && obj.discountDetails.length > 0) { }}
                                <div class="promotion small">
                                    <strong>Discounts:</strong>
                                    {{ if(obj.discountDetails.length > 150) { }}
                                        {{= obj.discountDetails.substring(0, 150) }} <span title="Click More Info to see extra details">...</span>
                                    {{ } else { }}
                                        {{= obj.discountDetails }}
                                    {{ } }}
                                </div>
                                {{ } }}
                            </div>
                        </div>
                        <div class="col-sm-{{= smColCountContract }} col-lg-{{= lgColCountContract }} contractPeriod">
                            <div class="dataColumn"><span>{{= contractPeriod }}</span></div>
                        </div>
                        {{ if(showYearlySavings === true) { }}
                        <div class="col-sm-3 col-lg-2 yearlySavingsContainer {{= (yearlySavingsValue <= 0 ? 'noSavings' : '') }}">
                            <div class="dataColumn"><span class="yearlySavings">{{= yearlySavingsLabel }}</span></div>
                        </div>
                        {{ } }}
                        <div class="col-sm-{{= smColCountDiscounts }} col-lg-{{= lgColCountDiscounts }} totalDiscountsContainer">
                            <div class="dataColumn"><span class="totalDiscounts">
                            {{ if(typeof obj.discountElectricity !== 'undefined' && typeof obj.discountGas !== 'undefined' && typeof obj.discountOther !== 'undefined' ) { }}
                                <div class="subDiscounts">
                                    <div><span class="small-black">Electricity:</span> {{= obj.discountElectricity }}%</div>
                                    <div><span class="small-black">Gas:</span> {{= obj.discountGas }}%</div>
                                    {{ if(obj.discountOther > 0) { }}
                                        <div><span class="small-black">Other:</span> {{= obj.discountOther }}%</div>
                                    {{ } }}
                                </div>
                            {{ }  else { }}
                                {{= obj.totalDiscountValue }}%
                            {{ } }}
                        </span></div>
                        </div>
                        <div class="col-md-12 col-lg-2 cta visible-lg">
                            <div class="row">
                                <div class="col-sm-4 col-sm-push-8 col-lg-push-0 col-lg-12 buyNow">
                                    <a class="btn btn-primary btn-block btn-apply" href="javascript:;"
                                       data-productId="{{= obj.productId }}">
                                        Apply Now <span class="icon icon-arrow-right"/></a>
                                </div>
                                <div class="col-sm-4 col-sm-pull-4 col-lg-12 moreInfo">
                                    <a href="javascript:;" class="btn-more-info"
                                       data-available="{{= obj.productAvailable }}"
                                       data-productId="{{= obj.productId }}">More
                                        Info</a>
                                </div>
                            </div>
                        </div>
                    </div>
                        <%-- END SM and Greater --%>

                        <%-- START XS Top Row --%>
                    <div class="row visible-xs">
                        <div class="col-xs-3 logoContainer">
                            {{= logo }}
                        </div>
                        <div class="col-xs-9">
                            <div class="row">
                                <div class="priceExcessContainer clearfix">
                                    <h2 class="productTitle singleProductTitle">
                                        {{= productTitle }}
                                    </h2>
                                    {{ var colCount = showYearlySavings === true ? '6' : '12'; }}
                                    <div class="col-xs-{{= colCount }} totalDiscountsContainer">
                                    <span class="totalDiscounts">
                                    {{ if(typeof obj.discountElectricity !== 'undefined' && typeof obj.discountGas !== 'undefined' && typeof obj.discountOther !== 'undefined' ) { }}
                                        <div class="subDiscounts">
                                            <div>{{= obj.discountElectricity }}%  <span class="totalDiscountsTitle">Electricity discounts</span></div>
                                            <div>{{= obj.discountGas }}% <span class="totalDiscountsTitle">Gas discounts</span></div>
                                            {{ if(obj.discountOther > 0) { }}
                                                <div>{{= obj.discountOther }}% <span class="otherDiscountsTitle">Other Discounts</span></div>
                                            {{ } }}
                                        </div>
                                    {{ }  else { }}
                                            {{= obj.totalDiscountValue }}%
                                            <span class="totalDiscountsTitle">Available discounts</span>
                                    {{ } }}
									</span>

                                    </div>
                                    {{ if(showYearlySavings === true) { }}
                                    <div class="col-xs-6 yearlySavingsContainer {{= (yearlySavingsValue <= 0 ? 'noSavings' : '') }}">
                                        <span class="yearlySavings">{{= yearlySavingsLabel }}</span>
                                        {{ if(yearlySavingsValue >= 0) { }}
                                        <span class="yearlySavingsTitle">Savings</span>
                                        {{ } }}
                                    </div>
                                    {{ } }}
                                </div>
                            </div>
                        </div>
                            <%-- /col-xs-10 --%>
                    </div>
                        <%-- END XS Top Row --%>

                </div>
                    <%-- /resultInsert --%>
            </div>
            <div class="featuresList featuresElements">

            </div>

        </div>
    </core:js_template>

    <%-- FEATURE TEMPLATE --%>
    <core:js_template id="feature-template"></core:js_template>

    <%-- UNAVAILABLE ROW --%>
    <core:js_template id="unavailable-template">
        {{ var productTitle = (typeof obj.planName !== 'undefined') ? obj.planName : 'Unknown product name'; }}
        {{ var productDescription = (typeof obj.planName !== 'undefined') ? obj.planName : 'Unknown product name'; }}

        {{ var template = $("#provider-logo-template").html(); }}
        {{ var logo = _.template(template); }}
        {{ logo = logo(obj); }}

        <div class="result-row unavailable result_{{= obj.productId }}" data-productId="{{= obj.productId }}"
             data-available="N">
            <div class="result">
                <div class="unavailable featuresMode">
                    <div class="productSummary results">
                    </div>
                </div>

                <div class="unavailable priceMode">
                    <div class="row">
                        <div class="col-xs-2 col-sm-8 col-md-6">
                            {{= logo }}
                            <h2 class="hidden-xs">{{= productTitle }}</h2>

                            <p class="description hidden-xs">{{= productDescription }}</p>
                        </div>
                        <div class="col-xs-10 col-sm-4 col-md-6">
                            <p class="specialConditions">We're sorry but these providers did not return a quote:</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </core:js_template>

    <%-- UNAVAILABLE COMBINED ROW --%>
    <core:js_template id="unavailable-combined-template">
        {{ var template = $("#provider-logo-template").html(); }}
        {{ var logo = _.template(template); }}
        {{ var logos = ''; }}
        {{ _.each(obj, function(result) { }}
        {{ if (result.available !== 'Y') { }}
        {{ logos += logo(result); }}
        {{ } }}
        {{ }) }}
        <div class="result-row result_unavailable_combined notfiltered" data-available="N" style="display:block"
             data-position="{{= obj.length }}" data-sort="{{= obj.length }}">
            <div class="result">
                <div class="unavailable featuresMode">
                    <div class="productSummary results clearfix">

                    </div>
                </div>

                <div class="unavailable priceMode clearfix">
                    <p>We're sorry but these providers did not return a quote:</p>
                    {{= logos }}
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
    </core:js_template>

    <%-- ERROR ROW --%>
    <core:js_template id="error-template">
        {{ var productTitle = (typeof obj.planName !== 'undefined') ? obj.planName : 'Unknown product name'; }}
        {{ var productDescription = (typeof obj.planName !== 'undefined') ? obj.planName : 'Unknown product name'; }}

        {{ var template = $("#provider-logo-template").html(); }}
        {{ var logo = _.template(template); }}
        {{ logo = logo(obj); }}

        <div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="E">
            <div class="result">
                <div class="resultInsert featuresMode">
                    <div class="productSummary results">

                    </div>
                </div>

                <div class="resultInsert priceMode">
                    <div class="row">
                        <div class="col-xs-2 col-sm-8 col-md-6">
                            <div class="companyLogo"><img src="assets/graphics/logos/results/{{= obj.productId }}_w.png" />
                            </div>

                            <h2 class="hidden-xs">{{= productTitle }}</h2>

                            <p class="description hidden-xs">{{= productDescription }}</p>
                        </div>
                        <div class="col-xs-10 col-sm-4 col-md-6">
                            <p class="specialConditions">We're sorry but these providers did not return a quote:</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </core:js_template>

    <%-- NO RESULTS --%>
    <div class="hidden">
        <agg_new_results:results_none/>
    </div>

    <%-- FETCH ERROR --%>
    <div class="resultsFetchError displayNone">
        Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);"
                                                                              data-slide-control="start"
                                                                              title='Revise your details'>try again
        later</a>.
    </div>

    <%-- Logo template --%>
    <core:js_template id="provider-logo-template">
        {{ var img = 'default_w'; }}
        {{ if (obj.hasOwnProperty('retailerName') && obj.retailerName.length > 1) img = obj.retailerName.toUpperCase().replace(/ /g, '_'); }}
        {{ var noShrinkClass = obj.hasOwnProperty('addNoShrinkClass') && obj.addNoShrinkClass ? 'noshrink' : ''; }}
        <div class="companyLogo logo_{{= img }} {{= noShrinkClass }}"></div>
    </core:js_template>

</agg_new_results:results>
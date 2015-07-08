<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" scope="request"/>

<div class="resultsHeadersBg">
</div>

<agg_new_results:results vertical="${pageSettings.getVerticalCode()}">
    <roadside_new:more_info/>

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
                    <%-- Prompt
                    <div class="container morePromptContainer">
                        <span class="morePromptCell">
                            <a href="javascript:;" class="morePromptLink">
                                <span class="icon icon-angle-down"></span>
                                <span class="morePromptLinkText hidden-xs">Go to Bottom</span>
                                <span class="icon icon-angle-down hidden-xs"></span>
                            </a>
                        </span>
                    </div> --%>
            </div>
        </div>
        <core:clear/>

        <div class="featuresFooterPusher"></div>
    </div>


    <%-- DEFAULT RESULT ROW --%>
    <core:js_template id="result-template">
        {{ var productBrand = (typeof obj.provider !== 'undefined') ? obj.provider : 'Unknown brand name'; }}
        {{ var productTitle = (typeof obj.des !== 'undefined') ? obj.des.replace('<br>',' ') : 'Unknown product name'; }}

        {{ var template = $("#provider-logo-template").html(); }}
        {{ var logo = _.template(template); }}
        {{ logo = logo(obj); }}

        {{ var calloutsText; }}
        {{ if(typeof obj.info == 'undefined' || typeof obj.info.roadCall == 'undefined' || obj.info.roadCall.text == '') { }}
        {{ calloutsText = "N/A";
        {{ } else { }}
        {{ calloutsText = obj.info.roadCall.text != "Unlimited" ? "Up to " + obj.info.roadCall.text : "Unlimited" }}
        {{ } }}
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
                            </div>
                            <div class="col-sm-3 col-sm-offset-1 cta">
                                <div class="buyNow">
                                    <a class="btn btn-primary btn-block btn-apply" href="javascript:;"
                                       data-productId="{{= obj.productId }}">
                                        <span>Continue Online</span> <span class="icon icon-arrow-right"/>
                                    </a>
                                </div>
                                <div class="moreInfo">
                                    <a href="javascript:;" class="btn-more-info"
                                       data-available="{{= obj.available }}"
                                       data-productId="{{= obj.productId }}">More
                                        Info</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-2 col-lg-1 lg-logo">
                            {{= logo }}
                        </div>
                        <div class="col-lg-3 visible-lg productTitleCell">
                            <div>
                                <h2 class="productTitle">{{= productBrand }}</h2>

                                <div class="productSubTitle">{{= productTitle }}</div>
                            </div>
                        </div>
                        <div class="col-sm-3 col-lg-2">
                            <div class="dataColumn"><span>City: {{= obj.info.towing.text }}<br/>
                            Country: {{= obj.info.towingCountry.text }}</span></div>
                        </div>
                        <div class="col-sm-2 col-lg-1">
                            <div class="dataColumn"><span>{{= calloutsText }}</span></div>
                        </div>
                        <div class="col-sm-2 col-lg-1">
                            <div class="dataColumn"><span>{{= obj.info.keyService.text }}</span></div>
                        </div>
                        <div class="col-sm-3 col-lg-2 priceContainer">
                            <div class="dataColumn">
                                <span class="price">
                                {{= obj.priceText }}
                            </span>
                            </div>
                        </div>
                        <div class="col-md-12 col-lg-2 cta visible-lg">
                            <div class="row">
                                <div class="col-sm-4 col-sm-push-8 col-lg-push-0 col-lg-12 buyNow">
                                    <a class="btn btn-primary btn-block btn-apply" href="javascript:;"
                                       data-productId="{{= obj.productId }}">
                                        Continue Online <span class="icon icon-arrow-right"/></a>
                                </div>
                                <div class="col-sm-4 col-sm-pull-4 col-lg-pull-0 col-lg-6 moreInfo">
                                    <a href="javascript:;" class="btn-more-info"
                                       data-available="{{= obj.available }}"
                                       data-productId="{{= obj.productId }}">More
                                        Info</a>
                                </div>
                                <div class="col-sm-4 col-sm-pull-4 col-lg-pull-0 col-lg-6 termsLink">
                                    {{= obj.subTitle.replace('& Conditions', '') }}<%--<a href="{{=obj.subTitle}}" target="_blank" class="showDoc">Terms</a>--%>
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

                                    <div class="col-xs-6 priceContainer">
                                    <span class="price">
                                            {{= obj.priceText }}
                                            <span class="small-heading">Per Year</span>
									</span>

                                    </div>
                                    <div class="col-xs-6 calloutsContainer">
                                        <span class="callouts">{{= calloutsText }}</span>
                                        <span class="small-heading">Annual Callouts</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                            <%-- /col-xs-10 --%>
                    </div>
                        <%-- END XS Top Row --%>

                </div>
                    <%-- /resultInsert --%>
                    <%-- START XS Bottom Row --%>
                <div class="row container visible-xs mainBenefitsContainer clearfix">
                    <div class="row mainBenefitsHeading">
                        <div class="col-xs-4 small-heading">
                            Emergency Key Service
                        </div>
                        <div class="col-xs-4 small-heading">
                            City Towing
                        </div>
                        <div class="col-xs-4 small-heading">
                            Country Towing
                        </div>
                    </div>
                    <div class="row mainBenefitsPricing">
                        <div class="col-xs-4">
                            {{= obj.info.keyService.text }}
                        </div>
                        <div class="col-xs-4">
                            {{= obj.info.towing.text }}
                        </div>
                        <div class="col-xs-4">
                            {{= obj.info.towingCountry.text }}
                        </div>
                    </div>
                </div>
                    <%-- /mainBenefitsContainer --%>
            </div>
            <div class="featuresList featuresElements">

            </div>

        </div>
    </core:js_template>

    <%-- FEATURE TEMPLATE --%>
    <div id="feature-template" style="display:none;" class="featuresTemplateComponent">

    </div>

    <%-- UNAVAILABLE ROW --%>
    <core:js_template id="unavailable-template">
        {{ var productTitle = (typeof obj.des !== 'undefined') ? obj.des : 'Unknown product name'; }}
        {{ var productDescription = (typeof obj.provider !== 'undefined') ? obj.provider : 'Unknown product name'; }}

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
        {{ if (obj.hasOwnProperty('providerCode') && obj.providerCode.length > 1) img = obj.providerCode.toUpperCase().replace(/ /g, '_'); }}
        {{ var noShrinkClass = obj.hasOwnProperty('addNoShrinkClass') && obj.addNoShrinkClass ? 'noshrink' : ''; }}
        <div class="companyLogo logo_{{= img }} {{= noShrinkClass }}"></div>
    </core:js_template>

</agg_new_results:results>
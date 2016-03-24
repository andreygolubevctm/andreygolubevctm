<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" scope="request"/>

<div class="resultsHeadersBg">
</div>

<agg_v2_results:results vertical="${pageSettings.getVerticalCode()}">
    <%-- RESULTS TABLE --%>
    <div class="bridgingContainer"></div>
    <div class="resultsContainer v2 results-columns-sm-3 results-columns-md-3 results-columns-lg-3">
        <div class="featuresHeaders featuresElements">
            <div class="result headers">
                <div class="resultInsert">
                </div>
            </div>
            <%-- Feature headers --%>
            <div class="featuresList featuresTemplateComponent"></div>
        </div>

        <div class="resultsOverflow">
            <div class="results-table">
                <core_v2:show_more_quotes_button />
            </div>
        </div>

        <core_v1:clear/>

        <div class="featuresFooterPusher"></div>
    </div>

    <%-- DEFAULT RESULT ROW --%>
    <core_v1:js_template id="result-template">
        <div class="result-row available result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="Y">
            <div class="result">
                <div class="resultInsert priceMode"></div>
                <%-- /resultInsert --%>

                <%-- START XS Bottom Row --%>
                <div class="row container visible-xs mainBenefitsContainer clearfix"></div>
                <%-- /mainBenefitsContainer --%>
            </div>
            <div class="featuresList featuresElements"></div>
        </div>
    </core_v1:js_template>

    <%-- FEATURE TEMPLATE --%>
    <core_v1:js_template id="feature-template"></core_v1:js_template>

    <%-- UNAVAILABLE ROW --%>
    <core_v1:js_template id="unavailable-template"></core_v1:js_template>

    <%-- UNAVAILABLE COMBINED ROW --%>
    <core_v1:js_template id="unavailable-combined-template"></core_v1:js_template>

    <%-- NO RESULTS --%>
    <div class="hidden">
        <agg_v2:no_quotes id="no-results-content"/>
    </div>

    <%-- FETCH ERROR --%>
    <div class="resultsFetchError displayNone">
        Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);"
                                                                              data-slide-control="start"
                                                                              title='Revise your details'>try again
        later</a>.
    </div>

    <%-- Logo template --%>
    <core_v1:js_template id="provider-logo-template">
        {{ var img = 'default_w'; }}
        {{ if (obj.hasOwnProperty('providerCode') && obj.providerCode.length > 1) img = obj.providerCode.toUpperCase().replace(/ /g, '_'); }}
        {{ var noShrinkClass = obj.hasOwnProperty('addNoShrinkClass') && obj.addNoShrinkClass ? 'noshrink' : ''; }}
        <div class="companyLogo logo_{{= img }} {{= noShrinkClass }}"></div>
    </core_v1:js_template>

</agg_v2_results:results>
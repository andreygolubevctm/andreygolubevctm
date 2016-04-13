<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" scope="request"/>

<div class="resultsHeadersBg"></div>

<agg_v2_results:results vertical="${pageSettings.getVerticalCode()}">
    <%-- RESULTS TABLE --%>
    <div class="bridgingContainer"></div>

    <div class="resultsContainer v2 fake-results-padding">
        <div class="featuresHeaders featuresElements">
            <div class="result headers">
                <div class="resultInsert"></div>
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
    <div class="fake-results-padding">
        <confirmation:other_products heading="" copy="Have you considered your other insurance needs? <span class='optinText'>comparethemarket.com.au</span> also compares:" id="resultsAlsoCompares"/>
    </div>

    <%-- DEFAULT RESULT ROW --%>
    <core_v1:js_template id="result-template">
        <div class="hidden result-row available result_{{= obj.product_id }}" data-productId="{{= obj.product_id }}" data-available="Y">
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
    <core_v1:js_template id="provider-logo-template"></core_v1:js_template>

    <%-- Thank you template --%>
    <core_v1:js_template id="thank-you-template">
        <div class="mockResults">
            <h1>Thank you for submitting your insurance enquiry</h1>

            <p>A consultant from <span class="results-highlighted">Lifebroker</span> will be in contact with you shortly to discuss your income protection needs and process your application.</p>
            <p>An email has been sent to <span class="results-highlighted" data-source="#ip_contactDetails_email"></span> with a summary of your details and your reference number.</p>
        </div>
    </core_v1:js_template>

</agg_v2_results:results>
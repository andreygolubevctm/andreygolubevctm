<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- Get data to build sections/categories/features --%>
<jsp:useBean id="resultsService" class="com.ctm.services.results.ResultsService" scope="request" />
<c:set var="resultTemplateItems" value="${resultsService.getResultsPageStructure(pageSettings.getVerticalCode())}" scope="request"  />
<c:set var="jsonString" value="${resultsService.getResultItemsAsJsonString(pageSettings.getVerticalCode(), 'category')}" scope="request"  />
<script>
    var resultLabels = ${jsonString};
</script>

<c:set var="brandCode" value="${pageSettings.getBrandCode()}" />

<jsp:useBean id="environmentService" class="com.ctm.services.EnvironmentService" scope="request" />

<jsp:useBean id="userAgentSniffer" class="com.ctm.services.UserAgentSniffer" />
<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
<div id="deviceType" data-deviceType="${deviceType}"></div>

<div class="resultsHeadersBg">
</div>

<agg_new_results:results vertical="${pageSettings.getVerticalCode()}">

    <%-- RESULTS TABLE --%>
    <div class="bridgingContainer"></div>
    <div id="results_v3" class="resultsContainer v2 results-columns-sm-3 results-columns-md-4 results-columns-lg-5">
        <div class="featuresHeaders featuresElements">

            <div class="result headers featuresNormalHeader">
                <div class="resultInsert controlContainer">
                </div>
            </div>

                <%-- Feature headers --%>
            <div class="featuresList featuresTemplateComponent">
                    <c:forEach items="${resultTemplateItems}" var="selectedValue" varStatus="status">
                        <features:resultsItem item="${selectedValue}" labelMode="true" index="${status.index}" />
                    </c:forEach>
            </div>
        </div>

        <div class="resultsOverflow">
            <div class="results-table">
            </div>
            <core_new:show_more_quotes_button />
        </div>
        <div class="comparisonFeaturesDisclosure">
            <div class="col-sm-5 disclaimer">
               <content:get key="lmiDisclaimer" />
            </div>
            <div class="col-sm-5">
                <content:get key="lmiCompareCopy" />
            </div>
            <div class="col-sm-2">
                <a href="${pageSettings.getBaseUrl()}car_quote.jsp" class="btn btn-next">
                    <span>Get a Quote</span> <span class="icon icon-arrow-right"></span>
                </a>
            </div>
            <div class="col-sm-12 disclosure">
                <content:get key="lmiDisclosure" />
            </div>
        </div>

        <core:clear />

        <div class="featuresFooterPusher"></div>


    </div>


    <%-- DEFAULT RESULT ROW --%>
    <core:js_template id="result-template">
        {{ var productTitle = (typeof obj.brandCode !== 'undefined') ? obj.brandCode : 'Unknown product name'; }}
        {{ var productDescription = (typeof obj.policyName !== 'undefined') ? obj.policyName : 'Unknown product name'; }}
        {{ obj.verticalLogo = meerkat.site.vertical == 'carlmi' ? 'car' : 'home' }}

        {{ var template = $("#provider-logo-template").html(); }}
        {{ var logo = _.template(template); }}
        {{ logo = logo(obj); }}

        <div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="Y">

            <div class="result featuresNormalHeader headers">
                <div class="resultInsert featuresMode">
                    <div class="productSummary results hidden-xs">
                        <div class="compare-toggle-wrapper">
                            <input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="features_compareTick_{{= obj.productId }}" />
                            <label for="features_compareTick_{{= obj.productId }}"></label>
                        </div>
                        <div class="logoContainer">
                            {{= logo }}
                        </div>
                        <h2>{{= productTitle }}</h2>
                        <strong>{{= productDescription }}</strong>
                    </div>
                    <div class="productSummary results visible-xs">
                        <div class="logoContainer">
                            {{= logo }}
                        </div>
                        <h2>{{= obj.brandCode }}</h2>
                        <strong>{{= obj.policyName }}</strong>
                    </div>
                </div>

                <div class="resultInsert priceMode">
                </div><%-- /resultInsert --%>

            </div>

                <%-- Feature list, defaults to a spinner --%>
            <div class="featuresList featuresElements">
                <img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/><%-- #WHITELABEL CX --%>
            </div>

        </div>
    </core:js_template>

    <%-- FEATURE TEMPLATE --%>
    <core:js_template id="feature-template">
           <c:forEach items="${resultTemplateItems}" var="selectedValue" varStatus="status">
                <features:resultsItem item="${selectedValue}" labelMode="false" index="${status.index}"/>
            </c:forEach>
    </core:js_template>

    <%-- ERROR ROW --%>
    <core:js_template id="error-template">
        {{ var productTitle = typeof obj.brandCode !== 'undefined' ? obj.brandCode : 'Unknown product name'; }}
        {{ var productDescription = typeof obj.policyName !== 'undefined' ? obj.policyName : 'Unknown product name'; }}

        {{ var template = $("#provider-logo-template").html(); }}
        {{ var logo = _.template(template); }}
        {{ logo = logo(obj); }}

        <div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="Y">
            <div class="result">
                <div class="resultInsert featuresMode">
                    <div class="productSummary results">
                        {{= logo }}
                        <p>We're sorry but this provider chose not to quote.</p>
                    </div>
                </div>

                <div class="resultInsert priceMode">
                </div>
            </div>
        </div>
    </core:js_template>

    <%-- NO RESULTS --%>
    <div class="hidden">
        <agg_new_results:results_none />
    </div>

    <%-- FETCH ERROR --%>
    <div class="resultsFetchError displayNone">
        Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later</a>.
    </div>

    <%-- Logo template --%>
    <core:js_template id="provider-logo-template">
        {{ var img = 'default_w'; }}
        {{ if (obj.hasOwnProperty('ctmProductId') && obj.ctmProductId.length > 1) img = obj.ctmProductId.substring(0, obj.ctmProductId.indexOf('-')); }}
        {{ if(img != 'default_w') { }}
            <div class="companyLogo logo_{{= img }}"></div>
        {{ } else { }}

            <div class="companyLogo icon icon-{{= obj.verticalLogo }}"></div>
        {{ } }}
    </core:js_template>

</agg_new_results:results>



<!-- COMPARE TEMPLETING BELOW -->
<%-- Template for results list. --%>
<core:js_template id="compare-basket-features-item-template">

    {{ for(var i = 0; i < products.length; i++) { }}
    <li>
			<span class="active-product">
				<input type="checkbox" class="compare-tick checked" data-productId="{{= products[i].productId }}" checked />
				<label for="features_compareTick_{{= products[i].productId }}"></label>
			</span>

			<span class="name">
				{{= products[i].brandCode }}
			</span>
    </li>
    {{ } }}
</core:js_template>
<!-- Compare products colums -->
<core:js_template id="compare-basket-features-template">
    <div class="compare-basket">
        {{ if(comparedResultsCount === 0) { }}
        <p>
            Click the <input type="checkbox" class="compare-tick"><label></label> to add up to <span class="compare-max-count-label">{{= maxAllowable }} products</span> to your shortlist.
            We've found <span class="products-returned-count">{{= resultsCount }} products</span> matching your selection.
        </p>
        {{ }  else { }}

        {{ var template = $("#compare-basket-features-item-template").html(); }}
        {{ var htmlTemplate = _.template(template); }}
        {{ var comparedItems = htmlTemplate(obj); }}


        <ul class="compared-products-list">

            {{= comparedItems }}

            {{ if(comparedResultsCount < maxAllowable && isCompareOpen === false) { }}
            {{ for(var m = 0; m < maxAllowable-comparedResultsCount; m++) { }}
            <li>
							<span class="compare-placeholder">
								<input type="checkbox" class="compare-tick" disabled />
								<label></label>
								<span class="placeholderLabel">Add another product</span>
							</span>
            </li>
            {{ } }}
            {{ } }}
        </ul>
        {{ if (comparedResultsCount > 1) { }}
        <div class="compareButtonsContainer">
            {{ if(meerkat.modules.compare.isCompareOpen() === true) { }}
            <a class="btn btn-compare-clear clear-compare btn-block" href="javascript:;">Clear Products<span class="icon icon-arrow-right"></span></a>
            {{ } else { }}
            <a class="btn btn-features-compare enter-compare-mode btn-block" href="javascript:;">Compare Products<span class="icon icon-arrow-right"></span></a>
            {{ } }}
        </div>
        {{ } }}
        {{ } }}
    </div>
    <div class="expand-collapse-toggle small hidden-xs">
        <a href="javascript:;" class="expandAllFeatures">Expand All</a> / <a href="javascript:;" class="collapseAllFeatures active">Collapse All</a>
    </div>
</core:js_template>

<%-- UNAVAILABLE COMBINED ROW --%>
<core:js_template id="unavailable-combined-template">
    <div class="result-row result_unavailable_combined notfiltered" data-available="N" style="display:block"
         data-position="0" data-sort="0">
        <div class="result">
            <div class="unavailable featuresMode">
                <div class="productSummary results clearfix">

                </div>
            </div>

            <div class="unavailable priceMode clearfix">
                <p>We're sorry but these providers did not return a quote:</p>
                <div class="clearfix"></div>
            </div>
        </div>
    </div>
</core:js_template>
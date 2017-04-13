<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Car features mode templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<!-- COMPARE TEMPLETING BELOW -->
<%-- Template for CAR results list. --%>
<core_v1:js_template id="compare-basket-features-item-template">
    {{ var tFrequency = Results.getFrequency(); }}
    {{ var monthlyHidden = tFrequency == 'monthly' ? '' : 'displayNone'; }}
    {{ var annualHidden = tFrequency == 'annual' ? '' : 'displayNone'; }}

    {{ for(var i = 0; i < products.length; i++) { }}
    <li>
			<span class="active-product">
				<input type="checkbox" class="compare-tick checked" data-productId="{{= products[i].productId }}" checked />
				<label for="features_compareTick_{{= products[i].productId }}"></label>
			</span>

        <span class="name">
				{{= products[i].productName }}
			</span>
        <span class="price">
				<span class="frequency annual annually {{= annualHidden }}">
					{{= '$' }}{{= products[i].price.annualPremiumFormatted }}
				</span>
				<span class="frequency monthly {{= monthlyHidden }}">
					{{= '$' }}{{= products[i].price.monthlyPremium.toFixed(2) }}
				</span>
			</span>
    </li>
    {{ } }}
</core_v1:js_template>

<!-- Compare products colums -->
<core_v1:js_template id="compare-basket-features-template">
    <div class="compare-basket">
        {{ if(comparedResultsCount === 0) { }}
        <p>
            We've found <span class="products-returned-count">{{= resultsCount }} products</span> matching your needs.
            <br>
            Click the <input type="checkbox" class="compare-tick"><label></label> to compare up to <span class="compare-max-count-label">{{= maxAllowable }} products</span>.

        </p>

        <agg_v1:inclusive_gst />

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
            <a class="btn btn-features-compare clear-compare btn-block" href="javascript:;">Clear Products<span class="icon icon-arrow-right"></span></a>
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
</core_v1:js_template>
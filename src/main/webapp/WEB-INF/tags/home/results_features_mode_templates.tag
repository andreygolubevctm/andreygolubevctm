<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="HnC features mode templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Template for H&C results list. --%>
<core_v1:js_template id="compare-basket-features-item-template">
    {{ var tFrequency = Results.getFrequency(); }}
    {{ var monthlyHidden = tFrequency == 'monthly' ? '' : 'displayNone'; }}
    {{ var annualHidden = tFrequency == 'annual' ? '' : 'displayNone'; }}

    {{ for(var i = 0; i < products.length; i++) { }}
    <li>
		<span class="active-product">
			<input type="checkbox" class="compare-tick checked" data-productId="{{= products[i].productId }}" checked />
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Short List - {{= obj.brandCode }} | {{= obj.productId }}" quoteChar="\"" /></c:set>
			<label for="features_compareTick_{{= products[i].productId }}" ${analyticsAttr}></label>
		</span>

        <span class="name">
			{{= products[i].productName }}
		</span>
        <span class="price">
			<span class="frequency annual annually {{= annualHidden }}">
				{{= products[i].price.annualPremiumFormatted }}
			</span>
			<span class="frequency monthly {{= monthlyHidden }}">
				{{= products[i].price.monthlyPremiumFormatted }}
			</span>
		</span>
    </li>
    {{ } }}
</core_v1:js_template>

<core_v1:js_template id="compare-basket-features-template">
    <div class="compare-basket">
        {{ if(comparedResultsCount === 0) { }}
        <p>
            We've found <span class="products-returned-count">{{= resultsCount }} products</span> matching your needs.
            <br>
            Click the <input type="checkbox" class="compare-tick"><label></label> to compare up to <span class="compare-max-count-label">{{= maxAllowable }} products</span>.
            <br>
            <br>
            <small>All prices are inclusive of GST &amp; Gov Charges</small>
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
            <a class="btn btn-features-compare enter-compare-mode btn-block" href="javascript:;" ${navBtnAnalyticsAttr}>Compare Products<span class="icon icon-arrow-right"></span></a>
            {{ } }}
        </div>
        {{ } }}
        {{ } }}
    </div>
    <div class="expand-collapse-toggle small hidden-xs">
        <a href="javascript:;" class="expandAllFeatures">Expand All</a> / <a href="javascript:;" class="collapseAllFeatures active">Collapse All</a>
    </div>
</core_v1:js_template>

<!-- Excess template featuresMode -->
<core_v1:js_template id="excess-features-template">
    <div class="excess row">
        {{ var contentsExcessAmount = (obj.contentsExcess !== null && obj.contentsExcess.amount != '') ? obj.contentsExcess.amount : null; }}
        {{ var homeExcessAmount = (obj.homeExcess !== null && obj.homeExcess.amount != '') ? obj.homeExcess.amount : null; }}

        {{ if (contentsExcessAmount !== null && homeExcessAmount !== null && contentsExcessAmount === homeExcessAmount) { }}
        <div class="col-xs-12 text-right">
            <div class="excessAmount">{{= obj.homeExcess.amountFormatted }}</div>
            <div class="excessTitle">Excess</div>
        </div>
        {{ } else { }}
        {{ if (homeExcessAmount !== null) { }}
        {{ var homeExcessCol = (contentsExcessAmount !== null && homeExcessAmount !== null) ? '6' : '12'; }}
        <div class="col-xs-{{= homeExcessCol }}">
            <div class="excessAmount">{{= obj.homeExcess.amountFormatted }}</div>
            <div class="excessTitle">Home excess</div>
        </div>
        {{ } else { }}
        <div class="col-xs-12">
            <div class="excessAmount excessContents">{{= obj.contentsExcess.amountFormatted }}</div>
            <div class="excessTitle">Contents excess</div>
        </div>
        {{ } }}

        {{ if (contentsExcessAmount !== null && homeExcessAmount !== null) { }}
        <div class="col-xs-6">
            <div class="excessAmount excessContents">{{= obj.contentsExcess.amountFormatted }}</div>
            <div class="excessTitle">Contents excess</div>
        </div>
        {{ } }}
        {{ } }}
    </div>
</core_v1:js_template>
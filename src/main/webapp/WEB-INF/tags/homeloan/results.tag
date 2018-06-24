<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Hidden fields --%>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<field_v1:hidden xpath="${xpath}/results/pageNumber" defaultValue="1" />
<field_v1:hidden xpath="${xpath}/results/loanTerm" defaultValue="30" />

<%-- Filters hidden inputs --%>
<field_v1:hidden xpath="${xpath}/results/frequency/weekly" defaultValue="" />
<field_v1:hidden xpath="${xpath}/results/frequency/fortnightly" defaultValue="" />
<field_v1:hidden xpath="${xpath}/results/frequency/monthly" defaultValue="Y" />
<field_v1:hidden xpath="${xpath}/fees/noApplication" defaultValue="" />
<field_v1:hidden xpath="${xpath}/fees/noOngoing" defaultValue="" />
<field_v1:hidden xpath="${xpath}/loanDetails/productLineOfCredit" defaultValue="" />
<field_v1:hidden xpath="${xpath}/loanDetails/productLowIntroductoryRate" defaultValue="" />
<field_v1:hidden xpath="${xpath}/features/redraw" defaultValue="" />
<field_v1:hidden xpath="${xpath}/features/offset" defaultValue="" />
<field_v1:hidden xpath="${xpath}/features/bpay" defaultValue="" />
<field_v1:hidden xpath="${xpath}/features/onlineBanking" defaultValue="" />
<field_v1:hidden xpath="${xpath}/features/extraRepayments" defaultValue="" />

<%-- Get data to build sections/categories/features --%>
<jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />
<c:set var="jsonString" value="${resultsDisplayService.getResultItemsAsJsonString('hmlams', 'category')}" scope="request"  />
<c:if test="${empty jsonString}">
	<c:set var="jsonString" value="''" />
</c:if>
<script>
	var resultLabels = ${jsonString};
</script>



<div class="resultsHeadersBg">
</div>


<agg_v2_results:results vertical="${pageSettings.getVerticalCode()}">

	<homeloan:more_info />

<%--
	<p>
		<a href="javascript:meerkat.modules.homeloanResults.switchToPriceMode()">Price view</a> &bull; <a href="javascript:meerkat.modules.homeloanResults.switchToFeaturesMode()">Features view</a>
	</p>
--%>

<%-- RESULTS TABLE --%>
	<div class="bridgingContainer"></div>
	<div class="resultsContainer v2 results-columns-sm-3 results-columns-md-3 results-columns-lg-3">
		<div class="featuresHeaders featuresElements">
			<div class="result headers">

				<div class="resultInsert controlContainer">
					<%-- Compare basket goes here --%>
				</div>

			</div>

			<%-- Feature headers --%>
			<features:resultsItemTemplate_labels />
			<div class="featuresList featuresTemplateComponent"></div>
		</div>

		<div class="resultsOverflow">
			<div class="results-table"></div>
		</div>

		<core_v1:clear />

		<%-- Prompt --%>
		<div class="morePromptContainer priceMode results-load-more" data-provide="results-load-more">
			<span class="morePromptCell">
				<a href="javascript:void(0)" class="morePromptLink results-load-more-activator"><span class="icon icon-angle-down"></span>Click to show more results<span class="icon icon-angle-down"></span></a>
			</span>
		</div>

		<div class="featuresFooterPusher"></div>
	</div>

	<div class="comparison-rate-disclaimer">
		<h6 class="small">Comparison rate disclaimer</h6>
		<p class="small">*Comparison rates shown are based on the home loan details you have entered which include loan amount and term of loan or on a secured loan of $150,000 over the term of 25 years for advertisements. WARNING: This comparison rate is true only for the examples given and may not include all fees and charges. Different terms, fees or other loan amounts might result in a different comparison rate.</p>
	</div>



<%-- DEFAULT RESULT ROW --%>
<core_v1:js_template id="result-template">
	{{ var productTitle = (typeof obj.lenderProductName !== 'undefined') ? obj.lenderProductName : 'Unknown product name'; }}
	{{ var lender = (typeof obj.lender !== 'undefined') ? obj.lender : 'Unknown lender'; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	{{ var template = $("#monthly-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var monthlyPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#interest-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var interestTemplate = htmlTemplate(obj); }}

	{{ var template = $("#interest-comparison-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var interestComparisonTemplate = htmlTemplate(obj); }}

	<div class="result-row result_{{= obj.id }}" data-productId="{{= obj.id }}" data-available="Y">
		<div class="result">

			<div class="resultInsert featuresMode">
				<div class="productSummary results hidden-xs">
					<div class="compare-toggle-wrapper">
						<input type="checkbox" class="compare-tick" data-productId="{{= obj.id }}" id="features_compareTick_{{= obj.id }}" />
						<label for="features_compareTick_{{= obj.id }}"></label>
						<label for="features_compareTick_{{= obj.id }}" class="compare-label"></label>
					</div>
					{{= logo }}
					{{= monthlyPriceTemplate }}

					<a class="btn btn-cta btn-block btn-enquire-now" href="javascript:;" data-productId="{{= obj.id }}">Enquire now <span class="icon icon-arrow-right" /></a>
				</div>
				<div class="productSummary results visible-xs">
					{{= logo }}
					<h2 class="productTitle">{{= lender }}</h2>
					<div class="productTitle">{{= productTitle }}</div>
					<a class="btn btn-cta btn-block btn-enquire-now" href="javascript:;" data-productId="{{= obj.id }}">Enquire now <span class="icon icon-arrow-right" /></a>
				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-4 col-sm-6 col-md-5 col-lg-4">
						{{= logo }}
						<div class="compare-toggle-wrapper">
							<input type="checkbox" class="compare-tick" data-productId="{{= obj.id }}" id="price_compareTick_{{= obj.id }}" />
							<label for="price_compareTick_{{= obj.id }}"></label>
							<label for="price_compareTick_{{= obj.id }}" class="compare-label"></label>
						</div>
						<h2 class="hidden-xs productTitle push-top-20">{{= lender }}</h2>
						<p class="description hidden-xs">{{= productTitle }}</p>
					</div>

					<div class="col-xs-4 col-sm-3 col-md-2 col-lg-2 push-top-20 ">
						{{= interestTemplate }}

						<div class="hidden-xs hidden-md hidden-lg push-top-20 ">
						{{= interestComparisonTemplate }}
						</div>
					</div>
					<div class="col-xs-4 col-md-2 col-lg-2 hidden-sm push-top-20 ">
						{{= interestComparisonTemplate }}
					</div>
					<div class="col-xs-4 col-sm-3 col-md-3 col-lg-2 push-top-20 ">
						{{= monthlyPriceTemplate }}
					</div>
					<div class="col-xs-4 col-sm-3 col-md-3 col-lg-2 push-top-20 col-md-offset-4 col-lg-offset-0">
						<a class="btn btn-cta btn-block btn-enquire-now hidden-xs" href="javascript:;" data-productId="{{= obj.id }}">Enquire now <span class="icon icon-arrow-right" /></a>
						<a href="javascript:;" class="btn-more-info hidden-xs" data-available="{{= obj.productAvailable }}" data-productId="{{= obj.id }}">more information</a>
					</div>
				</div><%-- /row --%>
			</div><%-- /resultInsert --%>

		</div>


		<%-- Feature list container --%>
		<div class="featuresList featuresElements">
		</div>

	</div>
</core_v1:js_template>

<%-- FEATURE TEMPLATE --%>
<features:resultsItemTemplate />

<%-- UNAVAILABLE ROW --%>
<core_v1:js_template id="unavailable-template">
	{{ var productTitle = (typeof obj.lenderProductName !== 'undefined') ? obj.lenderProductName : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.headline !== 'undefined' && typeof obj.headline.des !== 'undefined') ? obj.headline.des : ''; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	<div class="result-row result_{{= obj.id }}" data-productId="{{= obj.id }}" data-available="N">
		<div class="result">
			<div class="resultInsert featuresMode">
				<div class="productSummary results">
					{{= logo }}
					<p>We're sorry but this provider chose not to quote.</p>
				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-2 col-sm-8 col-md-6">
						{{= logo }}

						<h2 class="hidden-xs productTitle">{{= productTitle }}</h2>

						<p class="description hidden-xs">{{= productDescription }}</p>
					</div>
					<div class="col-xs-10 col-sm-4 col-md-6">
						<p class="specialConditions">We're sorry but this provider chose not to quote.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- UNAVAILABLE COMBINED ROW --%>
<core_v1:js_template id="unavailable-combined-template">
{{ var template = $("#brands-template").html(); }}
{{ var logo = _.template(template); }}
{{ var logos = logo(); }}
	<div class="result-row result_unavailable_combined notfiltered" data-available="N" style="display:block" data-position="{{= obj.length }}" data-sort="{{= obj.length }}">
		<div class="result">
			<div class="resultInsert featuresMode">
				<div class="productSummary results clearfix">
					<h2>Sorry, some of our providers were unable to get you a quote</h2>
					<div class="logos">{{= logos }}</div>
				</div>
			</div>

			<div class="resultInsert priceMode clearfix">
				<h2>Sorry, some of our providers were unable to get you a quote</h2>
				<div class="logos">{{= logos }}</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- ERROR ROW --%>
<core_v1:js_template id="error-template">
	{{ var productTitle = (typeof obj.lenderProductName !== 'undefined') ? obj.lenderProductName : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.headline !== 'undefined' && typeof obj.headline.description !== 'undefined') ? obj.headline.description : ''; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	<div class="result-row result_{{= obj.id }}" data-productId="{{= obj.id }}" data-available="E">
		<div class="result">
			<div class="resultInsert featuresMode">
				<div class="productSummary results">
					{{= logo }}
					<p>We're sorry but this provider chose not to quote.</p>
				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-2 col-sm-8 col-md-6">
						{{= logo }}

						<h2 class="hidden-xs productTitle">{{= productTitle }}</h2>

						<p class="description hidden-xs">{{= productDescription }}</p>
					</div>
					<div class="col-xs-10 col-sm-4 col-md-6">
						<p class="specialConditions">We're sorry but this provider chose not to quote.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- NO RESULTS --%>
<div class="hidden">
	<agg_v2:no_quotes id="no-results-content"/>
</div>

<%-- FETCH ERROR --%>
<div class="resultsFetchError displayNone">
	Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later</a>.
</div>

<%-- Logo template --%>
<core_v1:js_template id="provider-logo-template">
	{{ var img = ''; }}
	{{ if (obj.lender === 'Adelaide Bank') img = 'ADLB'; }}
 	{{ if (obj.lender.indexOf('AFG Home Loans') === 0) img = 'AFG'; }}
	{{ if (obj.lender === 'AMP Bank') img = 'AMP'; }}
	{{ if (obj.lender === 'ANZ') img = 'ANZ'; }}
	{{ if (obj.lender === 'Auswide Bank') img = 'AUSWIDE'; }}
	{{ if (obj.lender === 'Bank Australia') img = 'BANKAUST'; }}
	{{ if (obj.lender === 'Bank of China') img = 'BOC'; }}
	{{ if (obj.lender === 'Bank of Melbourne') img = 'BOM'; }}
	{{ if (obj.lender === 'Bank of QLD') img = 'BOQ'; }}
	{{ if (obj.lender === 'Bank SA') img = 'BANKSA'; }}
	{{ if (obj.lender === 'Bank of Sydney') img = 'BOS'; }}
	{{ if (obj.lender === 'Bankwest') img = 'BANKWEST'; }}
	{{ if (obj.lender === 'Beyond Bank') img = 'BEYOND'; }}
	{{ if (obj.lender === 'Bluestone') img = 'BLUESTONE'; }}
	{{ if (obj.lender === 'Citibank') img = 'CITI'; }}
	{{ if (obj.lender === 'Commonwealth Bank') img = 'CBA'; }}
	{{ if (obj.lender === 'Firefighters Mutual Bank') img = 'FIREFIGHTERS'; }}
	{{ if (obj.lender === 'Heritage Bank') img = 'HERITAGE'; }}
	{{ if (obj.lender === 'HomeStart Finance') img = 'HOMESTART'; }}
	{{ if (obj.lender === 'Homeloans') img = 'HOMELOANS'; }}
	{{ if (obj.lender === 'Homeside Lending') img = 'HOMESIDE'; }}
	{{ if (obj.lender === 'ING') img = 'ING'; }}
	{{ if (obj.lender === 'IMB') img = 'IMB'; }}
	{{ if (obj.lender === 'Keystart') img = 'KEY'; }}
	{{ if (obj.lender === 'La Trobe Financial') img = 'LATROBE'; }}
	{{ if (obj.lender === 'Liberty Financial') img = 'LIBERTY'; }}
	{{ if (obj.lender === 'Macquarie Bank') img = 'MACQ'; }}
	{{ if (obj.lender === 'ME') img = 'ME'; }}
	{{ if (obj.lender === 'ME Bank') img = 'ME'; }}
	{{ if (obj.lender === 'MKM Capital Pty Ltd') img = 'MKM'; }}
	{{ if (obj.lender === 'MyState') img = 'MYSTATE'; }}
	{{ if (obj.lender === 'NAB') img = 'NAB'; }}
	{{ if (obj.lender === 'NAB Broker') img = 'NABBROKER'; }}
	{{ if (obj.lender === 'National Australia Bank') img = 'NAB'; }}
	{{ if (obj.lender === 'Newcastle Permanent') img = 'NP'; }}
	{{ if (obj.lender === 'P&N Bank') img = 'PN'; }}
	{{ if (obj.lender === 'Pepper Homeloans') img = 'PEPPER'; }}
	{{ if (obj.lender === 'QBANK') img = 'QBANK'; }}
	{{ if (obj.lender === 'QPCU') img = 'QPCU'; }}
	{{ if (obj.lender === 'St George Bank') img = 'GEORGE'; }}
	{{ if (obj.lender === 'Suncorp') img = 'SUNCORP'; }}
	{{ if (obj.lender === 'Teachers Mutual Bank') img = 'TMB'; }}
	{{ if (obj.lender === 'The Rock') img = 'ROCK'; }}
	{{ if (obj.lender === 'The Rock Building Society Limited') img = 'ROCK'; }}
	{{ if (obj.lender === 'UniBank') img = 'UNIBANK'; }}
	{{ if (obj.lender === 'Westpac') img = 'WESTPAC'; }}
	{{ if (obj.lender === 'Wide Bay Australia') img = 'WIDE'; }}
	{{ if (obj.lender === 'Virgin Money	') img = 'VIRG'; }}



	<div class="companyLogo logo_{{= img }} noshrink"></div>
</core_v1:js_template>

</agg_v2_results:results>

<%-- Price templates --%>
<core_v1:js_template id="monthly-price-template">
{{ var tFrequency = Results.getFrequency(); }}
	<div class="frequency monthly{{= tFrequency !== 'monthly' ? ' displayNone' : '' }}">
		<div class="frequencyAmount">{{= (obj.hasOwnProperty('formatted')) ? obj.formatted.repayments.monthly : '$'+obj.monthlyRepayments }}</div>
		<div class="frequencyTitle">Monthly Repayments</div>
	</div>
	<div class="frequency fortnightly{{= tFrequency !== 'fortnightly' ? ' displayNone' : '' }}">
		<div class="frequencyAmount">{{= (obj.hasOwnProperty('formatted')) ? obj.formatted.repayments.fortnightly : '$'+obj.fortnightlyRepayments }}</div>
		<div class="frequencyTitle">Fortnightly Repayments</div>
	</div>
	<div class="frequency weekly{{= tFrequency !== 'weekly' ? ' displayNone' : '' }}">
		<div class="frequencyAmount">{{= (obj.hasOwnProperty('formatted')) ? obj.formatted.repayments.weekly : '$'+obj.weeklyRepayments }}</div>
		<div class="frequencyTitle">Weekly Repayments</div>
	</div>
</core_v1:js_template>

<%-- Interest template --%>
<core_v1:js_template id="interest-template">
	<div class="excess interestRate">
		<div class="excessAmount">{{= obj.formatted.intrRate }}</div>
		<div class="excessTitle">Interest Rate</div>
	</div>
</core_v1:js_template>

<%-- Interest template --%>
<core_v1:js_template id="interest-comparison-template">
	<div class="excess comparisonRate">
		<div class="excessAmount">{{= obj.formatted.comparRate }}</div>
		<div class="excessTitle">Comparison Rate*</div>
	</div>
</core_v1:js_template>


<%-- Template for Home Loans Compare results list. --%>
<core_v1:js_template id="compare-basket-features-item-template">
{{ var tFrequency = Results.getFrequency(); }}
{{ for(var i = 0; i < products.length; i++) { }}
	{{ var lender = (typeof products[i].lender !== 'undefined') ? products[i].lender : 'Unknown lender'; }}
	<li>
		<span class="active-product">
			<input type="checkbox" class="compare-tick checked" data-productId="{{= products[i].id }}" checked />
			<label for="features_compareTick_{{= products[i].id }}"></label>
		</span>

		<span class="name">{{= lender }}</span>

		<span class="price">
			<span class="frequency monthly{{= tFrequency !== 'monthly' ? ' displayNone' : '' }}">
				{{= (products[i].hasOwnProperty('formatted')) ? products[i].formatted.repayments.monthly : '$'+products[i].monthlyRepayments }}
			</span>
			<span class="frequency fortnightly{{= tFrequency !== 'fortnightly' ? ' displayNone' : '' }}">
				{{= (products[i].hasOwnProperty('formatted')) ? products[i].formatted.repayments.fortnightly : '$'+products[i].fortnightlyRepayments }}
		</span>
			<span class="frequency weekly{{= tFrequency !== 'weekly' ? ' displayNone' : '' }}">
				{{= (products[i].hasOwnProperty('formatted')) ? products[i].formatted.repayments.weekly : '$'+products[i].weeklyRepayments }}
			</span>
		</span>
	</li>
{{ } }}
</core_v1:js_template>

<core_v1:js_template id="compare-basket-price-item-template">
{{ var tFrequency = Results.getFrequency(); }}
{{ var tDisplayMode = Results.getDisplayMode(); }}
{{ var template = $("#provider-logo-template").html(); }}

{{ for(var i = 0; i < products.length; i++) { }}

	{{ var logo = _.template(template); }}
	{{ logo = logo(products[i]); }}
	<li class="compare-item">
		{{= logo }}
		<span class="price">
			<span class="frequency monthly{{= tFrequency !== 'monthly' ? ' displayNone' : '' }}">
				{{= (products[i].hasOwnProperty('formatted')) ? products[i].formatted.repayments.monthly : '$'+products[i].monthlyRepayments }} <span class="small hidden-sm">monthly</span>
			</span>
			<span class="frequency fortnightly{{= tFrequency !== 'fortnightly' ? ' displayNone' : '' }}">
				{{= (products[i].hasOwnProperty('formatted')) ? products[i].formatted.repayments.fortnightly : '$'+products[i].fortnightlyRepayments }} <span class="small hidden-sm">fortnightly</span>
		</span>
			<span class="frequency weekly{{= tFrequency !== 'weekly' ? ' displayNone' : '' }}">
				{{= (products[i].hasOwnProperty('formatted')) ? products[i].formatted.repayments.weekly : '$'+products[i].weeklyRepayments }} <span class="small hidden-sm">weekly</span>
			</span>
		</span>
		<span class="icon icon-cross remove-compare" data-productId="{{= products[i].id }}" title="Remove from shortlist"></span>
	</li>
{{ } }}
{{ if(comparedResultsCount < maxAllowable && isCompareOpen === false) { }}
	{{ for(var m = 0; m < maxAllowable-comparedResultsCount; m++) { }}
		<li class="compare-item small hidden-sm">
			<span class="compare-placeholder">
				<div class="companyLogo"></div>
				<span class="price">
					<span class="frequency monthly ">
						<span class="small hidden-sm">Add another product</span>
					</span>
				</span>
			</span>
		</li>
	{{ } }}
{{ } }}
</core_v1:js_template>

<core_v1:js_template id="compare-basket-features-template">
<div class="compare-basket">
<h2>Compare Products</h2>
{{ if(comparedResultsCount === 0) { }}
	<p>
		Click the <input type="checkbox" class="compare-tick"><label></label> to add up to <span class="compare-max-count-label">{{= maxAllowable }} products</span> to your shortlist.
		We've found <span class="products-returned-count">{{= resultsCount }} products</span> matching your needs.
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
		{{ if(meerkat.modules.compare.isCompareOpen() === true) { }}
			<a class="btn btn-compare-clear clear-compare btn-block" href="javascript:;">Clear Products<span class="icon icon-arrow-right"></span></a>
		{{ } else { }}
			<a class="btn btn-features-compare enter-compare-mode btn-block" href="javascript:;">Compare Products<span class="icon icon-arrow-right"></span></a>
		{{ } }}
	{{ } }}
{{ } }}
</div>
</core_v1:js_template>

<core_v1:js_template id="compare-basket-price-template">
	{{ if(comparedResultsCount > 0) { }}
		{{ var template = $("#compare-basket-price-item-template").html(); }}
		{{ var htmlTemplate = _.template(template); }}
		{{ var comparedItems = htmlTemplate(obj); }}

		<ul class="nav navbar-nav">
			<li class="navbar-text">Add up to <span class="compare-max-count-label">{{= maxAllowable }} products</span> to your shortlist</li>
			{{= comparedItems }}
		</ul>
		{{ if(comparedResultsCount > 1) { }}
			<ul class="nav navbar-nav navbar-right">
				<li class=""><a href="javascript:void(0);" class="compare-list enter-compare-mode">Compare Products <span class="icon icon-arrow-right"></span></a></li>
			</ul>
		{{ } }}
	{{ } }}
</core_v1:js_template>

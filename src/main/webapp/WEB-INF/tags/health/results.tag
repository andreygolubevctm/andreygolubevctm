<%@ tag description="The Health Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<jsp:useBean id="openingHoursService" class="com.ctm.services.simples.OpeningHoursService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />
<c:if test="${healthAlternatePricingActive eq true}">
	<c:set var="healthAlternatePricingMonth" value="${healthPriceDetailService.getAlternatePriceMonth(pageContext.getRequest())}" />
</c:if>

<%-- Hidden fields necessary for Results page --%>
<input type="hidden" name="health_showAll" value="Y" />
<input type="hidden" name="health_onResultsPage" value="Y" />
<input type="hidden" name="health_incrementTransactionId" value="Y" />

<c:if test="${!callCentre && data['health/journey/stage'] == 'results'}">
	<c:choose>
		<c:when test="${param.action == 'load' && not empty param.productId && not empty param.productTitle}">
			<input type="hidden" name="health_directApplication" value="Y" />
		</c:when>
		<c:when test="${param.action == 'load' || param.action == 'amend'}">
	<input type="hidden" name="health_retrieve_savedResults" value="Y" />
	<input type="hidden" name="health_retrieve_transactionId" value="${data['current/previousTransactionId']}" />
		</c:when>
	</c:choose>
</c:if>

<%-- The following are hidden fields set by filters --%>
<field:hidden xpath="health/excess" defaultValue="4" />
<field:hidden xpath="health/filter/providerExclude" />
<field:hidden xpath="health/filter/priceMin" defaultValue="0" />
<field:hidden xpath="health/filter/frequency" defaultValue="M" />
<field:hidden xpath="health/fundData/hospitalPDF" defaultValue=""/>
<field:hidden xpath="health/fundData/extrasPDF" defaultValue=""/>
<field:hidden xpath="health/fundData/providerPhoneNumber" defaultValue=""/>
		<c:if test="${callCentre}">
	<field:hidden xpath="health/filter/tierHospital" />
	<field:hidden xpath="health/filter/tierExtras" />
		</c:if>



<jsp:useBean id="resultsService" class="com.ctm.services.results.ResultsService" scope="request" />
<c:set var="jsonString" value="${resultsService.getResultItemsAsJsonString('health', 'category')}" scope="request"  />
<script>
	var resultLabels = ${jsonString};
</script>

<div class="resultsMarketingMessages affixOnScroll">
	<div class="resultsLowNumberMessage" >
	<div class="insert">
		<h4>These results are based on your selected filters.</h4>
		<div class="subtext">
			To adjust your filters,
		</div>
		<div>
			<a href="javascript:;" class="adjustFilters">click here.</a>
		</div>
	</div>
</div>
	<c:if test="${not empty callCentreNumber}">	
		<div class="resultsMarketingMessage callCentreNumberSection" >
			<div class="insert">
				<h4>Do you need a hand?</h4>
				<p class="larger">
					Call <em class="noWrap callCentreNumber">${callCentreNumber}</em>
				</p>
					</div>
			</div>
	</c:if>
</div>
<div class="resultsHeadersBg affixOnScroll">
</div>

<agg_new_results:results vertical="${pageSettings.getVerticalCode()}">
	<c:if test="${not empty callCentreNumber}">	
		<div class="resultsMarketingMessage callCentreNumberSection" >
			<div class="insert">
				<ul>
					<li>You get personal service from our experienced and friendly staff.</li>
					<li>We help you through each step of the process.</li>
					<li>We answer any questions you may have along the way.</li>
					<li>We can help you find the right cover for your needs.</li>
				</ul>
			</div>
		</div>
	</c:if>
	<health:logo_price_template />



<%-- RESULTS TABLE --%>
	<div class="moreInfoDropdown container"></div>

	<div class="resultsContainer affixOnScroll">

		<div class="featuresHeaders featuresElements  ">
			<div class="result headers">

				<div class="resultInsert controlContainer"></div>

			</div>
			<features:resultsItemTemplate_labels />
			<div class="featuresList featuresTemplateComponent"></div>
			</div>
		<div class="resultsOverflow">
			<div class="results-table"></div>
			</div>
		<core:clear />
		<div class="featuresFooterPusher"></div>


			</div>

<%-- DEFAULT RESULT ROW --%>
	<script id="result-template" type="text/html">
		<div class="result-row result_{{= productId }}" data-productId="{{= productId }}">
			<div class="result">
				<div class="resultInsert">
					<div class="compareCheckbox compare-toggle-wrapper" data-toggle="popover" data-trigger="mouseenter" data-class="compareTooltip" data-adjust-x="5" data-content="click<br/> to compare">
						<input type="checkbox" class="compare-tick" data-productId="{{= productId }}" id="features_compareTick_{{= productId }}" />
						<label for="features_compareTick_{{= productId }}"></label>
					</div>
					<div class="productSummary vertical results">

					{{ var logoPriceTemplate = $("#logo-price-template").html(); }}
					{{ var htmlTemplatePrice = _.template(logoPriceTemplate); }}
					{{ obj._selectedFrequency = Results.getFrequency(); }}
					{{ obj.showAltPremium = false; obj.htmlString = htmlTemplatePrice(obj); }}
					{{= htmlString }}

					</div>

					<a class="btn btn-cta btn-block btn-more-info more-info-showapply ${oldCtaClass}" href="javascript:;" data-productId="{{= productId }}">
						<div class="more-info-text">More Info & Apply<span class="icon icon-arrow-right" /></div>
						<div class="close-text"><span class="icon icon-arrow-left" />Back to Results</div>
					</a>
					{{ if( info.restrictedFund === 'Y' ) { }}
						<div class="restrictedFund" data-title="This is a Restricted Fund" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center" data-at="bottom center" data-content="#restrictedFundText" data-class="restrictedTooltips">RESTRICTED FUND</div>
					{{ } }}
				</div>
			</div>

			<div class="featuresList featuresElements">
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/> <%-- #WHITELABEL CX --%>
			</div>

		</div>
	</script>

<%-- FEATURE TEMPLATE --%>
	<div id="restrictedFundText" class="hidden">
		<p>Restricted funds provide private health insurance cover to members of a specific industry or group.</p>
		<p>In some cases, family members and extended family are also eligible.</p>
			</div>

<%-- FEATURE TEMPLATE --%>
		<features:resultsItemTemplate />
	<%--<div id="feature-template" style="display:none;" class="featuresTemplateComponent">
		<c:forEach items="${resultTemplateItems}" var="selectedValue" varStatus="status">
			<features:resultsItem item="${selectedValue}" labelMode="false" index="${status.index}"/>
		</c:forEach>
	</div>--%>

<%-- NO RESULTS --%>
	<div class="noResults displayNone">
		<div class="alert alert-info">
			No results found, please alter your filters and selections to find a match.
			</div>
			</div>

<%-- FETCH ERROR --%>
	<div class="resultsFetchError displayNone">
		Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later.</a>
			</div>

	<!-- COMPARE PANEL -->
	<core:js_template id="compare-basket-features-template">
		<div class="compare-basket compareCheckbox">
			{{ if(comparedResultsCount === 0) { }}
			<p>
				Click the <input type="checkbox" class="compare-tick" checked disabled><label></label> to add up to <span class="compare-max-count-label">{{= maxAllowable }} products</span> to your shortlist.
				We've found <span class="products-returned-count">{{= resultsCount }} products</span> <span class="smaller">matching your needs.</span>
			</p>
			{{ }  else { }}

			{{ var template = $("#compare-basket-features-item-template").html(); }}
			{{ var htmlTemplate = _.template(template); }}
			{{ var comparedItems = htmlTemplate(obj); }}

			<h3>Your shortlist</h3>
			<ul class="compareCheckbox compared-products-list">

				{{= comparedItems }}

				{{ if(comparedResultsCount < maxAllowable && isCompareOpen === false) { }}
					{{ template = $("#compare-basket-features-placeholder-template").html(); }}
					{{ htmlTemplate = _.template(template); }}
					{{ var placeholderItem = htmlTemplate(); }}
					{{ for(var m = 0; m < maxAllowable-comparedResultsCount; m++) { }}
						{{= placeholderItem }}
					{{ } }}
				{{ } }}
			</ul>
			{{ if (comparedResultsCount > 1) { }}
			<div class="compareButtonsContainer">
				{{ if(meerkat.modules.compare.isCompareOpen() === true) { }}
				<a class="btn btn-features-compare clear-compare btn-block" href="javascript:;">Clear Shortlist<span class="icon icon-arrow-right"></span></a>
				{{ } else { }}
				<a class="btn btn-features-compare enter-compare-mode btn-block" href="javascript:;">Compare<span class="icon icon-arrow-right"></span></a>
				{{ } }}
			</div>
			{{ } }}
			{{ } }}
		</div>
	</core:js_template>

	<%-- COMPARE BAR ITEM --%>
	<script id="compare-basket-features-item-template" type="text/html">
		{{ var tFrequency = Results.getFrequency(); }}
		{{ var displayNone = 'displayNone'; }}
		{{ var weeklyHidden = tFrequency == 'weekly' ? '' : displayNone; }}
		{{ var fortnightlyHidden = tFrequency == 'fortnightly' ? '' : displayNone; }}
		{{ var monthlyHidden = tFrequency == 'monthly' ? '' : displayNone; }}
		{{ var quarterlyHidden = tFrequency == 'quarterly' ? '' : displayNone; }}
		{{ var halfyearlyHidden = tFrequency == 'halfyearly' ? '' : displayNone; }}
		{{ var annuallyHidden = tFrequency == 'annually' ? '' : displayNone; }}

		{{ for(var i = 0; i < obj.products.length; i++) { }}
			{{var prod = products[i]; }}
		<li>

			<span class="active-product">
				<input type="checkbox" class="compare-tick checked" data-productId="{{= prod.productId }}" id="features_compareTick_{{= prod.productId }}" checked />
				<label for="features_compareTick_{{= prod.productId }}"></label>
			</span>

			<span class="name">{{= prod.info.providerName }}</span>
			<span class="price">
				<span class="frequency annual annually {{= annuallyHidden }}" >
					{{= prod.premium.annually.lhcfreetext }}
				</span>
				<span class="frequency halfyearly {{= halfyearlyHidden }}" >
					{{= prod.premium.halfyearly.lhcfreetext }}
				</span>
				<span class="frequency quarterly {{= quarterlyHidden }}">
					{{= prod.premium.quarterly.lhcfreetext }}
				</span>
				<span class="frequency monthly {{= monthlyHidden }}" >
					{{= prod.premium.monthly.lhcfreetext }}
				</span>
				<span class="frequency fortnightly {{= fortnightlyHidden }}" >
					{{= prod.premium.fortnightly.lhcfreetext }}
				</span>
				<span class="frequency weekly {{= weeklyHidden }}" >
					{{= prod.premium.weekly.lhcfreetext }}
				</span>
			</span>
		</li>
		{{ } }}
	</script>

	<script id="compare-basket-features-placeholder-template" type="text/html">
		<li class="compare-placeholder">
			<span class="active-product">
				<input type="checkbox" class="compare-tick" disabled />
				<label></label>
			</span>
			<span class="name">select another product</span>
		</li>
	</script>

</agg_new_results:results>

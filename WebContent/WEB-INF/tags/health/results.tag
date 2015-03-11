<%@ tag description="The Health Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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
		<div class="resultsMarketingMessage" >
			<div class="insert">
				<h4>Do you need a hand?</h4>
				<p class="larger">
					Call <em class="noWrap">${callCentreNumber}</em>
				</p>
				<p class="smaller">
					Our Australian based call centre hours are
				</p>
				<p class="smaller">
					<strong><form:scrape id='135'/></strong><%-- Get the Call Centre Hours from Scrapes Table HLT-832 --%>
				</p>
			</div>
		</div>
	</c:if>
</div>
<div class="resultsHeadersBg affixOnScroll">
</div>

<agg_new_results:results vertical="${pageSettings.getVerticalCode()}">
	<c:if test="${not empty callCentreNumber}">	
	<div class="resultsMarketingMessage" >
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

				<div class="resultInsert">
					<div class="compareBar">

						<div class="comparisonInactive">
							Click the <div class="compareCheckbox compareCloseIcon"><input type="checkbox" class="compare compareCloseIcon" checked disabled /><label ></label></div> to add up to <strong>3 products</strong> to your shortlist. We've found <span class="productCount"></span> <span class="smaller">matching your needs.</span>
			</div>

						<div class="comparisonActive">

							<div class="comparisonSummary">
								<h3>Your shortlist</h3>

								<ul class="comparedProductsList">

								</ul>
					</div>

							<a class="btn  compareBtn">Compare Now <span class="icon icon-arrow-right"></span></a>

						</div>
					</div>



						</div>

			</div>
			<div class="featuresList featuresTemplateComponent">
				<%-- Dual pricing START --%>
				<c:if test="${not empty healthDualpricing and healthDualpricing != '0'}">

					<div class="cell feature collapsed promosFeature dualPricing" data-index="-1">
						<div class="labelInColumn feature collapsed promosFeature">
							<div class="content" data-featureid="0">
								<div class="contentInner"><c:out value="${healthDualpricing}" /> Rate Rise</div>
			</div>
		</div>
						<div class="h content isMultiRow dualPricingLabel" data-featureid="0"><c:out value="${healthDualpricing}" /> Rate Rise</div>
	</div>

				</c:if>
				<%-- Dual pricing END --%>

				<%-- Note: ${resultTemplateItems} is a request scoped variable on health_quote.jsp page - as it is used in multiple places --%>
				<c:forEach items="${resultTemplateItems}" var="selectedValue" varStatus="status">
					<features:resultsItem item="${selectedValue}" labelMode="true" index="${status.index}" />
				</c:forEach>
		</div>
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
					<div class="compareCheckbox " data-toggle="popover" data-trigger="mouseenter" data-class="compareTooltip" data-adjust-x="5" data-content="click<br/> to compare">
						<input type="checkbox" class="compare " data-productId="result_{{= productId }}" id="compareCheckbox_{{= productId }}" />
						<label for="compareCheckbox_{{= productId }}"></label>
			</div>
					<div class="productSummary vertical results">

					{{ var logoPriceTemplate = $("#logo-price-template").html(); }}
					{{ var htmlTemplatePrice = _.template(logoPriceTemplate); }}
					{{ obj._selectedFrequency = Results.getFrequency(); }}
					{{ obj.showAltPremium = false; obj.htmlString = htmlTemplatePrice(obj); }}
					<%-- Dual pricing START --%>
			<c:choose>
						<c:when test="${not empty healthDualpricing and healthDualpricing != '0'}">
							{{ obj.showAltPremium = true;  obj.htmlStringAlt = htmlTemplatePrice(obj); }}
				</c:when>
				<c:otherwise>
							{{ obj.htmlStringAlt = ''; }}
				</c:otherwise>
			</c:choose>
					{{ obj.pricingMessage = ''; if (obj.info.provider === 'THF') { obj.pricingMessage = 'We are pleased to welcome Teachers Health Fund to our panel!'; } }}
					<%-- Dual pricing END --%>

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
	<div id="feature-template" style="display:none;" class="featuresTemplateComponent">
		<%-- Dual pricing START --%>
		<c:if test="${not empty healthDualpricing and healthDualpricing != '0'}">

			<div class="cell feature collapsed promosFeature dualPricing" data-index="-1">
				<div class="labelInColumn feature collapsed promosFeature">
					<div class="content" data-featureid="0">
						<div class="contentInner"><c:out value="${healthDualpricing}" /> Rate Rise</div>
		</div>
			</div>

				<div class="c content isMultiRow productSummary vertical" data-featureid="0">
					<h5>Pricing from <c:out value="${healthDualpricing}" /></h5>
					{{= htmlStringAlt }}
					{{ if (pricingMessage.length !== 0) { }}
						<p class="message">{{= pricingMessage }}</p>
					{{ } }}
			</div>
			</div>

		</c:if>
		<%-- Dual pricing END --%>

		<c:forEach items="${resultTemplateItems}" var="selectedValue" varStatus="status">
			<features:resultsItem item="${selectedValue}" labelMode="false" index="${status.index}"/>
		</c:forEach>
	</div>

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

<%-- COMPARE BAR ITEM --%>
	<script id="compareBar-compareBox" type="text/html">
		<li class="compareBox">

			<div class="compareCheckbox compareCloseIcon" data-productId="{{= id }}">
				<input type="checkbox" class="compare compareCloseIcon checked"  id="listBucket_{{= id }}"  checked="checked" />
				<label for="listBucket_{{= id }}"></label>
		</div>

			<span class="name">{{= object.info.providerName }}</span>
			<div class="price">
				<div class="frequency annually {{= Results.getFrequency() != 'annually' ? 'displayNone' : '' }}" >
					{{= object.premium.annually.lhcfreetext }}
			</div>
				<div class="frequency halfyearly {{= Results.getFrequency() != 'halfyearly' ? 'displayNone' : '' }}" >
					{{= object.premium.halfyearly.lhcfreetext }}
			</div>
				<div class="frequency quarterly {{= Results.getFrequency() != 'quarterly' ? 'displayNone' : '' }}">
					{{= object.premium.quarterly.lhcfreetext }}
			</div>
				<div class="frequency monthly {{= Results.getFrequency() != 'monthly' ? 'displayNone' : '' }}" >
					{{= object.premium.monthly.lhcfreetext }}
			</div>
				<div class="frequency fortnightly {{= Results.getFrequency() != 'fortnightly' ? 'displayNone' : '' }}" >
					{{= object.premium.fortnightly.lhcfreetext }}
			</div>
				<div class="frequency weekly {{= Results.getFrequency() != 'weekly' ? 'displayNone' : '' }}" >
					{{= object.premium.weekly.lhcfreetext }}
			</div>
			</div>
		</li>
	</script>

	<script id="compareBar-compareBoxPlaceholder" type="text/html">
		<li class="compareBox">
			<div class="compareCheckbox compareCloseIcon">
				<input type="checkbox" class="compare compareCloseIcon" disabled />
				<label ></label>
			</div>
			<span class="placeholderLabel">select another product</span>
		</li>
	</script>



</agg_new_results:results>

<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"	required="true"  rtexprvalue="true"	 description="The vertical using the tag" %>

<%-- EXTERNAL JS --%>
<go:script marker="js-href" href="common/js/features/Features.js" />

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	CarResults.init(); // common/js/car/car.js
</go:script>

<%-- HTML --%>
<agg_results:summary vertical="${vertical}" />

<agg_results:filters>

	<div class="filter clearfix">
		Payment: <field:array_select
					items="annual=Annual,monthly=Monthly"
					xpath="quote/paymentType"
					title="Payment Type"
					required="true"
					className="update-payment" />
	</div>

	<div class="filter clearfix">
		Excess*: <field:additional_excess
						increment="100"
						minVal="500"
						xpath="quote/excess"
						maxCount="16"
						title="optional additional excess"
						required="true"
						omitPleaseChoose="Y"
						className="update-excess" />
		<input type="hidden" name="quote_baseExcess" id="quote_baseExcess" value="600">
	</div>

	<div class="updateDisc">*Updated quotes will use the individual provider's closest available excess</div>

</agg_results:filters>

<agg_results:compare />

<agg_results:results vertical="${vertical}">

<%-- COMPARISON TABLE --%>
	<div class="compareResultsWrapper">
		<div id="compare-results">
			<div id='compareCloseButton'><img src='brand/ctm/images/quote_result/close.png' /></div><core:clear />
			<div id="compareTableData" class="featuresMode">

				<div class="featuresHeaders">
					<div class="featuresHeadersPusher"></div>
					<div class="featuresList">
						<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/>
					</div>
				</div>
				<div class="results-table"></div>
				<core:clear />

			</div>
			<core:clear />
		</div>
	</div>

<%-- RESULTS TABLE --%>
	<div class="resultsContainer">
		<div class="featuresNavBar featuresElements">
			<div class="resultsFound"><span class="nbResultsFounds">X</span> results <span class="lightgrey">found</span></div>
			<div class="featuresNav">
				<div class="viewMoreProducts"></div>
				<div data-results-pagination-control="previous" class="featuresLeftNav resultsLeftNav"></div>
				<div class="featuresScreensNav"></div>
				<div data-results-pagination-control="next" class="featuresRightNav resultsRightNav"></div>
			</div>
		</div>

		<div class="featuresHeaders featuresElements">
			<div class="featuresHeadersPusher"></div>
			<div class="featuresList">
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/>
			</div>
		</div>
		<div class="resultsOverflow">
			<div data-results-pagination-control="previous" class="leftArrow resultsLeftNav"></div>
			<div data-results-pagination-control="next" class="rightArrow resultsRightNav"></div>
			<div class="results-table"></div>
		</div>
		<core:clear />
	</div>

<%-- DEFAULT RESULT ROW --%>
	<core:js_template id="result-template">
		<div class="result-row result_[#= productId #] notfiltered" data-productId="[#= productId #]">
			<div class="result">
			<div class="checkboxCustomCont">
					<a href="javascript:void(0);" class="compare" data-productId="result_[#= productId #]"><span class="compare-on" style="display: none;" ></span></a>
				<div class="checkboxCustomTxt">Select to compare</div>
			</div>
				<div class="companyLogo">
					<img src="common/images/logos/results/[#= productId #]_w.png" class="companyImage" />
				</div>
			<div class="des">
					<h3>
						<a href="javascript:moreDetailsHandler.init('[#= productId #]')">[#= headline.name #]</a>
					</h3>
					<p>[#= headline.des #]</p>
					<span class="feature">[#= headline.feature #]</span>
			</div>
		
				<div class="excessAndPrice priceAvailable">
					<div class="excess">
						<div class="excessAmount">$[#= excess.total #]</div>
						<div class="excessTitle">Excess</div>
				</div>

					<div class="price">

						<div class="frequency annual" data-availability="[#= available #]">
							<div class="frequencyAmount">$[#= headline.lumpSumTotal #]</div>
							<div class="annualTitle">Annual Price</div>
	</div>

						<div class="frequency monthly" data-availability="[#= available #]">
							<p>Monthly Payments:</p>
							<p><span class="firstPayment">[#= headline.instalmentCount #] x</span> <span class="frequencyAmount">$[#= headline.instalmentPayment #]</span></p>
							<p>1<span class="super">st</span> Month x $[#= headline.instalmentFirst #]</p>
							<div class="hr" />
							<p>Total: <span class="grandTotal">$[#= headline.instalmentTotal #]</span></p>
	</div>

	</div>
			</div>
				<div class="excessAndPrice hidden priceNotAvailable">
					<span class="frequencyName bold">Monthly</span> payment is not available for this product.
		</div>
			<div class="link">
					<ui:button href="javascript:moreDetailsHandler.init('[#= productId #]')">More Details</ui:button>
				</div>
				<core:clear />
				</div>
			<div class="featuresJaggedBorder featuresElements"></div>
			<div class="featuresList featuresElements">
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/>
			</div>
			</div>
	</core:js_template>

<%-- UNAVAILABLE ROW --%>
	<core:js_template id="unavailable-template">
		<div class="result-row unavailable result_[#= productId #]" data-productId="[#= productId #]">
			<div class="result">
				<div class="checkboxCustomCont"></div>
				<div class="companyLogo">
					<img src="common/images/logos/results/[#= productId #]_w.png" class="companyImage" />
					</div>
			<div class="des">
					<h3><a href="javascript:void(0);">[#= headline.name #]</a></h3>
					<p>[#= headline.des #]</p>
					<span class="feature">[#= headline.feature #]</span>
				</div>
			<div class="excessPrice">
					<div class="excess"><span></span></div>
				</div>
				<div class="non-link"><p>We're sorry but this provider chose not to quote</p></div>
				<core:clear />
			</div>
			<div class="featuresJaggedBorder featuresElements"></div>
			<div class="featuresList featuresElements">
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/>
		</div>
	</div>
	</core:js_template>

<%-- ERROR ROW --%>
	<core:js_template id="error-template">
		<div class="result-row unavailable result_[#= productId #]" data-productId="[#= productId #]">
			<div class="result">
				<div class="checkboxCustomCont"></div>
				<div class="companyLogo">
					<img src="common/images/logos/results/[#= productId #]_w.png" class="companyImage" />
				</div>
				<div class="des">
					<h3><a href="javascript:void(0);">[#= headline.name #]</a></h3>
					<p>[#= headline.des #]</p>
					<span class="feature">[#= headline.feature #]</span>
				</div>
				<div class="excessPrice">
					<div class="excess"><span></span></div>
				</div>
				<div class="non-link"><p>We're sorry but this provider chose not to quote</p></div>
				<core:clear />
			</div>
			<div class="featuresJaggedBorder featuresElements"></div>
			<div class="featuresList featuresElements">
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/>
			</div>
		</div>
	</core:js_template>

<%-- CURRENT INSURER ROW --%>
	<core:js_template id="current-product-template">
		<div class="result-row current-product result_[#= productId #]" data-productId="[#= productId #]">
				<div class="current-insurer-Result"></div>
			<div class="result">
				<div class="checkboxCustomCont">
					<div class="checkboxCustomTxt">Select to compare</div>
		</div>
				<div class="companyLogo"></div>
				<div class="des">
					<h3>
						<a href="javascript:void(0)">Your Current Insurer</a>
					</h3>
					<p>
						Your current insurer is <span class="productNameCurrent">[#= headline.name #]</span>, and you have comprehensive car insurance. We have ranked your current insurer in these results based on the price information you have supplied only.
					</p>
	</div>

				<div class="excessAndPrice priceAvailable">
					<div class="excess">
						<div class="excessAmount">Unknown</div>
						<div class="excessTitle">Excess</div>
				</div>

					<div class="price">

						<div class="frequency annual" data-availability="[#= available #]">
							<div class="frequencyAmount">$[#= headline.lumpSumTotal #]</div>
							<div class="annualTitle">Annual Price</div>
			</div>

						<div class="frequency monthly" data-availability="[#= available #]">
							<p>Monthly Payments:</p>
							<p><span class="firstPayment">[#= headline.instalmentCount #] x</span> <span class="frequencyAmount">$[#= headline.instalmentPayment #]</span></p>
							<p>1<span class="super">st</span> Month x $[#= headline.instalmentFirst #]</p>
							<div class="hr" />
							<p>Total: <span class="grandTotal">$[#= headline.instalmentTotal #]</span></p>
			</div>

			</div>
			</div>
				<div class="excessAndPrice hidden priceNotAvailable">
					<span class="frequencyName bold">Monthly</span> payment is not available for this product.
			</div>
				<div class="non-link"><p>Based on information<br/>provided by you</p></div>
				<div class="current-insurer-disclosure">
					<p>Each product in this list may offer different benefits and features. Please always consider the product disclosure statement for each product before making a decision to buy.</p>
			</div>
				<core:clear />
		</div>
			<div class="featuresJaggedBorder featuresElements"></div>
			<div class="featuresList featuresElements">
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/>
		</div>
		</div>
	</core:js_template>

<%-- FEATURE TEMPLATE --%>
	<core:js_template id="feature-template">
		<div class="feature">
				<div class="featuresValues isMultiRow" data-featureId="[#= featureId #]">[#= value #]</div>
				<div class="featuresExtras children" data-fid="[#= featureId #]">
					<div class="featuresValues isMultiRow" data-featureId="[#= featureId #]-extra">[#= extra #]</div>
				</div>
		</div>
	</core:js_template>

<%-- NO RESULTS --%>
	<div class="noResults hidden">
		No results found, please <a href='javascript:Results.reviseDetails()' title='Revise your details'>revise your details</a>.
			</div>

<%-- FETCH ERROR --%>
	<div class="resultsFetchError hidden">
		Oops, something seems to have gone wrong. Sorry about that! Please <a href='javascript:Results.reviseDetails()' title='Revise your details'>try again later.</a>
			</div>

<%-- COMPARISON SPECIAL HEADER => Comparison table's manually injected header for Product features & benefits (see compareBuilt event) --%>
	<div class="comparisonTableStarsHeader hidden">
		<div class="featuresBar featuresDesc">
			<span class="featuresDescText">
				<img src="brand/ctm/images/quote_result/stars.png">Product features &amp; Benefits
			</span>
			</div>
		</div>

</agg_results:results>


<%-- CSS --%>
<go:style marker="css-head">
	/* custom CSS for this results page only */
	.filtersContainer {
		padding-top: 4px;
		color: #ffffff;
		font-size: 17px;
		}
		.filter{
			float: left;
			margin: auto 10px;
		}
			.filter select{
				font-size: 17px;
		}
		.updateDisc {
			font-size: 0.7em;
			color: #333;
			float: left;
			margin-top: 8px;
		}
	[data-featureId="Excess"] .featuresValues{
		font-weight: bold;
		font-size: 14px;
	}
	.featuresHeaders [data-featureId="Excess"] .featuresValues{
		font-weight: normal;
		font-size: 13px;
	}
	.termsLinks{
		margin-top: 5px;
		display: block;
	}

.expandable .featuresValues{
	padding-right: 7px;
	padding-left: 7px;
}
/*
.featuresList .feature,
.featuresList .category{
	padding: 0;
}
.featureContainer{
	padding: 5px 10px;
}
*/
/*
#compareTableData .featuresValues{
	padding: 5px 10px;
}
#compareTableData .featuresValues.productFeaturesRow{
	
}
*/

.expanded > .children,
.expanding > .children{
	display:block;
}
</go:style>
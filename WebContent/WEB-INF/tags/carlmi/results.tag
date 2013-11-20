<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"	required="true"  rtexprvalue="true"	 description="The vertical using the tag" %>

<%-- EXTERNAL JS --%>
<go:script marker="js-href" href="common/js/carlmi/Features.js" />

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	CarBrandsResults.init(); // common/js/carlmi/carlmi.js
</go:script>

<%-- HTML --%>
<carlmi:compare vertical="${vertical}"/>

<agg-results:results vertical="${vertical}">

<%-- RESULTS TABLE --%>
	<div class="resultsContainer">
		<div class="featuresHeaders featuresElements">
			<div class="featuresHeadersPusher">
				<ui:speechbubble colour="blue" arrowPosition="left" width="200">
					<h6>Want to Compare Prices?</h6>
					<a class="btn orange arrow-right block" href="car_quote.jsp?int=C:CF:R:1">Get a Quote</a>
				</ui:speechbubble>
			</div>
			<div class="featuresList">
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/>
			</div>
		</div>
		<div class="resultsOverflow">
			<div class="results-table"></div>
		</div>
		<core:clear />
		<div class="featuresFooterPusher"> </div>
	</div>

<%-- DEFAULT RESULT ROW --%>
	<core:js_template id="result-template">
		<div class="result-row result_[#= policyId #]" data-productId="[#= policyId #]">
			<div class="result">
				<div class="checkboxCustomCont">
					<a href="javascript:void(0);" title="Select to compare" class="compare" data-productId="result_[#= policyId #]"><span class="compare-on" style="display: none;" ></span></a>
					<div class="checkboxCustomTxt">Select to compare</div>
				</div>
				<div class="companyLogo">
					<img src="common/images/logos/results/[#= logo #]_w.png" class="companyImage" />
				</div>
				<div class="companyName" title="Brand: [#= brandName #]">[#= brandName #]</div>
				<div class="companyPolicy" title="Product: [#= policyName #]">[#= policyName #]</div>
				<core:clear />
			</div>
			<%-- <div class="featuresJaggedBorder featuresElements"></div> --%>
			<div class="featuresList featuresElements">
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/>
			</div>
		</div>
	</core:js_template>

<%-- FEATURE TEMPLATE --%>
	<core:js_template id="feature-template">
		<div class="[#= cellType #]" data-featureId="[#= featureId #]">
			<div class="featuresValues">[#= value #]</div>
			<div class="featuresExtras">[#= extra #]</div>
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

</agg-results:results>


<%-- CSS --%>
<go:style marker="css-head">
/* Features compare for LMI brand compare presentation design!
 * Overrides the style in agg/results.tag */

	body {
		overflow-x: hidden;
	}

	#resultsPage.vertical_carlmi {
		min-height:550px;
		overflow: hidden; /* Attempts to handle the horizontal scrollbars coming in to ie7 */
	}
	.vertical_carlmi .featuresHeadersPusher{
		height: 133px;
		background-color: white;
		margin-left: -9999px;
		margin-right: -9999px;
		z-index:0;
		border-bottom: 2px solid #cecece;
	}
	.vertical_carlmi .featuresHeadersPusher .speechbubble {
		position: absolute;
		left:0;
		margin-top: 14px;
	}
	.vertical_carlmi .featuresFooterPusher {
		height: 40px;
		background-color: white;
		margin-left: -9999px;
		margin-right: -9999px;
		z-index: 0;
		border-top: 2px solid #cecece;
		top: -2px;
		position:relative;
	}
	.vertical_carlmi .featuresMode .result-row {
		float: left;
		margin: 0;
		border-width: 0 10px 0px 10px;
		border-style: solid;
		border-color: white;
		width: 212px;
	}
	.vertical_carlmi .featuresMode .result {
		padding: 10px;
		position: relative;
		height: 113px;
		text-align: center;
		background: white;
		border-bottom: 2px solid #CECECE;
	}
	.vertical_carlmi .resultsContainer {
		padding: 0;
	}
	.vertical_carlmi .featuresMode .result .companyLogo { float: none; }
	.vertical_carlmi .featuresMode .companyLogo {
		width: 103px;
		height: 62px;
		position: relative;
		background-color: white;
		margin: 0 auto 1px;
		border: 0 none;
	}
	.vertical_carlmi .featuresMode .companyLogo img{
		max-width: 115px;
		max-height: 62px;
	}
	.vertical_carlmi .featuresMode .companyName {
		font-size: 18px;
		font-family: "SunLTBoldRegular", "Open Sans", Helvetica, Arial, sans-serif;
		font-weight: 300;
		color: #0db14b;
		margin: 3px 0;
		-ms-text-overflow: ellipsis;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		cursor: help;
	}
	.vertical_carlmi .featuresMode .companyPolicy {
		font-size: 14px;
		color: #595955;
		line-height: 18px;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		cursor: help;
	}
	.vertical_carlmi .featuresList{
		text-align: center;
		background-color: #ebebeb;
		font-size: 12px;
		font-weight: normal;
		line-height: 15px;
		vertical-align: middle;
		border-bottom: 2px solid #cecece;
	}

	.vertical_carlmi .featuresValues {
		color: #485F94;
	}

	/*
	 * This wont work on IE7 and IE8, and will revert
	 * back to borders use instead of shaded rows
	 */
	.vertical_carlmi .featuresList > div:nth-child(odd) { background-color: #e6e6e6; }
	.vertical_carlmi .featuresList > div:nth-child(odd) > div { border: 0 none; }
	.vertical_carlmi .featuresList > div:nth-child(even) > div { border: 0 none; }

	.vertical_carlmi .featuresList > div.expandableHover:nth-child(odd){
		background-color: #D3D3D3;
	}
	.vertical_carlmi .featuresList > div.category:nth-child(odd) {
		background-color: #5E729F;
	}
	.vertical_carlmi .featuresList .category{
		background-color: #5E729F;
	}
	.vertical_carlmi .featuresList .category .featuresValues{
		color: white;
	}

	.vertical_carlmi .featuresExtras {
		padding: 10px 10px;
		border-bottom: 1px solid #cccccc;
		color: #475E93;
		font-size: 10px;
		font-weight: bold;
	}
	.vertical_carlmi .featuresHeaders .featuresList{
		background-color: transparent;
		text-align: left;
	}
	.vertical_carlmi .featuresHeaders .featuresValues{
		text-align: left;
		padding-right: 15px;
		font-family: "SunLTLightRegular", "Open Sans", Helvetica, Arial, sans-serif;
		font-size: 14px;
		color: #2C3959;
		font-weight: normal;
	}
	.vertical_carlmi .featuresValues.expandable {
		background-image: url("brand/ctm/images/icons/arrow_down_blue.png");
		background-position: right 10px;
	}
	.vertical_carlmi .expanded .featuresValues.expandable {
		background-image: url("brand/ctm/images/icons/arrow_up_blue.png");
	}
	.vertical_carlmi .featuresMode .checkboxCustomCont{
		float: right;
	}
	.vertical_carlmi .featuresMode .checkboxCustomTxt{
		display: none;
	}
	<%--
	.vertical_carlmi .expanded {
		background-color: #D3D3D3 !important;
	}
	--%>
	<%--
	.vertical_carlmi .expandableHover .featuresValues.expandable {
		background-image: url("brand/ctm/images/icons/arrow_down_white.png");
	}
	.vertical_carlmi .expandableHover.expanded .featuresValues.expandable {
		background-image: url("brand/ctm/images/icons/arrow_up_white.png");
	}
	--%>

/*---- Code for 4 column experimental ------------------------------------------*/

	.vertical_carlmi .featuresMode .featuresHeaders {
		width: 202px;
	}
	.vertical_carlmi .featuresMode .result-row {
		width: 175px;
		/*border-width: 0 11px;*/
		border-width: 0 0 0 19px;
		/*border-width: 0 22px 0 0;*/
	}
	.vertical_carlmi .featuresMode .resultsOverflow {
		/*width: 778px;*/
		width: 776px;
		margin-left: auto;
	}

/*----- End 4 column experimental -------------------------------------*/

</go:style>

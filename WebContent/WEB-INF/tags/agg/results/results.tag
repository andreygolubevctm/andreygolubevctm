<%@ tag description="Results tag"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical"	required="true"	 	rtexprvalue="true"	 description="The vertical using the tag" %>

<%-- EXTERNAL JS --%>
<go:script marker="js-href" href="common/js/results/Results.js" />
<go:script marker="js-href" href="common/js/results/ResultsView.js" />
<go:script marker="js-href" href="common/js/results/ResultsModel.js" />
<go:script marker="js-href" href="common/js/results/ResultsUtilities.js" />

<%-- HTML --%>
<div id="resultsPage" class="vertical_${vertical}">
	<div class="resultsOverlay">
		<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" />
	</div>
	<jsp:doBody />
	<core:clear />
</div>

<%-- Used to save rankings after every results sorting --%>
<agg:rankings vertical="${vertical}" />

<%-- CSS --%>
<go:style marker="css-head">

/* For Features compare for LMI brand compare presentation
design overrides, please see quote/results_brands.tag */

/* STRUCTURE */
	#resultsPage {
		display: none;
		position: relative;
		min-height:800px;
		font-size: 1.3em;
		background-color: #EDEDED;
	}
		#resultsPage .resultsOverlay{
			position: absolute;
			top: 0;
			bottom: 0;
			left: 0;
			right: 0;
			z-index: 1000;
			background-color: #EDEDED;
			display: none;
		}
			#resultsPage .resultsOverlay img{
				margin: auto;
				margin-top: 200px;
				display: block;
			}
	.resultsContainer{
		max-width: 980px;
		margin: 0 auto;
		padding: 10px;
		position: relative;
	}
	.noResults{
		margin-top: 20px;
	}
		.noResults a{
			font-size: 16px;
		}
	.result-row{
		position: relative;
		opacity: 1;
	}
		.result-row.filtered{
			opacity: 0;
		}
		.leftTransition{
			<css:transition property="left" duration="1000" />
		}
		.topTransition{
			<css:transition property="top" duration="1000" />
		}
		.transformTransition{
			<css:transition property="transform" prefixedProperty="true" duration="1000" />
		}
		.noTransformTransition{
			<css:transition property="transform" prefixedProperty="true" duration="0" />
		}
		.opacityTransition{
			<css:transition property="opacity" duration="1000" />
		}
		.hardwareAcceleration{
			-webkit-transform: translate3d(0, 0, 0);
			-moz-transform: translate3d(0, 0, 0);
			-ms-transform: translate3d(0, 0, 0);
			transform: translate3d(0, 0, 0);
		}
	.featuresElements{
		display: none;
	}

/* DEFAULT ROW */
	.result .checkboxCustomCont,
	.result .companyLogo,
	.result .des,
	.result .excessAndPrice,
	.result .link,
	.result .non-link,
	.result .current-insurer-disclosure {
		float: left;
	}
	.checkboxCustomTxt {
		color: #333;
	}
	.compare {
		width: 25px;
		height: 26px;
		background: url(brand/ctm/images/quote_result/tickBox.png) no-repeat 0 0;
		display: block;
		cursor:pointer;
	}
		.compare-on {
			height: 25px;
			width: 25px;
			background: url(brand/ctm/images/quote_result/greenTick.png) no-repeat 0 0;
			margin-left: 2px;
			-webkit-animation: pulse .4s ease-in-out alternate;
			animation: pulse .4s ease-in-out alternate;
			display: block;
		}
	.compareInactive {
		<css:opacity value="0.3" />
		cursor: default;
	}
	.companyLogo {
		width: 85px;
		height: 85px;
		position: relative;
		border: 1px solid #999;
		background-color: white;
	}
		.companyLogo img{
			max-width: 85px;
			max-height: 85px;
		}
	.des {
		padding: 0 10px;
		width: 466px;
		margin-right: 10px;
		margin-left: 5px;
	}
		.des h3{
			margin-bottom: 5px;
			display: block;
			text-align: left;
			line-height: 15px;
		}
			.des h3 a,
			.des h3 span{
				font-size: 16px;
				color: #0C4DA2;
				text-decoration: none;
			}
		.des a{
			color: #666;
		}
		.des p{
			display: block;
			text-align: left;
			padding: 0 0 5px 0;
			font-size: 0.8em;
			line-height: 1.1em;
			text-align: left;
		}
		.des span.feature {
			display: block;
			text-align: left;
			font-size: 0.7em;
			color: #666;
		}
			.des span.feature a {
				display: block;
				text-align: left;
				color: #666;
				text-decoration: underline;
				padding-top: 5px;
			}
		.des span.conditions {
			font-size: 11px;
		}
	.result-row .link {
		float: right;
		margin: 30px 14px 0 0;
	}
	.result-row .link a {
		padding: 10px 12px;
	}
		body .resultsMoreDetails {
			float: right;
			margin: 27px 15px 0 0;
			width: 100%;
			text-shadow: none;
			font-weight: normal;
			padding: 10px 3px;
			color: #FFF;
			font-size: 1em;
			<css:box_shadow horizontalOffset="0" verticalOffset="1" spread="0" blurRadius="0" color="#00C960" inset="true" />
			<css:gradient topColor="#00B14B" bottomColor="#009934"/>
			<css:rounded_corners value="6" />
			border: 1px solid #008a25;

			text-decoration: none;
			text-align: center;
		}

/* EXCESSES */
	.excessAndPrice {
		width: 153px;
	}
	.excess {
		height: 40px;
		margin: 28px 0 0 0;
		float: left;
		text-align: center;
		font-size: 1.2em;
		min-width: 44px;
	}
		.excessAmount{
			font-size: 19px;
			margin-bottom: 5px;
			float: none;
		}
		.excessTitle{
			font-size: 13px;
			color: #999;
		}

	.result-row .price {
		font-size: 9px;
		float: right;
		text-align: right;
	}
		.frequency{
			display: none;
			color: #999;
		}
			.frequency p{
				line-height: 12px;
			}
		.annual.frequency {
			margin-top: 28px;
			display: block;
			margin-right: 8px;
		}
			.frequencyAmount{
				color: #FF6600;
				font-weight: bold;
				font-size: 28px;
				line-height: 22px;
			}
			.annualTitle{
				font-size: 12px;
				margin-top: 3px;
			}
		.monthly.frequency{
			margin-top: 10px;
		}
			.firstPayment{
				font-size: 12px;
			}
			.grandTotal{
				color: #5F5F5F;
				font-size: 1.3em;
				font-weight: bold;
			}
			.monthly .frequencyAmount{
				font-size: 18px;
			}
			.hr{
				border-bottom: 1px solid #999;
				margin: 4px auto;
			}
		.priceNotAvailable{
			margin-top: 22px;
		}
	.super {
		vertical-align: super;
		font-size: 0.6em;
	}


/* CURRENT INSURER ROW */
	.current-product .checkboxCustomCont{
		visibility: hidden;
	}
	.current-product .companyLogo{
		background: url(brand/ctm/images/quote_result/currentInsurerLogo.png) no-repeat center 20px;
		border: none;
	}
	.non-link {
		color: #999999;
		font-size: 0.7em;
	}

/* FOOTER */
	#footer {
		width: 100%;
		background: #CCCCCC;
		<css:box_shadow horizontalOffset="0" verticalOffset="2" spread="2" blurRadius="2" color="0,0,0,0.2" inset="true"  />
		margin: 0px 0 0 0;
		padding: 10px 0 50px 0;
	}

	#copyright {
		background: #CCCCCC;
	}


/* PRICE COMPARISON */
	.priceMode .result-row {
		border: 1px solid #A9A9A9;
		<css:box_shadow horizontalOffset="0" verticalOffset="2" spread="1" blurRadius="10" color="0,0,0,0.5" />
		display: block;
		width: 100%;
		margin-bottom: 14px;
	}
	.priceMode .result {
		padding: 10px 0 10px 0;
		color: #666666;
		<css:gradient topColor="#ffffff" bottomColor="#ECECEC" />
		*background-color: #FEFEFE;
		height: 90px;
		overflow: hidden;
	}
	/* Compare checkbox */
		.priceMode .checkboxCustomCont {
			padding: 5px;
			margin: 10px 15px 10px 15px;
			float: left;
			z-index: 999;
			background: #E6E6E6;
			<css:gradient topColor="#CCCCCC" bottomColor="#E6E6E6"  />
			<css:rounded_corners value="5" />
			<css:box_shadow horizontalOffset="0" verticalOffset="1" spread="2" blurRadius="2" color="0,0,0,0.1" inset="true"  />
			width: 50px;
		}
			.priceMode .checkboxCustomTxt {
				width: 50px;
				text-align: center;
				font-size: 0.7em;
			}
			.priceMode .compare {
				margin: 0 auto 5px;
			}

	/* Unavailable */
		.priceMode .unavailable div.des p {
			color:#7F7F7F;
			font-size: 11px;
			position: relative;
		}
		.priceMode .unavailable .checkboxCustomCont {
			visibility: hidden;
			min-width: 50px;
		}
	/* Current product */
		.priceMode .current-insurer-Result {
			width: 60px;
			height: 60px;
			background: url(brand/ctm/images/quote_result/currentInsurerIcon.png) no-repeat 0 0;
			position: absolute;
			top: 0;
			left: 0;
			z-index: 777;
		}
		.priceMode .productNameCurrent {
			color: #000000;
			font-size: 1.1em;
		}
		.priceMode .current-product .excess{
			margin-top: 25px;
		}
		.priceMode .current-product .frequency.annual{
			margin-top: 20px;
		}
		.priceMode .current-product .excessAmount{
			font-size: 13px;
		}
		.priceMode .current-product .frequency.monthly{
			margin-top: 0;
		}
		.priceMode .non-link {
			margin: 25px 25px 0 0;
			width: 108px;
			float: right;
		}
		.priceMode .current-insurer-disclosure {
			bottom: 0;
			position: absolute;
			background-color: #C9C9C9;
			color: #444444;
			font-size: 0.7em;
			padding: 2px 0;
			text-align: center;
			left: 0;
			right: 0;
		}
		.priceMode .current-product h3 a{
			cursor: text;
		}
	/* TOP RESULT */
		.priceMode .result-row .topResult {
			width: 60px;
			height: 60px;
			color: #666;
			background: url(brand/ctm/images/quote_result/topResult.png) no-repeat 0 0;
			position: absolute;
			top: -1px;
			left: -1px;
			z-index: 777;
			cursor:pointer;
		}


/* FEATURES COMPARISON */
	.featuresHeaders{
		width: 294px;
		float: left;
	}
		.featuresHeadersPusher{
			height: 201px;
		}

		.featuresHeadersLoading{
			position:absolute;
			top:0;
			bottom:0;
			right: 0;
			left: 0;
			margin: auto;
		}
	.featuresMode .resultsOverflow{
		overflow: hidden;
		width: 696px;
		position: relative;
		float: left;
		margin-left: -10px;
	}
		.featuresMode .leftArrow,
		.featuresMode .rightArrow {
			display: block;
			position: absolute;
			top: 0;
			width: 100px;
			height: 100%;
			border: 1px solid red;
			z-index: 1;
			cursor: pointer;
		}
		.featuresMode .leftArrow{
			left: 0;
		}
		.featuresMode .rightArrow{
			right: 0;
		}
	.featuresMode .results-table{
		float: left;
	}
	.resultsTableLeftMarginTransition{
		<css:transition property="margin-left" />
	}
	.featuresMode .result-row{
		float: left;
		margin: 0 10px;
		width: 212px;
	}
	.featuresMode .result{
		padding: 10px;
		background-color: #FFFFFF;
		<css:rounded_corners value="5" corners="top-left,top-right"/>
		position: relative;
	}
	.featuresJaggedBorder{
		background: url("brand/ctm/images/quote_result/jagged_bg.png");
		background-color: #E0E0E0;
		background-repeat: repeat-x;
		height: 3px;
	}
	.featuresHeaders .featuresList{
		background-color: transparent;
		text-align: left;
	}
		.featuresHeaders .featuresValues{
			text-align: right;
			font-size: 13px;
			padding-right: 20px;
		}
	.featuresList{
		text-align: center;
		background-color: #E0E0E0;

		font-size: 12px;
		font-weight: normal;
		line-height: 15px;
		vertical-align: middle;
	}

		.featuresExtras{
			display: none;
			word-break: break-word;
		}
		.featuresValues,
		.featuresExtras{
			padding: 5px 10px;
			border-bottom: 1px solid #cccccc;
			color: #666666;
		}

			.featuresValues.expandable {
				background-image: url("brand/ctm/images/price_presentation_arrow.png");
				background-position: right center;
				background-repeat: no-repeat;
			}
			.expandableHover {
				background-color: #D3D3D3;
				cursor: pointer;
			}
			.featuresValues.specialRow {
				background-color: #B2B2B2;
				margin-top: -1px; /* for the border */
			}
	.featuresLoading{
		margin: 20px auto;
	}


	/* Content */
		.featuresMode .des,
		.featuresMode .excessAndPrice .excess,
		.featuresMode .current-insurer-disclosure {
			display: none;
		}

		.featuresMode .checkboxCustomCont{
			margin-bottom: 10px;
		}
		.featuresMode .compare,
		.featuresMode .checkboxCustomTxt{
			float: left;
		}
		.featuresMode .checkboxCustomTxt{
			font-size: 1.15em;
			line-height: 1.4em;
			margin-left: 5px;
			font-weight: bold;
		}
		.featuresMode .excessAndPrice{
			width: auto;
			float: right;
		}
		.featuresMode .price .annual{
			margin-left: 10px;
		}
		.featuresMode .link{
			float: none;
			margin: 0;
		}
		.featuresMode .link a{
			padding: 10px 0;
			width: 100%;
			margin: 18px 0 0 0;
		}
		.featuresMode .non-link{
			width: 100%;
			text-align: center;
			margin-top: 27px;
			margin-bottom: 8px;
		}

	/* unavailable / current product */
		.featuresMode .unavailable .companyLogo{
			margin-left: 50px;
			margin-top: 37px;
		}

		.featuresMode .unavailable,
		.featuresMode .current-product,
		.featuresMode .unavailable .featuresList,
		.featuresMode .current-product .featuresList{
			padding-bottom: 99999px;
			margin-bottom: -99999px;
		}
</go:style>
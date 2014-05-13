<%@ tag description="The Comparison Bar"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- EXTERNAL JS --%>
<go:script marker="js-href" href="common/js/compare/Compare.js" />
<go:script marker="js-href" href="common/js/compare/CompareView.js" />
<go:script marker="js-href" href="common/js/compare/CompareModel.js" />

<%-- HTML --%>
<ui:horizontal-bar-element className="compareBar">
	<span class="darkGreen">Choose up to 3 products<br />below, then select <em><strong>compare</strong></em></span>
	<div class="vrGreenBar"></div>
	<div class="selectedProdTxt"></div>
	<ul>
		<li class="noneSelected compareBox">
			<span class="compareBoxLogo" ></span>
			<div class="compareCloseIcon"></div>
			<span id="noneSelectedText1" class="noneSelectedText" >NONE</span>
		</li>
		<li class="noneSelected compareBox">
			<span class="compareBoxLogo" ></span>
			<div class="compareCloseIcon"></div>
			<span id="noneSelectedText2" class="noneSelectedText" >NONE</span>
		</li>
		<li class="noneSelected compareBox">
			<span class="compareBoxLogo" ></span>
			<div class="compareCloseIcon"></div>
			<span id="noneSelectedText3" class="noneSelectedText" >NONE</span>
		</li>
		<core:clear />
	</ul>
	<a href="javascript:void(0);" id="compareBtn" class="compareBtn compareInActive">Compare</a>
	<div class="vrGreenBar"></div>
	<div class="savemsg">You can save $<span id="save_val">$$</span>!</div>
</ui:horizontal-bar-element>

<%-- CSS --%>
<go:style marker="css-head">

	.compareResultsWrapper{
		max-width: 980px;
		margin: 0 auto;
		text-align: center;
		position: relative;
		top: 7px;
	}
	#compare-results{
		position: absolute;
		left: -20000px;
	}
		#compare-results .checkboxCustomCont{
			display: none;
		}
		#compare-results .featuresElements{
			display: block;
		}
		#compare-results .featuresHeadersPusher{
			height: 164px;
		}
		#compare-results .results-table{
			margin-left: -10px;
		}

	a.compareBtn {
		text-decoration: none;
		float: left;
		padding: 8px 10px;
		color: #FFF;
		margin: 6px 20px 0 10px;
		text-align: center;
		<css:gradient topColor="#00B14B" bottomColor="#009934"  />
		border: 1px solid #008a25;
		<css:box_shadow horizontalOffset="0" verticalOffset="2" spread="1" blurRadius="0" color="0,0,0,0.1" inset="false" />
		<css:rounded_corners value="5" />
		font-size: 1.5em;
		vertical-align: middle;
		font-weight: 700;
	}

	.compareBar {
		background: #0DB14B;
		display: none;
		padding: 7px 0;
		z-index: 10001;
	}
	.compareBar.fixed-top {
		<css:box_shadow horizontalOffset="0" verticalOffset="1" blurRadius="10" spread="0" color="#A9A9A9" />
	}

	.fixedThree {
		margin: 58px auto 0 !important;
	}

	.selectedProdTxt {
		width: 81px;
		height: 5px;
		display: block;
		background:url(brand/ctm/images/quote_result/selectedProdTxt.png) no-repeat 0 0;
		position: absolute;
		top: -4px;
		left: 190px;
	}

	.noneSelected {
		<css:gradient topColor="#00801D" bottomColor="#00941F" />
	}
	.compareBox {
		border-color: #204422;
		border-style: solid;
		border-width: 1px;
	}

	.compareInActive {
		opacity: 0.5 !important;
		color: #006600 !important;
		cursor: default;
	}

	.vrGreenBar {
		width: 2px;
		height: 40px;
		margin: 3px 10px 0px 10px;
		display: block;
		float: left;
		background:url(brand/ctm/images/quote_result/vrGreenBar.png) no-repeat 0 0;
	}

	.darkGreen {
		color: rgb(0, 54, 27);
		font-size: 1em;
		float: left;
		margin-top: 10px;
		text-align: left;
	}

	.compareBar ul{
		padding-top: 8px;
		width: 150px;
		float: left;
		overflow: hidden;
	}
	.compareBar ul li {
		width: 30px;
		height: 30px;
		display: inline-block;
		*display:inline;
		zoom:1;
		margin: 0 5px;
	}

	.compareCloseIcon {
		width: 14px;
		height: 14px;
		border: 1px solid #000;
		position: relative;
		right: -8px;
		float: right;
		top: -36px;
		-webkit-border-radius: 10px;
		-moz-border-radius: 10px;
		border-radius: 10px;
		background:#000 url(brand/ctm/images/quote_result/closeIcon.gif) no-repeat center center;
		display: none;
		cursor: pointer;
	}

	.noneSelectedText {
		color: #204422;
		font-size: 8px;
		font-weight: 700;
		margin-top: 10px;
		margin-left: 3px;
		float: left;
		display: inline-block;
		*display:inline;
		zoom:1;
	}

	.compareBoxLogo {
		display:none;
		float: left;
		height: 30px;
		width: 30px;
	}
	.savemsg {
		zoom:1;
		font-size: 3em;
		font-family: 'just_another_handregular';
		color: #f2f2f2;
		float: right;
		top: 5px;
		display: none;
		position: relative;
	}

/* COMPARISON TABLE */
	#compareTableData{
		display: inline-block;
		*display: inline;
		*zoom:1;
		margin: 15px auto 0 auto;
	}
	#compareTableData .featuresElements{
		display: block;
	}
	#logo_top {
		float: left;
		border: 1px solid #B1B1B1;
	}

	.featuresValues.productFeaturesRow{
		height: 42px;
		padding: 0;
		background: url("brand/ctm/images/quote_result/product_features_bg.png") repeat-x;
		margin-top: -1px;
		margin-right: -25px;
		<css:rounded_corners value="5" corners="top-right,bottom-right" />
	}
	.featuresHeaders .featuresValues.productFeaturesRow{
		padding: 0;
	}
	.featuresBar {
		font-size: 17px;
		font-weight: bold;
		height: 42px;
		color: #595959;
		background: url("brand/ctm/images/quote_result/product_features_bg.png") repeat-x;
		box-shadow: none;
		text-align: left;
		<css:rounded_corners value="5" corners="top-left,bottom-left" />
		margin-left: -40px;
	}
	.featuresLast {
		<css:rounded_corners value="5" corners="bottom-right,top-right"/>
		box-shadow: -8px 0 8px 0 #969696 inset;
	}
	.featuresDescText {
		position: relative;
		top: 10px;
		z-index: 1;
		margin-left: 10px;
	}
	.featuresDescText img {
		margin-right: 10px;
	}
	#compareCloseButton {
		cursor: pointer;
		float: right;
	}
	.featuresDisclosure {
		font-size: 10px;
	}
</go:style>
<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-head">

	#pInfoLogo {
		margin-left:20px;
		border: 1px solid #CCCCCC;
		width: 90px;
		height: 73px;
		text-align: center;
	}
	#pInfoProductName {
		font-size: 18px;
		font-weight: bold;
		top: 10px;
		left: 130px;
		position: absolute;
	}
	#pInfoUnderwriter, #pInfoAFS {
		font-size: 11px;
		font-weight: normal;
		top: 55px;
		left: 132px;
		position: absolute;
		color: #808080;
	}
	#pInfoAFS {
		top: 67px;
	}
	#pInformation {
		width: 354px;
		height: 238px;
		position: absolute;
		top: 100px;
		left: 18px;
		border: 0px solid pink;
	}
	#pInformation ul {
		margin-top:0px;
	}
	#pInformation ul li {
		background: url("common/images/bullet_dot.png") no-repeat left 3px;
		padding-left: 13px;
		margin-bottom:4px;
	}

	#pInformation p {
		margin-bottom:7px;
		margin-top:3px;
	}
	#pInfoApplyOnlineButton {
		left: 493px;
		position: absolute;
		top: 56px;
	}
	#pInfoPhoneApplyButton {
		position: absolute;
		top: 21px;
		left: 493px;
	}
	#pInfoConditionBox {
		border: 0px solid #005C00;
		width: 220px;
		min-height: 50px;
		position:relative;
		z-index: 2001;
		background: url("common/images/compare-results-header.gif") no-repeat scroll 0 0 transparent;
		padding: 0px;
		font-size: 11px;
	}
	#pInfoSpecialOffer {
		border: 0px solid #005C00;
		width: 220px;
		min-height: 50px;
		position:relative;
		background: url("common/images/compare-results-header.gif") no-repeat scroll 0 0 transparent;
		padding: 0;
		font-size: 11px;
	}
	#pInfoSpecialOffer a {
		display: block;
		text-align: right;
		margin-top: 5px;
		margin-right: 5px;
	}

	#pInfoRHS {
		position:absolute;
		top:105px;
		left:400px;
		width:220px;
	}

	#pInfoRHS h4 {
		padding-top:12px;
	}

	#pInfoAdditionalExcesses {
		border: 0px solid #005C00;
		width: 220px;
		min-height: 50px;
		position: relative;
		background: url("common/images/compare-results-header.gif") no-repeat scroll 0 0 transparent;
	}
	#pInfoDisclaimer{
		width: 630px;
		/*height: 156px;*/
		position: absolute;
		z-index: 2000;
		top: 450px;
		left: 0;
	}
	#pDisclosureTitle {
		color: #074CD9;
		font-size: 11px;
		font-weight: bold;
		margin-left: 15px;
		margin-top: 10px;
	}
	#pDisclosureText {
		color: #6A6A6A;
		font-size: 11px;
		font-weight: bold;
		margin-left: 15px;
		margin-top: 0px;
	}
	#pDisclaimerTitle {
		color: #074CD9;
		font-size: 11px;
		font-weight: bold;
		margin-left: 15px;
		margin-top: 30px;
	}
	#pDisclaimerText {
		color: #6A6A6A;
		font-size: 11px;
		font-weight: bold;
		margin-left: 15px;
		margin-top: 0px;
	}

	#pInfoConditionBox h4,
	#pInfoSpecialOffer h4,
	#pInfoAdditionalExcesses h4 {
		margin-top: 10px;
		margin-left: 13px;
		font-size: 14px;
		font-weight: bold;
		font-family: "SunLT Bold",Arial,Helvetica,sans-serif;
		color: #0C4DA2;
	}

	#pInfoPDSA, #pInfoPDSB, #pInfoFSG {
		margin-left: 15px;
		position: relative;
		top: 2px;
	}
	#pInfoPDSB {
		top: 4px;
	}
	#pInfoFSG {
		top: 6px;
	}
	#pInfoSummaryText li {
		margin-left: 16px;
	}
	#productInfoHeading { background: url("common/images/product_info/product_info_header.gif") no-repeat;
						width: 211px; height: 19px; position: absolute; top: 12px; left: 14px; display: none; }

	#productInfoClose   { background: url(common/images/dialog/close.png) no-repeat;
						width: 36px; height: 34px; position: absolute; top: -34px; left: 602px; cursor: pointer; display: none; }

	#productInfoFooter {    background-image: url("common/images/dialog/footer.gif");
		background-position: 0 0;
		background-repeat: no-repeat;
		height: 14px;
	}
	left top transparent;
						width: 637px; height: 14px; display: none; }

	#budget_direct_awards	{ position: absolute; top: 80px;}
	#real_insurance_awards { position: absolute; top: 104px; left: 25px; }
	.smlbtn {
		width: 120px;
	}

</go:style>

<%-- HTML --%>
<ui:dialog
	id="prodInfo"
	title="Product Information"
	width="660"
	height="680" />

<core:js_template id="special-conditions-template">

	<div id='pInfoLogo'><img src='common/images/logos/product_info/[#= productId #].png' /></div>
	<div id='pInfoProductName'>[#= productName #]</div>
	<div id='pInfoUnderwriter'>Underwriter: [#= underwriter #]</div>
	<div id='pInfoAFS'>AFS Licence No: [#= afsLicenceNo #]</div>

	<div id='pInformation' class='[#= productId #]'>
		<div id='pInfoSummaryText'>[#= productInfo #]</div>
	</div>

	<div id='pInfoApplyOnlineButton' class='[#= productId #]_more_details_button'><a class='smlbtn' href='#'><span>More Details</span></a></div>

	<div id='pInfoRHS'>
		<div id='pInfoAdditionalExcesses'><h4>Additional Excesses</h4><div class='excessTable'>[#= excessTable #]</div></div>
		<div id='pInfoConditionBox'><h4>Special Conditions</h4><div class='policyConditionsTable'>[#= conditions #]</div></div>
		<div id='pInfoSpecialOffer'><h4>Special Feature / Offer</h4><div class='excessTable'>[#= feature #]</div></div>
	</div>

	<div id='pInfoDisclaimer'>
		<div id='pDisclosureTitle'>Product Disclosure Statement</div>
		<div id='pDisclosureText'>Please read the Product Disclosure Statements before deciding to buy:</div>
		<div id='pInfoPDSA'>[#= pdsA #]</div>
		<div id='pInfoPDSB'>[#= pdsB #]</div>
		<div id='pDisclaimerTitle'>Disclaimer</div>
		<div id='pDisclaimerText'>[#= disclaimer #]</div>
	</div>
</core:js_template>

<go:script marker="js-head">

	function product_info(prod) {

		var pdsA = "";
		if ( $('#pdsaUrl_'+prod).html().length>0 ){
			pdsA = "<a href='javascript:showDoc(\"" + $('#pdsaUrl_'+prod).html() + "\")'>";
			if( $('#pdsaDesLong_'+prod).html().length>0 ) {
				pdsA += $('#pdsaDesLong_'+prod).html();
			} else {
				pdsA += 'Product Disclosure Statement Part A';
			}
			pdsA += "</a>";
		}

		var pdsB = "";
		if ( $('#pdsbUrl_'+prod).html().length>0 ){
			pdsB = "<a href='javascript:showDoc(\""+$('#pdsbUrl_'+prod).html()+"\")'>";
			if( $('#pdsbDesLong_'+prod).html().length>0 ) {
				pdsB += $('#pdsbDesLong_'+prod).html();
			} else {
				pdsB += 'Product Disclosure Statement Part B';
			}
			pdsB += "</a>";
		}

		var data = {
			productId: prod,
			productName: $('#productName_'+prod).text(),
			underwriter: $('#underwriter_'+prod).html(),
			afsLicenceNo: $('#afsLicenceNo_'+prod).html(),
			productInfo: $('#productInfo_'+prod).html(),
			excessTable: $('#excessTable_'+prod).html(),
			conditions: $('#conditions_'+prod).html(),
			feature: $('#feature_'+prod).html().replace("Price shown includes","Includes"),
			pdsA: pdsA,
			pdsB: pdsB,
			disclaimer: $('#disclaimer_'+prod).html()
		};

		var specialConditionsTemplate = $("#special-conditions-template").html();
		var dialogContent = $(parseTemplate(specialConditionsTemplate, data));

		if ( $('#conditions_'+prod).text().length == 0 ){
			dialogContent.find('#pInfoConditionBox').hide();
		}
		if ( $('#feature_'+prod).text().length == 0 ){
			dialogContent.find('#pInfoSpecialOffer').hide();
		}

		$("#prodInfoDialog").html(dialogContent);

		$("#pInfoApplyOnlineButton a").on("click", function(){
			prodInfoDialog.close();
			moreDetailsHandler.init(prod);
			return false;
		});

		prodInfoDialog.open();

	}


</go:script>
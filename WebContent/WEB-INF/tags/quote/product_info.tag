<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
		height: 156px;
		position: absolute;
		z-index: 2000;
		top: 417px;
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
<div id="prodInfoDialog"></div>

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$('#prodInfoDialog').dialog({
		autoOpen: false,
		show: 'clip',
		hide: 'clip', 
		'modal':true, 
		'width':637, 'height':680, 
		'minWidth':637, 'minHeight':680,  
		'autoOpen': false,
		'draggable':false,
		'resizable':false,
		'title':'Product Information',
		close: function(){
			$(".prodInfoDialog").hide();	
   		}
	});		
		
	$('.ui-dialog').append('<div id="productInfoClose" onclick="closeProdInfoDialog()" class="prodInfoDialog"></div><div id="productInfoFooter" class="prodInfoDialog"></div>');

</go:script>
<go:script marker="js-head">

	function product_info(prod) {	
		
		var html = "<div id='pInfoLogo'><img src='common/images/logos/product_info/"+prod+".png' /></div>"+
				   "<div id='pInfoProductName'>"+$('#productName_'+prod).text()+"</div>"+
				   "<div id='pInfoUnderwriter'>Underwriter: "+$('#underwriter_'+prod).html()+"</div>"+
				   "<div id='pInfoAFS'>AFS Licence No: "+$('#afsLicenceNo_'+prod).html()+"</div>"+
				   
				   "<div id='pInformation' class='"+prod+"'>"+
					   "<div id='pInfoSummaryText'>"+$('#productInfo_'+prod).html()+"</div>"+
				   "</div>";

				   if ($("#apply_online_"+prod).css("display") == "block") {
				   		html += "<div id='pInfoApplyOnlineButton' class='" + prod + "_apply_online_button'><a class='smlbtn' href='javascript:applyOnlineToggle(\""+prod+"\")'><span>Continue Online</span></a></div>";
				   }
				   if ($("#apply_by_phone_"+prod).css("display") == "block") {
				   		html += "<div id='pInfoPhoneApplyButton'><a class='smlbtn' href='javascript:applyByPhoneToggle(\""+prod+"\")'><span>Continue by Phone</span></a></div>";
				   }
				   
				   html+="<div id='pInfoRHS'>";
				   
				   html+="<div id='pInfoAdditionalExcesses'><h4>Additional Excesses</h4><div class='excessTable'>"+$('#excessTable_'+prod).html()+"</div></div>";
				   
				   if ($('#conditions_'+prod).text().length>0 ) {
				   		html += "<div id='pInfoConditionBox'><h4>Special Conditions</h4><div class='policyConditionsTable'>"+$('#conditions_'+prod).html()+"</div></div>";
			   	   };
				   		   
					if ($('#feature_'+prod).html().length>0 ) {				   		   
				   		html+="<div id='pInfoSpecialOffer'><h4>Special Feature / Offer</h4><div class='excessTable'>"+$('#feature_'+prod).html().replace("Price shown includes","Includes") +"</div></div>";
				   	};
				   	
				   	html+="</div>" +
				   	
				   
			   
				   "<div id='pInfoDisclaimer'>"+
						"<div id='pDisclosureTitle'>Product Disclosure Statement</div>"+				   
						"<div id='pDisclosureText'>Please read the Product Disclosure Statements before deciding to buy:</div>"+						
				   		"<div id='pInfoPDSA'>" + (( $('#pdsaUrl_'+prod).html().length>0 )?"<a href='javascript:showDoc(\""+$('#pdsaUrl_'+prod).html()+"\")'>" + (( $('#pdsaDesLong_'+prod).html().length>0 )? $('#pdsaDesLong_'+prod).html() : 'Product Disclosure Statement Part A') + "</a>":"") +"</div>"+
				   		"<div id='pInfoPDSB'>" + (( $('#pdsbUrl_'+prod).html().length>0 )?"<a href='javascript:showDoc(\""+$('#pdsbUrl_'+prod).html()+"\")'>" + (( $('#pdsbDesLong_'+prod).html().length>0 )? $('#pdsbDesLong_'+prod).html() : 'Product Disclosure Statement Part B') + "</a>":"") +"</div>"+
						"<div id='pDisclaimerTitle'>Disclaimer</div>"+				   		
						"<div id='pDisclaimerText'>"+$('#disclaimer_'+prod).html()+"</div>"+				   
				   "</div>";

		$('#prodInfoDialog').html(html);
		$('#prodInfoDialog').dialog('open');
		$(".prodInfoDialog").show();	
	}	
		
	function closeProdInfoDialog() {
		$('#prodInfoDialog').dialog('close');
	}

</go:script>					
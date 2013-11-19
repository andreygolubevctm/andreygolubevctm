<%@ tag description="Details for Money Back Guarantee popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
 
<%-- CSS --%>
<go:style marker="css-head">
	#guarantee-popup {
		width:850px;
		height:auto;
		z-index:2001;
		display:none;
		left:50%;
	} 
	#guarantee-popup h5 {
	    background: url("common/images/dialog/header_850.gif") no-repeat scroll 0 0 transparent;
	    display: block;
	    font-size: 17px;
	    font-weight: bold;
	    height: 39px;
	    padding-left: 13px;
	    padding-top: 10px;
	    width: 850px;
	    margin-bottom: -10px;
	    color: white;
	}
	#guarantee-popup h3 {
		margin:10px 0px 10px 10px;
		font-size:14px;
		font-weight:bold;
		color: #0554DF;
	    font-size: 21px;
	    font-weight: bold;
	    display:block;
	}
	#guarantee-popup li {
		font-size:11px;
		line-height:20px;
		margin-bottom:8px;
	}
	#guarantee-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_850.gif") no-repeat;
		width:850px;
		height:47px;
		display:block;
		padding-top:10px;
	}
	#guarantee-popup strong {
		line-height:21px;
	}
	#guarantee-popup .ok-button {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin: 0 auto;
	}
	#guarantee-popup .ok-button:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}
/*	#guarantee-popup .close-button {
	    background: url("common/images/dialog/close.gif") no-repeat scroll 0 0 transparent;
	    height: 12px;
	    left: 824px;
	    position: relative;
	    top: 25px;
	    width: 12px;
	    display: inline-block;
	}*/
	#guarantee-popup .back-button {
	    background: url("common/images/button-prev.png") no-repeat scroll 0 0 transparent;
	    height: 37px;
	    position: relative;
	    width: 140px;
		margin-top:10px;
		margin-right:5px;
	    float:right;
	}
	#guarantee-popup .back-button:hover {
	    background: url("common/images/button-prev-on.png") no-repeat scroll 0 0 transparent;
	}
	#guarantee-popup .content {
		background: white url("common/images/dialog/content_850.gif") repeat-y;
		padding:10px;
		overflow: hidden;
		height:350px; 
	}
	#guarantee-popup .content p {
	    margin-bottom: 9px;
	    font-size: 12px;
	    margin: 10px 10px;
	    line-height:17px;
	}
	#guarantee-popup, #guarantee-popup h5, #guarantee-popup .buttons{width:620px;}
	
	#guarantee-popup h5{
		background: url("common/images/dialog/header_620.gif") no-repeat scroll 0 0 transparent;
	}
	#guarantee-popup .content{
		background: url("common/images/dialog/content_620.gif") repeat-y scroll 0 0 white;
	}
	#guarantee-popup .buttons{
		background: url("common/images/dialog/buttonpane_620.gif") no-repeat scroll 0 0 transparent;
	}
	#guarantee-popup .close-button{
    	left: 590px;
    }
    .guarantee_left{
    	float:left;
    	width:350px;
    }
    .guarantee_right{
	    margin-left:7px;
    	float:left;
    	width:232px;
    }
    .bluetext{color:#0052e8;}
    .termsfont{
   		font-size:10px;
   		line-height:13px;
   		margin:8px;
   }
   .guarantee_right img{margin-top:10px;}
	#guarantee-overlay {
		position:absolute;
		top:0px;
		left:0px;
		z-index:2000;		 
	}
   
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var GuaranteePopup = new Object();
	GuaranteePopup = {	
		
		show: function(){
			
			var guarantee_template = $("#guarantee-template").html();
			$("#guarantee-popup .content").html($(parseTemplate(guarantee_template, '')));
			
			var overlay = $("<div>").attr("id","guarantee-overlay")
									.addClass("ui-widget-overlay")
									.css({	"height":$(document).height() + "px", 
											"width":$(document).width()+"px"
										});
			$("body").append(overlay);
			$(overlay).fadeIn("fast");
			// Show the popup
			$("#guarantee-popup").center().show("slide",{"direction":"down"},300);
					
		}, 
		hide : function(){
			$("#guarantee-popup").hide("slide",{"direction":"down"},300);
			$("#guarantee-overlay").remove();
		}, 
		init : function(){
			$("#guarantee-popup").hide();
		}
	}

	
</go:script>
<go:script marker="jquery-ui">
	$("#guarantee-popup .ok-button, #guarantee-popup .close-button").click(function(){
		GuaranteePopup.hide();
	});
</go:script>
<go:script marker="onready">
	GuaranteePopup.init();
	$('#headerimageforpoctest').click(function(){
		GuaranteePopup.show();		
	});
</go:script>
<%-- HTML --%>
<div id="guarantee-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>Offer Terms</h5>
	
	<div class="content"></div>

	<div class="buttons">
		<div class="ok-button"></div>
	</div>
</div>
<go:style marker="css-head">
	.cleardiv{clear:both;}
</go:style>
<%-- GUARANTEE POPUP ROW TEMPLATE --%>
<core:js_template id="guarantee-template">
	<div>
	
		<div class="guarantee_left">
			<h3>Superhuman Savings with a Money Back Guarantee!</h3>
	
			<p>Relax! All Car Insurance providers listed on Compare the Market provide at least a 14 day full Money Back Guarantee!</p>
			
			<p>In the unlikely event that you find a better product or a cheaper price, you can get all of your money back!*</p>
			
			<p class="bluetext">Found a better price? Get your money back!</p>
			<p class="bluetext">Found a better product? Get your money back!</p>
			
			
			
			<div class="cleardiv"></div>
		</div>
		
		<div class="guarantee_right">
			<img src="common/images/seal_big.png" width="232" height="208"/>
			<div class="cleardiv"></div>
		</div>
		
		<div class="cleardiv"></div>
		
		<div class="termsfont">
			* TERMS &amp; CONDITIONS<br />
			If you cancel the policy within 14 days from the date of purchase and do not make a claim on the policy, your insurer will give you a full refund. Note some insurers products have a 21 day cooling off period. Please see the specific insurers Product Disclosure Statement for full terms and conditions.
			<br />
			<br />1. Check to ensure you're within the 14 day period (14 days from the date you purchased your policy)
			<br />2. Contact your insurance provider directly
			<br />3. Request that they cancel your policy and refund your premium in full (so long as no claim has been made)
			
			<div class="cleardiv"></div>
		</div>

	</div>
</core:js_template>	

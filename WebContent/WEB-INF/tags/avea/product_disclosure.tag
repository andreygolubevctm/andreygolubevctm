<%@ tag description="Product Disclosure Statement"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
 
<%-- CSS --%>
<go:style marker="css-head">
	#product-disclosure-popup {
		width:620px;
		height:auto;
		z-index:2001;
		display:none;
		left:50%;
	} 
	#product-disclosure-popup h5 {
	    background: url("common/images/dialog/header_620.gif") no-repeat scroll 0 0 transparent;
	    display: block;
	    font-size: 17px;
	    font-weight: bold;
	    height: 39px;
	    padding-left: 13px;
	    padding-top: 10px;
	    width: 620px;
	    margin-bottom: -10px;
	    color: white;
	}
	#product-disclosure-popup h3 {
		margin:10px 0px 10px 10px;
		font-size:14px;
		font-weight:bold;
		color: #0554DF;
	    font-size: 21px;
	    font-weight: bold;
	    display:block;
	}
	#product-disclosure-popup li {
		font-size:11px;
		line-height:20px;
		margin-bottom:8px;
	}
	#product-disclosure-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_620.gif") no-repeat;
		width:620px;
		height:47px;
		display:block;
		padding-top:10px;
	}
	#product-disclosure-popup strong {
		line-height:21px;
	}
	#product-disclosure-popup .ok-button {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin: 0 auto;
	}
	#product-disclosure-popup .ok-button:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}
/*	#product-disclosure-popup .close-button {
	    background: url("common/images/dialog/close.gif") no-repeat scroll 0 0 transparent;
	    height: 12px;
	    left: 824px;
	    position: relative;
	    top: 25px;
	    width: 12px;
	    display: inline-block;
	}*/
	#product-disclosure-popup .back-button {
	    background: url("common/images/button-prev.png") no-repeat scroll 0 0 transparent;
	    height: 37px;
	    position: relative;
	    width: 140px;
		margin-top:10px;
		margin-right:5px;
	    float:right;
	}
	#product-disclosure-popup .back-button:hover {
	    background: url("common/images/button-prev-on.png") no-repeat scroll 0 0 transparent;
	}
	#product-disclosure-popup .content {
		background: white url("common/images/dialog/content_620.gif") repeat-y;
		padding:10px;
		overflow: hidden;
		height:350px; 
	}
	#product-disclosure-popup .content p {
	    margin-bottom: 9px;
	    font-size: 12px;
	    margin: 10px 10px;
	    line-height:17px;
	}
	#product-disclosure-popup, #guarantee-popup h5, #guarantee-popup .buttons{width:620px;}
	
	#product-disclosure-popup h5{
		background: url("common/images/dialog/header_620.gif") no-repeat scroll 0 0 transparent;
	}
	#product-disclosure-popup .content{
		background: url("common/images/dialog/content_620.gif") repeat-y scroll 0 0 white;
	}
	#product-disclosure-popup .buttons{
		background: url("common/images/dialog/buttonpane_620.gif") no-repeat scroll 0 0 transparent;
	}
	#product-disclosure-popup .close-button{
    	left: 590px;
    }

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var ProductDisclosurePopup = new Object();
	ProductDisclosurePopup = {	
		
		show: function(){
			
			var disclosure_template = $("#product-disclosure-template").html();
			$("#product-disclosure-popup .content").html($(parseTemplate(disclosure_template, '')));
			
			var overlay = $("<div>").attr("id","product-disclosure-overlay")
									.addClass("ui-widget-overlay")
									.css({	"height":$(document).height() + "px", 
											"width":$(document).width()+"px"
										});
			$("body").append(overlay);
			$(overlay).fadeIn("fast");
			// Show the popup
			$("#product-disclosure-popup").center().show("slide",{"direction":"down"},300);
					
		}, 
		hide : function(){
			$("#product-disclosure-popup").hide("slide",{"direction":"down"},300);
			$("#product-disclosure-overlay").remove();
		}, 
		init : function(){
			$("#product-disclosure-popup").hide();
		}
	}


	
</go:script>
<go:script marker="jquery-ui">
	$("#product-disclosure-popup .ok-button, #product-disclosure-popup .close-button").click(function(){
		ProductDisclosurePopup.hide();
	});
</go:script>
<go:script marker="onready">
	ProductDisclosurePopup.init();
</go:script>
<%-- HTML --%>
<div id="product-disclosure-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>Product Disclosure Statement</h5>
	
	<div class="content"></div>

	<div class="buttons">
		<a class="ok-button"></a>
	</div>
</div>

<%-- DISCLOSURE POPUP ROW TEMPLATE --%>
<core:js_template id="product-disclosure-template">
	<div>
	
		Product Disclosure Statement content

	</div>
</core:js_template>	

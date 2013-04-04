<%@ tag description="Terms and conditions popup for results page"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- CSS --%>
<go:style marker="css-head">
	#terms-popup {
		width:450px;
		height:auto;
		z-index:2001;
		display: none;
	}
	#terms-popup h5 {
	    background: url("common/images/dialog/header_450.gif") no-repeat scroll 0 0 transparent;
	    display: block;
	    height: 64px;
	    padding-left: 13px;
	    padding-top: 16px;
	    width: 450px;
	    margin-bottom: -10px;
	    font-family: "SunLT Light","Open Sans",Helvetica,Arial,sans-serif;
	    font-size: 22px;
	    font-weight: 300;
    }
	#terms-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_450.gif") no-repeat;
		width:450px;
		height:57px;
		display:block;
	}
/*	#terms-popup .buttons a {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin-left:200px;
		margin-top: 10px;
		display:inline-block;
	}
	#terms-popup .buttons a:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}
	*/
	#terms-popup .close-button {
	    left: 424px;
	}
	#terms-popup .content {
		background: white url("common/images/dialog/content_450.gif") repeat-y;
		padding:10px;
		overflow:none;
		height:auto; 
	}
	#terms-popup .content p {
	    margin-bottom: 9px;
	    font-size: 11px;
	    margin: 10px 10px;
	}	
	#terms-overlay {
		position:absolute;
		top:0px;
		left:0px;
		z-index:1000;		 
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var Terms = new Object();
Terms = {
	_origZ : 0,
	
	show: function(id, priceType){
		var res = Results.getResult(id);
		var terms=false;
		if (res){
			// No price type specified, default to headlineOffer
			if (!priceType){
				priceType = res.headlineOffer;
			}
		
			if (priceType == "OFFLINE") {
				terms = res.offlinePrice.terms;
			} else {
				terms = res.onlinePrice.terms;
			}
		}
		if (terms) {
			$("#terms-popup .content").html(terms);
			
			// If we're not already showing an overlay .. create one.
			if (!$(".ui-widget-overlay").is(":visible")) {
				var overlay = $("<div>").attr("id","terms-overlay")
										.addClass("ui-widget-overlay")
										.css({	"height":$(document).height() + "px", 
												"width":$(document).width()+"px"
										}).on("click", function(){
											Terms.hide(); 
								        	$('body').find('.ui-dialog div').not(':hidden').dialog('close');
								        	$(this).unbind("click");
								        });
											
				$("body").append(overlay);
				$(overlay).fadeIn("fast");
				
			// Otherwise just mess with the existing overlay's z-index				
			} else {
				this._origZ = $(".ui-widget-overlay:visible").css("z-index");
				$(".ui-widget-overlay").css("z-index","2000");
			}

			// Show the popup			
			$("#terms-popup").center().show("slide",{"direction":"down"},300);
		}
		Track.offerTerms(id);
	}, 
	hide : function(){
		$("#terms-popup").hide("slide",{"direction":"down"},300);
		
		// Did we add a specific overlay? if so remove.  		
		if ($("#terms-overlay").length) {
			$("#terms-overlay").remove();
		} else if (this._origZ > 0) {
			$(".ui-widget-overlay").css("z-index",this._origZ);
		}
	}, 
	init : function(){
		$("#terms-popup").hide();
	}
}
</go:script>
<go:script marker="jquery-ui">
	$("#terms-popup .ok-button, #terms-popup .close-button").click(function(){
		Terms.hide();
	});
</go:script>
<go:script marker="onready">
	Terms.init();
	
	<%-- Hide: Closes ALL of the Terms Boxes and open-Ui Dialogs --%>
	/*
	$('body').on('click','.ui-widget-overlay',function(ev){
	   Terms.hide(); 
	   $('body').find('.ui-dialog div').not(':hidden').dialog('close');
	});
	*/
</go:script>
<%-- HTML --%>
<div id="terms-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5 class="ui-dialog-title">Offer Terms</h5>
	
	<div class="content"></div>
	
	<div class="buttons">
		<a href="javascript:void(0)" class="ok-button"><span>OK</span></a>
	</div>
</div>

<%@ tag description="PromoTerms and conditions popup for results page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-head">
	#terms-popup {
		width:850px;
		height:auto;
		z-index:2001;
		display: none;
	}
	#terms-popup h5 {
		background: url("common/images/dialog/header_850.gif") no-repeat scroll 0 0 transparent;
		display: block;
		height: 70px;
		padding-left: 13px;
		padding-top: 10px;
		width: 850px;
		margin-bottom: -10px;
	}
	#terms-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_850.gif") no-repeat;
		width:850px;
		height:57px;
		display:block;
	}
/*	#terms-popup .buttons a {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin-left:400px;
		margin-top: 10px;
		display:inline-block;
	}
	#terms-popup .buttons a:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}*/

/*	#terms-popup .close-button {
		background: url("common/images/dialog/close.gif") no-repeat scroll 0 0 transparent;
		height: 12px;
		left: 824px;
		position: relative;
		top: 25px;
		width: 12px;
		display: inline-block;
	}*/
	#terms-popup .content {
		background: white url("common/images/dialog/content_850.gif") repeat-y;
		padding:10px;
		overflow: hidden;
		height:400px;
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
	#termsScrollDiv {
		height: 355px;
		overflow-y: scroll;
		width:836px;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var PromoTerms = new Object();
	PromoTerms = {
		show: function(){

				$.ajax({
					url : "ajax/html/comp_terms.jsp",
					async: false,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success : function(data){
						$("#terms-popup .content").html(data);

							var overlay = $("<div>").attr("id","terms-overlay")
													.addClass("ui-widget-overlay")
													.css({	"height":$(document).height() + "px",
															"width":$(document).width()+"px"
														});
							$("body").append(overlay);
							$(overlay).fadeIn("fast");
							// Show the popup
							$("#terms-popup").center().show("slide",{"direction":"down"},300);
					}
				});
		},
		hide : function(){
			$("#terms-popup").hide("slide",{"direction":"down"},300);
			$("#terms-overlay").remove();
		},
		init : function(){
			$("#terms-popup").hide();
		}
	}
</go:script>
<go:script marker="jquery-ui">
	$("#terms-popup .ok-button, #terms-popup .close-button").click(function(){
		PromoTerms.hide();
	});
</go:script>
<go:script marker="onready">
	PromoTerms.init();
</go:script>
<%-- HTML --%>
<div id="terms-popup">
	<a href="javascript:void(0);" class="close-button"></a>

	<h5>Terms &amp; Conditions</h5>

	<div class="content"></div>

	<div class="buttons">
		<a href="javascript:void(0);" class="ok-button"></a>
	</div>
</div>

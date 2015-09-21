<%@ tag description="transferring Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<!-- CSS -->
<go:style marker="css-head">
	#transferring-overlay {
		z-index:10000;
		display:none;
	}
	#transferring-popup {
		background: transparent url('brand/ctm/images/loading_ctm.png') no-repeat top left;
		width:500px;
		height:300px;
		z-index:10010;
		display:none;
		*position: absolute;
		*left: 35%;
		*top: 30%;
	}
	#transferring-popup div {
		width:400px;
		height:250px;
		margin: 27px 24px;
	}
	#transferring-popup span {
		display:inline-block;
	}
	#transferring-message {
		position: absolute;
		top: 25px;
		left: 27px;
		font-size: 19px;
		width: 480px;
		color: #333333;
		font-weight: bold;
		line-height:23px;
	}
	#transferring-brand {
		color: black;
		font-size: 28px;
		font-weight: bold;
		font-style: italic;
		text-align: center;
		padding-top: 15px;
	}
	#transferring-anim {
		background: url("common/images/loading.gif") no-repeat scroll left top transparent;
		height: 49px;
		width: 452px;
		top: 185px;
		position: absolute;
	}
</go:style>

<!-- JAVASCRIPT -->
<go:script marker="js-head">
var Transferring = new Object();
Transferring = {
	popup : false,
	show : function(brand, msg) {
		$("#transferring-overlay").css({	"height":$(document).height() + "px",
									"width":$(document).width()+"px"
									});
		//$("#transferring-brand").html(brand);
		$("#transferring-popup").center();
		if ($.browser.msie) {
			$("#transferring-overlay").css('filter', 'alpha(opacity=50)');
		}
		//$("#transferring-message").html(msg);
		$("#transferring-overlay").fadeIn("fast");
		$("#transferring-popup").fadeIn("fast");
	},
	hide : function(){
		if ($.browser.msie) {
			$("#transferring-popup").hide();
		} else {
			$("#transferring-popup").fadeOut("fast");
		}
		$("#transferring-overlay").fadeOut();
	}
}
</go:script>

<!-- HTML -->
<div id="transferring-overlay" class="ui-widget-overlay"></div>
<div id="transferring-popup">
	<div>
		<span id="transferring-message">Transferring</span>
		<%-- <span id="transferring-brand"></span> --%>
		<span id="transferring-anim"></span>
	</div>
</div>


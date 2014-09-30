<%@ tag description="Loading Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="hidePowering" required="false"	 rtexprvalue="true"	 description="Always Hide the PoweringUp - even for IE7?" %>

<c:set var="IE7display">
	<c:choose>
		<c:when test="hidePowering==true">none</c:when>
		<c:otherwise>block</c:otherwise>
	</c:choose>
</c:set>

<!-- CSS -->
<go:style marker="css-head">
	#loading-overlay {
		z-index:10000;
		display:none;
		*display:${IE7display};
	}

	#loading-popup {
		width:500px;
		height:300px;
		z-index:10010;
		display:none;
		*display:block;
		*position: absolute;
		*left: 35%;
		*top: 30%;
	}
	#loading-popup div {
		width:400px;
		height:250px;
		margin: 27px 24px
	}
	#loading-popup span {
		display:inline-block;
	}
	#loading-anim {
	    background: url("common/images/loading.gif") no-repeat scroll left top transparent;
	    height: 49px;
	    width: 452px;
		top: 185px;
	    position: absolute;
	}
	#loading-message {
		position: absolute;
		top: 25px;
		left: 27px;
		font-size: 19px;
		width: 480px;
		color: #4a4f51;
		font-weight: bold;
		line-height:23px;
	}
</go:style>

<!-- JAVASCRIPT -->
<go:script marker="js-head">
var Loading = new Object();
Loading = {
	_defaultMessage : "Please Wait...",

	show : function(message, callback) {

		message = message || Loading._defaultMessage;
		callback = callback || false;

		$("#loading-overlay").css({	"height":$(document).height() + "px",
									"width":$(document).width()+"px"
									});

		$("#loading-message").html(message);

		$("#loading-popup").center();

		if ($.browser.msie) {
			$("#loading-overlay").css('filter', 'alpha(opacity=50)');
		}

		$("#loading-overlay").fadeIn("fast", function() {
			$("#loading-popup").fadeIn("fast", function() {
				$("#loading-popup").center();
				Loading.actionCallback( callback );
			});
		});
	},

	hide : function( callback ){

		callback = callback || false;

		if ($.browser.msie) {
			$("#loading-popup").hide("fast", function(){
				$("#loading-overlay").fadeOut("fast", function(){
					Loading.actionCallback( callback );
					$("#loading-overlay, #loading-popup").hide();
				});
			});
		} else {
			$("#loading-popup").fadeOut("fast", function(){
				$("#loading-overlay").fadeOut("fast", function(){
					Loading.actionCallback( callback );
					$("#loading-overlay, #loading-popup").hide();
				});
			});
		}
	},

	actionCallback : function( callback ) {
		if( typeof callback == "function" ) {
			callback();
		}
	}
}

</go:script>

<go:script marker="onready">
	Loading.hide();
	$('<img/>')[0].src = "common/images/loading.gif"; //preload this image
</go:script>

<!-- HTML -->
<div id="loading-overlay" class="ui-widget-overlay"></div>
<div id="loading-popup">
	<div>
		<span id="loading-anim"></span>
		<span id="loading-message"></span>
	</div>
</div>


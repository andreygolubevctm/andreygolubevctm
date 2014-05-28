<%@ tag description="Error Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="errorMessage" required="true" rtexprvalue="true" description="error message" %>

<!-- CSS -->
<go:style marker="css-head">
	#error-popup {
		background: transparent url('common/images/error_bg.png') no-repeat top left;
		width:500px;
		height:500px;
		z-index:1010;
		display:none;
		*position: absolute;
		*left: 35%;
		*top: 30%;
	}
	#error-popup div {
		background: transparent url('common/images/error_cc.jpg') no-repeat top left;
		width:390px;
		height:418px;
		margin: 30px 30px
	}
	#error-popup span {
		display:block;
	}
	#error-message {
		color: #999999;
		font-size: 18px;
		font-weight: bold;
		text-align: center;
		padding-top: 27px;
	}
	#error-button-options {
		height: 28px;
		margin-top: 25px;
	}
	#exit_quote_button {
		left: 260px;
		position: absolute;
		
	}
	#new_quote_button {
		left: 60px;
		position: absolute;
	}
</go:style>

<!-- JAVASCRIPT -->
<go:script marker="js-head">
	var Error = new Object();
	Error = {
		popup : false,
		show : function(message) {
			$("#error-overlay").css({
				"height":$(document).height() + "px", 
				"width":$(document).width()+"px"
			});
			
			$("#error-message").html(message);
			
			$("#error-popup").center();
			
			if ($.browser.msie) {
				$("#error-overlay").css('filter', 'alpha(opacity=50)');
			}
			$("#error-overlay").fadeIn("fast");
			$("#error-popup").fadeIn("fast");
		},
		hide : function(){
			if ($.browser.msie) {
				$("#error-popup").hide();
			} else {
				$("#error-popup").fadeOut("fast");
			}
			$("#error-overlay").fadeOut();
		}
	}
</go:script>

<go:script marker="onready">
	Error.show(${errorMessage});
</go:script>

<!-- HTML -->

<div id="error-popup">
	<div>
		<span id="error-message">Oops...</span>
		<span id="error-button-options">
			<span id="new_quote_button"><a href="${pageSettings.getSetting('quoteUrl')}" title="New Quote"><img src="common/images/navigation-new-quote.gif" border="0"></img></a></span>		
			<span id="exit_quote_button"><a href="${pageSettings.getRootUrl()}" title="Exit Quote"><img src="common/images/navigation-exit-quote.gif" border="0"></img></a></span>
			
		</span>
	</div>
</div>


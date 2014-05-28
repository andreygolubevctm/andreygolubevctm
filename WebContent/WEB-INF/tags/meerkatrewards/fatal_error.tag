<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- HTML --%>
<div id="fatal_error_panel">
	<table class="content innertube"><tr><td>My site is experiencing technical difficulties, please try again later...</td></tr></table>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var FatalErrorObj = function() {

	this.fire = function(errors) {
		var response = errors;
		<%-- try {
			var temp = jQuery.parseJSON(errors);
			response = temp;
		} catch(e) { /* IGNORE */ } --%>

		send({
			message:		"Failed to add competition entry",
			page:			"meerkat_rewards.jsp",
			description:	"Failed to add competition entry",
			data:			response
		});
	};

	var send = function( data ) {
		$.ajax({
			url: "ajax/write/register_fatal_error.jsp",
			data: data,
			type: "POST",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				// Nothing to do here
				return false;
			},
			error: function(obj,txt){
				// Nothing to do here
				return false;
			}
		});
	};
}

var fatal_error_obj = new FatalErrorObj();
</go:script>

<%-- STYLE --%>
<go:style marker="css-head">
#fatal_error_panel {
	width:				100%;
	height:				100%;
	background:			#CFB955 url(brand/ctm/competition/meerkat_rewards/img/wrongAnswerBg.jpg) -60px -150px no-repeat;
	margin:				0 auto;
}

#fatal_error_panel .content {
	float:				right;
	width:				200px;
	height:				175px;
	background:			#CFB955;
	background:			transparent;
	border:				none;
}

#fatal_error_panel .content td {
	text-align:			center;
	vertical-align:		middle;
	color:				#52011C;
	font-family:		"Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif;
	font-weight:		bold;
	font-size:			1em;
}
</go:style>
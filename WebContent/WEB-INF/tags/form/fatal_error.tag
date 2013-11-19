<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Lightbox dialog for fatal problems e.g. ajax fail"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="property" required="false" description="Optional window title suffix"%>
<%@ attribute name="custom" required="false" rtexprvalue="true" description="Custom message to replace any technical messages." %>

<c:if test="${empty property}">
	<c:set var="property" value="CTM" />
</c:if>

<%-- HTML --%>
<div id="fatal-error-dialog" class="fatal-error-dialog">
	<div class="dialog_header"></div>
	<div class="wrapper">
		<table><tr><td><!-- content added here --></td></tr></table>
	</div>
	<div class="dialog_footer"></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">
#fatal-error-dialog {
	min-width:				350px;
	max-width:				350px;
	width:					350px;
	display: 				none;
	overflow:				hidden;
}
#fatal-error-dialog .clear{clear:both;}

#fatal-error-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/error_fatal/footer.gif?v5") no-repeat scroll left top transparent;
	width: 					350px;
	height: 				10px;
	clear: 					both;
}

#fatal-error-dialog .dialog_header {
	position:				absolute;
	left:					0;
	top:					0;
	background: 			url("common/images/error_fatal/header_under.gif?v5") no-repeat scroll left top transparent;
	width: 					350px;
	height: 				10px;
	clear: 					both;
}

.ui-dialog.fatal-error-dialog .ui-dialog-titlebar {
	padding: 				0 !important;
	height: 				30px !important;
}

.ui-dialog.fatal-error-dialog .ui-dialog-titlebar .ui-dialog-title {
	font-size:				12pt;
	color:					#F46C00;
	font-weight:			900;
	margin:					0.65em 16px 0.1em 0.5em !important;
	padding-left:			25px;
	background:				transparent url("common/images/error_fatal/warning.png?v5") center left no-repeat;
}

.ui-dialog.fatal-error-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					17px;
	right: 					5px;
}
.ui-dialog.fatal-error-dialog .message-form, .ui-dialog #fatal-error-dialog{
	padding:				0;
}

.fatal-error-dialog .ui-dialog-titlebar {
	background-image:		url("common/images/error_fatal/header_over.gif?v5") !important;
	height:					34px;
	-moz-border-radius-bottomright: 0;
	-webkit-border-bottom-right-radius: 0;
	-khtml-border-bottom-right-radius: 0;
	border-bottom-right-radius: 0;
	-moz-border-radius-bottomleft: 0;
	-webkit-border-bottom-left-radius: 0;
	-khtml-border-bottom-left-radius: 0;
	border-bottom-left-radius: 0;
}

.fatal-error-dialog .ui-dialog-titlebar-close.ui-state-hover { border-color: #F46C00; background-color: #F46C00; }

.fatal-error-dialog .ui-dialog-content {
	background-image:		url("common/images/error_fatal/content.gif?v5") !important;
}

.fatal-error-dialog .ui-dialog-content .wrapper {
	padding:					12px 15px 15px 15px;
}

.fatal-error-dialog .ui-dialog-content .wrapper table td {
	width:						100%;
	height:						70px;
	vertical-align:				middle;
	font-size:					10pt;
}
	
#fatal-error-dialog .wrapper .ok > a {
    display:					block;
    width:						150px;
    height:						33px;
    cursor:						pointer;
	margin:						0 auto 0 auto;
	padding:					0 0 5px 0;
    text-decoration: 			none;
	background:					transparent url("brand/ctm/images/button_bg.png?v5") top left no-repeat;
}

#fatal-error-dialog .wrapper .ok > a span {
    display: 					block;
	font-size:					11.25pt;
	font-weight:				bold;
	height: 					100%;
    width: 						100%;
    line-height: 				33px;
    margin:						0;
    padding:					0;
    text-align: 				center;
   	color: 						#ffffff;
	background: 				transparent url("brand/ctm/images/button_bg_right.png?v5") top right no-repeat;
	text-shadow: 				0px 1px 1px rgba(0,0,0,0.5);
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var FatalErrorDialog = {

	_initialised : false,
	_elements : {},

	init: function() {
	
		<%-- Initialise the search quotes dialog box --%>
		$('#fatal-error-dialog').dialog({
			autoOpen: false,
			show: {
				effect: 'clip',
				complete: function(){
					$('.ui-dialog.fatal-error-dialog').center();
				}
			},
			hide: 'clip', 
			'modal':true, 
			'width':350, 
			'minWidth':350,  
			'minHeight':70,
			'autoOpen': false,
			'draggable':true,
			'resizable':false,
			'dialogClass':'fatal-error-dialog',
			'title':'Oops... something has gone wrong.',
			open: function() {
				FatalErrorDialog.show();
				$('.ui-widget-overlay').on('click.fatal', function () { $('#fatal-error-dialog').dialog('close'); });
			},
			close: function() {
				$('.ui-widget-overlay').off('click.fatal');
				FatalErrorDialog.hide();
			}
		});
		
		FatalErrorDialog._elements = {
			content : $('#fatal-error-dialog .wrapper').find("td").first()
		}
	},
	
	getParams : function( params ) {
		return	$.extend({
			silent:			false,
			message:		"A fatal error has occurred.",
			page:			"undefined.jsp",
			description:	null,
			data:			null,
			callback:		null,
			property:		"${property}"
		}, params);
	},
	
	exec: function( params ) {
		
		params = params || {};
		params =		FatalErrorDialog.getParams(params);
		
		if( typeof params.callback == "function" ) {
			FatalErrorDialog._callback = params.callback;
		} else {
			FatalErrorDialog._callback = null;
		}
		
		FatalErrorDialog.register( params );
		
		if( params.silent !== true ) {
		FatalErrorDialog.display( params.message, params );
		}

		write_quote_ajax.write({triggeredsave:'fatalerror', triggeredsavereason:params.description});
	},
	
	display: function( message, data ) {
		data = data || {};
		
		if( !FatalErrorDialog._initialised ) {
			FatalErrorDialog.init();
		}
		
		<%-- Override the error message with a custom (friendly) one unless in Simples --%>
		<c:if test="${!empty custom && empty callCentre}">
			message = '<p class="custom">${fn:replace(custom, "'", "\\'")}</p>';
		</c:if>
		
		try {
			FatalErrorDialog._elements.content.fadeOut("fast", function(){
				FatalErrorDialog._elements.content.empty().append(message).fadeIn("fast");
				$('#fatal-error-dialog').dialog("open");
			});
		} catch(e) {
			alert(message);
			<%-- IGNORE - Silence is bliss --%>
		}
	},
	
	hide: function() {
		FatalErrorDialog._elements.content.fadeOut("fast", function(){
			FatalErrorDialog._elements.content.empty();
			if( typeof FatalErrorDialog._callback == "function" ) {
				FatalErrorDialog._callback();
			}
		});
	},

	show: function() {	
		FatalErrorDialog._elements.content.fadeIn("fast");
	},
	
	register: function( params ) {
		try{
			params = 		params || {};
			params =		FatalErrorDialog.getParams(params);
			params.data = 	JSON.stringify(params.data, null, 0);
			
			$.ajax({
				url: "ajax/write/register_fatal_error.jsp",
				data: params,
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
					<%--  Nothing to do here --%>
					return false;
				},
				error: function(obj,txt){
					<%--  Nothing to do here --%>
					return false;
				}
			});
		} catch(e) {
			<%-- IGNORE - Silence is bliss --%>
		}
	},
	
	test : function() {
	
		FatalErrorDialog.exec({
			silent: true,
			message: "This is a test message for the Fatal Error Dialog panel.",
			description: "FatalErrorDialog.test()",
			page: "car_quote.jsp",
			data: {
				variable1: true,
				variable2: false,
				variable3: "maybe",
				variable4: [9,8,7,6,5,4,3,2,1],
				variable5: {
					test1: 456.3,
					test2: false,
					test3: "something",
					test4: {
						wt: true
					}
				}
			}
		});
	}
};

var NonFatalError = {

	exec: function( params ) {

		params = params || {};
		params =		FatalErrorDialog.getParams(params);

		NonFatalError.register( params );
	},
	getParams : function( params ) {
		return	$.extend({
			message:		"A fatal error has occurred.",
			page:			"undefined.jsp",
			code:			"Unknown",
			property:		"${property}"
		}, params);
	},
	register: function( params ) {
		try{
			params = 		params || {};
			params =		NonFatalError.getParams(params);
			params.data = 	JSON.stringify(params.data, null, 0);

			$.ajax({
				url: "ajax/write/register_non_fatal_error.jsp",
				data: params,
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
					<%-- Nothing to do here --%>
					return false;
				},
				error: function(obj,txt){
					<%-- Nothing to do here --%>
					return false;
				}
			});
		} catch(e) {
			<%-- IGNORE - Silence is bliss --%>
		}
	}
}
</go:script>
<go:script marker="onready">
FatalErrorDialog.init();
</go:script>
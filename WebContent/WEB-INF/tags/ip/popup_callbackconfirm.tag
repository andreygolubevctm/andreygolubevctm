<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="callbackconfirm-dialog" class="callbackconfirm-dialog" title="Callback Confirmation">
	<div class="dialog_header"><!-- empty --></div>
	<div class="wrapper">
		<h4>Before we can call you we need your consent:</h4>
	
		<form:row label="Your phone number">
			<field:contact_telno xpath="${xpath}/confirmContactNumber" required="false" title="your phone number"  />
		</form:row>
		
		<form:row label="Is it ok for us to call you">
			<field:array_radio items="Y=Yes,N=No" id="ip_confirmCall" xpath="${xpath}/confirmCall" title="can we call you" required="false" className="" />				
		</form:row>
		
		<div class="button-wrapper">
			<a href="javascript:void(0);" class="button proceed"><span>Proceed</span></a>
			<a href="javascript:void(0);" class="button close"><span>Cancel</span></a>
		</div>
	</div>
	<div class="dialog_footer"><!-- empty --></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">

#callbackconfirm-dialog {
	min-width:				540px;
	max-width:				540px;
	width:					540px;
	display: 				none;
	overflow:				hidden;
	padding:				0 !important;
}

#callbackconfirm-dialog a {
	font-size:100%;
}

#callbackconfirm-dialog .clear{clear:both;}

#callbackconfirm-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_540.gif") no-repeat scroll left top transparent;
	width: 					540px;
	height: 				10px;
	clear: 					both;
}

#callbackconfirm-dialog .dialog_header {
	position:				absolute;
	left:					0;
	top:					0;
	background: 			url("brand/ctm/images/ui-dialog-header_540_under.gif") no-repeat scroll left bottom transparent;
	width: 					540px;
	height: 				10px;
	clear: 					both;
}

.ui-dialog.callbackconfirm-dialog .ui-dialog-titlebar {
	padding: 				0 !important;
	height: 				25px !important;
}

.ui-dialog.callbackconfirm-dialog .ui-dialog-titlebar .ui-dialog-title {
	display: 				none !important;
}

.ui-dialog.callbackconfirm-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					15px !important;
	right: 					1em;
}

.callbackconfirm-dialog .ui-dialog-titlebar {
	background-image:		url("brand/ctm/images/ui-dialog-header_540_over.gif") !important;
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

.callbackconfirm-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_540.png") !important;
}

.callbackconfirm-dialog .ui-dialog-content .wrapper {
	padding:					15px 20px;
}

.callbackconfirm-dialog .ui-dialog-content .wrapper h4 {
	margin:						15px 0;
	text-align:					center;
}

.callbackconfirm-dialog .ui-dialog-content .wrapper .button-wrapper {
	height: 					37px;
	margin:						0 100px 10px 0;
}

.callbackconfirm-dialog .ui-dialog-content .wrapper a.button {
	display: 					none;
	width: 						110px;
	height: 					37px;
	position: 					relative;
	float: 						right;
	background: 				transparent url('common/images/button_bg.png') left top no-repeat;
	margin: 					8px 0 8px 10px;
	text-decoration: 			none;
}

.callbackconfirm-dialog .ui-dialog-content .wrapper a.button span {
	display: 					block;
	padding: 					9px 10px 10px 0;
	color: 						white;
	font-size: 					15px;
	text-shadow: 				0px 1px 1px rgba(0, 0, 0, 0.5);
	font-weight: 				600;
	background:		 			transparent url('common/images/button_bg_right.png') right top no-repeat;
	margin-left: 				10px;
	text-align: 				center;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var CallbackConfirmDialog = new Object();
CallbackConfirmDialog = {
	
	_initialised: false,
	_callback : null,

	init: function() {
	
		if( !CallbackConfirmDialog._initialised )
		{
			// Initialise the search quotes dialog box
			// =======================================
			$('#callbackconfirm-dialog').dialog({
				autoOpen: false,
				show: 'clip',
				hide: 'clip', 
				'modal':true, 
				'width':540, 
				'minWidth':540,  
				'autoOpen': false,
				'draggable':false,
				'resizable':false,
				'dialogClass':'callbackconfirm-dialog',
				'title':'Confirm Contact.',
				open: function() {
					CallbackConfirmDialog.show(); 
				},
				close: function(){
					CallbackConfirmDialog.hide();	
			  	}
			});	
			
			CallbackConfirmDialog._initialised = true;
		}
	},
	
	launch: function( callback )
	{
		CallbackConfirmDialog.init();
		
		if( typeof callback == "function" ) {
			CallbackConfirmDialog._callback = callback;
		}
		$("#ip_confirmContactNumber").val( $("#ip_contactDetails_contactNumber").val() );
		$("#ip_confirmCall_N").prop("checked",true);
		$("#ip_confirmCall").buttonset();
		$("#ip_confirmCall").button("refresh");
		$("#callbackconfirm-dialog").find(".button").hide();
		$('#callbackconfirm-dialog').dialog("open");
	},
	
	hide: function() {
		$("#callbackconfirm-dialog").hide("fast", CallbackConfirmDialog._close_callback);
	},

	show: function() {

		$("#callbackconfirm-dialog").find(".proceed").first().hide();
		$("#callbackconfirm-dialog").find(".proceed").first().unbind("click");
		$("#callbackconfirm-dialog").find(".close").first().show();
		$("#callbackconfirm-dialog").find(".close").first().unbind("click");
		$("#callbackconfirm-dialog").find(".close").first().on("click", function(event){
			CallbackConfirmDialog.close();
		});
		$("#callbackconfirm-dialog-close").unbind("click");
		$("#callbackconfirm-dialog-close").on("click", function(){
			event.stopPropagation();
			CallbackConfirmDialog.close();
		});
		$("input[name=ip_confirmCall]").unbind("change");
		$("input[name=ip_confirmCall]").on("change", function(){
			CallbackConfirmDialog.toggleProceedButton();
		});
		$("#callbackconfirm-dialog").show();
	},
	
	close: function( callback ) {
		if( typeof callback == "function" )
		{
			CallbackConfirmDialog._close_callback = callback;
		}
		$("#callbackconfirm-dialog").dialog("close");
	},
	
	toggleProceedButton: function() {
		if( $("input[name=ip_confirmCall]:checked").val() == "Y" ) {
			$("#callbackconfirm-dialog").find(".proceed").first().unbind("click");
			$("#callbackconfirm-dialog").find(".proceed").first().on("click", function(){
				$("#life_contactDetails_call_N").prop("checked",false);
				$("#life_contactDetails_call_Y").prop("checked",true);
				$("#life_contactDetails_call").buttonset();
				$("#life_contactDetails_call").button("refresh");
				CallbackConfirmDialog.close();
				if( typeof CallbackConfirmDialog._callback == "function" ) {
					CallbackConfirmDialog._callback();
				}
			});
			$("#callbackconfirm-dialog").find(".proceed").first().show();
		}
		else
		{
			$("#callbackconfirm-dialog").find(".proceed").first().unbind("click");
			$("#callbackconfirm-dialog").find(".proceed").first().hide();
		}
	}
};
</go:script>
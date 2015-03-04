<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="life_link">
	<c:choose>
		<c:when test="${name eq 'life'}">life-insurance</c:when>
		<c:otherwise>income-protection</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div id="callbackconfirm-dialog" class="callbackconfirm-dialog" title="Callback Confirmation">
	<form:form action="ip_quote_results.jsp" method="POST" id="callBackConfirmationForm" name="callBackConfirmationForm">
		<div class="dialog_header"><!-- empty --></div>
		<div class="wrapper">
			<h4>Before we can call you we need your consent:</h4>

			<form:row label="Your phone number">
				<field:contact_telno
						xpath="${xpath}/confirmContactNumber"
						required="true"
						title="your phone number"
						className="inlineValidation" />
			</form:row>

			<c:if test="${empty callCentre}">
				<div class="${xpath}_contactDetails_callHelp">Phone number must be either a mobile phone<br/>or a landline number (including area code)</div>
				<div class="clear"><!-- empty --></div>
				<div class="${xpath}_contactDetails_callConfirm">I understand comparethemarket.com.au compares life insurance policies from a range of <a href="http://www.comparethemarket.com.au/${life_link}/#tab_nav_1610_0" target="_blank">participating suppliers</a>. By entering my telephone number I agree that Lifebroker or Auto &amp; General Services, Compare the Market&#39;s trusted life partners may contact me to further assist with my life insurance needs</div>
			</c:if>

			<field:hidden xpath="${xpath}/confirmCall" />

			<div class="button-wrapper">
				<a href="javascript:void(0);" class="button proceed"><span>Proceed</span></a>
				<a href="javascript:void(0);" class="button close"><span>Cancel</span></a>
			</div>
		</div>
		<div class="dialog_footer"><!-- empty --></div>
	</form:form>
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
	display:					block;

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

.callbackconfirm-dialog .${xpath}_contactDetails_callConfirm {
	margin:						0 75px;
	font-size:					90%;
}

.callbackconfirm-dialog #${xpath}_confirmContactNumber {
	width:						158px !important;
}

.callbackconfirm-dialog .${xpath}_contactDetails_callHelp {
	float:						right;
	width:						250px;
	color:						#808080;
	margin:						0 106px 10px 0 !important;
	padding:					0 !important;
	font-size:					80%;
	text-align:					right;
	font-style:					italic;
	line-height:				12px !important;
}

.callbackconfirm-dialog .${xpath}_contactDetails_callHelp.error {
	color:						#EB5300;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var CallbackConfirmDialog = new Object();
CallbackConfirmDialog = {

	_initialised: false,
	_callback : null,
	_confirmCallElement : null,
	_confirmContactNumberElement : null,
	_confirmContactNumberElementInput  : null,

	init: function() {
		CallbackConfirmDialog._confirmCallElement = $('#${name}_confirmCall');
		CallbackConfirmDialog._confirmContactNumberElement = $("#${name}_confirmContactNumber");
		CallbackConfirmDialog._confirmContactNumberElementInput = $("#${name}_confirmContactNumberinput");

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
		CallbackConfirmDialog._confirmContactNumberElement.val( $("#${xpath}_contactDetails_contactNumber").val() );
		CallbackConfirmDialog._confirmContactNumberElementInput.val( $("#${xpath}_contactDetails_contactNumberinput").val() );
		CallbackConfirmDialog._confirmCallElement.val("N");
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

		CallbackConfirmDialog._confirmContactNumberElementInput.on('focus', function(e){
			$(this).removeClass("error");
			$('.${xpath}_contactDetails_callHelp').removeClass('error');
		});

		CallbackConfirmDialog._confirmContactNumberElementInput.unbind('blur');
		CallbackConfirmDialog._confirmContactNumberElementInput.on('update keypress blur', function(e) {
			var valid = true;
			var strippedValue = $(this).val().replace(/[^0-9]+/g, '');

			var confirmCall = "Y";

			if (strippedValue == "" || strippedValue == "0000000000") {
				CallbackConfirmDialog._confirmContactNumberElement.val("");
				$(this).val("");
				confirmCall = 'N';
			} else {
				CallbackConfirmDialog._confirmContactNumberElement.val(strippedValue);
				valid = $(this).valid();
				if(!valid) {
					CallbackConfirmDialog._confirmContactNumberElement.val("");
					confirmCall = 'N';
				}
			}
			CallbackConfirmDialog._confirmCallElement.val(confirmCall);
			CallbackConfirmDialog.toggleProceedButton();
			if(!valid ) {
				$('.${xpath}_contactDetails_callHelp').addClass('error');
			} else {
				$('.${xpath}_contactDetails_callHelp').removeClass('error');
			}

		});

		$("#callbackconfirm-dialog").show();
		CallbackConfirmDialog._confirmContactNumberElementInput.blur().focus();
	},

	close: function( callback ) {
		if( typeof callback == "function" )
		{
			CallbackConfirmDialog._close_callback = callback;
		}
		$("#callbackconfirm-dialog").dialog("close");
	},

	toggleProceedButton: function() {
		if( CallbackConfirmDialog._confirmCallElement.val() == "Y" ) {
			$("#callbackconfirm-dialog").find(".proceed").first().unbind("click");
			$("#callbackconfirm-dialog").find(".proceed").first().on("click", function(){
				if( CallbackConfirmDialog._confirmContactNumberElement.val() != '' ) {
					$("#${xpath}_contactDetails_call").val("Y");
					$("#${xpath}_contactDetails_contactNumber").val( CallbackConfirmDialog._confirmContactNumberElement.val() );
					$("#${xpath}_contactDetails_contactNumberinput").val( CallbackConfirmDialog._confirmContactNumberElementInput.val() );
					CallbackConfirmDialog.close();
					if( typeof CallbackConfirmDialog._callback == "function" ) {
						CallbackConfirmDialog._callback();
					}
				} else {
					CallbackConfirmDialog._confirmContactNumberElementInput.trigger("blur");
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
<go:script>
	$("#callBackConfirmationForm").validate({
		rules: {
			${xpath}_confirmContactNumberinput: {
				validateTelNo:true
			}
		},
		messages: {
			${xpath}_confirmContactNumberinput:{
				validateTelNo:"Please enter the contact number in the format (area code)(local number) for landline or 04xxxxxxxx for mobile"
			}
		},
		submitHandler: function(form) {
			form.submit();
		},
		errorPlacement: function ($error, $element) {
		},
		onkeyup: function(element) {
			var element_id = jQuery(element).attr('id');
			if ( !this.settings.rules.hasOwnProperty(element_id) || this.settings.rules[element_id].onkeyup == false) {
				return;
			};

		},
		ignore: ":disabled",
		wrapper: 'li',
		meta: "validate",
		debug: false
	});
</go:script>
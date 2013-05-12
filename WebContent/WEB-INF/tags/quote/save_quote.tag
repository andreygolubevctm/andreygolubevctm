<%@ tag description="Terms and conditions popup for results page"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="quoteType"	required="false"	description="The vertical this quote is for"%>
<%@ attribute name="emailCode"	required="false"	description="The vertical this quote is for"%>
<%@ attribute name="mainJS"		required="false"	description="The vertical this quote is for"%>

<c:set var="isOperator">
	<c:choose>
		<c:when test="${not empty data.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<c:set var="vertical_main_js">
	<c:choose>
		<c:when test="${not empty mainJS and mainJS}">${mainJS}</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<%-- CSS --%>
<go:style marker="css-head">
	#save-popup {
		width:450px;
		height:auto;
		z-index:2001;
		display: none;
	}
	#save-popup h5 {
	    background: url("common/images/dialog/header_450.gif") no-repeat scroll 0 0 transparent;
	    display: block;
	    font-size: 22px;
	    height: 38px;
	    padding-top: 16px;
	    padding-left: 1em;
	    width: 450px;
	    margin-bottom: -10px;
	    font-family: "SunLT Light","Open Sans",Helvetica,Arial,sans-serif;
	}
	#save-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_450.gif") no-repeat;
		width:450px;
		height:57px;
		display:block;
	}

	#save-popup .close-button {
	    left: 424px;
	}
	#save-popup .content {
		background: white url("common/images/dialog/content_450.gif") repeat-y;
		padding:10px;
		overflow:none;
		height:auto; 
	}
	#save-popup .content h4 {
	    margin:6px 4px 27px 5px;
	    font-size: 13px;
	}	
	#save-popup .fieldrow {
    	width: 430px;
    }
    #save-popup h6 {
	    font-weight: bold;
	    font-size: 13px;
	    margin: 10px 0px 8px 10px;
    }
	#save-popup .content p {
	    margin-bottom: 9px;
	    font-size: 11px;
	    margin: 10px 10px;
	}	
	#save-overlay {
		position:absolute;
		top:0px;
		left:0px;
		z-index:1000;		 
	}
	#save_email {
		width:220px; 
	}
	#user_save_quote_errors,
	#operator_save_quote_errors {
		display:none;
		position: absolute;

	    right: -200px;

    	top: 144px;

    	width: 200px;
	}
	#save_confirm_email {
	    font-weight: bold;
	    padding-left: 25px;
	    padding-bottom: 15px;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var SaveQuote = new Object();
SaveQuote = {
	_CONFIRM : "confirm",
	_SAVE : "save",
	_ERROR : "error",
	
	_FILE : "save_quote",
	
	_IS_OPERATOR : ${isOperator},
	
	_origZ : 0,
	_mode : "",
	
	_callback : null,
	
	_VERT_MAIN_JS : ${vertical_main_js},
	
	setToMySQL : function() {
		SaveQuote._FILE = "save_quote_mysql";
		return SaveQuote;
	},
	
	applyDefaults : function( defaults )
	{
		if( typeof defaults == "object" )
		{
			if( defaults.hasOwnProperty("email") && !$("#save_email").val().length )
			{
				$("#save_email").val( defaults.email );
			}
			
			if( defaults.hasOwnProperty("optin") )
			{
				$("input[name='save_marketing'][value='" + defaults.optin + "']").attr("checked", true);
			}
		}
	},
	
	checkQuoteOwnership : function( callback )
	{
		if( typeof SaveQuote._VERT_MAIN_JS == "object" && SaveQuote._VERT_MAIN_JS.hasOwnProperty("checkQuoteOwnership") )
		{
			SaveQuote._VERT_MAIN_JS.checkQuoteOwnership( callback );
		}
		else
		{
			callback();
		}
	},
	
	updateErrorFeedback: function( errors ) {
		if(typeof errors == "object" && errors.length) {
			var element = $("#save-error").find(".customisable").first();
			for( var i = 0; i < errors.length; i++ ) {
				element.append( errors[i].error );
				
				if( i + 1 < errors.length ) {
					element.append("<br /><br />");
				}
			}
		}
		else
		{
			$("#save-error").find(".customisable").first().empty().hide();
		}
	},
	
	/**
	 * @param defaults	Object		[optional] Contains email and optin properties to update the form with
	 * @param callback	Function	[optional] Function to call before save to update the quote form's optin field
	 */
	show: function(mode, defaults, callback){
		
		SaveQuote.checkQuoteOwnership(function(){
			if (typeof mode != "undefined" && mode) {
				SaveQuote._mode = mode;
			} else {
				SaveQuote._mode = SaveQuote._SAVE;
			}	
			
			switch(SaveQuote._mode) {
			case SaveQuote._CONFIRM:
				$("#save_confirm_email").text($("#save_email").val());
				$("#user-save-form").hide();
				$("#operator-save-form").hide();
				$("#save-error").hide();
				$("#save-confirm").show();
	
				SaveQuote._callback = null;
				break; 
			
			case SaveQuote._ERROR:
			 	$("#user-save-form").hide();
			 	$("#operator-save-form").hide();
				$("#save-operator").hide();
				$("#save-confirm").hide();
				$("#save-error").show();
				SaveQuote._callback = null;
				break; 
				
			default:
				SaveQuote.applyDefaults( defaults );
				
				SaveQuote._callback = callback;
				
				// if we already have a save email address, 
				// just attempt to save the quote
				if ( !SaveQuote._IS_OPERATOR && $("#save_email").val() != "" && $("#save_password").val() != "" && String($("#save_password").val()).length >= 6)
				{
					SaveQuote._ajaxSave();
				}
				else if ( SaveQuote._IS_OPERATOR && $("#save_email").val() != "" && $("#save_password").val() != "" && String($("#save_password").val()).length >= 6)
				{
					$("#save-confirm").hide();
					$("#save-operator").hide();
					$("#save-error").hide();
					$("#userSaveForm").find("h4").eq(0).hide();
					$("#userSaveForm").find("div.fieldrow").eq(0).hide();
					$("#userSaveForm").find("div.fieldrow").eq(1).hide();
					$("#userSaveForm").find("div.fieldrow").eq(2).hide();
					$("#userSaveForm").find("div.fieldrow").eq(3).hide();
					$("#operator-save-unlock").buttonset();
					$("#operator-save-form").show();
					$("#marketing").buttonset();
					$("#user-save-form").show();
				}
				else
				{
					$("#save-confirm").hide();
					$("#save-operator").hide();
					$("#save-error").hide();
					$("#operator-save-form").hide();
					
					$("#userSaveForm").find("h4").eq(0).show();
					$("#userSaveForm").find("div.fieldrow").eq(0).show();
					$("#userSaveForm").find("div.fieldrow").eq(1).show();
					$("#userSaveForm").find("div.fieldrow").eq(2).show();
					$("#userSaveForm").find("div.fieldrow").eq(3).show();
				
					// if call centre operator just save without
					// displaying the form
					if( SaveQuote._IS_OPERATOR && !$('#operator-save-unlock').find('input:checked').val()  )
					{
						$("#operator-save-unlock").buttonset();
						$("#operator-save-form").show();
					}
									
					// default the email address to that of the quote (if not set) 
					if ($("#save_email").val() == '') {
						$("#save_email").val($("#quote_contact_email").val());
					}
					// Don't show the marketing if we already have an answer
					/*if ($("#quote_terms_Y").is(":checked") || $("#save_marketing_Y").is(":checked")) {
						$("#save_marketing").hide();
					}*/
					$("#marketing").buttonset();
					$("#user-save-form").show();
				}
						
				// If we're not already showing an overlay .. create one.
				if (!$(".ui-widget-overlay").is(":visible"))
				{
					var overlay = $("<div>").attr("id","save-overlay")
											.addClass("ui-widget-overlay")
											.css({	"height":$(document).height() + "px", 
													"width":$(document).width()+"px"
												});
					$("body").append(overlay);
					$(overlay).fadeIn("fast");
						
				// Otherwise just mess with the existing overlay's z-index				
				}
				else
				{
					SaveQuote._origZ = $(".ui-widget-overlay").css("z-index");
					$(".ui-widget-overlay").css("z-index","2000");
				}
	
				// Show the popup			
				$("#save-popup").center().show("slide",{"direction":"down"},300);
				//omnitureReporting(20);
				break;
			}
		});
	}, 
	hide: function()
	{
		$("#save-popup").hide("slide",{"direction":"down"},300);
		
		// Did we add a specific overlay? if so remove.  		
		if ($("#save-overlay").length) {
			$("#save-overlay").remove();
		} else {
			$(".ui-widget-overlay").css("z-index",SaveQuote._origZ);
		}
	}, 
	init : function()
	{
		$("#save-popup").hide();
		$("#user-save-form").hide();
		$("#operator-save-form").hide();
		$("#save-error").hide();
		$("#save-confirm").hide();
		$("#save-operator").hide();
		$("#save_email").val("");
	}, 
	save : function()
	{
		if (SaveQuote._mode == SaveQuote._SAVE)
		{
			$("#userSaveForm").validate();
			
			$("#userSaveForm :input").each(function(index) {
				$("#userSaveForm").validate().element("#" + $(this).attr("id"));
			});
			
			// If no validation errors, save the quote..
			if ($("#userSaveForm").validate().numberOfInvalids() == 0)
			{
				if( SaveQuote._IS_OPERATOR )
				{
					SaveQuote._ajaxSave( $('#operator-save-unlock').find('input:checked').val() == "Y" ? true : false );
				}
				else
				{
					SaveQuote._ajaxSave();
				}		
				Track.startSaveRetrieve(Transaction.getId(), 'Save');
			}
			
		}
		else
		{
			SaveQuote.hide();
		}
	}, 
	_ajaxSave : function( unlock )
	{
		unlock = unlock || false;
		
		if( typeof SaveQuote._callback == "function" )
		{
			SaveQuote._callback( $("input[name='save_marketing']:checked", "#userSaveForm").val() );
		}
		
		var dat = $("#userSaveForm").serialize() + "&" + $("#mainform").serialize() + "&quoteType=${quoteType}&emailCode=${emailCode}";
		
		switch(Track._type)
		{
			case "Health":
				if( Health._rates !== false )
				{
					dat += Health._rates;
				}
				break;
			default:
				break;
		}
		
		// ajax save the quote.. 
		$.ajax({
			url: "ajax/json/" + SaveQuote._FILE + ".jsp",
			data: dat,
			type: "POST",
			dataType: "json",
			async: false,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				
				if (jsonResult.result == "OK")
				{
					if( unlock )
					{
						SaveQuote._unlockQuote();
					}
					
					SaveQuote.show(SaveQuote._CONFIRM);
					try
					{
						Track.onSaveQuote();
					}
					catch(e){/* IGNORE */}
				}
				else
				{
					SaveQuote.show(SaveQuote._ERROR);
				}		
				
								
				return false;
			},
			error: function(obj,txt){
				try {
					var errors = eval(obj.responseText);
					if(typeof errors == "object" && errors.length) {
						SaveQuote.updateErrorFeedback(errors);
					}
					else
					{
						SaveQuote.updateErrorFeedback();
					}
				} catch(e) {
					SaveQuote.updateErrorFeedback();
				}
				
				SaveQuote.show(SaveQuote._ERROR);
			},
			timeout:30000
		});
		
		if(SaveQuote._IS_OPERATOR)
		{
			$('#operator-save-unlock').find('input').removeAttr('checked');
			$('#operator-save-unlock').find('input').button('refresh');	
		}
	},
	
	_unlockQuote : function()
	{
		var dat = {quoteType:"${quoteType}",touchtype:"X"};		
		
		this.ajaxReq = 
		$.ajax({
			url: "ajax/json/access_touch.jsp",
			data: dat,
			dataType: "json",
			type: "POST",
			async: true,
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
				if( !Number(jsonResult.result.success) )
				{
					FatalErrorDialog.display(jsonResult.result.message);
				}
				
				return false;
			},
			error: function(obj,txt){
				FatalErrorDialog.display("An undefined error has occured while unlocking the quote - please try again later.");
			}
		});
	}
}
</go:script>
<go:script marker="jquery-ui">
	$("#save-popup .close-button").click(function(){
		SaveQuote.hide();
	});
	$("#save-popup .ok-button").click(function() {
		SaveQuote.save();
	});
</go:script>
<go:script marker="onready">
	SaveQuote.init();
	
	$("#userSaveForm").validate({
     	rules: { 
            save_email: { 
            	required:true,
            	email:true
            },
            save_password: {
            	required:true,
                minlength: 6            	
            },
            save_confirm: {
            	required:true,
            	equalTo:"#save_password"
            }
        }, 
        messages: { 
        	save_email: "Please enter a valid email address",
            save_password: { 
            	required: "Please enter a password",
            	minlength: jQuery.format("Password must be at least {0} characters")
            },
            save_confirm: "Password and confirmation password must match"
        },
        errorContainer: "#user_save_quote_errors, #user_save_quote_errors p",
        errorLabelContainer:"#user_save_quote_errors ul",
		wrapper: "li",
		debug:true
	});
	
	$('#save_email').on('blur',function() { $(this).val($.trim($(this).val())); });
	
</go:script>

<%-- HTML --%>
<div id="save-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>Save Your Quotes</h5>
	
	<div class="content" id="user-save-form">
		<form:form name="userSaveForm" action="none" id="userSaveForm" method="POST">
			<h4>Enter your email address and a password to save your quotes.</h4>
			
			<form:row label="Email Address">
				<field:contact_email xpath="save/email" required="false" title="your email address"/>
			</form:row>
			
			<form:row label="Password">
				<field:password xpath="save/password" required="false" title="your password"/>
			</form:row>
			
			<form:row label="Confirm Password">
				<field:password xpath="save/confirm" required="false" title="your password for confirmation"/>
			</form:row>	
						
		 	<form:row label="Please keep me informed via email of news and other offers" id="save_marketing">
				<field:array_radio xpath="save/marketing" required="false"
					className="marketing" id="marketing" items="Y=Yes,N=No"
					title="agree to receive marketing" />
			</form:row>
	
			<div id="operator-save-form">
				<h4>Do you want to unlock this quote so the client can access it?</h4>
				
				<form:row label="Unlock Quote">
					<field:array_radio id="operator-save-unlock" xpath="save/unlock" required="true" items="Y=Yes,N=No" title="Do you wish to unlock this quote?" />
				</form:row>
				
				<div id="operator_save_quote_errors">
					<div class="error-panel-top small"><h3>Oops...</h3></div>
					<div class="error-panel-middle small"><ul></ul></div>
					<div class="error-panel-bottom small"></div>
				</div>				
			</div>
			
			<div id="user_save_quote_errors">
				<div class="error-panel-top small"><h3>Oops...</h3></div>
				<div class="error-panel-middle small"><ul></ul></div>
				<div class="error-panel-bottom small"></div>
			</div>
		</form:form>				
	</div>
	
	<div class="content" id="save-confirm">
		<h6>Your quote has been saved!</h6>
		<p>To retrieve your quotes, log in to <a href="${data['settings/root-url']}${data.settings.styleCode}/retrieve_quotes.jsp" target="_new">${data['settings/root-url']}${data.settings.styleCode}/retrieve_quotes.jsp</a> using the email address: </p>
		<p id="save_confirm_email"></p>	
	</div>
	
	<!--<div class="content" id="save-operator">
		<h6>Your quote has been saved!</h6>
	</div>-->

	<div class="content" id="save-error">
		<h6>Save quotes failed</h6>
		<p>An error occurred when trying to save your quotes.</p>
		<p class="customisable"><!-- empty --></p>
		<p>Please try again at a later time.</p>
	</div>
	
	<div class="buttons">
		<a href="javascript:void(0)" class="ok-button bigbtn"><span>Ok</span></a>
	</div>
</div>


$(document).ready(function() {
	$("#errorContainer").show();

	// User clicked "login" 
	$("#reset-button").click(function(){
		if ($("#resetPasswordForm").validate().form()) {
			Reset.submit();					
		}				
	});
	
	// User pressed enter on password
	$("#reset_confirm").keypress(function(e) {
		if(e.keyCode == 13) {
			$("#reset-button").click();
		}
	});
	
	$("#return-to-login").click(function(){
		// Redirect to the retrieve quote page 
		Reset.redirect();
	});	
	
	$("#try-again").click(function(){
		window.location.replace("retrieve_quotes.jsp#/?panel=forgotten-password");
	});
});


var Reset = new Object();
Reset = {	
	_email : "",
	_busy : false,
	
	submit : function(){
		if (this._busy){
			return false;
		}
		this._busy = true;
		// Submit ajax call and show popup for reset
		var dat = $("#resetPasswordForm").serialize(); 					
		
		$.ajax({
			url: "ajax/json/reset_password.jsp",
			data: dat,
			type: "GET",
			async: true,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				
				// Check if error occurred
				if (jsonResult.error) {
					
					switch(jsonResult.error){
					case "INVALID_LINK":
						$("#reset-error-message").text(
							"Unfortunately the reset password link you used has either expired or been used already."
						);
						break;
					case "INVALID_EMAIL":
						$("#reset-error-message").text(
							"Unfortunately we no longer have your email address on file."
						);
						break;
					case "TIMEOUT":
						$("#reset-error-message").text(
							"Unfortunately an error seems to have occurred."
						);
						break;																	
					}
					
					$("#reset-error-message").text();
					Popup.show("#reset-error");
					
				} else {
					this._email = jsonResult.email;
					Popup.show("#reset-confirm");
				}
				this._busy = false;
				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				$("#reset-error-message").text(txt);
				Popup.show("#reset-error");
				this._busy = false;
			},
			timeout:30000
		});
	}, 
	redirect : function(){
		window.location.replace("retrieve_quotes.jsp?email="+this._email);
	}		
};

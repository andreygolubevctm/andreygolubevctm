
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
		var self = this;
		$.ajax({
			url: "generic/reset_password",
			data: dat,
			type: "POST",
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
				if (jsonResult.result !== "OK") {

					if (jsonResult.message) {
						$("#reset-error-message").text(jsonResult.message);
					} else {
						$("#reset-error-message").text("Oops, something seems to have gone wrong! Please try again.");
					}
					Popup.show("#reset-error");

				} else {
					self._email = jsonResult.email;
					Popup.show("#reset-confirm");
				}
				self._busy = false;
				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				$("#reset-error-message").text("Oops, something seems to have gone wrong: " + txt + " Please try again.");
				Popup.show("#reset-error");
				this._busy = false;
			},
			timeout:30000
		});
	},
	redirect : function(){
		window.location.replace("retrieve_quotes.jsp?email="+encodeURIComponent(this._email));
	}
};

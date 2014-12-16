var UtilitiesLead = {

	ajaxPending : false,

	_new_quote : quoteCheck._new_quote,

	_init : function()
	{

		// Any slide
		slide_callbacks.register({
			mode:		'before',
			slide_id:	-1,
			callback:	function() {

				if( QuoteEngine.getCurrentSlide() == 1){
					UtilitiesLead.submitLead();
				}

				if( QuoteEngine.getCurrentSlide() != 0){
					$("#next-step").remove();
					$("#prev-step").remove();
				}

			}
		});
	},

	error: function(title, errors, data) {

		UtilitiesLead.ajaxPending = false;
		Loading.hide();

		if ($.isArray(errors)) {
			var m = [];
			$.each(errors, function(i, error) {
				if( error.code > 0 ) {
					m.push("Service is currently unavailable. Please try again later.");
				} else {
					m.push(error.message);
				}
			});
			errors = m;
		} else if (typeof errors == 'object' && errors.hasOwnProperty('error')) {
			errors = [errors.error.message];
		}

		if (!$.isArray(errors) || errors.length == 0) {
			errors = ['An undefined error has occured.'];
		}

		var content = '';
		content += '<b>'+title+'</b>';
		content += '<ul style="margin:0.25em 0 0 1.2em; list-style:disc"><li>' + errors.join('</li><li>') + '</li></ul>';

		FatalErrorDialog.exec({
			message:		content,
			page:			"utilities_lead.js",
			description:	typeof data == "object" && data.hasOwnProperty("description") ? data.description : "UtilitiesQuote.error()",
			data:			typeof data == "object" && data.hasOwnProperty("data") ? data.data : null
		});
	},

	errorSubmitLead: function(errors, data) {
		QuoteEngine.prevSlide();
		UtilitiesLead.error('An error occurred when submitting the application', errors, data);
	},

	submitLead: function(callback ) {

		if (!UtilitiesLead.ajaxPending){

			Loading.show("Submitting application...");

			var dat = serialiseWithoutEmptyFields('#mainform');
			UtilitiesLead.ajaxPending = true;

			$.ajax({
				url: "ajax/json/utilities_submit_lead.jsp",
				data: dat,
				type: "POST",
				async: true,
				dataType: "json",
				timeout:60000,
				cache: false,
				success: function(json){

					UtilitiesLead.ajaxPending = false;

					Loading.hide();

					//UtilitiesConfirmationPage.show(json);
					return json;
				},
				error: function(obj,txt,errorThrown) {
					UtilitiesLead.errorSubmitLead(txt + ' ' + errorThrown, {
						description:	"UtilitiesLead.submitLead(). AJAX request failed: " + txt + " " + errorThrown,
						data:			dat
					});
					return false;
				}
			});

		}

	}


};

UtilitiesLead._init();


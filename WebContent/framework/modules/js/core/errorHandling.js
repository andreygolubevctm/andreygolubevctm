////////////////////////////////////////////////////////////
//// Handle Errors                                      ////
////----------------------------------------------------////
//// This handles the logic on displaying				////
//// fatal errors to the user							////
////////////////////////////////////////////////////////////
;(function($, undefined){

	var meerkat = window.meerkat;
	var log = meerkat.logging.info;

	var defaultSettings = {
		errorLevel: 'silent', // silent (only log in the db), warning (visible to user but can go back to page) or fatal (visible to user and forces page refresh)
		page: "unknown",
		message: "Sorry, an error has occurred",
		description: "unknown",
		data:null
	}


	function error(instanceSettings){

		if( typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null){
			console.error("Message to dev: please provide an errorLevel to the errorHandling.error() function.");
		}

		var settings = $.extend({}, defaultSettings, instanceSettings);
		var fatal;

		switch(settings.errorLevel){
			case "warning":
				fatal = false;
				showErrorMessage(fatal, settings.message);
				break;
			case "fatal":
				fatal = true;
				showErrorMessage(fatal, settings.message);
				break;
			default: //silent
				fatal = false;
				break;
		}

		settings.fatal = fatal;

		var transactionId = '';

		if(typeof meerkat.modules.transactionId != 'undefined'){
			transactionId = meerkat.modules.transactionId.get();
			if(transactionId === null) transactionId = '';
		}

		settings.transactionId = transactionId;

		if(fatal){
			try{
				meerkat.modules.writeQuote.write({
					triggeredsave:'fatalerror',
					triggeredsavereason:settings.description
				}, false);
			}catch(e){
				// silently fail.
			}
		}

		meerkat.modules.comms.post({
			url:"ajax/write/register_fatal_error.jsp",
			data: settings,
			useDefaultErrorHandling: false,
			errorLevel: "silent",
			onError:function(){
				// override to prevent loops
			}
		});
	}

	function showErrorMessage(fatal, message){
		var buttons;

		if(fatal){

			buttons = [{
					label: "Refresh page",
					className: 'btn-primary',
					action: function(eventObject){
						location.reload();
					},
					closeWindow:false
				}
			];

			if(meerkat.site.isDev === true){
				buttons.push({
					label: "Attempt to continue [dev only]",
					className: 'btn-default',
					action: null,
					closeWindow:true
				});
			}

		}else{
			buttons = [{
					label: "OK",
					className: 'btn-primary',
					closeWindow:true
				}
			];
		}

		var modal = meerkat.modules.dialogs.show({
			title: "Error",
			htmlContent: message,
			buttons: buttons
		});

		if(fatal && !meerkat.site.isDev){
			$("#"+modal+" .modal-closebar").remove();
		}
	}

	meerkat.modules.register('errorHandling', {
		error:error
	});


})(jQuery);
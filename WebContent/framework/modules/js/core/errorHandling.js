////////////////////////////////////////////////////////////
//// Handle Errors                                      ////
////----------------------------------------------------////
//// This handles the logic on displaying				////
//// fatal errors to the user							////
////////////////////////////////////////////////////////////
;(function($, undefined){

	var meerkat = window.meerkat;
	var log = meerkat.logging.info;

	var events = {
			errorHandling : {
				OK_CLICKED : 'OK_CLICKED'
			}
	}, moduleEvents = events.errorHandling;

	var defaultSettings = {
		errorLevel: 'silent', // silent (only log in the db), warning (visible to user but can go back to page) or fatal (visible to user and forces page refresh)
		page: "unknown",
		message: "Sorry, an error has occurred",
		description: "unknown",
		data:null,
		id:null
	};


	function error(instanceSettings){

		if( typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null){
			console.error("Message to dev: please provide an errorLevel to the errorHandling.error() function.");
		}

		var settings = $.extend({}, defaultSettings, instanceSettings);
		var fatal;

		switch(settings.errorLevel){
			case "warning":
				fatal = false;
				showErrorMessage(fatal, settings);
				break;
			case "fatal":
				fatal = true;
				showErrorMessage(fatal, settings);
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

		if(typeof settings.data == 'object' && settings.data !== null)
			settings.data = JSON.stringify(settings.data);

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

	function showErrorMessage(fatal, data){

		var buttons;

		if(fatal){

			buttons = [{
					label: "Refresh page",
					className: 'btn-cta',
					action: function(eventObject){
						location.reload();
					},
					closeWindow:false
				}
			];

			if(meerkat.site.isDev === true){
				buttons.push({
					label: "Attempt to continue [dev only]",
					className: 'btn-cancel',
					action: null,
					closeWindow:true
				});
			}

		}else{
			buttons = [{
					label: "OK",
					className: 'btn-cta',
					closeWindow:true,
					action: function() {
						meerkat.messaging.publish(moduleEvents.OK_CLICKED);
				}
				}
			];
		}

		var dialogSettings = {
				title: "Error",
				htmlContent: data.message,
				buttons: buttons
		};

		if(!_.isNull(data.id)) {
			_.extend(dialogSettings, {id:data.id});
		}

		var modal = meerkat.modules.dialogs.show(dialogSettings);

		if(fatal && !meerkat.site.isDev){
			$("#"+modal+" .modal-closebar").remove();
		}
	}

	meerkat.modules.register('errorHandling', {
		error:error,
		events: events
	});


})(jQuery);
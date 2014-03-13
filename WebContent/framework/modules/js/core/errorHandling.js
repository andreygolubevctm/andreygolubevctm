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
		fatal:false,
		silent:false,
		page: "unknown",
		message: "Sorry, an error has occured",
		description: "unknown",
		data:null,
		property: meerkat.site.brand
	}


	function error(instanceSettings){

		var settings = $.extend({}, defaultSettings, instanceSettings);

		if(settings.silent === false){
			showErrorMessage(settings.fatal, settings.message);
		}

		if(settings.fatal){
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
			data:settings,
			useDefaultErrorHandling:false,
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
		
		meerkat.modules.dialogs.show({
			title: "Error",
			htmlContent: message,
			buttons: buttons
		});
	}

	meerkat.modules.register('errorHandling', {
		error:error
	});


})(jQuery);
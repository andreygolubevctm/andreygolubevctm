;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		writeQuote: {
			
		}
	},
	moduleEvents = events.writeQuote;

	function init(){

	}

	// extraDataToSave should be an object with a bunch of name: value (i.e. {blah:"blah", plop:"plop"} )
	function write( extraDataToSave, triggerFatalError, callback ){

		var data = [];

		data.push( meerkat.modules.journeyEngine.getFormData() );
		
		data.push({
			name: 'quoteType',
			value: meerkat.site.vertical 
		});
		
		data.push({
			name: 'stage',
			value: meerkat.modules.journeyEngine.getCurrentStep().navigationId
		});

		
		
		if( typeof extraDataToSave === "object" ){
			for(var i in extraDataToSave) {
				if( extraDataToSave.hasOwnProperty(i) ) {					
					data.push({
						name: i,
						value: extraDataToSave[i]
					});
				}
			}
		}

		meerkat.modules.comms.post({
			url: "ajax/write/write_quote.jsp",
			data: data,
			dataType: 'json',
			cache: false,
			errorLevel: triggerFatalError ? "fatal" : "silent",
			onSuccess:  function writeQuoteSuccess(result){
				if( typeof callback === "function" ) callback(result);
			}
		});

	}

	meerkat.modules.register("writeQuote", {
		init: init,
		events: events,
		write: write
	});

})(jQuery);
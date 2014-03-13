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

		data.push( meerkat.modules.journeyEngine.getSerializedFormData() );
		data.push( "quoteType="+meerkat.site.vertical );
		data.push( "stage=" + meerkat.modules.journeyEngine.getCurrentStep().navigationId )
		
		data = data.join("&");

		if( typeof extraDataToSave === "object" ){
			for(var i in extraDataToSave) {
				if( extraDataToSave.hasOwnProperty(i) ) {
					data += "&" + i + "=" + extraDataToSave[i]
				}
			}
		}

		meerkat.modules.comms.post({
			url: "ajax/write/write_quote.jsp",
			data: data,
			dataType: 'json',
			cache: false,
			isFatalError: triggerFatalError ? true : false,
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
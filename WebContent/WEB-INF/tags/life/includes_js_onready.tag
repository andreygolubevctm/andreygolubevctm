<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<ui:popup_window />

<go:script marker="onready">

	<life:custom_contact_panel />

	slide_callbacks.register({
		mode:			'before',
		slide_id:		-1,
		callback:		function(){
			if(QuoteEngine._options.currentSlide > 0 && QuoteEngine._options.currentSlide < 3) {
				$('#reference_number').fadeOut('fast');
			} else {
				$('#reference_number').fadeIn('fast');
			}
		}
	});

	QuoteEngine.nextSlide(function(currentSlide){
		switch(currentSlide){
			case 0:
				LifeQuote.fetchPrices(true);
				return true;
				break;
			default:
				return true;
		}
	});

	Track.onQuoteEvent('Start', referenceNo.getTransactionID(false));
	Track.nextClicked(0, referenceNo.getTransactionID(false));

	referenceNo.overrideSave(function(){
		var defaults = {
			email: $("#" + LifeQuote._vertical + "_contactDetails_email").val(),
			optin: $("#" + LifeQuote._vertical + "_contactDetails_optIn").is(":checked") ? "Y" : "N"
		}
		SaveQuote.show( SaveQuote._SAVE, defaults, function( optin ) {
			if( optin == "Y" )
			{
				$("#" + LifeQuote._vertical + "_contactDetails_optIn").attr("checked", "true");
			}
			else
			{
				$("#" + LifeQuote._vertical + "_contactDetails_optIn").removeAttr("checked");
			}
		} );
	});
</go:script>
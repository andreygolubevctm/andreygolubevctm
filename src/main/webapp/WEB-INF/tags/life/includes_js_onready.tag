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
			
			if(LifeQuote._vertical == "life") {
				var $contactPanel = $('.lifebroker-contact-panel');
				var primaryResult = Results.getPrimarySelectedProduct();
				if(QuoteEngine._options.currentSlide == 2 && typeof primaryResult.company !== "undefined" && primaryResult.company == "ozicare") {
					$contactPanel.find('.provider-phone-number').text(primaryResult.insurer_contact);
					$contactPanel.find('.call-provider-message span').text(primaryResult.companyName);
				} else {
					var $providerPhone = $contactPanel.find('.provider-phone-number');
					$providerPhone.text($providerPhone.data('original'));
					var $providerName = $contactPanel.find('.call-provider-message');
					$providerName.find('span').text($contactPanel.data('original'));
		}
				
				if(QuoteEngine._options.currentSlide == 3) {
					if(primaryResult.company == "ozicare") {
						$('#life-confirmation .column.left .inner.left .panel p:nth-child(2)').hide();
					} else {
						$('#life-confirmation .column.left .inner.left .panel p:nth-child(2)').show();
					}
				}
				
				if(QuoteEngine._options.currentSlide == 0 && LifeQuote._vertical == 'life') {
					$('#reference_number').hide();
				} else {
					$('#reference_number').show();
				}
				
				if(QuoteEngine._options.currentSlide == 2) {
					$('.what-next .phone-no-replace').text(primaryResult.insurer_contact);
				}
			
				if(QuoteEngine._options.currentSlide == 1) {
					$('#contact-panel').hide();
				} else {
					$('#contact-panel').show();
				}
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

	$('#reference_number').hide();

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
	
	$(document).on('click','a[data-savequote=true]',function(){

		SaveQuote.show();

	})
</go:script>

<form:radio_button_group_validate />
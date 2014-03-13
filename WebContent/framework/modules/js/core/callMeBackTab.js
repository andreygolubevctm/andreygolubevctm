;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		msg = meerkat.messaging,
		log = meerkat.logging.info;

	var events = {
		callMeBackTab: {
			
		}
	},
	moduleEvents = events.callMeBackTab;

	$currentCallMeBackModal = null;

	isRequested = false;

	function init(){
		jQuery(document).ready(function($) {
			$modalContent = $("#callMeBackModalContent");
			$openButton = $("#callMeBackTabButton");

			$openButton.on("click", open);
		});

		// subscribe to when the call me back form is valid or invalid to enable/disable the "Call Me" button
		msg.subscribe( meerkatEvents.callMeBack.VALID, enableSubmitButton );
		msg.subscribe( meerkatEvents.callMeBack.INVALID, disableSubmitButton );
		// subscribe to when the call me back has been requested successfully to hide the "Call me" button
		msg.subscribe( meerkatEvents.callMeBack.REQUESTED, onCallMeBackRequested );
	}

	function open(){
		
		// create modal
		var callMeBackDialogId = meerkat.modules.dialogs.show({
			title: "Get a call back",
			htmlContent: $modalContent.html(),
			buttons: [{
					label: isRequested ? "Close" : "Cancel",
					className: 'btn-default modal-call-me-back-close',
					closeWindow: true
				},
				{
					label: "Call me",
					className: 'btn-primary disabled modal-call-me-back-submit' + (isRequested ? ' displayNone' : ''),
					action: submitCallMeBack
				}],
			onClose: function(){
				$openButton.fadeIn();
			}
		});
		$currentCallMeBackModal = $("#" + callMeBackDialogId);

		// prefill form
		meerkat.modules.callMeBack.updateSelectedElements();
		meerkat.modules.callMeBack.prefillForm( $currentCallMeBackModal.find("form") );

		// hide superfluous title
		$currentCallMeBackModal.find("h5").hide();

		// hide superfluous submit button
		$currentCallMeBackModal.find(".call-me-back-submit").hide();

		// fade out opening button
		$openButton.fadeOut();

		// focus the first empty field
		var $name = $currentCallMeBackModal.find(".callmeback_name");
		var $phone = $currentCallMeBackModal.find(".callmeback_phone");

		if($name.val() === "") {
			$name.focus();
		} else if($phone.val() === "") {
			$phone.focus();
		} else {
			$currentCallMeBackModal.find(".callmeback_timeOfDay").focus();
		}

	}

	function submitCallMeBack(){
		meerkat.modules.callMeBack.submitCallMeBack( $currentCallMeBackModal.find("form") );
	}

	function enableSubmitButton(){
		if( $currentCallMeBackModal !== null ){
			$currentCallMeBackModal.find(".modal-call-me-back-submit").removeClass("disabled");
		}
	}

	function disableSubmitButton(){
		if( $currentCallMeBackModal !== null ){
			$currentCallMeBackModal.find(".modal-call-me-back-submit").addClass("disabled");
		}
	}

	function onCallMeBackRequested(){
		isRequested = true;
		if( $currentCallMeBackModal !== null ){
			$currentCallMeBackModal.find(".modal-call-me-back-submit").hide();
			$currentCallMeBackModal.find(".modal-call-me-back-close").html("Close");
		}
	}

	meerkat.modules.register("callMeBackTab", {
		init: init
	});

})(jQuery);
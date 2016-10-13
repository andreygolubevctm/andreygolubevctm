;(function($, undefined){

	var meerkat = window.meerkat;

	var timeout = 0,
		callbackSubmited = false;
		isModalOpen = false;
			
	function init() {

		if(meerkat.site.callbackPopup.enabled === 'Y') {
			idle = setInterval(count, 100);
		}

        $(document).on('mousemove', function (e) {
	        reset();
	    });

        $(document).on('keypress', function (e) {
	        reset();
	    });
	}

	function count() {
		timeout += 1;
		if(!callbackSubmited && timeout === meerkat.site.callbackPopup.timeout) {
			showModal();
		}
	}
	
	function reset() {
		timeout = 0;
	}

	function showModal() {
		if(!isModalOpen) {
			isModalOpen = true;
			
			var modalConfig = {
				className: "callbackPopupModal " + meerkat.site.callbackPopup.position,
				backdrop: false,
				onOpen: function onSessionModalOpen(dialogId) {
					$("#" + dialogId).find(".modal-closebar").remove();
				}
			};
		

			var htmlTemplate = _.template($('#callback-popup').html());
	        modalConfig.htmlContent = htmlTemplate();

			modalConfig.buttons = [
				{
					label: "Continue online, close this",
					closeWindow: true,
					action: function sessionModalClose() { hideModal(); }
				}
			];
			
			callbackPopupModal = meerkat.modules.dialogs.show(modalConfig);
		}
	}

	function hideModal() {
		isModalOpen = false;
		reset();
	}

	function setCallbackSubmited() {
		callbackSubmited = true;
	}

	meerkat.modules.register("healthCallbackPopup", {
		init: init,
		reset: reset
	});

})(jQuery);
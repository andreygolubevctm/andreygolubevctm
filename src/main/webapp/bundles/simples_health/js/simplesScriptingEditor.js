;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var moduleEvents = {
		};

	var modalId = false,
	templateScripting = false,
	dialogueId = 0;



	function init() {

		$(document).ready(function() {

			eventDelegates();

			//
			// Set up templates
			//
			var $e = $('#simples-template-scripting-editor');
			if ($e.length > 0) {
				templateScripting = _.template($e.html());
			}
		});
	}

	function eventDelegates() {
		$('.simples-dialogue-edit').on('click', function dialogueEditEvent(event) {
			event.preventDefault();
			dialogueId = event.currentTarget.id.split('simples-dialogue-edit-')[1];

			openModal();
		});
	}

	function performSearch() {
		 updateModal();
	}

	function openModal() {
		meerkat.modules.dialogs.show({
			title: ' ',
			fullHeight: false,
			onOpen: function(id) {
				modalId = id;
				performSearch();
			},
			onClose: function() {
			}
		});
	}

	function updateModal(data) {

		var htmlContent = 'No template found.';
		data = data || {};

		data.id = dialogueId;

		if (typeof templateScripting === 'function') {
			htmlContent = templateScripting(data);
		}

				// Replace modal with updated contents
				meerkat.modules.dialogs.changeContent(modalId, htmlContent, function simplesSearchModalChange() {

				});
	}

	meerkat.modules.register('simplesScriptingEditor', {
		init: init,
		events: moduleEvents
	});

})(jQuery);
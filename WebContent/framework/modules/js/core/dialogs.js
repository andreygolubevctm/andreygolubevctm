////////////////////////////////////////////////////////////
//// SIMPLE DIALOG                                      ////
////----------------------------------------------------////
//// This allows you to display a simple dialog modal   ////
//// window using bootstrap								////
////////////////////////////////////////////////////////////
/*

USAGE EXAMPLE: Call directly

		// Open the modal
		var modalId = meerkat.modules.dialogs.show({
			htmlContent: '<p>Hello!</p>',
			buttons: [{
				label: 'Close',
				className: 'btn-primary',
				closeWindow: true
			}],
			onOpen: function(id) {
				// Switch content
				meerkat.modules.dialogs.changeContent(id, '<iframe src="ajax/html/example.jsp"></iframe>');
			}
		});

		// Close and destroy the modal
		meerkat.modules.dialogs.close(modalId);

*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;

	var windowCounter = 0,
		dialogHistory = [],
		openedDialogs = [],
		defaultSettings = {
			title: '',
			htmlContent: null,
			url: null,
			cacheUrl: false,
			buttons: [],
			className: '',
			hashId: null,
			closeOnHashChange: false,
			fullHeight: false, // By default, a modal shorter than the viewport will be centred. Set to true to vertically fill the viewport.
			/*jshint -W112 */
			templates: {
				dialogWindow:
					'<div id="{{= id }}" class="modal" tabindex="-1" role="dialog" aria-labelledby="{{= id }}_title" aria-hidden="true"{{ if(fullHeight===true){ }} data-fullheight="true"{{ } }}>
						<div class="modal-dialog {{= className }}">
							<div class="modal-content">
								<div class="modal-closebar">
									<a href="javascript:;" class="btn btn-close-dialog"><span class="icon icon-cross"></span></a>
								</div>
								{{ if(title != "" ){ }}
								<div class="modal-header"><h4 class="modal-title" id="{{= id }}_title">{{= title }}</h4></div>
								{{ } }}
								<div class="modal-body">
									{{= htmlContent }}
								</div>
								{{ if(typeof buttons !== "undefined" && buttons.length > 0 ){ }}
									<div class="modal-footer {{ if(buttons.length > 1 ){ }} mustShow {{ } }}">
										{{ _.each(buttons, function(button, iterator) { }}
											<button data-index="{{= iterator }}" type="button" class="btn {{= button.className }} ">{{= button.label }}</button>
										{{ }); }}
									</div>
								{{ } }}
							</div>
						</div>
					</div>'},
			/*jshint +W112 */
			onOpen: function(dialogId) {},
			onClose: function(dialogId) {},
			onLoad: function(dialogId) {}
		}

	function show(instanceSettings){

		var settings = $.extend({}, defaultSettings, instanceSettings);
		isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;

		var id = "mkDialog_"+windowCounter;
		if(!_.isUndefined(settings.id)) {
			if(isDialogOpen(settings.id)) {
				close(settings.id);
			}
		} else {
			settings.id = id;
			windowCounter++;
		}

		if(settings.hashId != null){
			// append the dialogs hash id to the window hash.
			meerkat.modules.address.appendToHash(settings.hashId);
		}

		var htmlTemplate = _.template(settings.templates.dialogWindow);

		if(settings.url != null || settings.externalUrl != null){
			// Load content from dynamic source, insert loading icon until content loads
			settings.htmlContent = meerkat.modules.loadingAnimation.getTemplate();
		}

		var htmlString = htmlTemplate(settings);
		$("#dynamic_dom").append(htmlString);

		var $modal = $('#'+settings.id);

		$modal.modal({
			show: true,
			backdrop: settings.buttons && settings.buttons.length > 0 ? 'static' : true,
			keyboard: false
		});

		// Wait for Bootstrap to tell us it has closed a modal, then run our own close functions.
		$modal.on('hidden.bs.modal', function (event) {
			if (typeof event.target === 'undefined') return;
			var $target = $(event.target);
			if ($target.length === 0 || $target.hasClass('modal') === false) return;

			// Run our close functions
			doClose($target.attr('id'));
		});

		$modal.find('button').on('click', function onModalButtonClick(eventObject) {
			var button = settings.buttons[$(eventObject.currentTarget).attr('data-index')];

			// If this is a close button, tell Bootstrap to close the modal
			if(button.closeWindow === true){
				$(eventObject.currentTarget).closest('.modal').modal('hide');
			}

			// Run the callback
			if (typeof button.action === 'function') button.action(eventObject);
		});

		if (settings.url != null) {
			meerkat.modules.comms.get({
				url: settings.url,
				cache: settings.cacheUrl,
				errorLevel: "warning",
				onSuccess: function dialogSuccess(result) {
					changeContent(settings.id, result);

					// Run the callback
					if (typeof settings.onLoad === 'function') settings.onLoad(settings.id);
				}
			});
		}

		if(settings.externalUrl != null) {
			var iframe = '<iframe class="displayNone" id="' + settings.id + '_iframe" width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true" src="' + settings.externalUrl + '"></iframe>';
			appendContent(settings.id, iframe);

			$('#' + settings.id + '_iframe').on("load", function(){
				
				// calculate size of iframe content
				// console.log("scoll height", this.contentWindow.document.body.scrollHeight);
				//console.log("height", this.contentWindow.document.body.height);

				// show the iframe
				$(this).show();

				// remove the loading
				meerkat.modules.loadingAnimation.hide( $('#'+settings.id) );

			});
		}

		/**
		 * Had to add a slight delay before calculating heights as it seems the DOM is not
		 * always ready after the previous DOM manipulations (either 0 or incorrect height)
		 * see window.setTimout after this.
		 */
		window.setTimeout( function(){
			resizeDialog(settings.id);
		}, 0 );

		// Run the callback
		if (typeof settings.onOpen === 'function') settings.onOpen(settings.id);

		openedDialogs.push(settings);

		return settings.id;
	}

	// Tell Bootstrap to close this modal
	// Our follow-up close/destroy methods will run when we receive the hidden.bs.modal event
	function close( dialogId ){
		$('#' + dialogId).modal('hide');
	}

	function doClose(dialogId) {
		// Run the callback
		var settings = getSettings(dialogId);
		if (settings !== null && typeof settings.onClose === 'function') settings.onClose( dialogId );

		destroyDialog(dialogId);
	}

	function calculateLayout(eventObject){
		$("#dynamic_dom .modal").each(function resizeModalItem(index, element){
			resizeDialog($(element).attr('id'));
		});
	}

	function changeContent(dialogId, htmlContent, callback) {
		$('#' + dialogId + ' .modal-body').html(htmlContent);

		if (typeof callback === 'function') {
			callback();
		}

		calculateLayout();
	}

	function appendContent(dialogId, htmlContent) {
		$('#' + dialogId + ' .modal-body').append(htmlContent);
		calculateLayout();
	}

	function resizeDialog(dialogId) {
		isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;

		var $dialog = $("#" + dialogId);

		if ($dialog.find(".modal-header").outerHeight(true) === 0) {
			window.setTimeout( function(){
				resizeDialog(dialogId);
			}, 20);
		} else {
			var viewport_height,
				content_height,
				dialogTop,
				$modalContent = $dialog.find(".modal-content"),
				$modalDialog = $dialog.find(".modal-dialog");

			viewport_height = $(window).height();

			if (!isXS) {
				viewport_height -= 60; // top and bottom margin.
			}

			content_height = viewport_height;
			content_height -= $dialog.find(".modal-header").outerHeight(true);
			content_height -= $dialog.find(".modal-footer").outerHeight(true);
			content_height -= $dialog.find(".modal-closebar").outerHeight(true);

			// On XS, the modal fills the whole viewport.
			// Put the modals to the top of XS so the "X" close icon overlaps the navbar correctly.
			if (isXS) {
				$modalContent.css('height', viewport_height);
				$dialog.find(".modal-body").css('height', content_height);

				dialogTop = 0;
				$modalDialog.css('top', dialogTop);
			}
			else {
				// Set the max height for the modal overall, so it fits in the viewport
				$modalContent.css('max-height', viewport_height);

				// If specified, default the modal to vertically fill the viewport
				if ($dialog.attr('data-fullheight') === "true") {
					$modalContent.css('height', viewport_height);
				}

				// Set the max height on the body of the modal so it is scrollable
				$dialog.find(".modal-body").css('max-height', content_height);

				// Position the modal vertically centred
				dialogTop = (viewport_height/2) - ($modalDialog.height()/2);

				if ($modalContent.height() < viewport_height ) {
					dialogTop = dialogTop/2;
				}

				$modalDialog.css('top', dialogTop);
			}

		}

	}

	function destroyDialog(dialogId) {
		if (!dialogId || dialogId.length === 0) return;

		var $dialog = $("#" + dialogId);
			$dialog.find('button').unbind();
			$dialog.remove();

		var settings = getSettings(dialogId);

		if (settings != null) {
			if (settings.hashId != null) {
				meerkat.modules.address.removeFromHash(settings.hashId)

				var previousInstance = _.findWhere(dialogHistory, {hashId:settings.hashId});
				if(previousInstance == null) dialogHistory.push(settings);
			}

			openedDialogs.splice(settings.index, 1);
		}

	}

	function getSettings(dialogId){
		var index = getDialogSettingsIndex(dialogId);
		if(index !== null){
			openedDialogs[index].index = index;
			return openedDialogs[index];
		}
		return null;
	}

	function getDialogSettingsIndex(dialogId){
		for(var i=0;i<openedDialogs.length;i++){
			if(openedDialogs[i].id == dialogId) return i;
		}
		return null;
	}

	function isDialogOpen(dialogId) {
		return !_.isNull(getDialogSettingsIndex(dialogId));
	}

	// Initialise Dev helpers
	function initDialogs() {

		// Set up touch events on touch devices
		$(document).ready(function() {

			// Bind the default close button
			$(document).on('click', '.btn-close-dialog', function() {
				$(this).closest('.modal').modal('hide');
			});

			if (!Modernizr.touch) return;

			// Stop the background page being scrollable when a modal is open (doesn't work on mobiles really)
			$(document).on('touchmove', '.modal', function(e) {
				e.preventDefault();
			});
			// Allow the modal body to be scrollable
			$(document).on('touchmove', '.modal .modal-body', function(e) {
				e.stopPropagation();
			});
		});

		var self = this;

		meerkat.messaging.subscribe(meerkatEvents.dynamicContentLoading.PARSED_DIALOG, function dialogClicked( event ){

			var dialogInfoObject;

			var hashValue = event.element.attr('data-dialog-hash-id');
			var hashId = null;
			if(hashValue !== '') hashId = hashValue;

			if(event.contentType === 'url'){

				dialogInfoObject = {
					title: event.element.attr('data-title'),
					url: event.contentValue,
					cacheUrl: (event.element.attr('data-cache') ? true : false)
				};
			} else if(event.contentType === 'externalUrl'){
				
				dialogInfoObject = {
					title: event.element.attr('data-title'),
					externalUrl: event.contentValue
				};

			} else {

				dialogInfoObject = {
					title: $( event.contentValue ).attr('data-title'),
					htmlContent: event.contentValue
				};

			}

			var instanceSettings = $.extend({
					hashId: hashId,
					closeOnHashChange: true,
					className: event.element.attr('data-class')
				},
				dialogInfoObject
			);

			show(instanceSettings);

		});

		// Listen for window resizes to reposition and resize dialog windows.
		var lazyLayout = _.debounce(calculateLayout, 300);
		$(window).resize(lazyLayout);

		// Listen for hash changes and close any dialog which requested to be closed on hash change.
		meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function dialogHashChange(event){

			// find windows which need to be closed.
			for(var i=openedDialogs.length-1;i>=0;i--){
				var dialog = openedDialogs[i];
				if(dialog.closeOnHashChange === true){
					if(_.indexOf( event.hashArray, dialog.hashId) == -1){
						self.close(dialog.id);
					}
				}
			}

			// find windows which need to be opened.
			for(var j=0; j<event.hashArray.length;j++){
				var windowOpen = _.findWhere(openedDialogs, {hashId:event.hashArray[j]});
				if(windowOpen == null){
					var previousInstance = _.findWhere(dialogHistory, {hashId:event.hashArray[j]});
					if(previousInstance != null) meerkat.modules.dialogs.show(previousInstance);

				}
			}

		}, window);

	}

	meerkat.modules.register('dialogs', {
		init: initDialogs,
		show: show,
		changeContent: changeContent,
		close: close,
		isDialogOpen: isDialogOpen
	});


})(jQuery);
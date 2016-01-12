;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		debug = meerkat.logging.debug,
		exception = meerkat.logging.exception;

	var events = {
		writeQuote: {

		}
	},
	watchedFields = null,
	autoSaveTimeout = null,
	autoSaveTimeoutMs = 3000,
	liteXhrRequest = false,
	dataValues = {};

	function init() {
		if(meerkat.site.isCallCentreUser === false) {
			initWriteQuoteLite();
		}
	}

	/**
	 * This will only initialise if the journey has watchedFields outputted to it's vertical settings
	 * tag via content control table.
	 */
	function initWriteQuoteLite() {

		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function() {

			if(typeof meerkat.site.watchedFields == 'undefined' || meerkat.site.watchedFields === '') {
				return false;
			}

			watchedFields = meerkat.site.watchedFields;
			if(!$(watchedFields).length) {
				debug('[writeQuote] No fields identified from selector provided.');
				return false;
			}

			$(watchedFields).attr('data-autoSave',"true");
			setDefaultValues();

			_.defer(function() {
				eventSubscriptions();
				applyEventListeners();
			});
		});
	}

	function applyEventListeners() {

		/**
		 * Only monitor focus or change events on the currently active slide,
		 * and lastFieldTouch element.
		 * Note: may be more outside the current slide that may want to be tracked in other verticals.
		 */
		$(document).on('change', '.journeyEngineSlide.active :input[data-autoSave]', function() {
				triggerSaveTimeout($(this));
		}).on('focus', '.journeyEngineSlide.active :input[data-autoSave]', function() {
				triggerSaveTimeout($(this));
		});
	}
	/**
	 * Reset the default values object so that the dataValues object matches what it currently is set to.
	 */
	function setDefaultValues() {
		$(':input', $('.journeyEngineSlide')).each(function() {
			setDataValueForField($(this));
		});
	}
	/**
	 * Subscribe to the step changed, to kill any pending lite requests or timeouts, and reset default values.
	 * E.G. if step 2 has no monitors, and you proceed to step 3, it will run an update on all fields
	 * changed in step 2, to change them, even though the "next step" saved them.
	 */
	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function() {
			if( autoSaveTimeout ) {
				clearTimeout(autoSaveTimeout);
			}
			if(liteXhrRequest !== false) {
				if(typeof liteXhrRequest.state === 'function' && liteXhrRequest.state() == 'pending') {
					liteXhrRequest.abort();
				}
			}
			/**
			 * Must reset default values here.
			 * E.G. if not monitoring step 2, and you fill out all the fields and go to step 3 and trigger a write quote lite,
			 * It will send all the data values on step 2, but they were already sent in the "next step" write quote.
			 */
			setDefaultValues();
		});
	}

	/**
	 * Set the value to the object to identify if it was modified, without needing
	 * to track change events which e.g. doesn't work for vehicle selector.
	 */
	function setDataValueForField($el) {
		var xpath = getXpathFromElement($el);
		if(xpath !== false) {
			dataValues[xpath] = getValue($el);
		}
	}

	/**
	 * @param {jQuery} $el The :input element
	 */
	function getXpathFromElement($el) {
		return $el.attr('name') || $el.attr('id') || false;
	}
	/**
	 * @param {jQuery} $el The :input element
	 */
	function getValue($el) {
		if($el.attr('type') == 'radio' || $el.attr('type') == 'checkbox') {
			return $('input[name='+$el.attr('name')+']:checked').val() || "";
		}
		return $el.val();
	}

	/**
	 * Handles clearing old timeouts and starting the new timeout.
	 * Always cancel the timeout if another request is running.
	 * @param {Event} event
	 */
	function triggerSaveTimeout($el) {
		if( autoSaveTimeout ||
			( autoSaveTimeout && typeof liteXhrRequest !== false && typeof liteXhrRequest.state === 'function' && liteXhrRequest.state() == 'pending' ) ) {
			//debug('[writeQuote]', 'Clearing Timeout');
			clearTimeout(autoSaveTimeout);
		}
		//debug('[writeQuote]', 'Starting timeout on ' + $el.attr('name'));
		autoSaveTimeout = setTimeout(writeQuoteLite, autoSaveTimeoutMs);
	}
	/**
	 *
	 */
	function writeQuoteLite() {

		var data = [];
		/**
		 * Add any elements to the loop that are outside journeyEngineSlide that you want to include.
		 * Note: any elements added here will update every time if they are different like lastFieldTouch
		 * Note: this will also work with any elements rendered via a template.
		 */
		$(':input', $('.journeyEngineSlide'))
		.add($('input[id*=lastFieldTouch]'))
		.each(function() {
			var $el = $(this),
			xpath = getXpathFromElement($el);

			if(xpath !== false) {
				var value = getValue($el);
				/**
				 * If the current element's value is different to what it is in the object, we
				 * need to send it to the server.
				 */
				if(dataValues[xpath] !== value) {
					data.push({
						name: xpath,
						value: value
					});
					dataValues[xpath] = value;
				}
			}
		});

		if(!data.length) {
			return;
		}
		/**
		 * Only if there is something to change, append the stage.
		 */
		if(meerkat.modules.journeyEngine.getCurrentStep() !== null) {
			data.push({
				name: $('.journey_stage').attr('name'),
				value: meerkat.modules.journeyEngine.getCurrentStep().navigationId
			});
		}

		data.push({
			name: 'hasPrivacyOptin',
			value: meerkat.modules.optIn.isPrivacyOptedIn()
		});

		//debug('[writeQuote]', 'Running AJAX Request');
		liteXhrRequest = meerkat.modules.comms.post({
			url: "/" + meerkat.site.urls.context + "quote/write_lite.json",
			data: data,
			dataType: 'json',
			timeout: 20000,
			numberOfAttempts: 1,
			cache: false,
			returnAjaxObject: true,
			errorLevel: "silent",
			useDefaultErrorHandling: false
		});

	}
	/******************************/

	/**
	 * @param {JSON} extraDataToSave e.g. {blah:"blah", plop:"plop"}
	 * @param {Boolean} triggerFatalError
	 * @param {Function} callback
	 */
	function write( extraDataToSave, triggerFatalError, callback ){

		var data = [];

		$.extend(data, meerkat.modules.journeyEngine.getFormData());

		data.push({
			name: 'quoteType',
			value: meerkat.site.vertical
		});
		// may be used on pages that don't have journey engines.
		if(meerkat.modules.journeyEngine.getCurrentStep() !== null) {
			data.push({
				name: 'stage',
				value: meerkat.modules.journeyEngine.getCurrentStep().navigationId
			});
		}

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
			url: "/" + meerkat.site.urls.context + "ajax/write/write_quote.jsp",
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
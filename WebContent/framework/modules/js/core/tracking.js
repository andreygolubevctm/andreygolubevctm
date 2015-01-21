;(function($, undefined){

	var meerkat = window.meerkat;

	var events = {
			tracking: {
				TOUCH: 'TRACKING_TOUCH',
				EXTERNAL: 'TRACKING_EXTERNAL'
			}
		},
		moduleEvents = events.tracking;

	var lastFieldTouch = null;
	var lastFieldTouchXpath = null;

	function recordTouch(touchType, touchComment, includeFormData, callback){

		var data = [];
		if(includeFormData){
			data = meerkat.modules.journeyEngine.getFormData();
		}

		data.push({
			name: 'quoteType',
			value: meerkat.site.vertical
		});
		data.push({
			name: 'touchtype',
			value: touchType
		});
		data.push({
			name: 'comment',
			value: touchComment
		});

		meerkat.modules.comms.post({
			url: 'ajax/json/access_touch.jsp',
			data: data,
			errorLevel: "silent",
			onSuccess: function recordTouchSuccess(result){
				if (typeof callback === "function") callback(result);
			}
		});
	}
	/**
	 * CTMIT-64 Testing recordDTM
	 *
	 */
	function recordDTM(method, value) {
		try {
			if(typeof _satellite === 'undefined'){
				throw "_satellite is undefined";
			}

			for(var key in value) {
				if(value.hasOwnProperty(key)
						&& typeof value[key] !== 'function') {
					if(value[key] !== null) {
						var setVarValue = typeof value[key] === 'string' ? value[key].toLowerCase() : value[key];
						_satellite.setVar(key, setVarValue);
					} else {
						_satellite.setVar(key, "");
					}
				}
			}
			meerkat.logging.info("DTM", method, value);
			_satellite.track(method);


		} catch(e) {
			meerkat.logging.info("_satellite catch", method, value, e);
		}
	}

	function recordSupertag(method, value){
		try{
			if(typeof superT === 'undefined'){
				throw "Supertag is undefined";
			}

					superT[method](value);
					meerkat.logging.info("Supertag", method, value);

		}catch(e){
			meerkat.logging.info("Supertag catch", method, value, e);
		}
	}

	function getEmailId(emailAddress, marketing, oktocall, callback) {

		return meerkat.modules.comms.post({
			url: "ajax/json/get_email_id.jsp",
			data: {
				vertical:meerkat.site.vertical,
				email:emailAddress,
				m:marketing,
				o:oktocall
			},
			cache: true,
			errorLevel: "silent"
		});

	}

	function updateLastFieldTouch(label) {
		if(!_.isUndefined(label) && !_.isEmpty(label)) {
			lastFieldTouch = label;
			$('#' + lastFieldTouchXpath).val(lastFieldTouch);
			//meerkat.logging.debug('last touched field: ' + lastFieldTouch);
		}
	}

	function applyLastFieldTouchListener() {

		$('form input, form select').on('click focus', function (e) {
			updateLastFieldTouch( $(this).closest(':input').attr('name') );
		});

		$('a[data-slide-control]').on('click', function() {
			updateLastFieldTouch( $(this).attr('data-slide-control') + '-' + meerkat.modules.journeyEngine.getCurrentStep().navigationId );
		});

		/* It may be necessary to add vertical/module specific listeners that
		 * are not captured above. Eg the datepicker has a listener on its
		 * change event that will call updateLastFieldTouch.
		 */
	}

	function initLastFieldTracking() {

		var vertical = meerkat.site.vertical;
		vertical = vertical === 'car' ? 'quote' : vertical;
		lastFieldTouchXpath = vertical + '_lastFieldTouch';

		// Append tracking field to form so that it's value can also exist as an xpath
		$('#mainform').append($('<input/>',{
			type:	'hidden',
			name:	lastFieldTouchXpath,
			id:		lastFieldTouchXpath,
			value:	''
		}));

		applyLastFieldTouchListener();
	}

	function initTracking() {

		$(document).on("click", "a[data-tracking-type]", function onTrackedLinkClick(eventObject){
			var touchType = $(eventObject.currentTarget).attr('data-tracking-type');
			var touchValue = $(eventObject.currentTarget).attr('data-tracking-value'); // optional.
			meerkat.modules.tracking.recordTouch(touchType, touchValue);
		});

		$(document).on("click", "a[data-supertag-method]", function onTrackedSupertagLinkClick(eventObject){
			var supertagMethod = $(eventObject.currentTarget).attr('data-supertag-method');
			var supertagValue = $(eventObject.currentTarget).attr('data-supertag-value');
			meerkat.modules.tracking.recordSupertag(supertagMethod, supertagValue);
		});

		meerkat.messaging.subscribe(moduleEvents.TOUCH, function(eventObject) {
			if (typeof eventObject === 'undefined') return;

			var includeFormData = false;
			if(typeof eventObject.includeFormData !== 'undefined' && eventObject.includeFormData === true) includeFormData = true;

			recordTouch(eventObject.touchType, eventObject.touchComment, includeFormData, eventObject.callback);
		});

		meerkat.messaging.subscribe(moduleEvents.EXTERNAL, runTrackingCall);

		$(document).ready(function(){

			initLastFieldTracking();
			if(typeof meerkat !== 'undefined' && typeof meerkat.site !== 'undefined' && typeof meerkat.site.tracking !== 'undefined'
				&& meerkat.site.tracking.userTrackingEnabled === true) {
				meerkat.modules.utilities.pluginReady('sessionCamRecorder').done(function() {
					initUserTracking();
				});
			}
		});

	}

	function runTrackingCall(eventObject, override) {

			// override: is to bypass the eventObject being overwritten by updateObjectData
			override = override || false;

		if (typeof eventObject === 'undefined') {
			return;
		}

		if(typeof meerkat.site.tracking !== 'object') {
				meerkat.site.tracking = {};
		}

			// Create the value object here, to reduce duplicate code.
			var values, object = eventObject.object;

			if(meerkat.site.tracking.superTagEnabled === true || meerkat.site.tracking.DTMEnabled === true) {
			values = typeof object === 'function' ? object() : object;
				} else{
				// just set it to what it originally was.
				values = object;
			}

			// Add defaults to values if required
			values = override === false ? updateObjectData(values) : values;

			// Set a resolved promise to start with.
			var deferred = $.Deferred().resolve().promise();
			if(typeof values === 'object') {

				if(values.email !== null && values.email !== '' && values.emailID === null) {
				// Reset var deferred to the deferred result of the XHR object
					deferred = getEmailId(values.email, values.marketOptIn, values.okToCall).done(function(result) {
						if(typeof result.emailId !== 'undefined') {
							values.emailID = result.emailId;
							values.email = null;
						}
					});
				}
			}

		// run when it is either resolved OR rejected (emailID would just be null if failed).
			deferred.always(function() {
			if(meerkat.site.tracking.superTagEnabled === true) {
					recordSupertag(eventObject.method, values);
			}

			if(meerkat.site.tracking.DTMEnabled === true) {
					recordDTM(eventObject.method, values);
			}
		});
			}

	function getCurrentJourney() {
		return meerkat.modules.splitTest.get();
	}

	function getTrackingVertical() {
		// Add any other vertical label overrides here
		var vertical = meerkat.site.vertical;
		if(vertical === 'home') {
			vertical = 'Home_Contents';
		}

		return vertical;
	}

	/**
	 * To prefill certain global values between different tracking methods.
	 */
	function updateObjectData(object) {

		if (typeof object.brandCode === "undefined") {
			object.brandCode = meerkat.site.tracking.brandCode;
		}

		if (typeof object.transactionID === "undefined") {
			object.transactionID = meerkat.modules.transactionId.get();
		}

		if (typeof object.rootID === "undefined") {
			object.rootID = meerkat.modules.transactionId.getRootId();
		}

		if (typeof object.currentJourney === "undefined") {
			object.currentJourney = getCurrentJourney();
		}

		if (typeof object.vertical === "undefined") {
			object.vertical = getTrackingVertical();
		}

		if (typeof object.simplesUser === "undefined") {
			object.simplesUser = meerkat.site.isCallCentreUser;
		}

		if (typeof object.contactCentreID === "undefined") {
			object.contactCentreID = meerkat.site.userId || null;
		}

		if (typeof object.campaignID === "undefined") {
			object.campaignID = $('input[name$=tracking_cid]').val() || null;
		}

		if (typeof object.verticalFilter === "undefined") {
			object.verticalFilter = (typeof meerkat.modules[meerkat.site.vertical].getVerticalFilter === 'function' ? meerkat.modules[meerkat.site.vertical].getVerticalFilter() : null);
		}

		// Always ensure the tracking key exists
		object.trackingKey = meerkat.modules.trackingKey.get();

		object.lastFieldTouch = lastFieldTouch;

		return object;
	}

	/**
	 * For sessioncam
	 */
	function initUserTracking() {

		if(typeof window.sessionCamRecorder === 'undefined') {
			return;
		}
		if(typeof window.sessioncamConfiguration !== 'object') {
			window.sessioncamConfiguration = {};
		}
		if(typeof window.sessioncamConfiguration.customDataObjects !== 'object') {
			window.sessioncamConfiguration.customDataObjects = [];
		}
		var item = {
				key: "transactionId",
				value: meerkat.modules.transactionId.get()
		};
		window.sessioncamConfiguration.customDataObjects.push(item);
		item = {
				key: "brandCode",
				value: meerkat.site.tracking.brandCode
		};
		window.sessioncamConfiguration.customDataObjects.push(item);
		item = {
				key: "vertical",
				value: meerkat.site.vertical
		};
		window.sessioncamConfiguration.customDataObjects.push(item);
		item = {
				key: "rootID",
				value: meerkat.modules.transactionId.getRootId()
		};
		window.sessioncamConfiguration.customDataObjects.push(item);
		item = {
				key: "currentJourney",
				value: getCurrentJourney
		};
		window.sessioncamConfiguration.customDataObjects.push(item);
	}

	meerkat.modules.register("tracking", {
		init: initTracking,
		events: events,
		recordTouch: recordTouch,
		recordSupertag: recordSupertag,
		updateLastFieldTouch: updateLastFieldTouch,
		applyLastFieldTouchListener: applyLastFieldTouchListener,
		getCurrentJourney: getCurrentJourney,
		updateObjectData: updateObjectData,
		getTrackingVertical: getTrackingVertical
	});

})(jQuery);
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
	function recordDTM(method, object) {
		var value;
		try {
			if(typeof _satellite === 'undefined'){
				throw "_satellite is undefined";
			}

			if(typeof object ==='function'){
				value = object();
			}else{
				value = object;
			}

			value = updateObjectData(value);

			// Set it to a resolved promise
			var deferred = $.Deferred().resolve().promise();

			if(value.email !== null && value.email !== '' && value.emailID === null) {
				// Reset it to the result of the XHR object
				deferred = getEmailId(value.email, value.marketOptIn, value.okToCall).done(function(result) {
					if(typeof result.emailId !== 'undefined') {
						value.emailID = result.emailId;
						value.email = null;
			}
				});
			}

			deferred.always(function() {
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
			});


		} catch(e) {
			meerkat.logging.info("_satellite catch", method, value, e);
		}
	}

	function recordSupertag(method, object){
		var value;
		try{
			if(typeof superT === 'undefined'){
				throw "Supertag is undefined";
			}

			if(typeof object ==='function'){
				value = object();
			}else{
				value = object;
			}

			value = updateObjectData(value);

			// Set it to a resolved promise
			var deferred = $.Deferred().resolve().promise();

			if(value.email !== null && value.email !== '' && value.emailID === null){
				// Reset it to the result of the XHR object
				deferred = getEmailId(value.email, value.marketOptIn, value.okToCall).done(function(result) {
					if(typeof result.emailId !== 'undefined') {
						value.emailID = result.emailId;
						value.email = null;
			}
				});
			}

			deferred.always(function(result) {
					superT[method](value);
					meerkat.logging.info("Supertag", method, value);
				});

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

		meerkat.messaging.subscribe(moduleEvents.EXTERNAL, function(eventObject){
			if (typeof eventObject === 'undefined') return;

			if(typeof meerkat.site.tracking !== 'object')
				meerkat.site.tracking = {};

			if(meerkat.site.tracking.superTagEnabled === true) {
				recordSupertag(eventObject.method, eventObject.object);
			}

			if(meerkat.site.tracking.DTMEnabled === true) {
				recordDTM(eventObject.method, eventObject.object);
			}
		});

		$(document).ready(function(){
			initLastFieldTracking();
			if(meerkat.site.userTrackingEnabled === true) {
				meerkat.modules.utilities.pluginReady('sessionCamRecorder').done(function() {
					initUserTracking();
				});
			}
		});

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

		object.lastFieldTouch = lastFieldTouch;

		return object;
	}

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
		var item = { key: "transactionId", value: meerkat.modules.transactionId.get() };
		window.sessioncamConfiguration.customDataObjects.push(item);
	}

	meerkat.modules.register("tracking", {
		init: initTracking,
		events: events,
		recordTouch: recordTouch,
		recordSupertag: recordSupertag,
		updateLastFieldTouch: updateLastFieldTouch,
		applyLastFieldTouchListener: applyLastFieldTouchListener
	});

})(jQuery);
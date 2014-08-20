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

	function recordSupertag(method, object){
		var value;
		try{
			if(typeof object ==='function'){
				value = object();
			}else{
				value = object;
			}

			if(typeof superT === 'undefined'){
				throw "Supertag is undefined";
			}

			if (typeof value.brandCode === "undefined") {
				value.brandCode = meerkat.site.tracking.brandCode;
			}

			value.lastFieldTouch = lastFieldTouch;

			if(value.email !== null && value.email !== '' && value.emailID === null){
				getEmailId(value.email, value.marketOptIn, value.okToCall, function getEmailId(emailId){
					value.emailID = emailId;
					value.email = null;
					superT[method](value);
					meerkat.logging.info("Supertag", method, value);
				});
			}else{
				superT[method](value);
				meerkat.logging.info("Supertag", method, value);
			}


		}catch(e){
			meerkat.logging.info("Supertag catch", method, value, e);
		}
	}

	function getEmailId(emailAddress, marketing, oktocall, callback) {

		meerkat.modules.comms.post({
			url: "ajax/json/get_email_id.jsp",
			data: {
				vertical:meerkat.site.vertical,
				email:emailAddress,
				m:marketing,
				o:oktocall
			},
			errorLevel: "silent",
			onSuccess: function onSuccess(result){
				callback(result.emailId);
			}
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

			recordSupertag(eventObject.method, eventObject.object);
		});

		$(document).ready(function(){
			initLastFieldTracking();
		});

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
;(function($, undefined){

	var meerkat = window.meerkat;

	var events = {
			tracking: {
				TOUCH: 'TRACKING_TOUCH',
				EXTERNAL: 'TRACKING_EXTERNAL'
			}
		},
		moduleEvents = events.tracking;



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
				brand:meerkat.site.brand,
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

	}

	meerkat.modules.register("tracking", {
		init: initTracking,
		events: events,
		recordTouch: recordTouch,
		recordSupertag: recordSupertag
	});

})(jQuery);
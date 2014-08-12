/**
 * Comms.js is an abstracted $.ajax handler, it is not a wrapper as it doesn't return the same thing as $.ajax does.
 * E.G. $.ajax(settings).done(function(result) { } ); will have the success result object as a parameter.
 * comms.get.done(function(result) { } ); result will be undefined, as the ajax function in here, returns $.ajax().then, not $.ajax.
 */
;(function($, undefined){

	var meerkat = window.meerkat;

	var cache = [];

	var CHECK_AUTHENTICATED_LABEL = "checkAuthenticated";

	var requestPool = [];

	var defaultSettings = {
		url: 'not-set',
		data: null,
		dataType: false,
		numberOfAttempts: 1,
		attemptCallback: null,
		timeout: 60000,
		cache: false,
		// errorLevel
		//    mandatory
		//    silent (only log in the db)
		//    warning (visible to user but can go back to page)
		//    fatal (visible to user and forces page refresh)
		errorLevel: null,
		// useDefaultErrorHandling: By default allow comms to handle errors. Set to false to do your own error handling.
		useDefaultErrorHandling:true,
		// returnAjaxObject: By default the comms.ajax() function will return the Deferred .then object. Set this to true to return the parent ajax object.
		returnAjaxObject: false,
		onSuccess: function(result, textStatus, jqXHR){
			//
		},
		onError: function(jqXHR){
			// custom optional callback
		},
		onComplete: function(jqXHR, textStatus){

		},
		onErrorDefaultHandling: function(jqXHR, textStatus, errorThrown, settings, data) {

			var statusMap = {
				'400': "There was a problem with the last request to the server [400]. Please try again.",
				'401': "There was a problem accessing the data for the last request [401].",
				'403': "There was a problem accessing the data for the last request [403].",
				'404': "The requested page could not be found [404]. Please try again.",
				'412': "Supplied parameters failed to meet preconditions [412].",
				'500': "There was a problem with your last request to the server [500]. Please try again.",
				'503': "There was a problem with your last request to the server [503]. Please try again."
			};

			var message = '';

			var errorObject = {
					errorLevel:		settings.errorLevel,
					message:		message,
					page:			'comms.js',
					description:	"Error loading url: " + settings.url + ' : ' + textStatus + ' ' + errorThrown,
					data:			data
			};

			if(jqXHR.status && jqXHR.status != 200){
				message = statusMap[jqXHR.status];
			}else if(textStatus=='parsererror'){
				message += "There was a problem handling the response from the server [parsererror]. Please try again.";
			}else if(textStatus=='timeout'){
				message += "There was a problem connecting to the server. Please check your internet connection and try again. [Request Time out].";
			}else if(textStatus=='abort'){
				message += "There was a problem handling the response from the server [abort]. Please try again.";
			}

			if((!message || message === '') && errorThrown == CHECK_AUTHENTICATED_LABEL) {

				message="Your Simples login session has been lost. Please open Simples in a separate tab, login, then you can continue with this quote.";

				if(!meerkat.modules.dialogs.isDialogOpen(CHECK_AUTHENTICATED_LABEL)) {
					// Take user back to previous step
					meerkat.modules.journeyEngine.gotoPath('previous');
				}

				$.extend(errorObject, {
					errorLevel:'warning',
					id:CHECK_AUTHENTICATED_LABEL
				});
			} else if(!message || message === ''){
				message="Unknown Error";
			}

			$.extend(errorObject, {message:message});

			if(errorThrown != CHECK_AUTHENTICATED_LABEL || (errorThrown == CHECK_AUTHENTICATED_LABEL && !meerkat.modules.dialogs.isDialogOpen(CHECK_AUTHENTICATED_LABEL))) {
				meerkat.modules.errorHandling.error(errorObject);
			}

		}
	};

	function post(instanceSettings){

		var settings = $.extend({}, defaultSettings, instanceSettings);

		if( typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null){
			console.error("Message to dev: please provide an errorLevel to the comms.post() or comms.get() function.");
		}

		var usedCache = checkCache(settings);
		if(usedCache === true) return true;

		// cache:false is not used on this ajax request, please ensure your end point has a no cache header set.

		settings.attemptsCounter = 1;

		return ajax(settings, {
			url: settings.url,
			data: settings.data,
			dataType: settings.dataType,
			type: "POST",
			timeout: settings.timeout
		});

	}

	function get(instanceSettings){

		var settings = $.extend({}, defaultSettings, instanceSettings);

		if( typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null){
			console.error("Message to dev: please provide an errorLevel to the comms.post() or comms.get() function.");
		}

		var usedCache = checkCache(settings);
		if(usedCache === true) return true;

		settings.attemptsCounter = 1;

		return ajax(settings, {
			url: settings.url,
			data: settings.data,
			dataType: settings.dataType,
			type: "GET",
			timeout: settings.timeout
		});

	}

	function ajax(settings, ajaxProperties){

		var tranId = meerkat.modules.transactionId.get();

		try{
			if(ajaxProperties.data == null) {
				ajaxProperties.data = {};
			}

			if (_.isString(ajaxProperties.data)) {
				ajaxProperties.data += '&transactionId=' + tranId;

				if(meerkat.site.isCallCentreUser) {
					ajaxProperties.data += "&" + CHECK_AUTHENTICATED_LABEL + "=true";
				}
			}
			else if (_.isArray(ajaxProperties.data)) {
				// Add the transaction ID to the data payload if it's not already set
				if (_.indexOf(ajaxProperties.data, 'transactionId') === -1) {
					ajaxProperties.data.push({
						name: 'transactionId',
						value: tranId
					});
				}

				if(meerkat.site.isCallCentreUser) {
					ajaxProperties.data.push({
						name: CHECK_AUTHENTICATED_LABEL,
						value: true
					});
				}
			}
			else if (_.isObject(ajaxProperties.data)) {
				// Add the transaction ID to the data payload if it's not already set
				if (ajaxProperties.data.hasOwnProperty('transactionId') === false) {
					ajaxProperties.data.transactionId = tranId;
				}

				if(meerkat.site.isCallCentreUser) {
					ajaxProperties.data[CHECK_AUTHENTICATED_LABEL] = true;
				}
			}

		}catch(e){
		}

		var jqXHR = $.ajax(ajaxProperties);
		var deferred = jqXHR.then(
					function onAjaxSuccess(result, textStatus, jqXHR){
						var data = typeof(settings.data) != "undefined" ? settings.data : null;

						if(containsServerGeneratedError(result) === true) {
						handleError(jqXHR, "Server generated error", result.error, settings, data, ajaxProperties);
						}else{
							if(settings.cache === true)	addToCache(settings.url, data, result);
							if(settings.onSuccess != null) settings.onSuccess(result);
							if(settings.onComplete != null) settings.onComplete(jqXHR, textStatus);
						}

					},
					function onAjaxError(jqXHR, textStatus, errorThrown){
						var data = typeof(settings.data) != "undefined" ? settings.data : null;

					handleError(jqXHR, textStatus, errorThrown, settings, data, ajaxProperties);

						if(settings.onComplete != null) settings.onComplete(jqXHR, textStatus);
					}
				);

		if (settings.hasOwnProperty('returnAjaxObject') && settings.returnAjaxObject === true) {
			return jqXHR;
	}
		else {
			return deferred;
		}
	}

	function addToCache(url, postData, result){
		cache.push({
			url: url,
			postData:postData,
			result:result
		});
	}

	function findInCache(settings){

		for(var i=0;i<cache.length;i++){
			var cacheItem = cache[i];
			if(settings.url === cacheItem.url){
				if(settings.data === null && cacheItem.postData === null){
					// no post data
					return cacheItem;
				}else if(settings.data !== null && cacheItem.postData !== null){
					// compare post data
					if(_.isEqual(settings.data, cacheItem.postData)){
						return cacheItem;
					}
				}

			}

		}

		return null;

	}

	function checkCache(settings){
		if(settings.cache === true){
			var cachedResult = findInCache(settings);
			if(cachedResult !== null){
				meerkat.logging.info("Retrieved from cache",cachedResult);
				if(settings.onSuccess != null) settings.onSuccess(cachedResult.result);
				if(settings.onComplete != null) settings.onComplete();
				return true;
			}
		}

		return false;
	}

	function containsServerGeneratedError(data){
		if (typeof data.error !== 'undefined' || (typeof data.errors !== 'undefined' && data.errors.length > 0)) {
			return true;
		}

		return false;
	}

	function handleError(jqXHR, textStatus, errorThrown, settings, data, ajaxProperties){

		if(settings.numberOfAttempts > settings.attemptsCounter++) {
			ajax(settings, ajaxProperties);
		} else {
		if (typeof settings === 'undefined') {
			settings = {};
		}

		if(settings.useDefaultErrorHandling){
			settings.onErrorDefaultHandling(jqXHR, textStatus, errorThrown, settings, data);
		}

		if (settings.onError != null) {
			settings.onError(jqXHR, textStatus, errorThrown, settings, data);
		}
	}
	}

	function getCheckAuthenticatedLabel() {
		return CHECK_AUTHENTICATED_LABEL;
	}


	meerkat.modules.register("comms", {
		post: post,
		get: get,
		getCheckAuthenticatedLabel: getCheckAuthenticatedLabel
	});

})(jQuery);
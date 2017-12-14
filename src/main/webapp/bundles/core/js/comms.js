/**
 * Comms.js is an abstracted $.ajax handler, it is not a wrapper as it doesn't return the same thing as $.ajax does.
 * E.G. $.ajax(settings).done(function(result) { } ); will have the success result object as a parameter.
 * comms.get.done(function(result) { } ); result will be undefined, as the ajax function in here, returns $.ajax().then, not $.ajax.
 */
;(function($, undefined){

	var meerkat = window.meerkat;

	var cache = [];

	var AJAX_REQUEST_ABORTED = "abort";
	var CHECK_AUTHENTICATED_LABEL = "checkAuthenticated";

	// Needed specifically for Westfund white label
	var forcedStyleCodeId = false;

	var defaultSettings = {
		url: 'not-set',
        contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		data: null,
		dataType: false,
        numberOfAttempts: 1,
		attemptCallback: null,
		timeout: 60000,
		cache: false,
		async: true,
		// errorLevel
		//    mandatory
		//    silent (only log in the db)
		//    warning (visible to user but can go back to page)
		//    fatal (visible to user and forces page refresh)
		errorLevel: null,
		// useDefaultErrorHandling: By default allow comms to handle errors. Set to false to do your own error handling.
		useDefaultErrorHandling: true,
		// returnAjaxObject: By default the comms.ajax() function will return the Deferred .then object. Set this to true to return the parent ajax object.
		returnAjaxObject: true,
		sendTransIdWithRequest: true,
		onSuccess: function(result, textStatus, jqXHR){
			//
		},
		onError: function(jqXHR){
			// custom optional callback
		},
		onComplete: function(jqXHR, textStatus){

		},
		onErrorDefaultHandling: function(jqXHR, textStatus, errorThrown, settings, data) {

			if(textStatus !== AJAX_REQUEST_ABORTED) { // Don't throw error for aborted requests
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
					errorLevel: settings.errorLevel,
					message: message,
					page: 'comms.js',
					description: "Error loading url: " + settings.url + ' : ' + textStatus + ' ' + errorThrown,
					data: data
				};

				if (jqXHR.status && jqXHR.status != 200) {
					message = statusMap[jqXHR.status];
				} else if (textStatus == 'parsererror') {
					message += "There was a problem handling the response from the server [parsererror]. Please try again.";
				} else if (textStatus == 'timeout') {
					message += "There was a problem connecting to the server. Please check your internet connection and try again. [Request Time out].";
				} else if (textStatus == 'abort') {
					message += "There was a problem handling the response from the server [abort]. Please try again.";
				}

				if ((!message || message === '') && errorThrown == CHECK_AUTHENTICATED_LABEL) {

					message = "Your Simples login session has been lost. Please open Simples in a separate tab, login, then you can continue with this quote.";

					if (!meerkat.modules.dialogs.isDialogOpen(CHECK_AUTHENTICATED_LABEL)) {
						// Take user back to previous step
						meerkat.modules.journeyEngine.gotoPath('previous');
					}

					$.extend(errorObject, {
						errorLevel: 'warning',
						id: CHECK_AUTHENTICATED_LABEL
					});
				} else if (!message || message === '') {
					message = "Unknown Error";
				}

				$.extend(errorObject, {message: message});

				if (errorThrown != CHECK_AUTHENTICATED_LABEL || (errorThrown == CHECK_AUTHENTICATED_LABEL && !meerkat.modules.dialogs.isDialogOpen(CHECK_AUTHENTICATED_LABEL))) {
					meerkat.modules.errorHandling.error(errorObject);
				}
			}
		}
	};

	function post(instanceSettings){
		return getAndPost('POST', instanceSettings);
	}

	function get(instanceSettings){
		return getAndPost('GET', instanceSettings);
	}

	function getAndPost(requestMethod, instanceSettings) {

		var settings = $.extend({}, defaultSettings, instanceSettings);

		if( typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null){
			console.error("Message to dev: please provide an errorLevel to the comms.post() or comms.get() function.");
		}

		settings = appendBrandCodeToUrl(settings);

		var usedCache = checkCache(settings);
		if(usedCache === true) {
			var cachedResult = findInCache(settings);
			return $.Deferred(function(dfd) {
				// Deferring the callbacks brings their behaviour more inline with a normal .ajax object
				if(settings.onSuccess !== null) settings.onSuccess(cachedResult.result);
				if(settings.onComplete !== null) settings.onComplete();
				return dfd.resolveWith(this, [cachedResult.result]).promise();
			});
		}

		settings.attemptsCounter = 1;

		return ajax(settings, {
			url: settings.url,
			data: settings.data,
            contentType: settings.contentType,
            dataType: settings.dataType,
			type: requestMethod,
			timeout: settings.timeout,
			async: settings.async
		});

	}

	function ajax(settings, ajaxProperties){

		var tranId = meerkat.modules.transactionId.get();
		try{
			if(ajaxProperties.data === null) {
				ajaxProperties.data = {};
			}

			if (_.isString(ajaxProperties.data)) {

				if (settings.sendTransIdWithRequest) {
                    ajaxProperties.data += '&transactionId=' + tranId;
				}

				if(meerkat.site.isCallCentreUser) {
					ajaxProperties.data += "&" + CHECK_AUTHENTICATED_LABEL + "=true";
				}
			}
			else if (_.isArray(ajaxProperties.data)) {
				// We have to clone it so that JS is not referencing the original object
				ajaxProperties.data = $.merge([], settings.data);

				if (settings.sendTransIdWithRequest) {
                    // Add the transaction ID to the data payload if it's not already set
                    if (_.indexOf(ajaxProperties.data, 'transactionId') === -1) {
                        ajaxProperties.data.push({
                            name: 'transactionId',
                            value: tranId
                        });

                    }
				}

				if(meerkat.site.isCallCentreUser) {
					ajaxProperties.data.push({
						name: CHECK_AUTHENTICATED_LABEL,
						value: true
					});
				}
			}
			else if (_.isObject(ajaxProperties.data)) {
				// We have to clone it so that JS is not referencing the original object
				ajaxProperties.data = $.extend(true, {}, settings.data);

				if (settings.sendTransIdWithRequest) {
                    // Add the transaction ID to the data payload if it's not already set
                    if (ajaxProperties.data.hasOwnProperty('transactionId') === false) {
                        ajaxProperties.data.transactionId = tranId;
                    }
				}

				if(meerkat.site.isCallCentreUser) {
					ajaxProperties.data[CHECK_AUTHENTICATED_LABEL] = true;
				}
			}

			meerkat.modules.verificationToken.addTokenToRequest(ajaxProperties);

            if(settings.doStringify === true && _.isObject(ajaxProperties.data)){
                ajaxProperties.data = JSON.stringify(ajaxProperties.data);
            }
		}catch(e){
		}

		var jqXHR = $.ajax(ajaxProperties);
		var deferred = jqXHR.then(
					function onAjaxSuccess(result, textStatus, jqXHR){
						meerkat.modules.verificationToken.readTokenFromResponse(result);
						var data = (typeof settings.data !== "undefined") ? settings.data : null;

						if(containsServerGeneratedError(result) === true) {
					handleError(jqXHR, "Server generated error", getServerGeneratedError(result), settings, data, ajaxProperties);
				} else {
							if(settings.cache === true)	addToCache(settings.url, data, result);
							if(settings.onSuccess !== null) settings.onSuccess(result);
							if(settings.onComplete !== null) settings.onComplete(jqXHR, textStatus);

					if(typeof result.timeout != "undefined" && result.timeout) meerkat.modules.session.update(result.timeout);
						}
					},
					function onAjaxError(jqXHR, textStatus, errorThrown){
						var data = typeof(settings.data) != "undefined" ? settings.data : null;

					handleError(jqXHR, textStatus, errorThrown, settings, data, ajaxProperties);

						if(settings.onComplete !== null) settings.onComplete(jqXHR, textStatus);
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

		for (var i=0;i<cache.length;i++) {
			var cacheItem = cache[i];
			if (settings.url === cacheItem.url) {
				if (settings.data === null && cacheItem.postData === null) {
					// no post data
					return cacheItem;
				}
				else if (settings.data !== null && cacheItem.postData !== null) {
					// compare post data
					if(_.isEqual(settings.data, cacheItem.postData)){
						return cacheItem;
					}
				}
			}

		}//for loop

		return null;
	}

	function checkCache(settings){
		if(settings.cache === true){
			var cachedResult = findInCache(settings);
			if(cachedResult !== null){
				meerkat.logging.info("Retrieved from cache",cachedResult);

				return true;
			}
		}

		return false;
	}

	/**
	Check if the data has error properties.
	@returns boolean
	**/
	function containsServerGeneratedError(data){
		if (typeof data.error !== 'undefined' || (typeof data.errors !== 'undefined' && data.errors.length > 0)) {
			return true;
		}
		return false;
	}

	/**
	Get the error from the data.
	Handles old style:
		{error:'Message'}
		{error:['message']}
	Handles new style:
		{errors:[{message:'Message'}]}

	@returns string Error message or empty string.
	**/
	function getServerGeneratedError(data) {
		var target;

		// Find the appropriate error property
		// 'errors' is the new style, generally produced via java
		if (!_.isUndefined(data.errors)) {
			target = data.errors;
		}
		else if (!_.isUndefined(data.error)) {
			target = data.error;
		}
		else return '';

		// Collect the error value
		if (_.isArray(target) && target.length > 0) {
			if (target[0].hasOwnProperty('message')) {
				target = target[0].message;
			}
			else target = target[0];
		}

		if (_.isString(target)) {
			return target;
		}
		else {
			return '';
		}
	}

	function handleError(jqXHR, textStatus, errorThrown, settings, data, ajaxProperties){

		if(textStatus !== AJAX_REQUEST_ABORTED) { // Don't proceed with aborted requests
			if (settings.numberOfAttempts > settings.attemptsCounter++) {
				ajax(settings, ajaxProperties);
			} else {
				if (typeof settings === 'undefined') {
					settings = {};
				}

				if (settings.useDefaultErrorHandling) {
					settings.onErrorDefaultHandling(jqXHR, textStatus, errorThrown, settings, data);
				}

				if (settings.onError !== null) {
					settings.onError(jqXHR, textStatus, errorThrown, settings, data);
				}
			}
		}
	}

	function getCheckAuthenticatedLabel() {
		return CHECK_AUTHENTICATED_LABEL;
	}

	function appendBrandCodeToUrl(settings) {
		if(forcedStyleCodeId !== false) {
			if (settings.url.search(/\?/) !== -1) {
				if(settings.url.search(/brandCode=[a-zA-Z]+/) !== -1) {
					settings.url = settings.url.replace(/brandCode=[a-zA-Z]+/g, "brandCode=" + forcedStyleCodeId);
				} else {
					settings.url += "&brandCode=" + forcedStyleCodeId;
				}
			} else {
				settings.url += "?brandCode=" + forcedStyleCodeId;
			}
		}
		return settings;
	}

	function init() {
		jQuery(document).ready(function ($) {
			if(!_.isUndefined(meerkat.site.urlStyleCodeId) && !_.isEmpty(meerkat.site.urlStyleCodeId)) {
				forcedStyleCodeId = meerkat.site.urlStyleCodeId;
			}
		});
	}

	meerkat.modules.register("comms", {
		init: init,
		post: post,
		get: get,
		getCheckAuthenticatedLabel: getCheckAuthenticatedLabel
	});

})(jQuery);
;(function ($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        attemptCount = 0,
        $elements = {},
        errorTypes = {
            INVALID : 0,
            NOMATCH : 1,
            ATTEMPTS : 2
        };

    function init() {
        if (meerkat.site.isRememberMe) {
            meerkat.modules.jqueryValidate.initJourneyValidator();
            _setupFields();
            validateDob();
            initEventListeners();
            _track('offered');
        }
    }

    function _setupFields() {
        $elements = {
            startQuote: $('.remember-me-remove'),
            dobInput: $('#rememberme_primary_dob'),
            dobGroup: $('.remember-me-dob-group'),
            form: $('#rememberMeForm'),
            loadingPage: $('.journeyEngineLoader'),
            loadingMessage: $('.journeyEngineLoader > .message'),
            rememberMePage: $('#journeyEngineSlidesContainer'),
            reviewedit: $('#rememberme_reviewedit'),
            revieweditButton: $('.rememberme-review-btn'),
            errors: {
                primary: $('#rememberme_primary_dob-error'),
                additional: $('#rememberme_additional-error')
            }
        };
    }

    function initEventListeners() {
        $elements.startQuote.click(function (event) {
            event.preventDefault();
            showLoadingPage();
            deleteCookieAndRedirect($(this).data('track-action'));
        });

        $elements.dobInput.on("change", function () {
            var $error = $('.remember-me-dob-group label.error');
            if ($error.length) {
                $elements.dobGroup.removeClass('has-error');
                $error.hide();
            }
        });

        $elements.revieweditButton.on("click", function(){
            _setReviewEdit();
            $elements.form.trigger("submit");
        });
    }

    function deleteCookieAndRedirect(eventAction) {
        meerkat.modules.comms.post({
            url: 'spring/rest/rememberme/quote/deleteCookie.json',
            data: {
                quoteType: 'health'
            },
            dataType: 'json',
            cache: true,
            errorLevel: "silent",
            onSuccess: function onSuccess() {
                _track(eventAction);
                meerkat.modules.leavePageWarning.disable();
                window.location.replace("health_quote_v4.jsp" + _getQueryString());
            },
            onError: function onError(obj, txt, errorThrown) {
                // @TODO Should have better error handling here
	            meerkat.logging.debug(obj, errorThrown);
            }
        });
    }

    function showError(type) {
        type = type || false;
        $elements.dobGroup.removeClass('has-success').addClass('has-error');
	    $elements.errors.primary.add($elements.errors.additional).hide();
        if(type === errorTypes.INVALID) {
	        $elements.errors.primary.show();
        } else if (type === errorTypes.NOMATCH) {
            if(!$elements.errors.additional.length) {
	            $('<label id="rememberme_additional-error" class="error">The date of birth you entered didn\'t match our records, enter your date of birth again or start a new quote</label>').insertAfter('#rememberme_primary_dob');
	        }
	        _.defer(function() {
		        $elements.errors.additional = $('#rememberme_additional-error');
                $elements.errors.additional.show();
	        });
        } else {
            // All other cases simply keep the error fields hidden
        }
    }

    function updateErrorRedirectMessage() {
        $elements.loadingMessage.html("Sorry, you have exceeded the number of attempts allowed.<br />Redirecting you now to start a new quote.");
    }

    function showLoadingPage() {
        $elements.rememberMePage.fadeOut();
        setTimeout(function () {
            $elements.loadingPage.fadeIn();
        }, 300);
    }

    function validateDob() {
        $elements.form.submit(function (e) {
            e.preventDefault();
            var $form = $(this),
                rememberMeGetPromise = null;

            if ($form.valid()) {
                rememberMeGetPromise = meerkat.modules.comms.get({
                    url: 'spring/rest/rememberme/quote/get.json',
                    data: {
                        quoteType: 'health',
                        userAnswer: $elements.dobInput.val(),
	                    reviewedit: $elements.reviewedit.val()
                    },
                    cache: false,
                    errorLevel: 'silent',
                    onSuccess: function (result) {
                    	if (result.validAnswer === true && result.transactionId !== "") {
                            _track('success');
                            meerkat.modules.leavePageWarning.disable();
		                    if(result.reviewEdit === true) {
		                    	$elements.loadingMessage.text('Loading your quote... Please wait...');
		                    } else {
			                    $elements.loadingMessage.text('Loading Products & Prices... Please wait...');
		                    }
                            showLoadingPage();
                            var newQSParams = {
                                action : "remember",
                                transactionId : result.transactionId
                            };
                            if(result.reviewEdit === true) {
                            	newQSParams["reviewedit"] = "true";
                            }
                            window.location.replace("health_quote_v4.jsp" + _getQueryString(newQSParams));
                        } else {
                            _track('validation failed');
                            showError(errorTypes.NOMATCH);
                            attemptCount++;
                        }
                    },
                    onError: function onError(obj, txt, errorThrown) {
                        meerkat.logging.debug(obj, errorThrown);
                    },
                    onComplete: function(){
                        _unsetReviewEdit();
	                    $elements.errors.primary.add($elements.errors.additional).hide();
                    }
                });
            } else {
            	_unsetReviewEdit();
                _track('validation failed');
                showError(errorTypes.INVALID);
            }

            rememberMeGetPromise && rememberMeGetPromise.done(function() {
                if (attemptCount > 2) {
                    showError(errorTypes.ATTEMPTS);
                    updateErrorRedirectMessage();
                    showLoadingPage();
                    setTimeout(function () {
                        deleteCookieAndRedirect('token expired');
                    }, 800);
                }
            });
        });
    }

    function _getQueryString(data) {

    	// Ensure new query string elements is an object
	    data = data || null;
		var newQSParams = {};
		if(!_.isEmpty(data) || _.isObject(data)) {
			newQSParams = data;
		}

		// Prep existing query string into object
	    var srcQSParams = {};
	    if(_.isEmpty(window.location.search)) {
		    var tmp = window.location.search.split("?").pop().split("&");
		    for(var i=0; i<tmp.length; i++) {
			    var pieces = tmp[i].split("=");
			    if(pieces.length === 2) {
				    srcQSParams[pieces[0]] = pieces[1];
			    }
		    }
	    }

	    // Combine new and existing into single array of name/value pairs
	    var finalQSParams = _.extend({},srcQSParams,newQSParams);
	    var queryStr = [];
	    for(var j in finalQSParams) {
		    if(_.has(finalQSParams,j)) {
			    queryStr.push(j+"="+finalQSParams[j]);
		    }
	    }

	    // Return as generic query string
	    return _.isEmpty(queryStr) ? "" : "?" + queryStr.join("&");
    }

    function _track(eventAction) {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackRememberMeQuote',
            object: {
                vertical: 'health',
                eventCategory: 'remember me',
                eventAction: 'remember me - ' + eventAction
            }
        });
    }

    function _setReviewEdit() {
        $elements.reviewedit.val("Y");
    }

    function _unsetReviewEdit() {
        $elements.reviewedit.val("N");
    }

    meerkat.modules.register('rememberMe', {
        init: init
    });

})(jQuery);
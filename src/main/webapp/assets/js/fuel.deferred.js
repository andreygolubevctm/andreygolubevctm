/**
 * This module uses data attributes to populate empty content areas with html, text, values, AJAX results from a specific source.
 * It is initially developed to only function for CARAMS-12, and will be extended for CARAMS-7
 */
;(function ($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			contentPopulation: {}
		},
		moduleEvents = events.contentPopulation;

	/* Variables */


	/* main entrypoint for the module to run first */
	function init() {

	}

	/**
	 * Empty the values in the template. Needed to prevent ensure each refresh updates properly
	 * @param {String} container - Pass in a jQuery selector as the parent element wrapping the div template.
	 */
	function empty(container) {
		$('[data-source]', $(container)).each(function () {
			// it's possibly that we will want to reset a value/radio button/
			$(this).empty();
		});
	}

	/**
	 * Loop through each element with data-source attribute within the container
	 * Fill it with the content retrieved from the data-source
	 * Can be used to retrieve any type of content, just add more conditions.
	 * @param {String} container - Pass in a jQuery selector as the parent element wrapping the div template.
	 */
	function render(container) {

		$('[data-source]', $(container)).each(function () {
			var output = '',
				$el = $(this),
				$sourceElement = $($el.attr('data-source')),
				$alternateSourceElement = $($el.attr('data-alternate-source')); // used primarily with prefill data.

			// If the source element doesn't exist, continue
			if (!$sourceElement.length)
				return; // same as "continue" http://api.jquery.com/jquery.each/

			// setup variables
			sourceType = $sourceElement.get(0).tagName.toLowerCase(),
				dataType = $el.attr('data-type'),
				callback = $el.attr('data-callback');
			/**
			 * You can perform a callback function to create the output by adding: data-callback="meerkat.modules...."
			 * You can just let it handle it based on the elements tagName
			 * You can specify a data-type, and handle them differently e.g. radiogroup, list, JSON object etc (or create your own)
			 */
			if(callback) {
				/** To run a function. Can handle namespaced functions e.g. meerkat.modules... and global functions.
				 * Argument passed in to function is $sourceElement.
				 * If you wish to add another parameter,
				 * add it as a data attribute and include it in both .apply calls below as an additional array element.
				 **/
				try {
					var namespaces = callback.split('.');

					if(namespaces.length) {
						var func = namespaces.pop(),
						context = window;
						for(var i= 0; i < namespaces.length; i++) {
							context = context[namespaces[i]];
						}
						output = context[func].apply(context, [$sourceElement]);
					} else {
						output = callback.apply(window, [$sourceElement]);
					}
				} catch (e) {
					meerkat.modules.errorHandling.error({
						message:	"Unable to perform render Content Population Callback properly.",
						page:		"contentPopulation.js:render()",
						errorLevel:	"silent",
						description:"Unable to perform contentPopulation callback labelled: " + callback,
						data:		{"error": e.toString(), "sourceElement": $el.attr('data-source')}
					});
					output = '';
				}
			} else if (!dataType) {
				switch (sourceType) {
				case 'select':
					// to prevent a "please choose" from displaying.
					var $selected = $sourceElement.find('option:selected');
					if($selected.val() === '') {
						output = '';
					} else {
						// We generally want to see the options text content, rather than it's value.
						output = $selected.text() || '';
						// If there's an alternate source.
						if(output === '' && $alternateSourceElement.length) {
							$selected = $alternateSourceElement.find('option:selected');
							if($selected.val() === '') {
								output = '';
							} else {
								output = $selected.text() || '';
							}
						}
					}
					break;
				case 'input':
					output = $sourceElement.val() || $alternateSourceElement.val() || '';
					break;
				default:
					output = $sourceElement.html() || $alternateSourceElement.html() || '';
					break;
				}
			} else {
				var selectedParent;
				switch (dataType) {
					case 'checkboxgroup':
						selectedParent = $sourceElement.parent().find(':checked').next('label');
						if(selectedParent.length) {
							output = selectedParent.text() || '';
						}
					break;
					case 'radiogroup':
						selectedParent = $sourceElement.find(':checked').parent('label');
						if (selectedParent.length) {
							output = selectedParent.text() || '';
						}
						break;
					case 'list':
						// get it from a source ul, but text only
						// assumes the first span is the one with the text in it
						var $listElements = $sourceElement.find('li');
						if ($listElements.length > 0) {
							$listElements.each(function() {
								output += '<li>' + $(this).find('span:eq(0)').text() + '</li>';
							});
						} else {
							output += '<li>None selected</li>';
						}
						break;
					case 'optional':
						output = $sourceElement.val() || $alternateSourceElement.val() || '';
						// If we get even one output, we remove the no details element.
						if (output !== '') {
							$('.noDetailsEntered').remove();
						}
						break;
					case 'object':
						// get it from an object and do stuff
						break;
				}
			}

			// currently we only want to replace the elements html, potential to replace value, select options...? extend this with further data options.
			$el.html(output);
		});
	}

	meerkat.modules.register('contentPopulation', {
		init: init,
		events: events,
		render: render,
		empty: empty
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);
;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
        retrievequotesComponent: {},
        WEBAPP_LOCK: 'WEBAPP_LOCK',
        WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
    };

    function initJourneyEngine() {


        // Initialise the journey engine steps and bar
        initProgressBar(false);

        // Initialise the journey engine
        var startStepId = null;

        $(document).ready(function () {

            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });
        });
    }

    /**
     * Initialise and configure the progress bar.
     *
     * @param {bool} render
     */
    function initProgressBar(render) {
        setJourneyEngineSteps();
        //configureProgressBar();
    }

    function setJourneyEngineSteps() {

        var startStep = {
            title: 'Login',
            navigationId: 'login',
            slideIndex: 0,
            onAfterEnter: function onStartAfterEnter() {
                if(meerkat.site.loggedIn)
                    meerkat.modules.journeyEngine.gotoPath("next");
            },
            validation: {
                validate: true,
                customValidation: function (callback) {
                    if(meerkat.site.loggedIn) {
                        callback(true);
                        return;
                    }
                    meerkat.modules.retrievequotesLogin.doLoginAndRetrieve().done(function (data, textStatus, jqXHR) {
                        if (typeof data !== 'undefined' && data !== null && data.previousQuotes) {
                            meerkat.site.responseJson = data;
                            callback(true);
                        } else {
                            try {
                                callback(false);
                            } catch (e) {
                            }
                            meerkat.modules.retrievequotesLogin.handleLoginFailure(jqXHR, textStatus, "");
                        }
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        try {
                            callback(false);
                        } catch (e) {
                        }
                        meerkat.modules.retrievequotesLogin.handleLoginFailure(jqXHR, textStatus, errorThrown);
                        return;
                    }).always(function() {
                        meerkat.modules.loadingAnimation.hide($(".btn-login"));
                    });
                }
            }
        };

        var resultsStep = {
            title: 'Your Quotes',
            navigationId: 'quotes',
            slideIndex: 1,
            onBeforeEnter: function () {
                meerkat.modules.retrievequotesListQuotes.renderQuotes();
            },
            onAfterEnter: function() {
                if($.trim($("#quote-result-list").html()) === "") {
                    meerkat.modules.retrievequotesListQuotes.noResults();
                }
            }
        };

        steps = {
            startStep: startStep,
            resultsStep: resultsStep
        };

    }

    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([]);
    }

    meerkat.modules.register("retrievequotesComponent", {
        init: initJourneyEngine,
        events: moduleEvents
    });

})(jQuery);
;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var forgotPasswordModal;

    function initRetrieveQuotesForgotPassword() {
        _registerEventListeners();
    }

    function _registerEventListeners() {
        $(document)
            .on("click", ".forgot-password", _onForgotPasswordLinkClick)
            .on("click", ".reset-password", _onResetPasswordLinkClick);
    }

    function _onForgotPasswordLinkClick() {
        var forgotPasswordFormHTML = _.template($("#forgot-password-template").html())();

        forgotPasswordModal = meerkat.modules.dialogs.show({
            htmlContent: forgotPasswordFormHTML,
            hashId: "forgot-password",
            buttons: [
                {
                    label: 'Back',
                    className: 'btn-close-dialog'
                },
                {
                    label: 'Reset Password',
                    className: 'btn-secondary reset-password'
                }
            ],
            onOpen: function(dialogId) {
                // Setup validation on the forgot password form
                meerkat.modules.validation.setupDefaultValidationOnForm($("#forgot-password-form"));

                var usedEmail = $("#login_email").val();
                $("#login_forgotten_email").val(usedEmail);
            }
        });
    }

    function _onResetPasswordLinkClick() {
        var $emailField = $("#login_forgotten_email");

        if($emailField.valid()) {
            var $resetPasswordButton = $(".reset-password");

            meerkat.modules.loadingAnimation.showInside($resetPasswordButton, true);

            var $ajax = meerkat.modules.comms.post({
                errorLevel: "warning",
                url: "ajax/json/forgotten_password.jsp",
                data: {
                    email: $emailField.val()
                }
            });

            var genericFailMessage = "We could not send your password reset email at this time";

            var onFail = function(message) {
                message = message || genericFailMessage;

                var successHTML = _.template($("#reset-password-failure-template").html(), { message: message });

                meerkat.modules.dialogs.show({
                    title: "Reset Password Error",
                    htmlContent: successHTML,
                    hashId: "forgot-password",
                    buttons: [{
                        label: 'OK',
                        className: 'btn-secondary btn-close-dialog'
                    }]
                });
            };

            $ajax
                .done(function(data) {
                    if(typeof data === "string")
                        data = JSON.parse(data);

                    if(typeof data.result !== "undefined") {
                        var result = data.result;

                        if(result === "OK") {
                            var successHTML = _.template(
                                $("#reset-password-success-template").html(),
                                {email: $emailField.val()},
                                {variable: "data"}
                            );

                            meerkat.modules.dialogs.show({
                                title: "Reset Password",
                                htmlContent: successHTML,
                                hashId: "forgot-password",
                                buttons: [{
                                    label: 'OK',
                                    className: 'btn-secondary btn-close-dialog'
                                }]
                            });
                        } else {
                            var message = data.message || genericFailMessage,
                                errorObj = {
                                    "login_forgotten_email": message
                                };

                            $("#forgot-password-form").validate().showErrors(errorObj);
                        }
                    } else {
                        onFail();
                    }
                })
                .fail(function() {
                    onFail();
                })
                .always(function() {
                    meerkat.modules.dialogs.close(forgotPasswordModal);
                    meerkat.modules.loadingAnimation.hide($resetPasswordButton);
                });
        }
    }

    meerkat.modules.register("retrievequotesComponentForgotPassword", {
        init: initRetrieveQuotesForgotPassword
    });

})(jQuery);
;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var rowContainerTemplate,
        verticalTemplates = {};

    function initRetrievequotesListQuotes() {
        _registerEventListeners();
        $(document).ready(function() {
            var $resultsTemplate = $("#retrieve-quotes-container-template");
            if ($resultsTemplate.length) {
                rowContainerTemplate = _.template($resultsTemplate.html());
            }

            // to enable a new vertical to save quotes, create a new template_vertical.tag
            // and also include it in template_rows.tag.
            // TODO: Generate this object dynamically so all we have to do is include the tag in JSP
            verticalTemplates = {
                quote: $("#retrieve-car-template").html(),
                health: $("#retrieve-health-template").html(),
                life: $("#retrieve-life-template").html(),
                ip: $("#retrieve-ip-template").html(),
                homeloan: $("#retrieve-homeloan-template").html(),
                home: $("#retrieve-home-template").html(),
                utilities: $("#retrieve-utilities-template").html()
            };
        });
    }

    function _registerEventListeners() {
        $(document)
            .on("click", "#logout-user", _onClickLogoutUser)
            .on("click", "#new-quote", _onClickNewQuote)
            .on("click", ".btn-latest", _onClickLatest)
            .on("click", ".btn-amend", _onClickAmend)
            .on("click", ".btn-pending", _onClickPending)
            .on("click", ".btn-start-again", _onClickStartAgain)
            .on("click", ".btn-start-again-fresh", _onClickStartAgainFresh);
    }

    function _onClickPending(e) {
        var data = _getClickElementData(e.target),
            url = data.vertical + "_quote.jsp?action=confirmation&PendingID=" + encodeURIComponent(data.pendingID);
        
        window.location.href = url;
    }

    function _onClickLogoutUser(e) {
        meerkat.modules.utils.scrollPageTo("html, body");
        meerkat.modules.journeyEngine.loadingShow("Logging you out...");

        var $ajax = meerkat.modules.comms.get({
            url: "generic/logout_user.json",
            errorLevel: "silent",
            dataType: "json"
        });

        var onFail = function() {
            meerkat.modules.dialogs.show({
                title: "Unable to log out",
                htmlContent: "Sorry, we could not log you out at this time",
                buttons: [
                    {
                        label: 'OK',
                        className: 'btn-close-dialog'
                    }
                ]
            });

            meerkat.modules.journeyEngine.loadingHide();
        };

        $ajax
            .done(function(data) {
                if(typeof data === "string")
                    data = JSON.parse(data);

                if(data.success && data.success === true) {
                    window.location.href = "retrieve_quotes.jsp";
                    return;
                }

                onFail();
            })
            .fail(function() {
                onFail();
            })
    }

    function noResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#new-quote-template").html(),
            buttons: [false],
            onOpen: function(dialogId) {
                $("#" + dialogId).find(".btn-close-dialog, .modal-footer").remove();
            }
        });
    }

    function _onClickNewQuote(e) {
        meerkat.modules.dialogs.show({
            htmlContent: $("#new-quote-template").html(),
            className: "new-quote-dialog"
        });
    }

    function _getClickElementData(element) {
        var $element = $(element);

        if(typeof $element.attr("data-vertical") === "undefined")
            $element = $element.closest("a");

        var data = {
            $element: $element,
            vertical: $element.attr("data-vertical"),
            transactionId: $element.attr("data-transactionid")
        };

        if($element.attr("data-inpast") === "Y")
            data.inPast = "Y";

        if($element.attr("data-pendingid"))
            data.pendingID = $element.attr("data-pendingid");

        return data;
    }

    function _onClickLatest(e) {
        var data = _getClickElementData(e.target);

        meerkat.modules.dialogs.show({
            title: "Enter New Commencement Date",
            htmlContent: $("#new-commencement-date-template").html(),
            buttons: [
                {
                    label: 'Cancel',
                    className: 'btn-close-dialog'
                }, {
                    label: 'Get Latest Results',
                    className: 'btn-cta btn-submit'
                }
            ],
            onOpen: function(dialogId) {
                meerkat.modules.datepicker.setDefaults();
                meerkat.modules.datepicker.initModule();

                $(document).on("click", "#" + dialogId + " .btn-submit", function() {
                    var newDate = $("#newCommencementDate").val();
                    meerkat.modules.dialogs.close(dialogId);
                    _retrieveQuote(data.vertical, "latest", data.transactionId, newDate);
                });
            }
        });
    }

    function _onClickStartAgainFresh(e) {
        var data = _getClickElementData(e.target);
        _retrieveQuote(data.vertical, "start-again-fresh", data.transactionId);
    }

    function _onClickStartAgain(e) {
        var data = _getClickElementData(e.target);
        _retrieveQuote(data.vertical, "start-again", data.transactionId);
    }

    function _onClickAmend(e) {
        var data = _getClickElementData(e.target);
        _retrieveQuote(data.vertical, "amend", data.transactionId);
    }

    function _retrieveQuote(vertical, action, transactionId, newDate) {
        if(vertical === "quote")
            vertical = "car";

        meerkat.modules.utils.scrollPageTo("html, body");
        meerkat.modules.journeyEngine.loadingShow("Retrieving your quote...");

        var data = {
            vertical: vertical,
            action: action,
            transactionId: transactionId
        };

        if (newDate)
            data.newDate = newDate;

        var $ajax = meerkat.modules.comms.post({
            url: "ajax/json/load_quote.jsp",
            errorLevel: "silent",
            dataType: "json",
            data: data
        });

        var onFail = function(message) {
            message = message || "A problem occurred when trying to load your quote.";

            meerkat.modules.dialogs.show({
                title: "Unable to load your quote",
                htmlContent: "<p>" + message + "</p>",
                buttons: [{
                    label: 'OK',
                    className: 'btn-secondary btn-close-dialog'
                }]
            });

            meerkat.modules.journeyEngine.loadingHide();
        };

        $ajax
            .done(function(data) {
                if(typeof data === "string")
                    data = JSON.parse(data);

                if(data && data.result) {
                    var result = data.result;

                    if(result.destUrl) {
                        window.location.href = result.destUrl + '&ts=' + Number(new Date());
                        return;
                    } else {
                        if(result.showToUser && result.error) {
                            onFail(result.error);
                            return;
                        }
                    }
                }

                onFail();
            })
            .fail(function() {
                onFail();
            });
    }

    function renderQuotes() {
        $("#quote-result-list").html(rowContainerTemplate(meerkat.site.responseJson));
    }

    function renderTemplate(vertical, data) {
        if(!vertical) {
            return "";
        }
        try {
            var htmlTemplate = _.template(verticalTemplates[vertical]);
            return htmlTemplate(data);
        } catch(e) {
            meerkat.modules.errorHandling.error({
                errorLevel: "silent",
                page: "retrievequotesListQuotes.js",
                description: "Unable to render template [" + vertical + "]",
                message: "Unable to render template",
                data: {
                    vertical: vertical,
                    providedData: data
                }
            });

            return "";
        }
    }

    function getVerticalFromObject(obj) {
        var keys = _.keys(obj);
        for (var k = 0; k < keys.length; k++) {
            if (keys[k] != 'id') {
                return keys[k];
            }
        }
        return false;
    }

    function getGenderString(gender) {
        return gender == 'M' ? 'Male' : 'Female';
    }

    function carFormatNcd(value) {
        var rating;
        switch (value) {
            case 5:
                rating = 1;
                break;
            case 4:
                rating = 2;
                break;
            case 3:
                rating = 3;
                break;
            case 2:
                rating = 4;
                break;
            case 1:
                rating = 5;
                break;
            case 0:
                rating = 6;
                break;
        }
        // No NCD if 6
        if(rating == 6) {
            return "Rating 6 No NCD";
        }
        return typeof rating == 'undefined' ? "" : "Rating " + rating + " ("+value+" Years) NCD";
    }

    function healthBenefitsList(data) {
        if(typeof data == 'undefined' || typeof data.benefitsExtras == 'undefined') {
            return "";
        }
        var keys = Object.keys(data.benefitsExtras),
            outList = [];
        for(var i = 0; i < keys.length; i++) {
            if(data.benefitsExtras[keys[i]] == "Y") {
                outList.push(keys[i]);
            }
        }
        return outList.join(', ');
    }

    function getHomeloanSituation (situation) {
        switch(situation) {
            case "F":
                return "A First Home Buyer";
            case "E":
                return "An Existing Home Owner";
        }

        return "";
    }

    function getHomeloanGoal (goal) {
        switch(goal) {
            case "FH":
                return "Buy my first home";
            case "APL":
                return "Buy another property to live in";
            case "IP":
                return "Buy an investment property";
            case "REP":
                return "Renovate my existing property";
            case "CD":
                return "Consolidate my debt";
            case "CL":
                return "Compare better home loan options";
        }

        return "";
    }

    meerkat.modules.register("retrievequotesListQuotes", {
        init: initRetrievequotesListQuotes,
        renderQuotes: renderQuotes,
        renderTemplate: renderTemplate,
        getVerticalFromObject: getVerticalFromObject,
        noResults: noResults,

        getGenderString: getGenderString,
        carFormatNcd: carFormatNcd,
        healthBenefitsList: healthBenefitsList,
        getHomeloanSituation: getHomeloanSituation,
        getHomeloanGoal: getHomeloanGoal
    });

})(jQuery);
/**
 * Description:
 * External documentation:
 */

;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            retrievequotesLogin: {

            }
        },
        moduleEvents = events.retrievequotesLogin,
        failModalId,
        $loginFailureTemplate,
        htmlTemplate = function() { return "" };

    function initLogin(){

         _registerEventListeners();

        $(document).ready(function($) {
            $loginFailureTemplate = $("#failed-login-template");
            if($loginFailureTemplate.length) {
                htmlTemplate = _.template($loginFailureTemplate.html());
            }
        });

    }

    function _registerEventListeners() {
        $(document).on("click", "#js-too-many-attempts", function() {
            meerkat.modules.dialogs.close(failModalId);
            $(document).find(".forgot-password").trigger("click");
        });
    }

    /**
     * Simply responsible for the AJAX request
     */
    function doLoginAndRetrieve() {
        meerkat.modules.loadingAnimation.showInside($(".btn-login"), true);
        var data = meerkat.modules.form.getData($('#loginForm'));
        return meerkat.modules.comms.post({
            url: "ajax/json/retrieve_quotes.jsp",
            data: data,
            async: false,
            errorLevel: "warning",
            useDefaultErrorHandling: false,
            cache: false,
            dataType: "json"
        });
    }

    /**
     * Handles if it fails, what to show the user.
     * @param jqXHR
     * @param textStatus
     * @param errorThrown
     * @returns {boolean}
     */
    function handleLoginFailure(jqXHR, textStatus, errorThrown) {

        meerkat.modules.journeyEngine.unlockJourney();
        meerkat.modules.address.setHash("login");

        var responseText = jqXHR.responseText;
        if(!responseText) {
            _submitError({url: jqXHR.url}, "No responseText for request");
            return false;
        }
        var responseJson = {};
        try {
            responseJson = $.parseJSON(responseText);
        } catch(e) {
            _submitError(e, "Could not decode responseText to JSON");
        }

        _failureModal(responseJson);
    }

    function _submitError(exception, errorThrown) {
        meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK, { source:'retrievequotesLogin'});
        meerkat.modules.errorHandling.error({
            message:		"An error occurred when attempting to login. Please try again.",
            page:			"retrievequotesLogin.js:doLoginAndRetrieve()",
            errorLevel:		"warning",
            description:	errorThrown,
            data: exception
        });
    }

    /**
     * Display the correct modal for the user.
     * @param json
     * @private
     */
    function _failureModal(json) {

        var templateObj = {};
        if(json.length && typeof json[0].error !== 'undefined') {
            if(json[0].error == 'exceeded-attempts') {
                templateObj.suspended = true;
            } else {
                templateObj.errorMessage = json[0].error;
            }
        } else {
            templateObj.errorMessage = "The email address or password that you entered was incorrect.";
        }

        failModalId = meerkat.modules.dialogs.show({
            title: "A Problem Occurred",
            htmlContent: htmlTemplate(templateObj),
            buttons: [{
                label: "Ok",
                className: 'btn-default',
                closeWindow: true
            }]
        });
    }

    meerkat.modules.register("retrievequotesLogin", {
        init: initLogin,
        events: events,
        doLoginAndRetrieve: doLoginAndRetrieve,
        handleLoginFailure: handleLoginFailure
    });

})(jQuery);
/**
 * Description: External documentation:
 */


(function($, undefined) {

    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;

    var moduleEvents = {
        fuel: {

        },
        WEBAPP_LOCK : 'WEBAPP_LOCK',
        WEBAPP_UNLOCK : 'WEBAPP_UNLOCK'
    }, steps = null;

    var skipToResults = false;

    function initFuel() {
        $(document).ready(function() {
            // Only init if fuel
            if (meerkat.site.vertical !== "fuel")
                return false;

            meerkat.modules.fuelPrefill.setHashArray();

            // Init common stuff
            initJourneyEngine();
            eventDelegates();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
        });
    }

    function eventDelegates() { }


    function initJourneyEngine() {
        // Initialise the journey engine steps and bar
        initProgressBar(false);

        // Initialise the journey engine
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true && meerkat.modules.address.getWindowHashAsArray().length === 1) {
            startStepId = steps.startStep.navigationId;
            skipToResults = true;
        }
        // Use the stage user was on when saving their quote
        else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'latest') {
            startStepId = steps.resultsStep.navigationId;
        } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'amend') {
            startStepId = steps.startStep.navigationId;
        }

        $(document).ready(function(){
            meerkat.modules.journeyEngine.configure({
                startStepId : startStepId,
                steps : _.toArray(steps)
            });

            // Call initial supertag call
            var transaction_id = meerkat.modules.transactionId.get();

            if(meerkat.site.isNewQuote === false){
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method:'trackQuoteEvent',
                    object: {
                        action: 'Retrieve',
                        transactionID: parseInt(transaction_id, 10),
                        vertical: meerkat.site.vertical
                    }
                });
            } else {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: 'trackQuoteEvent',
                    object: {
                        action: 'Start',
                        transactionID: parseInt(transaction_id, 10),
                        vertical: meerkat.site.vertical
                    }
                });
            }
        });
    }


    /**
     * Initialise and configure the progress bar.
     *
     * @param {bool}
     *            render
     */
    function initProgressBar(render) {
        setJourneyEngineSteps();
        configureProgressBar();
        if (render) {
            meerkat.modules.journeyProgressBar.render(true);
        }
    }

    function setJourneyEngineSteps() {
        var startStep = {
            title : 'Fuel Details',
            navigationId : 'start',
            slideIndex : 0,
            validation: {
                validate: true
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            onInitialise: function(){
                meerkat.modules.fuelPrefill.initFuelPrefill();
            },
            onAfterEnter: function() {
                if (skipToResults) {
                    meerkat.modules.journeyEngine.gotoPath("next");
                    skipToResults = false;
                }
            }
        };

        var resultsStep = {
            title : 'Fuel Prices',
            navigationId : 'results',
            slideIndex : 1,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            additionalHashInfo: function() {
                var fuelTypes = $("#fuel_hidden").val(),
                    location = $("#fuel_location").val().replace(/\s/g, "+");

                return location + "/" + fuelTypes;
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.fuelResults.initPage();
                meerkat.modules.showMoreQuotesPrompt.initPromptBar();
                meerkat.modules.fuelSorting.initSorting();
                meerkat.modules.fuelResultsMap.initFuelResultsMap();
                meerkat.modules.fuelCharts.initFuelCharts();
            },
            onAfterEnter: function afterEnterResults(event) {
                meerkat.modules.fuelResults.get();
                meerkat.modules.fuelResultsMap.resetMap();
            },
            onAfterLeave: function(event) {
                if(event.isBackward) {
                    meerkat.modules.showMoreQuotesPrompt.disablePromptBar();
                }
            }
        };

        /**
         * Add more steps as separate variables here
         */
        steps = {
            startStep: startStep,
            resultsStep: resultsStep
        };
    }

    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([
            {
                label: 'Fuel Details',
                navigationId: steps.startStep.navigationId
            }, {
                label: 'Fuel Prices',
                navigationId: steps.resultsStep.navigationId
            }
        ]);
    }

    // Build an object to be sent by tracking.
    function getTrackingFieldsObject(special_case) {
        try {

            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furthest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

            var location = $("#fuel_location").val().split(' '),
                actionStep = '';

            switch (current_step) {
                case 0:
                    actionStep = "fuel details";
                    break;
                case 1:
                    if (special_case === true) {
                        actionStep = 'fuel more info';
                    } else {
                        actionStep = 'fuel results';
                    }
                    break;
            }

            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.transactionId.get()
            };

            // Push in values from 2nd slide only when have been beyond it
            if (furthest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
                _.extend(response, {
                    state: location[location.length-1],
                    postcode: location[location.length-2]
                });
            }

            return response;

        } catch (e) {
            return {};
        }
    }

    meerkat.modules.register("fuel", {
        init: initFuel,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);
/**
 * Description:
 * External documentation: https://developers.google.com/chart/interactive/docs/
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            fuelCharts: {}
        },
        moduleEvents = events.fuelCharts,
        modalTemplate,
        modalId,
        chart,
        chartData,
        chartOptions;

    function initChartsApi() {
        google.load('visualization', '1', {packages: ['corechart', 'line'], callback: drawChart});
    }

    function getChart() {
        return chart;
    }

    function initFuelCharts() {

        $(document).ready(function () {
            applyEventListeners();
            modalTemplate = _.template($('#price-chart-template').html());
        });

    }

    function applyEventListeners() {
        $('.openPriceHistory').click(function () {
            initChartsApi();
        });

        meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function () {
            if(typeof google !== 'undefined' && chartData && chartOptions && $('.fuelChart').length) {
                chart = new google.visualization.LineChart(document.getElementById('linechart_material'));
                chart.draw(chartData, chartOptions);
            }
        });
    }

    function squashDifferentFuelTypesToSingleDateArray(results) {
        return results.filter(function (element, index, array) {
            for (var i = 0; i < array.length; i++) {
                if(typeof array[i].amountObj == 'undefined') {
                    array[i].amountObj = {};
                    array[i].amountObj[array[i].type] = array[i].amount;
                }
                if (i == index) {
                    return true;
                }
                if (array[i].period == element.period) {
                    array[i].amountObj[element.type] = element.amount;
                    return false;
                }
            }
            return true;
        });
    }

    function getChartTitle() {
        var title = "Average daily prices <span class='hidden-xs'>for selected fuel types in and</span> around ";
        var location = $('#fuel_location').val();
        if (isNaN(location.substring(1, 5))) {
            title += location;
        } else {
            title += "the postcode: " + location;
        }

        return title;
    }

    var getFuelLabel = function (fuelid) {
        var labels = ['Unknown', 'Unknown', 'Unleaded', 'Diesel', 'LPG', 'Premium Unleaded 95', 'E10', 'Premium Unleaded 98', 'Bio-Diesel 20', 'Premium Diesel'];
        return labels[fuelid];
    }

    function drawChart() {

        createModal(function (modalId) {

            meerkat.modules.loadingAnimation.showInside($('#linechart_material'), true);
            var selectedFuelTypes = $('#fuel_hidden').val().split(',');

            // This part is here as when you select Diesel, it adds Premium Diesl to results.
            // If there are no Diesel, but premium diesel options, it won't show any graph for them.
            if(selectedFuelTypes.indexOf('3') != -1 && selectedFuelTypes.indexOf('9') == -1) {
                selectedFuelTypes.push('9');
            }
            meerkat.modules.comms.post({
                    url: "ajax/json/fuel_price_monthly_averages.jsp",
                    cache: true,
                    data: meerkat.modules.form.getSerializedData($('#mainform')),
                    errorLevel: "warning",
                    onSuccess: function onPriceHistorySuccess(result) {
                        chartData = new google.visualization.DataTable();
                        chartData.addColumn('date', 'Date');
                        chartData.addColumn('number', getFuelLabel(selectedFuelTypes[0]));
                        if (selectedFuelTypes[1]) {
                            chartData.addColumn('number', getFuelLabel(selectedFuelTypes[1]));
                        }
                        if (selectedFuelTypes[2]) {
                            chartData.addColumn('number', getFuelLabel(selectedFuelTypes[2]));
                        }
                        var prices = squashDifferentFuelTypesToSingleDateArray(result.results.prices);
                        for (var dataSet = [], i = 0; i < prices.length; i++) {
                            var row = [new Date(prices[i].period), Number(prices[i].amountObj[selectedFuelTypes[0]]) / 10];
                            if (selectedFuelTypes[1]) {
                                row.push(Number(prices[i].amountObj[selectedFuelTypes[1]]) / 10);
                            }
                            if (selectedFuelTypes[2]) {
                                row.push(Number(prices[i].amountObj[selectedFuelTypes[2]]) / 10);
                            }
                            dataSet.push(row);
                        }
                        chartData.addRows(dataSet);
                        chartOptions = {
                            height: 400,
                            legend: {
                                position: "bottom"
                            },
                            axisTitlesPosition: 'out',
                            hAxis: {
                                title: 'Collected Date',
                                format: 'EEE, MMM d'
                            },
                            tooltip: {
                                trigger: 'focus'
                            },
                            fontName: 'Source Sans Pro',
                            explorer: {
                                axis: 'horizontal',
                                actions: ['dragToZoom', 'rightClickToReset'],
                                keepInBounds: true
                            },
                            vAxis: {
                                title: 'Price Per Litre',
                                format: '###.#',
                                gridlines: {
                                    color: '#b2b2b2',
                                    count: -1
                                }
                            },
                            chartArea: {
                                top: 0
                            },
                            colors: ['#1c3e93', '#0db14b', '#b2b2b2']
                        };
                        chart = new google.visualization.LineChart(document.getElementById('linechart_material'));

                        chart.draw(chartData, chartOptions);
                        runTrackingCall(selectedFuelTypes);
                    }
                }
            )
            ;
        });
    }

    function runTrackingCall(selectedFuelTypes) {

        var location = $("#fuel_location").val().split(' ');
        for(var out= "", i = 0; i < selectedFuelTypes.length; i++) {
            out += ":" + getFuelLabel(selectedFuelTypes[i]);
        }
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackCustomPage',
            object: {
                customPage: "Fuel:PriceHistory" + out,
                state: location[location.length-1],
                postcode: location[location.length-2]
            }
        });
    }

    /**
     * The modal in this case is never destroyed. It is always kept and just shown using bootstraps own functions.
     * This is to avoid extra API calls to Google Maps.
     * This should only be run once per page load.
     */
    function createModal(onOpen) {
        var options = {
            htmlContent: modalTemplate({}),
            hashId: 'chart',
            className: 'fuelChart',
            onOpen: onOpen,
            title: getChartTitle()
        };
        modalId = meerkat.modules.dialogs.show(options);
    }

    function _handleError(e, page) {
        meerkat.modules.errorHandling.error({
            errorLevel: "warning",
            message: "An error occurred with loading the Fuel Price History. Please reload the page and try again.",
            page: page,
            description: "[Google Charts] Error Initialising API",
            data: {
                error: e.toString()
            },
            id: meerkat.modules.transactionId.get()
        });
    }

    meerkat.modules.register("fuelCharts", {
        initFuelCharts: initFuelCharts,
        events: events,
        getChart: getChart
    });

})
(jQuery);
;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var $checkboxes;

    function initFuelDetails() {
        $(document).ready(function() {
            $checkboxes = $("#checkboxes-all input");
           _registerEventListeners();
        });
    }

    function _registerEventListeners() {
        $(document)
            .on("change", "#checkboxes-all input", _onChangeCheckbox);
    }

    /**
     * Checks the number of selected checkboxes and toggles their availability
     * @param e
     * @private
     */
    function _onChangeCheckbox(e) {
        var $unchecked = $checkboxes.filter(":not(:checked)"),
            $checked = $checkboxes.filter(":checked");

        if($checked.length >= 2)
            $unchecked.attr("disabled", "disabled");
        else
            $checkboxes.removeAttr("disabled");

        var checkedValues = $checked.map(function(){ return this.value; }).get().join(",");
        $("#fuel_hidden").val(checkedValues);
        $("label[for='fuel_hidden']").remove();
        $checkboxes.removeClass("has-error");
    }

    meerkat.modules.register("fuelDetails", {
        init: initFuelDetails
    });
})(jQuery);
;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var hashArray,
        mapLoaded = false;

    function initFuelPrefill() {
        _registerSubscriptions();
        _eventDelegates();
    }

    function setHashArray(){
        hashArray = meerkat.modules.address.getWindowHashAsArray();
    }

    /**
     * Registers meerkat messaging subscriptions
     * @private
     */
    function _registerSubscriptions() {
        _populateInputs();
    }

    function _eventDelegates() {
        $(document).on("resultsAnimated", _findMap);
    }

    function _findMap() {
        if(mapLoaded === false && hashArray.length >= 4 && hashArray[3].match(/^(map-)/g)) {
            var siteId = hashArray[3].replace("map-", "");
            meerkat.modules.fuelResultsMap.openMap($(document).find("a[data-siteid='" + siteId + "']").first());
            mapLoaded = true;
        }
    }

    /**
     * Gets the available query params and attempts to populate inputs
     * @private
     */
    function _populateInputs() {
        if (typeof meerkat.site.formData !== "undefined" || hashArray.length >= 3) {
            _setFuelType();
            _setLocation();
        }
    }

    /**
     * Selects (up to) two fuels of a specified type
     * @private
     */
    function _setFuelType() {
        var fuelType;
        if(typeof hashArray[2] !== "undefined")
            fuelType = hashArray[2];
        else if(typeof meerkat.site.formData !== "undefined" && typeof meerkat.site.formData.fuelType !== "undefined")
            fuelType = meerkat.site.formData.fuelType;

        if(typeof fuelType !== "undefined") {
            var isCustomSelection = fuelType.match(/\d,?\d?/g);

            if(isCustomSelection) {
                var selected = fuelType.split(",").slice(0,2);

                $("#checkboxes-all .checkbox-custom").each(function() {
                        for(var i = 0; i < selected.length; i++) {
                            var $this = $(this);

                            if ($this.val() === selected[i])
                                $this.trigger("click");
                        }
                    });
            } else {
                var fuelTypeId;

                switch (fuelType) {
                    case "P":
                        fuelTypeId = "petrol";
                        break;
                    case "D":
                        fuelTypeId = "diesel";
                        break;
                    case "L":
                        fuelTypeId = "lpg";
                        break;
                    default:
                        return;
                }

                $("#checkboxes-" + fuelTypeId).find(".checkbox-custom").slice(0,2).trigger("click");
            }
        }
    }

    /**
     * Sets the value of the #fuel_location input.
     * @private
     */
    function _setLocation() {
        var location;
        if(typeof hashArray[1] !== "undefined" && hashArray[1].substr(0,7) !== "?stage=")
            location = hashArray[1].replace(/\+/g, " ");
        else if(typeof meerkat.site.formData !== "undefined" && typeof meerkat.site.formData.location !== "undefined")
            location = meerkat.site.formData.location;

        if(location !== "undefined")
            $("#fuel_location").val(location);
    }

    meerkat.modules.register("fuelPrefill", {
        initFuelPrefill: initFuelPrefill,
        setHashArray: setHashArray
    });
})(jQuery);
;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var events = {};

    function initPage(){
        _initResults();
        _registerEventListeners();
    }

    function _initResults() {
        try {
            var displayMode = 'price';

            // Init the main Results object
            Results.init({
                url: "ajax/json/fuel_price_results.jsp",
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.price",
                        general:  "results.general"
                    },
                    productId: "productId",
                    productName: "name",
                    productBrandCode: "provider",
                    price: {
                        premium: "priceText"
                    },
                    availability: {
                        product: "available"
                    },
                    sort: {
                        city: "city"
                    }
                },
                show: {
                    nonAvailableProducts: false, // This will apply the availability.product rule
                    unavailableCombined: true    // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
                },
                availability: {
                    product: ["equals", "Y"],
                    price: ["notEquals", -1] // As a filter this should never match, but is here due to inconsistent Car data model and work-around for Results.setFrequency
                },
                render: {
                    templateEngine: '_',
                    dockCompareBar: false
                },
                displayMode: displayMode, // features, price
                pagination: {
                    mode: 'page',
                    touchEnabled: Modernizr.touch
                },
                sort: {
                    sortBy: 'price.premium',
                    city: "sort.city"
                },
                animation: {
                    results: {
                        individual: {
                            active: false
                        },
                        delay: 500,
                        options: {
                            easing: "swing", // animation easing type
                            duration: 1000
                        }
                    },
                    shuffle: {
                        active: true,
                        options: {
                            easing: "swing", // animation easing type
                            duration: 1000
                        }
                    },
                    filter: {
                        reposition: {
                            options: {
                                easing: "swing" // animation easing type
                            }
                        }
                    }
                },
                elements: {
                    features:{
                        values: ".content",
                        extras: ".children"
                    }
                },
                templates:{
                    pagination:{
                        pageText: 'Product {{=currentPage}} of {{=totalPages}}'
                    }
                },
                rankings: {
                    triggers : ['RESULTS_DATA_READY'],
                    callback : _rankingCallback,
                    forceIdNumeric : false,
                    filterUnavailableProducts : true
                },
                incrementTransactionId : false
            });
        }
        catch(e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.fuel.initResults(); ' + e.message, e);
        }
    }

    function _rankingCallback(product, position) {
        var data = {};

        // If the is the first time sorting, send the prm as well
        data["rank_premium" + position] = product.price;
        data["rank_productId" + position] = product.productId;

        return data;
    }

    function _registerEventListeners() {
        // When the navar docks/undocks
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $('#resultsPage').css('margin-top', '35px');
        });

        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $('#resultsPage').css('margin-top', '0');
        });

        // If error occurs, go back in the journey
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function() {
            // Delayed to allow journey engine to unlock
            _.delay(function() {
                meerkat.modules.journeyEngine.gotoPath('previous');
            }, 1000);
        });

        // Run the show method even when there are no available products
        // This will render the unavailable combined template
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });

        // Scroll to the top when results come back
        $(document).on("resultsReturned", function() {
            meerkat.modules.utils.scrollPageTo($("header"));
            _updateDisclaimer();
        });

        // Start fetching results
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            $('#resultsPage, .loadingDisclaimerText').removeClass('hidden');
        });

        // Fetching done
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $('.loadingDisclaimerText').addClass('hidden');

            $(document.body).removeClass('priceMode').addClass('priceMode');

            // If no providers opted to show results, display the no results modal.
            var availableCounts = 0;
            $.each(Results.model.returnedProducts, function(){
                if (this.available === 'Y' && this.productId !== 'CURR') {
                    availableCounts++;
                }
            });

            // You've been blocked!
            if (availableCounts === 0 && !Results.model.hasValidationErrors && Results.model.isBlockedQuote) {
                showBlockedResults();
                return;
            }

            // Check products length in case the reason for no results is an error e.g. 500
            if (availableCounts === 0 && _.isArray(Results.model.returnedProducts)) {
                showNoResults();
                _.delay(function() {
                    meerkat.modules.journeyEngine.gotoPath('previous');
                }, 1000);
                return;
            }

            if(Results.getReturnedGeneral().source == "regional") {
                Results.view.showNoResults();
                _openRegionalModal();
                return;
            }

            // Results are hidden in the CSS so we don't see the scaffolding after #benefits
            $(Results.settings.elements.page).show();
        });

        $(Results.settings.elements.resultsContainer).on('click', '.result-row', _onResultRowClick);
    }

    function _onResultRowClick(event) {
        // Ensure only in XS price mode
        if ($(Results.settings.elements.resultsContainer).hasClass('priceMode') === false || meerkat.modules.deviceMediaState.get() !== 'xs') return;

        var $resultrow = $(event.target);
        if ($resultrow.hasClass('result-row') === false) {
            $resultrow = $resultrow.parents('.result-row');
        }

        var $mapButton = $resultrow.find(".map-open");
        meerkat.modules.fuelResultsMap.openMap($mapButton);
    }

    function get() {
        Results.get();
        _updateSnapshot();
    }

    function _updateDisclaimer() {
        var general = Results.getReturnedGeneral();
        if(typeof general.timeDiff !== "undefined") {
            $("#provider-disclaimer .time").text(general.timeDiff);
        }
    }

    function _updateSnapshot() {
        var fuelTypeArray = [];

        $("#checkboxes-all :checked").each(function() {
            var pushValue = "<strong>" + $.trim($(this).next("label").text()) + "</strong>";
            fuelTypeArray.push(pushValue);
        });

        var fuelTypes = fuelTypeArray.join(" &amp; "),
            location = $("#fuel_location").val(),
            data = {
                fuelTypes: fuelTypes,
                location: location
            },
            template = _.template($("#snapshot-template").html(), data, { variable: "data" });
        $("#resultsSummaryPlaceholder").html(template);
    }

    function init() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
    }

    function _openRegionalModal() {

        var $tpl = $('#regional-results-template'),
            htmlString = "";
        if ($tpl.length > 0) {
            var htmlTemplate = _.template($tpl.html());
            Results.sortBy(Results.settings.sort.city, "asc");
            htmlString = htmlTemplate(Results.getSortedResults());
        }
        if(htmlString.length) {
            meerkat.modules.dialogs.show({
                title: "Regional Price Average",
                htmlContent: htmlString
            });
        } else {
            showNoResults();
        }
        _.delay(function() {
            meerkat.modules.journeyEngine.gotoPath('previous');
        }, 1000);

    }

    function showNoResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $('#no-results-content')[0].outerHTML
        });
    }

    function showBlockedResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $('#blocked-ip-address')[0].outerHTML
        });
    }

    function getFormattedTimeAgo(date) {
        return "Last updated " + meerkat.modules.utils.getTimeAgo(date) + " ago";
    }

    /**
     * This function has been refactored into calling a core resultsTracking module.
     * It has remained here so verticals can run their own unique calls.
     */
    function publishExtraSuperTagEvents(additionalData) {
        additionalData = typeof additionalData === 'undefined' ? {} : additionalData;
        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: $.extend({
                sortBy: Results.getSortBy() + '-' + Results.getSortDir()
            }, additionalData),
            onAfterEventMode: 'Refresh'
        });
    }

    meerkat.modules.register("fuelResults", {
        init: init,
        initPage: initPage,
        events: events,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        get: get,
        getFormattedTimeAgo: getFormattedTimeAgo
    });
})(jQuery);
/**
 * Description: Google Developer Console set up under user ben.thompson@comparethemarket.com.au and software@comparethemarket.com.au.
 * External documentation: https://developers.google.com/maps/documentation/javascript/3.exp/reference
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            fuelResultsMap: {}
        },
        moduleEvents = events.fuelResultsMap;

    /**
     * Google API key from the Developers Console.
     * @source https://console.developers.google.com/project/ctm-fuel-map/apiui/apiview/maps_backend/usage
     * @type {string}
     */
    var googleAPIKey = 'AIzaSyC8ygWPujOpSI1O-7jsiyG3_YIDlPoIP6U';
    /**
     * The google Map object
     * @type {Map}
     */
    var map;
    /**
     * The infoWindow object for the current info window.
     * @type {InfoWindow}
     */
    var infoWindow;
    var markers = {};
    /**
     * The current latitude or longitude from the clicked map.
     * @type {String|Number}
     */
    var currentLat,
        currentLng; //String/Number
    var markerTemplate,
        modalId,
        siteId,
        modalTemplate,
        windowResizeListener;

    /**
     * Asynchronously load in the Google Maps API and then calls initCallback
     * Uses Google Developer Console API Key
     */
    function initGoogleAPI() {
        if (typeof map !== 'undefined') {
            return;
        }
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = 'https://maps.googleapis.com/maps/api/js?key=' + googleAPIKey + '&v=3.exp' +
        '&signed_in=false&callback=meerkat.modules.fuelResultsMap.initCallback';
        script.onerror = function (msg, url, linenumber) {
            _handleError(msg + ':' + linenumber, "fuelResultsMap.js:initGoogleAPI");
        };
        document.body.appendChild(script);
    }

    /**
     * This is executed as a callback to loading the script asynchronously.
     */
    function initCallback() {
        try {
            var mapOptions = {
                zoom: 15, // higher the number, closer to the ground.
                minZoom: 11, // e.g. 0 is whole world
                center: createLatLng(currentLat, currentLng),
                mapTypeId: google.maps.MapTypeId.ROAD,
                mapTypeControlOptions: {
                    style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
                }
            };

            // Create the modal so that map-canvas exists in the DOM.
            createModal();
            // Initialise the Google Map
            map = new google.maps.Map(document.getElementById('map-canvas'),
                mapOptions);
            // Initialise the info window
            infoWindow = new google.maps.InfoWindow();

            // Plot all the markers for the current result set.
            plotMarkers();
        } catch (e) {
            _handleError(e, "fuelResultsMap.js:initCallback");
        }

    }

    function initFuelResultsMap() {

        $(document).ready(function ($) {
            applyEventListeners();
            markerTemplate = _.template($('#map-marker-template').html());
            modalTemplate = _.template($('#google-map-canvas-template').html());
        });

    }

    function applyEventListeners() {
        $(document).on('click', '.map-open', function () {
            openMap($(this));
        });
    }

    /**
     * Determines whether to initialise a new map or open an existing one
     * When opens existing one, it resets to the
     * @param $el
     */
    function openMap($el) {
        currentLat = $el.data('lat');
        currentLng = $el.data('lng');
        Results.setSelectedProduct($el.attr('data-productid'));

        if (typeof map === 'undefined') {
            initGoogleAPI();
        } else {
            // If no markers (resets in fuel:onAfterEnter for results step.
            if (!_.keys(markers).length) {
                plotMarkers();
            }
            $('#' + modalId).modal('show');
            infoWindow.close();
            var product = Results.getSelectedProduct();

            siteId = product.siteid;
            meerkat.modules.address.appendToHash('map-' + siteId);

            if (product) {
                openInfoWindow(markers[product.siteid], product);
                centerMap(createLatLng(currentLat, currentLng));
            }
        }
        //open map counted as bridging click
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method:	'trackQuoteForms',
            object:	_.bind(meerkat.modules.fuel.getTrackingFieldsObject, this, true)
        });

    }

    function centerMap(LatLng) {
        map.panTo(LatLng);
    }

    /**
     * Utility function to create a LatLng object from two values.
     * @param lat
     * @param lng
     * @returns {google.maps.LatLng}
     */
    function createLatLng(lat, lng) {
        return new google.maps.LatLng(
            parseFloat(lat),
            parseFloat(lng)
        );
    }


    /**
     * We only need to plot the markers once per results view.
     * The markers are reset
     */
    function plotMarkers() {
        var results = filterDuplicatesOut(Results.getFilteredResults());
        var bounds = new google.maps.LatLngBounds();

        var focusMarker, focusCoords, focusInfo;

        for (var selectedProduct = Results.getSelectedProduct(),
                 i = 0; i < results.length; i++) {
            var latLng = createLatLng(results[i].lat, results[i].long);
            var marker = createMarker(latLng, results[i]);
            markers[results[i].siteid] = marker;
            if (results[i].siteid == selectedProduct.siteid) {
                openInfoWindow(marker, results[i]);
                focusMarker = marker;
                focusCoords = latLng;
                focusInfo = results[i];
            }
            bounds.extend(latLng);
        }

        map.fitBounds(bounds);

        if (focusMarker && focusCoords && focusInfo) {
            centerMap(focusCoords);
            openInfoWindow(focusMarker, focusInfo);
        }
    }

    /**
     * When you are loading two different types of fuel, you get duplicate records
     * Hence we cannot use getFilteredResults as-is.
     * This loop smushes the other fuel prices for that station into one result.
     * @param results
     * @returns {*}
     */
    function filterDuplicatesOut(results) {
        return results.filter(function (element, index, array) {
            for (var i = 0; i < array.length; i++) {
                if (i == index) {
                    return true;
                }
                if (array[i].siteid == element.siteid) {
                    if (!array[i].price2Text) {
                        array[i].price2Text = element.priceText;
                        array[i].price2 = element.price;
                        array[i].fuel2Text = element.fuelText;
                    } else {
                        array[i].price3Text = element.priceText;
                        array[i].price3 = element.price;
                        array[i].fuel3Text = element.fuelText;
                    }

                    return false;
                }
            }
            return true;
        });
    }

    /**
     * Create the marker objects and bind click events.
     * @param latLng
     * @param info
     * @param markerOpts
     * @returns {google.maps.Marker}
     */
    function createMarker(latLng, info, markerOpts) {

        var marker = new google.maps.Marker({
            map: map,
            position: latLng,
            icon: 'brand/ctm/graphics/fuel/map-pin.png',
            animation: google.maps.Animation.DROP
        });

        google.maps.event.addListener(marker, 'click', function () {
            openInfoWindow(marker, info);
        });
        return marker;
    }

    /**
     * open the infoWindow inside a google map on marker click and by default.
     * @param marker
     * @param info
     */
    function openInfoWindow(marker, info) {
        var htmlString = "";
        if (markerTemplate) {
            htmlString = markerTemplate(info);
            infoWindow.setContent(htmlString);
            infoWindow.open(map, marker);

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackProductView',
                object: {
                    productID: info.productId || null,
                    productBrandCode: info.provider || null,
                    productName: (info.name || "") + " " + (info.fuelText || "")
                }
            });

        } else {
            _handleError("", 'An error occurred displaying information for this fuel provider.');
        }
    }

    /**
     * The modal in this case is never destroyed. It is always kept and just shown using bootstraps own functions.
     * This is to avoid extra API calls to Google Maps.
     * This should only be run once per page load.
     */
    function createModal() {
        var options = {
            htmlContent: modalTemplate(Results.getSelectedProduct()),
            hashId: 'map-' + Results.getSelectedProduct().siteid,
            className: 'googleMap',
            closeOnHashChange: false,
            destroyOnClose: false,
            onClose: onClose,
            onOpen: setMapHeight,
            fullHeight: true
        };
        modalId = meerkat.modules.dialogs.show(options);

        if(windowResizeListener) {
            google.maps.event.removeListener(windowResizeListener);
        }
        windowResizeListener = google.maps.event.addDomListener(window, "resize", function () {
            if(typeof google !== 'undefined' && $('#'+modalId).length) {
                meerkat.modules.dialogs.resizeDialog(modalId);
                setMapHeight();
                google.maps.event.trigger(map, "resize");
                map.setCenter(createLatLng(currentLat, currentLng));
            }
        });
    }

    function onClose() {
        if(siteId)
            meerkat.modules.address.removeFromHash('map-' + siteId);
    }

    function setMapHeight() {
        _.defer(function () {
            var isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false,
                $modalContent = $('.googleMap .modal-body');
            var heightToSet = isXS ? $modalContent.css('height') : $modalContent.css('max-height');
            $('#google-map-container').css('height', heightToSet);
        });
    }

    function resetMap() {
        if (infoWindow) {
            infoWindow.close();
        }
        _clearMarkers();
    }

    function _clearMarkers() {
        var keys = _.keys(markers);
        if (!keys.length) {
            return;
        }
        for (var i = 0; i < keys.length; i++) {
            markers[keys[i]].setMap(null);
        }
        markers = {};
    }

    function getMap() {
        return map;
    }

    function _handleError(e, page) {
        meerkat.modules.errorHandling.error({
            errorLevel: "warning",
            message: "An error occurred with loading the Google Map. Please reload the page and try again.",
            page: page,
            description: "[Google Maps] Error Initialising Map",
            data: {
                error: e.toString()
            },
            id: meerkat.modules.transactionId.get()
        });
    }

    meerkat.modules.register("fuelResultsMap", {
        initFuelResultsMap: initFuelResultsMap,
        events: events,
        initCallback: initCallback,
        resetMap: resetMap,
        getMap: getMap,
        openMap: openMap
    });

})(jQuery);
;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var $signUpForm;

    function initFuelSignup() {
        _registerEventListeners();
        $(document).ready(function() {
            $signUpForm = $("#sign-up-form");
            meerkat.modules.validation.setupDefaultValidationOnForm($signUpForm);
        });
    }

    function _registerEventListeners() {
        $(document)
            .on("click", "#fuel_signup_terms, #fuel_signup_privacyoptin", _toggleCheckboxHidden)
            .on("click", ".fuel-sign-up", _onClickFuelSignup);
    }

    function _toggleCheckboxHidden(e) {
        var $this = $(e.target),
            hiddenVal = $this.prop("checked") ? "Y" : "";
        $("#" + $this.attr("id") + "Hidden").val(hiddenVal).valid();
    }

    function _onClickFuelSignup() {
        if($signUpForm.valid()) {
            var $promise = meerkat.modules.comms.post({
                errorLevel: "warning",
                url: "ajax/write/fuel_signup.jsp",
                dataType: "xml",
                data: $signUpForm.serialize()
            });

            $promise
                .done(function(xml) {
                    var resultCode = $(xml).find("resultcode").text();

                    if(resultCode === "0") {
                        // Success
                        _signupSuccess();
                    } else {
                        // Failure
                        _signupFail();
                    }
                })
                .fail(_signupFail);
        }
    }

    function _signupSuccess() {
        var data = $signUpForm.serializeArray(),
            templateData = {};

        for(var i = 0; i < data.length; i++) {
            var current = data[i],
                name = current.name.match(/[a-zA-Z]{1,}$/g)[0];
            templateData[name] = current.value;
        }

        var html = _.template($("#signup-success-template").html(), templateData, { variable: "data" });
        $signUpForm.html(html);
    }

    function _signupFail() {
        $signUpForm.find(".form-submit-error-message").removeClass("hidden");
    }

    meerkat.modules.register("fuelSignup", {
        init: initFuelSignup
    });
})(jQuery);
/*
 This module supports the Sorting for fuel results page.
 Travel, Utilities, Fuel use the same logic but copied and pasted.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        error = meerkat.logging.error,
        $sortElements,
        defaultSortStates = {
            'price.premium': 'asc'
        },
        sortByMethods = {
            'price.premium': null
        };

    //Sorting is a kind of filtering for now in the events
    var events = {
            fuelSorting: {
                CHANGED: 'FUEL_SORTING_CHANGED'
            }
        },
        moduleEvents = events.fuelSorting;

    //Set from an element clicked
    function setSortFromTarget($elem) {
        var sortType = $elem.attr('data-sort-type');
        var sortDir = $elem.attr('data-sort-dir');

        if (typeof sortType !== 'undefined' && typeof sortDir !== 'undefined') {

            //Update the direction on the element if it was already sorted this way.
            if ((sortType === Results.getSortBy()) && (sortDir === Results.getSortDir())) {

                sortDir = sortDir === 'asc' ? 'desc' : 'asc';
                $elem.attr('data-sort-dir', sortDir);
            }

            //Combined version call is better! Now returns a bool!
            //Set it, run it and check the return before setting classes
            Results.setSortByMethod(sortByMethods[sortType]);
            var sortByResult = Results.sortBy(sortType, sortDir);
            if (sortByResult) { //Successful sorting
                //Clear active classes and Mark as current
                /**
                 * This helps utilise the existing bootstrap navbar 'active' styling
                 * by adding the class to the parent li instead of the item itself.
                 */
                $sortElements.parent('li').removeClass('active');
                $elem.parent('li').addClass('active');

                meerkat.modules.resultsTracking.setResultsEventMode('Refresh');
                meerkat.modules.fuelResults.publishExtraSuperTagEvents({products: [], recordRanking: 'N'});
            } else {
                error('[fuelSorting]', 'The sortBy or sortDir could not be set', setSortByReturn, setSortDirReturn);
            }

        } else {
            error('[fuelSorting]', 'No data on sorting element');
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
        }
    }


    function initSorting() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, function sortedCallback(obj) {
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
        });

        $sortElements.on('click', function sortingClickHandler(event) {
            //We clicked this
            var $clicked = $(event.target);
            if (!($clicked.is('a'))) {
                $clicked = $clicked.closest('a');
            }

            if (!($clicked.hasClass('disabled'))) {
                //Lock Sorting.
                meerkat.messaging.publish(meerkatEvents.WEBAPP_LOCK);

                //defer here allows it to be as responsive as possible to the click, since this is an expensive operation to actually sort animate things.
                _.defer(function deferredSortClickWrapper() {
                    // check if resetState is enabled and that the clicked item isn't the currently clicked item
                    if (!$clicked.parent().hasClass('active')) {
                        resetSortDir($clicked);
                    }
                    setSortFromTarget($clicked);
                });
            }
        });

        // On application lockdown/unlock, disable/enable the dropdown
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockSorting(obj) {
            $sortElements.addClass('inactive disabled');
        });

        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockSorting(obj) {
            $sortElements.removeClass('inactive disabled');
        });
    }

    // Reset the sort dir everytime we click on a sortable column header
    function resetSortDir($elem) {
        var sortType = $elem.attr('data-sort-type'); // grab the currently clicked sort type
        $elem.attr('data-sort-dir', defaultSortStates[sortType]); // reset this element's default sort state
    }

    function init() {
        $(document).ready(function fuelSortingInitDomready() {
            $sortElements = $('[data-sort-type]');
        });
    }

    function resetToDefaultSort() {
        var $priceSortEl = $("[data-sort-type='price.premium']");
        var sortBy = Results.getSortBy(),
            price = 'price.premium';

        if (sortBy != price || ($priceSortEl.attr('data-sort-dir') == 'desc' && sortBy == price)) {
            $priceSortEl.parent('li').siblings().removeClass('active').end().addClass('active').end().attr('data-sort-dir', 'desc');
            Results.setSortBy('price.premium');
            Results.setSortDir('desc');
        }

    }

    meerkat.modules.register('fuelSorting', {
        init: init,
        initSorting: initSorting,
        events: events,
        resetToDefaultSort: resetToDefaultSort
    });

})(jQuery);
/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var moduleEvents = {
        retrievequotesComponent: {},
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    function initJourneyEngine() {
        initProgressBar(false);
        var startStepId = null;
        $(document).ready(function() {
            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });
        });
    }
    function initProgressBar(render) {
        setJourneyEngineSteps();
    }
    function setJourneyEngineSteps() {
        var startStep = {
            title: "Login",
            navigationId: "login",
            slideIndex: 0,
            onInitialise: function onStartInit(event) {},
            validation: {
                validate: true,
                customValidation: function(callback) {
                    meerkat.modules.retrievequotesLogin.doLoginAndRetrieve().done(function(data, textStatus, jqXHR) {
                        if (typeof data !== "undefined" && data !== null && data.previousQuotes) {
                            callback(true);
                        } else {
                            callback(false);
                            meerkat.modules.retrievequotesLogin.handleLoginFailure(jqXHR, textStatus, "");
                        }
                    }).fail(function(jqXHR, textStatus, errorThrown) {
                        callback(false);
                        meerkat.modules.retrievequotesLogin.handleLoginFailure(jqXHR, textStatus, errorThrown);
                    });
                }
            }
        };
        var resultsStep = {
            title: "Your Quotes",
            navigationId: "quotes",
            slideIndex: 1,
            onBeforeEnter: function() {}
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

console.log("forgotPassword");

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        retrievequotesLogin: {}
    }, moduleEvents = events.retrievequotesLogin, failModalId, $loginFailureTemplate, htmlTemplate = function() {
        return "";
    };
    function initLogin() {
        $(document).ready(function($) {
            $loginFailureTemplate = $("#failed-login-template").html();
            if ($loginFailureTemplate.length) {
                htmlTemplate = _.template($loginFailureTemplate);
            }
        });
    }
    function doLoginAndRetrieve() {
        var data = meerkat.modules.form.getData($("#loginForm"));
        return meerkat.modules.comms.post({
            url: "ajax/json/retrieve_quotes.jsp",
            data: data,
            errorLevel: "warning",
            useDefaultErrorHandling: false,
            cache: false,
            dataType: "json"
        });
    }
    function handleLoginFailure(jqXHR, textStatus, errorThrown) {
        var responseText = jqXHR.responseText;
        if (!responseText) {
            return false;
        }
        var responseJson = {};
        try {
            responseJson = $.parseJSON(responseText);
        } catch (e) {
            _submitError(e, "Could not decode responseText to JSON");
        }
        _.delay(function() {
            meerkat.modules.journeyEngine.gotoPath("previous");
        }, 1e3);
        _failureModal(responseJson);
    }
    function _submitError(exception, errorThrown) {
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
            source: "retrievequotesLogin"
        });
        meerkat.modules.errorHandling.error({
            message: "An error occurred when attempting to login.",
            page: "retrievequotesLogin.js:doLoginAndRetrieve()",
            errorLevel: "warning",
            description: errorThrown,
            data: exception
        });
    }
    function _failureModal(json) {
        var templateObj = {};
        if (json.length && typeof json[0].error !== "undefined") {
            if (json[0].error == "exceeded-attempts") {
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
            buttons: [ {
                label: "Ok",
                className: "btn-default",
                closeWindow: true
            } ]
        });
    }
    meerkat.modules.register("retrievequotesLogin", {
        init: initLogin,
        events: events,
        doLoginAndRetrieve: doLoginAndRetrieve,
        handleLoginFailure: handleLoginFailure
    });
})(jQuery);
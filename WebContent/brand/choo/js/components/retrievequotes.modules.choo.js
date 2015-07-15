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
            onAfterEnter: function onStartAfterEnter() {
                if (meerkat.site.loggedIn) meerkat.modules.journeyEngine.gotoPath("next");
            },
            validation: {
                validate: true,
                customValidation: function(callback) {
                    if (meerkat.site.loggedIn) {
                        callback(true);
                        return;
                    }
                    meerkat.modules.retrievequotesLogin.doLoginAndRetrieve().done(function(data, textStatus, jqXHR) {
                        if (typeof data !== "undefined" && data !== null && data.previousQuotes) {
                            meerkat.site.responseJson = data;
                            callback(true);
                        } else {
                            try {
                                callback(false);
                            } catch (e) {}
                            meerkat.modules.retrievequotesLogin.handleLoginFailure(jqXHR, textStatus, "");
                        }
                    }).fail(function(jqXHR, textStatus, errorThrown) {
                        try {
                            callback(false);
                        } catch (e) {}
                        meerkat.modules.retrievequotesLogin.handleLoginFailure(jqXHR, textStatus, errorThrown);
                        return;
                    });
                }
            }
        };
        var resultsStep = {
            title: "Your Quotes",
            navigationId: "quotes",
            slideIndex: 1,
            onBeforeEnter: function() {
                meerkat.modules.retrievequotesListQuotes.renderQuotes();
            },
            onAfterEnter: function() {
                if ($.trim($("#quote-result-list").html()) === "") {
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

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var forgotPasswordModal;
    function initRetrieveQuotesForgotPassword() {
        _registerEventListeners();
    }
    function _registerEventListeners() {
        $(document).on("click", ".forgot-password", _onForgotPasswordLinkClick).on("click", ".reset-password", _onResetPasswordLinkClick);
    }
    function _onForgotPasswordLinkClick() {
        var forgotPasswordFormHTML = _.template($("#forgot-password-template").html())();
        forgotPasswordModal = meerkat.modules.dialogs.show({
            htmlContent: forgotPasswordFormHTML,
            hashId: "forgot-password",
            buttons: [ {
                label: "Back",
                className: "btn-close-dialog"
            }, {
                label: "Reset Password",
                className: "btn-secondary reset-password"
            } ],
            onOpen: function(dialogId) {
                meerkat.modules.validation.setupDefaultValidationOnForm($("#forgot-password-form"));
                var usedEmail = $("#login_email").val();
                $("#login_forgotten_email").val(usedEmail);
            }
        });
    }
    function _onResetPasswordLinkClick() {
        var $emailField = $("#login_forgotten_email");
        if ($emailField.valid()) {
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
                var successHTML = _.template($("#reset-password-failure-template").html(), {
                    message: message
                });
                meerkat.modules.dialogs.show({
                    title: "Reset Password Error",
                    htmlContent: successHTML,
                    hashId: "forgot-password",
                    buttons: [ {
                        label: "OK",
                        className: "btn-secondary btn-close-dialog"
                    } ]
                });
            };
            $ajax.done(function(data) {
                if (typeof data === "string") data = JSON.parse(data);
                if (typeof data.result !== "undefined") {
                    var result = data.result;
                    if (result === "OK") {
                        var successHTML = _.template($("#reset-password-success-template").html(), {
                            email: $emailField.val()
                        }, {
                            variable: "data"
                        });
                        meerkat.modules.dialogs.show({
                            title: "Reset Password",
                            htmlContent: successHTML,
                            hashId: "forgot-password",
                            buttons: [ {
                                label: "OK",
                                className: "btn-secondary btn-close-dialog"
                            } ]
                        });
                    } else {
                        var message = data.message || genericFailMessage, errorObj = {
                            login_forgotten_email: message
                        };
                        $("#forgot-password-form").validate().showErrors(errorObj);
                    }
                } else {
                    onFail();
                }
            }).fail(function() {
                onFail();
            }).always(function() {
                meerkat.modules.dialogs.close(forgotPasswordModal);
                meerkat.modules.loadingAnimation.hide($resetPasswordButton);
            });
        }
    }
    meerkat.modules.register("retrievequotesComponentForgotPassword", {
        init: initRetrieveQuotesForgotPassword
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var rowContainerTemplate, verticalTemplates = {};
    function initRetrievequotesListQuotes() {
        _registerEventListeners();
        $(document).ready(function() {
            var $resultsTemplate = $("#retrieve-quotes-container-template");
            if ($resultsTemplate.length) {
                rowContainerTemplate = _.template($resultsTemplate.html());
            }
            verticalTemplates = {
                quote: $("#retrieve-car-template").html(),
                health: $("#retrieve-health-template").html(),
                life: $("#retrieve-life-template").html(),
                ip: $("#retrieve-ip-template").html(),
                homeloan: $("#retrieve-homeloan-template").html(),
                home: $("#retrieve-home-template").html()
            };
        });
    }
    function _registerEventListeners() {
        $(document).on("click", "#logout-user", _onClickLogoutUser).on("click", "#new-quote", _onClickNewQuote).on("click", ".btn-latest", _onClickLatest).on("click", ".btn-amend", _onClickAmend).on("click", ".btn-pending", _onClickPending).on("click", ".btn-start-again", _onClickStartAgain);
    }
    function _onClickPending(e) {
        var data = _getClickElementData(e.target), url = data.vertical + "_quote.jsp?action=confirmation&PendingID=" + encodeURIComponent(data.pendingID);
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
                buttons: [ {
                    label: "OK",
                    className: "btn-close-dialog"
                } ]
            });
            meerkat.modules.journeyEngine.loadingHide();
        };
        $ajax.done(function(data) {
            if (typeof data === "string") data = JSON.parse(data);
            if (data.success && data.success === true) {
                window.location.href = "retrieve_quotes.jsp";
                return;
            }
            onFail();
        }).fail(function() {
            onFail();
        });
    }
    function noResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#new-quote-template").html(),
            buttons: [ false ],
            onOpen: function(dialogId) {
                $("#" + dialogId).find(".btn-close-dialog, .modal-footer").remove();
            }
        });
    }
    function _onClickNewQuote(e) {
        meerkat.modules.dialogs.show({
            htmlContent: $("#new-quote-template").html()
        });
    }
    function _getClickElementData(element) {
        var $element = $(element);
        if (typeof $element.attr("data-vertical") === "undefined") $element = $element.closest("a");
        var data = {
            $element: $element,
            vertical: $element.attr("data-vertical"),
            transactionId: $element.attr("data-transactionid")
        };
        if ($element.attr("data-inpast") === "Y") data.inPast = "Y";
        if ($element.attr("data-pendingid")) data.pendingID = $element.attr("data-pendingid");
        return data;
    }
    function _onClickLatest(e) {
        var data = _getClickElementData(e.target);
        meerkat.modules.dialogs.show({
            title: "Enter New Commencement Date",
            htmlContent: $("#new-commencement-date-template").html(),
            buttons: [ {
                label: "Cancel",
                className: "btn-close-dialog"
            }, {
                label: "Get Latest Results",
                className: "btn-cta btn-submit"
            } ],
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
    function _onClickStartAgain(e) {
        var data = _getClickElementData(e.target);
        _retrieveQuote(data.vertical, "start-again", data.transactionId);
    }
    function _onClickAmend(e) {
        var data = _getClickElementData(e.target);
        _retrieveQuote(data.vertical, "amend", data.transactionId);
    }
    function _retrieveQuote(vertical, action, transactionId, newDate) {
        if (vertical === "quote") vertical = "car";
        meerkat.modules.utils.scrollPageTo("html, body");
        meerkat.modules.journeyEngine.loadingShow("Retrieving your quote...");
        var data = {
            vertical: vertical,
            action: action,
            transactionId: transactionId
        };
        if (newDate) data.newDate = newDate;
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
                buttons: [ {
                    label: "OK",
                    className: "btn-secondary btn-close-dialog"
                } ]
            });
            meerkat.modules.journeyEngine.loadingHide();
        };
        $ajax.done(function(data) {
            if (typeof data === "string") data = JSON.parse(data);
            if (data && data.result) {
                var result = data.result;
                if (result.destUrl) {
                    window.location.href = result.destUrl + "&ts=" + Number(new Date());
                    return;
                } else {
                    if (result.showToUser && result.error) {
                        onFail(result.error);
                        return;
                    }
                }
            }
            onFail();
        }).fail(function() {
            onFail();
        });
    }
    function renderQuotes() {
        $("#quote-result-list").html(rowContainerTemplate(meerkat.site.responseJson));
    }
    function renderTemplate(vertical, data) {
        if (!vertical) {
            return "";
        }
        try {
            var htmlTemplate = _.template(verticalTemplates[vertical]);
            return htmlTemplate(data);
        } catch (e) {
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
            if (keys[k] != "id") {
                return keys[k];
            }
        }
        return false;
    }
    function getGenderString(gender) {
        return gender == "M" ? "Male" : "Female";
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
        if (rating == 6) {
            return "Rating 6 No NCD";
        }
        return typeof rating == "undefined" ? "" : "Rating " + rating + " (" + value + " Years) NCD";
    }
    function healthBenefitsList(data) {
        if (typeof data == "undefined" || typeof data.benefitsExtras == "undefined") {
            return "";
        }
        var keys = Object.keys(data.benefitsExtras), outList = [];
        for (var i = 0; i < keys.length; i++) {
            if (data.benefitsExtras[keys[i]] == "Y") {
                outList.push(keys[i]);
            }
        }
        return outList.join(", ");
    }
    function getHomeloanSituation(situation) {
        switch (situation) {
          case "F":
            return "A First Home Buyer";

          case "E":
            return "An Existing Home Owner";
        }
        return "";
    }
    function getHomeloanGoal(goal) {
        switch (goal) {
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

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        retrievequotesLogin: {}
    }, moduleEvents = events.retrievequotesLogin, failModalId, $loginFailureTemplate, htmlTemplate = function() {
        return "";
    };
    function initLogin() {
        _registerEventListeners();
        $(document).ready(function($) {
            $loginFailureTemplate = $("#failed-login-template");
            if ($loginFailureTemplate.length) {
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
    function doLoginAndRetrieve() {
        var data = meerkat.modules.form.getData($("#loginForm"));
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
    function handleLoginFailure(jqXHR, textStatus, errorThrown) {
        meerkat.modules.journeyEngine.unlockJourney();
        meerkat.modules.address.setHash("login");
        var responseText = jqXHR.responseText;
        if (!responseText) {
            _submitError({
                url: jqXHR.url
            }, "No responseText for request");
            return false;
        }
        var responseJson = {};
        try {
            responseJson = $.parseJSON(responseText);
        } catch (e) {
            _submitError(e, "Could not decode responseText to JSON");
        }
        _failureModal(responseJson);
    }
    function _submitError(exception, errorThrown) {
        meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK, {
            source: "retrievequotesLogin"
        });
        meerkat.modules.errorHandling.error({
            message: "An error occurred when attempting to login. Please try again.",
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
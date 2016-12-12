;(function ($, undefined) {

    var meerkat = window.meerkat,
        moduleEvents = {
            healthSubmitApplication: {
            },
            WEBAPP_LOCK: 'WEBAPP_LOCK',
            WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
        },
        stateSubmitInProgress = false;

    function initHealthSubmitApplication() {
        applyEventListeners();
    }

    function enableSubmitApplication() {
        // Enable button, hide spinner
        var $button = $('#submit_btn');
        $button.removeClass('disabled');
        meerkat.modules.loadingAnimation.hide($button);
    }

    function disableSubmitApplication(isSameSource) {
        // Disable button, show spinner
        var $button = $('#submit_btn');
        $button.addClass('disabled');
        if (isSameSource === true) {
            meerkat.modules.loadingAnimation.showAfter($button);
        }
    }

    function applyEventListeners() {
        // Submit application button
        $("#submit_btn").on('click', function (event) {
            var valid = meerkat.modules.journeyEngine.isCurrentStepValid();

            // Because validation is inline we can't see them inside privacy/compliance panels.
            if (meerkat.site.isCallCentreUser === true) {
                $('.agg_privacy').each(function () {
                    var $this = $(this);
                    $this.find('.error-count').remove();
                    var $errors = $this.find('.error-field label');
                    $this.children('button').after('<span class="error-count' + (($errors.length > 0) ? ' error-field' : '') + '" style="margin-left:10px">' + $errors.length + ' validation errors in this panel.</span>');
                });
            }

            // Validation passed, submit the application.
            if (valid) {
                submitApplication();
            }
        });
    }

    function submitApplication() {

        if (stateSubmitInProgress === true) {
            alert('Your application is still being submitted. Please wait.');
            return;
        }
        stateSubmitInProgress = true;

        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitApplication' });

        try {

            Results.updateApplicationEnvironment();

            var postData = meerkat.modules.journeyEngine.getFormData();

            // Disable fields must happen after the post data has been collected.
            meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitApplication', disableFields: true });


            var healthApplicationUrl = "ajax/json/health_application.jsp";
            if (meerkat.modules.splitTest.isActive(401) || meerkat.site.isDefaultToHealthApply) {
                healthApplicationUrl = "ajax/json/health_application_ws.jsp";
            }

            meerkat.modules.comms.post({
                url: healthApplicationUrl,
                data: postData,
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "silent",
                timeout: 250000, //10secs more than SOAP timeout
                onSuccess: function onSubmitSuccess(resultData) {

                    meerkat.modules.leavePageWarning.disable();

                    var redirectURL = "health_confirmation_v2.jsp?action=confirmation&transactionId=" + meerkat.modules.transactionId.get() + "&token=";
                    var extraParameters = "";

                    if (meerkat.site.utm_source !== '' && meerkat.site.utm_medium !== '' && meerkat.site.utm_campaign !== '') {
                        extraParameters = "&utm_source=" + meerkat.site.utm_source + "&utm_medium=" + meerkat.site.utm_medium + "&utm_campaign=" + meerkat.site.utm_campaign;
                    }

                    // Success
                    if (resultData.result && resultData.result.success) {
                        window.location.replace(redirectURL + resultData.result.confirmationID + extraParameters);

                        // Pending and not a call centre user (we want them to see the errors)
                    } else if (resultData.result && resultData.result.pendingID && resultData.result.pendingID.length > 0 && (!resultData.result.callcentre || resultData.result.callcentre !== true)) {
                        window.location.replace(redirectURL + resultData.result.pendingID + extraParameters);

                        // Handle errors
                    } else {
                        // Normally this shouldn't be reached because it should go via the onError handler thanks to the comms module detecting the error.
                        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitApplication' });
                        handleSubmittedApplicationErrors(resultData);
                    }
                },
                onError: onSubmitApplicationError,
                onComplete: function onSubmitComplete() {
                    stateSubmitInProgress = false;
                }
            });

        }
        catch (e) {
            stateSubmitInProgress = false;
            onSubmitApplicationError();
        }

    }

    function onSubmitApplicationError(jqXHR, textStatus, errorThrown, settings, data) {
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitApplication' });
        stateSubmitInProgress = false;
        if (errorThrown == meerkat.modules.comms.getCheckAuthenticatedLabel()) {
            // Handling of this error is defined in comms module
        } else if (textStatus == 'Server generated error') {
            handleSubmittedApplicationErrors(errorThrown);
        } else {
            handleSubmittedApplicationErrors(data);
        }
    }

    function handleSubmittedApplicationErrors(resultData) {
        var error = resultData;
        if (resultData.hasOwnProperty("error") && typeof resultData.error == "object") {
            error = resultData.error;
        }


        var msg = '';
        var validationFailure = false;
        try {
            // Handle errors return by provider
            if (resultData.result && resultData.result.errors) {
                var target = resultData.result.errors;
                if ($.isArray(target.error)) {
                    target = target.error;
                }
                $.each(target, function (i, error) {
                    msg += "<p>";
                    msg += '[Code: ' + error.code + '] ' + error.text;
                    msg += "</p>";
                });
                if (msg === '') {
                    msg = 'An unhandled error was received.';
                }
                // Handle internal SOAP error
            } else if (error && error.hasOwnProperty("type")) {
                switch (error.type) {
                    case "validation":
                        validationFailure = true;
                        break;
                    case "timeout":
                        msg = "Fund application service timed out.";
                        break;
                    case "parsing":
                        msg = "Error parsing the XML request - report issue to developers.";
                        break;
                    case "confirmed":
                        msg = error.message;
                        break;
                    case "transaction":
                        msg = error.message;
                        break;
                    case "submission":
                        msg = error.message;
                        break;
                    default:
                        msg = '[' + error.code + '] ' + error.message + " (Please report to IT before continuing)";
                        break;
                }
                // Handle unhandled error
            } else {
                msg = 'An unhandled error was received.';
            }
        } catch (e) {
            msg = 'Application unsuccessful. Failed to handle response: ' + e.message;
        }

        if (validationFailure) {
            meerkat.modules.serverSideValidationOutput.outputValidationErrors({
                validationErrors: error.errorDetails.validationErrors,
                startStage: 'payment'
            });
            if (typeof error.transactionId != 'undefined') {
                meerkat.modules.transactionId.set(error.transactionId);
            }
        } else {

            // Only show the real error to the Call Centre operator
            if (meerkat.site.isCallCentreUser === false) {
                msg = "Please contact us on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span> for assistance.";
            }
            meerkat.modules.errorHandling.error({
                message: "<strong>Application failed:</strong><br/>" + msg,
                page: "health.js",
                errorLevel: "warning",
                description: "handleSubmittedApplicationErrors(). Submit failed: " + msg,
                data: resultData
            });

            //call the custom fail handler for each fund
            if (healthFunds.applicationFailed) {
                healthFunds.applicationFailed();
            }
        }

    }

    meerkat.modules.register("healthSubmitApplication", {
        initHealthSubmitApplication: initHealthSubmitApplication,
        events: moduleEvents,
        disableSubmitApplication: disableSubmitApplication,
        enableSubmitApplication: enableSubmitApplication
    });

})(jQuery);

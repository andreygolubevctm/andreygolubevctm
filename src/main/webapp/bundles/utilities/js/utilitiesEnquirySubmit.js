;(function($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        WEBAPP_LOCK: 'WEBAPP_LOCK',
        WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
    };

    var $submitButton,
        submitXhr;

    function initUtilitiesEnquirySubmit() {
        $(document).ready(function() {
            $submitButton = $("#submit_btn");
            applyEventListeners();
        });

    }

    function applyEventListeners() {
        $submitButton.on("click", function(event) {
            $('.tt-hint').addClass('hidden');
            var valid = meerkat.modules.journeyEngine.isCurrentStepValid();
            if (valid) {
                submitEnquiry();
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, lockSlide);

        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, unlockSlide);
    }

    function lockSlide(obj) {
        // Must hide these as
        var isSameSource = (typeof obj !== 'undefined' && obj.source && obj.source === 'utilitiesEnquiry');
        var disableFields = (typeof obj !== 'undefined' && obj.disableFields && obj.disableFields === true);

        // Disable button, show spinner
        $submitButton.addClass('disabled');

        if(disableFields === true) {
            var $slide = $('#enquiryForm');
            $slide.find(':input').prop('disabled', true);
            $slide.find('.select').addClass('disabled');
            $slide.find('.btn-group label').addClass('disabled');
        }

        if (isSameSource === true) {
            meerkat.modules.loadingAnimation.showAfter($submitButton);
        }
    }

    function unlockSlide(obj) {
        $('.tt-hint').removeClass('hidden');
        $submitButton.removeClass('disabled');
        meerkat.modules.loadingAnimation.hide($submitButton);

        var $slide = $('#enquiryForm');
        $slide.find(':input').prop('disabled', false);
        $slide.find('.select').removeClass('disabled');
        $slide.find('.btn-group label').removeClass('disabled');
    }

    function submitEnquiry() {

        if (submitXhr && typeof submitXhr.status === 'function' && submitXhr.status() == 'pending') {
            alert('This page is still being processed. Please wait.');
            return;
        }

        // Must collect the form data BEFORE the application lockdown which disables the fields on the slide
        var postData = meerkat.modules.journeyEngine.getFormData();

        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source:'utilitiesEnquiry', disableFields:true });

        var applyResultsUrl = "ajax/json/utilities_submit.jsp";

        // Instead we to a forward from the jsp page
        //if (meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToEnergyQuote) {
        //    applyResultsUrl = "spring/rest/energy/apply/apply.json";
        //}

        submitXhr = meerkat.modules.comms.post({
            url: applyResultsUrl,
            data: postData,
            cache: false,
            useDefaultErrorHandling: false,
            errorLevel: "fatal",
            timeout: 30000,
            onSuccess: function onSubmitSuccess(resultData) {

                if (resultData.hasOwnProperty('confirmationkey') === false) {
                    onSubmitError(false, '', 'Missing confirmationkey', false, resultData);
                    return;
                }

                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method:'trackQuoteForms',
                    object: meerkat.modules.utilities.getTrackingFieldsObject
                });

                var confirmationId = resultData.confirmationkey;
                meerkat.modules.leavePageWarning.disable();
                window.location.href = 'viewConfirmation?key=' + encodeURI(confirmationId);
            },
            onError: onSubmitError
        });
    }

    function onSubmitError(jqXHR, textStatus, errorThrown, settings, resultData) {
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source:'utilitiesEnquiry'});
        var validationErrors = false;
        if(_.has(jqXHR, "responseJSON")) {
            var response = jqXHR.responseJSON;
            if (response.hasOwnProperty("error") && typeof response.error == "object") {
                error = response.error;
                if (_.has(error, "errorDetails") && _.isObject(error.errorDetails)) {
                    var details = error.errorDetails;
                    if (_.has(details, "validationErrors") && _.isArray(details.validationErrors)) {
                        validationErrors = details.validationErrors;
                    }
                }
            }
        }

        if(validationErrors !== false) {
            meerkat.modules.serverSideValidationOutput.outputValidationErrors({
                validationErrors: error.errorDetails.validationErrors,
                startPage: null // let outputValidationErrorsn decide the step
            });
        } else {
            meerkat.modules.errorHandling.error({
                message: "<p>An error occurred when attempting to submit your enquiry.</p><p>Please click OK to try again, or call <strong>" + meerkat.site.content.callCentreNumber + "</strong> quoting your reference number <strong>" + meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber() + "</strong>.</p>",
                page: "utilitiesEnquirySubmit.js:submitEnquiry()",
                errorLevel: "warning",
                description: "Ajax request to " + settings.url + " failed to return a valid response: " + errorThrown,
                data: resultData
            });
        }
    }

    meerkat.modules.register("utilitiesEnquirySubmit", {
        initUtilitiesEnquirySubmit: initUtilitiesEnquirySubmit,
        lockSlide:lockSlide
    });

})(jQuery);
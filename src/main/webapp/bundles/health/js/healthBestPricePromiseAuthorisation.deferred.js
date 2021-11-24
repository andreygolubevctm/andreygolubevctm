/**
 * Description: Provides all the functionality to interact with the
 * Best Price Promise (BPP) validation form
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        $elements = {},
        data = null;

    /**
     * init: reset private data object, cache all required DOM elements and
     * call all setup methods.
     */
    function init() {

        resetData(); // reset the private data object
        $(document).ready(function () {
            if(meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

            if(meerkat.site.isCallCentreUser) {
                // Cache all required jquery element objects
                $elements.root = $('#bppAuthorisationGroup');
                $elements.wrappers = {
                    approvedby:     $elements.root.find('.healthbestPrisePromiseApprovedByRow').first(),
                    authorisation:  $elements.root.find('.healthBestPrisePromiseAuthorisationRow').first(),
                    messages:       $elements.root.find('.best-price-promise-validation-messages'),
                    disableables:   $elements.root.find('.disableable-fields'),
                    matchedDatas:    $elements.root.find('.bestPrisePromiseMatchedTransDataGroup'),
                    userEditables: $elements.root.find('.bestPrisePromiseReasonAndApprovalGroup')
                };
                $elements.triggers = {
                    submit:     $elements.wrappers.authorisation.find(".btn-authorise").first(),
                    reset:      $elements.wrappers.authorisation.find(".btn-reset").first()
                };
                $elements.inputs = {
                    all: $elements.root.find('input'),
                    disableables:      $elements.wrappers.disableables.find('input'),
                    userEditables:    $elements.wrappers.userEditables.find('input'),
                    reasonDisplay:     $elements.root.find('#healthbestPrisePromiseReason'),
                    approvedby:        $elements.root.find('#health_price_promise_bestPrisePromise_approvedby'),
                    approvedbydisplay: $elements.root.find('#healthbestPrisePromiseApprovedBy'),
                    code:              $elements.root.find('#health_price_promise_bestPrisePromise_authorisationcode')
                };

                $elements.inputs.code.attr("required", "true");
                $elements.inputs.code.attr("aria-required", "true");

                applyEventListeners();
                updateData();
                updateView();
            }
        });
    }


    /**
     * applyEventListeners: apply listeners to required elements
     */
    function applyEventListeners() {
        // $elements.triggers.reason.on('change', onUpdateReason);
        $elements.triggers.submit.on('click',authorise);
        $elements.triggers.reset.on('click',deAuthorise);

        // MUST BE LAST LISTENER
        $elements.inputs.all.on('change',function(){
            updateData();
            updateView();
        });
    }


    /**
     * resetData: resets the private data object to the default state
     */
    function resetData() {
        data = {
            available : false,
            other :     false
        };

        data.other = {
            reason :        null,
            code :          null,
            approvedby :    null
        };
    }


    /**
     * authorise: check the authorisation code is valid by making an
     * ajax call to the authorise end point
     */
    function authorise() {

        if(isValid()) {
            updateData();
            meerkat.modules.comms.get({
                url: 'spring/voucher/authorise',
                data: {code : data.other.code},
                cache: false,
                dataType: 'json',
                useDefaultErrorHandling: false,
                errorLevel: 'silent',
                timeout: 5000,
                onSuccess: function onSubmitSuccess(resultData) {
                    if(isValidAuthoriseResponse(resultData)) {
                        $elements.inputs.approvedby.val(resultData.username);
                        updateData();
                        updateView();
                        renderSuccess("Offer approved by '" + data.other.approvedby + "'");
                    } else {
                        renderError("Invalid voucher code entered");
                    }
                },
                onError: function(xhr, status, error) {
                    renderError("There is a problem with this service: " + error);
                }
            });
        } else {
            // Ignore - validation errors are sufficient
        }
    }

    /**
     * deAuthorise: unsets the current authorisation by resetting the
     * approvedby and code fields.
     */
    function deAuthorise() {
        flushMessage();
        $elements.inputs.code.val('');
        $elements.inputs.approvedby.val('');
        updateData();
        updateView();
    }

    /**
     * updateView: update the form based on values in the private data object
     * Also, toggles the visibility of form elements based on the state.
     */
    function updateView() {

        $elements.inputs.approvedby.val(!_.isEmpty(data.other.approvedby) ? data.other.approvedby : '');
        $elements.inputs.approvedbydisplay.empty().append(!_.isEmpty(data.other.approvedby) ? data.other.approvedby : '');
        $elements.inputs.code.val(data.other.code || '');

        // Enable/disable fields based on whether authorised
        if(!_.isEmpty(data.other.approvedby)) {
            $elements.wrappers.userEditables.addClass('disabled');
            $elements.inputs.userEditables.each(function() {
                var value = $(this).val();
                $(this).closest('.fieldrow').find('.display-only').empty().append(value);
            });
            $elements.inputs.code.closest('.authorisation-column').hide();
            $elements.wrappers.approvedby.slideDown('fast');
            $elements.triggers.submit.slideUp('fast', function(){
                $elements.triggers.reset.slideDown('fast');
            });
        } else {
            $elements.wrappers.userEditables.removeClass('disabled');
            $elements.inputs.reasonDisplay.empty();
            $elements.inputs.approvedbydisplay.empty();
            $elements.inputs.userEditables.each(function() {
                $(this).closest('.fieldrow').find('.display-only').empty();
            });
            $elements.inputs.code.closest('.authorisation-column').show();
            $elements.wrappers.approvedby.slideUp('fast');
            $elements.triggers.reset.slideUp('fast', function(){
                $elements.triggers.submit.slideDown('fast');
            });
        }

    }


    /**
     * isValid: validate each of the form elements before making
     * ajax call to authorise the code.
     *
     * @returns {boolean}
     */
    function isValid() {
        var vCode = $elements.inputs.code.valid();
        return vCode;
    }


    /**
     * isValidAuthoriseResponse: validates the response from the authorise ajax call
     *
     * @param response
     * @returns {boolean}
     */
    function isValidAuthoriseResponse(response) {
        if(response && typeof response === 'object') {
            return response.isAuthorised && response.username;
        }
    }


    /**
     * updateData: updates the private data object with values from the form
     */
    function updateData() {
            var code = $elements.inputs.code.val();
            console.log('code: ', code);
            var approvedby = $elements.inputs.approvedby.val();
            data.other = {
                code: _.isEmpty(code) ? null : code,
                approvedby: _.isEmpty(approvedby) ? null : approvedby
            };
    }


    /**
     * renderSuccess: render an error message
     *
     * @param copy
     */
    function renderError(copy) {
        renderMessage('error', copy);
    }


    /**
     * renderSuccess: render a success message
     *
     * @param copy
     */
    function renderSuccess(copy) {
        renderMessage('success', copy);
    }


    /**
     * renderMessage: common message render method
     *
     * @param type
     * @param copy
     */
    function renderMessage(type,copy) {
        flushMessage().append(
            '<p class="' + type + '">' + copy + '</p>'
        );
    }


    function flushMessage() {
        return $elements.wrappers.messages.empty();
    }


    /**
     * checkTLAuthorised: if AuthCode field has valid value (greater than 6 chars) but team leader authorisation,
     * not yet checked then do not allow submit
    */
    function checkTLAuthorised() {
        var returnVal = true;
        if ($elements.root.css('display') === 'block') {
            if ($elements.inputs.code.prop("required")) {
                if ($elements.inputs.code.val().length > 5) {

                    if ($elements.inputs.code.is(':visible')) {
                        returnVal = false;

                        $elements.inputs.code.toggleClass("has-success", false);
                        $elements.inputs.code.toggleClass("has-error", true);
                        $elements.inputs.code.parent().parent().toggleClass("has-success", false);
                        $elements.inputs.code.parent().parent().toggleClass("has-error", true);
                        $elements.inputs.code.attr('aria-invalid', 'true');

                        if ($elements.inputs.code.parent().parent().find('.error-field').length) {

                            if ($('#health_price_promise_bestPrisePromise_authorisationcode-error').length) {
                                $('#health_price_promise_bestPrisePromise_authorisationcode-error').html("Authorisation required");
                            } else {
                                $elements.inputs.code.parent().parent().find('.error-field').prepend('<label id="health_price_promise_bestPrisePromise_authorisationcode-error" class="has-error" for="health_price_promise_bestPrisePromise_authorisationcode">Authorisation required</label>');
                            }
                        } else {
                            $elements.inputs.code.parent().parent().prepend('<div class="error-field" style="display: block;"><label id="health_price_promise_bestPrisePromise_authorisationcode-error" class="has-error" for="health_payment_details_bestPrisePromise_authorisationcode">Authorisation required</label></div>');
                        }
                    }
                }
            }
        }

        return returnVal;
    }


    meerkat.modules.register("healthBestPricePromiseAuthorisation", {
        init: init,
        checkTLAuthorised: checkTLAuthorised

    });

})(jQuery);
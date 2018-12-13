/**
 * Description: Provides all the functionality to interact with the
 * Spit Transaction form.
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception,
        $elements = {},
        postData = {
            rootId: null,
            transactionId: null,
            emailAddress: null,
            fullAddress: null,
            mobile: null,
            homePhone: null
        },
        responseData = {},
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
                $elements.root = $('#possibleMatchingCustomer');
                $elements.wrappers = {
                    reason:         $elements.root.find('.healthSplitTransactionReasonRow').first(),
                    approvedby:     $elements.root.find('.healthSplitTransactionApprovedByRow').first(),
                    authorisation:  $elements.root.find('.healthSplitTransactionAuthorisationRow').first(),
                    messages:       $elements.root.find('.split-trans-validation-messages'),
                    disableables:   $elements.root.find('.disableable-fields')
                };
                $elements.triggers = {
                    reason:     $elements.wrappers.reason.find("select").first(),
                    submit:     $elements.wrappers.authorisation.find(".btn-authorise").first(),
                    reset:     $elements.wrappers.authorisation.find(".btn-reset").first()
                };
                $elements.inputs = {
                    all: $elements.root.find('input,select'),
                    disableables: $elements.wrappers.disableables.find('input,select'),
                    reason: $elements.root.find('#health_payment_details_splitTransaction_reason'),
                    reasonDisplay: $elements.root.find('#healthSplitTransactionReason'),
                    approvedby: $elements.root.find('#health_payment_details_splitTransaction_approvedby'),
                    approvedbydisplay: $elements.root.find('#healthSplitTransactionApprovedBy'),
                    code: $elements.root.find('#health_payment_details_splitTransaction_authorisationcode')
                };

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
        $elements.triggers.reason.on('change', onUpdateReason);
        $elements.triggers.submit.on('click',authorise);
        $elements.triggers.reset.on('click',deAuthorise);

        // MUST BE LAST LISTENER
        $elements.inputs.all.on('change',function(){
            updateData();
            updateView();
        });
    }


    /**
     * Sets the visibility of the Spit Transaction section on the payment page
     */
    function showSplitTransactions(found) {
        resetData();
        data.available = found;
        updateData();
        updateView();
    }

    /**
     * checkIfMatchingCustomerTransactions: check if there are transactions that could be from the same user or household by making an
     * ajax call to A BACKEND end point
     */
    function checkIfMatchingCustomerTransactions() {

        postData = {
            rootId: meerkat.modules.transactionId.getRootId(),
            transactionId: meerkat.modules.transactionId.get(),
            emailAddress: $('#health_application_email').val() || '',
            fullAddress: $('#health_application_address_fullAddress').val(),
            mobile: $('#health_application_mobile').val() || '',
            homePhone: $('#health_application_other').val() || ''
        };

        meerkat.modules.comms.post({
            url: "spring/dupetranscheck/duplicate-transactions-check/post.json",
            contentType: 'application/json;',
            data: JSON.stringify(postData),
            cache: false,
            dataType: 'json',
            useDefaultErrorHandling: false,
            errorLevel: 'silent',
            //timeout: 10000,
            onSuccess: function onSubmitSuccess(resultData) {
                if(!_.isEmpty(resultData) && _.isObject(resultData)) {
                    showSplitTransactions(resultData.details.hasDuplicateTransactions);

                    $("#health_payment_details_splitTransaction_matched_transactionId").val(resultData.details.transactionId);
                    $("#healthSplitTransactionTransactionId").text(resultData.details.transactionId);
                    $("#health_payment_details_splitTransaction_matched_rootId").val(resultData.details.rootId);
                    $("#healthSplitTransactionRootId").text(resultData.details.rootId);
                    $("#health_payment_details_splitTransaction_matched_fullName").val(resultData.details.fullName);
                    $("#healthSplitTransactionFullName").text(resultData.details.fullName);
                    $("#health_payment_details_splitTransaction_matched_date").val(resultData.details.date);
                    $("#health_payment_details_splitTransaction_matched_time").val(resultData.details.time);

                    var dupeDateTimeStamp = new Date(resultData.details.date + 'T' + resultData.details.time);

                    $("#healthSplitTransactionDate").text(meerkat.modules.dateUtils.format(dupeDateTimeStamp, 'DD-MM-YYYY'));
                    $("#healthSplitTransactionTime").text(dupeDateTimeStamp.toLocaleTimeString());

                    $("#health_payment_details_splitTransaction_matched_operatorId").val(resultData.details.operatorId);
                    $("#healthSplitTransactionOperatorId").text(resultData.details.operatorId);
                } else {
                    showSplitTransactions(false);
                    $("#health_payment_details_splitTransaction_matched_transactionId").val('');
                    $("#health_payment_details_splitTransaction_matched_rootId").val('');
                    $("#health_payment_details_splitTransaction_matched_fullName").val('');
                    $("#health_payment_details_splitTransaction_matched_date").val('');
                    $("#health_payment_details_splitTransaction_matched_time").val('');
                    $("#health_payment_details_splitTransaction_matched_operatorId").val('');
                }
            },
            onError: function(obj, txt, errorThrown) {
                showSplitTransactions(false);
                console.log({errorMessage: txt + ': ' + errorThrown});
            }
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
     * onUpdateReason: action when reason selector is updated. Form
     * is changed depending on the value.
     */
    function onUpdateReason() {
        deAuthorise();
        clearAuthCodeValidation();

        var reason = $elements.inputs.reason.val();
        if (reason === 'HES' || reason === 'CSP' || reason === 'CSS' || reason === 'DSP' || reason === 'FDA') {
            $elements.inputs.code.attr("required", "true");
            $elements.inputs.code.attr("aria-required", "true");
        } else {
            $elements.inputs.code.prop("required", false);
            $elements.inputs.code.attr("aria-required", "false");
        }
    }

    function clearAuthCodeValidation() {
        $elements.inputs.code.attr("aria-invalid", "false");
        $elements.inputs.code.toggleClass( "has-error", false);
        $elements.inputs.code.parent().parent().toggleClass( "has-error", false);
        $elements.inputs.code.parent().parent().find('.error-field').remove();
        $elements.inputs.code.parent().parent().find('.split-trans-validation-messages').remove();
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
                        renderSuccess("Voucher approved by '" + data.other.approvedby + "'");
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
        // Update inputs based on sanitised data
        if (!data.available) {
            $elements.triggers.reason.find('option:selected').prop('selected', null);
        }

        if (_.isEmpty(data.other.reason)) {
            $elements.triggers.reason.find('option:selected').prop('selected', null);
        }

        $elements.inputs.approvedby.val(!_.isEmpty(data.other.approvedby) ? data.other.approvedby : '');
        $elements.inputs.approvedbydisplay.empty().append(!_.isEmpty(data.other.approvedby) ? data.other.approvedby : '');
        $elements.inputs.code.val(data.other.code || '');

        // Enable/disable fields based on whether authorised
        if(!_.isEmpty(data.other.approvedby)) {
            $elements.wrappers.disableables.addClass('disabled');
            $elements.inputs.disableables.each(function() {
                var value = $(this).val();
                $(this).closest('.fieldrow').find('.display-only').empty().append(value);
            });
            $elements.inputs.code.closest('.authorisation-column').hide();
            $elements.wrappers.approvedby.slideDown('fast');
            $elements.triggers.submit.slideUp('fast', function(){
                $elements.triggers.reset.slideDown('fast');
            });
        } else {
            $elements.wrappers.disableables.removeClass('disabled');
            $elements.inputs.disableables.each(function() {
                $(this).closest('.fieldrow').find('.display-only').empty();
            });
            $elements.inputs.code.closest('.authorisation-column').show();
            $elements.wrappers.approvedby.slideUp('fast');
            $elements.triggers.reset.slideUp('fast', function(){
                $elements.triggers.submit.slideDown('fast');
            });
        }

        // Update visibility of form element wrappers
        if(data.available) {
            $elements.root.slideDown('fast');
        } else {
            $elements.root.slideUp('fast');
        }
    }


    /**
     * isValid: validate each of the form elements before making
     * ajax call to authorise the voucher.
     *
     * @returns {boolean}
     */
    function isValid() {
        var vReason = $elements.inputs.reason.valid();
        var vCode = $elements.inputs.code.valid();
        return vReason && vCode;
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
        if(data.available) {

            var reason = $elements.triggers.reason.val();
            var code = $elements.inputs.code.val();
            var approvedby = $elements.inputs.approvedby.val();
            data.other = {
                reason: $elements.triggers.reason.val() || null,
                code: _.isEmpty(code) ? null : code,
                approvedby: _.isEmpty(approvedby) ? null : approvedby
            };

        } else {
            resetData(); // if not available then flush data object
        }
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


    meerkat.modules.register("healthSplitTransaction", {
        init: init,
        checkIfMatchingCustomerTransactions: checkIfMatchingCustomerTransactions

    });

})(jQuery);
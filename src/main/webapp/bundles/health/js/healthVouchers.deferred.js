/**
 * Description: Provides all the functionality to interact with the
 * voucher form.
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception,
        $elements = {},
        data = null,
        valueRange = {
            inc : 25,
            min : 25,
            max : 200,
            custom : {
                'price-promise': {
                    min: 50,
                    max: 50
                },
                'referral-offer': {
                    min: 25,
                    max: 100
                },
	            'q-jun$100-offer': {
		            min: 100,
		            max: 100
	            },
	            'q-jun$200-offer': {
		            min: 200,
		            max: 200
	            },
                '2017oct$100': {
                    min: 100,
                    max: 100
                }
            }
    };

    /**
     * init: reset private data object, cache all required DOM elements and
     * call all setup methods.
     */
    function init() {
        resetData(); // reset the private data object
        $(document).ready(function () {
            if(meerkat.site.isCallCentreUser) {
                // Cache all required jquery element objects
                $elements.root = $('#healthVouchers');
                $elements.wrappers = {
                    available:      $elements.root.find('.voucherIsAvailable').first(),
                    type:           $elements.root.find('.healthVoucherTypeRow').first(),
                    mando:          $elements.root.find('.voucher.mando').first(),
                    other:          $elements.root.find('.voucher.other').first(),
                    reason:         $elements.root.find('.healthVoucherReasonRow').first(),
                    referrerref:    $elements.root.find('.healthVoucherReferrerRefRow').first(),
                    value:          $elements.root.find('.healthVoucherValueRow').first(),
                    approvedby:     $elements.root.find('.healthVoucherApprovedByRow').first(),
                    authorisation:  $elements.root.find('.healthVoucherAuthorisationRow').first(),
                    simples :   {
                        defaultReason :      $elements.root.find('.dialogue.defaultReason').first(),
                          },
                    messages:       $elements.root.find('.voucher-validation-messages'),
                    disableables:   $elements.root.find('.disableable-fields')
                };
                $elements.triggers = {
                    available:  $elements.root.find('.healthVoucherAvailableRow').first().find('input'),
                    type:       $elements.wrappers.type.find("select").first(),
                    reason:     $elements.wrappers.reason.find("select").first(),
                    submit:     $elements.wrappers.authorisation.find(".btn-authorise").first(),
                    reset:     $elements.wrappers.authorisation.find(".btn-reset").first()
                };
                $elements.inputs = {
                    all: $elements.root.find('input,select'),
                    disableables: $elements.wrappers.disableables.find('input,select'),
                    reason: $elements.root.find('#health_voucher_reason'),
                    reasonDisplay: $elements.root.find('#healthVoucherReason'),
                    referrerref: $elements.root.find('#health_voucher_referrerref'),
                    referrerrefDisplay: $elements.root.find('#healthVoucherReferrerRef'),
                    value: $elements.root.find('#health_voucher_value'),
                    valueDisplay: $elements.root.find('#healthVoucherValue'),
                    emailDisplay: $elements.root.find('#healthVoucherEmail'),
                    approvedby: $elements.root.find('#health_voucher_approvedby'),
                    approvedbydisplay: $elements.root.find('#healthVoucherApprovedBy'),
                    code: $elements.root.find('#health_voucher_authorisationcode'),
                    appemail: $('#health_application_email')
                };
                applyEventListeners();
                updateData();
                updateValueOptions(data.isOther ? data.other.reason : false);
                updateView();

                // If we have a PYRR offer add it to the dropdown.
                var pyrrCoupon = meerkat.modules.healthPyrrCampaign.isPyrrActive(true);

                if (pyrrCoupon) {
                    $elements.wrappers.simples.pyrrCampaign = $elements.root.find('.dialogue.pyrrCampaign').first();
                    $elements.inputs.reason.append('<option value="pay-your-rate-rise">Pay Your Rate Rise</option>');
                }
            }
        });
    }

    /**
     * applyEventListeners: apply listeners to required elements
     */
    function applyEventListeners() {
        $elements.triggers.available.on('change', function(){
            resetData();
            data.available = $(this).val() === 'Y';
        });
        $elements.triggers.type.on('change', function(){
            switch($(this).val()){
                case 'other':
                    setOther();
                    break;
                default: // Mando
                    setMando();
                    break;
            }
        });
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
     * updateData: updates the private data object with values from the form
     */
    function updateData() {
        var $available = $elements.triggers.available.filter(':checked');
        data.available = _.isEmpty($available) ? false : $available.val() === 'Y';

        if(data.available) {
            // If voucher available then reset the data object to suit
            var type = $elements.triggers.type.val();
            switch (type) {
                case 'other':
                    setOther();
                    break;
                case 'mando':
                    setMando();
                    break;
                default:
                    resetData();
                    data.available = true;
                    break;
            }

            // If is Other voucher type then pull in values from form
            if(data.isOther) {
                var reason = $elements.triggers.reason.val();
                var referrerref = $elements.inputs.referrerref.val();
                var value = $elements.inputs.value.val();
                var code = $elements.inputs.code.val();
                var approvedby = $elements.inputs.approvedby.val();
                data.other = {
                    reason: _.isEmpty(reason) ? null : reason,
                    referrerref: _.isEmpty(referrerref) ? null : referrerref,
                    value: _.isEmpty(value) ? null : value,
                    code: _.isEmpty(code) ? null : code,
                    approvedby: _.isEmpty(approvedby) ? null : approvedby
                };
            }
        } else {
            resetData(); // if not available then flush data object
        }
    }

    /**
     * updateView: update the form based on values in the private data object
     * Also, toggles the visibility of form elements based on the state.
     */
    function updateView() {
        // Update inputs based on sanitised data
        if (!data.available) {
            $elements.triggers.type.find('option:selected').prop('selected', null);
        }
        if (!data.isOther || _.isEmpty(data.other.reason)) {
            $elements.triggers.reason.find('option:selected').prop('selected', null);
        }
        if (!data.isOther || _.isEmpty(data.other.value)) {
            $elements.inputs.value.find('option:selected').prop('selected', null);
        }
        $elements.inputs.referrerref.val(data.isOther && !_.isEmpty(data.other.referrerref) ? data.other.referrerref : '');
        $elements.inputs.emailDisplay.empty().append($elements.inputs.appemail.val());
        $elements.inputs.approvedby.val(data.isOther && !_.isEmpty(data.other.approvedby) ? data.other.approvedby : '');
        $elements.inputs.approvedbydisplay.empty().append(data.isOther && !_.isEmpty(data.other.approvedby) ? data.other.approvedby : '');
        $elements.inputs.code.val(data.isOther && !_.isEmpty(data.other.code) ? data.other.code : '');

        // Enable/disable fields based on whether authorised
        if(data.isOther && !_.isEmpty(data.other.approvedby)) {
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
            $elements.wrappers.available.slideDown('fast', function(){
                $elements.wrappers.type.slideDown('fast', function(){
                    if(data.isMando) {
                        $elements.wrappers.other.slideUp('fast', function () {
                            $elements.wrappers.mando.slideDown('fast');
                        });
                    } else if(data.isOther) {
                        $elements.wrappers.mando.slideUp('fast', function(){
                            var pyrrCoupon = meerkat.modules.healthPyrrCampaign.isPyrrActive(true);
                            if (pyrrCoupon) {
                                $elements.wrappers.simples.pyrrCampaign.hide();
                            }
                            toggleReasonDialog(pyrrCoupon , data.other.reason);
                            toggleReferrerReference( data.other.reason);
                            $elements.wrappers.other.slideDown('fast');
                        });
                    }
                });
            });
        } else {
            $elements.wrappers.available.slideUp('fast');
        }
    }

    function toggleReferrerReference(otherReason) {
        if(!_.isEmpty(otherReason)) {
            if (otherReason === 'referral-offer') {
                $elements.wrappers.referrerref.show();
            } else {
                $elements.wrappers.referrerref.hide();
            }
        }
    }
    function toggleReasonDialog(pyrrCoupon , otherReason) {
        if(!_.isEmpty(otherReason)) {
            if (pyrrCoupon && otherReason === 'pay-your-rate-rise') {
                $elements.wrappers.simples.defaultReason.hide();
                $elements.wrappers.simples.pyrrCampaign.show();
            } else {
                $elements.wrappers.simples.defaultReason.show();
            }
        } else {
            $elements.wrappers.simples.defaultReason.hide();
        }
    }
    /**
     * resetData: resets the private data object to the default state
     */
    function resetData() {
        data = {
            available : false,
            isMando :   false,
            isOther :   false,
            other :     false
        };
    }

    /**
     * resetMando: sets the private data object to the default state for a mando voucher
     */
    function setMando() {
        data.isMando = true;
        data.isOther = false;
        data.other = false;
    }

    /**
     * resetMando: sets the private data object to the default state for an 'other' voucher
     */
    function setOther() {
        data.isMando = false;
        data.isOther = true;
        data.other = {
            reason :        null,
            referrerref :   null,
            value :         null,
            code :          null,
            approvedby :    null
        };
    }

    /**
     * onUpdateReason: action when reason selector is updated. Form
     * is changed depending on the value.
     */
    function onUpdateReason() {
        var reason = $elements.triggers.reason.val();
        if(reason !== 'referral-offer') {
            // Flush the referralref field if not a referral offer
            $elements.inputs.referrerref.val('');
        }

        // Update value selector with applicable options
        updateValueOptions(reason);

        // If Pay Your Rate Rise is selected.
        if(reason === 'pay-your-rate-rise') {
            var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();
            var giftCardAmount = selectedProduct.giftCardAmount;
            $elements.inputs.value.empty().append('<option value="'+giftCardAmount+'">$'+giftCardAmount+'</option>');
        }

        if(_.indexOf(['q-jun$100-offer','q-jun$200-offer'],reason) !== -1) {
            $elements.inputs.value.val(valueRange.custom[reason].max);
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
        var vRef = $elements.inputs.referrerref.valid();
        var vValue = $elements.inputs.value.valid();
        var vCode = $elements.inputs.code.valid();
        return vReason && vRef && vValue && vCode;
    }

    /**
     * isValidAuthoriseResponse: validates the response from the authorise ajax call
     *
     * @param response
     * @returns {boolean}
     */
    function isValidAuthoriseResponse(response) {
        if(!_.isEmpty(response) && _.isObject(response)) {
            return _.has(response,'isAuthorised') && response.isAuthorised === true && _.has(response,'username') && !_.isEmpty(response.username);
        }
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
     * updateValueOptions: renders the value options to the value selector.
     * Custom will apply a custom set of values as defined in valueRange.custom
     * @param custom
     */
    function updateValueOptions(custom) {
        custom = custom  || false;
        var $option = $('<option/>',{
            value: null,
            label: 'Please choose...'
        });
        var range = getRange(custom);
        $elements.inputs.value.empty().append($option);
        for(var i=range.min; i <= range.max; i = i + range.inc) {
            $option = $('<option/>',{
                value: i,
                label: '$' + i
            });
            if(i === data.other.value) {
                $option.prop("selected", true);
            }
            $elements.inputs.value.append($option);
        }
    }

    /**
     * getRange: returns a range object applicable to the voucher reason
     * @param type
     */
    function getRange(type) {
        var range = {
            inc : valueRange.inc,
            min : valueRange.min,
            max : valueRange.max
        };
        if(_.has(valueRange.custom, type)) {
            var row = valueRange.custom[type];
            range.inc = _.has(row,'inc') ? row.inc : range.inc;
            range.min = row.min;
            range.max = row.max;
        }
        return range;
    }

    meerkat.modules.register("healthVouchers", {
        init: init
    });

})(jQuery);
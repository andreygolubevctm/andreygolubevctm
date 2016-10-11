/**
 * Description: External documentation:
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
            otherMax : 50
    };

    function init() {
        resetData();
        $(document).ready(function () {
            if(meerkat.site.isCallCentreUser) {
                $elements.root = $('#healthVouchers');
                $elements.wrappers = {
                    available:      $elements.root.find('.voucherIsAvailable').first(),
                    type:           $elements.root.find('.healthVoucherTypeRow').first(),
                    mando:          $elements.root.find('.voucher.mando').first(),
                    other:          $elements.root.find('.voucher.other').first(),
                    reason:         $elements.root.find('.healthVoucherReasonRow').first(),
                    referrerref:    $elements.root.find('.healthVoucherReferrerRefRow').first(),
                    value:          $elements.root.find('.healthVoucherValueRow').first(),
                    email:          $elements.root.find('.healthVoucherEmailRow').first(),
                    approvedby:     $elements.root.find('.healthVoucherApprovedByRow').first(),
                    authorisation:  $elements.root.find('.healthVoucherAuthorisationRow').first(),
                    simples :   {
                        referral :  $elements.root.find('.dialogue.referral').first(),
                        other :     $elements.root.find('.dialogue.others').first()
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
                    referrerref: $elements.root.find('#health_voucher_referrerref'),
                    value: $elements.root.find('#health_voucher_value'),
                    email: $elements.root.find('#health_voucher_email'),
                    approvedby: $elements.root.find('#health_voucher_approvedby'),
                    approvedbydisplay: $elements.root.find('#healthVoucherApprovedBy'),
                    code: $elements.root.find('#health_voucher_authorisationcode'),
                    appemail: $elements.root.find('#health_application_email')
                };
                applyEventListeners();
                updateData();
                updateValueOptions(data.isOther && data.other.reason === 'price-promise');
                updateView();
            }
        });
    }

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

    function updateData() {
        var $available = $elements.triggers.available.filter(':checked');
        data.available = _.isEmpty($available) ? false : $available.val() === 'Y';
        if(data.available) {
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
        } else {
            resetData();
        }
        if(data.isOther) {
            var reason = $elements.triggers.reason.val();
            var referrerref = $elements.inputs.referrerref.val();
            var value = $elements.inputs.value.val();
            var email = $elements.inputs.email.val();
            if(_.isEmpty(email)) {
                email = $elements.inputs.appemail.val();
            }
            var code = $elements.inputs.code.val();
            var approvedby = $elements.inputs.approvedby.val();
            data.other = {
                reason: _.isEmpty(reason) ? null : reason,
                referrerref: _.isEmpty(referrerref) ? null : referrerref,
                value: _.isEmpty(value) ? null : value,
                email: _.isEmpty(email) ? null : email,
                code: _.isEmpty(code) ? null : code,
                approvedby: _.isEmpty(approvedby) ? null : approvedby
            };
        }
    }

    function updateView() {
        // Update inputs
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
        $elements.inputs.approvedby.val(data.isOther && !_.isEmpty(data.other.approvedby) ? data.other.approvedby : '');
        $elements.inputs.approvedbydisplay.empty().append(data.isOther && !_.isEmpty(data.other.approvedby) ? data.other.approvedby : '');
        $elements.inputs.code.val(data.isOther && !_.isEmpty(data.other.code) ? data.other.code : '');
        // Disable fields once authorised
        if(data.isOther && !_.isEmpty(data.other.approvedby)) {
            $elements.wrappers.disableables.addClass('disabled');
            $elements.inputs.disableables.prop('readonly',true);
            $elements.wrappers.approvedby.slideDown('fast');
            $elements.triggers.submit.slideUp('fast', function(){
                $elements.triggers.reset.slideDown('fast');
            });
        } else {
            $elements.wrappers.disableables.removeClass('disabled');
            $elements.inputs.disableables.prop('readonly',false);
            $elements.wrappers.approvedby.slideUp('fast');
            $elements.triggers.reset.slideUp('fast', function(){
                $elements.triggers.submit.slideDown('fast');
            });
        }
        // Update wrapper visibility
        if(data.available) {
            $elements.wrappers.available.slideDown('fast', function(){
                $elements.wrappers.type.slideDown('fast', function(){
                    if(data.isMando) {
                        $elements.wrappers.other.slideUp('fast', function () {
                            $elements.wrappers.mando.slideDown('fast');
                        });
                    } else if(data.isOther) {
                        $elements.wrappers.mando.slideUp('fast', function(){
                            if(!_.isEmpty(data.other.reason)) {
                                if (data.other.reason === 'referral-offer') {
                                    $elements.wrappers.referrerref.show();
                                    $elements.wrappers.simples.referral.show();
                                    $elements.wrappers.simples.other.hide();
                                } else {
                                    $elements.wrappers.referrerref.hide();
                                    $elements.wrappers.simples.referral.hide();
                                    $elements.wrappers.simples.other.show();
                                }
                            } else {
                                $elements.wrappers.simples.referral.hide();
                                $elements.wrappers.simples.other.hide();
                            }
                            $elements.wrappers.other.slideDown('fast');
                        });
                    }
                });
            });
        } else {
            $elements.wrappers.available.slideUp('fast');
        }
    }

    function resetData() {
        data = {
            available : false,
            isMando :   false,
            isOther :   false,
            other :     false
        };
    }

    function setMando() {
        data.isMando = true;
        data.isOther = false;
        data.other = false;
    }

    function setOther() {
        data.isMando = false;
        data.isOther = true;
        data.other = {
            reason :        null,
            referrerref :   null,
            value :         null,
            email :         null,
            code :          null,
            approvedby :    null
        };
    }

    function onUpdateReason() {
        var reason = $elements.triggers.reason.val();
        if(reason !== 'referral-offer') {
            $elements.inputs.referrerref.val('');
        }
        updateValueOptions(data.other.reason === 'price-promise');
    }

    function isValid() {
        $elements.inputs.reason.valid();
        $elements.inputs.referrerref.valid();
        $elements.inputs.value.valid();
        $elements.inputs.email.valid();
        $elements.inputs.code.valid();
        return !_.isEmpty($elements.wrappers.available.find('.has-error'));
    }

    function isValidAuthoriseResponse(response) {
        if(!_.isEmpty(response) && _.isObject(response)) {
            return _.has(response,'isAuthorised') && response.isAuthorised === true && _.has(response,'username') && !_.isEmpty(response.username);
        }
    }

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
            renderMessage("error","All fields are mandatory");
        }
    }

    function deAuthorise() {
        flushMessage();
        $elements.inputs.code.val('');
        $elements.inputs.approvedby.val('');
        updateData();
        updateView();
    }

    function renderError(copy) {
        renderMessage('error', copy);
    }

    function renderSuccess(copy) {
        renderMessage('success', copy);
    }

    function renderMessage(type,copy) {
        flushMessage().append(
            '<p class="' + type + '">' + copy + '</p>'
        );
    }

    function flushMessage() {
        return $elements.wrappers.messages.empty();
    }

    function updateValueOptions(filtered) {
        filtered = filtered  || false;
        var $option = $('<option/>',{
            text: 'Please choose...'
        });
        $elements.inputs.value.empty().append($option);
        for(var i=valueRange.min; i <= valueRange[filtered ? 'otherMax':'max']; i = i + valueRange.inc) {
            $option = $('<option/>',{
                value: i,
                text: '$' + i
            });
            if(i === data.other.value) {
                $option.prop("selected", true);
            }
            $elements.inputs.value.append($option);
        }
    }

    meerkat.modules.register("healthVouchers", {
        init: init
    });

})(jQuery);
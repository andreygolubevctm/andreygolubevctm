;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        _initialised = false,
        _settings = {
            coverStartRange: {
                min: 0,
                max: 30
            },
            renderPaymentDaysCb: null
        },
        $firstName = null,
        _fundCode = null,
        _getAjax = null,
        _formattedUTCToday,
        _timeOffset = null,
        _dialogId = null,
        _appendDeductionDateMsg = false;

    function onInitialise() {
        $firstName = $('#health_application_primary_firstname');

        // do server call
        _serverCall();
    }

    function onFundInit(settings) {
        _settings = settings;
        _fundCode = Results.getSelectedProduct().info.provider;
        _appendDeductionDateMsg = false;

        meerkat.modules.healthCoverStartDate.setDaysOfWeekDisabled(_settings.weekends ? '' : '06');

        checkOffset();
    }

    function checkOffset(beforeSubmitCheck) {
        // format UTC today date to DD/MM/YYYY
        _formattedUTCToday = meerkat.modules.dateUtils.format(new Date(meerkat.modules.utils.getUTCToday()), 'DD/MM/YYYY');
        _timeOffset = beforeSubmitCheck;

        if (_timeOffset) {
            _settings.coverStartRange.min++;
            _settings.coverStartRange.max--;
            meerkat.modules.healthCoverStartDate.setToNextDay();

            if (beforeSubmitCheck) {

                // select next valid option for payment days
                var paymentMethod = meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() === 'cc' ? 'credit' : 'bank',
                    $paymentSelection = $('.health_payment_' + paymentMethod + '-selection select:visible'),
                    paymentSelectionValue = $paymentSelection.val();

                _settings.renderPaymentDaysCb();

                // update only if deduction day is today
                if (meerkat.modules.dateUtils.format(new Date(paymentSelectionValue), 'DD/MM/YYYY') === _formattedUTCToday) {
                    $paymentSelection.prop('selectedIndex', 1);
                    _appendDeductionDateMsg = true;
                } else {
                    $paymentSelection.val(paymentSelectionValue);
                }
            }
        }

        meerkat.modules.healthCoverStartDate.setCoverStartRange(_settings.coverStartRange.min, _settings.coverStartRange.max);

        return _timeOffset;
    }

    function checkBeforeSubmit(submitCB) {
        // check only if startDate is today
        if (meerkat.modules.healthCoverStartDate.getVal() !== _formattedUTCToday) return;

        if (checkOffset(true)) {
            var coverStartDate = meerkat.modules.healthCoverStartDate.getVal(),
                deductionDateMsg = _appendDeductionDateMsg ? ' and your payment will be deducted on ' + coverStartDate : '',
                htmlContent = "Hi "+$firstName.val()+", "+ _fundCode +" is based in <State>, the date here is now "+coverStartDate+" your policy will therefore commence on "+coverStartDate+deductionDateMsg+". Click submit to take out this policy.";

            // open popup message
            _dialogId = meerkat.modules.dialogs.show({
                id: 'fund-time-offset',
                htmlContent: htmlContent,
                showCloseBtn: false,
                buttons: [{
                    label: "Submit Application",
                    className: "btn btn-cta",
                    closeWindow: true,
                    // action: submitCB
                    action: function() {

                    }
                }]
            });
        } else {
            submitCB();
        }
    }

    function _serverCall() {

    }

    function setNextDay() {

    }

    meerkat.modules.register('healthFundTimeOffset', {
        onInitialise: onInitialise,
        onFundInit: onFundInit,
        checkOffset: checkOffset,
        // getOffset: getOffset,
        checkBeforeSubmit: checkBeforeSubmit
    });
})(jQuery);
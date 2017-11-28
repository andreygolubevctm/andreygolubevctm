;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        _settings = {
            coverStartRange: {
                min: 0,
                max: 30
            },
            renderPaymentDaysCb: null
        },
        _fundCode = null,
        _getFundTimeZoneAjax = null,
        _formattedUTCToday,
        _isWithinTime = {
            application: null,
            submit: null
        },
        _dialogId = null,
        _timezone = null,
        _timezoneStateMapping = {
            'Australia/NSW': 'NSW',
            'Australia/Queensland': 'QLD',
            'Australia/Victoria': 'VIC',
            'Australia/West': 'WEST'
        };

    function onInitialise(settings) {
        _settings = settings;
        _fundCode = Results.getSelectedProduct().info.provider;

        meerkat.modules.healthCoverStartDate.setDaysOfWeekDisabled(_settings.weekends ? '' : '06');

        checkOffset('application');
    }

    function checkOffset(typeOfCheck) {
        // format UTC today date to DD/MM/YYYY
        _formattedUTCToday = meerkat.modules.dateUtils.format(new Date(meerkat.modules.utils.getUTCToday()), 'DD/MM/YYYY');
        _getFundTimeZone();

        _getFundTimeZoneAjax && _getFundTimeZoneAjax.done(function() {
            if (_isWithinTime[typeOfCheck] === false) {
                _settings.coverStartRange.min++;
                _settings.coverStartRange.max--;
                meerkat.modules.healthCoverStartDate.setToNextDay();
            }

            meerkat.modules.healthCoverStartDate.setCoverStartRange(_settings.coverStartRange.min, _settings.coverStartRange.max);
        });
    }

    function checkBeforeSubmit(submitCB) {
        // check only if startDate is today
        if (meerkat.modules.healthCoverStartDate.getVal() !== _formattedUTCToday) {
            submitCB();
            return;
        }

        checkOffset('submit');

        meerkat.modules.healthSubmitApplication.disableSubmitApplication(true);

        _getFundTimeZoneAjax && _getFundTimeZoneAjax.done(function() {
            meerkat.modules.healthSubmitApplication.enableSubmitApplication();

            if (_isWithinTime['submit'] === false) {
                var paymentMethod = meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() === 'cc' ? 'credit' : 'bank',
                    $paymentSelection = $('.health_payment_' + paymentMethod + '-selection select:visible'),
                    coverStartDate = meerkat.modules.healthCoverStartDate.getVal(),
                    deductionDateMsg = '';

                if ($paymentSelection.length > 0) {
                    var paymentSelectionValue = $paymentSelection.val();

                    if (_.isFunction(_settings.renderPaymentDaysCb)) {
                        _settings.renderPaymentDaysCb();
                    }

                    // update only if deduction day is today
                    if (meerkat.modules.dateUtils.format(new Date(paymentSelectionValue), 'DD/MM/YYYY') === _formattedUTCToday) {
                        $paymentSelection.prop('selectedIndex', 1);
                        deductionDateMsg = ' and your payment will be deducted on ' +
                            meerkat.modules.dateUtils.format(new Date($paymentSelection.val()), 'DD/MM/YYYY');
                    } else {
                        $paymentSelection.val(paymentSelectionValue);
                    }
                }

                var htmlContent = "Hi " + meerkat.modules.healthApplyStep.getPrimaryFirstname() + ", " + _fundCode + " is based in " + _timezoneStateMapping[_timezone] + ", the date here is now " + coverStartDate +
                        " your policy will therefore commence on " + coverStartDate + deductionDateMsg + ". Click submit to take out this policy.";

                // open popup message
                _dialogId = meerkat.modules.dialogs.show({
                    id: 'fund-time-offset',
                    htmlContent: htmlContent,
                    showCloseBtn: false,
                    buttons: [{
                        label: "Submit Application",
                        className: "btn btn-cta",
                        closeWindow: true,
                        action: submitCB
                    }]
                });
            } else {
                submitCB();
            }
        });
    }

    function _getFundTimeZone() {
        _getFundTimeZoneAjax = meerkat.modules.comms.get({
            url: 'spring/health/fund/timezone/valid',
            data: {
                fundCode: _fundCode
            },
            cache: false,
            dataType: 'json',
            useDefaultErrorHandling: false,
            errorLevel: 'silent',
            timeout: 5000,
            onSuccess: function onSubmitSuccess(data) {
                _isWithinTime = {
                    application: data.application,
                    submit: data.submit
                };
                _timezone = data.timezone;
            }
        });
    }

    meerkat.modules.register('healthFundTimeOffset', {
        onInitialise: onInitialise,
        checkBeforeSubmit: checkBeforeSubmit
    });
})(jQuery);
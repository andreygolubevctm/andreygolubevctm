;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        _settings = {
            weekends: true,
            coverStartRange: {
                min: 0,
                max: 30
            },
            renderPaymentDaysCb: null
        },
        _fundCode = null,
        _deductionDate = null,
        _getFundTimeZoneAjax = null,
        _formattedUTCToday,
        _isWithinTime = {
            application: null,
            submit: null
        },
        _dialogId = null,
        _timezone = null,
        _timezoneStateMapping = {
            'Australia/NSW': 'New South Wales',
            'Australia/Queensland': 'Queensland',
            'Australia/Victoria': 'Victoria',
            'Australia/West': 'West Australia'
        },
        _fn = {
            setDaysOfWeekDisabled: 'setDaysOfWeekDisabled',
            setToNextDay: 'setToNextDay',
            getVal: 'getVal'
        },
        _template = null,
        CoverStartDate = null,
        SubmitApplication = null;

    function init() {
        _template = _.template($('#fund-timezone-offset-modal-template').html());
        CoverStartDate = meerkat.modules.healthCoverStartDate;
        SubmitApplication = meerkat.modules.healthSubmitApplication;
        var extraFuncString = '';

        if (meerkat.site.isCallCentreUser) {
            extraFuncString = 'CoverStart';
            CoverStartDate = meerkat.modules.healthPaymentStep;
            SubmitApplication = meerkat.modules.health;
        }

        _fn = {
            setDaysOfWeekDisabled: 'set'+extraFuncString+'DaysOfWeekDisabled',
            setToNextDay: 'set'+extraFuncString+'ToNextDay',
            getVal: 'get'+extraFuncString+'Val'
        };
    }

    function onInitialise(settings) {
        _settings = settings;
        _fundCode = Results.getSelectedProduct().info.provider;
        _deductionDate = null;
        CoverStartDate[_fn.setDaysOfWeekDisabled](_settings.weekends ? '' : '06');

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
                CoverStartDate[_fn.setToNextDay]();
            }

            CoverStartDate.setCoverStartRange(_settings.coverStartRange.min, _settings.coverStartRange.max);
        });
    }

    function checkBeforeSubmit(submitCB) {
        // check only if startDate is today
        if (CoverStartDate[_fn.getVal]() !== _formattedUTCToday) {
            submitCB();
            return;
        }

        checkOffset('submit');

        SubmitApplication.disableSubmitApplication(true);

        _getFundTimeZoneAjax && _getFundTimeZoneAjax.done(function() {
            SubmitApplication.enableSubmitApplication();

            if (_isWithinTime['submit'] === false) {
                var paymentMethod = meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() === 'cc' ? 'credit' : 'bank',
                    $paymentSelection = $('.health_payment_' + paymentMethod + '-selection select:visible');

                if ($paymentSelection.length > 0) {
                    var paymentSelectionValue = $paymentSelection.val();

                    if (_.isFunction(_settings.renderPaymentDaysCb)) {
                        _settings.renderPaymentDaysCb();
                    }

                    // update only if deduction day is today
                    if (meerkat.modules.dateUtils.format(new Date(paymentSelectionValue), 'DD/MM/YYYY') === _formattedUTCToday) {
                        $paymentSelection.prop('selectedIndex', 1);
                        _deductionDate = meerkat.modules.dateUtils.format(new Date($paymentSelection.val()), 'DD/MM/YYYY');
                    } else {
                        $paymentSelection.val(paymentSelectionValue);
                    }
                }

                // open popup message
                _dialogId = meerkat.modules.dialogs.show({
                    id: 'fund-timezone-offset',
                    htmlContent: _getHTMLContent(),
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

    function _getHTMLContent() {
        var data = {
            fundCode: _fundCode,
            timezone: _timezoneStateMapping[_timezone],
            coverStartDate: CoverStartDate[_fn.getVal](),
            deductionDate: _deductionDate
        };

        if (!meerkat.site.isCallCentreUser) {
            data.firstname = meerkat.modules.healthApplyStep.getPrimaryFirstname();
        }

        return _template(data);
    }

    meerkat.modules.register('healthFundTimeOffset', {
        init: init,
        onInitialise: onInitialise,
        checkBeforeSubmit: checkBeforeSubmit
    });
})(jQuery);
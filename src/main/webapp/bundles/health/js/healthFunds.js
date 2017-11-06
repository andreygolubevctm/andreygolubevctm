(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthFunds: {}
        };

    var _fund = false,
        $_authority,
        $_authorityText,
        _payments = {},
        $_dependantDefinition,
        $_optionDR,
        medicareHelpId;

    // If retrieving a quote and a product had been selected, inject the fund's application set.
    // This is in case any custom form fields need access to the data bucket, because write_quote will erase the data when it's not present in the form.
    // A fund must implement the processOnAmendQuote property for this to occur.
    function checkIfNeedToInjectOnAmend(callback) {
        if ($('#health_application_provider').val().length > 0) {
            var provider = $('#health_application_provider').val(),
                objname = 'healthFunds_' + provider;

            $(document.body).addClass('injectingFund');

            meerkat.modules.healthFunds.load(
                provider,
                function injectFundLoaded() {
                    if (window[objname].processOnAmendQuote && window[objname].processOnAmendQuote === true) {
                        window[objname].set();
                        window[objname].unset();
                    }

                    $(document.body).removeClass('injectingFund');

                    callback();
                },
                false
            );

        } else {
            callback();
        }
    }

    // Create the 'child' method over-ride
    function load(fund, callback, performProcess) {

        if (fund === '' || !fund) {
            meerkat.modules.healthFunds.loadFailed('Empty or false');
            return false;
        }

        if (performProcess !== false) performProcess = true;

        // Load separate health fund JS
        if (typeof window['healthFunds_' + fund] === 'undefined' || window['healthFunds_' + fund] === false) {
            var returnval = true;

            var data = {
                transactionId: meerkat.modules.transactionId.get()
            };

            $.ajax({
                url: 'common/js/health/healthFunds_' + fund + '.jsp' + '?brandCode=' + meerkat.site.urlStyleCodeId,
                dataType: 'script',
                data: data,
                async: true,
                timeout: 30000,
                cache: false,
                beforeSend: function (xhr, setting) {
                    var url = setting.url;
                    var label = "uncache";
                    url = url.replace("?_=", "?" + label + "=");
                    url = url.replace("&_=", "&" + label + "=");
                    setting.url = url;
                },
                success: function () {
                    // Process
                    if (performProcess) {
                        meerkat.modules.healthFunds.process(fund);
                    }
                    // Callback
                    if (typeof callback === 'function') {
                        callback(true);
                    }
                },
                error: function (obj, txt) {
                    meerkat.modules.healthFunds.loadFailed(fund, txt);

                    if (typeof callback === 'function') {
                        callback(false);
                    }
                }
            });

            return false; //waiting
        }

        // If same fund then don't need to re-apply the rules
        if (fund != _fund && performProcess) {
            meerkat.modules.healthFunds.process(fund);
        }

        // Success callback
        if (typeof callback === 'function') {
            callback(true);
        }

        return true;
    }

    function process(fund) {

        // set the main object's function calls to the specific provider
        var O_method = window['healthFunds_' + fund];

        meerkat.modules.healthFunds.set = O_method.set;
        meerkat.modules.healthFunds.unset = O_method.unset;

        // action the provider
        $('body').addClass(fund);

        meerkat.modules.healthFunds.set();
        _fund = fund;

    }

    function loadFailed(fund, errorTxt) {
        FatalErrorDialog.exec({
            message: "Unable to load the fund's application questions",
            page: "health:health_funds.tag",
            description: "meerkat.modules.healthFunds.update(). Unable to load fund questions for: " + fund,
            data: errorTxt
        });
    }

    function unload() {
        if (_fund !== false) {
            meerkat.modules.healthFunds.unset();
            $('body').removeClass(_fund);
            _fund = false;
            meerkat.modules.healthFunds.set = function () {
            };
            meerkat.modules.healthFunds.unset = function () {
            };
        }
    }

    function _dependants(message) {
        if (message !== false) {
            // SET and ADD the dependant definition
            $_dependantDefinition = $('#mainform').find('.health-dependants').find('.definition');
            $_dependantDefinition.html(message);
        } else {
            $_dependantDefinition.html('');
            $_dependantDefinition = undefined;
        }
    }

    function _memberIdRequired(required) {
        $('#clientMemberID input[type=text], #partnerMemberID input[type=text]').setRequired(required);
    }

    function _previousfund_authority(message) {
        if (message !== false) {
            // SET and ADD the authority 'label'
            $_authority = $('.health_previous_fund_authority label span');
            $_authorityText = $_authority.eq(0).text();
            $_authority.text(meerkat.modules.healthResults.getSelectedProduct().info.providerName);
            $('.health_previous_fund_authority').removeClass('hidden');
        }
        else if (typeof $_authority !== 'undefined') {
            $_authority.text($_authorityText);
            $_authority = undefined;
            $_authorityText = undefined;
            $('.health_previous_fund_authority').addClass('hidden');
        }
    }


    function _partner_authority(display) {
        if (display === true) {
            $('#partnerContainer .health_previous_fund_authority').removeClass('hidden');
        } else {
            $('#partnerContainer .health_previous_fund_authority').addClass('hidden');
        }
    }

    function _reset() {
        meerkat.modules.healthFunds.hideHowToSendInfo();
        meerkat.modules.healthFunds._partner_authority(false);
        _memberIdRequired(true);
        meerkat.modules.healthDependants.resetConfig();
    }

    function applicationFailed() {
        return false;
    }

    // Fund customisation setting, used via the fund 'child' object
    function set() {
    }

    // Unpicking the fund customisation settings, used via the fund 'child' object
    function unset() {
    }

// Creates the earliest date based on any of the matching days (not including an exclusion date)
    function _earliestDays(euroDate, a_Match, _exclusion) {
        if (!$.isArray(a_Match) || euroDate === '') {
            return false;
        }
        // creating the base date from the exclusion
        var _now = meerkat.modules.dateUtils.returnDate(euroDate);
        // 2014-03-05 Leto: Why is this hardcoded when it's also a function argument?
        _exclusion = 7;
        var _date = new Date(_now.getTime() + (_exclusion * 24 * 60 * 60 * 1000));
        var _html = '<option value="">No date has been selected for you</option>';
        // Loop through 31 attempts to match the next date
        for (var i = 0; i < 31; i++) {
            /*var*/
            _date = new Date(_date.getTime() + (24 * 60 * 60 * 1000));
            // Loop through the selected days and attempt a match
            for (a = 0; a < a_Match.length; a++) {
                if (a_Match[a] == _date.getDate()) {
                    var _dayString = meerkat.modules.numberUtils.leadingZero(_date.getDate());
                    var _monthString = meerkat.modules.numberUtils.leadingZero(_date.getMonth() + 1);
                    /*var*/
                    _html = '<option value="' + meerkat.modules.dateUtils.dateValueServerFormat(_date) + '" selected="selected">' +
                        meerkat.modules.dateUtils.dateValueLongFormat(_date) + '</option>';
                    i = 99;
                    break;
                }
            }
        }
        return _html;
    }

    function _setPolicyDate(dateObj, addDays) {

        var dateSplit = dateObj.split('/');
        var dateFormated = dateSplit[2] + '-' + dateSplit[1] + '-' + dateSplit[0];

        var newdate = new Date(dateFormated);
        newdate.setDate(newdate.getDate() + addDays);

        var dd = ("0" + newdate.getDate()).slice(-2);
        var mm = ("0" + (newdate.getMonth() + 1)).slice(-2);
        var y = newdate.getFullYear();

        return y + '-' + mm + '-' + dd;
    }

    function setPayments(payments) {
        _payments = payments;
    }

    function getPayments() {
        return _payments;
    }

    function setDoctorOption(option) {
        $_optionDR = option;
    }

    function getDoctorOption() {
        return $_optionDR;
    }

    function setMedicareCoverHelpId(id) {
        medicareHelpId = id;
    }

    function getMedicareCoverHelpId() {
        return medicareHelpId;
    }

    function toggleWarning($container) {
        var selectedProduct = meerkat.modules.healthResults.getSelectedProduct(),
            $fundWarning = $container.find('.fundWarning');

        // Show warning if applicable
        if (typeof selectedProduct.warningAlert !== 'undefined' && selectedProduct.warningAlert !== '') {
            $fundWarning.show().html(selectedProduct.warningAlert);
        } else {
            $fundWarning.hide().empty();
        }
    }

    function showHowToSendInfo(providerName, required) {
        var contactPointGroup = $('#health_application_contactPoint-group'),
            contactPoint = contactPointGroup.find('.control-label span');

        contactPoint.text( providerName);
        contactPointGroup.find('input').setRequired(required, 'Please choose how you would like ' + providerName + ' to contact you');
        contactPointGroup.removeClass('hidden');
    }

    function hideHowToSendInfo() {
        var contactPointGroup = $('#health_application_contactPoint-group');
        contactPointGroup.addClass('hidden');
    }

    meerkat.modules.register("healthFunds", {
        applicationFailed: applicationFailed,
        checkIfNeedToInjectOnAmend: checkIfNeedToInjectOnAmend,
        load: load,
        unload: unload,
        getPayments: getPayments,
        setPayments: setPayments,
        _previousfund_authority: _previousfund_authority,
        _partner_authority: _partner_authority,
        process: process,
        loadFailed: loadFailed,
        _reset: _reset,
        _dependants: _dependants,
        _setPolicyDate: _setPolicyDate,
        getDoctorOption: getDoctorOption,
        setDoctorOption: setDoctorOption,
        setMedicareCoverHelpId: setMedicareCoverHelpId,
        getMedicareCoverHelpId: getMedicareCoverHelpId,
        toggleWarning: toggleWarning,
        showHowToSendInfo: showHowToSendInfo,
        hideHowToSendInfo: hideHowToSendInfo
    });

})(jQuery);
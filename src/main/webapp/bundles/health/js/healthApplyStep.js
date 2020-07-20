;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $paymentDetailsStart,
        $paymentMedicareColour,
        $paymentMedicareCover,
        $medicareYellowMessage,
        $medicareExpiryDayWrapper,
        $medicareExpiryMonthWrapper,
        $medicareExpiryYearWrapper,
        $medicareExpiryGroupWrapper,
        $unitElements,
        $personName,
        $primaryName,
        _postalNonStdStreetRegexRule,
        $primaryMemberNumber,
        $partnerMemberNumber,
        $primaryDifferentFundsScript,
        $partnerDifferentFundsScript;

    function init(){
        $(document).ready(function () {
            $paymentDetailsStart = $("#health_payment_details_start");
            $paymentMedicareColour = $("#health_payment_medicare_colour");
            $paymentMedicareCover = $("#health_payment_medicare_cover");
            $medicareYellowMessage = $("#health_medicareDetails_yellowCardMessage");
            $medicareExpiryDayWrapper = $("#health_payment_medicare_expiry_cardExpiryDay").parent().parent();
            $medicareExpiryMonthWrapper = $("#health_payment_medicare_expiry_cardExpiryMonth").parent().parent();
            $medicareExpiryYearWrapper = $("#health_payment_medicare_expiry_cardExpiryYear").parent().parent();
            $medicareExpiryGroupWrapper = $("#health_payment_medicare_expiry_cardExpiryMonth").parent().parent().parent().parent();

            $unitElements = {
                appAddressUnitShop: $('#health_application_address_unitShop'),
                appAddressStreetNum: $('#health_application_address_streetNum'),
                appAddressUnitType: $('#health_application_address_unitType'),
                appPostalUnitShop: $('#health_application_postal_unitShop'),
                appPostalStreetNum: $('#health_application_postal_streetNum'),
                appPostalUnitType: $('#health_application_postal_unitType'),
                appPostalNonStdStreet: $('#health_application_postal_nonStdStreet')
            };
            $personName = $('.contactField.person_name');
            $primaryName = {
                first: $('#health_application_primary_firstname'),
                middle: $('#health_application_primary_middleName'),
                last: $('#health_application_primary_surname'),
                medicare: {
                    first: $('#health_payment_medicare_firstName'),
                    middle: $('#health_payment_medicare_middleName'),
                    last: $('#health_payment_medicare_surname')
                }
            };

            $primaryMemberNumber = $('#health_previousfund_primary_memberID');
            $partnerMemberNumber = $('#health_previousfund_partner_memberID');
            $primaryDifferentFundsScript = $('.simples-dialogue-different-funds-primary');
            $partnerDifferentFundsScript = $('.simples-dialogue-different-funds-partner');
            _postalNonStdStreetRegexRule = $unitElements.appPostalNonStdStreet.attr('data-rule-regex');
        });
    }

    // Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
    function onBeforeEnter(){
        // validate at least 1 contact number is entered
        $('#health_application_mobileinput').addRule('requireOneContactNumber', true, 'Please include at least one phone number');

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PARTNER,
            meerkat.modules.healthAboutYou.getPartnerCurrentCover());

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthAboutYou.getPrimaryCurrentCover());

        // Default Check format message on person name field
        $personName.parent().find('.person-name-check-format').addClass('hidden');
        
        $primaryDifferentFundsScript.toggleClass('hidden', meerkat.modules.healthAboutYou.getPrimaryCurrentCover() === 'N' || meerkat.modules.healthAboutYou.getPrimaryHealthCurrentCover() !== 'C');

        $partnerDifferentFundsScript.toggleClass('hidden', meerkat.modules.healthAboutYou.getPartnerCurrentCover() === 'N' || meerkat.modules.healthAboutYou.getPartnerHealthCurrentCover() !== 'C');

        meerkat.modules.healthCancellationType.init();

        if(meerkat.modules.healthAboutYou.getPrimaryCurrentCover() === 'N') {
            $primaryMemberNumber.removeAttr('required');
        }else {
            $primaryMemberNumber.attr('required', true);
        }

        if(meerkat.modules.health.hasPartner()) {
            if(meerkat.modules.healthAboutYou.getPartnerCurrentCover() === 'N') {
                $partnerMemberNumber.removeAttr('required');
            }else {
                $partnerMemberNumber.attr('required', true);
            }
        }
    }

    function onInitialise() {
        $paymentMedicareColour
            .addRule('medicareCardColour')
            .on('change', function() {
                var value = $(this).val();
                // set hidden Medicare cover value
                $paymentMedicareCover.val(value === 'none' ? 'N' : 'Y');

                // toggle message for Yellow card holders
                $medicareYellowMessage.toggleClass('hidden', value !== 'yellow');

                // Show expiry day field if yellow or blue medicare card and adjust field widths to suit
                var showMedicareDayField = (value === 'yellow' || value === 'blue');

                $medicareExpiryDayWrapper.toggleClass('hidden', !showMedicareDayField);

                $medicareExpiryMonthWrapper.toggleClass('col-xs-4  allow-for-exp-day', showMedicareDayField);
                $medicareExpiryMonthWrapper.toggleClass('col-xs-6', !showMedicareDayField);

                $medicareExpiryYearWrapper.toggleClass('col-xs-4', showMedicareDayField);
                $medicareExpiryYearWrapper.toggleClass('col-xs-6', !showMedicareDayField);
            })
            .trigger('change');

        // initialise start date datepicker from payment step as it will be used by selected fund
        $paymentDetailsStart
            .datepicker({ clearBtn:false, format:"dd/mm/yyyy" })
            .on("changeDate", function updateStartCoverDateHiddenField(e) {
                // fill the hidden field with selected value
                $("#health_payment_details_start").val( e.format() );
                meerkat.messaging.publish(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
            });

        $unitElements.appPostalUnitType.on('change', function toggleUnitRequiredFields() {
            _changeStreetNoLabel(this.value);
            _toggleRegexValidation(this.value);
        });

        $unitElements.appAddressUnitShop.add($unitElements.appPostalUnitShop).on('change', function toggleUnitShopRequiredFields() {
            _toggleUnitShopRequired(this.id.indexOf('address') !== -1 ? 'Address' : 'Postal', !_.isEmpty(this.value));
        });

        // Show Check format message on name fields when field isn't in 'Proper case'
        $personName.on('change', function() {
            var value = $(this).val(),
                showCheckFormat = false,
                i = 1,
                character = '',
                $checkFormat = $(this).parent().find('.person-name-check-format');

            if (!_.isEmpty(value)) {
                for (i = 1; i < value.length; i++) {
                    character = value.charAt(i);

                    if (character === character.toUpperCase()) {
                        showCheckFormat = true;
                    }
                }

                $checkFormat.toggleClass('hidden', showCheckFormat === false);
            } else {
                $checkFormat.addClass('hidden');
            }
        });

        $primaryName.first.on('blur.apply', function(){
            $primaryName.medicare.first.val($primaryName.first.val());
        });

        $primaryName.middle.on('blur.apply', function(){
            $primaryName.medicare.middle.val($primaryName.middle.val());
        });

        $primaryName.last.on('blur.apply', function(){
            $primaryName.medicare.last.val($primaryName.last.val());
        });

        $primaryMemberNumber.on('keyup', function() {
            var input = $(this);
            var value = input.val().replace(/[\W_]+/g, '');
            input.val(value);
        });

        $partnerMemberNumber.on('keyup', function() {
            var input = $(this);
            var value = input.val().replace(/[\W_]+/g, '');
            input.val(value);
        });

    }

    function _changeStreetNoLabel(unitType) {
        var $label = $unitElements.appPostalStreetNum.closest('.form-group').find('label.control-label'),
            $errorField = $('#health_application_postal_streetNum-error'),
            labelText = 'Street No.',
            msgRequired = 'Please enter a street number';

        if (unitType === 'PO') {
            labelText = 'Box No.';
            msgRequired = 'Please enter a box number';
        }

        $label.text(labelText);
        $unitElements.appPostalStreetNum.attr('data-msg-required', msgRequired);

        if ($errorField.length > 0) {
            $errorField.text(msgRequired);
        }
    }

    function _toggleRegexValidation(unitType) {
        if (unitType === 'PO') {
            $unitElements.appPostalNonStdStreet.removeRule('regex');
            $unitElements.appPostalNonStdStreet.blur();
        } else {
            $unitElements.appPostalNonStdStreet.addRule('regex', _postalNonStdStreetRegexRule);
        }
    }

    function _toggleUnitShopRequired(addressType, isUnitShop) {
        $unitElements['app'+addressType+'UnitType'].setRequired(isUnitShop);

        // blur out of fields to trigger validation when unitShop not empty
        if (!isUnitShop) {
            $unitElements['app'+addressType+'UnitType'].blur();
        }
    }

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise
    });

})(jQuery);
(function ($) {

    /**
     * This validation rule prevents someone who is a female from selecting "Mr" and vice versa.
     */
    $.validator.addMethod("genderTitle", function (value, element, param) {

        if (value === '') {
            return true;
        }

        /* Adding another case for dependants gender */
        var className = (param === true) ? 'person-gender' : param;

        var _gender = $(element).closest('.qe-window').find('.' + className + ' input:checked').val();

        if (typeof _gender == 'undefined' || _gender === '') {
            return true; // no need to validate until both completed
        }
        switch (value) {
            case 'MR':
                return _gender == 'M';
            case 'MRS':
            case 'MISS':
            case 'MS':
                return _gender == 'F';
            default:
                return true;
        }
    }, 'The title and gender do not match');

    $.validator.addMethod("medicareNumber", function (value, elem, parm) {

        var cardNumber = value.replace(/\s/g, ''); //remove spaces

        if (isNaN(cardNumber)) {
            return false;
        }

        /* Ten is the length */
        if (cardNumber.length != 10) {
            return false;
        }

        /* Must start between 2 and 6 */
        if ((cardNumber.substring(0, 1) < 2) || (cardNumber.substring(0, 1) > 6)) {
            return false;
        }

        var sumTotal =
            (cardNumber.substring(0, 1) * 1)
            + (cardNumber.substring(1, 2) * 3)
            + (cardNumber.substring(2, 3) * 7)
            + (cardNumber.substring(3, 4) * 9)
            + (cardNumber.substring(4, 5) * 1)
            + (cardNumber.substring(5, 6) * 3)
            + (cardNumber.substring(6, 7) * 7)
            + (cardNumber.substring(7, 8) * 9);

        /* Remainder needs to = the 9th number */
        return sumTotal % 10 == cardNumber.substring(8, 9);
    }, 'Please enter a valid Medicare card number');

    $.validator.addMethod("medicareLastName", function (value, elem, parm) {

        var firstName = $('.health-medicare_details-first_name').val(),
            initialLength = 3, // Always one character plus space each side
            maxLength = 0;

        maxLength = 50 - initialLength - (firstName).length;

        return (value.length <= maxLength);
    }, 'Your full name can not be longer than 50 characters in total');

    function getMonth() {
        var realMonth = meerkat.site.serverDate.getMonth()+1 ;
        return realMonth < 10 ? "0"+realMonth:realMonth;
    }

    /**
     * Applies to both credit cards and medicare cards.
     */
    $.validator.addMethod("cardExpiry", function (value, elem, param) {
        if ($('#' + param.prefix + '_cardExpiryYear').val() !== '' && $('#' + param.prefix + '_cardExpiryMonth').val() !== '') {
            var now_ym = parseInt(meerkat.site.serverDate.getFullYear() + '' + getMonth());
            var sel_ym = parseInt('20' + $('#' + param.prefix + '_cardExpiryYear').val() + '' + $('#' + param.prefix + '_cardExpiryMonth').val());
            return sel_ym >= now_ym;
        }
        return false;
    });

    $.validator.addMethod("medicareCardExpiry", function (value, elem, param) {

        if (typeof param !== 'undefined' && param.medicareCardSelector && param.prefix) {

            var check = false;

            var selectedCardColour = $('select[name=' + param.medicareCardSelector + ']').find('option:selected').val();

            if (selectedCardColour === 'yellow' || selectedCardColour === 'blue') {

                // blue and yellow medicare cards use dd/mm/yyyy input

                if ($('#' + param.prefix + '_cardExpiryYear').val() !== '' && $('#' + param.prefix + '_cardExpiryMonth').val() !== ''&& $('#' + param.prefix + '_cardExpiryDay').val() !== '') {

                    var d = parseInt($('#' + param.prefix + '_cardExpiryDay').val());
                    var m = parseInt($('#' + param.prefix + '_cardExpiryMonth').val());
                    var y = parseInt("20" + $('#' + param.prefix + '_cardExpiryYear').val());

                    var theDateEntered = new Date(y, m - 1, d);

                    var theExtrapolatedDay = theDateEntered.getDate();
                    var theExtrapolatedMonth = theDateEntered.getMonth() + 1;
                    var theExtrapolatedYear = theDateEntered.getFullYear();

                    // check if date entered is equal to values pulled from date object (if they dont match then it will error (eg choosing 29th of feb on a non leap year or choosing 31st for september)
                    check = (theExtrapolatedYear === y) && (theExtrapolatedMonth === m) && (theExtrapolatedDay === d);

                    if (check) {
                        // check that the card has not expired
                        theDateEntered.setHours(0,0,0,0);
                        var today = new Date();
                        today.setHours(0,0,0,0);

                        check = theDateEntered >= today;
                    }

                }

            } else {
                // green medicare cards use mm/yyyy input

                if ($('#' + param.prefix + '_cardExpiryYear').val() !== '' && $('#' + param.prefix + '_cardExpiryMonth').val() !== '') {
                    var now_ym = parseInt(meerkat.site.serverDate.getFullYear() + '' + getMonth());
                    var sel_ym = parseInt('20' + $('#' + param.prefix + '_cardExpiryYear').val() + '' + $('#' + param.prefix + '_cardExpiryMonth').val());
                    check =  sel_ym >= now_ym;
                }
            }

            return check;
        } else {

            //this validation rule requires both the prefix and  medicareCardSelector parameters to to be supplied against the param object
            return false;
        }
    });

    // Was never working in __health_legacy.js as it used ${name} instead of javascript. Would always pass I believe.
    $.validator.addMethod("validateMinDependants", function (value, element, param) {
            return !$("#" + param.prefix + "_threshold").is(":visible");
        }
    );

    //Validation for defacto messages
    $.validator.addMethod("defactoConfirmation", function (value, element) {
        return $(element).parent().find(':checked').val() == 'Y';
    }, "Sorry, the highlighted dependant cannot be added to this policy. Please contact us if you require assistance.");

    //DOB validation message
    $.validator.addMethod("limitDependentAgeToUnder25", function (value) {
        var getAge = meerkat.modules.age.returnAge(value, true);
        var isValid = true;
        var familyCoverType = meerkat.modules.healthChoices.returnCoverCode();
        var message = 'Your dependant cannot be added to the policy as they are aged {AGE} years or older. You can still arrange cover for this dependent by applying for a separate singles policy.';
        if (getAge >= meerkat.modules.healthDependants.getMaxAge()) {
            switch (Results.getSelectedProduct().info.FundCode) {
                case 'AHM':
                        $.validator.messages.limitDependentAgeToUnder25 = message.replace('{AGE}', meerkat.modules.healthDependants.getMaxAge());
                        isValid = false;
                    break;
                case 'BUP':
                        $.validator.messages.limitDependentAgeToUnder25 = message.replace('{AGE}', meerkat.modules.healthDependants.getMaxAge());
                        isValid = false;
                    break;
                case 'WFD':
                    if (getAge >= meerkat.modules.healthDependants.getExtendedFamilyMaxAge()) {
                        //dependant age cannot be covered by any family cover type
                        $.validator.messages.limitDependentAgeToUnder25 = message.replace('{AGE}', meerkat.modules.healthDependants.getExtendedFamilyMaxAge());
                        isValid = false;
                    } else if (['F', 'SPF'].includes(familyCoverType)) {
                        //dependant age cannot be covered family or single parent family
                        $.validator.messages.limitDependentAgeToUnder25 = message.replace('{AGE}', 'between ' + meerkat.modules.healthDependants.getExtendedFamilyMinAge() +
                            ' - ' + meerkat.modules.healthDependants.getExtendedFamilyMaxAge());
                        isValid = false;
                    }
                    break;
                default:
                    $.validator.messages.limitDependentAgeToUnder25 = (message.replace('dependant', 'child').replace('{AGE}', meerkat.modules.healthDependants.getMaxAge())).slice(0, -1) +
                        ' or please contact us if you require assistance.';
                    isValid = false;
            }
        }
        return isValid;
    }, "Your child cannot be added to the policy as they are aged 25 years or older. You can still arrange cover for this dependant by applying for a separate singles policy or please contact us if you require assistance.");


    //If fulltime student toggle is enabled, use this validator instead of the above one
    $.validator.addMethod("validateFulltime", function (value, element) {
        var $wrapper = $(element).closest('.health_dependant_details'),
            dependantId = $wrapper.attr('data-id'),
            $dob = $('#health_application_dependants_dependant' + dependantId + '_dob');

            var fullTime = $wrapper.find('.health_dependant_details_fulltimeGroup input[type=radio]:checked').val();
            var getAge = meerkat.modules.age.returnAge($dob.val(), true);
            var dependantConfig = meerkat.modules.healthDependants.getConfig();
            var maxAge = meerkat.modules.healthDependants.getMaxAge();
            var suffix = dependantConfig.schoolMinAge == 21 ? 'st' : dependantConfig.schoolMinAge == 22 ? 'nd' : dependantConfig.schoolMinAge == 23 ? 'rd' : 'th';
            if (getAge >= maxAge) {
                $.validator.messages.validateFulltime = 'Dependants over ' + maxAge + ' are considered adult dependants and can still be covered by applying for a separate singles policy';
                return false;
            } else if (fullTime === 'N' && getAge >= dependantConfig.schoolMinAge) {
                $.validator.messages.validateFulltime = 'This product only covers dependants who are studying full-time, past the age of ' + dependantConfig.schoolMinAge;
                return false;
            }
            return true;
        }
    );


    /**
     * Credit Card Validation
     */

    $.validator.addMethod("ccv", function (value, element) {
        var len = $(element).attr('maxlength') || 4;
        var regex = '^\\d{' + len + '}$';
        return value.search(regex) != -1;
    }, 'Please enter a valid CCV number');

    var creditCardRules = {
        "a": new RegExp('^3[47][0-9]{13}$'),
        "d": new RegExp('^3(?:0[0-5]|[68][0-9])[0-9]{11}$'),
        "m": new RegExp('^5[1-5][0-9]{14}$'),
        "v": new RegExp('^4[0-9]{12}(?:[0-9]{3})?$')
    };

    $.validator.addMethod("creditCardNumber", function (value, elem, param) {

            /* Strip non-numeric */
            value = value.replace(/[^0-9]/g, '');

            var message;
            switch (param.cardType) {
                case 'm':
                    message = 'Please enter a valid Mastercard card number';
                    break;
                case 'v':
                    message = 'Please enter a valid Visa card number';
                    break;
                case 'a':
                    message = 'Please enter a valid American Express card number';
                    break;
                case 'd':
                    message = 'Please enter a valid Diners Club card number';
                    break;
                default:
                    $.validator.messages.creditCardNumber = "Please enter a valid credit card number";
                    return value.length == 16;
            }
            $.validator.messages.creditCardNumber = message;

            return value.search(creditCardRules[param.cardType]) !== -1;
        },
        "Please enter a valid credit card number"
    );

    $.validator.addMethod('validateBupaCard', function(val, el, param) {
        val = $(el).val();
        // Validation rules:
        // - Digits and asterisks only (no spaces or what not)
        return meerkat.modules.healthResults.getSelectedProduct().info.FundCode === 'BUP' ? !!val : val.match(/[0-9]{1,12}(\*){1,}[0-9]{1,4}/);
    }, 'Please register a valid credit card');

    $.validator.addMethod("matchStates", function (value, element) {
            return healthApplicationDetails.testStatesParity();
        },
        "Health product details, prices and availability are based on the state in which you reside. The postcode entered here does not match the original state provided at the start of the search. If you have made a mistake with the postcode on this page please rectify it before continuing. Otherwise please <a href='#results' class='changeStateAndQuote'>carry out the quote again</a> using this state."
    );

})(jQuery);

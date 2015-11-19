(function($) {
    $.validator.addMethod("amountPeriodRequired",
        function(value, element) {

            var amount = $('#' + $(element).attr('id').replace('_period', '_amount') );
            var period = $(element);

            var amt = $.trim(amount.val());

            if(amt === '' || amt === '0' || (amount.val !== '' && period.val() !== '')){
                return true;
            } else {
                return false;
            }

        },
        "Replace this message with something else"
    );

    $.validator.addMethod("maximumSpend",
        function(value, e) {

            element = $('#' + $(e).attr('id').replace('amountentry', 'amount'));
            var spend = $(element).val();
            var period = $('#' + $(element).attr('id').replace('_amount', '_period') );
            var normalise;

            switch($(period).val()) {
                case 'M':
                    normalise = 1;
                    break;
                case 'B':
                    normalise = 2;
                    break;
                case 'Q':
                    normalise = 3;
                    break;
                default:
                    normalise = 12;
                    break;
            }

            if(spend >= 1 && spend < (5000 * normalise)){
                return true;
            } else {
                return false;
            }

        },
        (function(value, e) {
            element = $('#' + $(e).attr('id').replace('amountentry', 'amount'));
            var period = $('#' + $(element).attr('id').replace('_amount', '_period') );

            switch($(period).val()) {
                case 'M':
                    return "Monthly spend should be between $1 and $5,000";
                case 'B':
                    return "Bimonthly spend should be between $1 and $10,000";
                case 'Q':
                    return "Quartly spend should be between $1 and $15,000";
                default:
                    return "Annual spend should be between $1 and $60,000";
            }
        })
    );

    $.validator.addMethod("maximumUsage",
        function(value, e) {

            element = $('#' + $(e).attr('id').replace('amountentry', 'amount'));
            var usage = $(element).val();
            var period = $('#' + $(element).attr('id').replace('_amount', '_period') );
            var normalise;
            var valid = false;

            switch($(period).val()) {
                case 'M':
                    if(usage === '' || (usage >= 0 && usage <= 7000)){
                        valid = true;
                    }
                    break;
                case 'B':
                    if(usage === '' || (usage >= 0 && usage <= 14000)){
                        valid = true;
                    }
                    break;
                case 'Q':
                    if(usage === '' || (usage >= 0 && usage <= 20000)){
                        valid = true;
                    }
                    break;
                default:
                    if(usage === '' || (usage >= 0 && usage <=  85000)){
                        valid = true;
                    }
                    break;
            }

            return valid;
        },
        (function(value, e) {
            element = $('#' + $(e).attr('id').replace('amountentry', 'amount'));
            var period = $('#' + $(element).attr('id').replace('_amount', '_period') );

            switch($(period).val()) {
                case 'M':
                    return "Monthly usage should be between 1kWh and 7,000kWh";
                case 'B':
                    return "Bimonthly usage should be between 1kWh and 14,000kWh";
                case 'Q':
                    return "Quarterly usage should be between 1kWh and 20,000kWh";
                default:
                    return "Annual usage should be between 1kWh and 85,000kWh";
            }
        })
    );

    $.validator.addMethod("maximumUsageGas",
        function(value, e) {

            element = $('#' + $(e).attr('id').replace('amountentry', 'amount'));
            var usage = $(element).val();
            var period = $('#' + $(element).attr('id').replace('_amount', '_period') );
            var normalise;
            var valid = false;

            switch($(period).val()) {
                case 'M':
                    if(usage === '' || (usage >= 0 && usage <= 6500)){
                        valid = true;
                    }
                    break;
                case 'B':
                    if(usage === '' || (usage >= 0 && usage <= 14000)){
                        valid = true;
                    }
                    break;
                case 'Q':
                    if(usage === '' || (usage >= 0 && usage <= 20000)){
                        valid = true;
                    }
                    break;
                default:
                    if(usage === '' || (usage >= 0 && usage <=  85000)){
                        valid = true;
                    }
                    break;
            }

            return valid;
        },
        (function(value, e) {
            element = $('#' + $(e).attr('id').replace('amountentry', 'amount'));
            var period = $('#' + $(element).attr('id').replace('_amount', '_period') );

            switch($(period).val()) {
                case 'M':
                    return "Monthly usage should be between 1MJ and 6,500MJ";
                case 'B':
                    return "Bimonthly usage should be between 1MJ and 14,000MJ";
                case 'Q':
                    return "Quarterly usage should be between 1MJ and 20,000MJ";
                default:
                    return "Annual usage should be between 1MJ and 85,000MJ";
            }
        })
    );

    $.validator.addMethod('validateSelectedResidentialPostCode', function(value, element) {
        var $element = $(element),
            startPostCode = $("#utilities_householdDetails_postcode").val(),
            enquiryPostCode = $element.val(),
            isValid = (startPostCode === enquiryPostCode),
            $errorFieldContainer = $("#utilities_application_details_address_error_container .error-field");

        // We only need to show one error if the suburb name has already complained, so let's only show that:
        if($errorFieldContainer.find("label[for='utilities_application_details_address_suburbName']").length)
            isValid = true;

        if(isValid)
            $errorFieldContainer.find("label[for='" + $element.attr("name") + "']").remove();

        return isValid;
    });

    $.validator.addMethod('validateSelectedResidentialSuburb', function(value, element) {
        var $element = $(element),
            startSuburb = $("#utilities_householdDetails_suburb").val(),
            enquirySuburb = $element.find("option:selected").length ? $element.find("option:selected").text() : $element.val(),
            isValid = (startSuburb === enquirySuburb),
            $errorFieldContainer = $("#utilities_application_details_address_error_container .error-field");

        if(isValid)
            $errorFieldContainer.find("label[for='" + $element.attr("name") + "']").remove();

        return isValid;
    });

    $.validator.addMethod("amountPeriodRequired", function (value, element) {

        var amount = $('#' + $(element).attr('id').replace('_period', '_amount'));
        var period = $(element);

        var amt = $.trim(amount.val());

        if (amt === '' || amt === '0' || (amount.val !== '' && period.val() !== '')) {
            return true;
        } else {
            return false;
        }

    });

    $.validator.addMethod("maximumSpend",
        function (value, e) {

            var element = $('#' + $(e).attr('id'));
            var spend = $(element).val();
            var period = $('#' + $(element).attr('id').replace('_amount', '_period'));
            var normalise;

            switch (period.val()) {
                case 'M':
                    normalise = 1;
                    break;
                case 'B':
                    normalise = 2;
                    break;
                case 'Q':
                    normalise = 3;
                    break;
                default:
                    normalise = 12;
                    break;
            }

            if (spend >= 1 && spend < (5000 * normalise)) {
                return true;
            } else {
                return false;
            }

        }, (function (value, e) {
            var element = $('#' + $(e).attr('id'));
            var period = $('#' + $(element).attr('id').replace('_amount', '_period'));
            switch (period.val()) {
                case 'M':
                    return "Monthly spend should be between $1 and $5,000";
                case 'B':
                    return "Bimonthly spend should be between $1 and $10,000";
                case 'Q':
                    return "Quartly spend should be between $1 and $15,000";
                default:
                    return "Annual spend should be between $1 and $60,000";
            }
        })
    );

    $.validator.addMethod("maximumUsage",
        function (value, e) {

            element = $('#' + $(e).attr('id'));
            var $amountElement = $(element);
            var usage = $amountElement.val();
            var minimumUsage = $amountElement.attr('id').indexOf('offpeak') === -1 ? 0 : -1;
            var period = $('#' + $amountElement.attr('id').replace('_amount', '_period'));
            var normalise;
            var valid = false;

            switch ($(period).val()) {
                case 'M':
                    if (usage === '' || (usage > minimumUsage && usage <= 7000)) {
                        valid = true;
                    }
                    break;
                case 'B':
                    if (usage === '' || (usage > minimumUsage && usage <= 14000)) {
                        valid = true;
                    }
                    break;
                case 'Q':
                    if (usage === '' || (usage > minimumUsage && usage <= 20000)) {
                        valid = true;
                    }
                    break;
                default:
                    if (usage === '' || (usage > minimumUsage && usage <= 85000)) {
                        valid = true;
                    }
                    break;
            }

            return valid;
        }, (function (value, e) {
            var element = $('#' + $(e).attr('id'));
            var period = $('#' + $(element).attr('id').replace('_amount', '_period'));

            switch ($(period).val()) {
                case 'M':
                    return "Monthly usage should be between 1kWh and 7,000kWh";
                case 'B':
                    return "Bimonthly usage should be between 1kWh and 14,000kWh";
                case 'Q':
                    return "Quarterly usage should be between 1kWh and 20,000kWh";
                default:
                    return "Annual usage should be between 1kWh and 85,000kWh";
            }
        })
    );

    $.validator.addMethod("maximumUsageGas",
        function (value, e) {

            element = $('#' + $(e).attr('id').replace('amountentry', 'amount'));
            var $amountElement = $(element);
            var usage = $amountElement.val();
            var minimumUsage = $amountElement.attr('id').indexOf('offpeak') === -1 ? 0 : -1;
            var period = $('#' + $amountElement.attr('id').replace('_amount', '_period'));
            var normalise;
            var valid = false;

            switch ($(period).val()) {
                case 'M':
                    if (usage === '' || (usage > minimumUsage && usage <= 6500)) {
                        valid = true;
                    }
                    break;
                case 'B':
                    if (usage === '' || (usage > minimumUsage && usage <= 14000)) {
                        valid = true;
                    }
                    break;
                case 'Q':
                    if (usage === '' || (usage > minimumUsage && usage <= 20000)) {
                        valid = true;
                    }
                    break;
                default:
                    if (usage === '' || (usage > minimumUsage && usage <= 85000)) {
                        valid = true;
                    }
                    break;
            }

            return valid;
        }, (function (value, e) {
            var element = $('#' + $(e).attr('id'));
            var period = $('#' + $(element).attr('id').replace('_amount', '_period'));

            switch ($(period).val()) {
                case 'M':
                    return "Monthly usage should be between 1MJ and 6,500MJ";
                case 'B':
                    return "Bimonthly usage should be between 1MJ and 14,000MJ";
                case 'Q':
                    return "Quarterly usage should be between 1MJ and 20,000MJ";
                default:
                    return "Annual usage should be between 1MJ and 85,000MJ";
            }
        })
    );

})(jQuery);
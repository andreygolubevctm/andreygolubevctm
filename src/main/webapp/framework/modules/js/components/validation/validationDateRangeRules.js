(function($) {
    var dateEURRegex = /^\d{1,2}\/\d{1,2}\/\d{2,4}$/;
    $.validator.addMethod("dateEUR", function(value, element, params) {
        if (typeof params !== 'undefined' && params.selector) {
            value = $(params.selector).val() || value;
        }

        var check = false;

        if (!dateEURRegex.test(value)) {
            check = false;
        } else {
            var adata = value.split('/');
            var d = parseInt(adata[0], 10);
            var m = parseInt(adata[1], 10);
            var y = parseInt(adata[2], 10);
            var xdata = new Date(y, m - 1, d);
            check = (xdata.getFullYear() === y || String(xdata.getFullYear()).substring(2) === y) && (xdata.getMonth() === m - 1)
            && (xdata.getDate() === d);
        }

        return (this.optional(element) !== false) || check;
    }, "Please enter a date in dd/mm/yyyy format.");

    function getDate(v) {
        var adata = v.split('/');
        return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
            parseInt(adata[0], 10));
    }

    $.validator.addMethod("earliestDateEUR", function(value, element, param) {
        return (this.optional(element) !== false)
            || getDate(value) >= getDate(param);
    }, $.validator.format("Please enter a minimum of {0}."));

    $.validator.addMethod("latestDateEUR", function(value, element, param) {
        return (this.optional(element) !== false)
            || getDate(value) <= getDate(param);
    }, $.validator.format("Please enter a maximum of {0}."));

     //
     // Validates the dropdown for mobile commencement date.
     //

     $.validator.addMethod("commencementDateMobileDropdownCheck", function (value, element) {
        return !(element.value === '' || element.value === null);
     }, "Please select a commencement date.");


    function checkDateAvailability(element, dateType) {
        var dateAttr = $(element).datepicker("option", dateType);
        var datepicker = $(element).data("datepicker");
        var datePickerDate = $.datepicker._determineDate(datepicker, dateAttr, new Date()); /* Handles dates like +1d, -3y, etc. */

        var currentDate = $(element).datepicker("getDate");

        if (dateType == 'minDate') {
            return currentDate >= datePickerDate;
        } else {
            return currentDate <= datePickerDate;
        }

    }

    $.validator.addMethod("earliestAvailableDate",
        function(value, element) {
            return checkDateAvailability(element, 'minDate');
        },
        "Custom message"
    );

    $.validator.addMethod("latestAvailableDate",
        function(value, element) {
            return checkDateAvailability(element, 'maxDate');
        },
        "Custom message"
    );

    $.validator.addMethod("notWeekends",
        function(value, element) {
            return BasicDateHandler.isNotWeekEnd( $(element).datepicker("getDate") );
        },
        "Custom message"
    );

    $.validator.addMethod("${name}notPublicHolidays",
        function(value, element) {
            //return ${name}Handler.isNotPublicHoliday( $(element).datepicker("getDate") )[0];
            return true;
        },
        "Custom message"
    );
})(jQuery);
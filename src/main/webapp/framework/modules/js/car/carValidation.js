(function ($) {
    /**
     * Validates NCD: Years driving can exceed NCD years
     */

    function getDateFullYear(v) {
        var adata = v.split('/');
        return parseInt(adata[2], 10);
    }

    $.validator.addMethod("ncdValid", function (value, element) {

        if (element.value === "")
            return false;

        var d = new Date();
        var curYear = d.getFullYear();

        var minDrivingAge = 16;
        var rgdYrs = curYear - getDateFullYear($("#quote_drivers_regular_dob").val());
        var ncdYears = value;
        var yearsDriving = rgdYrs - minDrivingAge;
        // alert("ncdYears: " + ncdYears + " yearsDriving: " + yearsDriving);
        return ncdYears <= yearsDriving;
    }, "Invalid NCD Rating based on number of years driving.");

    /**
     * Validates youngest driver minimum age
     */
    $.validator.addMethod("youngestDriverMinAge", function (value, element) {

        var minAge;
        switch (value) {
            case "H":
                minAge = 21;
                break;
            case "7":
                minAge = 25;
                break;
            case "A":
                minAge = 30;
                break;
            case "D":
                minAge = 40;
                break;
            default:
            // do nothing
        }

        var d = new Date();
        var curYear = d.getFullYear();
        var yngFullYear = getDateFullYear($("#quote_drivers_young_dob").val());
        var yngAge = curYear - yngFullYear;
        if (yngAge < minAge) {
            return (this.optional(element) !== false) || false;
        }
        return true;

    }, "Driver age restriction invalid due to youngest driver's age.");


    //
// Validates youngest drivers age with regular driver, youngest can not be older
// than regular driver
//
    $.validator.addMethod("youngRegularDriversAgeCheck", function (value, element) {
        function getDate(v) {
            var adata = v.split('/');
            return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
                parseInt(adata[0], 10));
        }

        var rgdDob = getDate($("#quote_drivers_regular_dob").val());
        var yngDob = getDate(value);

        // Rgd must be older than YngDrv
        if (yngDob < rgdDob) {
            return (this.optional(element) !== false) || false;
        }
        return true;
    }, "Youngest driver should not be older than the regular driver.");



    //
// Validates youngest drivers annual kilometers with the car details kilometers per year
// Youngest cannot exceed the car details kilometers.
//
    $.validator.addMethod("youngRegularDriversAnnualKilometersCheck", function () {

        var vehicleAnnualKms = parseInt($('#quote_vehicle_annualKilometres').val().replace(/\D/g, ''));
        var youngestAnnualKms = parseInt($('#quote_drivers_young_annualKilometres').val().replace(/\D/g, ''));
        return youngestAnnualKms < vehicleAnnualKms;
    }, "The annual kilometres driven by the youngest driver cannot exceed those of the regular driver.");


})(jQuery);



//
// Validates age licence obtained for regular driver
//
$.validator.addMethod("ageLicenceObtained", function (value, element) {

    var driver;
    switch (element.name) {
        case "quote_drivers_regular_licenceAge":
            driver = "#quote_drivers_regular_dob";
            break;
        case "quote_drivers_young_licenceAge":
            driver = "#quote_drivers_young_dob";
            break;
        default:
            return false;
    }

    function getDateFullYear(v) {
        var adata = v.split('/');
        return parseInt(adata[2], 10);
    }

    var d = new Date();
    var curYear = d.getFullYear();
    var driverFullYear = getDateFullYear($(driver).val());
    var driverAge = curYear - driverFullYear;
    if (this.optional(element) === false) {
        if (!isNaN(driverFullYear)) {
            if (isNaN(driverAge) || value < 16 || value > driverAge) {
                return false;
            }
        } else if (value < 16) {
            return false;
        }
    }
    return true;

}, "Age licence obtained invalid due to driver's age.");


//
// Validates OK to call which ensure we have a phone number if they select yes
//
$.validator.addMethod("okToCall", function () {
    return !($('input[name="quote_contact_oktocall"]:checked').val() == "Y"
    && $('input[name="quote_contact_phone"]').val() === "");

}, "");

//
//Validates OK to email which ensure we have a email address if they select yes
//
$.validator.addMethod("marketing", function () {
    if ($('input[name="quote_contact_marketing"]:checked').val() === "Y"
        && $('input[name="quote_contact_email"]').val() === "") {
        return false;
    } else {
        $('input[name="quote_contact_email"]').parent().removeClass('state-right state-error');
        return true;
    }

}, "");

$.validator.addMethod('validateOkToCall', function (value, element) {
    var optin = ($("#quote_contactFieldSet input[name='quote_contact_oktocall']:checked").val() === 'Y');
    var phone = $('#quote_contact_phone').val();
    if (optin === true && _.isEmpty(phone)) {
        return false;
    }
    return true;
});

$.validator.addMethod('validateOkToCallRadio', function (value, element) {
    var $optin = $("#quote_contactFieldSet input[name='quote_contact_oktocall']:checked");
    var noOptin = $optin.length === 0;
    var phone = $('#quote_contact_phone').val();
    if (!_.isEmpty(phone) && noOptin === true) {
        return false;
    }
    return true;
});
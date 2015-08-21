



//
// Validates NCD: Years driving can exceed NCD years
//
$.validator.addMethod("ncdValid", function(value, element) {

    if (element.value === "")
        return false;

    function getDateFullYear(v) {
        var adata = v.split('/');
        return parseInt(adata[2], 10);
    }

    // TODO: Get date from server and not client side
    var d = new Date();
    var curYear = d.getFullYear();

    var minDrivingAge = 16;
    var rgdYrs = curYear
        - getDateFullYear($("#quote_drivers_regular_dob").val());
    var ncdYears = value;
    var yearsDriving = rgdYrs - minDrivingAge;
    // alert("ncdYears: " + ncdYears + " yearsDriving: " + yearsDriving);
    return ncdYears <= yearsDriving;

}, "Invalid NCD Rating based on number of years driving.");

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

    var vehicleAnnualKms = parseInt($('#quote_vehicle_annualKilometres').val().replace(/\D/g,''));
    var youngestAnnualKms = parseInt($('#quote_drivers_young_annualKilometres').val().replace(/\D/g,''));

    return youngestAnnualKms < vehicleAnnualKms;
}, "The annual kilometres driven by the youngest driver cannot exceed those of the regular driver.");


//
// Validates...
//
$.validator.addMethod("allowedDrivers", function (value) {

    var allowDate = false;

    function getDateFullYear(v) {
        var adata = v.split('/');
        return parseInt(adata[2], 10);
    }
    function getDateMonth(v) {
        var adata = v.split('/');
        return parseInt(adata[1], 10) - 1;
    }
    function getDate(v) {
        var adata = v.split('/');
        return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
            parseInt(adata[0], 10));
    }

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

    // TODO: Get date from server and not client side
    var d = new Date();
    var curYear = d.getFullYear();
    var curMonth = d.getMonth();
    var dobValue = $("#quote_drivers_regular_dob").val();
    var rgdDOB = getDate(dobValue);
    var rgdFullYear = getDateFullYear(dobValue);
    var rgdMonth = getDateMonth(dobValue);
    var rgdYrs = curYear - rgdFullYear;

    // Check AlwDrv allows Rgd
    if (rgdYrs < minAge) {
    } else if (rgdYrs == minAge) {
        if ((rgdFullYear + minAge) == curYear) {
            if (rgdMonth < curMonth) {
                allowDate = true;
            } else if (rgdMonth == curMonth) {
                if (rgdDOB <= d) {
                    allowDate = true;
                }
            }
        }
    } else {
        allowDate = true;
    }

    return allowDate;

}, "Driver age restriction invalid due to regular driver's age.");

//
// Validates youngest driver minimum age
//
$.validator.addMethod("youngestDriverMinAge", function (value, element) {

    function getDateFullYear(v) {
        var adata = v.split('/');
        return parseInt(adata[2], 10);
    }

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

    // TODO: Get date from server and not client side
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
    if(this.optional(element) === false) {
        if(!isNaN(driverFullYear) ) {
            if (isNaN(driverAge) || value < 16 || value > driverAge) {
                return false;
            }
        } else if(value < 16) {
            return false;
        }
    }
    return true;

}, "Age licence obtained invalid due to driver's age.");


//
// Validates OK to call which ensure we have a phone number if they select yes
//
$.validator.addMethod("okToCall", function() {
    return !($('input[name="quote_contact_oktocall"]:checked').val() == "Y"
    && $('input[name="quote_contact_phone"]').val() === "");

}, "");

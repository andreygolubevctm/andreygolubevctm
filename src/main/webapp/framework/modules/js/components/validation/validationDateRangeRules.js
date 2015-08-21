$.validator.addMethod("dateEUR", function(value, element, params) {
    if (typeof params !== 'undefined' && params.selector) {
        value = $(params.selector).val() || value;
    }

    var check = false;
    var re = /^\d{1,2}\/\d{1,2}\/\d{2,4}$/;
    if (!re.test(value)) {
        check = false;
    } else {
        var adata = value.split('/');
        var d = parseInt(adata[0], 10);
        var m = parseInt(adata[1], 10);
        var y = parseInt(adata[2], 10);
        var xdata = new Date(y, m - 1, d);
        check = (xdata.getFullYear() == y) && (xdata.getMonth() == m - 1)
        && (xdata.getDate() == d);
    }

    return (this.optional(element) != false) || check;
}, "Please enter a date in dd/mm/yyyy format.");

$.validator.addMethod("dateOfBirthEUR", function(value, element, params) {

    if (typeof params !== 'undefined' && params.selector) {
        value = $(params.selector).val() || value;
    }

    var check = false;
    var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
    if (!re.test(value)) {
        check = false;
    } else {
        var adata = value.split('/');
        var d = parseInt(adata[0], 10);
        var m = parseInt(adata[1], 10);
        var y = parseInt(adata[2], 10);
        var xdata = new Date(y, m - 1, d);
        check = (xdata.getFullYear() == y || String(xdata.getFullYear()).substring(2) == y) && (xdata.getMonth() == m - 1)
        && (xdata.getDate() == d);
    }

    return (this.optional(element) != false) || check;
}, "Please enter a date in dd/mm/yyyy format.");

$.validator.addMethod("minDateEUR", function(value, element, param) {
    function getDate(v) {
        var adata = v.split('/');
        return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
            parseInt(adata[0], 10));
    }
    return (this.optional(element) != false)
        || getDate(value) >= getDate(param);
}, $.validator.format("Please enter a minimum of {0}."));

$.validator.addMethod("maxDateEUR", function(value, element, param) {
    function getDate(v) {
        var adata = v.split('/');
        return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
            parseInt(adata[0], 10));
    }
    return (this.optional(element) != false)
        || getDate(value) <= getDate(param);
}, $.validator.format("Please enter a maximum of {0}."));




$.validator.addMethod('min_DateOfBirth', function(value, element, params) {
    if (typeof params === 'undefined' || !params.hasOwnProperty('ageMin')) return false;

    if (params.selector) {
        value = $(params.selector).val() || value;
    }
    var now = new Date();
    var temp = value.split('/');

    if(String(parseInt(temp[2], 10)).length === 4) {

        var minDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- params.ageMin) );

        if (minDate > now) {
            return false;
        }
    }

    return true;
});

$.validator.addMethod('max_DateOfBirth', function(value, element, params) {
    if (typeof params === 'undefined' || !params.hasOwnProperty('ageMax')) return false;

    if (params.selector) {
        value = $(params.selector).val() || value;
    }
    var now = new Date();
    var temp = value.split('/');

    if(String(parseInt(temp[2], 10)).length === 4) {

        var maxDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- params.ageMax) );

        if (maxDate < now) {
            return false;
        }
    }

    return true;
});


//
// Validates the dropdown for mobile commencement date.
//
$.validator.addMethod("commencementDateMobileDropdownCheck", function (value, element) {
    return !(element.value == '' || element.value == null);
}, "Please select a commencement date.");

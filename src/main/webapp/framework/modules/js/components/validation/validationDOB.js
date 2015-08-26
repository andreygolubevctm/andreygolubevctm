(function($) {
    function checkDob(value, age, selector) {
        if (selector) {
            value = $(selector).val() || value;
        }
        var now = new Date();
        var temp = value.split('/');
        if(String(parseInt(temp[2], 10)).length === 4) {
            var splitAge = age.split('.');
            // this is because the variable passed into the param age is dynamically set by health via js
            var ageDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- window[splitAge[0]][splitAge[1]]) );

            if (ageDate > now) {
                return false;
            }
        }
        return true;
    }

    $.validator.addMethod('youngestDOB', function(value, element, params) {
        if (typeof params == 'undefined' || !params.hasOwnProperty('ageMin')) return false;
        return checkDob(value, params.ageMin, params.selector);
    });

    $.validator.addMethod('oldestDOB', function(value, element, params) {
        if (typeof params == 'undefined' || !params.hasOwnProperty('ageMax')) return false;
        return !checkDob(value,  params.ageMax, params.selector);
    });

})(jQuery);
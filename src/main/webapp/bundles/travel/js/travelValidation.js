(function($) {
    date_gt_date = function (date1, date2){

        // Parse dates first
        d1 = date1.split('/');
        d2 = date2.split('/');

        // Prepend leading zeros
        for(var i=0;i<3;i++){
            if(parseInt(d1[i])<10 && d1[i].indexOf('0')==-1) d1[i]='0'+d1[i];
            if(parseInt(d2[i])<10 && d2[i].indexOf('0')==-1) d2[i]='0'+d2[i];
        }

        // Return true if Date 2 >= Date 1
        var datenum1 = parseInt(d1[2]+d1[1]+d1[0]);
        var datenum2 = parseInt(d2[2]+d2[1]+d2[0]);

        return datenum2 <= datenum1;
    };

    $.validator.addMethod("fromToDate", function(value, element, params){
        if (typeof params === 'undefined' || (!params.hasOwnProperty('toDate') && !params.hasOwnProperty('fromDate'))) return false;
        var fromDateVal = $('#'+params.fromDate).val();
        var toDateVal = $('#'+params.toDate).val();

        if (fromDateVal !== '' && toDateVal !== '')
        {
            return date_gt_date(toDateVal, fromDateVal);
        }

        return true;
    });

    // Validate age range 16-99
    $.validator.addMethod("ageRange",
        function(value, element){
            if(parseInt(value) >= 16 && parseInt(value) < 100){
                return true;
            }
        },
        "Adult${validationNoun}s must be aged 16 - 99."
    );
})(jQuery);
$.validator.addMethod("min_dob_${name}",
    function(value, element) {

        var now = new Date();
        var temp = value.split('/');
        var minDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- dob_${name}.ageMin) ); <%-- ("MM/DD/YYYY") x-browser --%>

        //min Age check for fail
        if( minDate > now  ){
            return false;
        };

        return true;
    }
);

$.validator.addMethod("max_dob_${name}",
    function(value, element) {

        var now = new Date();
        var temp = value.split('/');
        var maxDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- dob_${name}.ageMax) ); <%-- ("MM/DD/YYYY") x-browser --%>

        //max Age check for fail
        if( maxDate < now ){
            return false;
        };

        return true;
    }
);

$.validator.addMethod("validateAge",
    function(value, element) {
        var getAge = function(dob) {
            var dob_pieces = dob.split("/");
            var year = Number(dob_pieces[2]);
            var month = Number(dob_pieces[1]) - 1;
            var day = Number(dob_pieces[0]);
            var today = new Date();
            var age = today.getFullYear() - year;
            if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day))
            {
                age--;
            }
        }

        var age = getAge( value );

        if( age < 18 || age > 65 )
        {
            return false;
        }

        return true;
    },
    "Replace this message with something else"
);
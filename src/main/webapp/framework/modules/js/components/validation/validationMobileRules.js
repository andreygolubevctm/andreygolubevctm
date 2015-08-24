$.validator.addMethod("notMobile",
    function(value, element) {
        if($(element).val().substring(0,2) == '04'){
            return false;
        } else {
            return true;
        };

    },
    "Custom message"
);
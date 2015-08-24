// similar to the validatePasswordLength at the bottom
$.validator.addMethod("validateMinPasswordLength",
    function(value, element) {
        return String(value).length >= ${minLength};
    },
    "Replace this message with something else"
);

$.validator.addMethod("validateMobileField",
    function(value, element) {
        var mobileField = $('#${name}_mobileNumber');
        var phoneField = $('#${name}_otherPhoneNumberinput');

        $("#${name}_mobileNumberinput, #${name}_otherPhoneNumberinput").on("change", function(){
            $("#${name}_mobileNumberinput, #${name}_otherPhoneNumberinput").valid();
        });

        mobileField.val( String($(element).val()).replace(/[^0-9]/g, '') );

        var mobile = mobileField.val();
        var phone = phoneField.val();

        if(mobile != '' && mobile.substring(0,2) == '04'){
            return true;
        } else {
            return phone != '';
        };

    },
    "Custom message"
);

$.validator.addMethod('validateMatchingPassword', function(value, element) {
    return $("#reset_password").val() === $("#reset_confirm").val();
});

// similar to validateMinPasswordLength at the top
$.validator.addMethod('validatePasswordLength', function(value, element) {
    return (value.length >= 6);
});
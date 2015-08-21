$.validator.addMethod('validateOkToEmail', function(value, element) {
    var optin = ($("#quote_contactFieldSet input[name='quote_contact_marketing']:checked").val() === 'Y');
    var email = $('#quote_contact_email').val();
    if(optin === true && _.isEmpty(email)) {
        return false;
    }
    return true;
});

$.validator.addMethod('validateOkToCallRadio', function(value, element) {
    var $optin	= $("#quote_contactFieldSet input[name='quote_contact_oktocall']:checked");
    var noOptin = $optin.length === 0;
    var phone = $('#quote_contact_phone').val();
    if(!_.isEmpty(phone) && noOptin === true) {
        return false;
    }
    return true;
});
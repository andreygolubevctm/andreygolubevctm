;(function ($) {

    //$.validator.addMethod('validateOkToEmailRadio', function(value, element, param) {
    //    var $optin = $("#quote_contactFieldSet input[name='quote_contact_marketing']:checked");
    //    var noOptin = $optin.length === 0;
    //    var email = $('#quote_contact_email').val();
    //    if(!_.isEmpty(email) && noOptin) {
    //        return false;
    //    }
    //    return true;
    //}, "Please choose if OK to email");

    $.validator.addMethod('validateInsuranceAmount', function(value, element, param) {
       return true;
    }, 'Please specify a cover amount');

})(jQuery);
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
        var $this = $(element);
        $this.val($this.val().replace(/[^0-9]/g, ''));

        var $parentInputs = $this.parents('.insuranceAmountContainer').find('input');
        var hasRelatedFieldFilled = false;

        $parentInputs.each(function() {
            var $current = $(this);
            if($current.val() && $this.attr('id') !== $current.attr('id')) {
                hasRelatedFieldFilled = true;
                return false;
            }
        });

        if(($this.val() && $this.val() != 0) || hasRelatedFieldFilled) {
            return true;
        }

        return false;
    }, 'Please specify a cover amount in dollar format');

})(jQuery);
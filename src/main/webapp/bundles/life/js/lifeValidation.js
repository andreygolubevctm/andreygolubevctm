;(function ($) {

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
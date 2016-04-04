;(function ($) {
    $.validator.addMethod('validateBenefitAmount', function(value, element, param) {
        var $this = $(element);
        var $income = $('#ip_primary_insurance_income');

        return (Number($income.val()) * 0.75 / 12) >= Number($this.val()) ;
    }, 'Your benefit amount must be a monthly calculation of 75% of your gross annual income');
})(jQuery);
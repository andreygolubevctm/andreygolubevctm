(function ($) {
    $.validator.addMethod('medicareCardColour', function (value, element) {
        return (value !== 'none');
    }, "To proceed with this policy, you must have a green, blue or yellow medicare card. For overseas visitor cover, please <a class='black' href='https://ctm.livepro.com.au/goto/ovc-to-au-transfer\n' target=\'_blank\'>click here</a>.");

})(jQuery);

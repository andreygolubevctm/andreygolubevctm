(function ($) {
    function init () {
        $('.dropdown-menu').click(function(e) {
            e.stopPropagation();
        });



        $('input[name="radio-group"]').change(function () {
           $('.selected-excess-value').text($(this).val());
        });
    }

    meerkat.modules.register("travelResultFilters", {
        init: init
    });
})(jQuery);
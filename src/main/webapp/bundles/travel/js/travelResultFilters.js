(function ($) {
    function init () {
        $('.dropdown-menu').click(function(e) {
            e.stopPropagation();
        });

        $('input[name="radio-group"]').change(function () {
           $('.selected-excess-value').text($(this).val());
        });

        $('input[name="luggageRangeSlider"]').change(function () {
           $('.luggage-range-value').empty().text('$' + Number($(this).val()).toLocaleString('en'));
        });

        $('input[name="cancellationRangeSlider"]').change(function () {
            $('.cancellation-range-value').empty().text('$' + Number($(this).val()).toLocaleString('en'));
        });

        $('input[name="overseasMedicalRangeSlider"]').change(function () {
            $('.overseas-medical-range-value').empty().text('$' + Number($(this).val()).toLocaleString('en'));
        });

        $('.dropdown').on('show.bs.dropdown', function () {
            $(this).find(".icon").removeClass("icon-angle-down").addClass("icon-angle-up");
        });

        $('.dropdown').on('hide.bs.dropdown', function () {
            $(this).find(".icon").removeClass("icon-angle-up").addClass("icon-angle-down");
        });
    }

    meerkat.modules.register("travelResultFilters", {
        init: init
    });
})(jQuery);
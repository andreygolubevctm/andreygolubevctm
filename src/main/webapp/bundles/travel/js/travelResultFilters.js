(function ($) {
    function init () {

        // close dropdown only if outside is clicked
        $('.dropdown-menu').click(function(e) {
            e.stopPropagation();
        });

        // update the excess header when any of the excess option is selected
        $('input[name="radio-group"]').change(function () {
           $('.selected-excess-value').text($(this).val());
            _updateTravelResults('EXCESS', parseInt($(this).data('excess')));
        });

        // update the luggage cover when the slider is moved
        $('input[name="luggageRangeSlider"]').change(function () {
           $('.luggage-range-value').empty().text('$' + Number($(this).val()).toLocaleString('en'));
            _updateTravelResults('LUGGAGE', parseInt($(this).val()));
        });

        // update the cancellation cover when the slider is moved
        $('input[name="cancellationRangeSlider"]').change(function () {
            $('.cancellation-range-value').empty().text('$' + Number($(this).val()).toLocaleString('en'));
        });

        // update the overseas medical cover when the slider is moved
        $('input[name="overseasMedicalRangeSlider"]').change(function () {
            $('.overseas-medical-range-value').empty().text('$' + Number($(this).val()).toLocaleString('en'));
        });

        // show up arrow when the dropdown is shown
        $('.dropdown').on('show.bs.dropdown', function () {
            $(this).find(".icon").removeClass("icon-angle-down").addClass("icon-angle-up");
        });

        // show down arrow when the dropdown is hidden
        $('.dropdown').on('hide.bs.dropdown', function () {
            $(this).find(".icon").removeClass("icon-angle-up").addClass("icon-angle-down");
        });
    }

    function _updateTravelResults (filter, value) {
        var _filters = Results.model.travelFilters;

        switch (filter) {
            case 'EXCESS':
                _filters.EXCESS = value;
                break;
            case 'LUGGAGE':
                _filters.LUGGAGE = value;
                break;
            case 'CXDFEE':
                _filters.CXDFEE = value;
                break;
            case 'MEDICAL':
                _filters.MEDICAL = value;
                break;
        }
        Results.model.travelFilters = _filters;
        Results.model.travelResultFilter(true, true);
    }

    meerkat.modules.register("travelResultFilters", {
        init: init
    });
})(jQuery);
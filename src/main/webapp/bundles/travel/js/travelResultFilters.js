(function ($) {
    function init () {
        $('.dropdown-menu').click(function(e) {
            e.stopPropagation();
        });
    }

    meerkat.modules.register("travelResultFilters", {
        init: init
    });
})(jQuery);
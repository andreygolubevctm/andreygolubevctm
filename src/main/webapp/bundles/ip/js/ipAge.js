;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    function initIPAge() {
        _initEventListeners();
    }

    function _initEventListeners() {
        $('.dateinput_container input')
            .on('blur', function() {
                var $container = $(this).parents('.dateinput_container');

                $container.find('input[id$="dobInput"]').each(function() {
                    var $this = $(this);
                    var val = $this.val();

                    if(!!val) {
                        var dob_pieces = val.split("-");
                        var day = Number(dob_pieces[2]);
                        var month = Number(dob_pieces[1]);
                        var year = Number(dob_pieces[0]);

                        var age = meerkat.modules.age.get(day, month, year);
                        $this.parents('.row').find('input[id$="_age"]').val(age);
                    }
                });
            })
            .trigger('blur');
    }

    meerkat.modules.register("ipAge", {
        init: initIPAge,
        events: events
    });
})(jQuery);
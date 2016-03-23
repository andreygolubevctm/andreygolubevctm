;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    function initLifeAge() {
        _initEventListeners();
    }

    function _initEventListeners() {
        $('.dateinput_container input')
            .on('blur', function() {
                var $container = $(this).parents('.dateinput_container');

                $container.find('input[id$="dobInput"]').each(function() {
                    var $this = $(this);
                    var val;

                    if(!!val) {
                        var dob_pieces = $this.val().split("/");
                        var day = Number(dob_pieces[0]);
                        var month = Number(dob_pieces[1]) - 1;
                        var year = Number(dob_pieces[2]);

                        var age = meerkat.modules.age.getNextBirthday(day, month, year);
                        $this.next('input[id$="_age"]').val(age);
                    }
                });
            })
            .trigger('blur');
    }

    meerkat.modules.register("lifeAge", {
        init: initLifeAge,
        events: events
    });
})(jQuery);
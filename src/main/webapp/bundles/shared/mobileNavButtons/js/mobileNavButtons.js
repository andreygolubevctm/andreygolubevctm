;(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var $buttons,
        $editDetailsBtn;

    function init() {
        $buttons = $('.mobile-nav-buttons');
        $editDetailsBtn = $buttons.find('.edit-details a');

        eventSubscriptions();
    }

    function eventSubscriptions() {
        // Disable mobile nav buttons while results are in progress
        $(document).on('resultsFetchStart', function onResultsFetchStart() {
            disable();
        });

        $(document).on('resultsFetchFinish', function onResultsFetchFinish() {
            enable();
        });

        $editDetailsBtn.on('click', function(e) {
            e.preventDefault();

            if (!$(this).hasClass('disabled')) {
                meerkat.modules.carEditDetails.show();
            }
        });
    }

    function disable() {
        $buttons.addClass('disabled');
        $buttons.find('a').addClass('disabled');
    }

    function enable() {
        $buttons.removeClass('disabled');
        $buttons.find('a').removeClass('disabled');
    }

    meerkat.modules.register('mobileNavButtons', {
        init: init,
        disable: disable
    });
})(jQuery);
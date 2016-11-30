;(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,

        events = {
            mobileNavButtons: {
                REFINE_RESULTS_TOGGLED: 'REFINE_RESULTS_TOGGLED',
                EDIT_DETAILS_TOGGLED: 'EDIT_DETAILS_TOGGLED'
            }
        },
        moduleEvents = events.mobileNavButtons,

        $buttons,
        $refineResults,
        $saveQuote,
        $editDetailsBtn;

    function init() {
        $buttons = $('.mobile-nav-buttons');
        $refineResults = $buttons.find('.refine-results a');
        $saveQuote = $buttons.find('.save-quote a');
        $editDetailsBtn = $buttons.find('.edit-details a');

        applyEventListeners();
        eventSubscriptions();
    }

    function applyEventListeners() {
        $refineResults.on('click', function(e) {
            e.preventDefault();

            if (!$(this).hasClass('disabled')) {
                meerkat.messaging.publish(moduleEvents.REFINE_RESULTS_TOGGLED);
            }
        });

        $editDetailsBtn.on('click', function(e) {
            e.preventDefault();

            if (!$(this).hasClass('disabled')) {
                meerkat.messaging.publish(moduleEvents.EDIT_DETAILS_TOGGLED);
            }
        });
    }

    function eventSubscriptions() {
        // Disable mobile nav buttons while results are in progress
        $(document).on('resultsFetchStart', function onResultsFetchStart() {
            disable();
        });

        $(document).on('resultsFetchFinish', function onResultsFetchFinish() {
            enable();
        });
    }

    function disable() {
        $buttons.addClass('disabled');
        $buttons.find('a').addClass('disabled');
    }

    function disableSpecificButtons(list) {
        var arr = list.split(',');

        arr.forEach(function (btnClass) {
            switch (btnClass) {
                case 'refine':
                    $refineResults.addClass('disabled');
                    break;
                case 'save':
                    $saveQuote.addClass('disabled');
                    break;
            }
        });
    }

    function enable() {
        $buttons.removeClass('disabled');
        $buttons.find('a').removeClass('disabled');
    }

    meerkat.modules.register('mobileNavButtons', {
        init: init,
        events: events,
        disable: disable,
        disableSpecificButtons: disableSpecificButtons
    });
})(jQuery);
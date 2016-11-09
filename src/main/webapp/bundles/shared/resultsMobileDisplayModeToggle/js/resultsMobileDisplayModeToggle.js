;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $body,
        $component,
        $resultsCount,
        $button,
        displayMode = 'price';

    var moduleEvents = {
        resultsMobileDisplayModeToggle : {
            DISPLAY_MODE_UPDATED: "DISPLAY_MODE_UPDATED",
            DISPLAY_MODE_CHANGED: "DISPLAY_MODE_CHANGED"
        }
    };

    function initToggle() {
        $body = $('body');
        $component = $('.results-mobile-display-mode-toggle');
        $resultsCount = $component.find('.results-mobile-display-mode-count');
        $button = $component.find('.results-mobile-display-mode-button');

        eventSubscriptions();
    }

    function eventSubscriptions() {
        // hide component while results are in progress
        $(document).on('resultsFetchStart', function onResultsFetchStart() {
            hide();
        });

        // set component properties once results are loaded
        $(document).on("resultsLoaded", function() {
            if (Results.model.availableCounts > 0) {
                setCount(Results.model.availableCounts);
                setDisplayMode(Results.getDisplayMode());
                show();
            }
        });

        $button.on('click', function() {
            setDisplayMode(displayMode === 'price' ? 'features' : 'price');

            meerkat.messaging.publish(moduleEvents.resultsMobileDisplayModeToggle.DISPLAY_MODE_CHANGED, { displayMode: displayMode });
        });

        meerkat.messaging.subscribe(moduleEvents.resultsMobileDisplayModeToggle.DISPLAY_MODE_UPDATED, function() {
            setDisplayMode(Results.getDisplayMode());
        });
    }

    // set results available count
    function setCount(count) {
        $resultsCount.text(count);
    }

    // set the display mode
    function setDisplayMode(mode) {
        displayMode = mode;
        $component.attr('data-display-mode', displayMode);
    }

    // hide component
    function hide() {
        $component.addClass('hidden');
        $body.removeClass('results-mobile-display-mode-toggle-shown');
    }

    // show component
    function show() {
        $component.removeClass('hidden');
        $body.addClass('results-mobile-display-mode-toggle-shown');
    }

    meerkat.modules.register('resultsMobileDisplayModeToggle', {
        initToggle: initToggle,
        events: moduleEvents
    });

})(jQuery);
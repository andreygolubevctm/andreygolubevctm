;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var events = {
        travelPopularDestinations: {}
    };

    function initTravelPopularDestinations() {
        eventSubscriptions();
        setTimeout(function () {
            initTravelDropDown();
        }, 750);

    }

    function eventSubscriptions() {

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_REMOVED, function onSelectedTagRemove(isoCode) {
            toggleSelectedIcon(isoCode, false);
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_ADDED, function onSelectedTagAdd(isoCode) {
            toggleSelectedIcon(isoCode, true);
        });
    }

    function toggleSelectedIcon(isoCode, state) {
        $('#destinations-list').find('a.destination-item').filter(function filterByIsoCode() {
            return $(this).data('country').isoCode === isoCode;
        }).toggleClass('active', state);
    }

    meerkat.modules.register("travelPopularDestinations", {
        initTravelPopularDestinations: initTravelPopularDestinations,
        events: events
    });

})(jQuery);

function initTravelDropDown() {
    var $destinationsfs = $('#destinationsfs'),
        $travelDestinations = $('#travel_destinations'),
        $destinationsPopover = $('#destinations-popover'),
        $destinationsList = $('#destinations-list'),
        $fromTravelDates = $('#travel_dates_fromDateInputD, #travel_dates_fromDateInputM, #travel_dates_fromDateInputY');

    function applyTravelDestinationDisplayListeners(api) {
        $travelDestinations.on('keyup', function (e) {
            hidePopover(e, api);
        });

        $fromTravelDates.on('focus', function (e) {
            hidePopover(e, api);
        });
    }

    function hidePopover(e, api) {
        e.preventDefault();
        if (api.elements.tooltip.is(':visible')) {
            api.toggle(false);
        }
    }

    function applyTravelDestinationClickListener() {
        $destinationsList.find('a.destination-item').on('click', function onTravelDestinationClick() {
            var $this = $(this),
                country = $this.data('country');

            if ($this.hasClass('active')) {
                // Remove country from selected-tags list
                $destinationsfs.find('.selected-tag').filter(function filterByIsoCode() {
                    return country.isoCode === $(this).data('value');
                }).find('button').trigger('click');
            } else {
                $travelDestinations.trigger('typeahead:selected', country);
            }
            $this.toggleClass('active');
        });
    }

    $travelDestinations.qtip({
        content: {
            text: $destinationsPopover,
            button: 'Close'
        },
        show: 'click',
        hide: 'unfocus',
        position: {
            my: 'top left',
            at: 'bottom left'
        },
        style: {
            classes: 'qtip-bootstrap travelDestinationPopover',
            tip: {
                width: 14,
                height: 12,
                mimic: 'center'
            }
        },
        events: {
            render: function (event, api) {
                $destinationsPopover.removeClass('hide');
                applyTravelDestinationClickListener();
                applyTravelDestinationDisplayListeners(api);
            }
        }
    });

    $destinationsfs.find('ul.selected-tags').on('DOMSubtreeModified', function () {
        if (typeof $travelDestinations.qtip === 'function' && typeof $travelDestinations.qtip().reposition === 'function') {
            $travelDestinations.qtip().reposition();
        }
    });

};

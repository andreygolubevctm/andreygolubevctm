;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var events = {
        travelPopularDestinations: {}
    };

    var $destinationsfs,
        $travelDestinations,
        $destinationsPopover,
        $destinationsList;

    function initTravelPopularDestinations() {
        var data = {};
        $destinationsfs = $('#destinationsfs');
        $travelDestinations = $('#travel_destinations');
        $destinationsPopover = $('#destinations-popover');
        $destinationsList = $('#destinations-list');
        initTravelPopover();
        eventSubscriptions();
    }

    function eventSubscriptions() {

        $destinationsfs.find('ul.selected-tags').on('DOMSubtreeModified', function () {
            $travelDestinations.qtip().reposition();
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_REMOVED, function onSelectedTagRemove(isoCode) {
            toggleSelectedIcon(isoCode, false);
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_ADDED, function onSelectedTagAdd(isoCode) {
            toggleSelectedIcon(isoCode, true);
        });
    }

    function initTravelPopover() {
        if (meerkat.modules.deviceMediaState.get() !== 'xs') {
            $(window).on('load', function () {
                $travelDestinations.qtip({
                    prerender: true,
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
                            toggleTravelSelectionDisplay(api);
                        }
                    }
                });
            });
        }
    }

    function toggleTravelSelectionDisplay(api) {
        $travelDestinations.on('keyup', function (e) {
            e.preventDefault();
            if (api.elements.tooltip.is(':visible')) {
                api.toggle(false);
            }
        });
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

    function toggleSelectedIcon(isoCode, state) {
        $destinationsList.find('a.destination-item').filter(function filterByIsoCode() {
            return $(this).data('country').isoCode === isoCode;
        }).toggleClass('active', state);
    }

    meerkat.modules.register("travelPopularDestinations", {
        initTravelPopularDestinations: initTravelPopularDestinations,
        events: events
    });

})(jQuery);
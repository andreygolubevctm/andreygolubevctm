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
        $destinationsList,
        $travel_policyType_S,
        $fromTravelDates;

    function initTravelPopularDestinations() {
        var data = {};
        $destinationsfs = $('#destinationsfs');
        $travelDestinations = $('#travel_destinations');
        $destinationsPopover = $('#destinations-popover');
        $destinationsList = $('#destinations-list');
        $travel_policyType_S = $('#travel_policyType_S');
        $fromTravelDates = $('#travel_dates_fromDateInputD, #travel_dates_fromDateInputM, #travel_dates_fromDateInputY');
        initTravelPopularDestPopover();
        eventSubscriptions();
    }

    function eventSubscriptions() {

        $destinationsfs.find('ul.selected-tags').on('DOMSubtreeModified', function () {
          if (typeof $travelDestinations.qtip === 'function' && typeof $travelDestinations.qtip().reposition === 'function') {
            $travelDestinations.qtip().reposition();
          }
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_REMOVED, function onSelectedTagRemove(isoCode) {
            toggleSelectedIcon(isoCode, false);
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_ADDED, function onSelectedTagAdd(isoCode) {
            toggleSelectedIcon(isoCode, true);
        });
    }

    function initTravelPopularDestPopover() {
        if (meerkat.modules.deviceMediaState.get() !== 'xs') {
            $(window).on('load', function () {
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

                if (meerkat.modules.journeyEngine.getCurrentStepIndex() === 0 && $destinationsfs.is(':visible') && $travel_policyType_S.prop('checked')) {
                    showTravelPopularDestPopover();
                }
            });

            // Show TravelPopularDestPopover when Single Trip is clicked
            $travel_policyType_S.on('click', function () {
                showTravelPopularDestPopover();
            });
        }
    }

    function showTravelPopularDestPopover() {
        $travelDestinations.focus();
        setTimeout(function() {
            if ($travel_policyType_S.parent().hasClass('active')) {
                $travelDestinations.qtip('toggle', true);
            }
        }, 750);
    }

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
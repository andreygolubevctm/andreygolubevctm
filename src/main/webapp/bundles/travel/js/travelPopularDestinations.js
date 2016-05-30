;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var events = {
        travelPopularDestinations: {}
    };

    var $destinationsfs,
        $travelDestinations;

    function initTravelPopularDestinations() {

        if(meerkat.modules.splitTest.isActive(99) !== true) { return; }

        var data = {};
        $destinationsfs = $('#destinationsfs');
        $travelDestinations = $('#travel_destinations');

        if(meerkat.site.isDev === true) {
            // need to wait for the development.deferred module to be initialised
            // then wait for the ajax call there to get all available service URL
            // IE8-10 is not working because for some reason the promise doesn't get set until 10 secs later

            meerkat.modules.utils.pluginReady("development").done(function() {
                meerkat.modules.development.getAggregationServicePromise().done(function() {
                    data.environmentOverride = $("#developmentAggregatorEnvironment").val();
                    getPopularCountriesList(data);
                });
            });

            return;
        }
        getPopularCountriesList(data);
    }

    function getPopularCountriesList(data) {
        meerkat.modules.comms.get({
            url: "spring/rest/travel/popularDestinations/list.json",
            data: data,
            cache: true,
            errorLevel: "warning",
            dataType: 'json'
        })
        .done(function onSuccess(json) {
            var popularCountriesTemplate = _.template($("#travel-popular-countries-template").html());
            $destinationsfs.find('.content').prepend(popularCountriesTemplate(json));
            eventSubscriptions();
        })
        .fail(function onError(obj, txt, errorThrown) {
            exception(txt + ': ' + errorThrown);
        });
    }

    function eventSubscriptions() {
        $destinationsfs.find('.popular-countries-container a').on('click', function onPopularCountryClick() {
            var $this = $(this),
                country = $this.data('country');

            if ($this.hasClass('active')) {
                $destinationsfs.find('.selected-tag').filter(function filterByIsoCode() {
                    return country.isoCode === $(this).data('value');
                }).find('button').trigger('click');
            } else {
                $travelDestinations.trigger('typeahead:selected', country);
            }

            $this.toggleClass('active');
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_REMOVED, function onSelectedTagRemove(isoCode) {
            toggleSelectedIcon(isoCode, false);
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_ADDED, function onSelectedTagAdd(isoCode) {
            toggleSelectedIcon(isoCode, true);
        });
    }

    function toggleSelectedIcon(isoCode, state) {
        $destinationsfs.find('.popular-countries-container a').filter(function filterByIsoCode() {
            return $(this).data('country').isoCode === isoCode;
        }).toggleClass('active', state);
    }


    meerkat.modules.register("travelPopularDestinations", {
        initTravelPopularDestinations: initTravelPopularDestinations,
        events: events
    });

})(jQuery);
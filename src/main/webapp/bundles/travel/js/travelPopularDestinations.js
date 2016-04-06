;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var events = {
        travelPopularDestinations: {}
    };

    var $destinationsfs;


    function initTravelPopularDestinations() {

        if(meerkat.modules.splitTest.isActive(99) !== true) { return; }

        var data = {};
        $destinationsfs = $('#destinationsfs');

        if(meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi'){
            // need to wait for the development.deferred module to be initialised then wait for the ajax call there to get all available service URL,
            // It is pretty painful to get something working/tested in DEV because of the branches
            // this is not working in IE because they take 5-10 secs to be dom ready thus the deferred module is pushed to be loaded after that
            _.delay(function() {
                meerkat.modules.development.getAggregationServicePromise().then(function() {
                    data.environmentOverride = $("#developmentAggregatorEnvironment").val();
                    getPopularCountriesList(data);
                });
            }, 1000);
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
                $('#travel_destinations').trigger('typeahead:selected', country);
            }

            $this.toggleClass('active');
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_REMOVED, function onSelectedTagRemove(isoCode) {
            $destinationsfs.find('.popular-countries-container a').filter(function filterByIsoCode() {
                return $(this).data('country').isoCode === isoCode;
            }).removeClass('active');
        });

        meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_ADDED, function onSelectedTagAdd(isoCode) {
            $destinationsfs.find('.popular-countries-container a').filter(function filterByIsoCode() {
                return $(this).data('country').isoCode === isoCode;
            }).addClass('active');
        });
    }


    meerkat.modules.register("travelPopularDestinations", {
        initTravelPopularDestinations: initTravelPopularDestinations,
        events: events
    });

})(jQuery);
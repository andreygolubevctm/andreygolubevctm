;(function ($, undefined) {

    /**
     * regoLookup provides a common gateway to make requests to the java service
     * to retrieve vehicle details based on the registration.
     *
     * It is presently just a basic ajax call however it can be extended later
     * as needed. Better to have this functionality common.
     **/

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        events = {};

    /**
     * get - calls a java service for the registration lookup. It expects at least the
     * data params which is an object with 2 properties - plateNumber (rego) and state (3 char).
     * Optionally settings can be passed in
     * @param data
     * @param settings
     */
    function getData(data, settings) {
        data = _.extend({plateNumber: null, state: null}, data);
        settings = settings || {};
        var request_obj = {
            url: "rest/rego/lookup/list.json",
            data: data,
            dataType: 'json',
            cache: true,
            useDefaultErrorHandling: true,
            numberOfAttempts: 3,
            errorLevel: "fatal"
        };
        if (_.isObject(settings) && !_.isEmpty(settings)) {
            request_obj = $.extend(request_obj, settings);
        }
        return meerkat.modules.comms.get(request_obj);
    }

    meerkat.modules.register("regoLookup", {
        events: events,
        get: getData
    });

})(jQuery);
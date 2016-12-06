;(function ($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        isLhcApplicable = 'N';


    /**
     * This function has been refactored into calling a core resultsTracking module.
     * It has remained here so verticals can run their own unique calls.
     */
    function publishExtraSuperTagEvents() {

        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: {
                preferredExcess: getPreferredExcess(),
                paymentPlan: Results.getFrequency(),
                sortBy: (Results.getSortBy() === "benefitsSort" ? "Benefits" : "Lowest Price"),
                simplesUser: meerkat.site.isCallCentreUser,
                isLhcApplicable: isLhcApplicable
            },
            onAfterEventMode: 'Load'
        });
    }


    function setLhcApplicable(lhcLoading) {
        isLhcApplicable = lhcLoading > 0 ? 'Y' : 'N';
    }

    function init() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
    }



    meerkat.modules.register('healthResults', {
        init: init,
        events: moduleEvents,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        setLhcApplicable: setLhcApplicable
    });

})(jQuery);

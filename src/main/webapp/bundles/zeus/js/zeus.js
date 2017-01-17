;(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
    };

    var steps;

    function initZeusComponent() {
        _registerEventListeners();
        _setJourneyEngineSteps();

        $(document).ready(function() {
            meerkat.modules.journeyEngine.configure({
                startStepId: null,
                steps: _.toArray(steps)
            });
        });
    }

    function _registerEventListeners() {
    }

    function _setJourneyEngineSteps(){
        meerkat.modules.journeyProgressBar.configure([]);

        steps = {
            startStep: {
                title: 'Toy Tracker',
                navigationId: 'toyTracker',
                slideIndex: 0,
                onInitialise: function() {
                }
            }
        };
    }

    meerkat.modules.register('zeusComponent', {
        init: initZeusComponent,
        events: events
    });

})(jQuery);
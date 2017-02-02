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
            $.ajaxSetup({ cache: true });
            $.getScript('//connect.facebook.net/en_US/sdk.js', function() {
                FB.init({
                    appId: 432806116767632,
                    version: 'v2.8'
                });

                $('.facebookShare').on('click', function() {
                    var url = $(this).attr("url_location");
                    FB.ui({
                        method: 'share',
                        href: url
                    });
                });
            });
        });
    }

    function _registerEventListeners() {
    }

    function _setJourneyEngineSteps(){
        meerkat.modules.journeyProgressBar.configure([]);

        steps = {
            startStep: {
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
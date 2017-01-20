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
                console.log("Does the get script.");


                $('.facebookShare').on('click', function() {
                    // FB.ui({
                    //     method: 'share_open_graph',
                    //     action_type: 'og.likes',
                    //     action_properties: JSON.stringify({
                    //         object:'https://www.comparethemarket.com.au/',
                    //     })
                    // },
                    // // callback
                    // function(response) {
                    //     if (response && !response.error_message) {
                    //         alert('Posting completed.');
                    //     } else {
                    //         alert('Error while posting.');
                    //     }
                    // });

                    FB.ui({
                        method: 'feed',
                        link: "https://www.comparethemarket.com.au/",
                        picture: 'https://www.comparethemarket.com.au/wp-content/uploads/2012/07/tom-aleks-sergei-home-min2.png',
                        name: "The name of who?",
                        description: "Some description"
                    }, function(response){
                        console.log(response);
                    });

                    // FB.ui({
                    //     method: 'share',
                    //     href: 'https://www.comparethemarket.com.au/',
                    //     quote: 'You can see where my toy is with this link www.blah.com'
                    // },
                    // // callback
                    // function(response) {
                    //     if (response && !response.error_message) {
                    //         alert('Posting completed.');
                    //     } else {
                    //         alert('Error while posting.');
                    //     }
                    // });
                });
                FB.getLoginStatus(updateStatusCallback());
            });
        });
    }

    function updateStatusCallback() {
        console.log("Does this");
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
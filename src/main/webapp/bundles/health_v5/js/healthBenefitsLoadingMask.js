;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            triggerBenefitsLoading : "BENEFITS_LOADING"
        },
        options = {
            duration: 1500
        },
        timer = null,
        $elements;

    function init() {
        $(document).ready(function () {
            $elements = {
                loader:          $('.benefitsLoadingAnimation')
            };

            eventSubscriptions();
        });
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.triggerBenefitsLoading, showAnimation);
    }

    function showAnimation() {
        $elements.loader.addClass('active').fadeIn("fast");
        clearTimeout(timer);
        timer = setTimeout(stopAnimation, options.duration);
    }

    function stopAnimation() {
        $elements.loader.fadeOut("fast", function(){
            $elements.loader.removeClass('active');
        });
    }

    meerkat.modules.register('healthBenefitsLoadingMask', {
        init: init,
        events: moduleEvents
    });

})(jQuery);
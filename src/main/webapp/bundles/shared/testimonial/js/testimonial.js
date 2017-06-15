;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var templateAllowed = false;

    function initTestimonial(){
        $(document).ready(function() {
            if (meerkat.site.vertical === 'simples' ||
                meerkat.site.isCallCentreUser === true ||
                meerkat.site.pageAction === "confirmation") return;


            if ((meerkat.site.vertical === 'health') ) {
                templateAllowed = true;
            }
        });
    }

    function renderTestimonialTile() {
        if (!templateAllowed) return;

        if (meerkat.modules.journeyEngine.getCurrentStep()['navigationId'].toLowerCase() === 'contact') {

            if ($e.length > 0) {

                //dont show modal if content does not exist
                if ($e.html().length > 0) {

                    var testimonialTemplate = _.template($('#testimonial-template').html());
                    $('.testimonial-tile-container').empty().append(testimonialTemplate());
                }
            }
        }
    }

    meerkat.modules.register("testimonial", {
        init: initTestimonial,
        renderTestimonialTile: renderTestimonialTile
    });

})(jQuery);
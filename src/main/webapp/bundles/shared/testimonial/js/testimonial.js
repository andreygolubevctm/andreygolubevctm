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

            var $e = $('#testimonial-template');

            //dont show modal if content does not exist
            if (! _.isEmpty($e.html())) {

                var testimonialTemplate = _.template($e.html());

                //append after the bottom get prices button on the contact page
                $('.journeyEngineSlide.active .row .col-sm-9 .row.slideAction').parent().parent().parent().append(testimonialTemplate());
            }
        }
    }

    meerkat.modules.register("testimonial", {
        init: initTestimonial,
        renderTestimonialTile: renderTestimonialTile
    });

})(jQuery);
;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var _contactTemplateInserted = false;

    function initTestimonial(){
        _contactTemplateInserted = false;
    }

    function renderContactTestimonialTile() {
        if (_contactTemplateInserted) return;

        if (meerkat.modules.journeyEngine.getCurrentStep()['navigationId'].toLowerCase() === 'contact') {

            var $e = $('#testimonial-template');

            /* don't show modal if content does not exist */
            if (! _.isEmpty($e.html())) {

                var testimonialTemplate = _.template($e.html());

                /* append after the bottom get prices button on the contact page */
                $('#contactForm').closest('.journeyEngineSlide').append(testimonialTemplate());
                _contactTemplateInserted = true;
            }
        }
    }

    meerkat.modules.register("testimonial", {
        init: initTestimonial,
        renderContactTestimonialTile: renderContactTestimonialTile
    });

})(jQuery);
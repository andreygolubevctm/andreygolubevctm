;(function ($, undefined) {

    var meerkat = window.meerkat,
        moduleEvents = {
            coverTypeChanged : "COVERTYPE_CHANGED"
        },
        $elements;

    function init() {
        _.defer(function(){
            $elements = {
                unselectAllHospital:    $('#health_benefits_toggleAndJumpMenuHospital-container .untickAll'),
                unselectAllExtras:      $('#health_benefits_toggleAndJumpMenuExtras-container .untickAll'),
                jumpToExtras:           $('#health_benefits_toggleAndJumpMenuHospital-container .jumpTo > span'),
                jumpToHospital:         $('#health_benefits_toggleAndJumpMenuExtras-container .jumpTo > span'),
                extrasWrapper:          $('#Extras-wrapper'),
                hospitalWrapper:        $('#Hospital-wrapper'),
                extrasBenefits:         $('#Extras-wrapper .short-list-item').find(':input'),
                hospitalBenefits:       $('#Hospital-wrapper .short-list-item').find(':input')
            };

            eventSubscriptions();
            eventListeners();
        });
    }
    
    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.coverTypeChanged, function(payload) {
            $elements.jumpToHospital.parent().toggleClass("hidden", payload.coverType === "E");
            $elements.jumpToExtras.parent().toggleClass("hidden", payload.coverType === "H");
        });
    }

    function eventListeners() {
        $elements.unselectAllHospital.on("click.untickAll", function(){
            $elements.hospitalBenefits.filter(":checked").each(function(){
                $(this).siblings("label:first").trigger("click.manualBenefitSelection");
            });
        });
        $elements.unselectAllExtras.on("click.untickAll", function(){
            $elements.extrasBenefits.filter(":checked").each(function(){
                $(this).siblings("label:first").trigger("click.manualBenefitSelection");
            });
        });
        $elements.jumpToExtras.on("click.jumpTo", function(){
            $('html, body').stop().animate({
                scrollTop: parseInt($elements.extrasWrapper.offset().top - 50)
            }, 1000);
        });
        $elements.jumpToHospital.on("click.jumpTo", function(){
            $('html, body').stop().animate({
                scrollTop: parseInt($elements.hospitalWrapper.offset().top - 50)
            }, 1000);
        });
    }

    meerkat.modules.register('healthBenefitsToggleAndJumpMenu', {
        init: init,
        events: moduleEvents
    });

})(jQuery);
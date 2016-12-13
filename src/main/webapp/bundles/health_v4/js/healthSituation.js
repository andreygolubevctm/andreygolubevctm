;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthSituation: {
                SITUATION_CHANGED: 'SITUATION_CHANGED'
            }
        },
        $healthSituation;

    function init() {
        $healthSituation = $('input[name=health_situation_healthCvr]');
        $healthSituation.filter('[value=SM],[value=SF]').parent().addClass('icon icon-single');
        $healthSituation.filter('[value=C]').parent().addClass('icon icon-couple');
        $healthSituation.filter('[value=F]').parent().addClass('icon icon-family');
        $healthSituation.filter('[value=SPF]').parent().addClass('icon icon-single-family');

        eventSubscriptions();
    }

    function eventSubscriptions() {
        $healthSituation.on('change', function onSituationChanged() {
            meerkat.messaging.publish(moduleEvents.healthSituation.SITUATION_CHANGED, { situation: $(this).val() });
            meerkat.modules.healthChoices.setCover($(this).filter(':checked').val());
        });
    }

    meerkat.modules.register('healthSituation', {
        init: init,
        events: moduleEvents
    });

})(jQuery);
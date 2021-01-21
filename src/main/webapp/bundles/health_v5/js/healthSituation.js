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
        _.defer(function(){
            $healthSituation = $('input[name=health_situation_healthCvr]');
            $healthSituation.filter('[value=SM],[value=SF]').parent().addClass('icon icon-single');
            $healthSituation.filter('[value=C]').parent().addClass('icon icon-couple');
            $healthSituation.filter('[value=F]').parent().addClass('icon icon-family');
            $healthSituation.filter('[value=SPF]').parent().addClass('icon icon-single-family');

            _eventSubscriptions();

            if (getSituation()) {
                $healthSituation.filter(':checked').change();
            }
        });
    }

    function _eventSubscriptions() {
        $healthSituation.on('change', function onSituationChanged() {
            var situation = $(this).filter(':checked').val();

            meerkat.messaging.publish(moduleEvents.healthSituation.SITUATION_CHANGED, { situation: situation });
            meerkat.modules.healthChoices.setCover(situation);
        });
    }

    function getSituation() {
        if(_.isUndefined($healthSituation)) {
            $healthSituation = $('input[name=health_situation_healthCvr]');
        }
        var $checked = $healthSituation.filter(':checked');
        return $checked.length ? $checked.val() : false;
    }

    function getSituationAsText() {
        var $checked = $healthSituation.filter(':checked');
        return $checked.length ? $.trim($healthSituation.filter(':checked').parent().text()) : "";
    }

    meerkat.modules.register('healthSituation', {
        init: init,
        events: moduleEvents,
        getSituation: getSituation,
        getSituationAsText: getSituationAsText
    });

})(jQuery);
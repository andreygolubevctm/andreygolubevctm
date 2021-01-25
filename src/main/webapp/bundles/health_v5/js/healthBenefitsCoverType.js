;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            coverTypeChanged : "COVERTYPE_CHANGED"
        },
        $elements = {};

    function init() {
        $(document).ready(function () {
            $elements = {
                wrapper:            $('#health-benefits-coverType-container').find('.health-benefits-coverType'),
                coverType:          $('input[name=health_situation_coverType]'),
                hospitalWrapper:    $('#benefitsForm').find('.Hospital-wrapper'),
                extrasWrapper:      $('#benefitsForm').find('.Extras-wrapper')
            };
            $elements.coverType.filter('[value=C]').parent().addClass('health-icon icon-health-covertype-combined');
            $elements.coverType.filter('[value=H]').parent().addClass('health-icon icon-health-covertype-hospital');
            $elements.coverType.filter('[value=E]').parent().addClass('health-icon icon-health-covertype-extras');

            eventSubscriptions();
            eventListeners();

            if($elements.coverType.filter(':checked')) {
                $elements.coverType.filter(':checked').trigger("click.coverType");
            }

            $elements.wrapper.find('label').each(function(){
                $(this).addClass("no-width col-xs-3 col-md-2");
            });
        });
    }

    function eventSubscriptions() {}

    function eventListeners() {
        $elements.coverType.on("click.coverType", function(){
            var coverType = $(this).val();
            meerkat.messaging.publish(moduleEvents.coverTypeChanged, {coverType: coverType});
            if(coverType === 'E') {
                setExtrasOnly();
            } else if(coverType === 'H') {
                setHospitalOnly();
            } else {
                setCombined();
            }
        });
    }

    function setCoverType(coverType) {
        coverType = coverType || false;
        if(coverType && _.isString(coverType)) {
            coverType = coverType.toUpperCase();
            var validTypes = ["C", "H", "E"];
            if(_.indexOf(validTypes, coverType) !== -1) {
                if (coverType === 'E') {
                    setExtrasOnly();
                } else if (coverType === 'H') {
                    setHospitalOnly();
                } else {
                    setCombined();
                }
            }
        }
    }

    function getCoverType() {
        if($elements.coverType && $elements.coverType.filter(':checked')) {
            return $elements.coverType.filter(':checked').val();
        }
        return false;
    }

    function setExtrasOnly() {
        $elements.coverType.filter('[value=E]').prop('checked', true).change();
        $elements.hospitalWrapper.fadeOut('fast', function() {
            toggleClass("E");
            $elements.extrasWrapper.fadeIn('fast');
        });
    }

    function setHospitalOnly() {
        $elements.coverType.filter('[value=H]').prop('checked', true).change();
        $elements.extrasWrapper.fadeOut('fast', function(){
            toggleClass("H");
            $elements.hospitalWrapper.slideDown('fast');
        });
    }

    function setCombined() {
        $elements.coverType.filter('[value=C]').prop('checked', true).change();
        $elements.hospitalWrapper.slideDown('fast', function(){
            $elements.extrasWrapper.slideDown('fast');
        });
        toggleClass("C");
    }

    function toggleClass(coverType) {
        var list = ["C", "H", "E"];
        _.each(list, function(type){
            $('body').toggleClass("coverType-" + type, type === coverType);
        });
    }

    meerkat.modules.register('healthBenefitsCoverType', {
        init: init,
        events: moduleEvents,
        getCoverType: getCoverType,
        setCoverType: setCoverType
    });

})(jQuery);
/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat =window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $elements = {},
        moduleEvents = {
            quickSelect: {
                CLEAR_BENEFITS: 'CLEAR_BENEFITS',
                PRESELECT_BENEFITS: 'PRESELECT_BENEFITS'
            }
        };

    function initBenefits() {
        $('#tabs').on('click', '.nav-tabs a', function(e) {
            e.preventDefault();
            e.stopPropagation();

            $(this).tab('show');
        });

        $('.nav-tabs a:first').click();

        $elements = {
            benefitsOverlow: $('.benefitsOverflow'),
            extrasOverlay: $('.extrasOverlay'),
            hospitalOverlay: $('.hospitalOverlay'),
            hospital: $('.Hospital_container'),
            extras: $('.GeneralHealth_container'),
            quickSelectContainer: $('.quickSelectContainer'),
            coverType: $('input[name=health_situation_covertype]')
        };

        _eventSubscription();
    }

    function _eventSubscription() {
        _registerXSBenefitsSlider();
        _registerBenefitsCounter();
    }

    function _coverChangePartner(isHospital) {
        // deselect the benefits
        var $container = isHospital ? $elements.hospital : $elements.extras;
        $container.find('input:checkbox').removeAttr('checked');

        // update the model
        meerkat.modules.benefitsModel.setIsHospital(isHospital);
        _updateBenefits();
    }

    function _preselectBenefits(settings) {
        // set the flag if we're updating the hospital or extras benefits
        meerkat.modules.benefitsModel.setIsHospital(settings.isHospital);

        var benefitType = meerkat.modules.benefitsModel.getBenefitType();

        // update the dom with the selected benefits
        _.each(settings.selectedItems, function addDefaultBenefits(id) {
            $elements[benefitType].find('[data-benefit-id='+id+']').prop('checked', 'checked');
        });

        // update the model with all the selected benefits
        _updateBenefits();

    }

    function _registerBenefitsCounter() {
        $('.GeneralHealth_container, .Hospital_container').on('change', 'input', function(){
            meerkat.modules.benefitsModel.setIsHospital($(this).closest('.Hospital_container').length === 1);
            _updateBenefits();
        });
    }

    function _registerXSBenefitsSlider() {
        $elements.hospitalOverlay.hide();

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function extrasOverlayEnterXsState() {
            $elements.extrasOverlay.show();

            // set extras
            _updateBenefits();

            // set hospital
            meerkat.modules.benefitsModel.setIsHospital(true);
            _updateBenefits();
            _setOverlayLabelCount($elements.hospitalOverlay, meerkat.modules.benefitsModel.getHospitalCount());
            _setOverlayLabelCount($elements.extrasOverlay, meerkat.modules.benefitsModel.getExtrasCount());
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function extrasOverlayLeaveXsState() {
            $elements.extrasOverlay.hide();
        });

        // toggle the overlays
        $elements.extrasOverlay.off().on('click', function displayExtrasBenefits() {
            $elements.benefitsOverlow.animate({'left': ($elements.extrasOverlay.width() * -1)}, 500, function onExtrasAnimateComplete(){
                _setOverlayLabelCount($elements.hospitalOverlay, meerkat.modules.benefitsModel.getHospitalCount());
                $elements.extrasOverlay.hide();
                $elements.hospitalOverlay.show();
            });
        });

        $elements.hospitalOverlay.off().on('click', function displayHospitalBenefits() {
            $elements.benefitsOverlow.animate({'left': 0}, 500, function onHospitalAnimateComplete() {
                _setOverlayLabelCount($elements.extrasOverlay, meerkat.modules.benefitsModel.getExtrasCount());
                $elements.hospitalOverlay.hide();
                $elements.extrasOverlay.show();
            });
        });

        // toggle the quick select data in the hospital container
        $elements.hospital.find('.nav-tabs a').on('click', function toggleQuickSelect(){
            $elements.hospital.find($elements.quickSelectContainer).toggleClass('hidden', $(this).data('target') === '.limited-pane');
        });

        // clear benefits
        meerkat.messaging.subscribe(moduleEvents.CLEAR_BENEFITS, _coverChangePartner);

        // preselect benefits
        meerkat.messaging.subscribe(moduleEvents.PRESELECT_BENEFITS, _preselectBenefits);
    }

    function _setOverlayLabelCount($overlay, count) {
        $overlay.find('span').text(count);
    }

    function _setCoverTypeField() {
        // set the hidden field
        var coverType = 'C';

        if (meerkat.modules.benefitsModel.getExtrasCount() > 0 && meerkat.modules.benefitsModel.getHospitalCount() === 0) {
            coverType = 'E';
        } else if (meerkat.modules.benefitsModel.getExtrasCount() === 0 && meerkat.modules.benefitsModel.getHospitalCount() > 0) {
            coverType = 'H';
        }

        $elements.coverType.val(coverType);
    }

    function setDefaultTabs() {
        // set extras
        _updateBenefits();

        // set hospital
        meerkat.modules.benefitsModel.setIsHospital(true);
        _updateBenefits();

        if (meerkat.modules.deviceMediaState.get() == 'xs') {
            // update label
            _setOverlayLabelCount($elements.extrasOverlay, meerkat.modules.benefitsModel.getExtrasCount());
        }
    }

    function _updateBenefits(){
        var tempBenefitsCounter = [],
            benefitType = meerkat.modules.benefitsModel.getBenefitType();

        // update the dom
        _.each($elements[benefitType].find('input').filter(':checked'), function updateBenefitCount(checkbox) {
            tempBenefitsCounter.push($(checkbox).data('benefit-id'));
        });

        meerkat.modules.benefitsModel.setBenefits(tempBenefitsCounter);

        _setCoverTypeField();
    }

    meerkat.modules.register("benefits", {
        init : initBenefits,
        setDefaultTabs: setDefaultTabs
    });

})(jQuery);
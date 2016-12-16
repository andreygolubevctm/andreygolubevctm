/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        events = {
            benefits: {
                BENEFIT_SELECTED: 'BENEFIT_SELECTED'
            }
        },
        moduleEvents = events.benefits;

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

    function updateModelOnPreload(){
        // extras first
        meerkat.modules.benefitsModel.setIsHospital(false);
        meerkat.modules.benefitsModel.setBenefits(_getSelectedBenefits($('.GeneralHealth_container')));

        // hospital second since this is our default benefits screen
        meerkat.modules.benefitsModel.setIsHospital(true);
        meerkat.modules.benefitsModel.setBenefits(_getSelectedBenefits($('.Hospital_container')));
    }

    function _getSelectedBenefits($container) {
        var selectedIds = [];

        _.each($container.find(':input[data-benefit-id]:checked'), function getInputIds(el){
            selectedIds.push($(el).data('benefit-id'));
        });

        return selectedIds;
    }

    function _registerBenefitsCounter() {
        $('.GeneralHealth_container, .Hospital_container').on('change', 'input', function(){
            var $this = $(this),
                options = {
                    benefitId: $this.data('benefit-id'),
                    isHospital: $this.closest('.Hospital_container').length === 1,
                    removeBenefit: !$this.is(':checked')
                };
            meerkat.messaging.publish(moduleEvents.BENEFIT_SELECTED, options);
        });
    }

    function _registerXSBenefitsSlider() {
        $elements.hospitalOverlay.hide();

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function extrasOverlayEnterXsState() {
            $elements.extrasOverlay.show();
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

        // updated benefits model
        meerkat.messaging.subscribe(meerkatEvents.benefitsModel.BENEFITS_UPDATED, _reSelectBenefitCheckboxes);
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

    function _reSelectBenefitCheckboxes(updatedBenefitsModel) {
        var benefitType = meerkat.modules.benefitsModel.getBenefitType();

        // reset the checkboxes
        $elements[benefitType].find(':checkbox').removeAttr('checked');

        // reselect the checkboxes
        _.each(updatedBenefitsModel, function updateCheckboxes(id) {
            $elements[benefitType].find('input[data-benefit-id='+id+']').prop('checked', 'checked');
        });

        _setCoverTypeField();
    }

    meerkat.modules.register("benefits", {
        init: initBenefits,
        events: events,
        updateModelOnPreload: updateModelOnPreload
    });

})(jQuery);
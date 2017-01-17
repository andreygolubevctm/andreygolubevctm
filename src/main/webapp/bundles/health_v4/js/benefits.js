/**
 * Description: External documentation:
 */

(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        events = {
            benefits: {
                BENEFIT_SELECTED: 'BENEFIT_SELECTED'
            }
        },
        moduleEvents = events.benefits,
        _hospitalType = 'customise'; // default to customise

    function initBenefits() {
        jQuery(document).ready(function ($) {
            // was in step onInitialise, didnt work there for results.
            meerkat.modules.benefits.updateModelOnPreload();

            $('#tabs').on('click', '.nav-tabs a', function (e) {
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

            _populateBenefitsLabelsStore();
        });
    }

    function _isBenefitElementHospital($element) {
        return $element.closest('.Hospital_container').length === 1;
    }

    /**
     * Need to populate the benefit label store for the benefit filter template.
     * @private
     */
    function _populateBenefitsLabelsStore() {
        var benefits = {
            hospital: [],
            extras: []
        };
        $elements.extras.add($elements.hospital).find('input').each(function () {
            var $this = $(this),
                benefitType = _isBenefitElementHospital($this) ? 'hospital' : 'extras';
            // If health filters needs any other properties in filters_benefits.tag, add them here.
            benefits[benefitType].push({
                id: $this.data('benefit-id'),
                label: $this.next('label').find('.benefitTitle').text(),
                value: $this.data('benefit-id') // this is needed for filters.
            });
        });
        meerkat.modules.benefitsModel.initBenefitLabelStore(benefits);
    }

    function _eventSubscription() {
        _registerXSBenefitsSlider();
        _registerBenefitsSelection();
    }

    function updateModelOnPreload() {
        // extras first
        meerkat.modules.benefitsModel.setIsHospital(false);
        meerkat.modules.benefitsModel.setBenefits(_getSelectedBenefits($('.GeneralHealth_container')));

        // hospital second since this is our default benefits screen
        meerkat.modules.benefitsModel.setIsHospital(true);
        meerkat.modules.benefitsModel.setBenefits(_getSelectedBenefits($('.Hospital_container')));
    }

    function _getSelectedBenefits($container) {
        var selectedIds = [];

        _.each($container.find(':input[data-benefit-id]:checked'), function getInputIds(el) {
            selectedIds.push($(el).data('benefit-id'));
        });

        return selectedIds;
    }

    function _registerBenefitsSelection() {
        $('.GeneralHealth_container, .Hospital_container').on('change', 'input', function () {
            var $this = $(this),
                options = {
                    benefitId: $this.data('benefit-id'),
                    isHospital: _isBenefitElementHospital($this),
                    removeBenefit: !$this.is(':checked')
                };

            meerkat.messaging.publish(moduleEvents.BENEFIT_SELECTED, options);
        });

        // set cover type field
        meerkat.messaging.subscribe(meerkatEvents.benefitsModel.BENEFITS_MODEL_UPDATE_COMPLETED, _setCoverTypeField);

        // updated the selected checkboxes
        meerkat.messaging.subscribe(meerkatEvents.benefitsModel.UPDATE_SELECTED_BENEFITS_CHECKBOX, _reSelectBenefitCheckboxes);
    }

    function _registerXSBenefitsSlider() {
        // toggle the quick select data in the hospital container
        $elements.hospital.find('.nav-tabs a').on('click', function toggleQuickSelect(){
            var target = $(this).data('target');

            $elements.hospital.find($elements.quickSelectContainer).toggleClass('hidden', target === '.limited-pane');
            _hospitalType = target === '.limited-pane' ? 'limited' : 'customise';
        });
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
            $elements[benefitType].find('input[data-benefit-id=' + id + ']').prop('checked', 'checked');
        });
    }

    function getHospitalType() {
        return _hospitalType;
    }

    meerkat.modules.register("benefits", {
        init: initBenefits,
        events: events,
        updateModelOnPreload: updateModelOnPreload,
        getHospitalType: getHospitalType
    });

})(jQuery);
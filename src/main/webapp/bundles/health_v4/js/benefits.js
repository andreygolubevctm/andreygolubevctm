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

            $elements = {
                benefitsOverlow: $('.benefitsOverflow'),
                extrasOverlay: $('.extrasOverlay'),
                hospitalOverlay: $('.hospitalOverlay'),
                hospital: $('.Hospital_container'),
                extras: $('.GeneralHealth_container'),
                quickSelectContainer: $('.quickSelectContainer'),
                coverType: $('input[name=health_situation_coverType]'),
                hiddenHospitalCover: $('input[name="health_benefits_benefitsExtras_Hospital"]'),
                hiddenExtraCover: $('input[name="health_benefits_benefitsExtras_GeneralHealth"]'),
                accidentOnlyCover: $('input[name=health_situation_accidentOnlyCover]'),
                comprehensiveBenefitTab: $('#comprehensiveBenefitTab'),
                limitedCoverIcon: $('#health_benefits_benefitsExtras_LimitedCover'),
                privateHospitalBenefit: $('input[name=health_benefits_benefitsExtras_PrHospital]')
            };

            if (meerkat.modules.splitTest.isActive(2)) {
                $elements.benefitsSwitchAlert = $('.benefits-switch-alert');
            }

            $('#tabs').find('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                if (!meerkat.modules.splitTest.isActive(2) ||
                    (meerkat.modules.splitTest.isActive(2) && meerkat.modules.benefitsSwitch.isHospitalOn())) {
                    var hospitalType = getHospitalType();

                    setHospitalType($(this).data('benefit-cover-type'));
                    $('.hospital-content-toggle').toggle(hospitalType !== 'limited');
                }
            });

            $('label[for="health_benefits_benefitsExtras_LimitedCover"]').on('click', function () {
                if (!meerkat.modules.splitTest.isActive(2) ||
                    (meerkat.modules.splitTest.isActive(2) && meerkat.modules.benefitsSwitch.isHospitalOn())) {
                    $elements.comprehensiveBenefitTab.find('a').trigger('click');
                }
            });

            // was in step onInitialise, didnt work there for results.
            meerkat.modules.benefits.updateModelOnPreload();
            _eventSubscription();
            _populateBenefitsLabelsStore();

            _.defer(function(){
                // Ensure that Private Hospital is selected as default cover
                if(meerkat.site.isNewQuote && !$('#health_benefits_benefitsExtras_PrHospital').prop('checked')) {
                    $('#health_benefits_benefitsExtras_PrHospital').prop('checked',true).change();
                }
            });
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

        $elements.extras.add($elements.hospital).find('.healthBenefits input').not($elements.limitedCoverIcon).each(function () {
            var $this = $(this),
                benefitType = _isBenefitElementHospital($this) ? 'hospital' : 'extras';
            // If health filters needs any other properties in filters_benefits.tag, add them here.
            benefits[benefitType].push({
                id: $this.attr('data-benefit-id'),
                label: $this.next('label').find('.benefitTitle').text(),
                value: $this.attr('data-benefit-id'), // this is needed for filters - filters.deferred.js requires a .value node
                code: $this.attr('data-benefit-code') // this is needed for quote ranking and best price email
            });
        });
        meerkat.modules.benefitsModel.initBenefitLabelStore(benefits);
    }

    function _eventSubscription() {
        _registerXSBenefitsSlider();
        _registerBenefitsSelection();
    }

    function updateModelOnPreload() {

        var type = $elements.accidentOnlyCover.val() == 'Y' ? "limited" : "customise";
        $('#tabs').find('[data-benefit-cover-type=' + type + ']').click().trigger('shown.bs.tab');

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
            selectedIds.push($(el).attr('data-benefit-id'));
        });

        return selectedIds;
    }

    function _registerBenefitsSelection() {
        $('.GeneralHealth_container, .Hospital_container').on('change', '.healthBenefits input', function () {
            var $this = $(this),
                options = {
                    benefitId: $this.attr('data-benefit-id'),
                    isHospital: _isBenefitElementHospital($this),
                    removeBenefit: !$this.is(':checked')
                };

            meerkat.messaging.publish(moduleEvents.BENEFIT_SELECTED, options);
        });

        // set cover type field
        meerkat.messaging.subscribe(meerkatEvents.benefitsModel.BENEFITS_MODEL_UPDATE_COMPLETED, function updateHiddenFields() {
            _setCoverTypeField();
            _updateHiddenFields();
        });

        // updated the selected checkboxes
        meerkat.messaging.subscribe(meerkatEvents.benefitsModel.UPDATE_SELECTED_BENEFITS_CHECKBOX, _reSelectBenefitCheckboxes);


        if (meerkat.modules.splitTest.isActive(2)) {
            meerkat.messaging.subscribe(meerkatEvents.benefitsSwitch.SWITCH_CHANGED, function (e) {
                _toggleBenefitSelection(e.benefit, e.isSwitchedOn);
                _toggleSwitchValidation();
                _setCoverTypeField();

                if (e.benefit === 'hospital' && e.isSwitchedOn) {
                    _checkPrivateHospital();
                }
            });
        }
    }

    function _registerXSBenefitsSlider() {
        // toggle the quick select data in the hospital container
        $elements.hospital.find('.nav-tabs a').on('click', function toggleQuickSelect() {
            var target = $(this).attr('href'),
                limitedSelected = target === '.limited-pane';

            // Check the input so it remains a green tick.
            $elements.limitedCoverIcon.prop('checked', true);
            $elements.hospital.find($elements.quickSelectContainer).toggleClass('hidden', limitedSelected);
            _hospitalType = limitedSelected ? 'limited' : 'customise';

            if (!limitedSelected) {
                _checkPrivateHospital();
            }
        });
    }

    function _setCoverTypeField() {
        // set the hidden field
        var isLimited = meerkat.modules.benefits.getHospitalType() === 'limited';
        var coverType = 'C';
        var hospitalCount = meerkat.modules.benefitsModel.getHospitalCount();
        var extrasCount = meerkat.modules.benefitsModel.getExtrasCount();

        // C = extras AND (hospital OR limited)
        if(extrasCount > 0 && (hospitalCount > 0 || isLimited)) {
            coverType = 'C';
            // H = No extras, and Hospital benefits OR limited
        } else if(extrasCount === 0 && (hospitalCount > 0 || isLimited)) {
            coverType = 'H';
            // E = extras only
        } else if(extrasCount > 0) {
            coverType = 'E';
        }

        if (meerkat.modules.splitTest.isActive(2)) {
            if (!meerkat.modules.benefitsSwitch.isHospitalOn()) {
                coverType = 'E';
            }

            if (!meerkat.modules.benefitsSwitch.isExtrasOn()) {
                coverType = 'H';
            }
        }

        meerkat.modules.healthChoices.setCoverType(coverType);
    }

    function _reSelectBenefitCheckboxes(updatedBenefitsModel) {
        var benefitType = meerkat.modules.benefitsModel.getBenefitType();

        // reset the checkboxes
        $elements[benefitType].find('input[data-benefit-id]').removeAttr('checked');

        // reselect the checkboxes
        _.each(updatedBenefitsModel, function updateCheckboxes(id) {
            $elements[benefitType].find('input[data-benefit-id=' + id + ']').prop('checked', 'checked');
        });

        // Update limited icon
        $elements.limitedCoverIcon.prop('checked',meerkat.modules.benefits.getHospitalType() === 'limited');
    }

    function getHospitalType() {
        return _hospitalType;
    }

    function setHospitalType(type) {
        _hospitalType = type;
        _setAccidentOnly();
    }

    function _setAccidentOnly() {
        $elements.accidentOnlyCover.val(_hospitalType == 'limited' ? 'Y' : 'N');
    }

    function toggleHospitalTypeTabs() {
        $('#tabs').find('a[data-benefit-cover-type="' + getHospitalType() + '"]').trigger('click');
    }

    function _updateHiddenFields() {
        switch (meerkat.modules.healthChoices.getCoverType()) {
            case 'C':
                $elements.hiddenHospitalCover.val('Y');
                $elements.hiddenExtraCover.val('Y');
                break;
            case 'H':
                $elements.hiddenHospitalCover.val('Y');
                $elements.hiddenExtraCover.val('');
                break;
            case 'E':
                $elements.hiddenHospitalCover.val('');
                $elements.hiddenExtraCover.val('Y');
                break;
        }
    }

    function _toggleBenefitSelection(benefit, isSwitchedOn) {
        $elements[benefit].toggleClass('benefits-switched-off', !isSwitchedOn);

        $elements[benefit].find('.healthBenefits input[type=checkbox]').prop('disabled', !isSwitchedOn);
    }

    function _checkPrivateHospital() {
        if (meerkat.modules.benefitsModel.getHospitalCount() === 0) {
            $elements.privateHospitalBenefit.trigger('click');
        }
    }

    function _toggleSwitchValidation() {
        var areBenefitsSwitchOn = meerkat.modules.benefitsSwitch.isHospitalOn() || meerkat.modules.benefitsSwitch.isExtrasOn();
        $elements.benefitsSwitchAlert
            .add($elements.benefitsSwitchAlert.find('.benefits-switch-off-message'))
            .toggleClass('hidden', areBenefitsSwitchOn);
        $elements.benefitsSwitchAlert.find('.benefits-switch-extras-message').addClass('hidden');
        $('.journeyEngineSlide.active .journeyNavButton, .slide-control-insurance-preferences').attr('disabled', !areBenefitsSwitchOn);
    }

    function toggleExtrasMessage(hide) {
        $elements.benefitsSwitchAlert
            .add($elements.benefitsSwitchAlert.find('.benefits-switch-extras-message'))
            .toggleClass('hidden', hide);
        $elements.benefitsSwitchAlert.find('.benefits-switch-off-message').toggleClass('hidden', !hide);
    }

    meerkat.modules.register("benefits", {
        init: initBenefits,
        events: events,
        updateModelOnPreload: updateModelOnPreload,
        getHospitalType: getHospitalType,
        setHospitalType: setHospitalType,
        toggleHospitalTypeTabs: toggleHospitalTypeTabs,
        toggleExtrasMessage: toggleExtrasMessage
    });

})(jQuery);
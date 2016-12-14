/**
 * Description: External documentation:
 */

(function($, undefined) {


    var meerkat =window.meerkat,
        _isHospital = false,
        defaultSelections = {
            // Private Hospital, Birth Related Services, Assisted Reproduction, In-Hospital Rehabilitation
            family: [6953, 6957, 6960, 6987],
            // Private Hospital, Heart Surgery, Joint Replacement, Major Eye Surgery, In-Hospital Rehabilitation
            aging: [6953, 6954, 6966, 6963, 6987],
            // General Dental, Major Dental, Endodontics, Orthodontics
            dental: [6991, 7002, 7011, 7019],
            // General Dental, Major Dental, Physiotherapy, Chiropratic, Remedial Massage, Podiatry, Orthotics, Lifestyle
            sports: [6991, 7002, 7036, 7045, 7078, 7054, 7119, 7158],
            // General Dental, Optical, Physiotherapy
            peace: [6991, 7028, 7036]
        },
        selectedElements = {
            hospital: [],
            extras: []
        },
        meerkatEvents = meerkat.modules.events,
        events = {
            benefitsModel: {
                BENEFITS_UPDATED: 'BENEFITS_UPDATED'
            }
        },
        moduleEvents = events.benefitsModel;

    function init() {
        _eventsSubscription();
    }

    function _eventsSubscription() {
        // benefit selected
        meerkat.messaging.subscribe(meerkatEvents.benefits.BENEFIT_SELECTED, _updateBenefitToModel);

        // clear benefits
        meerkat.messaging.subscribe(meerkatEvents.qSelect.CLEAR_BENEFITS, _resetModel);
    }

    function _resetModel(isHospital) {
        setIsHospital(isHospital);
        setBenefits([]);
    }

    function _updateBenefitToModel(options) {
        setIsHospital(options.isHospital);

        if (typeof options.removeBenefit !== 'undefined' && options.removeBenefit) {
            selectedElements[getBenefitType()] =  $.grep(selectedElements[getBenefitType()], function(value) {
                return value != options.benefitId;
            });
        } else {
            if (typeof options.benefitId === 'number') {
                selectedElements[getBenefitType()].push(options.benefitId);
            } else {
                setBenefits(_.union(selectedElements[getBenefitType()], options.benefitIds));
            }
        }
    }

    function getBenefitType() {
        return _isHospital ? 'hospital' : 'extras';
    }

    function getDefaultSelections(selectType){
        return defaultSelections[selectType];
    }

    function getExtras() {
        return selectedElements.extras;
    }

    function getExtrasCount() {
        return selectedElements.extras.length;
    }

    function getHospital() {
        return selectedElements.hospital;
    }

    function getHospitalCount() {
        return selectedElements.hospital.length;
    }

    function setBenefits(updatedBenefits) {
        selectedElements[getBenefitType()] = updatedBenefits;

        meerkat.messaging.publish(moduleEvents.BENEFITS_UPDATED, selectedElements[getBenefitType()]);
    }

    function setIsHospital(isHospital) {
        _isHospital = isHospital;
    }

    meerkat.modules.register("benefitsModel", {
        init: init,
        events: events,
        getBenefitType: getBenefitType,
        getDefaultSelections: getDefaultSelections,
        getExtras: getExtras,
        getExtrasCount: getExtrasCount,
        getHospital: getHospital,
        getHospitalCount: getHospitalCount,
        setBenefits: setBenefits,
        setIsHospital: setIsHospital
    });

})(jQuery);
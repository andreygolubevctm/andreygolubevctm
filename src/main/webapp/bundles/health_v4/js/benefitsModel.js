/**
 * Description: External documentation:
 */

(function($, undefined) {


    var meerkat =window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
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
        $benefitContainers = {
            hospital: $('.Hospital_container'),
            extras: $('.GeneralHealth_container')
        };

    function init() {

    }

    function getDefaultSelections(selectType){
        return defaultSelections[selectType];
    }

    function getExtrasCount() {
        return selectedElements.extras.length;
    }

    function getHospitalCount() {
        return selectedElements.hospital.length;
    }

    function _getBenefitValue(id) {
        var parts = id.split('_');
        return parts[parts.length-1];
    }

    function addBenefit(val) {
        selectedElements[getBenefitType()].push(_getBenefitValue(val));
    }

    function removeBenefit(val) {
        var index = selectedElements[getBenefitType()].indexOf(_getBenefitValue(val));
        selectedElements[getBenefitType()].splice(index, 1);
    }

    function setIsHospital(isHospital) {
        _isHospital = isHospital;
    }

    function getBenefitType() {
        return _isHospital ? 'hospital' : 'extras';
    }

    function updateBenefits() {
        var benefitCounter = selectedElements[getBenefitType()];

          // iterate over the dom to get the latest selected benefits
        _.each($benefitContainers[getBenefitType()].find('input'), function updateBenefitModel(){
            benefitCounter.push($(this).data('benefit-id'));
        });
    }

    function clearModel() {
        selectedElements[getBenefitType()] = [];
    }

    meerkat.modules.register("benefitsModel", {
        init : init,
        getExtrasCount: getExtrasCount,
        getHospitalCount: getHospitalCount,
        addBenefit: addBenefit,
        removeBenefit: removeBenefit,
        getDefaultSelections: getDefaultSelections,
        getBenefitType: getBenefitType,
        setIsHospital: setIsHospital,
        updateBenefits: updateBenefits,
        clearModel: clearModel
    });

})(jQuery);
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
        };

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

    function setBenefits(tempBenefitsCounter) {
        selectedElements[getBenefitType()] = tempBenefitsCounter;
    }

    function setIsHospital(isHospital) {
        _isHospital = isHospital;
    }

    meerkat.modules.register("benefitsModel", {
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
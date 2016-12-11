/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat =window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $elements = {},
        extrasCounter = 0,
        hospitalCounter = 0;

    function init() {

    }

    function increaseBenefitCount(benefitType) {
        if (benefitType.toLowerCase() === 'hospital') {
            hospitalCounter++;
        } else {
            extrasCounter++;
        }
    }

    function decreaseBenefitCount(benefitType) {
        if (benefitType.toLowerCase() === 'hospital') {
            hospitalCounter--;
        } else {
            extrasCounter--;
        }
    }

    function getExtrasCount() {
        return extrasCounter;
    }

    function getHospitalCount() {
        return hospitalCounter;
    }

    meerkat.modules.register("benefitsModel", {
        init : init,
        getExtrasCount: getExtrasCount,
        getHospitalCount: getHospitalCount,
        increaseBenefitCount: increaseBenefitCount,
        decreaseBenefitCount: decreaseBenefitCount
    });

})(jQuery);
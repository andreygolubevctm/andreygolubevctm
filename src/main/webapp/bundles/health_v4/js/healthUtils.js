/**
 * Health Utils Module.
 * Health utilities for getting information from the form
 */
;(function($, undefined){

    var meerkat = window.meerkat;


    function getPrimaryCurrentPHI() {
        return $('[name="health_healthCover_primary_cover"]:checked').val();
    }

    function getSpecialOffer(product) {
        var promoText = /^(.+)<p><a class="dialogPop" data-content="([\s\S]+)" title=.+$/g.exec(product.promo.promoText);
        var specialOffer = promoText && promoText[1];
        // Convert this back to html
        var specialOfferTerms = promoText && promoText[2] && $('<div/>').html(promoText[2]).text();
        return {
            "specialOffer" : specialOffer,
            "specialOfferTerms" : specialOfferTerms
        };
    }

    function getExcessesAndCoPayment(product) {
        var excessPerAdmission = null;
        var excessPerPerson = null;
        var excessPerPolicy = null;
        var coPayment = null;
        if (product.hospital && product.hospital.inclusions) {
            if (product.hospital.inclusions.excesses) {
                excessPerAdmission = (product.hospital.inclusions.excesses.perAdmission && meerkat.modules.currencyUtils.toDollarValue(product.hospital.inclusions.excesses.perAdmission)) || null;
                excessPerPerson = (product.hospital.inclusions.excesses.perPerson && meerkat.modules.currencyUtils.toDollarValue(product.hospital.inclusions.excesses.perPerson)) || null;
                excessPerPolicy = (product.hospital.inclusions.excesses.perPolicy && meerkat.modules.currencyUtils.toDollarValue(product.hospital.inclusions.excesses.perPolicy)) || null;
            }
            coPayment = (product.hospital.inclusions.copayment && meerkat.modules.currencyUtils.toDollarValue(product.hospital.inclusions.copayment)) || null;
        }
        return {
            "excessPerAdmission" : excessPerAdmission,
            "excessPerPerson" : excessPerPerson,
            "excessPerPolicy" : excessPerPolicy,
            "coPayment" : coPayment
        };
    }

    meerkat.modules.register('healthUtils', {
        getPrimaryCurrentPHI: getPrimaryCurrentPHI,
        getSpecialOffer: getSpecialOffer,
        getExcessesAndCoPayment: getExcessesAndCoPayment
    });

})(jQuery);
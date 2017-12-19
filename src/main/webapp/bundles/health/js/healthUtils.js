/**
 * Health Utils Module.
 * Health utilities for getting information from the form
 */
;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    /**
     * Returns the selected benefit codes
     * @param product
     * @returns {Array}
     */
    function getSelectedBenefits(productType) {
        var benefits=[];
        if (productType == 'Hospital' || productType == 'Combined') {
            $('[name="health_filterBar_benefitsHospital"]:checked').each(
                function () {
                    benefits.push(getBenefit($(this)));
                }
            );
        }
        if (productType == 'GeneralHealth' || productType == 'Combined') {
            $('[name="health_filterBar_benefitsExtras"]:checked').each(
                function(){
                    benefits.push(getBenefit($(this)));

                }
            );
        }
        return benefits;
    }

    function getBenefit(benefit) {
        return {
            "title" : benefit.attr('title'),
            "code" : benefit.val()
        };
    }

    function getSelectedHealthSituation() {
        var selectedHealthSitu = $('[name="health_situation_healthSitu"]:checked');
        var healthSituationName = null;
        var healthSituationCode = null;
        if (selectedHealthSitu.length !== 0) {
            healthSituationName = $.trim(selectedHealthSitu.parent().text());
            healthSituationCode = selectedHealthSitu.val();
        }
        return {
            "name" : healthSituationName,
            "code" : healthSituationCode
        };
    }

    function getPrimaryCurrentPHI() {
        return $('[name="health_healthCover_primary_cover"]:checked').val();
    }

    // TODO Fix this promo text regex (it doesn't match the format coming from the health quote service)
    function getSpecialOffer(product) {
        var promoText = /^(.+)<p><a class="dialogPop" data-content="(.+)" title="Conditions".+$/g.exec(product.promo.promoText);
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
        getSelectedBenefits: getSelectedBenefits,
        getSelectedHealthSituation: getSelectedHealthSituation,
        getPrimaryCurrentPHI: getPrimaryCurrentPHI,
        getSpecialOffer: getSpecialOffer,
        getExcessesAndCoPayment: getExcessesAndCoPayment
    });

})(jQuery);
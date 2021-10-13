;(function() {

    var meerkat = window.meerkat,
        hospitalQuickOptions,
        extrasQuickOptions,
        categoryData,
        rebateTiers,
        nothingSelected = "Nothing selected",
        clinicalCategories = 'CLINICAL_CATEGORIES';

    function init() {
        // this mapping is a copy of healthBenefitsQuickSelectHospital.deferred.js option var
        hospitalQuickOptions = {
            CANCER_COVER: "Cancer cover",
            CHRONIC_BACK_ISSUES: "Chronic back issues",
            EAR_NOSE_THROAT: "Ear, nose & throat",
            MEDICALLY_NECESSARY_PLASTIC_AND_RECONSTRUCTIVE_SURGERY: "Plastic and reconstructive surgery (medically necessary)",
            BONE_MUSCLE_AND_JOINT_RECONSTRUCTION: "Bone, muscle and joint reconstruction",
            JOINT_REPLACEMENT: "Joint replacement",
            PREGNANCY_COVER: "Pregnancy cover"
        };

        // this mapping is a copy of healthBenefitsCategorySelectExtras.deferred.deferred.js copyMappings var
        extrasQuickOptions = {
            SPECIFIC_COVER:             {
                title:  "Specific cover",
                body:   "Looking for a product that is very specific to your needs and lifestyle. If you know exactly what you are looking for pick and choose your preferred cover options from the list below."
            },
            POPULAR:        {
                title:  "Most popular",
                body:   "Our most commonly selected extras, covering trips to the dentist, physio and optical services."
            },
            A_LITTLE_BIT_MORE:     {
                title:  "A few more",
                body:   "Next level up of extras. Cover that includes major dental, remedial messages, chiro as well as a wide range of benefits for you to claim back on."
            },
            COMPLETE_COVER: {
                title:  "Complete cover",
                body:   "Be prepared for any moment and get cover for everything."
            }
        };

        // this mapping is a copy of healthBenefitsQuickSelectHospital.deferred.js categoryData var
        categoryData = {
            SPECIFIC_COVER:             {
                title:  "Specific cover",
                H: "Looking for a product that is very specific to your needs and lifestyle. If you know exactly what you are looking for pick and choose your preferred cover options from the list below.",
                C: "Looking for a product that is very specific to your needs and lifestyle. If you know exactly what you are looking for pick and choose your preferred cover options from the list below."
            },
            NEW_TO_HEALTH_INSURANCE:    {
                title:  "New to health insurance",
                H: "First time to health insurance? Or just wanting cover that is an entry point into private hospital cover? This cover can give you more control, like less waiting time and being treated by a doctor of your choice. It can also help you at tax time.",
                C: "First time to health insurance? Or just wanting cover that is an entry point into private hospital cover? This cover can give you more control, like less waiting time and being treated by a doctor of your choice. It can also help you at tax time. There are also options to include basic extras that you think you’ll need such as Dental and Optical."
            },
            GROWING_FAMILY:             {
                title:  "Growing family",
                H: "Got a growing family? Hospital cover for services and treatment during pregnancy, birth, and following delivery. We've preselected the typical inclusions people choose for this category below.",
                C: "Got a growing family? Hospital cover for services and treatment during pregnancy, birth, and following delivery. Plus mid-level extras for you and the kids such as Dental and Optical. We've preselected the typical inclusions people choose for this category below.",
                hideWhenSituationIs: ["SM"]
            },
            ESTABLISHED_FAMILY:         {
                title:  "Established family",
                H: "Done with needing pregnancy cover? Move to good all-round cover options for you and your family as they grow from kids to teenagers. Cover that doesn’t include pregnancy and birth services.",
                C: "Done with needing pregnancy cover? Move to good all-round cover options for you and your family as they grow from kids to teenagers. Cover that doesn’t include pregnancy and birth services. Includes mid-level extras products to support you and growing kids such as dental, optical, physio, and remedial massage.",
                hideWhenSituationIs: ["SM", "SF", "C"]
            },
            PEACE_OF_MIND:              {
                title:  "Peace of mind",
                H: "Want something that is good for all-round everyday health cover? Accidents and a range of common procedures. Cover that doesn’t include pregnancy and birth services.",
                C: "Want something that is good for all-round everyday health cover? Accidents and a range of common procedures. Cover that doesn’t include pregnancy and birth services. Includes mid-level extras products to support you such as dental, optical, physio, and remedial massage.",
                hideWhenSituationIs: ["SPF", "F"]
            },
            COMPREHENSIVE_COVER:        {
                title:  "Comprehensive cover",
                H: "Empty nest? Looking for cover tailored to you and/or your partner as the occasional ailment might arise? Cover for more of the things you need such as joint replacement, heart treatment, etc.",
                C: "Empty nest? Looking for cover tailored to you and/or your partner as the occasional ailment might arise? Cover for more of the things you need such as joint replacement, heart treatment, etc. This is option selects Higher-level hospital cover excluding pregnancy."
            },
            REDUCE_TAX:                 {
                title:  "Reduce tax",
                H: "Wanting basic hospital cover to exempt yourself from the Medicare levy surcharge? This is the entry-level or basic level of Hospital cover.",
                C: "Wanting basic hospital cover to exempt yourself from the Medicare levy surcharge? This is the entry-level or basic level of Hospital cover."
            }
        };

        rebateTiers = {
            single:[
                "$90,000 or less (Base Tier, Tier 0)",
                "$90,001 - $105,000 (Tier 1)",
                "$105,001 - $140,000 (Tier 2)",
                "$140,001+ (Tier 3 - no rebate)"
            ],
            familyOrCouple:[
                "$180,000 or less (Base Tier, Tier 0)",
                "$180,001 - $210,000 (Tier 1)",
                "$210,001 - $280,000 (Tier 2)",
                "$280,001+ (Tier 3 - no rebate)"
            ]
        };
    }

    function convertHospital(names) {
        if(!names) return nothingSelected;
        var result = "",
            namesArray = names.split(","),
            separator = namesArray && namesArray.length < 2 ? "" : ", ";
        namesArray.forEach(function (name, i) {
            result += hospitalQuickOptions[name.trim()] + (i === namesArray.length - 1 ? "" : separator);
        });
        return result;
    }

    function convertExtras(names) {
        if(!names) return nothingSelected;
        var result = "",
            namesArray = names.split(","),
            separator = namesArray && namesArray.length < 2 ? "" : ", ";
        namesArray.forEach(function (name, i) {
            result += extrasQuickOptions[name.trim()].title + (i === namesArray.length - 1 ? "" : separator);
        });
        return result;
    }

    function convertReason(names) {
        if(!names) return nothingSelected;
        var result = "",
            namesArray = names.split(","),
            separator = namesArray && namesArray.length < 2 ? "" : ", ";
        namesArray.forEach(function (name, i) {
            result += categoryData[name.trim()].title + (i === namesArray.length - 1 ? "" : separator);
        });
        return result;
    }

    function covertProductType(name) {
        return name === 'C' ? 'Hospital & Extras' : name === 'E' ? 'Extras' : 'Hospital';
    }

    function checkIfClinicalCategories(hospitalBenefitsSource) {
        return hospitalBenefitsSource === clinicalCategories;
    }

    function sortNames(benefits, benefitTypes) {
        var hospitals = [];
        var extras = [];
        if(benefitTypes && Array.isArray(benefitTypes.benefitType)) {
            hospitals = benefitTypes.benefitType.filter(function (b) {
                return b.type === 'hospital';
            }).map(function (v) {
                return v.benefit.toUpperCase();
            });
        } else if(benefitTypes && !Array.isArray(benefitTypes.benefitType)) {
            hospitals = [
                benefitTypes.benefitType.type === 'hospital' && !
                    _.isNull(benefitTypes.benefitType.benefit) && !_.isUndefined(benefitTypes.benefitType.benefit)
                    ? benefitTypes.benefitType.benefit.toUpperCase() : undefined];
        }

        if(benefitTypes && Array.isArray(benefitTypes.benefitType)) {
            extras = benefitTypes.benefitType.filter(function (b) {
                return b.type === 'extras';
            }).map(function (v) {
                return v.benefit;
            });
        } else if (benefitTypes && !Array.isArray(benefitTypes.benefitType)) {
            extras = [benefitTypes.benefitType.type === 'extras' &&
                !_.isNull(benefitTypes.benefitType.benefit) && !_.isUndefined(benefitTypes.benefitType.benefit)
                ? benefitTypes.benefitType.benefit.toUpperCase() : undefined];
        }

        if(benefits && benefits.indexOf('Hospital') !== -1) {
            hospitals.push('Hospital'.toUpperCase());
        }

        if(benefits && benefits.indexOf('GeneralHealth') !== -1) {
            extras.push('GeneralHealth');
        }

        var sortedHospitals = _.sortBy(hospitals, function (n) {
            return n;
        }).join(', ');

        var sortedExtras = _.sortBy(extras, function (n) {
            return n;
        }).join(', ');

        return (sortedHospitals ? sortedHospitals : '') + (sortedExtras ?  '; ' + sortedExtras : '');
    }

    function getRebateTiers(type, tier) {
        return !rebateTiers[type] ? null : rebateTiers[type][tier];
    }

    meerkat.modules.register('benefitsNameConverter', {
        init: init,
        convertHospital: convertHospital,
        convertExtras: convertExtras,
        convertReason: convertReason,
        covertProductType: covertProductType,
        checkIfClinicalCategories: checkIfClinicalCategories,
        sortNames: sortNames,
        getRebateTiers: getRebateTiers
    });

})(jQuery);

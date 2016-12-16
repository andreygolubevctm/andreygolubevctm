/**
 * Description: External documentation:
 */

(function($, undefined) {


    var meerkat =window.meerkat,
        _isHospital = false,
        defaultSelections = {},
        selectedElements = {
            hospital: [],
            extras: []
        },
        meerkatEvents = meerkat.modules.events,
        events = {
            benefitsModel: {
                UPDATE_SELECTED_BENEFITS_CHECKBOX: 'UPDATE_SELECTED_BENEFITS_CHECKBOX',
                BENEFITS_MODEL_UPDATE_COMPLETED: 'BENEFITS_MODEL_UPDATE_COMPLETED'
            }
        },
        moduleEvents = events.benefitsModel;

    function init() {
        _setupPreselectData();
        _eventsSubscription();
    }

    function _setupPreselectData() {
        meerkat.modules.comms.get({
            url: 'spring/content/getsupplementary',
            data: {
                vertical: 'HEALTH',
                key: 'benefitsPreselectData_v4'
            },
            cache: true,
            dataType: 'json',
            useDefaultErrorHandling: false,
            errorLevel: 'silent',
            timeout: 5000,
            onSuccess: function onSubmitSuccess(resultData) {
                _.each(resultData.supplementary, function setupDefaultSelections(obj) {
                    defaultSelections[obj.supplementaryKey] = obj.supplementaryValue.split(',');
                });
            }
        });
    }

    function _eventsSubscription() {
        // benefit selected
        meerkat.messaging.subscribe(meerkatEvents.benefits.BENEFIT_SELECTED, _updateBenefitModel);

        // clear benefits
        meerkat.messaging.subscribe(meerkatEvents.quickSelect.CLEAR_BENEFITS, _resetModel);
    }

    function _resetModel(isHospital) {
        setIsHospital(isHospital);
        setBenefits([]);
    }

    function _updateBenefitModel(options) {
        setIsHospital(options.isHospital);

        if (typeof options.removeBenefit !== 'undefined' && options.removeBenefit) {
            // removing a singular item from a user click so don't need to fire the BENEFITS_UPDATED event
            selectedElements[getBenefitType()] =  $.grep(selectedElements[getBenefitType()], function(value) {
                return value != options.benefitId;
            });
        } else {
            if (typeof options.benefitId === 'number') {
                // adding a singular item from a user click so don't need to fire the BENEFITS_UPDATED event
                selectedElements[getBenefitType()].push(options.benefitId);
            } else {
                // pre-select fired
                setBenefits(_.union(selectedElements[getBenefitType()], options.benefitIds));
            }
        }

        meerkat.messaging.publish(moduleEvents.BENEFITS_MODEL_UPDATE_COMPLETED);
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
        meerkat.messaging.publish(moduleEvents.UPDATE_SELECTED_BENEFITS_CHECKBOX, selectedElements[getBenefitType()]);
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
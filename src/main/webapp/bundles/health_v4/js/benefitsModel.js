/**
 * Description: External documentation:
 */

(function ($, undefined) {


    var meerkat = window.meerkat,
        _isHospital = false,
        defaultSelections = {},
        selectedBenefits = {
            hospital: [],
            extras: []
        },
        benefitsLabels = {},
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

    // do an ajax request to retrieve the supplementary data for the health pre-select data
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

    // clear the model for hospital or extras
    function _resetModel(isHospital) {
        setIsHospital(isHospital);
        setBenefits([]);
    }

    // update the benefit model depending on the type of click scenario
    // 1. remove an item from the selectedBenefits array
    // 2. add an item from the selectedBenefits array
    // 3. pre-select some benefits
    function _updateBenefitModel(options) {
        setIsHospital(options.isHospital);

        if (typeof options.removeBenefit !== 'undefined' && options.removeBenefit) {
            // removing a singular item from a user click so don't need to fire the BENEFITS_UPDATED event
            selectedBenefits[getBenefitType()] = selectedBenefits[getBenefitType()].filter(function removeItemFromModel(value) {
                return value != options.benefitId;
            });
        } else {
            if (typeof options.benefitId === 'number') {
                // adding a singular item from a user click so don't need to fire the BENEFITS_UPDATED event
                selectedBenefits[getBenefitType()].push(options.benefitId);
            } else {
                // pre-select fired
                setBenefits(_.union(selectedBenefits[getBenefitType()], options.benefitIds));
            }
        }

        meerkat.messaging.publish(moduleEvents.BENEFITS_MODEL_UPDATE_COMPLETED);
    }

    // return a string of hospital or events depending on value of _isHospital
    function getBenefitType() {
        return _isHospital ? 'hospital' : 'extras';
    }

    // return an array of the default selected ids
    function getDefaultSelections(selectType) {
        return defaultSelections[selectType];
    }

    // return an array of the hospital selected extras ids
    function getExtras() {
        return selectedBenefits.extras;
    }

    // return the number of selected extras benefits
    function getExtrasCount() {
        return selectedBenefits.extras.length;
    }

    // return an array of the hospital selected hospital ids
    function getHospital() {
        return selectedBenefits.hospital;
    }

    // return the number of selected hospital benefits
    function getHospitalCount() {
        return selectedBenefits.hospital.length;
    }

    // set the selected benefits for hospital/extras AND fire off the UPDATE_SELECTED_BENEFITS_CHECKBOX event
    function setBenefits(updatedBenefits) {
        selectedBenefits[getBenefitType()] = updatedBenefits;
        meerkat.messaging.publish(moduleEvents.UPDATE_SELECTED_BENEFITS_CHECKBOX, selectedBenefits[getBenefitType()]);
    }

    // run once to initialise labels store.
    function initBenefitLabelStore(benefits) {
        benefitsLabels = benefits;
    }

    // get all the selected benefits
    function getSelectedBenefits() {
        return selectedBenefits.hospital.concat(selectedBenefits.extras);
    }

    function getHospitalBenefitsForFilters() {
        return benefitsLabels.hospital;
    }

    function getExtrasBenefitsForFilters() {
        return benefitsLabels.extras;
    }

    function setIsHospital(isHospital) {
        _isHospital = isHospital;
    }

    function isSelected(id) {
        var benefits = getSelectedBenefits();
        return _.contains(benefits, id);
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
        setIsHospital: setIsHospital,
        getSelectedBenefits: getSelectedBenefits,
        initBenefitLabelStore: initBenefitLabelStore,
        getExtrasBenefitsForFilters: getExtrasBenefitsForFilters,
        getHospitalBenefitsForFilters: getHospitalBenefitsForFilters,
        isSelected: isSelected
    });

})(jQuery);
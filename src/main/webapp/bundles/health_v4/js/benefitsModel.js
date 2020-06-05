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
        flattenedBenefits = [],
        meerkatEvents = meerkat.modules.events,
        selectedHospitalLabel,
        selectedExtrasLabel,
        snapshotSelectedHospitalLabel,
        snapshotSelectedExtrasLabel,
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

        selectedHospitalLabel = $('#selected-hospital-count');
        selectedExtrasLabel = $('#selected-extras-count');

        snapshotSelectedHospitalLabel = $('.snapshot-benefits-selected');
        snapshotSelectedExtrasLabel = $('.snapshot-extras-selected');
    }

    // do an ajax request to retrieve the supplementary data for the health pre-select data
    function _setupPreselectData() {
        meerkat.modules.comms.get({
            url: 'spring/content/getsupplementary.json',
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

        meerkat.messaging.publish(moduleEvents.BENEFITS_MODEL_UPDATE_COMPLETED);
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
            // has one benefit
            if (options.benefitId) {
                // adding a singular item from a user click so don't need to fire the BENEFITS_UPDATED event
                selectedBenefits[getBenefitType()].push(options.benefitId);
            } else {
                // pre-select fired on an array of benefitIds
                setBenefits(_.union(selectedBenefits[getBenefitType()], options.benefitIds));
            }
        }

        updateUIElements();

        meerkat.messaging.publish(moduleEvents.BENEFITS_MODEL_UPDATE_COMPLETED);
    }

    function updateUIElements() {
        var selectedHospitalCount = selectedBenefits.hospital.length;
        var selectedExtrasCount = selectedBenefits.extras.length;

        selectedHospitalLabel.text(selectedHospitalCount + ' selected');
        selectedExtrasLabel.text(selectedExtrasCount + ' selected');

        snapshotSelectedHospitalLabel.text(selectedHospitalCount + ' Hospital benefit' + (selectedHospitalCount !== 1 ? 's' : '') + ' selected');
        snapshotSelectedExtrasLabel.text(selectedExtrasCount + ' Extra' + (selectedExtrasCount !== 1 ? 's' : '') + ' selected');

        $('.categoriesCell_v2').each(function() {
            $(this).removeClass('active');

            var input = $(this).children()[0].firstElementChild;
            if(selectedBenefits.hospital.indexOf(input.dataset.benefitId) > -1 || 
                selectedBenefits.extras.indexOf(input.dataset.benefitId) > -1) {
                    $(this).addClass('active');
            }
        });
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

        updateUIElements();
    }

    // run once to initialise labels store.
    function initBenefitLabelStore(benefits) {
        benefitsLabels = benefits;
        flattenedBenefits = benefits.hospital.concat(benefits.extras);
    }

    // get all the selected benefits
    function getSelectedBenefits() {
        return selectedBenefits.hospital.concat(selectedBenefits.extras);
    }

    // For each selected benefit, return its code e.g. PrHospital
    // This is used for email brochures as well.
    function getCodesForSelectedBenefits() {
        var selectedBenefits = getSelectedBenefits();
        var codes = [];
        for (var i = 0; i < selectedBenefits.length; i++) {
            codes.push(_getBenefitObjectById(selectedBenefits[i]).code);
        }
        return codes;
    }

    function _getBenefitObjectById(benefitId) {

        for (var i = 0; i < flattenedBenefits.length; i++) {
            if (flattenedBenefits[i].id == benefitId) {
                return flattenedBenefits[i];
            }
        }
        return {};
    }

    /**
     * Returns an array of objects in the form:
     * { id: 31265
     * label: "Private Hospital"
     * selected:true
     * value:31265 }
     * @returns {Array}
     */
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
        isSelected: isSelected,
        getCodesForSelectedBenefits: getCodesForSelectedBenefits
    });

})(jQuery);
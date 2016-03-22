;(function ($) {

    var $component;

    function init() {
        $(document).ready(function() {
            $component = $("#resultsPage");
        });
    }

    // Change the results templates to promote features to the 'selected' features row.

    function onBenefitsSelectionChange(selectedBenefits, callback) {
        meerkat.modules.healthResults.setSelectedBenefitsList(selectedBenefits);

        // when hospital is set to off in [Customise Cover] hide the excess section
        var $excessSection = $component.find('.cell.excessSection');
        _.contains(selectedBenefits, 'Hospital') ? $excessSection.show() : $excessSection.hide();

        // If on the results step, reload the results data. Can this be more generic?
        if (typeof callback === 'undefined') {
            if (meerkat.modules.journeyEngine.getCurrentStepIndex() === meerkat.modules.healthResults.resultsStepIndex) {
                getResultsAndIncrementTransactionId();
            }
        } else {
            callback();
        }

    }

    function onFilterChange(obj) {
        if (obj && obj.hasOwnProperty('filter-frequency-change')) {
            meerkat.modules.resultsTracking.setResultsEventMode('Refresh'); // Only for events that dont cause a new TranId
        } else {
            // This is a little dirty however we need to temporarily override the
            // setting which prevents the tranId from being incremented.
            // Object only has value in above case, otherwise empty
            getResultsAndIncrementTransactionId();
        }
    }

    function getResultsAndIncrementTransactionId() {
        Results.settings.incrementTransactionId = true;
        meerkat.modules.healthResults.get();
        Results.settings.incrementTransactionId = false;
    }

    meerkat.modules.register('healthResultsChange', {
        init: init,
        events: moduleEvents,
        onBenefitsSelectionChange: onBenefitsSelectionChange,
        onFilterChange : onFilterChange
    });

})(jQuery);
;(function ($, undefined) {

    var meerkat = window.meerkat,
        $elements = {},
        _mustShowList = [
            "gmhba",
            "frank",
            "budget direct",
            "bupa",
            "hif",
            "qchf",
            "navy health",
            "tuh",
            "myown",
            "nib",
            "qantas"
        ];

    function initHealthMedicare() {
        _setupFields();
        _applyEventListeners();
    }

    function _setupFields() {
        $elements = {
            appFirstname: $('#health_application_primary_firstname'),
            appMiddleName: $('#health_application_primary_middleName'),
            appSurname: $('#health_application_primary_surname'),
            medFirstname: $('#health_payment_medicare_firstName'),
            medMiddleName: $('#health_payment_medicare_middleName'),
            medSurname: $('#health_payment_medicare_surname'),
            selectionNestedGroups: $('#health_payment_medicare-selection > .nestedGroup')
        };
    }

    function onBeforeEnterApply() {
        _prepopulateNameFields();
        _updateMedicareLabel();
        _toggleSelectionNestedGroups();
    }

    // Did think of moving healthApplyStep.js in health_v2 but it had some dependancies that exist only in v2
    function _updateMedicareLabel() {
        $('#medicare_group').find('label:first').text('IRN');
    }

    function _applyEventListeners() {
        /* ONLY need to forward update the firstname/surname to the medicare fields
         if the medicare field is empty - otherwise ignore. Definitely no more
         reverse updating the primary user from the medicare fields.
         */
        $elements.appFirstname.add($elements.appSurname).on('change', function syncApplicationPageNames() {
            _prepopulateNameFields();
        });
    }

    function _prepopulateNameFields() {
        $elements.medFirstname.val($elements.appFirstname.val());
        $elements.medMiddleName.val($elements.appMiddleName.val());
        $elements.medSurname.val($elements.appSurname.val());
    }

    function _toggleSelectionNestedGroups() {
        var product = meerkat.modules.healthResults.getSelectedProduct(),
            toggle = !meerkat.modules.healthRebate.isRebateApplied() && $.inArray(product.info.providerName.toLowerCase(), _mustShowList) === -1;

        $elements.selectionNestedGroups.toggleClass('hidden', toggle);
    }

    meerkat.modules.register("healthMedicare", {
        initHealthMedicare: initHealthMedicare,
        onBeforeEnterApply: onBeforeEnterApply
    });

})(jQuery);

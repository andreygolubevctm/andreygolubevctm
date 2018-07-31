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
            "nib"
        ];

    function initHealthMedicare() {
        _setupFields();
        _applyEventListeners();
    }

    function _setupFields() {
        $elements = {
            appFirstname: $('#health_application_primary_firstname'),
            appSurname: $('#health_application_primary_surname'),
            medFirstname: $('#health_payment_medicare_firstName'),
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
        var currentProduct = Results.getSelectedProduct().info.FundCode,
            $medicareLabel = $('#medicare_group').find('label:first');

        if (currentProduct === 'NHB' || currentProduct === 'QCH') {
            $medicareLabel.text('Position and name on Medicare card');
        } else {
            $medicareLabel.text('Name on Medicare card');
        }
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
        if (_.isEmpty($elements.medFirstname.val())) {
            $elements.medFirstname.val($elements.appFirstname.val());
        }

        if (_.isEmpty($elements.medSurname.val())) {
            $elements.medSurname.val($elements.appSurname.val());
        }
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
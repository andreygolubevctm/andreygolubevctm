;(function ($, undefined) {

    var meerkat = window.meerkat,
        nameFields = {};


    function initHealthMedicare() {
        _setupFields();
        _applyEventListeners();
    }

    function _setupFields() {
        nameFields.appFirstname = $('#health_application_primary_firstname');
        nameFields.appSurname = $('#health_application_primary_surname');
        nameFields.medFirstname = $('#health_payment_medicare_firstName');
        nameFields.medSurname = $('#health_payment_medicare_surname');
    }

    // Did think of moving healthApplyStep.js in health_v2 but it had some dependancies that exist only in v2
    function updateMedicareLabel(){

        var currentProduct = Results.getSelectedProduct().info.FundCode,
            $medicareLabel = $('#medicare_group').find('label:first');

        if (currentProduct === 'NHB' || currentProduct === 'QCH') {
            $medicareLabel.text('Position and name on Medicare card');
        } else {
            $medicareLabel.text('Name on Medicare card');
        }
    }

    function _applyEventListeners(){
        nameFields.appFirstname.add(nameFields.appSurname).add(nameFields.medFirstname).add(nameFields.medSurname).on('change', function syncApplicationPageNames(e) {
            if ($(e.target).attr('id') === 'health_application_primary_firstname' || $(e.target).attr('id') === 'health_application_primary_surname') {
                nameFields.medFirstname.val(nameFields.appFirstname.val());
                nameFields.medSurname.val(nameFields.appSurname.val());
            } else {
                nameFields.appFirstname.val(nameFields.medFirstname.val());
                nameFields.appSurname.val(nameFields.medSurname.val());
            }
        });
    }

    meerkat.modules.register("healthMedicare", {
        initHealthMedicare: initHealthMedicare,
        updateMedicareLabel: updateMedicareLabel
    });

})(jQuery);
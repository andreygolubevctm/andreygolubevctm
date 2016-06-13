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
        /* ONLY need to forward update the firstname/surname to the medicare fields
            if the medicare field is empty - otherwise ignore. Definitely no more
            reverse updating the primary user from the medicare fields.
         */
        nameFields.appFirstname.add(nameFields.appSurname).on('change', function syncApplicationPageNames(e) {
            var names = {
                    medi : {
                        first: nameFields.medFirstname.val(),
                        last: nameFields.medSurname.val()
                    },
                    prim : {
                        first: nameFields.appFirstname.val(),
                        last: nameFields.appSurname.val()
                    }
            };
            if(_.isEmpty(names.medi.first)) {
                nameFields.medFirstname.val(names.prim.first);
            }
            if(_.isEmpty(names.medi.last)) {
                nameFields.medSurname.val(names.prim.last);
            }
        });
    }

    meerkat.modules.register("healthMedicare", {
        initHealthMedicare: initHealthMedicare,
        updateMedicareLabel: updateMedicareLabel
    });

})(jQuery);
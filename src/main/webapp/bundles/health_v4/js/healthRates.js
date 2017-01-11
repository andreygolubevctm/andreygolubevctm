;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        moduleEvents = {
            healthRates: {}
        },
        rates = null;

    function loadRatesBeforeResultsPage(forceRebate, callback) {

        var $healthCoverDetails = $('#startForm');

        var postData = {
            dependants: meerkat.modules.healthRebate.getDependents(),
            income: $healthCoverDetails.find(':input[name="health_healthCover_income"]').val() || 0,
            rebate_choice: forceRebate === true ? 'Y' : $healthCoverDetails.find('input[name="health_healthCover_rebate"]').val(),
            primary_dob: $healthCoverDetails.find('#health_healthCover_primary_dob').val(),
            primary_loading: $healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: $healthCoverDetails.find('input[name="health_healthCover_primary_cover"]:checked').val(),
            primary_loading_manual: $healthCoverDetails.find('.primary-lhc').val(),
            cover: meerkat.modules.healthSituation.getSituation()
        };

        // If the customer answers Yes for current health insurance, assume 0% LHC
        if (postData.primary_current === 'Y' && postData.primary_loading !== 'N') {
            postData.primary_loading = 'Y';
        }

        if (meerkat.modules.healthRebate.hasPartner()) {
            var $partnerCoverDetails = $('#benefitsForm');
            postData.partner_dob = $partnerCoverDetails.find('input[name="health_healthCover_partner_dob"]').val();
            postData.partner_current = $partnerCoverDetails.find('input[name="health_healthCover_partner_health_cover"]:checked').val() || 'N';
            postData.partner_loading = $partnerCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val() || 'N';
            postData.partner_loading_manual = $partnerCoverDetails.find('input[name="health_healthCover_partner_lhc"]').val();
        }

        if (!fetchRates(postData, true, callback)) {
            exception("Failed to fetch rates");
        }
    }

// Load the rates object via ajax. Also validates currently filled in fields to ensure only valid attempts are made.
    function loadRates(callback) {

        var $healthCoverDetails = $('#startForm');

        var postData = {
            dependants: meerkat.modules.healthRebate.getDependents(),
            income: $healthCoverDetails.find(':input[name="health_healthCover_income"]').val() || 0,
            rebate_choice: $healthCoverDetails.find('input[name="health_healthCover_rebate"]').val(),
            primary_dob: $healthCoverDetails.find('#health_healthCover_primary_dob').val(),
            primary_loading: $healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: $healthCoverDetails.find('input[name="health_healthCover_health_cover"]:checked').val(),
            primary_loading_manual: $healthCoverDetails.find('.primary-lhc').val(),
            partner_dob: $('#health_healthCover_partner_dob').val(),
            partner_loading: $('#benefitsForm').find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val(),
            partner_current: $('#benefitsForm').find('input[name="health_healthCover_partner_health_cover"]:checked').val(),
            partner_loading_manual: $('#benefitsForm').find('.partner-lhc').val(),
            cover: meerkat.modules.healthSituation.getSituation()
        };

        var applicationFields = $('#health_application_provider, #health_application_productId').val();
        if (typeof applicationFields !== 'undefined' && applicationFields !== '') {
            // in application stage
            postData.primary_dob = $('#health_application_primary_dob').val();
            postData.partner_dob = $('#health_application_partner_dob').val() || postData.primary_dob;  // must default, otherwise fetchRates fails.
            postData.primary_current = ( meerkat.modules.healthPreviousFund.getPrimaryFund() == 'NONE' ) ? 'N' : 'Y';
            postData.partner_current = ( meerkat.modules.healthPreviousFund.getPartnerFund() == 'NONE' ) ? 'N' : 'Y';

        }

        if (!fetchRates(postData, true, callback)) {
            exception("Failed to Fetch Health Rebate Rates");
        }
    }

    function fetchRates(postData, canSetRates, callback) {
        // Check if there is enough data to ask the server.
        var coverTypeHasPartner = meerkat.modules.healthRebate.hasPartner();
        if (postData.cover === '') return false;
        if (postData.rebate_choice === '') return false;
        if (postData.primary_dob === '') return false;
        if (coverTypeHasPartner && postData.partner_dob === '')  return false;

        if (meerkat.modules.age.returnAge(postData.primary_dob) < 0) return false;
        if (coverTypeHasPartner && meerkat.modules.age.returnAge(postData.partner_dob) < 0)  return false;
        if (postData.rebate_choice === "Y" && postData.income === "") return false;

        // check in valid date format
        var dateRegex = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;

        if (!postData.primary_dob.match(dateRegex)) return false;
        if (coverTypeHasPartner && !postData.partner_dob.match(dateRegex))  return false;

        return meerkat.modules.comms.post({
            url: "ajax/json/health_rebate.jsp",
            data: postData,
            cache: true,
            errorLevel: "warning",
            onSuccess: function onRatesSuccess(data) {
                if (canSetRates === true) setRates(data);
                if (!_.isNull(callback) && typeof callback !== 'undefined') {
                    callback(data);
                }
            }
        });

    }

    // Make the rates object available outside of this module.
    function getRates() {
        return rates;
    }

    // Make the rebate available publicly, and handle rates property being null.
    function getRebate() {
        if (!_.isNull(rates) && rates.rebate) {
            return rates.rebate;
        }
        else {
            return 0;
        }
    }

    // Set the rates object and hidden fields in the form so it is included in post data.
    function setRates(ratesObject) {
        rates = ratesObject;
        $("#health_rebate").val((rates.rebate || ''));
        $("#health_rebateChangeover").val((rates.rebateChangeover || ''));
        $("#health_loading").val((rates.loading || ''));
        $("#health_primaryCAE").val((rates.primaryCAE || ''));
        $("#health_partnerCAE").val((rates.partnerCAE || ''));

        meerkat.modules.healthResults.setLhcApplicable(rates.loading);
    }

    meerkat.modules.register("healthRates", {
        events: moduleEvents,
        getRates: getRates,
        setRates: setRates,
        getRebate: getRebate,
        fetchRates: fetchRates,
        loadRates: loadRates,
        loadRatesBeforeResultsPage: loadRatesBeforeResultsPage
    });

})(jQuery);
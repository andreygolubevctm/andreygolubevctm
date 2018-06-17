;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        moduleEvents = {
            healthRates: {}
        },
        rates = null,
        ratesAjaxObj = null,
        $elements = {};

    function init() {
        _setupFields();
    }

    function _setupFields() {
        $elements = {
            income: $(':input[name="health_healthCover_income"]'),
            rebate: $('input[name="health_healthCover_rebate"]'),
            primaryDob: $('#health_healthCover_primary_dob'),
            primaryAppDob: $('#health_application_primary_dob'),
            primaryLoading: $('input[name="health_healthCover_primary_healthCoverLoading"]'),   //this is/was the have you had continuous cover question?  (it was doing if yes 0% else full LHC)
            primaryCurrent: $('input[name="health_healthCover_primary_cover"]'),                //this is/was the have you had any kind of health cover question that was always treated as if it was do you have HOSPITAL cover question!
            primaryLoadingManual: $('.primary-lhc'),
            partnerDob: $('#health_healthCover_partner_dob'),
            partnerAppDob: $('#health_application_partner_dob'),
            partnerLoading: $('input[name="health_healthCover_partner_healthCoverLoading"]'),   //this is/was the have you had continuous cover question?  (it was doing if yes 0% else full LHC)
            partnerCurrent: $('input[name="health_healthCover_partner_cover"]'),                //this is/was the have you had any kind of health cover question that was always treated as if it was do you have HOSPITAL cover question!
            partnerLoadingManual: $('input[name="health_healthCover_partner_lhc"]'),
            dependants: $('#health_healthCover_dependants'),
            searchDate: $('#health_searchDate')
        };

        if(meerkat.site.isNewQuote === false) {
            $elements.income.trigger('change');
        }
    }

    function loadRatesBeforeResultsPage(forceRebate, callback) {
        _.defer(function(){

            var oldPrimaryObj,
                oldPrimaryEverHadAnyCoverEquivalent,
                oldPrimaryContinuousCoverEquivalent,
                oldPartnerObj,
                oldPartnerEverHadAnyCoverEquivalent,
                oldPartnerContinuousCoverEquivalent;

            oldPrimaryObj = _getPrimary_EverHadAnyCover_and_ContinuousCover_Equivalent();
            oldPartnerObj = _getPartner_EverHadAnyCover_and_ContinuousCover_Equivalent();
            oldPrimaryEverHadAnyCoverEquivalent = oldPrimaryObj.oldEverHadAnyCoverEquivalent;
            oldPrimaryContinuousCoverEquivalent = oldPrimaryObj.oldContinuousCoverEquivalent;
            oldPartnerEverHadAnyCoverEquivalent = oldPartnerObj.oldEverHadAnyCoverEquivalent;
            oldPartnerContinuousCoverEquivalent = oldPartnerObj.oldContinuousCoverEquivalent;

            var postData = {
                dependants: $elements.dependants.val(),
                income: $elements.income.val() || 0,
                rebate_choice: forceRebate === true ? 'Y' : $elements.rebate.filter(':checked').val(),
                primary_dob: $elements.primaryDob.val(),
                primary_loading: oldPrimaryContinuousCoverEquivalent,
                primary_current: oldPrimaryEverHadAnyCoverEquivalent,
                primary_loading_manual: $elements.primaryLoadingManual.val(),
                cover: meerkat.modules.healthSituation.getSituation()
            };

            // If the customer answers Yes for current health insurance, assume 0% LHC
            if (postData.primary_current === 'Y' && postData.primary_loading !== 'N') {
                postData.primary_loading = 'Y';
            }

            if (meerkat.modules.healthRebate.hasPartner() && !_.isEmpty($elements.partnerDob.val())) {
                postData.partner_dob = $elements.partnerDob.val();
                postData.partner_current = oldPartnerEverHadAnyCoverEquivalent || 'N';
                postData.partner_loading = oldPartnerContinuousCoverEquivalent || 'N';
                postData.partner_loading_manual = $elements.partnerLoadingManual.val();
            }

            fetchRates(postData, true, callback);
        });
    }

    // this is to make this meerkat module compatible with the new fields as a temp fix
    function _getPrimary_EverHadAnyCover_and_ContinuousCover_Equivalent() {

        var oldEverHadAnyCoverEquivalent,
            oldContinuousCoverEquivalent;

        var currentlyHaveAnyKindOfCoverApplyPage_primary = $('#health_application_health_cover').find('input').filter(':checked').val();
        var everHadPrivateHospital_1_primary = $(':input[name=health_healthCover_primary_everHadCover]').filter(':checked').val();
        var healthContinuousCover_primary = $(':input[name=health_healthCover_primary_healthCoverLoading]').filter(':checked').val();

        if ((currentlyHaveAnyKindOfCoverApplyPage_primary === 'N' && everHadPrivateHospital_1_primary === 'Y') || (currentlyHaveAnyKindOfCoverApplyPage_primary === 'Y' && healthContinuousCover_primary === 'N')) {
            //Full LHC  (use Calc)  Pass Fund Data
            oldEverHadAnyCoverEquivalent = 'Y';
            oldContinuousCoverEquivalent = 'N';
        } else if (currentlyHaveAnyKindOfCoverApplyPage_primary === 'Y' && healthContinuousCover_primary === 'Y') {
            //LHC 0%
            oldEverHadAnyCoverEquivalent = 'Y';
            oldContinuousCoverEquivalent = 'Y';
        } else if (currentlyHaveAnyKindOfCoverApplyPage_primary === 'N' && everHadPrivateHospital_1_primary === 'N') {
            //Full LHC        (use Calc)  Dont pass fund data

            oldEverHadAnyCoverEquivalent = 'N';
            //oldContinuousCoverEquivalent = UNDEFINED
        } else {
            //pre-results
            //treat it as full results
            oldEverHadAnyCoverEquivalent = 'Y';
            oldContinuousCoverEquivalent = 'N';
        }

        return {"oldEverHadAnyCoverEquivalent": oldEverHadAnyCoverEquivalent, "oldContinuousCoverEquivalent" : oldContinuousCoverEquivalent };
    }

    function _getPartner_EverHadAnyCover_and_ContinuousCover_Equivalent() {
        var oldEverHadAnyCoverEquivalent,
            oldContinuousCoverEquivalent;

        var currentlyHaveAnyKindOfCoverApplyPage_partner = $('#health_application_partner_health_cover').find('input').filter(':checked').val();
        var everHadPrivateHospital_1_partner = $(':input[name=health_healthCover_partner_everHadCover]').filter(':checked').val();
        var healthContinuousCover_partner = $(':input[name=health_healthCover_partner_healthCoverLoading]').filter(':checked').val();

        if ((currentlyHaveAnyKindOfCoverApplyPage_partner === 'N' && everHadPrivateHospital_1_partner === 'Y') || (currentlyHaveAnyKindOfCoverApplyPage_partner === 'Y' && healthContinuousCover_partner === 'N')) {
            //Full LHC  (use Calc)  Pass Fund Data
            oldEverHadAnyCoverEquivalent = 'Y';
            oldContinuousCoverEquivalent = 'N';
        } else if (currentlyHaveAnyKindOfCoverApplyPage_partner === 'Y' && healthContinuousCover_partner === 'Y') {
            //LHC 0%
            oldEverHadAnyCoverEquivalent = 'Y';
            oldContinuousCoverEquivalent = 'Y';
        } else if (currentlyHaveAnyKindOfCoverApplyPage_partner === 'N' && everHadPrivateHospital_1_partner === 'N') {
            //Full LHC        (use Calc)  Dont pass fund data
            oldEverHadAnyCoverEquivalent = 'N';
            //oldContinuousCoverEquivalent = UNDEFINED
        } else {
            //pre-results
            //treat it as full results
            oldEverHadAnyCoverEquivalent = 'Y';
            oldContinuousCoverEquivalent = 'N';
        }

        return {"oldEverHadAnyCoverEquivalent": oldEverHadAnyCoverEquivalent, "oldContinuousCoverEquivalent" : oldContinuousCoverEquivalent };
    }

// Load the rates object via ajax. Also validates currently filled in fields to ensure only valid attempts are made.
    function loadRates(callback) {
        _.defer(function() {

            var oldPrimaryObj,
                oldPrimaryEverHadAnyCoverEquivalent,
                oldPrimaryContinuousCoverEquivalent,
                oldPartnerObj,
                oldPartnerEverHadAnyCoverEquivalent,
                oldPartnerContinuousCoverEquivalent;

            oldPrimaryObj = _getPrimary_EverHadAnyCover_and_ContinuousCover_Equivalent();
            oldPartnerObj = _getPartner_EverHadAnyCover_and_ContinuousCover_Equivalent();
            oldPrimaryEverHadAnyCoverEquivalent = oldPrimaryObj.oldEverHadAnyCoverEquivalent;
            oldPrimaryContinuousCoverEquivalent = oldPrimaryObj.oldContinuousCoverEquivalent;
            oldPartnerEverHadAnyCoverEquivalent = oldPartnerObj.oldEverHadAnyCoverEquivalent;
            oldPartnerContinuousCoverEquivalent = oldPartnerObj.oldContinuousCoverEquivalent;

            var postData = {
                dependants: $elements.dependants.val(),
                income: $elements.income.val() || 0,
                rebate_choice: $elements.rebate.filter(':checked').val(),
                primary_dob: $elements.primaryDob.val(),
                primary_loading: oldPrimaryContinuousCoverEquivalent,
                primary_current: oldPrimaryEverHadAnyCoverEquivalent,
                primary_loading_manual: $elements.primaryLoadingManual.val(),
                cover: meerkat.modules.healthSituation.getSituation()
            };

            if (meerkat.modules.healthRebate.hasPartner() && !_.isEmpty($elements.partnerDob.val())) {
                postData.partner_dob = $elements.partnerDob.val();
                postData.partner_current = oldPartnerEverHadAnyCoverEquivalent || 'N';
                postData.partner_loading = oldPartnerContinuousCoverEquivalent || 'N';
                postData.partner_loading_manual = $elements.partnerLoadingManual.val();
            }

            var applicationFields = $('#health_application_provider, #health_application_productId').val();
            if (typeof applicationFields !== 'undefined' && applicationFields !== '') {
                // in application stage
                postData.primary_dob = $elements.primaryAppDob.val();
                postData.partner_dob = $elements.partnerAppDob.val() || postData.primary_dob;  // must default, otherwise fetchRates fails.
                postData.primary_current = ( meerkat.modules.healthPreviousFund.getPrimaryFund() == 'NONE' ) ? 'N' : 'Y';
                postData.partner_current = ( meerkat.modules.healthPreviousFund.getPartnerFund() == 'NONE' ) ? 'N' : 'Y';

            }

            fetchRates(postData, true, callback);
        });
    }

    function fetchRates(postData, canSetRates, callback) {
        // Check if there is enough data to ask the server.
        var coverTypeHasPartner = meerkat.modules.healthRebate.hasPartner() && !_.isEmpty($elements.partnerDob.val());
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

        postData.commencementDate = null;
        var commencementDate = meerkat.modules.healthCoverStartDate.getVal();
        var searchDate = $elements.searchDate.val();
        if(!_.isEmpty(commencementDate)) {
            postData.commencementDate = commencementDate;
        } else if (!_.isEmpty(searchDate)) {
            postData.commencementDate = searchDate;
        }

        if(!_.isNull(ratesAjaxObj) && _.isObject(ratesAjaxObj) && _.has(ratesAjaxObj,"abort")) {
            ratesAjaxObj.abort();
        }

        ratesAjaxObj = meerkat.modules.comms.post({
            url: "ajax/json/health_rebate.jsp",
            data: postData,
            cache: true,
            errorLevel: "warning",
            onSuccess: function onRatesSuccess(data) {
                if (canSetRates === true) setRates(data);
                if (!_.isNull(callback) && typeof callback !== 'undefined') {
                    callback(data);
                }
                // Update snapshot with latest rates
                meerkat.messaging.publish(meerkat.modules.events.health.SNAPSHOT_FIELDS_CHANGE);
            },
            onError: function onRatesError() {
                meerkat.modules.healthRates.setRatesAjaxObj(null);
                exception("Failed to Fetch Health Rebate Rates");
            },
            onComplete: function onRatesComplete() {
                meerkat.modules.healthRates.setRatesAjaxObj(null);
            }
        });

        return ratesAjaxObj;
    }

    function setRatesAjaxObj(obj) {
        ratesAjaxObj = obj;
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
        rates = $.extend(true, {}, ratesObject);
        $("#health_rebate").val((rates.rebate || ''));
        $("#health_rebateChangeover").val((rates.rebateChangeover || ''));
        $("#health_previousRebate").val((rates.previousRebate || ''));
        $("#health_loading").val(!_.isNull(meerkat.modules.healthLHC.getNewLHC()) ? meerkat.modules.healthLHC.getNewLHC() : (rates.loading || ''));
        $("#health_primaryCAE").val((rates.primaryCAE || ''));
        $("#health_partnerCAE").val((rates.partnerCAE || ''));

        meerkat.modules.healthResults.setLhcApplicable(rates.loading);
    }

    function unsetRebate() {
        if(_.isEmpty(rates)) rates = {};
        rates.rebate = "0";
        rates.rebateChangeover = "0";
        rates.previousRebate = "0";
        setRates(rates);
        $("#health_rebate").val(rates.rebate);
        $("#health_rebateChangeover").val(rates.rebateChangeover);
        $("#health_previousRebate").val(rates.previousRebate);
    }

    meerkat.modules.register("healthRates", {
        init: init,
        events: moduleEvents,
        getRates: getRates,
        setRates: setRates,
        getRebate: getRebate,
        unsetRebate: unsetRebate,
        fetchRates: fetchRates,
        loadRates: loadRates,
        loadRatesBeforeResultsPage: loadRatesBeforeResultsPage,
        setRatesAjaxObj: setRatesAjaxObj
    });

})(jQuery);
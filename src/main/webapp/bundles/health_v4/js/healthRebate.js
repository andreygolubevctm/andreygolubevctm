/**
 * Description: Health setup
 */
;(function ($, undefined) {


    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        log = meerkat.logging.info;

    var moduleEvents = {
        health: {},
        WEBAPP_LOCK: 'WEBAPP_LOCK',
        WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
    },
    rates = null,
    $elements = {};

    function init() {
        _setupFields();
        _eventSubscriptions();

        meerkat.modules.healthTiers.initHealthTiers();
        meerkat.modules.healthTiers.setTiers(true);
    }

    function _setupFields() {
        $elements = {
            situationSelect: $('input[name=health_situation_healthCvr]'),
            applyRebate: $('#health_healthCover_rebate'),
            incomeSelectContainer: $('#income_container'),
            lhcContainers: $('.health-cover, #health_healthCover_primaryCover'),
            incomeSelect: $('#health_healthCover_income'),
            selectedRebateText: $('#selectedRebateText'),
            rebateLabel: $('#rebateLabel'),
            editTier: $('.editTier'),
            rebateLegend: $('#health_healthCover_tier_row_legend'),
            healthCoverDetails: $('#startForm')
        };
    }

    function _eventSubscriptions() {
        $(':input[name="health_situation_healthCvr"], #health_healthCover_rebate').on('change', function updateRebateTiers(){
            meerkat.modules.healthChoices.setCover($elements.situationSelect.filter(':checked').val());
            meerkat.modules.healthTiers.setTiers();
        });

        $elements.applyRebate.on('change', function toggleRebateDropdown(){
            $elements.incomeSelectContainer.toggleClass('hidden', !$(this).is(':checked'));
        });

        $elements.editTier.off().on('click', function showTierDropdown(){
            $elements.selectedRebateText.hide();
            $elements.rebateLabel.hide();
            $elements.incomeSelect.parent('.select').removeClass('hidden');
        });

        // update the lhc message. used lhcElements for now as the questions have changed dramatically
        $elements.lhcContainers.find(':input').on('change', function updateRebateContinuousCover(event) {

            var $this = $(this);

            // update rebate
            if ($this.valid()) {
                _setRebate();
            }
        });
    }

    function updateSelectedRebateLabel() {
        // on first load, select the dropdown value and set it as a text label
        var $elDropdownOption =  $elements.incomeSelect.prop('selectedIndex') === 0 ? $elements.incomeSelect.find('option:eq(1)') : $elements.incomeSelect.find(':selected'),
            completeText = '',
            dependantsText = 'including any adjustments for your dependants',
            cover = meerkat.modules.healthChoices.returnCoverCode();

        if (cover !== '') {
            var statusText = '';

            switch(cover) {
                case 'SM':
                case 'SF':
                    statusText = 'Singles '; break;
                case 'C':
                    statusText = 'Couples '; break;
                default:
                    statusText = 'Families '; break;
            }
            completeText = statusText;
        }

        completeText += $elDropdownOption.text();

        if (meerkat.modules.healthTiers.shouldShowDependants()) {
            completeText += ', ' + dependantsText;
        }

        $elements.selectedRebateText.text(completeText);

        if ($elements.incomeSelect.prop('selectedIndex') === 0) {
            $elements.incomeSelect.prop('selectedIndex', 1);
        }
    }

    function _setRebate(){
        loadRatesBeforeResultsPage(true, function (rates) {
            if (!isNaN(rates.rebate) && parseFloat(rates.rebate) > 0) {
                $elements.rebateLegend.html('You are eligible for a ' + rates.rebate + '% rebate.');
            } else {
                $elements.rebateLegend.html('');
            }
        });
    }

    // Make the rates object available outside of this module.
    function getRates(){
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
    function setRates(ratesObject){
        rates = ratesObject;
        $("#health_rebate").val((rates.rebate || ''));
        $("#health_rebateChangeover").val((rates.rebateChangeover || ''));
        $("#health_loading").val((rates.loading || ''));
        $("#health_primaryCAE").val((rates.primaryCAE || ''));
        $("#health_partnerCAE").val((rates.partnerCAE || ''));

        meerkat.modules.healthResults.setLhcApplicable(rates.loading);
    }

    function fetchRates(postData, canSetRates, callback) {
        // Check if there is enough data to ask the server.
        var coverTypeHasPartner = hasPartner();
        if(postData.cover === '') return false;
        if (postData.rebate_choice === '') return false;
        if(postData.primary_dob === '') return false;
        if(coverTypeHasPartner && postData.partner_dob === '')  return false;

        if(meerkat.modules.age.returnAge(postData.primary_dob) < 0) return false;
        if(coverTypeHasPartner && meerkat.modules.age.returnAge(postData.partner_dob) < 0)  return false;
        if(postData.rebate_choice === "Y" && postData.income === "") return false;

        // check in valid date format
        var dateRegex = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;

        if(!postData.primary_dob.match(dateRegex)) return false;
        if(coverTypeHasPartner && !postData.partner_dob.match(dateRegex))  return false;

        return meerkat.modules.comms.post({
            url:"ajax/json/health_rebate.jsp",
            data: postData,
            cache:true,
            errorLevel: "warning",
            onSuccess:function onRatesSuccess(data){
                if(canSetRates === true) setRates(data);
                if(!_.isNull(callback) && typeof callback !== 'undefined') {
                    callback(data);
                }
            }
        });
    }

    // Use the situation value to determine if a partner is visible on the journey.
    function hasPartner(){
        var cover = $(':input[name="health_situation_healthCvr"]').filter(':checked').val();
        if(cover == 'F' || cover == 'C'){
            return true;
        }else{
            return false;
        }
    }


    function getDependents() {
        return ($elements.healthCoverDetails && $.inArray($elements.healthCoverDetails.find(':input[name="health_situation_healthCvr"]').filter(':checked').val(), ['SPF', 'F']) >= 0 ? 1 : 0);
    }

    function loadRatesBeforeResultsPage(forceRebate, callback) {

        var $healthCoverDetails = $elements.healthCoverDetails;

        var postData = {
            dependants: getDependents(),
            income: $elements.incomeSelect.val() || 0,
            rebate_choice: forceRebate === true ? 'Y' : $healthCoverDetails.find('input[name="health_healthCover_rebate"]:checked').val(),
            primary_dob: $healthCoverDetails.find('#health_healthCover_primary_dob').val(),
            primary_loading:$healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: $healthCoverDetails.find('input[name="health_healthCover_primary_cover"]:checked').val(),
            primary_loading_manual: $healthCoverDetails.find('.primary-lhc').val(),
            cover: $healthCoverDetails.find(':input[name="health_situation_healthCvr"]').filter(':checked').val()
        };

        // If the customer answers Yes for current health insurance, assume 0% LHC
        if (postData.primary_current === 'Y' && postData.primary_loading !=='N') {
            postData.primary_loading = 'Y';
        }

        if (hasPartner()) {
            postData.partner_dob = $healthCoverDetails.find('input[name="health_healthCover_partner_dob"]').val();
            postData.partner_current = meerkat.modules.healthAboutYou && meerkat.modules.healthAboutYou.getPartnerCurrentCover() || 'N';
            postData.partner_loading = $healthCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val() || 'N';
            postData.partner_loading_manual = $healthCoverDetails.find('input[name="health_healthCover_partner_lhc"]').val();
        }

        if(!fetchRates(postData, true, callback)) {
            exception("Failed to fetch rates");
        }
    }

    // Load the rates object via ajax. Also validates currently filled in fields to ensure only valid attempts are made.
    function loadRates(callback){

        var $healthCoverDetails = $elements.healthCoverDetails;

        var postData = {
            dependants: getDependents(),
            income:$healthCoverDetails.find(':input[name="health_healthCover_income"]').val() || 0,
            rebate_choice: $healthCoverDetails.find('input[name="health_healthCover_rebate"]:checked').val() || 'Y',
            primary_dob: $healthCoverDetails.find('#health_healthCover_primary_dob').val(),
            primary_loading:$healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: $healthCoverDetails.find('input[name="health_healthCover_primary_cover"]:checked').val(),
            primary_loading_manual: $healthCoverDetails.find('.primary-lhc').val(),
            partner_dob: $healthCoverDetails.find('#health_healthCover_partner_dob').val(),
            partner_loading:$healthCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val(),
            partner_current: meerkat.modules.healthAboutYou && meerkat.modules.healthAboutYou.getPartnerCurrentCover() || 'N',
            partner_loading_manual: $healthCoverDetails.find('.partner-lhc').val(),
            cover: $healthCoverDetails.find(':input[name="health_situation_healthCvr"]').filter(':checked').val()
        };

        if( $('#health_application_provider, #health_application_productId').val() === '' ) {

            // before application stage
            postData.primary_dob = $('#health_healthCover_primary_dob').val();

        } else {

            // in application stage
            postData.primary_dob = $('#health_application_primary_dob').val();
            postData.partner_dob = $('#health_application_partner_dob').val() || postData.primary_dob;  // must default, otherwise fetchRates fails.
            postData.primary_current = ( meerkat.modules.healthPreviousFund.getPrimaryFund() == 'NONE' )?'N':'Y';
            postData.partner_current = ( meerkat.modules.healthPreviousFund.getPartnerFund() == 'NONE' )?'N':'Y';

        }

        if(!fetchRates(postData, true, callback)) {
            exception("Failed to Fetch Health Rebate Rates");
        }
    }

    meerkat.modules.register("healthRebate", {
        init: init,
        getRates: getRates,
        setRates: setRates,
        getRebate: getRebate,
        fetchRates: fetchRates,
        loadRates: loadRates,
        loadRatesBeforeResultsPage: loadRatesBeforeResultsPage,
        hasPartner: hasPartner,
        updateSelectedRebateLabel: updateSelectedRebateLabel,
        getDependents: getDependents
    });


})(jQuery);
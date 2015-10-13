;(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var modalId = false,
        ratesChanged = false,
        mode,
        $modal,
        $healthCoverDetailsContainer,
        $healthCoverlhcGroup,
        $healthCoverlhcQuestion,
        $healthCoversituation,
        $primaryDob,
        $primaryCurrentCover,
        $primaryContinuousCover,
        $partnerDob,
        $partnerCurrentCover,
        $partnerContinuousCover,
        $healthCoverDependants,
        $healthCoverTier,
        $healthCoverIncome,
        $healthCoverIncomeLabel,
        $healthCoverIncomeMessage,
        $healthCoverIncomeBasedOn,
        $healthCoverRebate,
        $healthDetailsHiddenFields;

    var MODE_POPOVER = 'popover-mode', // Triggered as pop over
        MODE_JOURNEY = 'journey-mode'; // Triggered by journey engine step. Different buttons are shown and different events are triggered.

    function initHealthCoverDetails() {
        $(document).ready(function () {
            // Setup jQuery objects already available
            $primaryDob = $('#health_application_primary_dob');
            $primaryCurrentCover = $('#health_healthCover_primaryCover');
            $healthDetailsHiddenFields = $('.healthDetailsHiddenFields');
            $healthCoversituation = $('#health_situation_healthCvr');
        });
    }

    function setFormAndValidation() {
        if (modalId) {
            $modal = $('#' + modalId);
            $healthCoverDetailsContainer = $modal.find('#health_healthCover-selection');

            $healthCoverlhcGroup = $healthCoverDetailsContainer.find('.lhc-group');
            $healthCoverlhcQuestion = $healthCoverlhcGroup.find('.lhc-question');

            $primaryContinuousCover = $healthCoverDetailsContainer.find('#health-continuous-cover-primary');

            $partnerDob = $healthCoverDetailsContainer.find('#health_healthCover_partner_dob');
            $partnerCurrentCover = $healthCoverDetailsContainer.find('#health_healthCover_partnerCover');
            $partnerContinuousCover = $healthCoverDetailsContainer.find('#health-continuous-cover-partner');

            $healthCoverDependants = $healthCoverDetailsContainer.find('.health_cover_details_dependants');
            $healthCoverIncomeBasedOn = $healthCoverDetailsContainer.find('#health_healthCover_incomeBase');

            $healthCoverTier = $healthCoverDetailsContainer.find('#health_healthCover_tier');
            $healthCoverIncome = $healthCoverTier.find('#health_healthCover_income');
            $healthCoverIncomeMessage = $healthCoverTier.find('#health_healthCover_incomeMessage');
            $healthCoverIncomeLabel = $healthCoverTier.find('#health_healthCover_incomelabel');

            $healthCoverRebate = $healthCoverDetailsContainer.find('.health_cover_details_rebate');

            meerkat.modules.formDateInput.init();
            meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($healthCoverDetailsContainer);
            meerkat.modules.healthTiers.initHealthTiers();
        }
    }

    function populateHiddenFields() {
        $healthDetailsHiddenFields.find('input').each(function (index, element) {
            var $visibleElement = $healthCoverDetailsContainer.find(':input[name="' + $(element).attr('name') + '"]');
            if ($visibleElement.length && $visibleElement.valid()) {
                if ($visibleElement.attr('type') === 'radio') {
                    $(element).val($($visibleElement.selector + ':checked').val()).change();
                } else {
                    $(element).val($visibleElement.val()).change();
                }
            }
        });

        // bind change event will trigger the warning but we don't want it at this stage.
        _.defer(function () {
            $(".policySummaryContainer").find(".policyPriceWarning").hide();
        });
    }

    function populateVisibleFields() {
        $healthDetailsHiddenFields.find('input').each(function (index, element) {
            var $visibleElement = $healthCoverDetailsContainer.find(':input[name="' + $(element).attr('name') + '"]');
            if ($visibleElement.attr('type') === 'radio') {
                $($visibleElement.selector + '[value="' + $(element).val() + '"]').prop('checked', true).change();
            } else {
                $visibleElement.val($(element).val()).change();
            }
        });
    }

    function isRebateApplied() {
        return meerkat.modules.dialogs.isDialogOpen(modalId) === true ? $healthCoverRebate.find(':checked').val() === 'Y' : $healthDetailsHiddenFields.find('input[name="health_healthCover_rebate"]').val() === 'Y';
    }

    function setIncomeBase(initMode) {
        if (meerkat.site.isCallCentreUser !== true) return;

        if (isSinglePolicy()) {
            initMode ? $healthCoverIncomeBasedOn.show() : $healthCoverIncomeBasedOn.slideDown();
        } else {
            initMode ? $healthCoverIncomeBasedOn.hide() : $healthCoverIncomeBasedOn.slideUp();
        }
    }

    //Previous funds, settings
    function displayHealthFunds() {
        var $_previousFund = $('#mainform').find('.health-previous_fund');
        var $_primaryFund = $('#clientFund').find('select');
        var $_partnerFund = $('#partnerFund').find('select');

        if ($_primaryFund.val() !== 'NONE' && $_primaryFund.val() !== '') {
            $_previousFund.find('#clientMemberID').slideDown();
            $_previousFund.find('.membership').addClass('onA');
        } else {
            $_previousFund.find('#clientMemberID').slideUp();
            $_previousFund.find('.membership').removeClass('onA');
        }

        if (healthChoices.hasSpouse() && $_partnerFund.val() !== 'NONE' && $_partnerFund.val() !== '') {
            $_previousFund.find('#partnerMemberID').slideDown();
            $_previousFund.find('.membership').addClass('onB');
        } else {
            $_previousFund.find('#partnerMemberID').slideUp();
            $_previousFund.find('.membership').removeClass('onB');
        }
    }

    function setHealthFunds(initMode) {
        //// Quick variables
        var _primary = $primaryCurrentCover.find(':checked').val();
        var _partner = $partnerCurrentCover.find(':checked').val();
        var $_primaryFund = $('#clientFund').find('select');
        var $_partnerFund = $('#partnerFund').find('select');

        //// Primary Specific
        if (_primary == 'Y') {
            if (isLessThan31Or31AndBeforeJuly1($primaryDob.val())) {
                initMode ? $primaryContinuousCover.hide() : $primaryContinuousCover.slideUp();
            } else {
                initMode ? $primaryContinuousCover.show() : $primaryContinuousCover.slideDown();
            }
        } else {
            if (_primary == 'N') {
                resetRadio($primaryContinuousCover, 'N');
            }
            initMode ? $primaryContinuousCover.hide() : $primaryContinuousCover.slideUp();
        }

        if (_primary == 'Y' && $_primaryFund.val() == 'NONE') {
            $_primaryFund.val('');
        } else if (_primary == 'N') {
            $_primaryFund.val('NONE');
        }

        //// Partner Specific
        if (_partner == 'Y') {

            if (isLessThan31Or31AndBeforeJuly1($partnerDob.val())) {
                initMode ? $partnerContinuousCover.hide() : $partnerContinuousCover.slideUp();
            } else {
                initMode ? $partnerContinuousCover.show() : $partnerContinuousCover.slideDown();
            }
        } else {
            if (_partner == 'N') {
                resetRadio($partnerContinuousCover, 'N');
            }
            initMode ? $partnerContinuousCover.hide() : $partnerContinuousCover.slideUp();
        }

        if (_partner == 'Y' && $_partnerFund.val() == 'NONE') {
            $_partnerFund.val('');
        } else if (_partner == 'N') {
            $_partnerFund.val('NONE');
        }

        //// Adjust the questions further along
        displayHealthFunds();
    }

    function toggleLHCApplicability(){
        var _primary = $primaryCurrentCover.find(':checked').val();

        isLessThan31Or31AndBeforeJuly1($primaryDob.val()) && isSinglePolicy() ? $healthCoverlhcGroup.hide() : $healthCoverlhcGroup.show();
        !isLessThan31Or31AndBeforeJuly1($primaryDob.val()) && isSinglePolicy() && _primary === 'N'  ? $healthCoverlhcQuestion.hide() : $healthCoverlhcQuestion.show();
    }
    function isSinglePolicy(){
        var legitTypes = ['S','SF','SM','SPF'];
        return legitTypes.indexOf(healthChoices._cover) >= 0 ? true: false ;
    }

    function flushPartnerDetails () {
        $partnerDob.val('').change();
        $partnerCurrentCover.find(':checked').prop('checked', false);
        resetRadio($partnerCurrentCover);
        $partnerContinuousCover.find(':checked').prop('checked', false);
        resetRadio($partnerContinuousCover);
    }

    function resetRebateForm () {
        $healthCoverDependants.find('option:selected').prop("selected", false);
        $healthCoverDependants.find('option').first().prop("selected", true);
        $healthCoverIncome.find('option:selected').prop("selected", false);
        $healthCoverIncome.find('option').first().prop("selected", true);
        $healthCoverIncomeLabel.val('');
        $healthCoverRebate.find(':checked').prop('checked', false);
        resetRadio($healthCoverRebate);
        $healthCoverRebate.hide();
        $healthCoverlhcGroup.show();
    }

    function setDependants(initMode) {
        if( healthChoices.hasChildren()) {
            // Show the dependants questions
            initMode === true ?  $healthCoverDependants.show() : $healthCoverDependants.slideDown();
        } else {
            // Reset questions and hide
            if(initMode === true){
                $healthCoverDependants.hide();
            }else{
                $healthCoverDependants.find('option:selected').prop("selected", false);
                $healthCoverIncome.find('option:selected').prop("selected", false);
                $healthCoverDependants.slideUp();
            }
        }
    }

    function setPartner() {
        if (healthChoices.hasSpouse()) {
            $('#partner-health-cover, #partner, .health-person-details-partner, #partnerFund').show();
        } else {
            flushPartnerDetails();
            $('#partner-health-cover, #partner, .health-person-details-partner, #partnerFund').hide();
        }
    }

    function setup() {
        setFormAndValidation();
        resetRebateForm();
        populateVisibleFields();
        eventSubscriptions();
        toggleLHCApplicability();
        setPartner();
        setHealthFunds(true);
        setIncomeBase(true);
        setDependants(true);
        meerkat.modules.healthTiers.setTiers(true);
        setRebate(true);

    }

    function eventSubscriptions() {

        $healthCoverDependants.find('#health_healthCover_dependants').on('change', function(){
            meerkat.modules.healthTiers.setTiers();
        });

        $healthCoverRebate.on('change', function(){
            var $medicare = $('.health-medicare_details');
            // Hide these questions as they are not required
            if( isRebateApplied() !== true ) {
                $medicare.hide();
                meerkat.modules.form.clearInitialFieldsAttribute($medicare);
            } else {
                $medicare.show();
            }
        });

        if(meerkat.site.isCallCentreUser === true){
            $healthCoverIncomeBasedOn.find('input').on('change', function(){
                $healthCoverIncome.prop('selectedIndex', 0);
                meerkat.modules.healthTiers.setTiers();
            });
        }

        $healthCoverDetailsContainer.find(':input').on('change', function(event) {
            var $this = $(this);

            // Don't action on the DOB input fields; wait until it's serialised to the hidden field.
            if ($this.hasClass('dateinput-day') || $this.hasClass('dateinput-month') || $this.hasClass('dateinput-year') || ($this.attr('name').indexOf('partner_dob') >= 0 && $this.val() === "")) return;

           setHealthFunds();

            // TODO: re-enable this when we are bring healthV2 to call centre
            //if(meerkat.site.isCallCentreUser === true){
            //
            //    // Get rates and show LHC inline.
            //    loadRates(function(rates){
            //
            //        $healthCoverRebate.find('.fieldrow_legend').html('Overall LHC ' + rates.loading + '%');
            //
            //        if(healthChoices.hasSpouse()){
            //            $primaryCurrentCover.find('.fieldrow_legend').html('Individual LHC ' + rates.primaryLoading + '%, overall  LHC ' + rates.loading + '%');
            //            $partnerCurrentCover.find('.fieldrow_legend').html('Individual LHC ' + rates.partnerLoading + '%, overall  LHC ' + rates.loading + '%');
            //        } else {
            //            $primaryCurrentCover.find('.fieldrow_legend').html('Overall  LHC ' + rates.loading + '%');
            //        }
            //
            //        meerkat.modules.healthTiers.setTiers();
            //    });
            //}

            // update rebate
            if ($this.valid()) {
                setRebate();
            }
        });

        if(meerkat.site.isCallCentreUser === true){
            // Handle pre-filled
            toggleRebateDialogue();
            // Handle toggle rebate options
            $healthCoverRebate.find('input').on('change', function() {
                toggleRebateDialogue();
            });
        }

        // Hook up modal buttons
        $modal.find('.btn-cancel, .btn-close-dialog').on('click', function cancelClick() {
            populateHiddenFields();
            closeModal();

            if (mode === MODE_JOURNEY){
                meerkat.modules.journeyEngine.gotoPath('previous');
            }
        });

        $modal.find('.btn-healthCoverDetails-save').on('click', function saveClick() {
            populateHiddenFields();
            saveHealthCoverDetails();
        });
    }

    function setRebate(initMode){
        loadRates(true, function (rates) {
            if (!isNaN(rates.rebate) && parseFloat(rates.rebate) > 0) {
                $healthCoverTier.find('#health_healthCover_tier_row_legend').html('You are eligible for a ' + rates.rebate + '% rebate.');
                initMode ? $healthCoverRebate.show() : $healthCoverRebate.slideDown();
            } else {
                $healthCoverTier.find('#health_healthCover_tier_row_legend').html('');
                $healthCoverRebate.find('input[value="N"]').prop('checked', true);
                initMode ? $healthCoverRebate.hide() : $healthCoverRebate.slideUp();
            }
        });
    }

    function saveHealthCoverDetails() {
        var selectedProduct = Results.getSelectedProduct();
        if (selectedProduct && $healthCoverDetailsContainer.valid()) {
            lockForm();

            loadRates(false, function (rates) {
               // compare LHC and rebate with the rates saved last time when get results.
               // If the values are same, don't fetch result again.
               // TODO: premiumCalculator could be done in frontEnd to avoid the price fetch
                var oriRates = meerkat.modules.health.getRates();
                if (typeof oriRates === 'undefined' || oriRates === null) { unlockAndClose(); return; }
                if (typeof rates === 'undefined' || rates === null) { unlockAndClose(); return; }
                if (rates.rebate === oriRates.rebate && rates.loading === oriRates.loading) { unlockAndClose(); return; }

                // Now set the rates back to hidden fields so we can fetch the prices
                meerkat.modules.health.setRates(rates);
                ratesChanged = true;

                var postData = meerkat.modules.journeyEngine.getFormData();

                // Override some form data to only return a single product.
                _.findWhere(postData, {name: "health_showAll"}).value = "N";
                _.findWhere(postData, {name: "health_onResultsPage"}).value = "N";
                _.findWhere(postData, {name: "health_incrementTransactionId"}).value = "N";
                postData.push({
                    name: "health_payment_details_type",
                    value: 'ba'
                });

                meerkat.modules.comms.post({
                    url: "ajax/json/health_quote_results.jsp",
                    data: postData,
                    cache: false,
                    errorLevel: "warning",
                    onSuccess: function onGetProductSuccess(data) {
                        Results.model.updateTransactionIdFromResult(data);

                        if (data.results && data.results.price && data.results.price.available !== 'N') {
                            var product = _.isArray(data.results.price) ? data.results.price[0] : data.results.price;

                            // Update selected product
                            meerkat.modules.healthResults.setSelectedProduct(product, true, true);
                        }
                    },
                    onComplete: function(){
                        unlockAndClose();
                    }
                });
            });
        }
    }

    function closeModal(){
        meerkat.modules.dialogs.close(modalId);
    }
    function unlockAndClose() {
        unlockForm();
        closeModal();
    }

    function unlockForm() {
        // Enable button, hide spinner
        var $button = $modal.find('.btn-healthCoverDetails-save');
        $button.removeClass('disabled');
        $modal.find('.btn-cancel').removeClass('disabled');

        // Enable inputs
        $healthCoverDetailsContainer.find(':input').prop('disabled', false);
        $healthCoverDetailsContainer.find('.select').removeClass('disabled');
        $healthCoverDetailsContainer.find('.btn-group label').removeClass('disabled');

        meerkat.modules.loadingAnimation.hide($button);
    }

    function lockForm() {
        // Disable button, show spinner
        var $button = $modal.find('.btn-healthCoverDetails-save');
        $button.addClass('disabled');
        $modal.find('.btn-cancel').addClass('disabled');

        $healthCoverDetailsContainer.find(':input').prop('disabled', true);
        $healthCoverDetailsContainer.find('.select').addClass('disabled');
        $healthCoverDetailsContainer.find('.btn-group label').addClass('disabled');

        meerkat.modules.loadingAnimation.showAfter($button);
    }

    function loadRates(forceRebate, callback) {

        var postData =  {
            dependants: $healthCoverDetailsContainer.find(':input[name="health_healthCover_dependants"]').val(),
            income: $healthCoverDetailsContainer.find(':input[name="health_healthCover_income"]').val(),
            rebate_choice: forceRebate === true ? 'Y' : $healthCoverRebate.find(':checked').val(),
            primary_dob: $primaryDob.val(),
            primary_loading:$healthCoverDetailsContainer.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: $primaryCurrentCover.find(':checked').val(),
            primary_loading_manual: $healthCoverDetailsContainer.find('.primary-lhc').val(),
            partner_dob: $partnerDob.val(),
            partner_loading: $healthCoverDetailsContainer.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val(),
            partner_current: $healthCoverDetailsContainer.find('input[name="health_healthCover_partner_cover"]:checked').val(),
            partner_loading_manual: $healthCoverDetailsContainer.find('.partner-lhc').val(),
            cover: healthChoices._cover
        };

        meerkat.modules.health.fetchRates(postData, false, callback);
    }

    // Hide/show simples Rebate dialogue when toggle rebate options in simples journey
    function toggleRebateDialogue() {
        // apply rebate
        if (isRebateApplied()) {
            $('.simples-dialogue-37').removeClass('hidden');
        }
        // no rebate
        else {
            $('.simples-dialogue-37').addClass('hidden');
        }
    }

    function hasRatesChanged() {
        return ratesChanged;
    }

    function showModal(modeParam) {
        mode = modeParam;

        // reset ratesChanged for Journey mode
        if (mode === MODE_JOURNEY) ratesChanged = false;

        var htmlTemplate = _.template($('#health-cover-details-template').html());

        meerkat.modules.dialogs.show({
            htmlContent: htmlTemplate(),
            buttons: [{
                label: 'Cancel',
                className: 'btn-cancel',
                closeWindow: false
            },
            {
                label: 'Continue',
                className: 'btn-cta btn-healthCoverDetails-save',
                closeWindow: false
            }],
            onOpen: function(id) {
                modalId = id;
                setup();
                var data = {
                    actionStep: 'Health LHC modal'
                };
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method:	'trackQuoteForms',
                    object:	data
                });
            }
        });
    }

    meerkat.modules.register("healthCoverDetails", {
        init: initHealthCoverDetails,
        showModal: showModal,
        isRebateApplied: isRebateApplied,
        hasRatesChanged: hasRatesChanged,
        displayHealthFunds: displayHealthFunds
    });

})(jQuery);

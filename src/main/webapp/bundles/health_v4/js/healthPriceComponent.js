;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            healthPriceComponent: {
                INIT: 'PRICE_COMPONENT_INITED'
            }
        },
        moduleEvents = events.healthPriceComponent;

    var quoteRefTemplate, priceTemplate, logoTemplate, lhcTemplate, aboutTemplate;

    var $policySummaryContainer;
    var $policySummaryTemplateHolder;
    var $policySummaryDetailsComponents;

    var $displayedFrequency;

    var initialised = false,
        premiumChangeEventFired = false;

    function initHealthPriceComponent(){

        if(!initialised) {
            initialised = true;

            if(meerkat.site.vertical !== "health") return false;

            quoteRefTemplate = $("#quoteref-template").html();
            priceTemplate = $("#price-template").html();
            logoTemplate = $('#logo-template').html();
            lhcTemplate = $('#price-breakdown-lhc-template').html();
            aboutTemplate = $('#about-this-fund-link-template').html();

            $policySummaryContainer = $(".policySummaryContainer");
            $policySummaryTemplateHolder = $(".policySummaryTemplateHolder");
            $policySummaryDetailsComponents = $(".productSummaryDetails");

            if(meerkat.site.pageAction != "confirmation"){

                $displayedFrequency = $("#health_payment_details_frequency");

                meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_CHANGED, function(selectedProduct){
                    // This should be called when the user selects a product on the results page.
                    premiumChangeEventFired = false;
                    onProductPremiumChange(selectedProduct, false);
                });

                meerkat.messaging.subscribe(meerkatEvents.healthResults.PREMIUM_UPDATED, function(selectedProduct, doNotShowIncPrice){
                    doNotShowIncPrice = doNotShowIncPrice || false;
                    premiumChangeEventFired = true;
                    // This should be called when the user updates their premium on the payment step.
                    onProductPremiumChange(selectedProduct, !doNotShowIncPrice);
                });

                meerkat.messaging.subscribe(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM, function(selectedProduct){
                    $policySummaryContainer.find(".policyPriceWarning").show();
                });

            }

            applyEventListeners();

            meerkat.messaging.publish(moduleEvents.INIT);

        }
    }

    function onProductPremiumChange(selectedProduct, showIncPrice){
        // Use the frequency selected on the payment step - if that is not set, refer to the results page frequency.
        var displayedFrequency = $displayedFrequency.val();
        if (_.isEmpty(displayedFrequency)) displayedFrequency = Results.getFrequency();
        updateProductSummaryHeader(selectedProduct, displayedFrequency, showIncPrice);

        // Update product summary
        var startDateString = "Please confirm";
        var startDateInput = meerkat.modules.healthCoverStartDate.getVal();
        if (!_.isEmpty(startDateInput)){
            startDateString = startDateInput;
        }

        updateProductSummaryDetails(selectedProduct, startDateString);
    }

    function updateProductSummaryHeader(product, frequency, showIncPrice){
        product._selectedFrequency = frequency;

        // Reset any settings for rendering
        if(showIncPrice){
            product.mode = 'lhcInc';
            $policySummaryContainer.find('.footer').addClass('hidden');
        }else{
            product.mode = '';
        }
        product.showAltPremium = false;
        product.priceBreakdown = meerkat.modules.healthPriceBreakdown.showBreakdown();

        if (!meerkat.modules.healthCoverStartDate.isAfterMarch() && meerkat.modules.healthDualPricing.isDualPricingActive()) {
            product.displayLogo = false;
            if (typeof product.dropDeadDate === 'undefined') {
                var selectedProduct = Results.getSelectedProduct();
                product.dropDeadDate = selectedProduct.dropDeadDate;
                product.dropDeadDateFormatted = selectedProduct.dropDeadDateFormatted;
                product.dropDeadDatePassed = selectedProduct.dropDeadDatePassed;
            }

            $policySummaryContainer.addClass('hidden');
            $('.policySummary.dualPricing').removeClass('hidden');
            $('.policySummary-sidebar h1').removeClass('hidden');
            $('.quoterefTemplateHolder').removeClass('hidden');

            meerkat.modules.healthDualPricing.renderTemplate('.policySummary.dualPricing', product, false, true);
        } else {
            product.displayLogo = true;

            var quoteRefHtmlTemplate = typeof quoteRefTemplate !== 'undefined' ? _.template(quoteRefTemplate) : null;
            var lhcHtml = _.template(lhcTemplate);
            var priceHtmlTemplate = _.template(priceTemplate);
            var logoHtmlTemplate = _.template(logoTemplate);
            var aboutHtml = _.has(Results.getSelectedProduct(), 'aboutFund') ? _.template(aboutTemplate)() : '';
            var htmlString = (typeof quoteRefHtmlTemplate === 'function' ? quoteRefHtmlTemplate({}) : "")
                + lhcHtml(product) + logoHtmlTemplate(product) + aboutHtml + priceHtmlTemplate(product);

            $policySummaryContainer.removeClass('hidden');
            $('.policySummary.dualPricing').addClass('hidden');
            $('.policySummary-sidebar h1').addClass('hidden');
            $('.quoterefTemplateHolder').addClass('hidden');

            $policySummaryTemplateHolder.html(htmlString);
            $policySummaryContainer.find(".policyPriceWarning").hide();
        }
    }

    function updateProductSummaryDetails(product, startDateString, displayMoreInfoLink){
        $policySummaryDetailsComponents.find(".name").text((product.info.providerName ? product.info.providerName : product.info.fundName) + " " + product.info.name);
        $policySummaryDetailsComponents.find(".startDate").text(startDateString);
        if (typeof product.hospital.inclusions !== 'undefined') {
            $policySummaryDetailsComponents.find(".excess").html(product.hospital.inclusions.excess);
            $policySummaryDetailsComponents.find(".excessWaivers").html(product.hospital.inclusions.waivers);
            $policySummaryDetailsComponents.find(".copayment").html(product.hospital.inclusions.copayment);
        }

        $policySummaryDetailsComponents.find(".footer").removeClass('hidden');
        $policySummaryDetailsComponents.find(".excess").parent().removeClass('hidden');
        $policySummaryDetailsComponents.find(".excessWaivers").parent().removeClass('hidden');
        $policySummaryDetailsComponents.find(".copayment").parent().removeClass('hidden');

        // hide more info link on request (i.e. confirmation page)
        if (typeof(displayMoreInfoLink) != "undefined" && displayMoreInfoLink === false) {
            $policySummaryDetailsComponents.find(".footer").addClass('hidden');
        }

        // hide some info if it's empty
        if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.excess === "") {
            $policySummaryDetailsComponents.find(".excess").parent().addClass('hidden');
        }
        if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.waivers === "") {
            $policySummaryDetailsComponents.find(".excessWaivers").parent().addClass('hidden');
        }
        if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.copayment === "") {
            $policySummaryDetailsComponents.find(".copayment").parent().addClass('hidden');
        }

        $policySummaryDetailsComponents.find('.open-more-info').attr('data-productId',product.productId).attr('data-available', product.available);
//		This is a deactivated split test as it is likely to be run again in the future
//		if (meerkat.modules.splitTest.isActive(2)) {
//			$policySummaryDetailsComponents.find(".companyLogo").attr('class', 'companyLogo hidden-sm'); //reset class
//			$policySummaryDetailsComponents.find(".companyLogo").addClass(product.info.provider);
//		}
    }

    function applyEventListeners() {
        $('.btn-show-how-calculated').on('click', function(){
            meerkat.modules.dialogs.show({
                title: 'Here is how your premium is calculated:',
                htmlContent: '<p>The BASE PREMIUM is the cost of a policy set by the health fund. This cost excludes any discounts or additional charges that are applied to the policy due to your age or income.</p><p>LHC LOADING is an initiative designed by the Federal Government to encourage people to take out private hospital cover earlier in life. If you&rsquo;re over the age of 31 and don&rsquo;t already have cover, you&rsquo;ll be required to pay a 2% Lifetime Health Cover loading for every year over the age of 30 that you were without hospital cover. The loading is applied to the BASE PREMIUM of the hospital component of your cover if applicable.<br/>For full information please go to: <a href="http://www.privatehealth.gov.au/healthinsurance/incentivessurcharges/lifetimehealthcover.htm" target="_blank">http://www.privatehealth.gov.au/healthinsurance/incentivessurcharges/lifetimehealthcover.htm</a></p><p>The AUSTRALIAN GOVERNMENT REBATE exists to provide financial assistance to those who need help with the cost of their health insurance premium. It is currently income-tested and tiered according to total income and the age of the oldest person covered by the policy. If you claim a rebate and find at the end of the financial year that it was incorrect for whatever reason, the Australian Tax Office will simply correct the amount either overpaid or owing to you after your tax return has been completed. There is no penalty for making a rebate claim that turns out to have been incorrect. The rebate is calculated against the BASE PREMIUM for both the hospital &amp; extras components of your cover.<br/>For full information please go to: <a href="https://www.ato.gov.au/Calculators-and-tools/Private-health-insurance-rebate-calculator/" target="_blank">https://www.ato.gov.au/Calculators-and-tools/Private-health-insurance-rebate-calculator/</a></p><p>PAYMENT DISCOUNTS can be offered by health funds for people who choose to pay by certain payment methods or pay their premiums upfront. These are applied to the total premium costs.</p>'
            });
        });
    }

    meerkat.modules.register('healthPriceComponent', {
        initHealthPriceComponent: initHealthPriceComponent,
        events: events,
        updateProductSummaryHeader: updateProductSummaryHeader,
        updateProductSummaryDetails: updateProductSummaryDetails
    });

})(jQuery);

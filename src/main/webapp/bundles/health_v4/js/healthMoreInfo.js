;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var events = {
            healthMoreInfo: {}
        },
        moduleEvents = events.healthMoreInfo;

    var $bridgingContainer = $('.moreInfoDropdown'),
        scrollPosition, //The position of the page on the modal display,
        topPosition,
        moreInfoDialogId,
        testimonials = [
            {quote:"Compare the Market helped me choose a policy with features relevant to me. I no longer pay for benefits I don't use", author:"Andrea, WA"},
            {quote:"With Compare the Market I was able to find the same level of cover but now save $60 a month off my premium", author:"Geoff, QLD"},
            {quote:"Health insurance is important to us as it gives us the peace of mind that if something went wrong we'd be covered", author:"Julie Barrett, NSW"},
            {quote:"The whole process was really simple and really easy. I’d definitely use comparethemarket.com.au again", author:"Wendy, WA"}
        ],
        $elements = {};


    function initMoreInfo() {
        $(document).ready(function ($) {
            var options = {
                container: $bridgingContainer,
                updateTopPositionVariable: updateTopPositionVariable,
                hideAction: 'fadeOut',
                showAction: 'fadeIn',
                showActionWhenOpen: 'fadeIn',
                modalOptions: {
                    className: 'modal-breakpoint-wide modal-tight moreInfoDropdown',
                    openOnHashChange: false,
                    leftBtn: {
                        label: 'Back',
                        icon: '<span class="icon icon-angle-left"></span>',
                        callback: function (eventObject) {
                            $(eventObject.currentTarget).closest('.modal').modal('hide');
                        }
                    },
                    showCloseBtn: true,
                    onClose: function () {
                        onBeforeHideTemplate();
                        meerkat.modules.moreInfo.close();
                        meerkat.modules.benefitsToggleBar.deRegisterScroll();
                    }
                },
                runDisplayMethod: runDisplayMethod,
                onBeforeShowBridgingPage: onBeforeShowBridgingPage,
                onBeforeShowTemplate: onBeforeShowTemplate,
                onBeforeShowModal: onBeforeShowModal,
                onAfterShowModal: onAfterShowModal,
                onAfterShowTemplate: onAfterShowTemplate,
                onBeforeHideTemplate: onBeforeHideTemplate,
                onAfterHideTemplate: onAfterHideTemplate,
                onClickApplyNow: onClickApplyNow,
                onBeforeApply: onBeforeApply,
                onApplySuccess: onApplySuccess,
                prepareCover: prepareCover,
                retrieveExternalCopy: retrieveExternalCopy,
                additionalTrackingData: {
                    productName: null,
                    productBrandCode: null
                },
                onBreakpointChangeCallback: updateTopPositionVariable
            };

            meerkat.modules.moreInfo.initMoreInfo(options);

            eventSubscriptions();
            applyEventListeners();
        });
    }

    /**
     * Health specific event listeners
     */
    function applyEventListeners() {

        $(document.body).on("click", ".next-steps", function nextStepsClick(event) {
            var product = Results.getSelectedProduct();
            if (!product) {
                return;
            }

            var modalId = meerkat.modules.dialogs.show({
                htmlContent: product.whatHappensNext
            });
        });

        $(document.body).off('click.emailBrochures').on('click.emailBrochures', '.getPrintableBrochures', function () {
            var product = Results.getSelectedProduct(),
                brochureTemplate = meerkat.modules.templateCache.getTemplate($('#emailBrochuresTemplate'));

            // init the validation
            $('#emailBrochuresForm').validate();

            var htmlContent = brochureTemplate(product),
                modalOptions = {
                    htmlContent: htmlContent,
                    hashId: 'email-brochures',
                    className: 'email-brochures-modal',
                    closeOnHashChange: true,
                    openOnHashChange: false,
                    onOpen: function (modalId) {
                        if (meerkat.site.emailBrochures.enabled) {
                            // initialise send brochure email button functionality
                            initialiseBrochureEmailForm(Results.getSelectedProduct(), $('#' + modalId), $('#emailBrochuresForm'));
                            populateBrochureEmail();
                        }
                    }
                };

            var callbackModalId = meerkat.modules.dialogs.show(modalOptions);
        });
    }

    function _setTabs() {
        $(document).on('click', '.nav-tabs a', function (e) {
            e.preventDefault();
            e.stopPropagation();

            $(this).tab('show');
        });
        $('.moreInfoHospitalTab .nav-tabs a:first, .moreInfoExtrasTab .nav-tabs a:first').trigger('click');
    }


    function onApplySuccess() {
        meerkat.modules.address.setHash('apply');
    }

    /**
     * If a different product is selected, ensure the join declaration is unticked
     */
    function onBeforeApply($this) {
        if (Results.getSelectedProduct() !== false && Results.getSelectedProduct().productId != $this.attr("data-productId")) {
            $('#health_declaration:checked').prop('checked', false).change();
        }
    }

    function onClickApplyNow(product, applyCallback) {

        meerkat.modules.healthResults.setSelectedProduct(product);
        // this variable declared in __health_legacy.js
        meerkat.modules.healthFunds.load(product.info.provider, applyCallback);

        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product: product,
            type: meerkat.site.isCallCentreUser ? "Simples" : "Online",
            quoteReferenceNumber: meerkat.modules.transactionId.get(),
            productID: product.productId.replace("PHIO-HEALTH-", ""),
            productName: product.info.name,
            productBrandCode: product.info.FundCode
        }, false);

        return true;
    }

    function eventSubscriptions() {

        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function bridgingPageHashChange(event) {
            if (meerkat.modules.deviceMediaState.get() != 'xs' && event.hash.indexOf('/moreinfo') == -1) {
                meerkat.modules.moreInfo.hideTemplate($bridgingContainer);
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
            if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
                meerkat.modules.moreInfo.close();
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
            if (meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_RESET, function bridgingPageLeaveXsState() {
            dynamicPyrrBanner();
        });
    }

    /**
     * Handles how you want to display the bridging page based on your viewport/requirements
     */
    function runDisplayMethod(productId) {
        var currStep = meerkat.modules.journeyEngine.getCurrentStep().navigationId;
        if (meerkat.modules.deviceMediaState.get() != 'xs' && currStep != 'apply' && currStep != 'payment') {
            meerkat.modules.moreInfo.showTemplate($bridgingContainer);
        } else {

            // grab the affixed template
            var updatedSettings = {
                modalOptions: {
                    htmlHeaderContent: _getAffixedMobileHeaderData()
                }
            };
            meerkat.modules.moreInfo.updateSettings(updatedSettings);
            meerkat.modules.moreInfo.showModal();

        }
        meerkat.modules.address.appendToHash('moreinfo');
    }

    function _getAffixedMobileHeaderData() {
        var headerTemplate = meerkat.modules.templateCache.getTemplate($('#moreInfoAffixedHeaderMobileTemplate')),
            obj = Results.getSelectedProduct();

        if (meerkat.modules.healthDualPricing.isDualPricingActive()) {
            obj.renderedPriceTemplate = meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false);
        } else if (meerkat.modules.healthPyrrCampaign.isPyrrActive()) {
            obj.renderedPyrrCampaign = meerkat.modules.healthPyrrCampaign.renderTemplate('', obj, true, false);
        } else {
            var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template"));
            obj.showAltPremium = false;
            obj._selectedFrequency = Results.getFrequency();
            obj.renderedPriceTemplate = priceTemplate(obj);
        }
        return headerTemplate(obj);
    }

    function onBeforeShowTemplate(jsonResult, moreInfoContainer) {

    }

    function onAfterShowTemplate() {
        additionalTrackingData();

        var product = Results.getSelectedProduct();
        // Add to the hidden fields for later use in emails
        $('#health_fundData_hospitalPDF').val(product.promo.hospitalPDF !== undefined ? meerkat.site.urls.base + product.promo.hospitalPDF : "");
        $('#health_fundData_extrasPDF').val(product.promo.extrasPDF !== undefined ? meerkat.site.urls.base + product.promo.extrasPDF : "");
        $('#health_fundData_providerPhoneNumber').val(product.promo.providerPhoneNumber !== undefined ? product.promo.providerPhoneNumber : "");

        $('.whatsNext li').each(function () {
            $(this).prepend('<span class="icon icon-angle-right"></span>');
        });

        _setupDualPricing(product);
        dynamicPyrrBanner(product);
        _setTabs();

        // HLT-4339: AUF discount override
        if (product.info.FundCode === 'AUF') {
            $('.productExtraInfo .discountText').text(meerkat.modules.healthResultsTemplate.getDiscountText(product));
        }
    }

    function _setupDualPricing(product) {
        if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) {
            // $('.april-pricing').addClass('april-pricing-done');
            $('.current-pricing').addClass('current-pricing-done');

            var productPremium = product.altPremium,
                comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon';

            $('.more-info-affixed-header').addClass(comingSoonClass);

            // update the dropdeaddate. Tried in _getAffixedMobileHeaderData but that returns undefined
            if (!_.isUndefined($elements.applyBy)) {
                $elements.applyBy.text('Must Apply by ' + product.dropDeadDateFormatted);
            }
        }
    }

    function dynamicPyrrBanner(product) {
        if (meerkat.modules.healthPyrrCampaign.isPyrrActive()) {
            if (meerkat.modules.healthResults.getSelectedProduct() !== null) {
                addShowDynamicPrice(meerkat.modules.healthResults.getSelectedProduct());

            } else if (typeof product !== 'undefined') {
                addShowDynamicPrice(product);

            } else {
                // This class is in the database and is used to dynamically change the coupon banner.
                $('.coupon-pyrr-banner-dynamic-hidden').hide();
                $('.coupon-pyrr-banner-static').show();
            }
        }
    }

    function addShowDynamicPrice(product) {
        var couponValue = product.giftCardAmount;
        if (typeof couponValue === 'undefined') {
            couponValue = 0;
        }
        $('.coupon-pyrr-banner-dynamic-price').text('$'+couponValue);
        $('.coupon-pyrr-banner-dynamic-hidden').show();
        $('.coupon-pyrr-banner-static').hide();
    }

    function onBeforeShowModal(jsonResult, dialogId) {
        var $dialog = $('#' + dialogId);
        moreInfoDialogId = dialogId;
        $dialog.find('.modal-body').children().wrap("<form class='healthMoreInfoModel'></form>");

        // Move dual-pricing panel
        $('.more-info-content .moreInfoRightColumn > .dualPricing').insertAfter($('.more-info-content .moreInfoMainDetails'));

        fixBootstrapModalPaddingIssue(dialogId);
    }

    function fixBootstrapModalPaddingIssue(dialogId) {
        // just fighting Bootstrap here...
        // It seems to think that because the body is overflowing, it needs to add right padding to cater for the scrollbar width
        // so taking that off once the modal is open
        $("#" + dialogId).css('padding-right', '0px');
    }

    function onAfterShowModal() {
        additionalTrackingData();

        $('.whatsNext li').each(function () {
            $(this).prepend('<span class="icon icon-angle-right"></span>');
        });

        $elements = {
            hospital: $('.Hospital_container'),
            extras: $('.GeneralHealth_container'),
            quickSelectContainer: $('.quickSelectContainer'),
            moreInfoContainer: $('.moreInfoTopLeftColumn'),
            modalHeader: $('.modal-header'),
            pricingContainer: $('.mobile-pricing, .logo-header'),
            currentPricingContainer: $('.current-container'),
            currentPricingDetails: $('.current-pricing-details'),
            applyBy: $('.applyBy')
        };

        if (meerkat.modules.healthDualPricing.isDualPricingActive()) {
            $elements.pricingContainer.removeClass('col-xs-6').addClass('col-xs-12');
        }

        _setTabs();

        var toggleBarInitSettings = {
                container: '.moreInfoVisible .modal-dialog',
                currentStep: 'moreinfo',
                isModal: true
            },
            product = Results.getSelectedProduct(),
            initToggleBar = (typeof product.hospitalCover !== 'undefined' && typeof product.extrasCover !== 'undefined');

        _setupDualPricing(product);

        if (initToggleBar) {
            meerkat.modules.benefitsToggleBar.initToggleBar(toggleBarInitSettings);
            _trackScroll();
        }

        $(toggleBarInitSettings.container).find('.toggleBar').toggleClass('hidden', initToggleBar === false);
        $('#' + moreInfoDialogId).find('.navbar-text.modal-title-label').html('<span class="quoteRefHdr">Quote Ref: <span class="quoteRefHdrTransId">' + meerkat.modules.transactionId.get() + '</span></span>');
    }

    function _trackScroll() {
        var startTopOffset = $elements.moreInfoContainer.offset().top,
            startHeaderHeight = $elements.modalHeader.height(),
            calculatedHeight = startTopOffset;

        $('.modal-body').off("scroll.moreInfoXS").on("scroll.moreInfoXS", function () {

            var currentTopOffset = $elements.moreInfoContainer.offset().top;
            var currentTopOffsetLtCalcHght = currentTopOffset < calculatedHeight;
            var currentTopOffsetGtOrEqlToCalcHght = currentTopOffset >= calculatedHeight;

            if (calculatedHeight === startTopOffset) {
                // need to get the newly calculated height since we hide some data
                calculatedHeight = startTopOffset - (startHeaderHeight - $elements.modalHeader.height());
            }

            $elements.modalHeader.find('.lhcText').toggleClass('hidden', currentTopOffsetLtCalcHght);
            $elements.modalHeader.find('.printableBrochuresLink').toggleClass('hidden', currentTopOffsetLtCalcHght);
            $elements.modalHeader.find('.productTitleText').toggleClass('hidden', currentTopOffsetLtCalcHght);

            $elements.modalHeader.find('.dockedHdr')
                .toggleClass('dockedHeaderSlim', currentTopOffsetLtCalcHght)
                .toggleClass('dockedHeaderLarge', currentTopOffsetGtOrEqlToCalcHght);

            $('#' + moreInfoDialogId).find('.xs-results-pagination').toggleClass('dockedHeaderSlim', currentTopOffsetLtCalcHght);

            if (meerkat.modules.healthPyrrCampaign.isPyrrActive()) {
                $elements.modalHeader.find('.pyrrMoreInfoXSContainer').toggleClass('hidden', currentTopOffsetLtCalcHght);

            }

            if (meerkat.modules.healthDualPricing.isDualPricingActive() && meerkat.modules.deviceMediaState.get() === 'xs') {
                $elements.modalHeader.find('.april-container').toggleClass('hidden', currentTopOffsetLtCalcHght);
                $elements.currentPricingContainer
                    .toggleClass('col-xs-12', currentTopOffsetLtCalcHght)
                    .toggleClass('col-xs-6', currentTopOffsetGtOrEqlToCalcHght);

                $elements.pricingContainer
                    .toggleClass('col-xs-6', currentTopOffsetLtCalcHght)
                    .toggleClass('col-xs-12', currentTopOffsetGtOrEqlToCalcHght);


                $elements.currentPricingDetails.toggleClass('hidden', currentTopOffsetLtCalcHght);
                $elements.modalHeader.find('.current-pricing').toggleClass('no-background', currentTopOffsetLtCalcHght);
            }

            if(moreInfoDialogId && meerkat.modules.deviceMediaState.get() === 'xs') {
                meerkat.modules.dialogs.resizeDialog(moreInfoDialogId);
            }
        });
    }

    /**
     * HLT has different format of product json, so need to send different properties.
     */
    function additionalTrackingData() {
        var product = meerkat.modules.moreInfo.getOpenProduct();
        if (!product) {
            return;
        }
        var settings = {
            additionalTrackingData: {
                productName: product.info.productTitle,
                productBrandCode: product.info.providerName
            }
        };
        meerkat.modules.moreInfo.updateSettings(settings);
    }

    function onBeforeHideTemplate() {
        // unfade all headers
        $(Results.settings.elements.page).find(".result").removeClass("faded");
        dynamicPyrrBanner();
    }

    function initialiseBrochureEmailForm(product, parent, form) {
        var emailBrochuresElement = parent.find('.moreInfoEmailBrochures');
        emailBrochuresElement.show();
        var benefitCodes = meerkat.modules.benefitsModel.getCodesForSelectedBenefits();
        var currentPHI = meerkat.modules.healthUtils.getPrimaryCurrentPHI();
        var specialOffer = meerkat.modules.healthUtils.getSpecialOffer(product);
        var excessesAndCoPayment = meerkat.modules.healthUtils.getExcessesAndCoPayment(product);

        meerkat.modules.emailBrochures.setup({
            emailInput: emailBrochuresElement.find('.sendBrochureEmailAddress'),
            submitButton: emailBrochuresElement.find('.btn-email-brochure'),
            form: form,
            marketing: emailBrochuresElement.find('.optInMarketing'),
            emailHistoryInput: $('#health_brochureEmailHistory'),
            productData: [
                { name: "hospitalPDSUrl", value: product.promo.hospitalPDF },
                { name: "extrasPDSUrl", value: product.promo.extrasPDF },
                { name: "provider", value: product.info.provider },
                { name: "providerName", value: product.info.providerName },
                { name: "productName", value: product.info.productTitle },
                { name: "productId", value: product.productId },
                { name: "productCode", value: product.info.productCode },
                { name: "premium", value: product.premium[Results.settings.frequency].lhcfreetext },
                { name: "premiumText", value: product.premium[Results.settings.frequency].lhcfreepricing },
                // Additional information
                // NOTE: healthSituation question does not exist in V4 (e.g. 'wanting to compare'
                { name: "healthSituation", value: "" },
                { name: "primaryCurrentPHI", value: currentPHI },
                { name: "coverType", value: product.info.ProductType },
                { name: "benefitCodes", value: benefitCodes.join(',') },
                { name: "specialOffer", value: specialOffer.specialOffer },
                { name: "specialOfferTerms", value: specialOffer.specialOfferTerms },
                { name: "excessPerAdmission", value: excessesAndCoPayment.excessPerAdmission },
                { name: "excessPerPerson", value: excessesAndCoPayment.excessPerPerson },
                { name: "excessPerPolicy", value: excessesAndCoPayment.excessPerPolicy },
                { name: "coPayment", value: excessesAndCoPayment.coPayment }
            ],
            product: product,
            identifier: "SEND_BROCHURES" + product.productId,
            emailResultsSuccessCallback: function onSendBrochuresCallback(result, settings) {
                if (result.success) {
                    parent.find('.formInput').hide();
                    parent.find('.moreInfoEmailBrochuresSuccess').removeClass("hidden");
                    meerkat.modules.emailBrochures.tearDown(settings);
                    meerkat.modules.healthResults.setSelectedProduct(product);
                } else {
                    meerkat.modules.errorHandling.error({
                        errorLevel: 'warning',
                        message: 'Oops! Something seems to have gone wrong. Please try again by re-entering your email address or ' +
                        'alternatively contact our call centre on <span class=\"callCentreHelpNumber\">' + meerkat.site.content.callCentreHelpNumber + '</span> and they\'ll be able to assist you further.',
                        page: 'healthMoreInfo.js:onSendBrochuresCallback',
                        description: result.message,
                        data: product
                    });
                }
            }
        });
    }

    /**
     * Set the current scroll position so that it can be used when modals are closed
     */
    function setScrollPosition() {
        scrollPosition = $(window).scrollTop();
    }

    /**
     * Sets the view state for when your bridging page or modal is open.
     * Called from meerkat.modules.moreInfo.openBridgingPage
     */
    function onBeforeShowBridgingPage($this) {

        setScrollPosition();

        var data = {
            actionStep: 'Health More Info'
        };
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackQuoteForms',
            object: data
        });

        // hide the results before showing the more info page (except for xs as we use a modal)
        if (meerkat.modules.deviceMediaState.get() != 'xs') {
            $('.resultsContainer, .resultsHeadersBg, .resultsMarketingMessages, .resultsMarketingMessage, #results-sidebar, .results-column-container, .results-prologue-row').addClass("hidden");
        }
        meerkat.messaging.publish(meerkatEvents.filters.FILTERS_CANCELLED);
    }

    function onAfterHideTemplate() {
        $('.resultsContainer, .resultsHeadersBg, .resultsMarketingMessages, .resultsMarketingMessage, #results-sidebar, .results-column-container, .results-prologue-row').removeClass("hidden");
        $(window).scrollTop(scrollPosition);
    }

    //
    // Sort out inclusions, restrictions and hospital/extras for this product if not done already
    //
    function prepareCover() {

        // The product object in moreInfo is updated by reference i.e. this does not create a "copy" of the product object, it IS the product object.
        var product = meerkat.modules.moreInfo.getProduct();
        if (typeof product.hospitalCover === "undefined") {
            // Ensure this is a Hospital product before trying to use the benefits properties
            if (typeof product.hospital !== 'undefined' && typeof product.hospital.benefits !== 'undefined') {
                prepareCoverFeatures("hospital.benefits", "hospitalCover");
            }
        }

        if (typeof product.extrasCover === "undefined") {
            // Ensure this is a Extras product before trying to use the benefits properties
            if (typeof product.extras !== 'undefined' && typeof product.extras === 'object') {
                prepareCoverFeatures("extras", "extrasCover");
            }

        }

        prepareTestimonial();
    }

    /**
     * Gets one of the testimonials from a set list
     * @return void
     */
    function prepareTestimonial() {
        // Updates by reference
        var product = meerkat.modules.moreInfo.getProduct();
        product.testimonial = testimonials[_.random(0, testimonials.length - 1)];
    }

    /**
     *
     * @param product A reference to the existing product object.
     * @returns {*}
     */
    function retrieveExternalCopy(product) {

        // Default text in case an ajax error occurs
        product.aboutFund = '<p>Apologies. This information did not download successfully.</p>';
        product.whatHappensNext = '<p>Apologies. This information did not download successfully.</p>';
        product.warningAlert = '';
        product.dropDeadDate = '31/3/2016';
        product.dropDeadDateFormatted = '31st March 2016';

        // Get the "about fund", "what happens next" and warningAlert info
        return $.when(
            getProviderContentByType(product, 'ABT'),
            getProviderContentByType(product, 'NXT'),
            getProviderContentByType(product, 'FWM'),
            getProviderContentByType(product, 'DDD')
        );
    }

    /**
     *
     * @param product
     * @param providerContentTypeCode
     * @return promise
     */
    function getProviderContentByType(product, providerContentTypeCode) {

        var data = {};
        data.providerId = product.info.providerId;
        data.providerContentTypeCode = providerContentTypeCode;
        data.styleCode = meerkat.site.tracking.brandCode;

        if (typeof data.providerId === 'undefined' || data.providerId === '') {
            meerkat.modules.errorHandling.error({
                message: "providerId is empty",
                page: "healthMoreInfo.js:getProviderContentByType",
                errorLevel: "silent",
                description: "providerId is empty providerContentTypeCode: " + providerContentTypeCode,
                data: product
            });
        } else {
            return meerkat.modules.comms.get({
                url: "health/provider/content/get.json",
                data: data,
                cache: true,
                errorLevel: "silent",
                onSuccess: function getProviderContentSuccess(result) {
                    if (result.hasOwnProperty('providerContentText')) {
                        switch (providerContentTypeCode) {
                            case 'ABT':
                                product.aboutFund = result.providerContentText;
                                break;
                            case 'NXT':
                                product.whatHappensNext = result.providerContentText;
                                break;
                            case 'FWM':
                                product.warningAlert = result.providerContentText;
                                break;
                            case 'DDD':
                                meerkat.modules.dropDeadDate.setDropDeadDate(result.providerContentText, product);
                                break;
                        }
                    }
                }
            });
        }
    }

    function prepareCoverFeatures(searchPath, target) {
        // Updates by reference
        var product = meerkat.modules.moreInfo.getProduct();
        product[target] = {
            inclusions: [],
            restrictions: [],
            exclusions: []
        };

        if (target == "hospitalCover") {
            coverSwitch(product.hospital.inclusions.publicHospital, "hospitalCover", {
                name: "Public Hospital",
                className: "HLTicon-hospital"
            });
            coverSwitch(product.hospital.inclusions.privateHospital, "hospitalCover", {
                name: "Private Hospital",
                className: "HLTicon-hospital"
            });
        }

        var lookupKey;
        var name;
        _.each(Object.byString(product, searchPath), function eachBenefit(benefit, key) {

            lookupKey = searchPath + "." + key + ".covered";
            var foundObject = _.findWhere(resultLabels, { "p": lookupKey });

            if (typeof foundObject !== "undefined") {
                coverSwitch(benefit.covered, target, $.extend(benefit, {
                    name: foundObject.n,
                    className: foundObject.c
                }));
            }

        });

    }

    function coverSwitch(cover, target, benefit) {
        // Updates by reference
        var product = meerkat.modules.moreInfo.getProduct();
        switch (cover) {
            case 'Y':
                product[target].inclusions.push(benefit);
                break;
            case 'R':
                product[target].restrictions.push(benefit);
                break;
            case 'N':
                product[target].exclusions.push(benefit);
                break;
        }
    }

    function populateBrochureEmail() {
        var emailAddress = $('#health_contactDetails_email').val();
        if (emailAddress !== "") {
            $('input[name=emailAddress].sendBrochureEmailAddress').val(emailAddress).trigger('blur');
        }
    }

    function updateTopPositionVariable() {
        topPosition = $('.resultsHeadersBg').height();
    }

    function hasPublicHospital(inclusions) {
        if (!inclusions) {
            return false;
        }
        for (var i = 0; i < inclusions.length; i++) {
            if (inclusions[i] && inclusions[i].name.indexOf('Public Hospital') !== -1) {
                return true;
            }
        }
        return false;
    }

    meerkat.modules.register("healthMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        prepareCover: prepareCover,
        retrieveExternalCopy: retrieveExternalCopy,
        applyEventListeners: applyEventListeners,
        hasPublicHospital: hasPublicHospital,
        dynamicPyrrBanner: dynamicPyrrBanner
    });

})(jQuery);
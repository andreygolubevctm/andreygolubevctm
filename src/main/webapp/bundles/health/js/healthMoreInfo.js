;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var events = {
            healthMoreInfo: {}
        },
        moduleEvents = events.healthMoreInfo;

    var $bridgingContainer = $('.bridgingContainer'),
        topPosition,
        htmlTemplate,
        product,
        modalId,
        isModalOpen = false,
        isBridgingPageOpen = false,
        $moreInfoElement;


    function initMoreInfo() {
        var options = {
            container: $bridgingContainer,
            updateTopPositionVariable: updateTopPositionVariable,
            modalOptions: {
                className: 'modal-breakpoint-wide modal-tight bridgingContainer',
                openOnHashChange: false,
                leftBtn: {
                    label: 'All Products',
                    icon: '<span class="icon icon-arrow-left"></span>',
                    callback: function (eventObject) {
                        $(eventObject.currentTarget).closest('.modal').modal('hide');
                    }
                }
            },
            runDisplayMethod: runDisplayMethod,
            onBeforeShowBridgingPage: null,
            onBeforeShowTemplate: onBeforeShowTemplate,
            onBeforeShowModal: onBeforeShowModal,
            onAfterShowModal: onAfterShowModal,
            onAfterShowTemplate: onAfterShowTemplate,
            onBeforeHideTemplate: null,
            onAfterHideTemplate: null,
            onClickApplyNow: onClickApplyNow,
            onBeforeApply: onBeforeApply,
            onApplySuccess: onApplySuccess,
            retrieveExternalCopy: retrieveExternalCopy,
            onBreakpointChangeCallback: onBreakpointChange
        };

        meerkat.modules.moreInfo.initMoreInfo(options);

        eventSubscriptions();
        applyEventListeners();
    }

    /**
     * Health specific event listeners
     */
    function applyEventListeners() {

        // Add dialog on "promo conditions" links
        $(document.body).on("click", ".dialogPop", function promoConditionsLinksClick() {

            meerkat.modules.dialogs.show({
                title: $(this).attr("title"),
                htmlContent: $(this).attr("data-content")
            });

        });

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

        // declared in ????
        healthFunds.load(product.info.provider, applyCallback);
        meerkat.modules.healthResults.setSelectedProduct(product);

        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product: product,
            type: meerkat.site.isCallCentreUser ? "Simples" : "Online",
            quoteReferenceNumber: transaction_id,
            transactionID: transaction_id,
            productID: product.productId.replace("PHIO-HEALTH-", ""),
            productName: product.info.name,
            productBrandCode: product.info.FundCode,
            simplesUser: meerkat.site.isCallCentreUser
        }, false);

    }

    function onBreakpointChange() {
        meerkat.modules.moreInfo.updateTopPositionVariable();
    }

    function eventSubscriptions() {

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
            if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
                meerkat.modules.moreInfo.close();
            }
            // HLT currently unbinds then rebinds the event to btn-more-info?
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
            if (meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
            // HLT currently unbinds then rebinds the event to btn-more-info?
        });

        meerkat.messaging.subscribe(moduleEvents.bridgingPage.SHOW, function (state) {
            adaptResultsPageHeight(state.isOpen);
        });
        meerkat.messaging.subscribe(moduleEvents.bridgingPage.HIDE, function (state) {
            adaptResultsPageHeight(state.isOpen);
        });

    }

    function onBeforeShowTemplate(jsonResult) {
        if (meerkat.site.emailBrochures.enabled) {
            // initialise send brochure email button functionality
            //TODO: Fix this so we can get moreInfoContainer
            initialiseBrochureEmailForm(product, moreInfoContainer, $('#resultsForm'));
            populateBrochureEmail();
        }

        // Insert next_info_all_funds
        $('.more-info-content .next-info-all').html($('.more-info-content .next-steps-all-funds-source').html());
    }

    /**
     * Handles how you want to display the bridging page based on your viewport/requirements
     */
    function runDisplayMethod(productId) {
        if (meerkat.modules.deviceMediaState.get() != 'xs') {
            meerkat.modules.moreInfo.showTemplate($bridgingContainer);
        } else {
            meerkat.modules.moreInfo.showModal();

        }
        meerkat.modules.address.appendToHash('moreinfo');
    }

    function onAfterShowTemplate() {
        // Set the correct phone number
        meerkat.modules.healthPhoneNumber.changePhoneNumber();

        // hide elements based on marketing segments
        meerkat.modules.healthSegment.hideBySegment();

        // Add to the hidden fields for later use in emails
        $('#health_fundData_hospitalPDF').val(product.promo.hospitalPDF !== undefined ? meerkat.site.urls.base + product.promo.hospitalPDF : "");
        $('#health_fundData_extrasPDF').val(product.promo.extrasPDF !== undefined ? meerkat.site.urls.base + product.promo.extrasPDF : "");
        $('#health_fundData_providerPhoneNumber').val(product.promo.providerPhoneNumber !== undefined ? product.promo.providerPhoneNumber : "");
    }

    function onAfterShowModal() {

    }

    function _requestTracking(product) {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackProductView',
            object: {
                productID: product.productId,
                productBrandCode: product.info.providerName,
                productName: product.info.productTitle,
                simplesUser: meerkat.site.isCallCentreUser
            }
        });
    }
    function adaptResultsPageHeight(isOpen) {
        if (isOpen) {
            $(Results.settings.elements.page).css("overflow", "hidden").height($moreInfoElement.outerHeight());
        } else {
            $(Results.settings.elements.page).css("overflow", "visible").height("");
        }
    }

    function hide(target) {
        // unfade all headers
        $(Results.settings.elements.page).find(".result").removeClass("faded");

        // reset button to default one
        $('.btn-close-more-info').removeClass("btn-close-more-info").addClass("btn-more-info");

        target.slideUp(400, function hideMoreInfo() {
            target.html('').hide();
            isBridgingPageOpen = false;
            meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {isOpen: isBridgingPageOpen});
            meerkat.messaging.publish(moduleEvents.bridgingPage.HIDE, {isOpen: isBridgingPageOpen});
        });
    }

    function openModalClick(event) {
        var $this = $(this),
            productId = $this.attr("data-productId"),
            showApply = $this.hasClass('more-info-showapply');
        setProduct(Results.getResult("productId", productId), showApply);

        openModal();
    }

    function openModal() {
        prepareProduct(function moreInfoOpenModalSuccess() {

            var htmlString = "<form class='healthMoreInfoModel'>" + htmlTemplate(product) + "</form>";
            modalId = meerkat.modules.dialogs.show({
                htmlContent: htmlString,
                className: "modal-breakpoint-wide modal-tight",
                onOpen: function onOpen(id) {
                    if (meerkat.site.emailBrochures.enabled) {
                        initialiseBrochureEmailForm(product, $('#' + id), $('#' + id).find('.healthMoreInfoModel'));
                    }
                }
            });


            // Insert next_info_all_funds
            $('.more-info-content .next-info .next-info-all').html($('.more-info-content .next-steps-all-funds-source').html());

            // Move dual-pricing panel
            $('.more-info-content .moreInfoRightColumn > .dualPricing').insertAfter($('.more-info-content .moreInfoMainDetails'));

            isModalOpen = true;

            $(".more-info-content").show();

            // Set the correct phone number
            meerkat.modules.healthPhoneNumber.changePhoneNumber(true);

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackProductView',
                object: {
                    productID: product.productId,
                    productBrandCode: product.info.providerName,
                    productName: product.info.productTitle,
                    simplesUser: meerkat.site.isCallCentreUser
                }
            });
        });
    }

    function initialiseBrochureEmailForm(product, parent, form) {
        var emailBrochuresElement = parent.find('.moreInfoEmailBrochures');
        emailBrochuresElement.show();
        meerkat.modules.emailBrochures.setup({
            emailInput: emailBrochuresElement.find('.sendBrochureEmailAddress'),
            submitButton: emailBrochuresElement.find('.btn-email-brochure'),
            form: form,
            marketing: emailBrochuresElement.find('.optInMarketing'),
            productData: [
                {name: "hospitalPDSUrl", value: product.promo.hospitalPDF},
                {name: "extrasPDSUrl", value: product.promo.extrasPDF},
                {name: "provider", value: product.info.provider},
                {name: "providerName", value: product.info.providerName},
                {name: "productName", value: product.info.productTitle},
                {name: "productId", value: product.productId},
                {name: "productCode", value: product.info.productCode},
                {name: "premium", value: product.premium[Results.settings.frequency].lhcfreetext},
                {name: "premiumText", value: product.premium[Results.settings.frequency].lhcfreepricing}
            ],
            product: product,
            identifier: "SEND_BROCHURES" + product.productId,
            emailResultsSuccessCallback: function onSendBrochuresCallback(result, settings) {
                if (result.success) {
                    parent.find('.formInput').hide();
                    parent.find('.moreInfoEmailBrochuresSuccess').show();
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

    function closeModal() {
        $('#' + modalId).modal('hide');
        isModalOpen = false;
    }

    function openbridgingPageDropdown(event) {
        var $this = $(this);

        // fade all other headers
        $(Results.settings.elements.page).find(".result").addClass("faded");

        // reset all the close buttons (there should only be one) to default button
        $(".btn-close-more-info").removeClass("btn-close-more-info").addClass("btn-more-info");

        // unfade the header from the clicked button
        $this.parents(".result").removeClass("faded");

        // replace clicked button with close button
        $this.removeClass("btn-more-info").addClass("btn-close-more-info");

        var productId = $this.attr("data-productId"),
            showApply = $this.hasClass('more-info-showapply');

        setProduct(Results.getResult("productId", productId), showApply);

        // disable the fixed header
        meerkat.modules.resultsHeaderBar.disableAffixMode();

        // load, parse and show the bridging page
        show($moreInfoElement);

    }

    function closeBridgingPageDropdown(event) {
        hide($moreInfoElement);

        // re-enable the fixed header
        meerkat.modules.resultsHeaderBar.enableAffixMode();

        if (isModalOpen) {
            // hide the xs modal
            closeModal();
        }
    }

    function setProduct(productToParse, showApply) {
        product = productToParse;

        if (product !== false) {
            if (showApply === true) {
                product.showApply = true;
            } else {
                product.showApply = false;
            }
        }


        return product;
    }

    function getOpenProduct() {
        if (isBridgingPageOpen === false) return null;
        return product;
    }

    function prepareProduct(successCallback) {
        prepareCover();
        prepareExternalCopy(successCallback);
    }

    //
    // Sort out inclusions, restrictions and hospital/extras for this product if not done already
    //
    function prepareCover() {
        if (typeof product.hospitalCover === "undefined") {
            // Ensure this is a Hospital product before trying to use the benefits properties
            if (typeof product.hospital !== 'undefined' && typeof product.hospital.benefits !== 'undefined') {

                prepareCoverFeatures("hospital.benefits", "hospitalCover");

                coverSwitch(product.hospital.inclusions.publicHospital, "hospitalCover", "Public Hospital");
                coverSwitch(product.hospital.inclusions.privateHospital, "hospitalCover", "Private Hospital");
            }
        }

        if (typeof product.extrasCover === "undefined") {
            // Ensure this is a Extras product before trying to use the benefits properties
            if (typeof product.extras !== 'undefined' && typeof product.extras === 'object') {

                prepareCoverFeatures("extras", "extrasCover");

            }
        }
    }

    function prepareExternalCopy(successCallback) {

        // Default text in case an ajax error occurs
        product.aboutFund = '<p>Apologies. This information did not download successfully.</p>';
        product.whatHappensNext = '<p>Apologies. This information did not download successfully.</p>';
        product.warningAlert = '';

        // Get the "about fund", "what happens next" and warningAlert info
        $.when(
            meerkat.modules.comms.get({
                url: "health_fund_info/" + product.info.provider + "/about.html",
                cache: true,
                errorLevel: "silent",
                onSuccess: function aboutFundSuccess(result) {
                    product.aboutFund = result;
                }
            }),
            meerkat.modules.comms.get({
                url: "health_fund_info/" + product.info.provider + "/next_info.html",
                cache: true,
                errorLevel: "silent",
                onSuccess: function whatHappensNextSuccess(result) {
                    product.whatHappensNext = result;
                }
            }),
            meerkat.modules.comms.get({
                url: "health/quote/dualPrising/getFundWarning.json",
                data: {providerId: product.info.providerId},
                cache: true,
                errorLevel: "silent",
                onSuccess: function warningAlertSuccess(result) {
                    product.warningAlert = result.warningMessage;
                }
            })
        )
            .then(
            successCallback,
            successCallback //the 'fail' function, but we handle the ajax fails above.
        );

    }

    function prepareCoverFeatures(searchPath, target) {

        product[target] = {
            inclusions: [],
            restrictions: [],
            exclusions: []
        };

        var lookupKey;
        var name;
        _.each(Object.byString(product, searchPath), function eachBenefit(benefit, key) {

            lookupKey = searchPath + "." + key + ".covered";
            foundObject = _.findWhere(resultLabels, {"p": lookupKey});

            if (typeof foundObject !== "undefined") {
                name = foundObject.n;
                coverSwitch(benefit.covered, target, name);
            }

        });

    }

    function coverSwitch(cover, target, name) {
        switch (cover) {
            case 'Y':
                product[target].inclusions.push(name);
                break;
            case 'R':
                product[target].restrictions.push(name);
                break;
            case 'N':
                product[target].exclusions.push(name);
                break;
        }
    }

    function populateBrochureEmail() {
        var emailAddress = $('#health_contactDetails_email').val();
        if (emailAddress !== "") {
            $('#emailAddress').val(emailAddress).trigger('blur');
        }
    }

    function updateTopPositionVariable() {
        topPosition = $('.resultsHeadersBg').height();
    }
    meerkat.modules.register("healthMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        setProduct: setProduct,
        prepareProduct: prepareProduct,
        prepareCover: prepareCover,
        prepareExternalCopy: prepareExternalCopy,
        getOpenProduct: getOpenProduct,
        close: closeBridgingPageDropdown,
        applyEventListeners: applyEventListeners
    });

})(jQuery);
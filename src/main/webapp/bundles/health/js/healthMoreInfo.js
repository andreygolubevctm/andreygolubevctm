;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var events = {
            healthMoreInfo: {}
        },
        moduleEvents = events.healthMoreInfo;

    var $bridgingContainer = $('.moreInfoDropdown'),
        topPosition;


    function initMoreInfo() {

        var options = {
            container: $bridgingContainer,
            updateTopPositionVariable: updateTopPositionVariable,
            showActionWhenOpen: 'fadeIn',
            modalOptions: {
                className: 'modal-breakpoint-wide modal-tight bridgingContainer',
                openOnHashChange: false,
                leftBtn: {
                    label: 'All Products',
                    icon: '<span class="icon icon-arrow-left"></span>',
                    callback: function (eventObject) {
                        $(eventObject.currentTarget).closest('.modal').modal('hide');
                    }
                },
                onClose: function() {
                    onBeforeHideTemplate();
                    meerkat.modules.moreInfo.close();
                },
                onOpen: function(dialogId){
                    // just fighting Bootstrap here...
                    // It seems to think that because the body is overflowing, it needs to add right padding to cater for the scrollbar width
                    // so taking that off once the modal is open
                    $("#"+dialogId).css('padding-right', '0px');
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
    }

    /**
     * Health specific event listeners
     */
    function applyEventListeners() {

        $(document.body).on("click", ".more-info", function moreInfoLinkClick(event) {
            var product = Results.getSelectedProduct();
            if(!product) {
                return;
            }

            $(this).attr('data-productId', product.productId).attr('data-available', product.available);
            // Need to pass the context of this click through.
            meerkat.modules.moreInfo.open.apply(this, [event]);
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

        meerkat.modules.healthResults.setSelectedProduct(product);
        // this variable declared in __health_legacy.js
        healthFunds.load(product.info.provider, applyCallback);

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

        meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.SHOW, function (state) {
            $(Results.settings.elements.page).css("overflow", "hidden").height($bridgingContainer.outerHeight());
        });
        meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.HIDE, function (state) {
            $(Results.settings.elements.page).css("overflow", "visible").height("");
        });

    }

    /**
     * Handles how you want to display the bridging page based on your viewport/requirements
     */
    function runDisplayMethod(productId) {
        var currStep = meerkat.modules.journeyEngine.getCurrentStep().navigationId;
        if (meerkat.modules.deviceMediaState.get() != 'xs' &&  currStep != 'apply' && currStep != 'payment') {
            meerkat.modules.resultsHeaderBar.disableAffixMode();
            meerkat.modules.moreInfo.showTemplate($bridgingContainer);
        } else {
            meerkat.modules.moreInfo.showModal();

        }
        meerkat.modules.address.appendToHash('moreinfo');
    }

    function onBeforeShowTemplate(jsonResult, moreInfoContainer) {
        if (meerkat.site.emailBrochures.enabled) {
            // initialise send brochure email button functionality
            initialiseBrochureEmailForm(Results.getSelectedProduct(), moreInfoContainer, $('#resultsForm'));
            populateBrochureEmail();
        }
    }

    function onAfterShowTemplate() {
        // Set the correct phone number
        meerkat.modules.healthPhoneNumber.changePhoneNumber();

        // hide elements based on marketing segments
        meerkat.modules.healthSegment.hideBySegment();
        additionalTrackingData();

        var product = Results.getSelectedProduct();
        // Add to the hidden fields for later use in emails
        $('#health_fundData_hospitalPDF').val(product.promo.hospitalPDF !== undefined ? meerkat.site.urls.base + product.promo.hospitalPDF : "");
        $('#health_fundData_extrasPDF').val(product.promo.extrasPDF !== undefined ? meerkat.site.urls.base + product.promo.extrasPDF : "");
        $('#health_fundData_providerPhoneNumber').val(product.promo.providerPhoneNumber !== undefined ? product.promo.providerPhoneNumber : "");
    }

    function onBeforeShowModal(jsonResult, dialogId) {

        $('#'+dialogId).find('.modal-body').children().wrap("<form class='healthMoreInfoModel'></form>");

        if (meerkat.site.emailBrochures.enabled) {
            initialiseBrochureEmailForm(Results.getSelectedProduct(), $('#' + dialogId), $('#' + dialogId).find('.healthMoreInfoModel'));
        }

        // Move dual-pricing panel
        $('.more-info-content .moreInfoRightColumn > .dualPricing').insertAfter($('.more-info-content .moreInfoMainDetails'));
        populateBrochureEmailForModel();
    }

    function onAfterShowModal() {
        additionalTrackingData();
        meerkat.modules.healthPhoneNumber.changePhoneNumber(true);
    }


    /**
     * HLT has different format of product json, so need to send different properties.
     */
    function additionalTrackingData() {
        var product = meerkat.modules.moreInfo.getOpenProduct();
        if(!product) {
            return;
        }
        var settings = {
            additionalTrackingData : {
                productName : product.info.productTitle,
                productBrandCode: product.info.providerName
            }
        };
        meerkat.modules.moreInfo.updateSettings(settings);
    }

    function onBeforeHideTemplate() {
        // unfade all headers
        $(Results.settings.elements.page).find(".result").removeClass("faded");
        // reset button to default one
        $('.btn-close-more-info').removeClass("btn-close-more-info").addClass("btn-more-info");
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

    function onBeforeShowBridgingPage($this) {
        $(Results.settings.elements.page).find(".result").addClass("faded");
        // reset all the close buttons (there should only be one) to default button
        $(".btn-close-more-info").removeClass("btn-close-more-info").addClass("btn-more-info");
        // unfade the header from the clicked button
        $this.parents(".result").removeClass("faded");
        // replace clicked button with close button
        $this.removeClass("btn-more-info").addClass("btn-close-more-info");

        var data = {
            actionStep: 'Health More Info'
        };
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackQuoteForms',
            object: data
        });
    }

    function onAfterHideTemplate() {
        meerkat.modules.resultsHeaderBar.enableAffixMode();
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

        // Get the "about fund", "what happens next" and warningAlert info
        return $.when(
            getProviderContentByType( product, 'ABT'),
            getProviderContentByType( product, 'NXT'),
            getProviderContentByType( product, 'FWM')
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
                    }
                }
            }
        });
    }

    function prepareCoverFeatures(searchPath, target) {
        // Updates by reference
        var product = meerkat.modules.moreInfo.getProduct();
        product[target] = {
            inclusions: [],
            restrictions: [],
            exclusions: []
        };

        var lookupKey;
        var name;
        _.each(Object.byString(product, searchPath), function eachBenefit(benefit, key) {

            lookupKey = searchPath + "." + key + ".covered";
            var foundObject = _.findWhere(resultLabels, {"p": lookupKey});

            if (typeof foundObject !== "undefined") {
                name = foundObject.n;
                coverSwitch(benefit.covered, target, name);
            }

        });

    }

    function coverSwitch(cover, target, name) {
        // Updates by reference
        var product = meerkat.modules.moreInfo.getProduct();
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
            $('input[name=emailAddress].sendBrochureEmailAddress').val(emailAddress).trigger('blur');
        }
    }
    function populateBrochureEmailForModel() {
        var emailContact = $('#health_contactDetails_email').val();
        var emailApplication = $('#health_application_email').val();
        var emailMoreInfo = $('#emailAddress');
        if(emailApplication === "") {
            emailMoreInfo.val(emailContact).trigger('blur');
        }else{

            emailMoreInfo.val(emailApplication).trigger('blur');
        }
    }
    function updateTopPositionVariable() {
        topPosition = $('.resultsHeadersBg').height();
    }

    meerkat.modules.register("healthMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        prepareCover: prepareCover,
        retrieveExternalCopy: retrieveExternalCopy,
        applyEventListeners: applyEventListeners
    });

})(jQuery);
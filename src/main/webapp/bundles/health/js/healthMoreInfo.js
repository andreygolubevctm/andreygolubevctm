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
        testimonials = [
            {quote:"Compare the Market helped me choose a policy with features relevant to me. I no longer pay for benefits I don't use", author:"Andrea, WA"},
            {quote:"With Compare the Market I was able to find the same level of cover but now save $60 a month off my premium", author:"Geoff, QLD"},
            {quote:"Health insurance is important to us as it gives us the peace of mind that if something went wrong we'd be covered", author:"Julie Barrett, NSW"},
            {quote:"The whole process was really simple and really easy. I’d definitely use comparethemarket.com.au again", author:"Wendy, WA"}
        ];


    function initMoreInfo() {

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
                    label: 'Back to results',
                    icon: '<span class="icon icon-arrow-left"></span>',
                    callback: function (eventObject) {
                        $(eventObject.currentTarget).closest('.modal').modal('hide');
                    }
                },
                onClose: function() {
                    onBeforeHideTemplate();
                    meerkat.modules.moreInfo.close();
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

        $(document.body).on("click", ".next-steps", function nextStepsClick(event) {
            var product = Results.getSelectedProduct();
            if(!product) {
                return;
            }

            var modalId = meerkat.modules.dialogs.show({
                htmlContent: product.whatHappensNext
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

    }

    /**
     * Handles how you want to display the bridging page based on your viewport/requirements
     */
    function runDisplayMethod(productId) {
        var currStep = meerkat.modules.journeyEngine.getCurrentStep().navigationId;
        if (meerkat.modules.deviceMediaState.get() != 'xs' &&  currStep != 'apply' && currStep != 'payment') {
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
        //meerkat.modules.healthSegment.hideBySegment();
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

        fixBootstrapModalPaddingIssue(dialogId);
    }

    function fixBootstrapModalPaddingIssue(dialogId){
        // just fighting Bootstrap here...
        // It seems to think that because the body is overflowing, it needs to add right padding to cater for the scrollbar width
        // so taking that off once the modal is open
        $("#"+dialogId).css('padding-right', '0px');
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
            $('.resultsContainer, .resultsHeadersBg, .resultsMarketingMessages, .resultsMarketingMessage').addClass("hidden");
        }
    }

    function onAfterHideTemplate() {
        $('.resultsContainer, .resultsHeadersBg, .resultsMarketingMessages, .resultsMarketingMessage').removeClass("hidden");
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
    function prepareTestimonial(){
        // Updates by reference
        var product = meerkat.modules.moreInfo.getProduct();
        product.testimonial = testimonials[_.random(0,testimonials.length-1)];
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
            getProviderContentByType( product, 'ABT'),
            getProviderContentByType( product, 'NXT'),
            getProviderContentByType( product, 'FWM'),
            getProviderContentByType( product, 'DDD')
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
                        case 'DDD':
                            var d = new Date(),
                                formattedDate = '';

                            if ($.trim(result.providerContentText) !== '') {
                                dateSplit = result.providerContentText.split("/");
                                rearrangedDate = dateSplit[1]+"/"+dateSplit[0]+"/"+dateSplit[2];
                                newDate = new Date(rearrangedDate);
                                formattedDate = newDate.getDate()+getNth(newDate.getDate())+" of "+(newDate.getMonth() == 2 ? 'March' : 'April') + ", " + newDate.getFullYear();

                                product.dropDeadDateFormatted =  formattedDate;
                                product.dropDeadDate =  new Date(rearrangedDate);
                            } else {
                                product.dropDeadDateFormatted = '31st March '+d.getFullYear();
                                product.dropDeadDate =  new Date('31/3/'+d.getFullYear());
                            }

                            break;
                    }
                }
            }
        });
    }

    function getNth(day) {
        if(day>3 && day<21) return 'th'; // thanks kennebec
        switch (day % 10) {
            case 1:  return "st";
            case 2:  return "nd";
            case 3:  return "rd";
            default: return "th";
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

        if(target == "hospitalCover"){
            coverSwitch(product.hospital.inclusions.publicHospital, "hospitalCover", {name:"Public Hospital", className: "CTM-hospital"});
            coverSwitch(product.hospital.inclusions.privateHospital, "hospitalCover", {name:"Private Hospital", className: "CTM-privatehospital"});
        }

        var lookupKey;
        var name;
        _.each(Object.byString(product, searchPath), function eachBenefit(benefit, key) {

            lookupKey = searchPath + "." + key + ".covered";
            var foundObject = _.findWhere(resultLabels, {"p": lookupKey});

            if (typeof foundObject !== "undefined") {
                coverSwitch(benefit.covered, target, $.extend(benefit, {name: foundObject.n, className: foundObject.c} ));
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
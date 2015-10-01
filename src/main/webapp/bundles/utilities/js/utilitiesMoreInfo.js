(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var events = {
            utilitiesMoreInfo: {
            }
        },
        moduleEvents = events.utilitiesMoreInfo;

    var $bridgingContainer = $('.bridgingContainer'),
        callbackModalId, // the id of the currently displayed callback modal
        scrollPosition, //The position of the page on the modal display
        activeCallModal,
        callDirectTrackingFlag = true; // used to flag when ok to call tracking on CallDirect (once per transaction)

    /**
     * Specify the options within here to pass to meerkat.modules.moreInfo.
     */
    function initMoreInfo() {

        var options = {
            container: $bridgingContainer,
            hideAction: 'fadeOut',
            showAction: 'fadeIn',
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
                }
            },
            runDisplayMethod: runDisplayMethod,
            onBeforeShowBridgingPage: onBeforeShowBridgingPage,
            onBeforeShowTemplate: renderInfo,
            onBeforeShowModal: renderInfo,
            onAfterShowModal: requestTracking,
            onAfterShowTemplate: onAfterShowTemplate,
            onBeforeHideTemplate: null,
            onAfterHideTemplate: onAfterHideTemplate,
            onClickApplyNow: onClickApplyNow,
            onBeforeApply: null,
            onApplySuccess: onApplySuccess,
            retrieveExternalCopy: retrieveExternalCopy,
            additionalTrackingData: {
                productName: null
            },
            onBreakpointChangeCallback : _.bind(resizeSidebarOnBreakpointChange, this, '.paragraphedContent', '.moreInfoRightColumn', $bridgingContainer)
        };

        meerkat.modules.moreInfo.initMoreInfo(options);

        eventSubscriptions();
        applyEventListeners();
    }

    function applyEventListeners() {

        $(document).on('click', '.bridgingContainer .btn-call-actions', function (event) {
            var $el = $(this);
            callActions(event, $el);
        }).on('click', '.call-modal .btn-call-actions', function (event) {
            var $el = $(this);
            modalCallActions(event, $el);
        });
    }

    function resizeSidebarOnBreakpointChange(leftContainer, rightContainer, mainContainer) {
        if (meerkat.modules.deviceMediaState.get() == 'lg' || meerkat.modules.deviceMediaState.get() == 'md') {
            fixSidebarHeight(leftContainer, rightContainer, mainContainer);
        }
    }

    /**
     * Sets a min-height on a right sidebar.
     * @param {String} leftSelector A selector for the left container
     * @param {String} rightSelector A selector for the right container
     * @param {jQuery()} $container An element to provide context so it doesn't set height elsewhere.
     */
    function fixSidebarHeight(leftSelector, rightSelector, $container) {
        if(meerkat.modules.deviceMediaState.get() != 'xs') {
            var $right = $(rightSelector, $container),
                $left = $(leftSelector, $container);
            /* match up sidebar's height with left side or vice versa */
            if($right.length) {
                // firstly reset the height of the columns
                $left.css('min-height', '0px');
                $right.css('min-height', '0px');
                // Then measure the heights to work out which to toggle
                var leftHeight = $left.outerHeight();
                var rightHeight = $right.outerHeight();
                if(leftHeight >= rightHeight) {
                    $right.css('min-height', leftHeight + 'px');
                    $left.css('min-height', leftHeight + 'px');
                } else {
                    $right.css('min-height', rightHeight + 'px');
                    $left.css('min-height', rightHeight + 'px');
                }
            }
        }
    }
    /**
     * Record the fact they've clicked call insurer direct.
     * Only do this once per product, but once per session for supertag.
     * @param {event} event The event object.
     */
    function recordCallDirect(event, product) {
        trackCallDirect(product);// Add CallDirect request event to supertag
    }

    function eventSubscriptions() {

        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function bridgingPageHashChange(event) {
            if (meerkat.modules.deviceMediaState.get() != 'xs' && event.hash.indexOf('results/moreinfo') == -1) {
                meerkat.modules.moreInfo.hideTemplate($bridgingContainer);
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
            if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
                meerkat.modules.moreInfo.close();
            }
            if(typeof callbackModalId != 'undefined') {
                $('#' + callbackModalId).modal('hide');
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
            if (meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
            if(typeof callbackModalId != 'undefined') {
                $('#' + callbackModalId).modal('hide');
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.errorHandling.OK_CLICKED, function errorHandlingOkClicked() {
            if (meerkat.modules.moreInfo.isBridgingPageOpen() || meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.transactionId.CHANGED, function updateCallDirectTrackingFlag() {
            callDirectTrackingFlag = true;
        });

    }

    function callActions(event, element) {
        /**
         * Render the call modal template, set up default name values, fix height
         */
        event.preventDefault();
        event.stopPropagation();
        var $el = element;

        var $e = $('#utilities-call-modal-template');
        if ($e.length > 0) {
            templateCallback = _.template($e.html());
        }
        var obj = Results.getResultByProductId($el.attr('data-productId'));

        // If its unavailable, don't do anything
        // This is if someone tries to fake a bridging page for a "non quote" product.
        if(typeof obj === 'undefined' || obj.available !== "Y")
            return;

        activeCallModal = $el.attr('data-callback-toggle');
        var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);

        var htmlContent = templateCallback(obj);
        var modalOptions = {
            htmlContent: htmlContent,
            hashId: 'call',
            className: 'call-modal ' + obj.brandCode,
            closeOnHashChange: true,
            openOnHashChange: false,
            onOpen: function (modalId) {

                $('.' + activeCallModal).show();
                fixSidebarHeight('.paragraphedContent:visible', '.sidebar-right', $('#'+modalId));

                // for callback later
                // setupCallbackForm();

                if ($el.hasClass('btn-calldirect')) {
                    recordCallDirect(event, obj);
                }/* else {
                    trackCallBack(obj);// Add CallBack request event to supertag
                }*/

                meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);

            },
            onClose: function(modalId) {
                meerkat.modules.sessionCamHelper.setMoreInfoModal();
            }
        };

        if(meerkat.modules.deviceMediaState.get() == 'xs') {
            modalOptions.title = "Reference no. " + meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber();
        }

        callbackModalId = meerkat.modules.dialogs.show(modalOptions);
    }

    function modalCallActions(event, element) {
        /**
         * Just toggle between the modes here in the modal.
         */
        if(meerkat.modules.deviceMediaState.get() != 'xs') {
            event.preventDefault();
        }
        event.stopPropagation();
        var $el = element;
        var obj = Results.getResultByProductId($el.attr('data-productId'));

        activeCallModal = $el.attr('data-callback-toggle');
        var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);

        switch (activeCallModal) {
            case 'calldirect':
                $('.callback').hide();
                $('.calldirect').show();
                recordCallDirect(event, obj);
                break;
            /* for call back-- when implemented later. copy similar functions from car.
            case 'callback':
                $('.calldirect').hide();
                $('.callback').show();
                trackCallBack(obj);// Add CallBack request event to supertag
                break;*/
        }

        // Fix the height of the sidebar
        fixSidebarHeight('.paragraphedContent:visible', '.sidebar-right', $el.closest('.modal.in'));

        // Update session cam virtual page
        meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
    }

    /**
     * Set the current scroll position so that it can be used when modals are closed
     */
    function setScrollPosition() {
        scrollPosition = $(window).scrollTop();
    }
    /**
     * Set the view state for when your bridging page or modal is open.
     * Called from meerkat.modules.moreInfo.openBridgingPage
     */
    function onBeforeShowBridgingPage() {
        setScrollPosition();
        if (meerkat.modules.deviceMediaState.get() != 'xs') {
            $('.resultsContainer').hide();
            $('.sortbar-container').addClass('hidden');
        }
    }

    /**
     * Things to do once the template is displayed.
     * Called within meerkat.modules.moreInfo.showTemplate
     */
    function onAfterShowTemplate() {

        requestTracking();

        if (meerkat.modules.deviceMediaState.get() == 'lg' || meerkat.modules.deviceMediaState.get() == 'md') {
            fixSidebarHeight('.paragraphedContent', '.moreInfoRightColumn', $bridgingContainer);
        }
    }
    /**
     * Restores the original state of the view from what you changed in onBeforeShowTemplate
     * or onBeforeShowBridgingPage (template only, not modal)
     * Called within meerkat.modules.moreInfo.hideTemplate
     */
    function onAfterHideTemplate() {
        $('.resultsContainer').show();
        $('.sortbar-container').removeClass('hidden');
        $(window).scrollTop(scrollPosition);
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

    /**
     * Retrieves the data used for the bridging page.
     */
    function retrieveExternalCopy(product) {
        return meerkat.modules.comms.post({
            url: "utilities/moreinfo/get.json",
            cache: true,
            data: {
                productId: product.productId
            },
            errorLevel: "silent",
            onSuccess: function (result) {
                meerkat.modules.moreInfo.setDataResult(result);
            }
        });
    }

    /**
     * When you click the btn-more-info-apply.
     * Pre-dispatch checking and functionality.
     * @param {POJO} product The selected product
     * @param {Function} applyNowCallback - the function to run on a successful apply now click.
     */
    function onClickApplyNow(product, applyNowCallback) {

        Results.model.setSelectedProduct($('.btn-more-info-apply').attr('data-productId'));
        meerkat.modules.utilities.trackHandover();

        // otherwise just do it.
        meerkat.modules.journeyEngine.gotoPath("next");
    }

    /**
     * Performs the supertag trackBridgingClick tracking for the CrCallDir 'type'.
     * Will only be sent to superTag once per session.
     * As discussed with Elvin & Tim, we won't change supertag stats, but its ok
     * to send multiple transaction detail saves.
     */
    function trackCallDirect(product){
        if(callDirectTrackingFlag === true) {
            callDirectTrackingFlag = false;
            trackCallEvent('CrCallDir', product);
        }
    }

    /**
     * Tracks a click on call direct or call back.
     */
    function trackCallEvent(type, product) {
        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product:				product,
            type:					type,
            quoteReferenceNumber:	meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber() || meerkat.modules.transactionId.get(),
            productID:				product.productId,
            productName:			product.planName,
            productBrandCode:		product.brandCode
        }, {type: "CD", productId: product.productId});
    }

    /**
     * Track when we open a bridging page.
     */
    function trackProductView(){
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method:	'trackQuoteForms',
            object:	_.bind(meerkat.modules.utilities.getTrackingFieldsObject, this, true)
        });
    }

    function requestTracking() {
        var settings = {
            additionalTrackingData : {
                productName : Results.getSelectedProduct().planName
            }
        };

        meerkat.modules.moreInfo.updateSettings(settings);

        trackProductView();
    }

    /**
     *  Render the scrapes onto the placeholders in the page.
     */
    function renderInfo(json) {

        if(json === null || typeof json === 'undefined') {
            return;
        }

        for(var key in json) {
            if(json.hasOwnProperty(key)) {
                if($('#'+key).length) {
                    $('#'+key).html(json[key]);
                }
            }
        }
        // Add the icons, as we only receive li's in the scrape.
        $('.contentRow li').each(function () {
            $(this).prepend('<span class="icon icon-angle-right"></span>');
        });

        if(typeof json.termsUrl !== 'undefined') {
            $('.termsUrl').attr('href', json.termsUrl);
        }
        if(typeof json.privacyPolicyUrl !='undefined') {
            $('.privacyPolicyUrl').attr('href', json.privacyPolicyUrl);
        }

    }

    /**
     * This will only run if moreInfo.applyCallback has success === true as its parameter.
     */
    function onApplySuccess(product) {
        // open transferring dialog, if need be.
    }

    meerkat.modules.register("utilitiesMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        runDisplayMethod: runDisplayMethod,
        setScrollPosition: setScrollPosition,
        retrieveExternalCopy: retrieveExternalCopy
    });

})(jQuery);
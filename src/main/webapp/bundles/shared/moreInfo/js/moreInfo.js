/**
 * Brief explanation of the module and what it achieves. <example: Example
 * pattern code for a meerkat module.> Link to any applicable confluence docs:
 * <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            moreInfo: {
                bridgingPage: {
                    CHANGE: "BRIDGINGPAGE_CHANGE", // only triggered when state changes from open to closed or closed to open
                    SHOW: "BRIDGINGPAGE_SHOW", // trigger on every show (i.e. even when switching from product to product => show to show)
                    HIDE: "BRIDGINGPAGE_HIDE" // triggers on close
                }
            }
        },
        moduleEvents = events.moreInfo;

    var product,
        htmlTemplate,
        affixedHeaderTemplate,
        isModalOpen = false,
        isBridgingPageOpen = false,
        modalId,
        topPosition,// for Health's unique results view.
        jsonResult,
        triggerOnShowTimeout,
        defaults = {
            container: $('.bridgingContainer'), // if the template fills a container. If modal, not used
            template: $("#more-info-template").html(),
            affixedHeaderTemplate: $('#moreInfoAffixedHeaderTemplate').html(),
            affixedHeaderContainer: $('.more-info-affixed-header'),
            hideAction: 'slideUp',
            showAction: 'slideDown',
            showActionWhenOpen: 'slideDown', // some verticals may have a different animation to run when a bridging page is already open.
            updateTopPositionVariable: null, // For Health's unique results view.
            modalOptions: false, // can be an object that is passed directly to meerkat.modules.dialogs.show
            runDisplayMethod: null, // specify in your verticalMoreInfo.js file how to display, based on viewport etc.
            onBeforeShowBridgingPage: null, // before bridging page is displayed (applies to all forms of display)
            onBeforeShowTemplate: null, // before the "template" mode is displayed
            onBeforeShowModal: null, // before the "modal" mode is displayed
            onAfterShowTemplate: null, // after the "template" mode is displayed
            onAfterShowModal: null, // after the "modal" mode is displayed
            onBeforeHideTemplate: null, // before the template is hidden
            onAfterHideTemplate: null, // after the template is hidden
            onBeforeApply: null,
            onClickApplyNow: null,
            onApplySuccess: null,
            prepareCover: null, // Function for Health. I tried to call in retrieveExternalCopy, but on healthConfirmation, it does prepareCover as a separate step.
            retrieveExternalCopy: null, // could just return a simple javascript object, or a deferred promise (ajax request).
            additionalTrackingData: null, // add an object of additional tracking data to pass to trackProductView.,
            onBreakpointChangeCallback: null
        },
        settings = {},
        visibleBodyClass = 'moreInfoVisible';

    /* Initialise the more info module with options passed from your vertical */
    function initMoreInfo(options) {

        settings = $.extend({}, defaults, options);
        /* Disable on confirmation pages */
        if (meerkat.site.pageAction === "confirmation")
            return false;
        jQuery(document).ready(function ($) {
            // prepare compiled template
            if (typeof (settings.template) != "undefined") {
                htmlTemplate = _.template(settings.template);

                if (settings.affixedHeaderTemplate && typeof settings.affixedHeaderTemplate.length !== 'undefined') {
                    affixedHeaderTemplate = _.template(settings.affixedHeaderTemplate);
                }

                applyEventListeners();
                eventSubscriptions();

            }

        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, onBreakpointChange);
    }

    function applyEventListeners() {

        /* Show/Hide Bridging Page */
        if (typeof Results.settings !== "undefined") {
            // open bridging page
            $(Results.settings.elements.page).on("click", ".btn-more-info, .link-more-info", openBridgingPage);
            // some opens may be in modals or tooltips
            $(document).on("click", ".open-more-info", openBridgingPage);
            // close bridging page
            $(Results.settings.elements.page + ", .navMenu-row header").on("click", ".btn-close-more-info", closeBridgingPage);
        }

        // Close any more info panels when fetching new results
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            closeBridgingPage();
        });

        /* Other Methods */
        // Apply button in bridging page
        $(document.body).on("click", ".btn-more-info-apply", function applyClick(event) {

            event.preventDefault();

            if ($('#resultsForm').valid()) {

                var $this = $(this);
                $this.addClass('inactive').addClass('disabled');
                meerkat.modules.loadingAnimation.showInside($this, true);

                if (typeof settings.onBeforeApply == 'function') {
                    settings.onBeforeApply($this);
                }

                // Set selected product
                Results.setSelectedProduct($this.attr("data-productId"));
                var product = Results.getSelectedProduct();

                if (product) {
                    if (typeof settings.onClickApplyNow == 'function') {
                        return settings.onClickApplyNow(product, applyCallback);
                    }
                } else {
                    applyCallback(false);
                    return false;
                }
            }

        });

        // Add dialog on "promo conditions" links
        $(document.body).on("click", ".dialogPop", function promoConditionsLinksClick() {
            meerkat.modules.dialogs.show({
                title: $(this).attr("title"),
                htmlContent: $(this).attr("data-content"),
                className: $(this).attr("data-class")
            });
        });

    }

    function eventSubscriptions() {

        // Close when results page changes
        $(document).on("resultPageChange", function () {
            if (isBridgingPageOpen) {
                closeBridgingPage();
            }
        });
    }

    /**
     * openBridgingPage is central, the show actions are separate and determined in the verticalMoreInfo.js file.
     */
    function openBridgingPage(event) {

        var $this = $(this);
        if (typeof $this === 'undefined' || $this.hasClass('inactive') || $this.hasClass('disabled')) return;
        if (typeof $this.attr('data-productId') === 'undefined') return;
        if (typeof $this.attr('data-available') !== 'undefined' && $this.attr('data-available') !== 'Y') return;

        $this.addClass('inactive disabled');

        if (typeof settings.onBeforeShowBridgingPage == 'function') {
            settings.onBeforeShowBridgingPage($this);
        }
        var productId = $this.attr("data-productId"),
            showApply = $this.hasClass('more-info-showapply');

        setProduct(Results.getResult("productId", productId), showApply);

        // load, parse and show the bridging page
        settings.runDisplayMethod(productId);

        // set virtual page in sessioncam
        meerkat.modules.sessionCamHelper.setMoreInfoModal();
        setTimeout(function() {
            $this.removeClass('inactive disabled');
        }, 500);
    }

    /**
     * Calls prepareProduct, which requests the content, and performs the show success callback.
     * This function currently defaults to slideDown.
     */
    function showTemplate(moreInfoContainer) {

        toggleBodyClass(true);

        // show loading animation
        moreInfoContainer.html(meerkat.modules.loadingAnimation.getTemplate()).show();

        prepareProduct(function moreInfoShowSuccess() {
            var htmlString = htmlTemplate(product);
            // fade out loading anim
            moreInfoContainer.find(".spinner").fadeOut();

            // append content
            moreInfoContainer.html(htmlString);

            if (typeof affixedHeaderTemplate === 'function' && settings.affixedHeaderContainer && settings.affixedHeaderContainer.length === 1) {
                var affixedHtmlString = affixedHeaderTemplate(product);
                settings.affixedHeaderContainer.html(affixedHtmlString);
            }

            if (typeof settings.onBeforeShowTemplate == 'function') {
                settings.onBeforeShowTemplate(jsonResult, moreInfoContainer);
            }

            var animDuration = 400;
            var scrollToTopDuration = 250;
			var totalDuration = 0;

            if (isBridgingPageOpen) {
				moreInfoContainer.find(".more-info-content")[settings.showActionWhenOpen](animDuration, function() {
                    if (typeof settings.onAfterShowTemplate == 'function') {
                        settings.onAfterShowTemplate();
                    }

                });
				totalDuration = animDuration;
            } else {
                meerkat.modules.utils.scrollPageTo('.resultsSlide', scrollToTopDuration, -$("#navbar-main").height(), function () {
                    moreInfoContainer.find(".more-info-content")[settings.showAction](animDuration, showTemplateCallback);
                    isBridgingPageOpen = true;
                    if (typeof settings.onAfterShowTemplate == 'function') {
                        settings.onAfterShowTemplate();
                    }
				});
				totalDuration = animDuration + scrollToTopDuration;
			}

			triggerOnShowTimeout = setTimeout(function () {
				meerkat.messaging.publish(moduleEvents.bridgingPage.SHOW, {
					isOpen: isBridgingPageOpen
                });
				if(!isBridgingPageOpen && typeof settings.updateTopPositionVariable == 'function') {
					settings.updateTopPositionVariable();
					//Set position from the global.
					moreInfoContainer.css({
						'top': topPosition
					});
                }
			}, totalDuration);

            var trackData = {
                productID: product.productId
            };

            if (settings.additionalTrackingData !== null && typeof settings.additionalTrackingData === 'object') {
                trackData = $.extend({}, trackData, settings.additionalTrackingData);
            }

            /* This may need to be implemented differently if ever needed for verticals other than
             * car and the brandCode is stored differently eg Health product.info.FundCode */
            if (product.hasOwnProperty("brandCode")) {
                trackData.productBrandCode = product.brandCode;
            }

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackProductView',
                object: trackData
            });

            meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
                touchType: 'H',
                touchComment: 'MoreInfo',
                productId: product.hasOwnProperty('productId') ? product.productId : ""
            });

            // Instigate a session poke
            meerkat.modules.session.poke();

            initMoreInfoProductExtraInfo();

        });

    }

    /**
     * Populates the more info product summary items (discount, promo, etc)
     * Called by showTemplate
     */
    function initMoreInfoProductExtraInfo() {
        var product = Results.getSelectedProduct();
        if (!product) return;
        var ind = 1; //index starts at 1 as the best price promise already exists in the left column
        var addToColumns = function(type, text) {
            if (!text || text.length === 0) return;
            var container = $('#productSummaryRight');
            if (ind % 2 === 0) {
                container = $('#productSummaryLeft');
            }
            $(container).append(
                $('<div/>', { 'class': 'productExtraInfoItem'}).append(
                    $('<div/>', { 'class': 'extraInfoItemType', 'html': type})
                ).append(
                    $('<div/>', { 'class': 'extraInfoItemText', 'html': text})
                )
            )
        };

        var productHasProperty = function(obj) {
            var args = Array.prototype.slice.call(arguments, 1);
            for (var i = 0; i < args.length; i++) {
                if (!obj || !obj.hasOwnProperty(args[i])) {
                    return false;
                }
                obj = obj[args[i]];
            }
            return true;
        };

        if (productHasProperty(product, 'promo', 'promoText')) {
            addToColumns('Offer', product.promo.promoText);
        }

        if (productHasProperty(product, 'promo', 'discountText')) {
            addToColumns('Discount', product.promo.discountText);
        }

        if (productHasProperty(product, 'awardScheme', 'text')) {
            addToColumns('Reward', product.awardScheme.text);
        }

        if (productHasProperty(product, 'custom', 'info', 'content', 'results', 'header', 'text')) {
            addToColumns('Other', product.custom.info.content.results.header.text);
        }
    }

    /**
     * If there's a modal to show.
     */
    function showModal() {
        prepareProduct(function moreInfoShowModalSuccess() {

            toggleBodyClass(true);

            var options = {
                htmlContent: htmlTemplate(product),
                hashId: 'moreinfo',
                closeOnHashChange: true
            };

            if (!_.isEmpty(settings.modalOptions.htmlHeaderContent)) {
                options.htmlHeaderContent = settings.modalOptions.htmlHeaderContent;
            }

            if (typeof settings.onBeforeShowModal == 'function') {
                options.onOpen = function (dialogId) {
                    settings.onBeforeShowModal(jsonResult, dialogId);
                };
            }

            if (typeof settings.modalOptions == 'object') {
                options = $.extend(options, settings.modalOptions);
            }
            modalId = meerkat.modules.dialogs.show(options);


            isModalOpen = true;

            settings.container.add(".more-info-content").show();

            if (typeof settings.onAfterShowModal == 'function') {
                settings.onAfterShowModal(product);
            }

            _.delay(function () {
                meerkat.messaging.publish(moduleEvents.bridgingPage.SHOW, {
                    isOpen: isModalOpen
                });
            }, 0);

            var trackData = {
                productID: product.productId
            };

            if (settings.additionalTrackingData !== null && typeof settings.additionalTrackingData === 'object') {
                trackData = $.extend({}, trackData, settings.additionalTrackingData);
            }

            /* This may need to be implemented differently if ever needed for verticals other than
             * car and the brandCode is stored differently eg Health product.info.FundCode */
            if (product.hasOwnProperty("brandCode")) {
                trackData.productBrandCode = product.brandCode;
            }

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackProductView',
                object: trackData
            });

            meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
                touchType: 'H',
                touchComment: 'MoreInfo',
                productId: product.hasOwnProperty('productId') ? product.productId : ""
            });
        });
    }

    /**
     * Funnel - determines whether to close a modal or template view.
     */
    function closeBridgingPage() {

        var $this = $(this);
        if (typeof $this === 'undefined' || $this.hasClass('inactive') || $this.hasClass('disabled')) return;

        // Prevent double click - mostly an issue on HLT, or where the more info button remains displayed.
        $this.addClass('inactive disabled');

        if (isModalOpen) {
            hideModal();
            meerkat.modules.address.removeFromHash('moreinfo');
            meerkat.modules.sessionCamHelper.setResultsShownPage();
        }

        if (isBridgingPageOpen) {
            hideTemplate(settings.container);
            meerkat.modules.address.removeFromHash('moreinfo');
            meerkat.modules.sessionCamHelper.setResultsShownPage();
        }

        setTimeout(function() {
            $this.removeClass('inactive disabled');
        }, 500);
    }

    /**
     * Pass in container, as it can be called externally
     * Define onBeforeHideTemplate in verticalMoreInfo.js e.g. remove faded classes etc.
     * Default action: slideUp the container.
     */
    function hideTemplate(moreInfoContainer) {

        // Clear this timeout before hiding, so it doesn't run the show after hiding.
        if(triggerOnShowTimeout) {
            clearTimeout(triggerOnShowTimeout);
        }
        if (typeof settings.onBeforeHideTemplate == 'function') {
            settings.onBeforeHideTemplate();
        }

        moreInfoContainer[settings.hideAction](400, function () {
            toggleBodyClass(false);
            hideTemplateCallback(moreInfoContainer);
            if (typeof settings.onAfterHideTemplate == 'function') {
                settings.onAfterHideTemplate();
            }
        });
    }

    function hideModal() {
        $('#' + modalId).modal('hide');
        settings.container.add('.more-info-content').hide(function () {
            toggleBodyClass(false);
        });
        isModalOpen = false;
        // These are needed for health to reflow its "dropdown" area.
        meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {isOpen: isModalOpen});
        meerkat.messaging.publish(moduleEvents.bridgingPage.HIDE, {isOpen: isModalOpen});
    }


    /**
     * Publish a bridging page change event to be 'open'
     */
    function showTemplateCallback() {
        meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {
            isOpen: true
        });
    }

    /**
     * Publish a bridging page change event to be 'closed'
     * Hide the container and empty it of DOM elements, data/event constructs
     */
    function hideTemplateCallback(moreInfoContainer) {
        moreInfoContainer.empty().hide();
        isBridgingPageOpen = false;
        meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {isOpen: isBridgingPageOpen});
        meerkat.messaging.publish(moduleEvents.bridgingPage.HIDE, {isOpen: isBridgingPageOpen});
    }

    function setProduct(productToParse, showApply) {

        if (typeof productToParse !== 'undefined' && typeof productToParse.productId !== 'undefined') {
            // Results is not initialised on confirmation page for HLT.
            if (typeof Results.model != 'undefined' && typeof Results.model.setSelectedProduct != 'undefined') {
                Results.setSelectedProduct(productToParse.productId);
            }
        }

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
        if (isBridgingPageOpen === false && isModalOpen === false) return null;
        return product;
    }

    /**
     * Returns whatever is in the product object currently, regardless of whether the bridging page is open.
     * Needed for application in HLT.
     */
    function getProduct() {
        return product;
    }

    /**
     * This is called from the showTemplate and showModal functions, which contain the successCallback.
     * This callback is passed through to the deferred promise result of the retrieveExternalCopy function.
     * @param successCallback
     */
    function prepareProduct(successCallback) {
        // health only at the moment.
        if (typeof settings.prepareCover == 'function') {
            settings.prepareCover();
        }

        prepareExternalCopy(successCallback);
    }

    function prepareExternalCopy(successCallback) {
        // Retrieve the copy for the bridging page.
        // settings.retrieveExternalCopy should return a deferred object, whether its externally requested or already existing.
        $.when(settings.retrieveExternalCopy(product)).then(successCallback);
    }

    function applyCallback(success) {

        _.delay(function deferApplyCallback() {
            $('.btn-more-info-apply').removeClass('inactive').removeClass('disabled');
            meerkat.modules.loadingAnimation.hide($('.btn-more-info-apply'));
        }, 1000);

        if (success === true) {
            if (typeof settings.onApplySuccess == 'function') {
                // send to apply step or page, or load a transferring dialog etc.
                settings.onApplySuccess();
            }
        }
    }

    /**
     * Helper function to access the state from meerkat.modules.verticalMoreInfo
     */
    function getisBridgingPageOpen() {
        return isBridgingPageOpen;
    }

    function getisModalOpen() {
        return isModalOpen;
    }

    /**
     * Sets a jsonResult to this module so it can be accessed in template callbacks.
     */
    function setDataResult(result) {
        jsonResult = result;
    }

    function getDataResult() {
        return jsonResult;
    }

    /**
     * Allows other verticals to update the settings object.
     */
    function updateSettings(updatedSettings) {
        if (typeof updatedSettings !== 'object') {
            return;
        }
        settings = $.extend(true, {}, settings, updatedSettings);
    }

    function toggleBodyClass(show) {
        show = show || false;
        if (show) {
            $('body').addClass(visibleBodyClass);
        } else {
            $('body').removeClass(visibleBodyClass);
        }
    }

    function onBreakpointChange() {
        if (_.isFunction(settings.onBreakpointChangeCallback)) {
            _.defer(settings.onBreakpointChangeCallback);
        }
    }

    meerkat.modules.register('moreInfo', {
        initMoreInfo: initMoreInfo, // main entrypoint to be called.
        events: events,
        open: openBridgingPage,
        close: closeBridgingPage,
        showTemplate: showTemplate,
        hideTemplate: hideTemplate,
        showModal: showModal,
        hideModal: hideModal,
        isBridgingPageOpen: getisBridgingPageOpen,
        isModalOpen: getisModalOpen,
        getOpenProduct: getOpenProduct,
        getProduct: getProduct,
        setProduct: setProduct,
        setDataResult: setDataResult,
        getDataResult: getDataResult,
        applyCallback: applyCallback,
        updateSettings: updateSettings
    });

})(jQuery);

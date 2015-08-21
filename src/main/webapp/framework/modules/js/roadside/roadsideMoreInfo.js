(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var events = {
            roadsideMoreInfo: {}
        },
        moduleEvents = events.roadsideMoreInfo;

    var $bridgingContainer = $('.bridgingContainer'),
        callbackModalId, // the id of the currently displayed callback modal
        scrollPosition; //The position of the page on the modal display

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
            onBeforeShowBridgingPage: null,
            onBeforeShowTemplate: null,
            onBeforeShowModal: onBeforeShowModal,
            onAfterShowModal: trackProductView,
            onAfterShowTemplate: null,
            onBeforeHideTemplate: null,
            onAfterHideTemplate: null,
            onClickApplyNow: onClickApplyNow,
            onBeforeApply: null,
            onApplySuccess: null,
            retrieveExternalCopy: retrieveExternalCopy,
            additionalTrackingData: {
                productName: null
            }
        };

        meerkat.modules.moreInfo.initMoreInfo(options);
    }

    /**
     * Set the current scroll position so that it can be used when modals are closed
     */
    function setScrollPosition() {
        scrollPosition = $(window).scrollTop();
    }

    /**
     * Handles how you want to display the bridging page based on your viewport/requirements
     */
    function runDisplayMethod(productId) {
        meerkat.modules.moreInfo.showModal();
        meerkat.modules.address.appendToHash('moreinfo');
    }

    /**
     * Retrieves the data used for the bridging page.
     */
    function retrieveExternalCopy(product) {

        return $.Deferred(function (dfd) {
            product.termsLink = $(product.subTitle).attr('href');

            var array = [];
            for(var key in product.info) {
                array.push( [product.info[key].desc, key] );
            }
            product.sortOrder = array.sort();
            meerkat.modules.moreInfo.setDataResult(product);
            return dfd.resolveWith(this, [product]).promise();
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
        meerkat.modules.roadside.trackHandover();

        // otherwise just do it.
        meerkat.modules.journeyEngine.gotoPath("next");
    }

    /**
     * Track when we open a bridging page.
     */
    function trackProductView() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackQuoteForms',
            object: _.bind(meerkat.modules.roadside.getTrackingFieldsObject, this, true)
        });
    }

    function onBeforeShowModal(product) {
        var settings = {
            additionalTrackingData: {
                productName: product.des
            }
        };
        meerkat.modules.moreInfo.updateSettings(settings);
    }


    meerkat.modules.register("roadsideMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        runDisplayMethod: runDisplayMethod,
        setScrollPosition: setScrollPosition,
        retrieveExternalCopy: retrieveExternalCopy
    });

})(jQuery);
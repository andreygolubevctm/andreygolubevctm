;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = window.meerkat.logging.info;

    var events = {
            resultsHeaderBar: {}
        },
        moduleEvents = events.resultsHeaderBar;

    var settings = {
            disableOnXs: false,
            navbarSelector: '#navbar-main',
            getStartOffset: function () {
                return $(".header-top .container").height();
            }
        },
        listenersRegistered = false,
        $resultsHeaderBg,
        $affixOnScroll,
        $resultsContainer,
        navBarHeight,
        topStartOffset = 0,
        contentAnimating = false,
        enterXsSubscription,
        leaveXsSubscription; // whether to disable on XS

    /**
     * Extend the default options from a vertical specific module
     * @param options
     */
    function initResultsHeaderBar(options) {

        settings = $.extend({}, settings, options);

        $resultsHeaderBg = $('.resultsHeadersBg');
        $affixOnScroll = $('.affixOnScroll');
        $resultsContainer = $('.resultsContainer');
        navBarHeight = $(settings.navbarSelector).outerHeight();

        // Self-initialise
        $(document).on('resultsLoaded', registerEventListeners);

        if (meerkat.modules.journeyEngine.getCurrentStep() && meerkat.modules.journeyEngine.getCurrentStep().navigationId == 'results') {
            registerEventListeners();
        }
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function (eventObject) {
            if (eventObject.navigationId == 'results') {
                registerEventListeners();
            } else if (eventObject.previousNavigationId == 'results') {
                removeEventListeners();
            }
        });
    }

    // has to wait for the results page to be displayed before updating
    function setHeaderBarStartOffset(forceUpdate) {

        // if not set yet, then set it
        if (topStartOffset === 0 || forceUpdate) {
            var dynamicTopHeaderContentHeight = 0;
            $(".dynamicTopHeaderContent > *").each(function () {
                // don't calculate height of hidden elements for Simples users if the user is a Simples user
                if ($(this).hasClass("simplesHidden") && meerkat.site.isCallCentreUser) {
                    return;
                }
                dynamicTopHeaderContentHeight += $(this).height();
            });
            topStartOffset = settings.getStartOffset() + dynamicTopHeaderContentHeight;
            // height of the header without navbar (which gets affixed at the same time)
            if ($resultsHeaderBg && $resultsHeaderBg.length) {
                topStartOffset += $resultsHeaderBg.position().top;
            }
        }

    }

    // Helpers to determine current state...
    function isWindowInAffixPosition() {
        return $(window).scrollTop() >= topStartOffset;
    }

    function isWindowInCompactPosition() {
        // the +5 is to force the headers to affix first before we switch to compact mode for performance reasons
        var randomOffset = 5;
        // This offset of ?five? causes the docked result headers to "jump" when there is a coupon banner, because this function is false after the affixed class has been added but before the compact classes are added...
        var currentCoupon = meerkat.modules.coupon.getCurrentCoupon();
        if (currentCoupon !== false || typeof currentCoupon !== 'undefined') {
            if (currentCoupon.hasOwnProperty('contentBanner')) {
                randomOffset = 0;
            }
        }
        return $(window).scrollTop() >= topStartOffset + randomOffset;
    }

    function isContentAffixed() {
        return $resultsContainer.hasClass('affixed');
    }

    function isContentCompact() {
        return $resultsContainer.hasClass('affixed-compact');
    }

    function isContentAffixedForPagination() {
        return $resultsContainer.hasClass('affixed-absoluted');
    }


    // Handle events...
    function onScroll() {
        setHeaderBarStartOffset(); // will set it first time only
        if (isWindowInAffixPosition() === true) {

            if (isContentAffixed() === false) {
                var skipAffix = false;
                if (_.has(settings, 'removeAffixXs') && settings.removeAffixXs) {
                    skipAffix = true;
                }
                if (!skipAffix) {
                    $affixOnScroll.addClass("affixed");
                    $resultsContainer.addClass("affixed-settings");
                }
            }

            if (isWindowInCompactPosition() === true && isContentCompact() === false) {
                if (_.has(settings, 'removeAffixXs') && settings.removeAffixXs) {
                    return;
                }
                $affixOnScroll.addClass("affixed-compact");
                $resultsContainer.find(".result .productSummary").addClass("compressed");
                $(document).trigger('headerAffixed');
            } else if (isWindowInCompactPosition() === false && isContentCompact() === true) {
                removeCompactClasses();
                $(document).trigger('headerUnaffixed');
            }

        } else if (isWindowInAffixPosition() === false && isContentAffixed() === true) {
            removeAffixClasses();
            $(document).trigger('headerUnaffixed');
        }

    }

    function removeCompactClasses() {
        $resultsContainer.find(".result .productSummary").removeClass("compressed");
        if (_.has(settings, 'removeAffixXs') && settings.removeAffixXs) {
            return;
        }
        $affixOnScroll.removeClass("affixed-compact");
    }

    function removeAffixClasses() {
        removeCompactClasses();
        $affixOnScroll.removeClass("affixed");
        $resultsContainer.removeClass("affixed-settings");
    }

    function onAnimationStart() {
        if (isContentAffixed() && contentAnimating === false) {
            contentAnimating = true;
            navBarHeight = $(settings.navbarSelector).outerHeight();
            var top = $(window).scrollTop() + navBarHeight - $resultsContainer.offset().top + settings.whilePaginatingOffset;
            $resultsContainer.find(".result").css("top", top + 'px').end().removeClass("affixed").addClass("affixed-absoluted");
        }
    }

    function onAnimationEnd() {
        if (isContentAffixedForPagination() && contentAnimating === true) {
            contentAnimating = false;
            $resultsContainer.removeClass("affixed-absoluted").addClass("affixed").find(".result").css("top", '');
        }
    }

    // when changing breakpoint, in compact mode, on page>1, the header layouts needs to refresh
    function refreshHeadersLayout() {
        if (isContentCompact()) {
            $(Results.settings.elements.productHeaders).refreshLayout(); // jquery plugin in utilities module
        }
    }

    function enableAffixMode() {

        _.defer(onScroll);
        $(window).on('scroll.resultsHeaderBar', _.throttle(onScroll, 25));

        if (settings.disableOnXs === true) {
            // subscribe to enter XS to disable fixed headers in that breakpoint
            enterXsSubscription = meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function () {
                disableAffixMode();
            });
        }
    }

    /**
     * Only runs if disabling on XS.
     */
    function disableAffixMode() {

        // unsubscribe to enter XS
        meerkat.messaging.unsubscribe(enterXsSubscription);

        // remove affix position
        removeAffixClasses();

        // unsubscribe from scroll event
        $(window).off('scroll.resultsHeaderBar');

        // subscribe to leave XS
        subscribeToLeaveXs();

    }

    function subscribeToLeaveXs() {
        if (settings.disableOnXs === true) {
            leaveXsSubscription = meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function () {
                meerkat.messaging.unsubscribe(leaveXsSubscription);
                registerEventListeners();
            });
        }
    }

    // Add remove event listeners (on entering / leaving results page)...
    function registerEventListeners() {
        // don't double up on needing to bind/unbind
        if (listenersRegistered) {
            return;
        }
        if (meerkat.modules.deviceMediaState.get() === "xs" && settings.disableOnXs === true) {
            subscribeToLeaveXs();
        } else {
            enableAffixMode();
        }
        //reset the navbar initially
        $(settings.navbarSelector).removeClass("affix").addClass("affix-top");
        // when repositioning the results (i.e. breakpoint change), this event is triggered. Fixed headers don't reposition so we force them to
        $(Results.settings.elements.resultsContainer).off("pagination.instantScroll").on("pagination.instantScroll", refreshHeadersLayout)
            .off("pagination.scrolling.start").on("pagination.scrolling.start", onAnimationStart)
            .off("pagination.scrolling.end").on("pagination.scrolling.end", onAnimationEnd)
            .off("results.view.animation.start").on("results.view.animation.start", onAnimationStart)
            .off("results.view.animation.end").on("results.view.animation.end", onAnimationEnd);

        // opening any of the Simples dialogue needs to refresh the header bar top offset value
        if ($resultsHeaderBg.length) {
            $resultsHeaderBg.prevAll(".simples-dialogue.toggle").off("click.updateHeaderBarOffset").on("click.updateHeaderBarOffset", function () {
                _.delay(function () {
                    setHeaderBarStartOffset(true);
                }, 300);
            });
        }
        listenersRegistered = true;
    }

    function removeEventListeners() {

        if (typeof enterXsSubscription !== "undefined") {
            meerkat.messaging.unsubscribe(enterXsSubscription);
        }

        if (typeof leaveXsSubscription !== "undefined") {
            meerkat.messaging.unsubscribe(leaveXsSubscription);
        }

        $(window).off('scroll.resultsHeaderBar');
        $(Results.settings.elements.resultsContainer).off("pagination.instantScroll")
            .off("pagination.scrolling.start")
            .off("pagination.scrolling.end")
            .off("results.view.animation.start")
            .off("results.view.animation.end");

        listenersRegistered = false;
    }

    meerkat.modules.register("resultsHeaderBar", {
        initResultsHeaderBar: initResultsHeaderBar,
        removeEventListeners: removeEventListeners
    });

})(jQuery);
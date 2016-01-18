/*
 This module supports the Sorting for travel results page.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $morePrompt,
        $morePromptLink,
        $morePromptIcons,
        $morePromptTextLink,
        promptInit = false,
        $extraDockedItem,
        scrollBottomAnchor,
        oldScrollBottomAnchor,
        moreLinkPositionOffset,
        disablePrompt = false,
        isXs = false,
        settings = {},
        defaults = {
            anchorPosition: 'div.results-table .available.notfiltered',
            goToBottomText: "Go to Bottom",
            goToTopText: "Go to Top",
            scrollTo: 'bottom',
            stationaryDockingOffset: 0,
            arrowsEnabled: true
        };


    function initPrompt() {
        isXs = meerkat.modules.deviceMediaState.get() == "xs";
        $(document).ready(function () {
            // update the docked position if there is an extra docked item that needs to sit at the bottom of the page

            moreLinkPositionOffset = (typeof $extraDockedItem !== 'undefined' && $extraDockedItem.length > 0 ? $extraDockedItem.outerHeight() : 0);
            $(".morePromptLink").css("bottom", moreLinkPositionOffset);

            if (!promptInit) {
                applyEventListeners();
            }
            eventSubscriptions();
            resetMorePromptBar();
        });
    }

    function applyEventListeners() {
        $morePrompt.fadeIn('slow');
        promptInit = true;

        $(document.body).on('click', '.morePromptLink', function () {

            var $footer = $("#footer"),
                contentBottom = 0;

            if (settings.scrollTo == 'bottom') {
                contentBottom = $footer.offset().top - $(window).height();
            }
            resetScrollBottomAnchorElement();
            $('body,html').stop(true, true).animate({scrollTop: contentBottom}, 1000, 'linear');
        });
    }

    function eventSubscriptions() {

        // Reset the more prompt bar to the bottom when the state changes
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function breakPointChange() {
            isXs = meerkat.modules.deviceMediaState.get() == "xs";
            if(!disablePrompt) {
                resetMorePromptBar();
                _.defer(setPromptBottomPx);
            }
        });

        $(document).on("results.view.animation.end", function() {
            resetScrollBottomAnchorElement();
        });

        meerkat.messaging.subscribe(meerkatEvents.RESIZE_DEBOUNCED, function(obj) {
            resetScrollBottomAnchorElement();
        });


       $(window).off("scroll.viewMorePrompt").on("scroll.viewMorePrompt", function () {
            setPromptBottomPx();
        });
    }

    function resetForCoverLevelTabs() {
        // needed here too because we defer in resetMorePrompt
        resetScrollBottomAnchorElement();
        resetMorePromptBar();
        $morePrompt.removeAttr('style');
        disablePrompt = false;
        setPromptBottomPx();
    }

    function setPromptBottomPx() {

        moreLinkPositionOffset = (typeof $extraDockedItem !== 'undefined' && $extraDockedItem.length > 0 ? $extraDockedItem.outerHeight() : 0);

        // we only want this to happen when the results are rendered otherwise it will appear when the loading screen appears
        if(disablePrompt || typeof scrollBottomAnchor == 'undefined' || !scrollBottomAnchor.length) {
            return;
        }

        var docHeight = $(document).height(),
            windowHeight = $(window).height();

        // Object with top: xxx left xxx. from top of element to top of document.
        var anchorOffsetTop = scrollBottomAnchor.offset().top + scrollBottomAnchor.outerHeight(true) + 15;

        // The offset relative to the actual viewport (whats visible on screen).
        var anchorViewportOffsetTop = anchorOffsetTop - $(document).scrollTop();

        // Get the position of the anchor from the bottom of the document.
        var anchorFromBottom = docHeight - (docHeight - anchorOffsetTop);

        // Get the current height relative to the anch or
        var currentHeight = anchorFromBottom - windowHeight;

        // When the current height is in the range of scrollTop the anchor is visible.
        if (currentHeight <= $(this).scrollTop()) {

            // Set the bottom style to be the offset from the bottom.
            if(!isXs) {
                var setHeightFromBottom = windowHeight - anchorViewportOffsetTop;
                $(".morePromptLink").css("bottom", (setHeightFromBottom - settings.stationaryDockingOffset)+ 'px');
                if (typeof $extraDockedItem !== 'undefined' && $extraDockedItem.length > 0) {
                    $extraDockedItem.css("bottom", (setHeightFromBottom - moreLinkPositionOffset - settings.stationaryDockingOffset) + 'px');
                }
            }
            if(settings.scrollTo != 'top') {
                toggleArrow("up");
            } else {
                // for XS, this isn't being reset so have added this condition in
                if (currentHeight < 0 && isXs) {
                    toggleArrow("down");
                }
            }
        } else {

            // during scrolling up and down the page
            $(".morePromptLink").css("bottom", moreLinkPositionOffset);
            if (typeof $extraDockedItem !== 'undefined' && $extraDockedItem.length > 0) {
                $extraDockedItem.css("bottom", 0);
            }
            if(settings.scrollTo != 'bottom') {
                toggleArrow("down");
            }
        }
    }

    /**
     * The element and its properties must be cached when its initially set on scroll for this to have any use when the page resizes for example.
     */
    function resetScrollBottomAnchorElement() {
        scrollBottomAnchor = $(settings.anchorPosition).last();
    }

    function resetMorePromptBar() {
        // defer by 1ms to ensure everything is rendered otherwise it throws an error
        _.defer(function () {
            resetScrollBottomAnchorElement();
            toggleArrow("down");
            $morePrompt.removeAttr('style');
            if(typeof $extraDockedItem !== 'undefined' && $extraDockedItem.length) {
                $extraDockedItem.removeAttr('style');
            }
        });
    }

    function toggleArrow(direction) {
        switch (direction) {
            case "up":
                settings.scrollTo = "top";
                $morePromptTextLink.html(settings.goToTopText);
                if (settings.arrowsEnabled) {
                    $morePromptIcons.removeClass("icon-angle-down").addClass("icon-angle-up");
                }
                break;
            default:
                settings.scrollTo = "bottom";
                $morePromptTextLink.html(settings.goToBottomText);
                if (settings.arrowsEnabled) {
                    $morePromptIcons.removeClass("icon-angle-up").addClass("icon-angle-down");
                }
                break;
        }
    }

    /** This is done specifically for cover level tabs. If not used the side affect is clicking back on international tab results in the prompt bar not docking after click on the domestic tab in travel */
    function disableForCoverLevelTabs() {
        $morePrompt.hide();
        disablePrompt = true;
    }

    function disablePromptBar() {
        $(window).off('scroll.viewMorePrompt');
        $morePrompt.hide();
        if(typeof $extraDockedItem !== 'undefined' && $extraDockedItem.length) {
            $extraDockedItem.hide();
        }
    }

    function initMoreQuotesPrompt(options) {

        $morePrompt = $('.morePromptContainer');
        $morePromptLink = $('.morePromptContainer');
        $morePromptIcons = $morePrompt.find('.icon');
        $morePromptTextLink = $morePrompt.find('.morePromptLinkText');

        settings = $.extend(true, {}, defaults, options);

        // remove the arrows if it's not required
        if (!settings.arrowsEnabled) {
            $morePromptIcons.removeClass("icon-angle-down");
        }

        meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, function morePromptCallBack() {
            $extraDockedItem = $(settings.extraDockedItem);
            initPrompt();
        });
    }

    function updateBarPosition(newBottomAnchor, isOpening) {
        if (isOpening) {
            oldScrollBottomAnchor = scrollBottomAnchor;
            scrollBottomAnchor = newBottomAnchor;
        } else {
            scrollBottomAnchor = typeof oldScrollBottomAnchor !== 'undefined' ? oldScrollBottomAnchor : $(settings.anchorPosition).last();
        }

        // IE8 was returning up to 196ms hence this check. It tends to fluctuate as another test returns numbers around 50ms so leaving it on the high side for now
        var delay = meerkat.modules.performanceProfiling.isIE8() ? 220 : 80;
        _.delay(setPromptBottomPx, delay);
    }

    meerkat.modules.register('showMoreQuotesPrompt', {
        initPromptBar: initMoreQuotesPrompt,
        resetPromptBar: resetMorePromptBar,
        disablePromptBar: disablePromptBar,
        disableForCoverLevelTabs: disableForCoverLevelTabs,
        resetForCoverLevelTabs: resetForCoverLevelTabs,
        updateBarPosition: updateBarPosition
    });

})(jQuery);
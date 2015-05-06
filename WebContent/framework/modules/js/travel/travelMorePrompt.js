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
        goToBottomText = "Go to Bottom",
        goToTopText = "Go to Top",
        scrollTo = 'bottom',
        scrollBottomAnchor,
        disablePrompt = false,
        isXs = false;


    function initPrompt() {
        scrollTo = "bottom";
        isXs = meerkat.modules.deviceMediaState.get() == "xs";
        $(document).ready(function () {

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

            if (scrollTo == 'bottom') {
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

        if(typeof meerkatEvents.coverLevelTabs !== 'undefined') {
            meerkat.messaging.subscribe(meerkatEvents.coverLevelTabs.CHANGE_COVER_TAB, function onTabChange(eventObject) {
                if (eventObject.activeTab == "D") {
                    $morePrompt.hide();
                    disablePrompt = true;
                } else {
                    // needed here too because we defer in resetMorePrompt
                    resetScrollBottomAnchorElement();
                    resetMorePromptBar();
                    $morePrompt.removeAttr('style');
                    disablePrompt = false;
                    setPromptBottomPx();
                }

            });
        }


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

    function setPromptBottomPx() {
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
                $(".morePromptLink").css("bottom", setHeightFromBottom + 'px');
            }
            if(scrollTo != 'top') {
                toggleArrow("up");
            }
        } else {
            $(".morePromptLink").css("bottom", 0);
            if(scrollTo != 'bottom') {
                toggleArrow("down");
            }
        }
    }

    /**
     * The element and its properties must be cached when its initially set on scroll for this to have any use when the page resizes for example.
     */
    function resetScrollBottomAnchorElement() {
        scrollBottomAnchor = $('div.results-table .available.notfiltered').last();
    }

    function resetMorePromptBar() {
        // defer by 1ms to ensure everything is rendered otherwise it throws an error
        _.defer(function () {
            resetScrollBottomAnchorElement();
            toggleArrow("down");
            $morePrompt.removeAttr('style');
        });
    }

    function toggleArrow(direction) {
        switch(direction) {
            case "up":
                scrollTo = "top";
                $morePromptTextLink.html(goToTopText);
                $morePromptIcons.removeClass("icon-angle-down").addClass("icon-angle-up");
                break;
            default:
                scrollTo = "bottom";
                $morePromptTextLink.html(goToBottomText);
                $morePromptIcons.removeClass("icon-angle-up").addClass("icon-angle-down");
                break;
        }
    }

    function disablePromptBar() {
        $(window).off('scroll.viewMorePrompt');
        $morePrompt.hide();
    }

    function initTravelMorePrompt() {

        $morePrompt = $('.morePromptContainer');
        $morePromptLink = $('.morePromptContainer');
        $morePromptIcons = $morePrompt.find('.icon');
        $morePromptTextLink = $morePrompt.find('.morePromptLinkText');

        meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, function morePromptCallBack() {
            initPrompt();
        });
    }

    meerkat.modules.register('travelMorePrompt', {
        initTravelMorePrompt: initTravelMorePrompt,
        resetMorePromptBar: resetMorePromptBar,
        disablePromptBar: disablePromptBar
    });

})(jQuery);
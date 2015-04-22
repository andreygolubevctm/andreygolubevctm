/*
 This module supports the Sorting for travel results page.
 */

;(function ($, undefined) {

    var scrollTop = 0,
        meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $htmlBody,
        $morePrompt = null,
        $morePromptIcons,
        $morePromptTextLink,
        $lastResultRow,
        morePromptClicked = false,
        promptInit = false,
        $footer,
        goToBottomText = "Go to Bottom",
        goToTopText = "Go to Top",
        scrollTo = 'bottom',
        disablePrompt = false; // made this global so that the bar won't get confused as to which direction it should travel to. There has been instances where it says to go bottom but clicking on the bar takes the user to the top


    function initPrompt() {
        scrollTo = "bottom";
        $(document).ready(function () {
            $lastResultRow = $('div.results-table .available.notfiltered').last();

            if (!promptInit && meerkat.modules.deviceMediaState.get() != 'xs') {
                applyEventListeners();
            }
            eventSubscriptions();
            resetMorePromptBar();
        });
    }

    function applyEventListeners() {

        $morePrompt.fadeIn('slow');
        promptInit = true;

        $(document.body).on('click', '.morePromptLink', function (e) {

            var animationOptions = {},
                contentBottom = $footer.offset().top - $(window).height();

            if (scrollTo == 'bottom') {
                contentBottom += $footer.outerHeight(true);
            } else {
                // send the user to the top
                contentBottom = 0;
            }

            animationOptions.scrollTop = contentBottom;
            morePromptClicked = true;

            $htmlBody.stop(true, true).animate(animationOptions, 800, function morePromptAnimateEnd() {
                morePromptClicked = false;
            });
        });
    }

    function eventSubscriptions() {

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function leaveXSMode() {
            if (!promptInit) {
                applyEventListeners();
            }
        });

        // Reset the more prompt bar to the bottom when the state changes
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function breakPointChange() {
            resetMorePromptBar();
        });
        if(typeof meerkatEvents.coverLevelTabs !== 'undefined') {
            meerkat.messaging.subscribe(meerkatEvents.coverLevelTabs.CHANGE_COVER_TAB, function onTabChange(eventObject) {
                if (eventObject.activeTab == "D") {
                    $morePrompt.hide();
                    disablePrompt = true;
                } else {
                    $morePrompt.removeAttr('style');
                    disablePrompt = false;
                }
            });
        }

        $(document).on("results.view.animation.end", function() {
            fixMorePromptAfterSortOrFilter();
        });

        var timeout;
        $(window).off("scroll.travelMorePrompt").on("scroll.travelMorePrompt", function () {
            scrollTop = $(this).scrollTop();
            if (timeout)
                clearTimeout(timeout);
            timeout = setTimeout(handleMorePromptToggling, 150);
        });
    }

    function fixMorePromptAfterSortOrFilter() {
        $lastResultRow = $('div.results-table .available.notfiltered').last(); // update who is the last visible row for cover level tabs
        handleMorePromptToggling();
    }

    function handleMorePromptToggling() {
        // we only want this to happen when the results are rendered otherwise it will appear when the loading screen appears
        if(disablePrompt) {
            return;
        }
        // check if we've reached the bottom of the results page
        var height = window.innerHeight || document.documentElement.offsetHeight,
            currentScrollTopPos = scrollTop,
            currentPos = height + currentScrollTopPos,
            lastAvailableProduct = $lastResultRow.position(),
            lastAvailableProductPos = (lastAvailableProduct.top + $lastResultRow.outerHeight());

        if (scrollTop === 0) { // if we're at the top
            // remove the previous attributes added above and reset the position to fixed
            $morePrompt.removeAttr('style').css({position: 'fixed'});
            $morePromptTextLink.html(goToBottomText);
            toggleArrowClass("icon-angle-down");
            scrollTo = 'bottom';
        } else {
            // if we've hit the area just after the results
            if (currentPos >= lastAvailableProductPos) {
                $morePrompt.css({top: lastAvailableProductPos, height: $morePrompt.height(), position: 'absolute'});
                $morePromptTextLink.html(goToTopText);
                toggleArrowClass("icon-angle-up");
                scrollTo = 'top';
            } else {
                if ($morePrompt.css("position") != "fixed") {
                    $morePrompt.removeAttr('style').css({position: 'fixed'});
                }
            }
        }
    }

    function resetMorePromptBar() {
        // defer by 1ms to ensure everything is rendered otherwise it throws an error
        _.defer(function () {
            $morePromptTextLink.html(goToBottomText);
            scrollTo = "bottom";
            toggleArrowClass("icon-angle-down");
            $morePrompt.removeAttr('style');
        });
    }

    function toggleArrowClass(thisClass) {
        if (!$morePromptIcons.hasClass(thisClass)) {
            $morePromptIcons.toggleClass("icon-angle-down icon-angle-up"); // toggle classes
        }
    }

    function disablePromptBar() {
        $(window).off('scroll.travelMorePrompt');
        $morePrompt.hide();
    }
    function initTravelMorePrompt() {

        $htmlBody = $('body,html');
        $footer = $("#footer");
        $morePrompt = $('.morePromptContainer');
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
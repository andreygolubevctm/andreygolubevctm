;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	// Keep track of the device type so we can adjust how we calculate and show the docked header.
	var deviceType = null;
	// We need to keep track of the headerAffixed state, so we keep the docked header on other events.
	var headerAffixed = false;
	// Track whether the vertical implements V3 of the results styling
	var isV3 = null;

	function init() {
		deviceType = $('#deviceType').attr('data-deviceType');

		jQuery(document).ready(function($) {
			applyEventListeners();
			eventSubscriptions();

		});
	}

	function applyEventListeners() {

		$(document).on('results.view.animation.start, pagination.scrolling.start', function onAnimationStart() {
			calculateDockedHeader('startPaginationScroll');
		});

		$(document).on('pagination.scrolling.end', function onPaginationEnd() {
			calculateDockedHeader('endPaginationScroll');
		});

		$(document).on('results.view.animation.end', function onAnimationEnd() {
			// Remove the "position:relative" from the result-row, otherwise Chrome will not render the
			// docked header correctly when the animation finishes after a shuffle.
			$('.result-row').css({'position': ''});
			calculateDockedHeader('filterAnimationEnded');
		});

	}

	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
			headerAffixed = true;
			calculateDockedHeader('affixed');
		});

		meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
			headerAffixed = false;
			calculateDockedHeader('unaffixed');
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function onDeviceMediaStateChange() {
			calculateDockedHeader('deviceMediaStateChange');
		});

		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function onExitCompareMode() {
			calculateDockedHeader('startPaginationScroll');
		});

		meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function onAfterEnterCompareMode() {
			calculateDockedHeader('endPaginationScroll');
		});

	}


	function calculateDockedHeader(event) {

		if(_.isNull(isV3)) {
			isV3 = $('#results_v3').length > 0;
		}

		var $featuresDockedHeader = $('.featuresDockedHeader'),
			$originalHeader = $('.headers');

		// There are copious issues with tablets and position:fixed. This just doesn't do the docked header, until we can fix it.
		if (isV3 === true && deviceType != 'TABLET' && meerkat.modules.deviceMediaState.get() != 'xs') {
			var featuresView = Results.getDisplayMode() == 'features' ? true : false,
				redrawFixedHeader = true,
				pagePaginationActive = event == 'startPaginationScroll' || event == 'endPaginationScroll' || event == 'filterAnimationEnded';

			if (featuresView) {
				var $fixedDockedHeader = $('.fixedDockedHeader');

				if (headerAffixed) {

					if($originalHeader.parent().hasClass('featuresHeaders') === false){
						$originalHeader.hide();
					}

					var $currentPage = $('.currentPage'),
						topPosition = $('#navbar-filter').height() + $('#navbar-main').outerHeight(),
						dockedHeaderTop = event == 'startPaginationScroll' ? '0' : topPosition + 'px',
						dockedHeaderWidth = $('.result-row').first().width();

					var pageContentOffSet = $('#pageContent').offset(),
						navFilterOffSet = $('#navbar-filter').offset(),
						offSetFromTopPlusNav = (_.isUndefined(navFilterOffSet) ? 0 : navFilterOffSet.top) - (_.isUndefined(pageContentOffSet) ? 0 : pageContentOffSet.top) + 7,
						dockedHeaderPosition = event == 'startPaginationScroll' ? 'absolute' : 'fixed',
						dockedHeaderPaddingTop = event == 'startPaginationScroll' ? offSetFromTopPlusNav + 'px' : '0px';

					if (!pagePaginationActive) {
						$currentPage.find($featuresDockedHeader).css({
							'top': dockedHeaderTop,
							'width': dockedHeaderWidth
						}).show();

					} else {
						redrawFixedHeader = false;
						$featuresDockedHeader.css({
							'position': dockedHeaderPosition,
							'top': dockedHeaderTop,
							'width': dockedHeaderWidth,
							'padding-top': dockedHeaderPaddingTop
						}).show();

						if (event == 'endPaginationScroll' || event == 'filterAnimationEnded') {
							// Only show the current providers docked bar.
							if ($currentPage.length >= 1) {
								$currentPage.siblings(":not(.currentPage)").find($featuresDockedHeader).hide();
							} else {
								$featuresDockedHeader.hide();
							}
							redrawFixedHeader = true;

						}
					}

					recalculateFixedHeader(redrawFixedHeader);

				} else {
					$featuresDockedHeader.hide();
					$fixedDockedHeader.hide();
					$originalHeader.show();

				}

			} else {
				// Reset the elements, so we don't have any weirdness switching back and forth.
				$originalHeader.show();
				$featuresDockedHeader.hide();

			}
		} else {
			// Reset the elements, so we don't have any weirdness switching back and forth.
			$originalHeader.show();
			$featuresDockedHeader.hide();

		}
	}

	function recalculateFixedHeader(redrawFixedHeader) {
		var $fixedDockedHeader = $('.fixedDockedHeader'),
			$currentPage = $('.currentPage'),
			topPosition = $('#navbar-filter').height() + $('#navbar-main').outerHeight();
		if (redrawFixedHeader) {
			// Set a default height if we don't have a docked header on the current page.
			var cellFeatureWidth = $('.cell.feature').width() + 2 + 'px',
				dockedHeaderHeight = '100px';
			if ($currentPage.length >= 1) {
				// Calculate the hight of the fixed header based off the docked header hight.
				dockedHeaderHeight = $('.currentPage .resultInsert.featuresMode:visible').first().innerHeight() + 1 + 'px';
			}
			$fixedDockedHeader.css({'top': topPosition, 'width': cellFeatureWidth, 'height': dockedHeaderHeight}).show();
		}
	}

	meerkat.modules.register("featuresDockedHeader", {
		init: init
	});

})(jQuery);
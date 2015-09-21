/**
 *
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var $component,
		$activator,
		$pageNumber;

	function init() {
		$(document).ready(initResultsLoadMore);
	}

	function initResultsLoadMore() {
		// Find if this module needs to execute
		$component = $('[data-provide="results-load-more"]');
		if ($component.length === 0) {
			return;
		}

		$pageNumber = $('#homeloan_results_pageNumber');

		// Find activator button if one is present
		$activator = $component.find('.results-load-more-activator');
		if ($activator.length === 0) {
			$activator = false;
		}
		else {
			$activator.on('click.resultsLoadMore', onStart);
		}

		// Event
		meerkat.messaging.subscribe(meerkat.modules.homeloanResults.events.RESULTS_REMAINING_PRODUCTS, function remainingProducts(obj) {
			if (_.isNumber(obj) && obj > 0) {
				show();
			}
			else {
				hide();
			}
		});
	}

	function onStart() {
		meerkat.modules.loadingAnimation.showInside($component, true);

		if ($activator !== false) {
			$activator.hide();
		}

		// Increment page number
		$pageNumber.val( parseInt($pageNumber.val(), 10) + 1 );

		// Fetch new results
		meerkat.modules.comms.post({
			url: Results.settings.url,
			data: meerkat.modules.form.getData( $(Results.settings.formSelector) ),
			dataType: 'json',
			cache: false,
			errorLevel: 'warning'
		})
		.fail(onError)
		.done(onSuccess)
		.always(onComplete);
	}

	function onError() {
		// Rollback the page number
		$pageNumber.val( parseInt($pageNumber.val(), 10) - 1 );
	}

	function onSuccess(json) {
		// Update transaction ID if present
		Results.model.updateTransactionIdFromResult(json);
		Results.model.triggerEventsFromResult(json);

		var newResults = Object.byString(json, Results.settings.paths.results.list);


		if (typeof newResults !== 'undefined') {

			// For sending only additional products to tracking.
			var indexIncrement = Results.model.sortedProducts.length;
			// sortedProducts is the collection used by the View to render
			Results.model.sortedProducts = newResults;

			meerkat.modules.homeloanResults.massageResultsObject(Results.model.sortedProducts);

			var sTagProductList = {};
			// Add the new results to the results model
			// filteredProducts is required so the View doesn't 'hide' the new products.
			_.each(newResults, function eachResult(result, index) {
				Results.model.returnedProducts.push(result);
				Results.model.filteredProducts.push(result);
				sTagProductList[indexIncrement] = {
						productID: result.id,
						ranking: indexIncrement,
						productName: result.lenderProductName,
						productBrandCode: result.brandCode,
						available: "Y"
				};
				indexIncrement++;
			});

			meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
				additionalData: {
					products: sTagProductList,
					loadMoreResultsPageNumber: $pageNumber.val(),
					event: 'Refresh'
				},
				onAfterEventMode: 'Load'
			});

			var $overflow = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.resultsOverflow);
			var overflowPreviousHeight = $overflow.outerHeight(true);
			var overflowNewHeight = 'auto';

			// Render the new products. It gets appended to the results container.
			Results.view.buildHtml();
			Results.model.sortedProducts = Results.model.filteredProducts;
			var countVisible = 0;
			$.each(Results.model.sortedProducts, function(index, result){
				$('.result_'+result.id).addClass("notfiltered").attr("data-position", countVisible)
				.attr("id", "result-row-" + index).attr("data-sort", index);
				countVisible++;
			});

			// Get the new height
			overflowNewHeight = $overflow.outerHeight(true);

			$overflow.css({
				'height': overflowPreviousHeight,
				'overflow': 'hidden'
			});

			$overflow.animate(
				{
					height: overflowNewHeight
				},
				2000,
				function animateComplete() {
					$overflow.css('height', 'auto');
				}
			);
		}
	}

	function onComplete() {
		meerkat.modules.loadingAnimation.hide($component);

		if ($activator !== false) {
			$activator.show();
		}
	}

	function hide() {
		$component.addClass('hidden');
	}

	function show() {
		$component.removeClass('hidden');
	}

	meerkat.modules.register('homeloanResultsLoadMore', {
		init: init,
		onStart: onStart,
		onComplete: onComplete,
		hide: hide,
		show: show
	});

})(jQuery);
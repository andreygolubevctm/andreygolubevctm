;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = window.meerkat.logging.info;

	var events = {
			// Defined here because it's published in ResultsModel.js
			RESULTS_DATA_READY: 'RESULTS_DATA_READY',
			// Defined here because it's published in ResultsView.js
			RESULTS_SORTED: 'RESULTS_SORTED'
	},
	moduleEvents = events;

	var supertagEventMode = 'Load';

	function write() {

		if(!_.isUndefined(Results.settings.rankings)) {

			var config = Results.settings.rankings;

			var externalTrackingData = [];

			var sorted = Results.getSortedResults();
			var filtered = Results.getFilteredResults();
			var vertical = meerkat.site.vertical;

			var sortedAndFiltered = [];

			for(var i=0; i < sorted.length; i++){
				for(var j=0; j < filtered.length; j++){
					if(sorted[i] == filtered[j]){
						sortedAndFiltered[sortedAndFiltered.length] = sorted[i];
					}
				}
			}

			var data = {
					rootPath:		vertical,
					rankBy:			Results.getSortBy() + "-" + Results.getSortDir(),
					rank_count:		sortedAndFiltered.length,
					transactionId:	meerkat.modules.transactionId.get()
			};

			for (var k = 0; k < sortedAndFiltered.length; k++) {

				var productId = Object.byString( sortedAndFiltered[k], config.paths.productId );
				var price = Object.byString( sortedAndFiltered[k], config.paths.price );

				/* @TODO ideally we'd like to be able to loops over a list of paths
					and add them to the data object. eg Health has a range of additional
					properties it adds to the ranking details table */

				data[config.parameters.productId + k] = productId;

				if ( price ) {
					data[config.parameters.price + k] = price;
				}

				var rank = k+1;
				externalTrackingData.push({
					productID : productId,
					ranking:rank
				});
			}

			meerkat.modules.comms.post({
				url: "ajax/write/quote_ranking.jsp",
				data: data,
				cache: false,
				errorLevel: "silent",
				onSuccess: function onRankingsWritten() {
					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method:'trackQuoteProductList',
						object:{
							products: externalTrackingData,
							vertical: meerkat.site.vertical
						}
					});

					/* Due to disparity between object properties for each vertical it is up to the vertical
					 * to make additional SuperTag calls to: trackQuoteList and/or trackQuoteForms
					 */

					supertagEventMode = 'Refresh'; // update for next call.*/
				},
				onError: function onWriteRankingsError(jqXHR, textStatus, errorThrown, settings, resultData) {
					meerkat.modules.errorHandling.error({
						message:		"Failed to write ranking results.",
						page:			"core:resultsRankings.js:write()",
						errorLevel:		"silent",
						description:	"Failed to write ranking results: " + errorThrown,
						data: {settings:settings, resultsData:resultData}
					});
				}
			});
		}
	}

	function registerSubscriptions() {
		switch(meerkat.site.vertical) {
			case 'car':
				meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, write);
				meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, write);
				break;
			default:
				// ignore - vertical to handle its own rank writing
				break;
		}
	}

	function initResultsRankings() {

		var self = this;

		$(document).ready(function() {
			registerSubscriptions();
		});

	}

	meerkat.modules.register("resultsRankings", {
		init : initResultsRankings,
		events : moduleEvents,
		write : write
	});

})(jQuery);
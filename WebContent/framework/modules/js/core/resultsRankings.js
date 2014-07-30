;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = window.meerkat.logging.info;

	var events = {
			RESULTS_RANKING_READY: 'RESULTS_RANKING_READY',
			// Defined here because it's published in Results.js
			RESULTS_INITIALISED: 'RESULTS_INITIALISED',
			// Defined here because it's published in ResultsModel.js
			RESULTS_DATA_READY: 'RESULTS_DATA_READY',
			// Defined here because it's published in ResultsView.js
			RESULTS_SORTED: 'RESULTS_SORTED'
	},
	moduleEvents = events;

	var defaultRankingTriggers = ['RESULTS_DATA_READY','RESULTS_SORTED'];

	function write(trigger) {

		var externalTrackingData = [];

		function appendTrackingData(id, pos) {
			externalTrackingData.push({
				productID : id,
				ranking: pos
			});
		}

		if(Results.settings.hasOwnProperty('rankings')) {

			var config = Results.settings.rankings;

			var sorted = Results.getSortedResults();
			var filtered = Results.getFilteredResults();
			var vertical = meerkat.site.vertical;

			var sortedAndFiltered = [];

			var method = null;
			var forceNumber = false;
			if(_.isObject(config) && !_.isEmpty(config)) {
				if(config.hasOwnProperty('paths') && _.isObject(config.paths)) {
					method = "paths";
				} else if(config.hasOwnProperty('callback') && _.isFunction(config.callback)) {
					method = "callback";
				}

				if(config.hasOwnProperty('forceIdNumeric') && _.isBoolean(config.forceIdNumeric)) {
					forceNumber = config.forceIdNumeric;
				}
			}

			if(!_.isNull(method)) {

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

					var rank = k+1;
					var price = sortedAndFiltered[k];
					var productId = price.productId;

					if(forceNumber) {
						productId = String(productId).replace(/\D/g,'');
					}

					if(method === "paths") {

						for(var p in config.paths) {

							if(config.paths.hasOwnProperty(p)) {

								var item = Object.byString( price, config.paths[p] );

								data[p + k] = item;
							}
						}

					} else if(method === "callback") {

						var response = config.callback(price, k);
						if(_.isObject(response) && !_.isEmpty(response)) {
							_.extend(data, response);
						}
					}

					appendTrackingData(productId, rank);
				}

				meerkat.logging.info("writing ranking data", {
					trigger: trigger,
					method: method,
					data: data
				});

				meerkat.modules.comms.post({
					url: "ajax/write/quote_ranking.jsp",
					data: data,
					cache: false,
					errorLevel: "silent",
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

				// Publish common external tracking
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

				// Publish event for vertical results JS to perform next tracking event
				meerkat.messaging.publish(meerkatEvents.RESULTS_RANKING_READY);
			}
		}
	}

	function registerSubscriptions() {

		var config = Results.settings.rankings;

		if(_.isObject(config)) {

			if((config.hasOwnProperty('paths') && !_.isEmpty(config.paths)) || (config.hasOwnProperty('callback') && _.isFunction(config.callback))) {

				var triggers = defaultRankingTriggers;
				if(config.hasOwnProperty('triggers') && _.isArray(config.triggers)) {
					triggers = config.triggers;
				}

				for(var i=0; i<triggers.length; i++) {
					if(meerkatEvents.hasOwnProperty(triggers[i])) {
						meerkat.messaging.subscribe(meerkatEvents[triggers[i]], _.bind(write,this,triggers[i]));
					}
				}
			}
		}
	}

	function initResultsRankings() {

		var self = this;

		$(document).ready(function() {
			// We need to wait until results object is initialised before setting up rank event listeners
			meerkat.messaging.subscribe(meerkatEvents.RESULTS_INITIALISED, registerSubscriptions);
		});

	}

	meerkat.modules.register("resultsRankings", {
		init : initResultsRankings,
		events : moduleEvents,
		write : write
	});

})(jQuery);
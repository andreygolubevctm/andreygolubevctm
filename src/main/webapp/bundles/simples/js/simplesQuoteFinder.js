/*

*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var modalId = false,
		searchTerm = false,
		templateQuoteDetails = false;



	function init() {
		$(document).ready(function() {

			$('[data-provide="simples-quote-finder"]').on('click', 'a', function(event) {
				event.preventDefault();
				launch();
			});

			// Event: Search modal form submit (uses #dynamic_dom because that is static on the page so retains the event binds)
			$('#dynamic_dom').on('submit', 'form.simples-search-quotedetails', function searchModalSubmit(event) {
				event.preventDefault();
				searchTerm = $(this).find(':input[name=keywords]').val();
				performSearch();
			});

			// Set up templates
			var $e = $('#simples-template-quotedetails');
			if ($e.length > 0) {
				templateQuoteDetails = _.template($e.html());
			}

		});
	}

	function launch() {
		modalId = meerkat.modules.dialogs.show({
			title: ' ',
			fullHeight: true,
			onOpen: function(id) {
				modalId = id;
				performSearch();
			},
			onClose: function() {
			}
		});
	}

	function performSearch() {
		// Reset
		updateModal();

		if (searchTerm === false || searchTerm === '') return;

		var validatedData = validateSearch(searchTerm);
		if (validatedData.valid === false) {
			validatedData.errorMessage = 'The search term is not valid. Must be valid email or transaction ID';
			updateModal(validatedData);
			return;
		}

		meerkat.modules.comms.post({
			url: 'simples/ajax/quote_finder.jsp',
			dataType: 'json',
			cache: false,
			errorLevel: 'silent',
			useDefaultErrorHandling: false,
			data: validatedData,
			onSuccess: function onSearchSuccess(json) {
				var data = {};

				if (typeof window.InspectorJSON === 'undefined') {
					data.errorMessage = 'InspectorJSON plugin is not available.';
				}
				else if (json.hasOwnProperty('findQuotes') && json.findQuotes.hasOwnProperty('quotes')) {
					data.results = json.findQuotes.quotes;

					// Turn into an array if not (stupid xml-to-json)
					if (!_.isArray(data.results)) {
						data.results = [json.findQuotes.quotes];
					}
				}

				updateModal(data);

				if (data.hasOwnProperty('errorMessage') === false) {
					jsonViewer(data.results);
				}
			},
			onError: function onError(obj, txt, errorThrown) {
				updateModal({errorMessage: txt + ': ' + errorThrown});
			}
		});
	}

	function jsonViewer(results) {
		var obj = {};
		var id;
		for (var i in results) {
			if (results[i].hasOwnProperty('quote')) {
				id = results[i].id + " - Car";
				obj[id] = {};
				obj[id] = results[i].quote;
			}
			else if (results[i].hasOwnProperty('health')) {
				id = results[i].id + " - Health";
				obj[id] = {};
				obj[id] = getCustomHealth(results[i].health);
			}
			else if (results[i].hasOwnProperty('ip')) {
				id = results[i].id + " - IP";
				obj[id] = {};
				obj[id] = results[i].ip;
			}
			else if (results[i].hasOwnProperty('life')) {
				id = results[i].id + " - Life";
				obj[id] = {};
				obj[id] = results[i].life;
			}
			else if (results[i].hasOwnProperty('travel')) {
				id = results[i].id + " - Travel";
				obj[id] = {};
				obj[id] = results[i].travel;
			}
			else if (results[i].hasOwnProperty('utilities')) {
				id = results[i].id + " - Utilities";
				obj[id] = {};
				obj[id] = results[i].utilities;
			}
			else if (results[i].hasOwnProperty('home')) {
				id = results[i].id + " - Home & Contents";
				obj[id] = {};
				obj[id] = results[i].home;
			}
			else {
				id = results[i].id + " - Unhandled vertical";
				obj[id] = {};
			}
		}

		if (typeof viewer === 'object' && viewer instanceof InspectorJSON) {
			viewer.destroy();
		}

		viewer = new InspectorJSON({
			element: $('#quote-details-container')[0],
			collapsed: true,
			debug: false,
			json: obj
		});
	}

	/**
	 * getCustomHealth - updates row object with verbose benefit data for
	 * HBF's flexi-extras.
	 * @param row
	 * @returns {*}
     */
	function getCustomHealth(row) {
		if(
			// Only proceed if is a HBF application with flexi-extras defined
			row.hasOwnProperty("application") &&
			_.isObject(row.application) &&
			row.application.provider=="HBF" &&
			row.application.hasOwnProperty("hbf") &&
			_.isObject(row.application.hbf) &&
			row.application.hbf.hasOwnProperty("flexiextras") &&
			!_.isEmpty(row.application.hbf.flexiextras)
		) {
			var benefits = row.application.hbf.flexiextras.split(",");
			if(_.isArray(benefits) && benefits.length) {
				var getBenefitMapping = function(ben) {
					// Duplicate of benefit mappings from healthFunds_HBF.jsp
					var mapping = {
						GDL:"General Dental",
						MDL:"Major Dental",
						OPT:"Optical",
						EYT:"Eye Therapy",
						POD:"Podiatry",
						PHY:"Physiotherapy",
						EXP:"Exercise Physiology",
						CHI:"Chiropractic",
						OST:"Osteopathy",
						PHA:"Pharmacy",
						REM:"Remedial Massage",
						SPT:"Speech Therapy",
						OCT:"Occupational Therapy",
						PSY:"Psychology",
						NAT:"Natural Therapies",
						NTN:"Nutritionist",
						APP:"Appliances",
						HLP:"Healthy living programs",
						UAM:"Urgent Ambulance"
					};
					return _.isUndefined(mapping[ben]) ? "** Undefined **" : mapping[ben];
				};
				row.application.hbf.flexiextras = {};
				for(var i=0; i<benefits.length; i++) {
					row.application.hbf.flexiextras[benefits[i]] = getBenefitMapping(benefits[i]);
				}
			}
		}
		return row;
	}

	function updateModal(data) {
		var htmlContent = 'No template found.';
		data = data || {};

		if (typeof templateQuoteDetails === 'function') {
			// Generate data object for the template
			data.results = data.results || '';
			data.keywords = data.keywords || searchTerm || '';

			if (data.errorMessage && data.errorMessage.length > 0) {
				// Error message has been specified elsewhere
			}
			else if (data.keywords === '') {
				data.errorMessage = 'Please enter something to search for.';
			}
			else if (data.results === '') {
				data.results = meerkat.modules.loadingAnimation.getTemplate();
			}

			// Run the template
			htmlContent = templateQuoteDetails(data);
		}

		// Replace modal with updated contents
		meerkat.modules.dialogs.changeContent(modalId, htmlContent, function simplesSearchModalChange() {
			// Move the template header into the modal header
			// This allows the search results to automatically be the scrollable region.
			$('#'+modalId + ' .modal-header').empty().prepend($('#'+modalId + ' #simples-search-modal-header'));
		});

	}

	// Validate search term
	function validateSearch(term) {
		var result = {
			valid: false,
			term: $.trim(term),
			type: false
		};

		if (term.length > 0) {
			if (isTransactionId(term)) {
				result = $.extend(result, {valid:true, type:'transactionid'});
			}
			else if (isValidEmailAddress(term)) {
				result = $.extend(result, {valid:true, type:'email'});
			}
		}

		return result;
	}

	// Validate email address
	function isValidEmailAddress(emailAddress) {
		var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
		return pattern.test(emailAddress);
	}

	// Validate transaction ID
	function isTransactionId(tranId) {
		try {
			var test = parseInt(String(tranId), 10);
			return !isNaN(test);
		} catch(e) {
			return false;
		}
	}



	meerkat.modules.register('simplesQuoteFinder', {
		init: init
	});

})(jQuery);

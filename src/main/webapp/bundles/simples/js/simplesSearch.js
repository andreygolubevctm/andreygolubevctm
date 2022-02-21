;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var moduleEvents = {
		};

	var modalId = false,
		templateSearch = false,
		templateMoreInfo = false,
		templateComments = false,
		searchResults = false,
		searchTerm = '';



	function init() {

		$(document).ready(function() {

			eventDelegates();

			//
			// Set up templates
			//
			var $e = $('#simples-template-search');
			if ($e.length > 0) {
				templateSearch = _.template($e.html());
			}

			$e = $('#simples-template-moreinfo');
			if ($e.length > 0) {
				templateMoreInfo = _.template($e.html());
			}

			$e = $('#simples-template-comments');
			if ($e.length > 0) {
				templateComments = _.template($e.html());
			}
		});
	}

	function eventDelegates() {
		//
		// Event: Navbar search submit
		//
		$('#simples-search-navbar').on('submit', function navbarSearchSubmit(event) {
			event.preventDefault();

			// Collect the search keywords
			searchTerm = $(this).find(':input[name=keywords]').val();

			openModal();
		});

		//
		// Event: Search modal form submit (uses #dynamic_dom because that is static on the page so retains the event binds)
		//
		$('#dynamic_dom').on('submit', 'form.simples-search', function searchModalSubmit(event) {
			event.preventDefault();
			searchTerm = $(this).find(':input[name=keywords]').val();
			performSearch();
		});

		//
		// Event: Search modal action buttons click
		//
		$('#dynamic_dom').on('click', '.search-quotes-results .btn[data-action]', searchModalResultButton);

		//
		// Event: Comments add
		//
		$('#dynamic_dom').on('click', '.comment-hideshow', function showAddComment(event) {
			event.preventDefault();
			var $this = $(this);
			$this.addClass('hidden');
			$this.siblings('.comment-inputfields').slideToggle(200);
		});

		$('#dynamic_dom').on('click', '.comment-addcomment', clickAddComment);
	}

	function searchModalResultButton(event) {
		event.preventDefault();

		var $button = $(this),
			action = $button.attr('data-action'),
			$resultRow = $button.parents('.search-quotes-result-row'),
			transactionId = $resultRow.attr('data-id');

		if ('amend' === action) {

			transactionId = $resultRow.attr('data-id');
			var vertical = $resultRow.attr('data-vertical');

			//alert('Amend quote for ' + transactionId);
			_.defer( function closeModal() {
				meerkat.modules.dialogs.close(modalId);
			});

		}
		else if ('moreinfo' === action) {

			// Close more info panel
			if ($resultRow.hasClass('open')) {
				$resultRow.removeClass('open');
				$button.text($button.attr('data-originaltext'));

				$resultRow.find('div.moreinfo-container').slideUp(200);
				$('.clinical-benefits-info-' + transactionId).addClass('hidden');
				$('.selected-benefits-info-' + transactionId).removeClass('hidden');
			}
			// Open more info panel
			else {
				$resultRow.addClass('open');
				$button.attr('data-originaltext', $button.text());
				$button.text('Less details');

				// Remove row highlight from any previously open result
				$resultRow.parent().children().not('.open').removeClass('bg-success');

				// Highlight the row
				$resultRow.addClass('bg-success');

				$resultRow.find('div.moreinfo-container').remove();
				$resultRow.append('<div class="moreinfo-container"></div>');

				var $container = $resultRow.find('div.moreinfo-container');
				transactionId = $resultRow.attr('data-id');

				var resultIndex = $resultRow.attr('data-index');
				var resultData = searchResults[resultIndex] || false;

				fetchMoreInfo(transactionId, $container, resultData);
				$('.clinical-benefits-info-' + transactionId).removeClass('hidden');
				$('.selected-benefits-info-' + transactionId).addClass('hidden');
			}

		}
	}

	function fetchMoreInfo(transactionId, $container, extraData) {
		if (typeof transactionId == 'undefined' || transactionId.length === 0) {
			$container.html('Could not get more info: transaction ID not known');
			return;
		}

		extraData = extraData || {};

		// Show an initial loading animation
		$container.html( meerkat.modules.loadingAnimation.getTemplate() );
		$container.slideDown(200);

		meerkat.modules.comms.get({
			url: 'simples/transactions/details.json',
			cache: false,
			errorLevel: 'silent',
			data: {
				transactionId: transactionId
			},
			onSuccess: function onSearchSuccess(json) {
				var htmlContent = '';

				if (typeof templateMoreInfo !== 'function') {
					htmlContent = 'Could not get more info: template not configured.';
				}
				else {
					// Add any extra data if provided
					$.extend(true, json, extraData);

					// Render the template using the data
					htmlContent = templateMoreInfo(json);
				}

				// Display the content
				$container.html( htmlContent );
			},
			onError: function onError(obj, txt, errorThrown) {
				$container.html('Could not get more info: ' + txt + ' ' + errorThrown);
			}
		});
	}

	function performSearch() {
		//log('simplesSearch.performSearch', searchTerm);

		// Reset
		searchResults = false;
		updateModal();

		if (searchTerm === false || searchTerm === '') return;

		// Update search box on navbar
		$('#simples-search-navbar').find(':input[name=keywords]').val(searchTerm);

		meerkat.modules.comms.post({
			url: 'simples/ajax/search_quotes.jsp',
			dataType: 'json',
			cache: false,
			errorLevel: 'silent',
			useDefaultErrorHandling: false,
			data: {
				simples: true,
				search_terms: searchTerm
			},
			onSuccess: function onSearchSuccess(json) {
				var data = {};

				if (json.hasOwnProperty('search_results') && json.search_results.hasOwnProperty('quote')) {
					data.results = json.search_results.quote;

					// Turn into an array if not (stupid xml-to-json)
					if (!_.isArray(data.results)) {
						data.results = [json.search_results.quote];
					}

					// Store the object
					searchResults = data.results;
				}

				updateModal(data);
			},
			onError: function onError(obj, txt, errorThrown) {
				updateModal({errorMessage: txt + ': ' + errorThrown});
			}
		});
	}

	function openModal() {
		meerkat.modules.dialogs.show({
			//htmlContent: htmlContent,
			title: ' ',
			fullHeight: true,
			showCloseBtn: false,
			onOpen: function(id) {
				modalId = id;
				performSearch();
			},
			onClose: function() {
			}
		});
	}

	function updateModal(data) {
		var htmlContent = 'No template found.';
		data = data || {};

		if (typeof templateSearch === 'function') {
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
			htmlContent = templateSearch(data);
		}

		// Replace modal with updated contents
		meerkat.modules.dialogs.changeContent(modalId, htmlContent, function simplesSearchModalChange() {
			// Move the template header into the modal header
			// This allows the search results to automatically be the scrollable region.
			$('#'+modalId + ' .modal-header').empty().prepend($('#'+modalId + ' #simples-search-modal-header'));
		});

	}


	function clickAddComment(event) {
		event.preventDefault();

		var $resultRow = $(this).parents('.comment-container');
		var transactionId = $resultRow.attr('data-id');
		var $comment = $resultRow.find('textarea');
		var $error = $resultRow.find('.comment-error');

		//Validation check
		if (transactionId === undefined || transactionId.length === 0) {
			$error.text('Transaction ID not found or not defined.');
			return;
		}
		if (!$comment.val || $comment.val().length === 0) {
			$error.text('Comment length can not be zero.');
			return;
		}

		// Show animation
		var $button = $resultRow.find('.comment-addcomment');
		$button.prop('disabled', true);
		meerkat.modules.loadingAnimation.showInside($button, true);
		$error.text('');

		addComment( transactionId, $comment.val(),
			function addCommentOk(json) {
				$button.prop('disabled', false);
				meerkat.modules.loadingAnimation.hide($button);
				$comment.val('');
				$resultRow.find('.comment-hideshow').removeClass('hidden');
				$resultRow.find('.comment-inputfields').slideUp(200);

				//Re-render the comments partial template
				if (typeof templateComments === 'function') {
					$resultRow.html( templateComments(json) );
				}
			},
			function addCommentErr(obj, txt, errorThrown) {
				$button.prop('disabled', false);
				meerkat.modules.loadingAnimation.hide($button);
				$error.text('Error: ' + txt + ' ' + errorThrown);
			}
		);
	}

	/**
	 *
	 */
	function addComment(transactionId, comment, callbackSuccess, callbackError) {
		if (!transactionId || transactionId.length === 0) {
			alert('transactionId must be defined.');
			return;
		}

		meerkat.modules.comms.post({
			url: 'simples/ajax/comment_add_then_get.jsp',
			dataType: 'json',
			cache: false,
			errorLevel: 'silent',
			data: {
				transactionId: transactionId,
				comment: comment
			},
			onSuccess: function(json) {
				if (json && json.errors && json.errors.length > 0) {
					if (typeof callbackError === 'function') callbackError(json, '', json.errors[0].message);
				}
				else {
					if (typeof callbackSuccess === 'function') callbackSuccess(json);
				}
			},
			onError: function(obj, txt, errorThrown) {
				if (typeof callbackError === 'function') callbackError(obj, txt, errorThrown);
			}
		});
	}



	meerkat.modules.register('simplesSearch', {
		init: init,
		events: moduleEvents
	});

})(jQuery);
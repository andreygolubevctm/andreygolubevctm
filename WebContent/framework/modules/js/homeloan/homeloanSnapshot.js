/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			homeloanSnapshot: {
			}
		},
		moduleEvents = events.example;

	var product;

	function initHomeloanSnapshot() {
		renderSnapshot();
		fillTemplate();
	}

	function renderSnapshot() {
		var $situation = '<p>Looking to <span data-source="#homeloan_details_goal"></span>';
		if ($("#homeloan_details_situation").val() === 'E') {
			if ($('#homeloan_details_currentLoan_Y').is(':checked')) {
				$situation = $situation + ' with an existing loan';
			} else {
				$situation = $situation + ' with no existing loan';
			}
			$situation = $situation + ' and property worth <span data-source="#homeloan_details_assetAmountentry"></span>';
		}
		$situation = $situation + '. Looking to borrow <span data-source="#homeloan_loanDetails_loanAmountentry"></span>.';
		$('.snapshotGoal').html($situation);
		meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(2) .snapshot');

	}

	function fillTemplate() {

		var productTemplate = $("#snapshot-template").html();
		var htmlTemplate = _.template(productTemplate);
		var htmlString = htmlTemplate(Results.getSelectedProduct());
		$(".product-snapshot").html(htmlString);
	}
	meerkat.modules.register('homeloanSnapshot', {
		initHomeloanSnapshot: initHomeloanSnapshot, //main entrypoint to be called.
		events: events, //exposes the events object
		renderSnapshot: renderSnapshot
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);
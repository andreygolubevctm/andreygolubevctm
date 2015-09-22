;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info

		//Stores the jQuery object for the component group
	var $resultsSummaryPlaceholder,
		$fromDate,
		$toDate,
		$worldwide,
		$adults,
		$children,
		$policytype,
		$summaryHeader,
		$selectedTags,
		initialised = false;

	function updateSummaryText() {
		// let it fire in all modes if in the event xs is displayed but a different orientation displays something greater

		// Build the summary text based on the entered information.
		var txt= '<span class="highlight">';

		var adults = $adults.val(),
		children = $children.val();

		// adults
		txt += adults + ' adult' + (adults == 1 ? '' : 's');

		// children
		if (children > 0)
		{
			txt += ' and ' + children + ' child' + (children == 1 ? '' : 'ren');
		}

		// if this is a single trip
		if ($("input[name=travel_policyType]:checked").val() == 'S')
		{
			// in case a user did an AMT quote and now wants a single trip quote
			$summaryHeader.html('Your quote is based on');
			txt +='</span> <span class="optional">travelling</span> <span class="sm-md-block">to <span class="highlight">';

			// update the country text for single trip
			if ($selectedTags.children().length == 1) {
				txt += $selectedTags.find('li:first-child').data("fulltext");
			} else {
				txt += "multiple destinations";
			}

			// duration calculation
			var x=$fromDate.val().split("/"),
				y=$toDate.val().split("/"),
				date1=new Date(x[2],(x[1]-1),x[0]),
				date2=new Date(y[2],(y[1]-1),y[0]);

			var DAY=1000*60*60*24,
				days=1+Math.ceil((date2.getTime()-date1.getTime())/(DAY));

			txt += "</span> for <span class='highlight'>"+days+" days</span>";
		} else {
			$summaryHeader.html('Your Annual Multi Trip (AMT) quote is based on');
			var blockClass = children > 1 ? 'sm-md-block' : 'sm-block';
			txt+="</span> travelling <span class='highlight "+blockClass+"'>multiple times in one year";
		}

		$resultsSummaryPlaceholder.html(txt+'</span>').fadeIn();
	}

	function initSummaryText() {
		if(!initialised) {
			initialised = true;

			$resultsSummaryPlaceholder = $(".resultsSummaryPlaceholder"),
			$fromDate = $("#travel_dates_fromDate"),
			$toDate = $("#travel_dates_toDate"),
			$worldwide = $('#travel_destinations_do_do'),
			$adults = $('#travel_adults'),
			$children = $('#travel_children'),
			$policytype = $('#travel_policyType');
			$summaryHeader = $('.resultsSummaryContainer h5');
			$selectedTags = $('.selected-tags');

			applyEventListeners();
		}
	}

	function applyEventListeners() {
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_SM, function updateSummaryTextXS(){
			if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results') {
				updateSummaryText();
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_MD, function updateSummaryTextMD(){
			if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results') {
				updateSummaryText();
			}
		});
	}

	function init(){

	}

	meerkat.modules.register('travelSummaryText', {
		init: init,
		initSummaryText: initSummaryText,
		updateText: updateSummaryText
	});

})(jQuery);

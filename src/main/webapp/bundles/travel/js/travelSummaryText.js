;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;
		//Stores the jQuery object for the component group
	var $resultsSummaryPlaceholder,
		$adults,
		$children,
		$summaryHeader,
		$selectedTags,
		initialised = false;

	function updateSummaryText() {
		// let it fire in all modes if in the event xs is displayed but a different orientation displays something greater
		// Build the summary text based on the entered information.
		
		var txt= '<span class="highlight">';
		var adults = $adults.val(),
		children = $children.val();
		
		if (adults < 3) {
			// adults
			txt += adults + ' adult' + (adults == 1 ? '' : 's');
		} else {
			txt += adults;
		}
		
		// children
		if (children > 0)
		{
			txt += ' and ' + children + ' child' + (children == 1 ? '' : 'ren');
		}

		// if this is a single trip
		if ($("input[name=travel_policyType]:checked").val() == 'S') {
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
			var days = meerkat.modules.travelDatepicker.getDateDifference();
			txt += "</span> for <span class='highlight'>"+days+" days</span>";
		} else {

			$summaryHeader.html('Your Annual Multi Trip (AMT) quote is based on');
			var blockClass = children > 1 ? 'sm-md-block' : 'sm-block';

			// build the destination string
			var regionTags = $('#destinationsfs').find('.selected-tag');
			var regionStr = '';
			if (regionTags.length === 1) {
				regionStr = regionTags.text();
			} else {
				for(var rs = 0; rs < regionTags.length; rs++) {
					regionStr += $(regionTags[rs]).text();
					if (rs == regionTags.length-1) {
						regionStr += '';
						continue;
					}
					if (regionTags.length > 1 && rs !== regionTags.length-2 ) {
						regionStr += ', ';
					} else {
						regionStr += ' & ';
					}
				}
			}

			var durationVal = $('#amtDurationsfs').find('.active').text().trim();
			var travelTxt = 'to ';

			if (regionTags.length > 1 && regionStr.indexOf('pacific') || regionSt.indexOf('united') || regionSt.indexOf('cook')) {
				travelTxt = 'to the ';
			} else if (regionStr === 'worldwide' || regionStr === 'wwExAmericas' || regionStr === 'asia' || regionStr === 'europe') {
				travelTxt = '';
				if (regionStr === 'wwExAmericas') {
					regionStr = 'Worldwide, excluding Americas';
				}
			}
			txt+="</span> travelling multiple times in one year "+travelTxt+"<span class='highlight'>"+regionStr+"</span> for a maximum single trip duration of <span class='highlight'>"+durationVal+".</span>" +
				 "\nWe have also inlcuded products that cover longer trips as they may be of greater value.";
		}

		if (meerkat.modules.tripType.exists()) {
			var triptypes = meerkat.modules.tripType.get();
			var copy = [];
			for(var i in triptypes) {
				if(_.has(triptypes, i)) {
					var type = triptypes[i];
					if(type.active) {
						copy.push(type.label);
					}
				}
			}
			txt+=". </span><em class=\"hidden-xs hidden-sm\"><br></em>Covered for <span class='highlight'>" + copy.join(", ");
		}

		$resultsSummaryPlaceholder.html(txt+'</span>').fadeIn();
	}

	function initSummaryText() {
		if (!initialised) {
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

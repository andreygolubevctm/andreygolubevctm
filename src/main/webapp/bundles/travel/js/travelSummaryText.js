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

	function buildTravelersString(adultsCount, childrenCount) {
		var travelersString = '';
		if (adultsCount < 3) {
			// adults
			travelersString += adultsCount + ' adult' + (adultsCount == 1 ? '' : 's');
		} else {
			travelersString += adults;
		}

		// children
		if (childrenCount > 0) {
			travelersString += ' and ' + childrenCount + ' child' + (childrenCount == 1 ? '' : 'ren');
		}
		return travelersString;
	}

	function buildRegionString(regionTags) {
		var regins='';
		for(var rs = 0; rs < regionTags.length; rs++) {
			regins += $(regionTags[rs]).text();
			if (rs == regionTags.length-1) {
				regins += '';
				continue;
			}
			if (regionTags.length > 1 && rs !== regionTags.length-2 ) {
				regins += ', ';
			} else {
				regins += ' & ';
			}
		}
		return regins;
	}

	function updateSummaryText() {
		// let it fire in all modes if in the event xs is displayed but a different orientation displays something greater
		// Build the summary text based on the entered information.
		var txt= '<span class="highlight">';
		var adults = $adults.val();
	 	var regionTags = $('#destinationsfs').find('.selected-tag');
		var children = $children.val();
		// duration calculation
		var days = meerkat.modules.travelDatepicker.getDateDifference();

		txt += buildTravelersString(adults, children);

		// if this is a single trip
		if ($("input[name=travel_policyType]:checked").val() == 'S') {
			// in case a user did an AMT quote and now wants a single trip quote
			$summaryHeader.html('Your quote is based on');
			txt +='</span> <span>travelling</span> <span class="md-block">to <span class="highlight">';

			// update the country text for single trip
			if (regionTags.length <=  10) {
				txt += buildRegionString(regionTags);
			} else {
				txt += "multiple destinations";
			}
			txt += "</span> for <span class='highlight'>"+days+" days</span>";
		} else {
			var regionStr = '';
			var durationVal = $('#amtDurationsfs').find('.active').text().trim();
			var travelTxt = 'to ';
			var is61Duration = durationVal.indexOf("61") > -1;
			var amtDurationSpan = "<span class='" + (is61Duration ? 'highlight' : 'amt-highlight') + "'>"+durationVal+".</span>";

			$summaryHeader.html('Your Annual Multi Trip (AMT) quote is based on');

			// build the destination string
			if (regionTags.length <=  10) {
				regionStr = buildRegionString(regionTags);
			} else {
				regionStr = "multiple destinations";
			}

			if (regionTags[0].textContent.toLowerCase().indexOf('pacific') !== -1 || regionTags[0].textContent.toLowerCase().indexOf('united') !== -1) {
				travelTxt = 'to the ';
			} else if (regionTags[0].textContent.toLowerCase().indexOf('worldwide') !== -1) {
				travelTxt = '';
			}

			if(!is61Duration) {
				amtDurationSpan = "<a href='javascript:void(0);' class='help-icon' data-content='helpid:645' data-toggle='popover'>" + amtDurationSpan + "</a>";
			}

			txt+= "</span> travelling multiple times in one year "+travelTxt+"<span class='highlight'>"+regionStr+"</span> for a maximum single trip duration of " + amtDurationSpan;
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
			txt+=". </span>Covered for <span class='highlight'>" + copy.join(", ");
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
			$summaryHeader = $('.resultsSummaryHeading');
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

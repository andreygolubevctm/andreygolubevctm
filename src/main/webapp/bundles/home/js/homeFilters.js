;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,

		events = {
			homeFilters: {
				CHANGED: 'HOME_FILTERS_CHANGED'
			}
		},
		moduleEvents = events.homeFilters,

		$component,
		$allDropDownToggles,
		$excessDropDownToggles,
		$freqDropDownToggles,
		$labels,
		$priceMode,
		$priceModeLink,
		$featuresMode,
		$featuresModeLink,
		$filterFrequency,
		$filterHomeExcess,
		$filterContentsExcess,
		$filterHomeExcessLabel,
		$filterContentsExcessLabel,
		$updateBtn,
		$cancelUpdateBtn,

		deviceStateXS = false,
		modalID = false,
		pageScrollingLockYScroll = false,
		currentValues = {
			display:		false,
			frequency:		false,
			homeExcess:		false,
			contentsExcess:	false
		},
		previousValues = {
			homeExcess:		false,
			contentsExcess:	false
		};

	//
	// Refresh filters from form/page
	//
	function updateFilters() {

		hideExcessLists();
		$priceMode.removeClass('active');
		$featuresMode.removeClass('active');
		var coverType = meerkat.modules.home.getCoverType();
		// Refresh price/features toggle buttons
		if (typeof Results.settings !== 'undefined' && Results.settings.hasOwnProperty('displayMode') === true) {
			switch (Results.getDisplayMode()) {
				case 'price':
					$priceMode.addClass('active');
					break;
				case 'features':
					$featuresMode.addClass('active');
					break;
			}

			meerkat.messaging.publish(meerkatEvents.resultsMobileDisplayModeToggle.DISPLAY_MODE_UPDATED);
		}

		// Refresh frequency
		var freq = $('#home_paymentType').val();
		if (typeof freq === 'undefined') {
			$filterFrequency.find('.dropdown-toggle span').text( $filterFrequency.find('.dropdown-menu a:first').text() );
		}
		else {
			$filterFrequency.find('.dropdown-toggle span').text( $filterFrequency.find('.dropdown-menu a[data-value="' + freq + '"]').text() );
		}

		// Refresh excess
		if (coverType == 'H' || coverType == 'HC'){
			var homeHomeExcess = $('#home_homeExcess').val(),
				homeBaseHomeExcess = $('#home_baseHomeExcess').val(),
				homeExcess = !_.isEmpty(homeHomeExcess) ? homeHomeExcess : homeBaseHomeExcess;

			$filterHomeExcess.find('.dropdown-toggle span').text( $filterHomeExcess.find('.dropdown-menu a[data-value="' + homeExcess + '"]').text() );
		}
		if (coverType == 'C' || coverType == 'HC'){
			var homeContentsExcess = $('#home_contentsExcess').val(),
				homeBaseContentsExcess = $('#home_baseContentsExcess').val(),
				contentsExcess = !_.isEmpty(homeContentsExcess) ? homeContentsExcess : homeBaseContentsExcess;

			$filterContentsExcess.find('.dropdown-toggle span').text( $filterContentsExcess.find('.dropdown-menu a[data-value="' + contentsExcess + '"]').text() );
		}
	}
	function hideExcessLists () {
		var coverType = meerkat.modules.home.getCoverType();
		switch (coverType){
			case 'H':
				$filterHomeExcess.add($filterHomeExcessLabel).show();
				$filterContentsExcess.add($filterContentsExcessLabel).hide();
				return;
			case 'C':
				$filterHomeExcess.add($filterHomeExcessLabel).hide();
				$filterContentsExcess.add($filterContentsExcessLabel).show();
				return;
			case 'HC':
				$filterHomeExcess.add($filterHomeExcessLabel).add($filterContentsExcess).add($filterContentsExcessLabel).add('.excess-update').show();
				return;
		}
	}
	function toggleXSFilters () {
		var coverType = meerkat.modules.home.getCoverType();
		var homeXSFilterRow = $("#xsFilterBarHomeExcessRow");
		var contentsXSFilterRow = $("#xsFilterBarContentsExcessRow");
		switch (coverType){
			case 'H':
				homeXSFilterRow.show();
				contentsXSFilterRow.hide();
				return;
			case 'C':
				homeXSFilterRow.hide();
				contentsXSFilterRow.show();
				return;
			case 'HC':
				homeXSFilterRow.add(contentsXSFilterRow).show();
				return;
		}
	}

	function setHomeResultsFilter() {
		// This will show/hide products that are either monthly only or annual only.
		// E.g The Ensurance products.
		if (currentValues.frequency == 'monthly') {
			Results.filterBy('price.monthly', "value", { "notEquals": null });
			Results.unfilterBy('price.annual', "value", true);
		} else if (currentValues.frequency == 'annual') {
			Results.filterBy('price.annual', "value", { "notEquals": null });
			Results.unfilterBy('price.monthly', "value", true);
		} else {
			// If something goes weird with the current frequency then remove the limitation on results and show all products.
			Results.unfilterBy('price.annual', "value", true);
			Results.unfilterBy('price.monthly', "value", true);
		}
	}

	//
	// Handle when any of the filter bar dropdown menu options are clicked
	//
	function handleDropdownOption(event) {
		event.preventDefault();
		var $menuOption = $(event.target);
		var $dropdown = $menuOption.parents('.dropdown');
		var value = $menuOption.attr('data-value');
		$dropdown.find('.dropdown-toggle span').text( $menuOption.text() );
		$menuOption.parent().siblings().removeClass('active');
		$menuOption.parent().addClass('active');
		if ($dropdown.hasClass('filter-frequency')) {
			if(value !== currentValues.frequency) {
				currentValues.frequency = value;
				$('#home_paymentType').val(currentValues.frequency);
				setHomeResultsFilter();
				Results.setFrequency(value);
				meerkat.messaging.publish(moduleEvents.CHANGED);
				meerkat.modules.paymentFrequencyButtons.set(value);
			}
		}

		if ($dropdown.hasClass('filter-excess')) {
			if ($dropdown.hasClass('homeExcess')) {
				if(value !== currentValues.homeExcess) {
					previousValues.homeExcess = currentValues.homeExcess;

					currentValues.homeExcess = value;
					$('#home_homeExcess').val(value);

					toggleUpdate(false);
				}
			}
			if ($dropdown.hasClass('contentsExcess')) {
				if (value !== currentValues.contentsExcess) {
					previousValues.contentsExcess = currentValues.contentsExcess;

					currentValues.contentsExcess = value;
					$('#home_contentsExcess').val(value);

					toggleUpdate(false);
				}
			}
		}
	}

	function toggleUpdate(hide) {
		$updateBtn.toggleClass('hidden', hide);
		$cancelUpdateBtn.toggleClass('hidden', hide);
	}

	function storeCurrentValues() {

		currentValues = {
			display:		Results.getDisplayMode(),
			frequency:		$('#home_paymentType').val(),
			homeExcess:		$('#home_homeExcess').val() || currentValues.homeExcess,
			contentsExcess:	$('#home_contentsExcess').val() || currentValues.contentsExcess
		};
	}
	function setDefaultExcess() {
		currentValues = {
			homeExcess:		$('#home_baseHomeExcess').val(),
			contentsExcess:	$('#home_baseContentsExcess').val()
		};
	}
	function preselectDropdowns() {
		$filterFrequency.find('li.active').removeClass("active");
		$filterFrequency.find('a[data-value="' + currentValues.frequency + '"]').each(function(){
			$(this).parent().addClass("active");
		});

		$filterHomeExcess.find('li.active').removeClass("active");
		$filterContentsExcess.find('li.active').removeClass("active");
		if(!_.isEmpty(currentValues.homeExcess)) {
			$filterHomeExcess.find('a[data-value="' + currentValues.homeExcess + '"]').each(function(){
				$(this).parent().addClass("active");
			});
		}

		if(!_.isEmpty(currentValues.contentsExcess)) {
			$filterContentsExcess.find('a[data-value="' + currentValues.contentsExcess + '"]').each(function(){
				$(this).parent().addClass("active");
			});
		}
	}

	function hide() {
		$component.slideUp(200, function hideDone() {
			$component.addClass('hidden');
		});

		$labels.slideUp(200, function hideLabelDone() {
			$labels.addClass('hidden');
		});
	}

	function show() {
		$component.removeClass('hidden').hide().slideDown(200);
		$labels.removeClass('hidden').hide().slideDown(200);

		storeCurrentValues();
		preselectDropdowns();

		meerkat.modules.paymentFrequencyButtons.set(currentValues.frequency);
	}

	function disable() {
		$allDropDownToggles
			.add([
				$priceMode[0],
				$priceModeLink[0],
				$featuresMode[0],
				$featuresModeLink[0]
			]).addClass('disabled');
	}

	function enable() {
		if (meerkat.modules.compare.isCompareOpen() === false) {
			$excessDropDownToggles
				.add([
					$priceMode[0],
					$priceModeLink[0],
					$featuresMode[0],
					$featuresModeLink[0]
				]).removeClass('disabled');
		}
		$freqDropDownToggles.removeClass('disabled');
	}

	function eventSubscriptions() {

		// Lock Y scrolling if page is scrolling. Events -> (Chrome, Firefox, IE)
		$(document.body).on('mousewheel DOMMouseScroll onmousewheel', function(e) {
			if (pageScrollingLockYScroll) {
				e.preventDefault();
				e.stopPropagation();
			}
		});

		// Disable filters while results are in progress
		$(document).on('resultsFetchStart pagination.scrolling.start', function onResultsFetchStart() {
			pageScrollingLockYScroll = true;
			disable();
			toggleUpdate(true);
		});

		$(document).on('resultsFetchFinish pagination.scrolling.end', function onResultsFetchStart() {
			pageScrollingLockYScroll = false;
			enable();
		});
		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, enable);

		// Display mode toggle
		$priceMode.on('click', function filterPrice(event) {
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;

			$featuresMode.removeClass('active');
			$priceMode.addClass('active');

			meerkat.modules.homeResults.switchToPriceMode(true);

			meerkat.modules.session.poke();
		});

		$featuresMode.on('click', function filterFeatures(event) {
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;

			$priceMode.removeClass('active');
			$featuresMode.addClass('active');

			meerkat.modules.homeResults.switchToFeaturesMode(true);

			meerkat.modules.session.poke();
		});

		// Dropdown options
		$component.on('click', '.dropdown-menu a', handleDropdownOption);


		$updateBtn.on('click', function updateResults() {
			meerkat.messaging.publish(moduleEvents.CHANGED, {contentsExcess:currentValues.contentsExcess, homeExcess:currentValues.homeExcess});
			toggleUpdate(true);
		});

		$cancelUpdateBtn.on('click', function cancelUpdate() {
			$filterHomeExcess.find('li.active').removeClass("active");
			if(!_.isEmpty(previousValues.homeExcess)) {
				var $dropdownHome = $('.dropdown.filter-excess.homeExcess');

				currentValues.homeExcess = previousValues.homeExcess;

				$filterHomeExcess.find('a[data-value="' + previousValues.homeExcess + '"]').each(function(){
					$dropdownHome.find('.dropdown-toggle span').text($(this).text());
					$(this).parent().addClass("active");
				});
			}

			$filterContentsExcess.find('li.active').removeClass("active");
			if(!_.isEmpty(previousValues.contentsExcess)) {
				var $dropdownContents = $('.dropdown.filter-excess.contentsExcess');

				currentValues.contentsExcess = previousValues.contentsExcess;

				$filterContentsExcess.find('a[data-value="' + previousValues.contentsExcess + '"]').each(function(){
					$dropdownContents.find('.dropdown-toggle span').text($(this).text());
					$(this).parent().addClass("active");
				});
			}
			toggleUpdate(true);
		});

		meerkat.messaging.subscribe(meerkatEvents.mobileNavButtons.REFINE_RESULTS_TOGGLED, function onRefineResultsToggled() {
			onRequestModal();
		});

		meerkat.messaging.subscribe(meerkatEvents.paymentFrequencyButtons.CHANGED, function() {
			$('#home_paymentType').val(Results.getFrequency());
			updateFilters();
		});
	}

	function renderModal() {

		var templateAccessories = _.template($('#home-xsFilterBar-template').html());

		var homeExcess = $('#home_homeExcess').val();
		var contentsExcess = $('#home_contentsExcess').val();

		var htmlContent = templateAccessories({
				homeStartingValue: _.isEmpty(homeExcess) ? $('#home_baseHomeExcess').val() : homeExcess,
				contentsStartingValue: _.isEmpty(contentsExcess) ? $('#home_baseContentsExcess').val() : contentsExcess
		});
		modalID = meerkat.modules.dialogs.show({
			title : $(this).attr('title'),
			htmlContent : htmlContent,
			hashId : 'xsFilterBar',
			rightBtn: {
				label: 'UPDATE RESULTS',
				className: 'btn-sm btn-save btn-update-results-modal',
				callback: saveModalChanges
			},
			closeOnHashChange: true,
			onOpen : onModalOpen
		});

		return false;
	}

	function onModalOpen(modal) {

		if (typeof Results.settings !== 'undefined' && Results.settings.hasOwnProperty('displayMode') === true) {
			$('#xsFilterBarSortRow input:checked').prop('checked', false);
			$('#xsFilterBarSortRow #xsFilterBar_sort_' + Results.getDisplayMode()).prop('checked', true).change();
		}

		$('#xsFilterBarFreqRow input:checked').prop('checked', false);
		$('#xsFilterBarFreqRow #xsFilterBar_freq_' + $('#home_paymentType').val()).prop('checked', true).change();
		$('#xsFilterBar_homeExcess').val(currentValues.homeExcess);
		$('#xsFilterBar_contentsexcess').val(currentValues.contentsExcess);

		meerkat.modules.dataAnalyticsHelper.add($('#' + modal).find('.btn-update-results-modal'),'nav button');

		toggleXSFilters();
	}

	function saveModalChanges() {
		var $homeExcess = $('#home_homeExcess');
		var $contentsExcess = $('#home_contentsExcess');

		var revised = {
				display: $('#xsFilterBarSortRow input:checked').val(),
				homeExcess : $('#xsFilterBarHomeExcessRow select').val(),
				contentsExcess : $('#xsFilterBarContentsExcessRow select').val()
		};

		if(Number(revised.homeExcess) === 0) {
			revised.homeExcess = '';
		}
		if(Number(revised.contentsExcess) === 0) {
			revised.contentsExcess = '';
		}

		$homeExcess.val( revised.homeExcess );
		$contentsExcess.val( revised.contentsExcess );

		if (revised.display !== currentValues.display) {
			if(revised.display === 'features') {
				meerkat.modules.homeResults.switchToFeaturesMode(true);
			} else if(revised.display === 'price') {
				meerkat.modules.homeResults.switchToPriceMode(true);
			}
		}

		meerkat.modules.dialogs.close(modalID);
		meerkat.modules.navMenu.close();

		if( currentValues.homeExcess !== revised.homeExcess ) {
			currentValues.homeExcess = revised.homeExcess;
			meerkat.messaging.publish(moduleEvents.CHANGED, {homeExcess:revised.homeExcess});
		}
		if( currentValues.contentsExcess !== revised.contentsExcess ) {
			currentValues.contentsExcess = revised.contentsExcess;
			meerkat.messaging.publish(moduleEvents.CHANGED, {contentsExcess:revised.contentsExcess});
		}

		updateFilters();
	}

	function onRequestModal() {
		var is_active = !$('#navbar-filter').hasClass('hidden');
		if(is_active && deviceStateXS === true) {
			storeCurrentValues();
			renderModal();
		}
	}

	function setCurrentDeviceState(data) {
		if(_.isUndefined(data)) {
			deviceStateXS = meerkat.modules.deviceMediaState.get() === "xs";
		} else {
			deviceStateXS = data.isXS === true;
		}

		if(deviceStateXS === false) {
			if(meerkat.modules.dialogs.isDialogOpen(modalID)) {
				meerkat.modules.dialogs.close(modalID);
			}
		}
	}

	function initHomeFilters() {
		log("[HomeFilters] Initialised");
		$(document).ready(function onReady() {

			// Collect options from the page
			$component = $('#navbar-filter');

			if (!$component.length) return;

			$allDropDownToggles = $component.find('li.dropdown, .dropdown-toggle');
			$excessDropDownToggles = $component.find('li.dropdown.filter-excess, .filter-excess .dropdown-toggle');
			$freqDropDownToggles = $component.find('li.dropdown.filter-frequency, .filter-frequency .dropdown-toggle');
			$labels = $('#navbar-filter-labels');
			$priceMode = $component.find('.filter-pricemode');
			$priceModeLink = $priceMode.find('a');
			$featuresMode = $component.find('.filter-featuresmode');
			$featuresModeLink = $featuresMode.find('a');
			$filterFrequency = $component.find('.filter-frequency');
			$filterHomeExcess = $component.find('.filter-excess.homeExcess');
			$filterContentsExcess = $component.find('.filter-excess.contentsExcess');
			$filterHomeExcessLabel = $labels.find('.filter-home-excess-label');
			$filterContentsExcessLabel = $labels.find('.filter-contents-excess-label');
			$updateBtn = $component.find('.updateFilters');
			$cancelUpdateBtn = $labels.find('.filter-cancel-label a');

			setDefaultExcess();

			eventSubscriptions();

			var $filterMenu;

			$filterMenu = $filterHomeExcess.find('.dropdown-menu');
			$('#filter_homeExcessOptions option').each(function() {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '"' + meerkat.modules.dataAnalyticsHelper.get('Home Excess ' + this.value,'"') + '>' + this.text + '</a></li>');
			});

			$filterMenu = $filterContentsExcess.find('.dropdown-menu');
			$('#filter_contentsExcessOptions option').each(function() {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '"' + meerkat.modules.dataAnalyticsHelper.get('Contents Excess ' + this.value,'"') + '>' + this.text + '</a></li>');
			});

			$filterMenu = $filterFrequency.find('.dropdown-menu');
			$('#filter_paymentType option').each(function() {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '"' + meerkat.modules.dataAnalyticsHelper.get('Payment Freq ' + this.value,'"') + '>' + this.text + '</a></li>');
			});

			// Add analytics to individual option buttons in mobile view
			$('.resultsContainer .payment-frequency-buttons').find('label.btn').each(function(){
				var $this = $(this);
				var freq = $this.find('input:first').val();
				$this.attr('data-analytics','Payment Freq ' + freq);
			});

			meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, _.bind(setCurrentDeviceState, this, {isXS:true}));
			meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, _.bind(setCurrentDeviceState, this, {isXS:false}));
			toggleUpdate(true);

			setCurrentDeviceState();
		});
	}



	meerkat.modules.register('homeFilters', {
		initHomeFilters: initHomeFilters,
		events: events,
		updateFilters: updateFilters,
		hide: hide,
		show: show,
		disable: disable,
		enable: enable,
		onRequestModal: onRequestModal,
		toggleXSFilters : toggleXSFilters,
		setHomeResultsFilter: setHomeResultsFilter
	});

})(jQuery);
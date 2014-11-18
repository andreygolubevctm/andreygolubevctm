;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			homeFilters: {
				CHANGED: 'HOME_FILTERS_CHANGED'
			}
		},
		moduleEvents = events.homeFilters;

	var $component;
	var $priceMode;
	var $featuresMode;
	var $filterFrequency,
		$filterHomeExcess,
		$filterContentsExcess,
		$filterHomeExcessLabel,
		$filterContentsExcessLabel;

	var deviceStateXS = false;
	var modalID = false;

	var currentValues = {
			display:		false,
			frequency:		false,
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
			if (typeof currentValues.homeExcess === 'undefined') {
				$filterHomeExcess.find('.dropdown-toggle span').text( $filterHomeExcess.find('.dropdown-menu a:first').text() );
			}
			else {
				$filterHomeExcess.find('.dropdown-toggle span').text( $filterHomeExcess.find('.dropdown-menu a[data-value="' + currentValues.homeExcess + '"]').text() );
			}
		}
		if (coverType == 'C' || coverType == 'HC'){
			if (typeof currentValues.contentsExcess === 'undefined') {
				$filterContentsExcess.find('.dropdown-toggle span').text( $filterContentsExcess.find('.dropdown-menu a:first').text() );
			}
			else {
				$filterContentsExcess.find('.dropdown-toggle span').text( $filterContentsExcess.find('.dropdown-menu a[data-value="' + currentValues.contentsExcess + '"]').text() );
			}
		}
	}
	function hideExcessLists () {
		var coverType = meerkat.modules.home.getCoverType();
		switch (coverType){
			case 'H':
				$filterHomeExcess.add($filterHomeExcessLabel).show();
				$filterContentsExcess.add($filterContentsExcessLabel).add('.excess-update').hide();
				$filterHomeExcess.find('li a').addClass('updateExcess');
				return;
			case 'C':
				$filterHomeExcess.add($filterHomeExcessLabel).add('.excess-update').hide();
				$filterContentsExcess.add($filterContentsExcessLabel).show();
				$filterContentsExcess.find('li a').addClass('updateExcess');
				return;
			case 'HC':
				$filterHomeExcess.add($filterHomeExcessLabel).add($filterContentsExcess).add($filterContentsExcessLabel).add('.excess-update').show();
				$filterContentsExcess.find('li a').removeClass('updateExcess');
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
	//
	// Handle when any of the filter bar dropdown menu options are clicked
	//
	function handleDropdownOption(event) {
		event.preventDefault();
		var $menuOption = $(event.target);
		if ($menuOption.hasClass('updateExcess')){
			updateExcessValue(event);
			updateFilters();
		}
		else {
			var $dropdown = $menuOption.parents('.dropdown');
			var value = $menuOption.attr('data-value');
			$dropdown.find('.dropdown-toggle span').text( $menuOption.text() );
			$menuOption.parent().siblings().removeClass('active');
			$menuOption.parent().addClass('active');
			if ($dropdown.hasClass('filter-frequency')) {
				if(value !== currentValues.frequency) {
					currentValues.frequency = value;
					$('#home_paymentType').val(currentValues.frequency);
					Results.setFrequency(value);

					meerkat.messaging.publish(moduleEvents.CHANGED);
				}
			}
		}
	}
	function updateExcessValue(event) {
		var coverType = meerkat.modules.home.getCoverType();
		event.preventDefault();
		var $menuOption = $(event.target);
		var homeValue, contentsValue;
		if($menuOption.text() === 'update') { // home and contents
			homeValue = $('.homeExcess .dropdown-toggle span').text().replace('$', '');
			contentsValue = $('.contentsExcess .dropdown-toggle span').text().replace('$', '');
		} else { // home only or contents only
			homeValue = $menuOption.text().replace('$', '');
			contentsValue = $menuOption.text().replace('$', '');
		}
		if (homeValue !== currentValues.homeExcess && (coverType == 'H' || coverType == 'HC')) {
			currentValues.homeExcess = homeValue;
			$('#home_homeExcess').val(homeValue);
		}
		if (contentsValue !== currentValues.contentsExcess && (coverType == 'C' || coverType == 'HC')) {
			currentValues.contentsExcess = contentsValue;
			$('#home_contentsExcess').val(contentsValue);
		}
		if(coverType == 'H') {
			meerkat.messaging.publish(moduleEvents.CHANGED, {homeExcess:homeValue});
		}
		else if(coverType == 'C') {
			meerkat.messaging.publish(moduleEvents.CHANGED, {contentsExcess:contentsValue});
		}
		else {
			meerkat.messaging.publish(moduleEvents.CHANGED, {contentsExcess:contentsValue, homeExcess:homeValue});
		}

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
		$filterFrequency.find('a[data-value=' + currentValues.frequency + ']').each(function(){
			$(this).parent().addClass("active");
		});

		$filterHomeExcess.find('li.active').removeClass("active");
		$filterContentsExcess.find('li.active').removeClass("active");
		if(!_.isEmpty(currentValues.homeExcess)) {
			$filterHomeExcess.find('a[data-value=' + currentValues.homeExcess + ']').each(function(){
				$(this).parent().addClass("active");
			});
		}
		if(!_.isEmpty(currentValues.contentsExcess)) {
			$filterContentsExcess.find('a[data-value=' + currentValues.contentsExcess + ']').each(function(){
				$(this).parent().addClass("active");
			});
		}
	}

	function hide() {
		$component.slideUp(200, function hideDone() {
			$component.addClass('hidden');
		});
	}

	function show() {
		$component.removeClass('hidden').hide().slideDown(200);
		storeCurrentValues();
		preselectDropdowns();
	}

	function disable() {
		$component.find('li.dropdown, .dropdown-toggle').addClass('disabled');
		$priceMode.addClass('disabled').find('a').addClass('disabled');
		$featuresMode.addClass('disabled').find('a').addClass('disabled');
		$('.slide-feature-filters').find('a').addClass('disabled').addClass('inactive');
		$('.excess-update').find('a').addClass('disabled').addClass('inactive');
	}

	function enable() {
		if (meerkat.modules.compare.isCompareOpen() === false){
			$component.find('li.dropdown.filter-excess, .filter-excess .dropdown-toggle').removeClass('disabled');
			$priceMode.removeClass('disabled').find('a').removeClass('disabled');
			$featuresMode.removeClass('disabled').find('a').removeClass('disabled');
			$('.slide-feature-filters').find('a').removeClass('inactive').removeClass('disabled');
			$('.excess-update').find('a').removeClass('inactive').removeClass('disabled');
		}
		$component.find('li.dropdown.filter-frequency, .filter-frequency .dropdown-toggle').removeClass('disabled');
	}

	function eventSubscriptions() {
		// Disable filters while results are in progress

		$(document).on('resultsFetchStart pagination.scrolling.start', function onResultsFetchStart() {
			disable();
		});

		$(document).on('resultsFetchFinish pagination.scrolling.end', function onResultsFetchStart() {
			enable();
		});
		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, enable);

		// Display mode toggle

		$priceMode.on('click', function filterPrice(event) {
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;

			meerkat.modules.homeResults.switchToPriceMode(true);
			updateFilters();

			meerkat.modules.session.poke();
		});

		$featuresMode.on('click', function filterFeatures(event) {
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;

			meerkat.modules.homeResults.switchToFeaturesMode(true);
			updateFilters();

			meerkat.modules.session.poke();
		});

		// Dropdown options

		$component.on('click', '.dropdown-menu a, .excess-update a', handleDropdownOption);
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
				label: 'Save Changes',
				className: 'btn-sm btn-save',
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
		$('input[name=xsFilterBar_homeExcess], input[name=xsFilterBar_contentsexcess]', $('#'+modal)).prop('checked', false);
		$('#xsFilterBar_homeExcess_' + currentValues.homeExcess, $('#'+modal)).prop('checked', true).change();
		$('#xsFilterBar_contentsexcess_' + currentValues.contentsExcess, $('#'+modal)).prop('checked', true).change();

		toggleXSFilters();
	}

	function saveModalChanges() {

		var $freq = $('#home_paymentType');
		var $homeExcess = $('#home_homeExcess');
		var $contentsExcess = $('#home_contentsExcess');

		var revised = {
				display: $('#xsFilterBarSortRow input:checked').val(),
				freq : $('#xsFilterBarFreqRow input:checked').val(),
				homeExcess : $('#xsFilterBarHomeExcessRow input:checked').val(),
				contentsExcess : $('#xsFilterBarContentsExcessRow input:checked').val()
		};

		if(Number(revised.homeExcess) === 0) {
			revised.homeExcess = '';
		}
		if(Number(revised.contentsExcess) === 0) {
			revised.contentsExcess = '';
		}

		$freq.val( revised.freq );
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

		if( currentValues.frequency !== revised.freq ) {
			currentValues.frequency = revised.freq;
			Results.setFrequency(currentValues.frequency);
			meerkat.messaging.publish(moduleEvents.CHANGED);
		}

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

			$priceMode = $component.find('.filter-pricemode');
			$featuresMode = $component.find('.filter-featuresmode');
			$filterFrequency = $component.find('.filter-frequency');
			$filterHomeExcess = $component.find('.filter-excess.homeExcess');
			$filterContentsExcess = $component.find('.filter-excess.contentsExcess');
			$filterHomeExcessLabel = $component.find('.filter-label.homeExcessLabel');
			$filterContentsExcessLabel = $component.find('.filter-label.contentsExcessLabel');
			setDefaultExcess();

			eventSubscriptions();

			var $filterMenu;

			$filterMenu = $filterHomeExcess.find('.dropdown-menu');
			$('#filter_homeExcessOptions option').each(function() {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
			});

			$filterMenu = $filterContentsExcess.find('.dropdown-menu');
			$('#filter_contentsExcessOptions option').each(function() {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
			});

			$filterMenu = $filterFrequency.find('.dropdown-menu');
			$('#filter_paymentType option').each(function() {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
			});

			$('#navbar-main .slide-feature-filters a').on('click', function(e) {
				e.preventDefault();
				if(!$(this).hasClass('disabled')) {
					onRequestModal();
				}
			});

			meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, _.bind(setCurrentDeviceState, this, {isXS:true}));
			meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, _.bind(setCurrentDeviceState, this, {isXS:false}));

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
		toggleXSFilters : toggleXSFilters
	});

})(jQuery);
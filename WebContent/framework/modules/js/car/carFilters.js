;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			carFilters: {
				CHANGED: 'CAR_FILTERS_CHANGED'
			}
		},
		moduleEvents = events.carFilters;

	var $component;
	var $priceMode;
	var $featuresMode;
	var $filterFrequency,
		$filterExcess;

	var deviceStateXS = false;
	var modalID = false;

	var currentValues = {
			display:	false,
			frequency:	false,
			excess:		false
	};

	//
	// Refresh filters from form/page
	//
	function updateFilters() {

		$priceMode.removeClass('active');
		$featuresMode.removeClass('active');

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
		var freq = $('#quote_paymentType').val();
		if (typeof freq === 'undefined') {
			$filterFrequency.find('.dropdown-toggle span').text( $filterFrequency.find('.dropdown-menu a:first').text() );
		}
		else {
			$filterFrequency.find('.dropdown-toggle span').text( $filterFrequency.find('.dropdown-menu a[data-value="' + freq + '"]').text() );
		}

		// Refresh excess
		var excess = $('#quote_excess').val();
		if (typeof excess === 'undefined') {
			$filterExcess.find('.dropdown-toggle span').text( $filterExcess.find('.dropdown-menu a:first').text() );
		}
		else {
			$filterExcess.find('.dropdown-toggle span').text( $filterExcess.find('.dropdown-menu a[data-value="' + excess + '"]').text() );
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
				$('#quote_paymentType').val(currentValues.frequency);
				Results.setFrequency(value);

				meerkat.messaging.publish(moduleEvents.CHANGED);
			}
		}
		else if ($dropdown.hasClass('filter-excess')) {
			if(value !== currentValues.excess) {
				currentValues.excess = value;
				$('#quote_excess').val(value);

				meerkat.messaging.publish(moduleEvents.CHANGED, {excess:value});
			}
		}
	}

	function storeCurrentValues() {

		currentValues = {
			display:	Results.getDisplayMode(),
			frequency:	$('#quote_paymentType').val(),
			excess:		$('#quote_excess').val()
		};
	}

	function preselectDropdowns() {

		$filterFrequency.find('li.active').removeClass("active");
		$filterFrequency.find('a[data-value=' + currentValues.frequency + ']').each(function(){
			$(this).parent().addClass("active");
		});

		$filterExcess.find('li.active').removeClass("active");
		if(!_.isEmpty(currentValues.excess)) {
			$filterExcess.find('a[data-value=' + currentValues.excess + ']').each(function(){
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
		$priceMode.addClass('disabled');
		$priceMode.find('a').addClass('disabled');
		$featuresMode.addClass('disabled');
		$featuresMode.find('a').addClass('disabled');
		$('.slide-feature-filters').find('a').addClass('disabled').addClass('inactive');
	}

	function enable() {
		$component.find('li.dropdown, .dropdown-toggle').removeClass('disabled');
		$priceMode.removeClass('disabled');
		$priceMode.find('a').removeClass('disabled');
		$featuresMode.removeClass('disabled');
		$featuresMode.find('a').removeClass('disabled');
		$('.slide-feature-filters').find('a').removeClass('inactive').removeClass('disabled');
	}

	function eventSubscriptions() {
		// Disable filters while results are in progress

		$(document).on('resultsFetchStart', function onResultsFetchStart() {
			disable();
		});
		$(document).on('pagination.scrolling.start', function onPaginationStart() {
			disable();
		});

		$(document).on('resultsFetchFinish', function onResultsFetchStart() {
			enable();
		});
		$(document).on('pagination.scrolling.end', function onPaginationStart() {
			enable();
		});

		// Display mode toggle

		$priceMode.on('click', function filterPrice(event) {
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;

			meerkat.modules.carResults.switchToPriceMode(true);
			updateFilters();

			meerkat.modules.session.poke();
		});

		$featuresMode.on('click', function filterFeatures(event) {
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;

			meerkat.modules.carResults.switchToFeaturesMode(true);
			updateFilters();

			meerkat.modules.session.poke();
		});

		// Dropdown options

		$component.on('click', '.dropdown-menu a', handleDropdownOption);
	}

	function renderModal() {

		var templateAccessories = _.template($('#car-xsFilterBar-template').html());

		var excess = $('#quote_excess').val();

		var htmlContent = templateAccessories({
				startingValue: _.isEmpty(excess) ? 0 : excess
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

	function onModalOpen() {

		if (typeof Results.settings !== 'undefined' && Results.settings.hasOwnProperty('displayMode') === true) {
			$('#xsFilterBarSortRow input:checked').prop('checked', false);
			$('#xsFilterBarSortRow #xsFilterBar_sort_' + Results.getDisplayMode()).prop('checked', true).change();
		}

		$('#xsFilterBarFreqRow input:checked').prop('checked', false);
		$('#xsFilterBarFreqRow #xsFilterBar_freq_' + $('#quote_paymentType').val()).prop('checked', true).change();

		try{
			meerkat.modules.sliders.init();
		}catch(e){}
	}

	function saveModalChanges() {

		var $freq = $('#quote_paymentType');
		var $excess = $('#quote_excess');

		var revised = {
				display: $('#xsFilterBarSortRow input:checked').val(),
				freq : $('#xsFilterBarFreqRow input:checked').val(),
				excess : $('#xsFilterBarExcessRow input[name=xsFilterBar_excess]').val()
		};

		if(Number(revised.excess) === 0) {
			revised.excess = '';
		}

		$freq.val( revised.freq );
		$excess.val( revised.excess );

		if (revised.display !== currentValues.display) {
			if(revised.display === 'features') {
				meerkat.modules.carResults.switchToFeaturesMode(true);
			} else if(revised.display === 'price') {
				meerkat.modules.carResults.switchToPriceMode(true);
			}
		}

		meerkat.modules.dialogs.close(modalID);
		meerkat.modules.navMenu.close();

		updateFilters();

		if( currentValues.frequency !== revised.freq ) {
			currentValues.frequency = revised.freq;
			Results.setFrequency(currentValues.frequency);
			meerkat.messaging.publish(moduleEvents.CHANGED);
		}

		if( currentValues.excess !== revised.excess ) {
			currentValues.excess = revised.excess;
			meerkat.messaging.publish(moduleEvents.CHANGED, {excess:revised.excess});
		}
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

	function init() {
		$component = $('#navbar-filter');
		if ($component.length === 0) return;

		$priceMode = $component.find('.filter-pricemode');
		$featuresMode = $component.find('.filter-featuresmode');
		$filterFrequency = $component.find('.filter-frequency');
		$filterExcess = $component.find('.filter-excess');

		eventSubscriptions();

		$(document).ready(function onReady() {

			// Collect options from the page

			var $filterMenu;

			$filterMenu = $filterExcess.find('.dropdown-menu');
			$('#filter_excessOptions option').each(function() {
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



	meerkat.modules.register('carFilters', {
		init: init,
		events: events,
		updateFilters: updateFilters,
		hide: hide,
		show: show,
		disable: disable,
		enable: enable,
		onRequestModal: onRequestModal
	});

})(jQuery);
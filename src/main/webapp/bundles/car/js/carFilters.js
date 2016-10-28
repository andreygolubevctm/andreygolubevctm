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

	var initialised = false;
	var $component;
	var $priceMode;
	var $featuresMode;
	var $filterFrequency,
		$filterExcess;

	var $labels,
		$filterCoverType,
		$updateBtn,
		$cancelUpdateBtn;

	var deviceStateXS = false;
	var modalID = false;
	var pageScrollingLockYScroll = false;

	var currentValues = {
			display:	false,
			frequency:	false,
			excess:		false
	};

	var previousValues = {
		excess: false
	};

	var updateBtnShown = false;

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

			meerkat.messaging.publish(meerkatEvents.resultsMobileDisplayModeToggle.DISPLAY_MODE_UPDATED);
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
		var excess = $('#quote_excess').val() ? $('#quote_excess').val() : $('#quote_baseExcess').val();
		$filterExcess.find('.dropdown-toggle span').text( $filterExcess.find('.dropdown-menu a[data-value="' + excess + '"]').text() );
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

				meerkat.modules.paymentFrequencyButtons.set(value);
			}
		}
		else if ($dropdown.hasClass('filter-excess')) {
			previousValues.excess = currentValues.excess;

			if(value !== currentValues.excess) {
				currentValues.excess = value;
				$('#quote_excess').val(value);

				toggleUpdate(false);
			}
		}
	}

	function toggleUpdate(hide) {
		$updateBtn.toggleClass('hidden', hide);
		$cancelUpdateBtn.toggleClass('hidden', hide);
		updateBtnShown = !hide;
	}

	function storeCurrentValues() {

		currentValues = {
			display:	Results.getDisplayMode(),
			frequency:	$('#quote_paymentType').val(),
			excess:		$('#quote_excess').val() ? $('#quote_excess').val() : $('#quote_baseExcess').val()
		};
	}

	function preselectDropdowns() {

		$filterFrequency.find('li.active').removeClass("active");
		$filterFrequency.find('a[data-value="' + currentValues.frequency + '"]').each(function(){
			$(this).parent().addClass("active");
		});

		$filterExcess.find('li.active').removeClass("active");
        $filterExcess.find('a[data-value="' + currentValues.excess + '"]').each(function(){
            $(this).parent().addClass("active");
        });
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
		$component.find('li.dropdown, .dropdown-toggle').addClass('disabled');
		$priceMode.addClass('disabled');
		$priceMode.find('a').addClass('disabled');
		$featuresMode.addClass('disabled');
		$featuresMode.find('a').addClass('disabled');
		$('.slide-feature-filters').find('a').addClass('disabled').addClass('inactive');
	}

	function enable() {
		if (meerkat.modules.compare.isCompareOpen() === false) {
			$component.find('li.dropdown.filter-excess, .filter-excess .dropdown-toggle, ' +
				'li.dropdown.filter-cover-type, .filter-cover-type .dropdown-toggle').removeClass('disabled');
			$priceMode.removeClass('disabled');
			$priceMode.find('a').removeClass('disabled');
			$featuresMode.removeClass('disabled');
			$featuresMode.find('a').removeClass('disabled');
			$('.slide-feature-filters').find('a').removeClass('inactive').removeClass('disabled');

			// Temporarily make Type of Cover disabled
			// Remove line below only once other options are introduced, also update the styles in layout.less
			$('.dropdown.filter-cover-type, .filter-cover-type .dropdown-toggle').addClass('disabled');
		}
		$component.find('li.dropdown.filter-frequency, .filter-frequency .dropdown-toggle').removeClass('disabled');
	}

	function eventSubscriptions() {

		// Disable filters while results are in progress
		$(document).on('resultsFetchStart', function onResultsFetchStart() {
			disable();
		});

		$(document).on('pagination.scrolling.start', function onPaginationStart() {
			pageScrollingLockYScroll = true;
			disable();
		});

		$(document).on('resultsFetchFinish', function onResultsFetchFinish() {
			enable();
		});

		$(document).on('pagination.scrolling.end', function onPaginationEnd() {
			pageScrollingLockYScroll = false;
			enable();
		});

		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, enable);

		// Lock Y scrolling if page is scrolling. Events -> (Chrome, Firefox, IE)
		$(document.body).on('mousewheel DOMMouseScroll onmousewheel', function(e) {
			if (pageScrollingLockYScroll) {
				e.preventDefault();
				e.stopPropagation();
			}
		});

		// Display mode toggle
		$priceMode.on('click', function filterPrice(event) {
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;

			$featuresMode.removeClass('active');
			$priceMode.addClass('active');

			meerkat.modules.carResults.switchToPriceMode(true);
			if (updateBtnShown) $cancelUpdateBtn.trigger('click');

			meerkat.modules.session.poke();
		});

		$featuresMode.on('click', function filterFeatures(event) {
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;

			$priceMode.removeClass('active');
			$featuresMode.addClass('active');

			meerkat.modules.carResults.switchToFeaturesMode(true);
			if (updateBtnShown) $cancelUpdateBtn.trigger('click');

			meerkat.modules.session.poke();
		});

		// Dropdown options

		$component.on('click', '.dropdown-menu a', handleDropdownOption);

		$updateBtn.on('click', function updateResults() {
			meerkat.messaging.publish(moduleEvents.CHANGED, {excess:currentValues.excess});
			toggleUpdate(true);
		});

		$cancelUpdateBtn.on('click', function cancelUpdate() {
			if(!_.isEmpty(previousValues.excess)) {
				$filterExcess.find('li.active').removeClass("active");
				var $dropdown = $('.dropdown.filter-excess');

				currentValues.excess = previousValues.excess;

				$filterExcess.find('a[data-value="' + previousValues.excess + '"]').each(function(){
					$dropdown.find('.dropdown-toggle span').text($(this).text());
					$(this).parent().addClass("active");
				});
			}
			toggleUpdate(true);
		});

		meerkat.messaging.subscribe(meerkatEvents.paymentFrequencyButtons.CHANGED, function() {
			$('#quote_paymentType').val(Results.getFrequency());
			updateFilters();
		});
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
				label: 'UPDATE RESULTS',
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

		$('#xsFilterBarCoverType input:checked').prop('checked', false);
		$('#xsFilterBarCoverType #xsFilterBar_coverType_comprehensive').prop('checked', true).change();

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
				excess : $('#xsFilterBarExcessRow select[name=xsFilterBar_excess]').val()
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

	function initCarFilters() {
		if(!initialised) {
			initialised = true;

			$component = $('#navbar-filter');
			$labels = $('#navbar-filter-labels');

			if ($component.length === 0) return;

			$priceMode = $component.find('.filter-pricemode');
			$featuresMode = $component.find('.filter-featuresmode');
			$filterFrequency = $component.find('.filter-frequency');
			$filterExcess = $component.find('.filter-excess');
			$filterCoverType = $component.find('.filter-cover-type');
			$updateBtn = $component.find('.updateFilters');
			$cancelUpdateBtn = $('.filter-cancel-label a');

			eventSubscriptions();

			// Collect options from the page

			var $filterMenu;

			$filterMenu = $filterCoverType.find('.dropdown-menu');
			$('#filter_coverTypeOptions option').each(function () {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
			});

			$filterMenu = $filterExcess.find('.dropdown-menu');
			$('#filter_excessOptions option').each(function () {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
			});

			$filterMenu = $filterFrequency.find('.dropdown-menu');
			$('#filter_paymentType option').each(function () {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
			});

			$('#navbar-main .slide-feature-filters a, .mobile-nav-buttons .refine-results a').on('click', function (e) {
				e.preventDefault();
				if (!$(this).hasClass('disabled')) {
					onRequestModal();
				}
			});

			meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, _.bind(setCurrentDeviceState, this, {isXS: true}));
			meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, _.bind(setCurrentDeviceState, this, {isXS: false}));

			setCurrentDeviceState();
		}
	}



	meerkat.modules.register('carFilters', {
		initCarFilters: initCarFilters,
		events: events,
		updateFilters: updateFilters,
		hide: hide,
		show: show,
		disable: disable,
		enable: enable,
		onRequestModal: onRequestModal
	});

})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,

		events = {
			carFilters: {
				CHANGED: 'CAR_FILTERS_CHANGED'
			}
		},
		moduleEvents = events.carFilters,

		initialised = false,
		deviceStateXS = false,
		modalID = false,
		pageScrollingLockYScroll = false,
		updateBtnShown = false,
		hasComprehensiveExcessUpdated = false,
		currentValues = {
			display:	false,
			frequency:	false,
			excess:		false,
			coverType:  false
		},
		defaultThirdPartyExcess = 600,

		$component,
		$priceMode,
		$featuresMode,
		$filterFrequency,
		$filterExcess,
		$labels,
		$filterCoverType,
		$updateBtn,
		$cancelUpdateBtn,

		// hidden xpaths
		$typeOfCover,
		$excess,
		$baseExcess
	;

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
		refreshFrequency();

		// Refresh cover type
		var coverType = $typeOfCover.val();
        $filterCoverType.find('.dropdown-toggle span').text( $filterCoverType.find('.dropdown-menu a[data-value="' + coverType + '"]').text() );

		// Refresh excess
		var excess = currentValues.excess ? currentValues.excess : ($excess.val() ? $excess.val() : $baseExcess.val());

		if (hasComprehensiveExcessUpdated) {
			if (currentValues.excess) {
				$excess.val(currentValues.excess);
			}
		}

		if (coverType !== 'COMPREHENSIVE') {
			excess = defaultThirdPartyExcess;
			$excess.val(excess);
		}
		else {
			if (!hasComprehensiveExcessUpdated && $excess.val() !== '') {
				excess = $baseExcess.val();
				$excess.val('');
			}
		}

		$filterExcess.find('.dropdown-toggle span').text( $filterExcess.find('.dropdown-menu a[data-value="' + excess + '"]').text() );
		$filterExcess.toggleClass('default-600', coverType !== 'COMPREHENSIVE');
	}

	// Refresh frequency
	function refreshFrequency() {
		var freq = $('#quote_paymentType').val();
		if (typeof freq === 'undefined') {
			$filterFrequency.find('.dropdown-toggle span').text( $filterFrequency.find('.dropdown-menu a:first').text() );
		}
		else {
			$filterFrequency.find('.dropdown-toggle span').text( $filterFrequency.find('.dropdown-menu a[data-value="' + freq + '"]').text() );
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

				if (deviceStateXS === true) {
					meerkat.modules.paymentFrequencyButtons.set(value);
				}
			}
		} else {
			var valueUpdated = false;

			if ($dropdown.hasClass('filter-cover-type')) {
				if (currentValues.coverType !== value) {
					valueUpdated = true;
				}

				currentValues.coverType = value;

				if (value !== 'COMPREHENSIVE') {
					// set third party default excess
					$filterExcess.find('.dropdown-menu a[data-value=' + defaultThirdPartyExcess + ']').trigger('click');
					$filterExcess.add($('.filter-excess .dropdown-toggle')).addClass('disabled');
				} else {
					$filterExcess.find('.dropdown-menu a[data-value=' + currentValues.excess + ']').trigger('click');
					$filterExcess.add($('.filter-excess .dropdown-toggle')).removeClass('disabled');

					if (!hasComprehensiveExcessUpdated) {
						currentValues.excess = $baseExcess.val();
						$filterExcess.find('.dropdown-menu a[data-value=' + currentValues.excess + ']').trigger('click');
					}
				}
				$filterExcess.toggleClass('default-600', value !== 'COMPREHENSIVE');
			} else {
				if (currentValues.coverType === 'COMPREHENSIVE') {
					if (currentValues.excess !== value) {
						valueUpdated = true;
					}
					currentValues.excess = value;
				}
			}

			// if values have changed, show update button
			if (valueUpdated) {
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
		var excess = currentValues.excess ? currentValues.excess : ($excess.val() ? $excess.val() : $baseExcess.val());

		currentValues = {
			display:	Results.getDisplayMode(),
			frequency:	$('#quote_paymentType').val(),
			excess: excess,
			coverType: $typeOfCover.val()
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

		$filterCoverType.find('li.active').removeClass("active");
		$filterCoverType.find('a[data-value="' + currentValues.coverType + '"]').each(function(){
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

		if (meerkat.site.skipNewCoverTypeCarJourney) {
			$('.dropdown.filter-cover-type, .filter-cover-type .dropdown-toggle').addClass('skipNewCoverTypes');
		}
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

			if (meerkat.site.skipNewCoverTypeCarJourney) {
				$('.dropdown.filter-cover-type, .filter-cover-type .dropdown-toggle').addClass('disabled');
			}
		}
		$component.find('li.dropdown.filter-frequency, .filter-frequency .dropdown-toggle').removeClass('disabled');

		if (currentValues.coverType !== 'COMPREHENSIVE') {
			$component.find('li.dropdown.filter-excess, .filter-excess .dropdown-toggle').addClass('disabled');
		}
	}

	function eventSubscriptions() {

		// Disable filters while results are in progress
		$(document).on('resultsFetchStart', function onResultsFetchStart() {
			disable();
			toggleUpdate(true);
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
			$typeOfCover.val(currentValues.coverType);
			$excess.val(currentValues.coverType === 'COMPREHENSIVE' ? currentValues.excess : defaultThirdPartyExcess);

			// if the comprehensive excess is different to baseExcess, set hasComprehensiveExcessUpdated to true
			if (currentValues.coverType === 'COMPREHENSIVE' && currentValues.excess !== $baseExcess.val()) {
				hasComprehensiveExcessUpdated = true;
			}

			meerkat.messaging.publish(moduleEvents.CHANGED, {excess:currentValues.excess, coverType:currentValues.coverType});
			toggleUpdate(true);
		});

		$cancelUpdateBtn.on('click', function cancelUpdate() {
			// trigger clicks on previous selected values
			var excess = $excess.val() ? $excess.val() : $baseExcess.val();
			$filterCoverType.find('.dropdown-menu a[data-value=' + $typeOfCover.val() + ']').trigger('click');
			$filterExcess.find('.dropdown-menu a[data-value=' + excess + ']').trigger('click');

			toggleUpdate(true);
		});

		meerkat.messaging.subscribe(meerkatEvents.paymentFrequencyButtons.CHANGED, function() {
			$('#quote_paymentType').val(Results.getFrequency());

			refreshFrequency();
		});

		meerkat.messaging.subscribe(meerkatEvents.mobileNavButtons.REFINE_RESULTS_TOGGLED, function onRefineResultsToggled() {
			onRequestModal();
		});
	}

	function renderModal() {
		var templateAccessories = _.template($('#car-xsFilterBar-template').html()),
			excess = $excess.val(),
			htmlContent = templateAccessories({
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
		$('#xsFilterBarCoverType #xsFilterBar_coverType_' + currentValues.coverType).prop('checked', true).attr('checked', 'checked').change();

		$('[name=xsFilterBar_coverType]').on('change', function() {
			var coverType = $(this).val();

			xsDefaultExcess(coverType);
		});

		xsDefaultExcess(currentValues.coverType);

		meerkat.modules.carTypeOfCover.toggleTPFTOption($('#xsFilterBar_coverType_TPFT').parent());
	}

	function xsDefaultExcess(coverType) {
		var excess = defaultThirdPartyExcess,
			xsFilterBarExcess = $('#xsFilterBar_excess');

		if (coverType === 'COMPREHENSIVE') {
			if (!hasComprehensiveExcessUpdated) {
				excess = $baseExcess.val();
			} else {
				excess = currentValues.excess;
			}
		}

		xsFilterBarExcess
			.val(excess)
			.toggleClass('default-600', coverType !== 'COMPREHENSIVE')
			.prop('disabled', coverType !== 'COMPREHENSIVE')
			.attr('disabled', coverType !== 'COMPREHENSIVE');

		xsFilterBarExcess.closest('.select').toggleClass('disabled', coverType !== 'COMPREHENSIVE');
	}

	function saveModalChanges() {

		var $freq = $('#quote_paymentType'),
            $coverType = $('#quote_typeOfCover'),

            revised = {
                display: $('#xsFilterBarSortRow input:checked').val(),
                freq : $('.payment-frequency-buttons input:checked').val(),
                excess : $('#xsFilterBarExcessRow select[name=xsFilterBar_excess]').val(),
                coverType : $('#xsFilterBarCoverType input:checked').val()
            },

            revisedValues = {};

		if(Number(revised.excess) === 0) {
			revised.excess = '';
		}

		$freq.val( revised.freq );
        $coverType.val( revised.coverType );

		if (revised.display !== currentValues.display) {
			if(revised.display === 'features') {
				meerkat.modules.carResults.switchToFeaturesMode(true);
			} else if(revised.display === 'price') {
				meerkat.modules.carResults.switchToPriceMode(true);
			}
		}

		meerkat.modules.dialogs.close(modalID);
		meerkat.modules.navMenu.close();

		if ( currentValues.frequency !== revised.freq ) {
			currentValues.frequency = revised.freq;
			Results.setFrequency(currentValues.frequency);
			meerkat.messaging.publish(moduleEvents.CHANGED);
		}

		if ( currentValues.excess !== revised.excess) {
			// only update currentValues.excess if comprehensive cover
			if (revised.coverType === 'COMPREHENSIVE') {
				currentValues.excess = revised.excess;
			}
            revisedValues.excess = revised.excess;
		}

		if ( currentValues.coverType !== revised.coverType ) {
		    currentValues.coverType = revised.coverType;
            revisedValues.coverType = revised.coverType;
        }

		if (revised.coverType === 'COMPREHENSIVE' && revised.excess !== $baseExcess.val()) {
			hasComprehensiveExcessUpdated = true;
		}

		updateFilters();

        if (!_.isEmpty(revisedValues)) {
            meerkat.messaging.publish(moduleEvents.CHANGED, revisedValues);
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

	function buildCoverTypeMenu($filterCoverType) {
		var $filterMenu = $filterCoverType.find('.dropdown-menu');

		$filterMenu.empty();

		$('#filter_coverTypeOptions option:not(.hidden)').each(function () {
			$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
		});
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

			$typeOfCover = $('#quote_typeOfCover');
			$excess = $('#quote_excess');
			$baseExcess = $('#quote_baseExcess');

			eventSubscriptions();

			// Collect options from the page
			var $filterMenu;

			buildCoverTypeMenu($filterCoverType);

			$filterMenu = $filterExcess.find('.dropdown-menu');
			$('#filter_excessOptions option').each(function () {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
			});

			$filterMenu = $filterFrequency.find('.dropdown-menu');
			$('#filter_paymentType option').each(function () {
				$filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + '</a></li>');
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
		onRequestModal: onRequestModal,
		buildCoverTypeMenu: buildCoverTypeMenu
	});

})(jQuery);
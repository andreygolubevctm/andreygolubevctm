;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            mobileFiltersMenu: {
                FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE',
                ON_RESET: 'ON_RESET'
            }
        },
        $elements = {},
        _isSwitchedOn = {
            hospital: null,
            extras: null
        },
        _switchTemplates = {
            hospital: '#refineResultsHospitalBenefitsSwitch',
            extras: '#refineResultsExtrasBenefitsSwitch'
        },
        Benefits = null,
        BenefitsModel = null;

    function initHealthRefineResultsMobileBenefits() {
        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();

        Benefits = meerkat.modules.benefits;
        BenefitsModel = meerkat.modules.benefitsModel;

        return this;
    }

    function _setupElements() {
        $elements = {
            hospitalSwitchDefaultSelector: $('#health_benefits_HospitalSwitch'),
            extrasSwitchDefaultSelector: $('#health_benefits_ExtrasSwitch')
        };
    }

    function _applyEventListeners() {
        $(document).on('shown.bs.tab', '.health-refine-results-hospital-benefits a[data-toggle="tab"]', function (e) {
            var $hospitalBenefits = $('input[name=health_refineResults_benefitsHospital]'),
                $hospitalBenefitsChecked = $hospitalBenefits.filter(':checked');

            if ($(this).attr('href').search(/Hospital/) !== -1 && $hospitalBenefitsChecked.length === 0) {
                $hospitalBenefits.filter('[data-benefit-code=PrHospital]').trigger('click');
            } else if ($hospitalBenefitsChecked.length > 0) {
                $hospitalBenefitsChecked.attr('disabled', $(this).attr('href').search(/Limited/) !== -1);
            }

            meerkat.messaging.publish(moduleEvents.mobileFiltersMenu.FOOTER_BUTTON_UPDATE);
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_OPENED, function () {
            // loop through selected hospital benefits
            benefitsCheckState('hospital');

            // loop through selected extras benefits
            benefitsCheckState('extras');

            if (Benefits.getHospitalType() === 'limited') {
                $('.health-refine-results-hospital-benefits li a').each(function () {
                    var $that = $(this);
                    var isLimited = $that.attr('href').search(/Limited/) !== -1;
                    $that.closest('li').toggleClass('active', isLimited);
                });
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.benefitsSwitch.FILTERS_SWITCH_CHANGED, function (e) {
            if (e.isMobile) {
            	_isSwitchedOn[e.benefit] = e.isSwitchedOn;

                meerkat.messaging.publish(meerkatEvents.refineResults.REFINE_RESULTS_UPDATABLE, {
                    updatable: meerkat.modules.benefitsSwitch.isFiltersHospitalOn(true) || meerkat.modules.benefitsSwitch.isFiltersExtrasOn(true)
                });
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_FOOTER_BUTTON_UPDATE_CALLBACK, function() {
        	// update hospital benefits cover type tab
            var $hospitalType = $('.health-refineResults-hospital-benefits li.active').find('a'),
                benefitCoverType = $hospitalType.length && $hospitalType.attr('href').search(/Limited/) !== -1 ? 'limited' : 'customise';

            $('#health_benefits_covertype').val(benefitCoverType);
            Benefits.setHospitalType(benefitCoverType);

            meerkat.modules.healthFilters.populateSelectedBenefits(
                $('.health-refine-results-hospital-benefits'),
                $('.health-refine-results-extras-benefits')
            );
			// SML-1614 this where the journey cover level is updated
			var journeyCoverType = meerkat.modules.healthBenefitsCoverType.getCoverType();
			var refineHospitalSwitch = isSwitchedOn('hospital');
			var refineExtrasSwitch = isSwitchedOn('extras');

			if(!_.isNull(refineHospitalSwitch) || !_.isNull(refineExtrasSwitch)) {
				var tempCoverType = "C";
				/**
				 * Important note: if a toggle hasn't been launched then its default value is null and you
				 * can derive the value from the original coverType (C, H or E). Eg if the hospital switch
				 * is off and the extras switch is null then if the original cover type is C then you can
				 * assume the new cover type is Extras Only.
				 */
				if((!_.isNull(refineHospitalSwitch) && refineHospitalSwitch) && (!_.isNull(refineExtrasSwitch) && !refineExtrasSwitch)) {
					tempCoverType = "H";
				} else if((!_.isNull(refineHospitalSwitch) && !refineHospitalSwitch) && (!_.isNull(refineExtrasSwitch) && refineExtrasSwitch)) {
					tempCoverType = 'E';
				} else if((!_.isNull(refineHospitalSwitch) && refineHospitalSwitch) && _.isNull(refineExtrasSwitch) && journeyCoverType === 'H') {
					tempCoverType = "H";
				} else if((!_.isNull(refineHospitalSwitch) && !refineHospitalSwitch) && _.isNull(refineExtrasSwitch) && journeyCoverType === 'C') {
					tempCoverType = 'E';
				} else if(_.isNull(refineHospitalSwitch) && (!_.isNull(refineExtrasSwitch) && refineExtrasSwitch) && journeyCoverType === 'E') {
					tempCoverType = "E";
				} else if(_.isNull(refineHospitalSwitch) && (!_.isNull(refineExtrasSwitch) && !refineExtrasSwitch) && journeyCoverType === 'C') {
					tempCoverType = 'H';
				}

				if(journeyCoverType !== tempCoverType) {
					meerkat.modules.healthBenefitsCoverType.setCoverType(tempCoverType);
					meerkat.messaging.publish("COVERTYPE_CHANGED", {coverType: tempCoverType});
					if(tempCoverType === 'E') {
						meerkat.modules.healthBenefitsToggleAndJumpMenu.unselectHospitalBenefits();
					} else if(tempCoverType === 'H') {
						meerkat.modules.healthBenefitsToggleAndJumpMenu.unselectExtrasBenefits();
					}
				}
			} else {
				// Must be no change to switches so no need to update the cover type
			}

			if (!_.isNull(refineHospitalSwitch)) {
            	_isSwitchedOn.hospital = null;
            }

            if (!_.isNull(refineExtrasSwitch)) {
				_isSwitchedOn.extras = null;
            }
        });

        meerkat.messaging.subscribe(moduleEvents.mobileFiltersMenu.ON_RESET, function() {
            _resetSwitchState();
        });
    }

    function benefitsCheckState(benefit, uncheckIt) {
        var items = (benefit === 'hospital') ?
            BenefitsModel.getHospitalBenefitsForFilters() : BenefitsModel.getExtrasBenefitsForFilters();

        _.each(items, function (item) {
            $('#health_refineResults_benefits_' + item.id).prop('checked', uncheckIt ? false : BenefitsModel.isSelected(item.id));
        });
    }

    function getSwitchHTML(benefit) {
        return _.template($(_switchTemplates[benefit]).html());
    }

    function switchInit(benefit, initialised, isSwitchedOn) {
        meerkat.modules.benefitsSwitch[benefit === 'hospital' ? 'initHospitalFilters' : 'initExtrasFilters'](true, initialised);
        meerkat.modules.healthFilters.toggleFiltersBenefitSelection(benefit, isSwitchedOn, true);
    }

    function isSwitchedOn(benefit) {
        return _isSwitchedOn[benefit];
    }

    function _resetSwitchState() {
        _isSwitchedOn = {
            hospital: null,
            extras: null
        };
    }

    meerkat.modules.register('healthRefineResultsMobileBenefits', {
        initHealthRefineResultsMobileBenefits: initHealthRefineResultsMobileBenefits,
        events: moduleEvents,
        getSwitchHTML: getSwitchHTML,
        switchInit: switchInit,
        isSwitchedOn: isSwitchedOn
    });

})(jQuery);
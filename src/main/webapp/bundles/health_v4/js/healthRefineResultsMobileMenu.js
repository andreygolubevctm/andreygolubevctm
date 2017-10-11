;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            mobileFiltersMenu: {
                ON_RESET: 'ON_RESET',
                FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE',
                BACK_BUTTON_CLICKED: 'BACK_BUTTON_CLICKED'
            }
        },
        settings = {
            title: 'Refine results',
            footerButtonUpdateText: 'Apply filters',
            template: $('#refine-results-template'),
            footerButtonUpdateCB: _footerButtonUpdateCB,
            rightButtonCB: _rightButtonCB
        },
        $elements = {},
        menuItems = {
            hospitalPreferences: { title: 'Hospital preferences', rightBtnText: 'Clear all' },
            extrasPreferences: { title: 'Extras preferences', rightBtnText: 'Clear all' },
            excess: { title: 'Excess' },
            funds: { title: 'Funds' }
        },
        MobileFiltersMenu = null,
        _currentMenuId = null;

    function initHealthRefineResultsMobileMenu() {
        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();

        var htmlTemplate = _.template(settings.template.html());
        settings.htmlContent = htmlTemplate(_getData());

        MobileFiltersMenu = meerkat.modules.mobileFiltersMenu;
        MobileFiltersMenu.initMobileFiltersMenu(settings);
    }

    function _setupElements() {
        $elements = {
            refineBtn: $('.refine-results'),
            applyDiscount: $('input[name=health_applyDiscounts]'),
            applyRebate: $('input[name="health_healthCover_rebate"]')
        };
    }

    function _applyEventListeners() {
        $elements.refineBtn.on('click', function() {
            if ($(this).hasClass('disabled')) return;

            _currentMenuId = 'main';

            // update html template content
            var htmlTemplate = _.template(settings.template.html());
            settings.htmlContent = htmlTemplate(_getData());

            MobileFiltersMenu
                .open()
                .updateMenuBodyHTML(settings.htmlContent);

            _.defer(function() {
                $('#health_refine_results_discount').prop('checked', $elements.applyDiscount.val() === 'Y');
                $('#health_refine_results_rebate').prop('checked', $elements.applyRebate.val() === 'Y');

                // loop through selected hospital benefits
                _.each(meerkat.modules.benefitsModel.getHospitalBenefitsForFilters(), function (benefit) {
                    $('#health_refineResults_benefits_' + benefit.id).prop('checked', meerkat.modules.benefitsModel.isSelected(benefit.id));
                });

                // loop through selected extras benefits
                _.each(meerkat.modules.benefitsModel.getExtrasBenefitsForFilters(), function (benefit) {
                    $('#health_refineResults_benefits_' + benefit.id).prop('checked', meerkat.modules.benefitsModel.isSelected(benefit.id));
                });

                var hospitalType = meerkat.modules.benefits.getHospitalType();

                if (hospitalType === 'limited') {
                    $('.health-refine-results-hospital-benefits li a').each(function () {
                        var $that = $(this);
                        var isLimited = $that.attr('href').search(/Limited/) !== -1;
                        $that.closest('li').toggleClass('active', isLimited);
                        $('#refineResultsHospitalBenefits').toggleClass('active in', !isLimited);
                        $('#refineResultsLimitedHospital').toggleClass('active in', isLimited);
                    });
                }
            });
        });

        $(document).on('change', '.mobile-filters-menu-body :input', function() {
            meerkat.messaging.publish(moduleEvents.mobileFiltersMenu.FOOTER_BUTTON_UPDATE);
        });

        $(document).on('click', '.mobile-filters-menu-item', function() {
            _currentMenuId = $(this).attr('data-menu-id');

            $('.mobile-filters-menu-body section[data-panel=1]').addClass('slide-out');
            $('.mobile-filters-menu-body section[data-panel-id="' + _currentMenuId + '"]').addClass('slide-in');

            MobileFiltersMenu
                .showBackBtn()
                .updateHeaderTitle(menuItems[_currentMenuId].title);

            if (menuItems[_currentMenuId].rightBtnText) {
                MobileFiltersMenu
                    .updateRightBtnText(menuItems[_currentMenuId].rightBtnText)
                    .showRightBtn();
            }
        });

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

        $(document).on('transitionend webkitTransitionEnd oTransitionEnd', '.mobile-filters-menu-body section', function() {
            if ($(this).hasClass('slide-out')) {
                $(this).removeClass('current');
            }

            if ($(this).hasClass('slide-in')) {
                $(this).addClass('current');
                $(this).removeClass('slide-in');
            }
        });
    }

    function _eventSubscriptions() {
        // Disable mobile nav buttons while results are in progress
        $(document).on('resultsFetchStart', function onResultsFetchStart() {
            disable();
        });

        $(document).on('resultsFetchFinish', function onResultsFetchFinish() {
            enable();
        });

        meerkat.messaging.subscribe(moduleEvents.mobileFiltersMenu.BACK_BUTTON_CLICKED, function() {
            $('.mobile-filters-menu-body section[data-panel=1]')
                .addClass('current')
                .removeClass('slide-out');

            $('.mobile-filters-menu-body section:not([data-panel=1])').removeClass('current');

            MobileFiltersMenu.hideRightBtn();

            _currentMenuId = 'main';
        });

        meerkat.messaging.subscribe(meerkatEvents.ON_RESET, function() {
            $('.mobile-filters-menu-body section').removeClass('current slide-out');
            $('.mobile-filters-menu-body section[data-panel=1]').addClass('current');
        });
    }

    function _footerButtonUpdateCB() {
        $elements.applyDiscount.val($('#health_refine_results_discount').is(':checked') ? 'Y' : 'N');
        $elements.applyRebate.val($('#health_refine_results_rebate').is(':checked') ? 'Y': 'N');

        // update hospital benefits cover type tab
        var $hospitalType = $('.health-refineResults-hospital-benefits li.active').find('a'),
            benefitCoverType = $hospitalType.length && $hospitalType.attr('href').search(/Limited/) !== -1 ? 'limited' : 'customise';

        $('#health_benefits_covertype').val(benefitCoverType);
        meerkat.modules.benefits.setHospitalType(benefitCoverType);
        meerkat.modules.benefits.toggleHospitalTypeTabs();

        meerkat.modules.healthFilters.populateSelectedBenefits(
            $('.health-refine-results-hospital-benefits'),
            $('.health-refine-results-extras-benefits')
        );

        _.defer(function() {
            // get new results
            meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
            meerkat.modules.healthResults.get();
        });
    }

    function _rightButtonCB() {
        switch (_currentMenuId) {
            case 'hospitalPreferences':
                _.each(meerkat.modules.benefitsModel.getHospitalBenefitsForFilters(), function (benefit) {
                    $('#health_refineResults_benefits_' + benefit.id).prop('checked', false);
                });
                break;

            case 'extrasPreferences':
                _.each(meerkat.modules.benefitsModel.getExtrasBenefitsForFilters(), function (benefit) {
                    $('#health_refineResults_benefits_' + benefit.id).prop('checked', false);
                });
                break;
        }

        meerkat.messaging.publish(moduleEvents.mobileFiltersMenu.FOOTER_BUTTON_UPDATE);
    }

    function disable() {
        $elements.refineBtn.addClass('disabled');
    }

    function enable() {
        $elements.refineBtn.removeClass('disabled');
    }

    function _getData() {
        var hospitalType = meerkat.modules.benefits.getHospitalType(),
            hospitalCount = meerkat.modules.benefitsModel.getHospitalCount(),
            hospitalPlural = hospitalCount > 1 ? 's' : '',
            comprehensiveText = hospitalCount > 0 ? hospitalCount + ' benefit' + hospitalPlural + ' selected' : 'No Hospital',
            extrasCount = meerkat.modules.benefitsModel.getExtrasCount(),
            extrasPlural = extrasCount > 1 ? 's' : '',
            data = {
                hospitalType: hospitalType === 'customise' ? 'Comprehensive' : 'Limited',
                hospitalCountText: hospitalType === 'customise' ? ', ' + comprehensiveText : '',
                extrasCountText: extrasCount > 0 ? extrasCount + ' extra' + extrasPlural + ' selected' : 'No Extras',
                benefitsHospital: meerkat.modules.benefitsModel.getHospitalBenefitsForFilters(),
                benefitsExtras: meerkat.modules.benefitsModel.getExtrasBenefitsForFilters()
            };

        if (meerkat.modules.splitTest.isActive(2)) {
            $.extend(data, {
                isHospitalOn: meerkat.modules.benefitsSwitch.isHospitalOn(),
                isExtrasOn: meerkat.modules.benefitsSwitch.isExtrasOn()
            });
        }

        return data;
    }

    meerkat.modules.register('healthRefineResultsMobileMenu', {
        initHealthRefineResultsMobileMenu: initHealthRefineResultsMobileMenu,
        events: moduleEvents
    });

})(jQuery);
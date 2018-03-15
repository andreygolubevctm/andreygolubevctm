;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            refineResults: {
                REFINE_RESULTS_OPENED: 'REFINE_RESULTS_OPENED',
                REFINE_RESULTS_MENU_ITEM_SELECTED: 'REFINE_RESULTS_MENU_ITEM_SELECTED',
                REFINE_RESULTS_FOOTER_BUTTON_UPDATE_CALLBACK: 'REFINE_RESULTS_FOOTER_BUTTON_UPDATE_CALLBACK',
                REFINE_RESULTS_UPDATABLE: 'REFINE_RESULTS_UPDATABLE'
            },
            mobileFiltersMenu: {
                ON_RESET: 'ON_RESET',
                RIGHT_BUTTON_INIT: 'RIGHT_BUTTON_INIT',
                FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE',
                FOOTER_BUTTON_TOGGLE_DISABLED: 'FOOTER_BUTTON_TOGGLE_DISABLED',
                BACK_BUTTON_CLICKED: 'BACK_BUTTON_CLICKED',
                RIGHT_BUTTON_ON_CHANGE: 'RIGHT_BUTTON_ON_CHANGE'
            }
        },
        settings = {
            title: 'Refine results',
            footerButtonUpdateText: 'Apply filters',
            template: $('#refine-results-template'),
            footerButtonUpdateCB: _footerButtonUpdateCB
        },
        $elements = {},
        menuItems = {
            hospital: {
                title: 'Hospital preferences',
                rightBtnInitCB: _hospitalBenefitsSwitchInit,
                rightBtnInitialised: false
            },
            extras: {
                title: 'Extras preferences',
                rightBtnInitCB: _extrasBenefitsSwitchInit,
                rightBtnInitialised: false
            },
            excess: { title: 'Excess' },
            funds: { title: 'Funds' }
        },
        MobileFiltersMenu = null,
        Benefits = null,
        BenefitsModel = null,
        MobileBenefits = null,
        MobileExcess =  null,
        MobileFunds = null,
        _currentMenuId = null;

    function initHealthRefineResultsMobileMenu() {
        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();

        MobileFiltersMenu = meerkat.modules.mobileFiltersMenu.initMobileFiltersMenu(settings);
        Benefits = meerkat.modules.benefits;
        BenefitsModel = meerkat.modules.benefitsModel;
        MobileBenefits = meerkat.modules.healthRefineResultsMobileBenefits.initHealthRefineResultsMobileBenefits();
        MobileExcess = meerkat.modules.healthRefineResultsMobileExcess.initHealthRefineResultsMobileExcess();
        MobileFunds = meerkat.modules.healthRefineResultsMobileFunds.initHealthRefineResultsMobileFunds();

        menuItems.hospital.rightBtn = MobileBenefits.getSwitchHTML('hospital');
        menuItems.extras.rightBtn = MobileBenefits.getSwitchHTML('extras');
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
            var htmlTemplate = _.template(settings.template.html()),
                htmlContent = htmlTemplate(_getData());

            MobileFiltersMenu
                .open()
                .updateMenuBodyHTML(htmlContent);

            _.defer(function() {
                $('#health_refine_results_discount').prop('checked', $elements.applyDiscount.val() === 'Y');
                $('#health_refine_results_rebate').prop('checked', $elements.applyRebate.val() === 'Y');

                meerkat.messaging.publish(moduleEvents.refineResults.REFINE_RESULTS_OPENED);

                // Note added this event handler here fixes for Safari mobile.
                $('.refine-results-mobile__item').on('click', function() {
                    _currentMenuId = $(this).attr('data-menu-id');
                    meerkat.messaging.publish(moduleEvents.refineResults.REFINE_RESULTS_MENU_ITEM_SELECTED, { id: _currentMenuId });

                    $('.refine-results-mobile section[data-panel-id="main"]').addClass('sliding slide-out');
                    $('.refine-results-mobile section[data-panel-id="' + _currentMenuId + '"]').addClass('sliding slide-in');

                    MobileFiltersMenu
                        .showBackBtn()
                        .updateHeaderTitle(menuItems[_currentMenuId].title);

                    if (menuItems[_currentMenuId].rightBtn) {
                        MobileFiltersMenu
                            .updateRightBtn(menuItems[_currentMenuId].rightBtn)
                            .showRightBtn();
                    }
                });
            });
        });

        $(document).on('change', '.mobile-filters-menu__container :input', function() {
            meerkat.messaging.publish(moduleEvents.mobileFiltersMenu.FOOTER_BUTTON_UPDATE);
        });

        $(document).on('transitionend webkitTransitionEnd oTransitionEnd', '.refine-results-mobile section', function() {
            if ($(this).hasClass('slide-out')) {
                $(this).removeClass('current');
            }

            if ($(this).hasClass('slide-in')) {
                $(this).addClass('current');
                $(this).removeClass('slide-in');
            }

            $(this).removeClass('sliding');
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

        meerkat.messaging.subscribe(moduleEvents.mobileFiltersMenu.RIGHT_BUTTON_INIT, function() {
            if (_.isFunction(menuItems[_currentMenuId].rightBtnInitCB) && menuItems[_currentMenuId].rightBtnInitCB) {
                menuItems[_currentMenuId].rightBtnInitCB();
                menuItems[_currentMenuId].rightBtnInitialised = true;
            }
        });

        meerkat.messaging.subscribe(moduleEvents.mobileFiltersMenu.BACK_BUTTON_CLICKED, function() {
            $('.refine-results-mobile section.current')
                .addClass('sliding')
                .removeClass('current');

            $('.refine-results-mobile section[data-panel-id="main"]')
                .addClass('sliding current')
                .removeClass('slide-out');

            MobileFiltersMenu.hideRightBtn();

            _currentMenuId = 'main';
        });

        meerkat.messaging.subscribe(meerkatEvents.mobileFiltersMenu.ON_RESET, function() {
            $('.refine-results-mobile section').removeClass('current slide-out');
            $('.refine-results-mobile section[data-panel-id="main"]').addClass('current');

            menuItems.hospital.rightBtnInitialised = false;
            menuItems.extras.rightBtnInitialised = false;
        });

        meerkat.messaging.subscribe(moduleEvents.refineResults.REFINE_RESULTS_UPDATABLE, function(e) {
            meerkat.messaging.publish(moduleEvents.mobileFiltersMenu.FOOTER_BUTTON_TOGGLE_DISABLED, { toggle: e.updatable });
        });
    }

    function _hospitalBenefitsSwitchInit() {
        var isSwitchedOn = menuItems.hospital.rightBtnInitialised ? meerkat.modules.benefitsSwitch.isFiltersHospitalOn(true) : meerkat.modules.benefitsSwitch.isHospitalOn();

        MobileBenefits.switchInit('hospital', menuItems.hospital.rightBtnInitialised, isSwitchedOn);
    }

    function _extrasBenefitsSwitchInit() {
        var isSwitchedOn = menuItems.extras.rightBtnInitialised ? meerkat.modules.benefitsSwitch.isFiltersExtrasOn(true) : meerkat.modules.benefitsSwitch.isExtrasOn();

        MobileBenefits.switchInit('extras', menuItems.extras.rightBtnInitialised, isSwitchedOn);
    }

    function _footerButtonUpdateCB() {
        $elements.applyDiscount.val($('#health_refine_results_discount').is(':checked') ? 'Y' : 'N');
        $elements.applyRebate.val($('#health_refine_results_rebate').is(':checked') ? 'Y': 'N');

        meerkat.messaging.publish(moduleEvents.refineResults.REFINE_RESULTS_FOOTER_BUTTON_UPDATE_CALLBACK);

        _.defer(function() {
            // get new results
            meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
            meerkat.modules.healthResults.get();
        });
    }

    function disable() {
        $elements.refineBtn.addClass('disabled');
    }

    function enable() {
        $elements.refineBtn.removeClass('disabled');
    }

    function _getData() {
        var hospitalType = Benefits.getHospitalType() === 'customise' ? 'Comprehensive' : 'Limited',
            hospitalCount = BenefitsModel.getHospitalCount(),
            hospitalPlural = hospitalCount > 1 ? 's' : '',
            comprehensiveText = hospitalCount > 0 ? hospitalCount + ' benefit' + hospitalPlural + ' selected' : 'No Hospital',
            hospitalCountText = Benefits.getHospitalType() === 'customise' ? ', ' + comprehensiveText : '',
            extrasCount = BenefitsModel.getExtrasCount(),
            extrasPlural = extrasCount > 1 ? 's' : '',
            data = {
                hospitalText: meerkat.modules.benefitsSwitch.isHospitalOn() ? hospitalType + ' Hospital' + hospitalCountText : 'No Hospital',
                extrasCountText: meerkat.modules.benefitsSwitch.isExtrasOn() && extrasCount > 0 ? extrasCount + ' extra' + extrasPlural + ' selected' : 'No Extras',
                benefitsHospital: BenefitsModel.getHospitalBenefitsForFilters(),
                benefitsExtras: BenefitsModel.getExtrasBenefitsForFilters(),
                excessText: MobileExcess.getText(),
                fundsText: MobileFunds.getFundsText()
            };

        return data;
    }

    meerkat.modules.register('healthRefineResultsMobileMenu', {
        initHealthRefineResultsMobileMenu: initHealthRefineResultsMobileMenu,
        events: moduleEvents
    });

})(jQuery);
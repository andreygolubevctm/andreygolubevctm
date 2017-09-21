;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            mobileMenu: {
                ON_RESET: 'ON_RESET',
                FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE',
                BACK_BUTTON_CLICKED: 'BACK_BUTTON_CLICKED'
            }
        },
        settings = {
            title: 'Refine results',
            footerButtonUpdateText: 'Apply filters',
            template: $('#refine-results-template')
        },
        $elements = {};

    function initHealthRefineResultsMobileMenu() {
        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();

        settings.footerButtonUpdateCB = function() {
            $elements.applyDiscount.val($('#health_refine_results_discount').is(':checked') ? 'Y' : 'N');
            $elements.applyRebate.val($('#health_refine_results_rebate').is(':checked') ? 'Y': 'N');

            // meerkat.modules.healthFilters.getCheckedBenefitsFromFilters($('.health-refine-results-hospital-benefits'));

            meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
            meerkat.modules.healthResults.get();
        };

        var htmlTemplate = _.template(settings.template.html());
        settings.htmlContent = htmlTemplate(_getData());

        meerkat.modules.mobileMenu.initMobileMenu(settings);
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

            meerkat.modules.mobileMenu.open();

            $('#health_refine_results_discount').prop('checked', $elements.applyDiscount.val() === 'Y');
            $('#health_refine_results_rebate').prop('checked', $elements.applyRebate.val() === 'Y');

            // loop through selected hospital benefits
            _.each(meerkat.modules.benefitsModel.getHospitalBenefitsForFilters(), function(benefit) {
                $('#health_refineResults_benefits_' + benefit.id).prop('checked', benefit.selected);
            });
        });

        $(document).on('change', '.mobile-menu-body :input', function() {
            meerkat.messaging.publish(moduleEvents.mobileMenu.FOOTER_BUTTON_UPDATE);
        });

        $(document).on('click', '.mobile-menu-item', function() {
            $('.mobile-menu-body section[data-panel=1]').addClass('slide-out');
            $('.mobile-menu-body section[data-panel="'+ $(this).attr('data-slide-panel') +'"]').addClass('slide-in');

            meerkat.modules.mobileMenu.showBackBtn();
            meerkat.modules.mobileMenu.updateHeaderTitle($(this).attr('data-slide-panel'));
        });

        $(document).on('transitionend webkitTransitionEnd oTransitionEnd', '.mobile-menu-body section', function() {
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

        meerkat.messaging.subscribe(moduleEvents.mobileMenu.BACK_BUTTON_CLICKED, function() {
            $('.mobile-menu-body section[data-panel=1]')
                .addClass('current')
                .removeClass('slide-out');

            $('.mobile-menu-body section:not([data-panel=1])').removeClass('current');
        });

        meerkat.messaging.subscribe(meerkatEvents.ON_RESET, function() {
            $('.mobile-menu-body section').removeClass('current slide-out');
            $('.mobile-menu-body section[data-panel=1]').addClass('current');
        });
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
            comprehensiveText = hospitalCount > 0 ? hospitalCount + ' Benefit' + hospitalPlural + ' selected' : 'No Hospital',
            extrasCount = meerkat.modules.benefitsModel.getExtrasCount(),
            extrasPlural = extrasCount > 1 ? 's' : '',
            data = {
                hospitalType: hospitalType === 'customise' ? 'Comprehensive' : 'Limited',
                hospitalBtnText: hospitalType === 'customise' ? (hospitalCount > 0 ? 'Change' : 'Add Hospital') : 'Change',
                hospitalCountText: hospitalType === 'customise' ? comprehensiveText : '',
                extrasBtnText: extrasCount > 0 ? 'Change' : 'Add Extras',
                extrasCountText: extrasCount > 0 ? extrasCount + ' Extra' + extrasPlural + ' selected' : 'No Extras',
                benefitsHospital: meerkat.modules.benefitsModel.getHospitalBenefitsForFilters()
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
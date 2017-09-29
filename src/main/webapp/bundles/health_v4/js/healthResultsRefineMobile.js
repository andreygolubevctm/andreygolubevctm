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
        $elements = {},
        modalId = null;

    function initHealthResultsRefineMobile() {
        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();
    }

    function _setupElements() {
        $elements = {
            refineBtn: $('.refine-results'),
            modalTemplate: $('#refine-results-modal-template'),
            redirectBtn: $('.refine-results-redirect-btn'),
            applyDiscount: $('input[name=health_applyDiscounts]')
        };
    }

    function _applyEventListeners() {
        $elements.refineBtn.on('click', function() {
            if ($(this).hasClass('disabled')) return;

            // _showModal();

            meerkat.modules.mobileMenu.open();

            $('#health_refine_results_discount').prop('checked', $elements.applyDiscount.val() === 'Y');
        });

        $(document).on('click', '.refine-results-redirect-btn', function() {
            var benefit = $(this).attr('data-benefit');

            _hideModal();
            meerkat.modules.address.setHash('benefits');

            _.delay(function() {
                meerkat.modules.benefitsSelectionScroller.triggerScroll(benefit);
            }, 750);
        });

        $(document).on('click', '.refine-results-view-all-times', function(e) {
            e.preventDefault();
            var anchorText = $(this).text() === 'View All Times ' ? 'Show Today Only ' : 'View All Times ';
            $(this).html(anchorText + "<span class='caret'></span>");
            $(this).toggleClass('dropup');
            $('.refine-results-all-times, .refine-results-today-hours').toggleClass('hidden');
        });

        $(document).on('click', '#health_refine_results_discount', function() {
            var isChecked = $(this).is(':checked');

            // update hidden apply discount element
            $elements.applyDiscount.val(isChecked ? 'Y' : 'N');
            // _hideModal();

            // retrieve new prices
            // meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
            // meerkat.modules.healthResults.get();
        });

        $(document).on('change', '.mobile-menu-body :input', function() {
            meerkat.messaging.publish(moduleEvents.mobileMenu.FOOTER_BUTTON_UPDATE);
        });

        $(document).on('click', '.mobile-menu-body h5', function() {
            console.log('data-slide-panel', $(this).attr('data-slide-panel'));
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
            $('.mobile-menu-body section').removeClass('current');
            $('.mobile-menu-body section[data-panel=1]').addClass('current');
        });
    }

    function disable() {
        $elements.refineBtn.addClass('disabled');
    }

    function enable() {
        $elements.refineBtn.removeClass('disabled');
    }

    function _showModal() {
        var template = _.template($elements.modalTemplate.html());

        modalId = meerkat.modules.dialogs.show({
            title: 'Refine Results',
            className: 'refine-results-modal',
            htmlContent: template(_getData()),
            onOpen: function(id) {
                $('#health_refine_results_discount').prop('checked', $elements.applyDiscount.val() === 'Y');
            }
        });

        return modalId;
    }

    function _hideModal() {
        if (modalId !== null) {
            $('#' + modalId).modal('hide');
        }
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
                isHospitalOn: meerkat.modules.benefitsSwitch.isHospitalOn(),
                isExtrasOn: meerkat.modules.benefitsSwitch.isExtrasOn()
            };

        return data;
    }

    meerkat.modules.register('healthResultsRefineMobile', {
        initHealthResultsRefineMobile: initHealthResultsRefineMobile,
        events: moduleEvents
    });

})(jQuery);
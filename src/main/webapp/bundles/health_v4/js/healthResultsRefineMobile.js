;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
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

            _showModal();
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
            _hideModal();

            // retrieve new prices
            meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
            meerkat.modules.healthResults.get();
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
        initHealthResultsRefineMobile: initHealthResultsRefineMobile
    });

})(jQuery);
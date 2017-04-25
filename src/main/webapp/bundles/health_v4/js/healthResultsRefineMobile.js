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
            redirectBtn: $('.refine-results-redirect-btn')
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

        $(document).on('click', '.refine-results-view-all-times', function() {
            var anchorText = $(this).text() === 'view all times' ? 'show today only' : 'view all times';
            $(this).text(anchorText);
            $('.refine-results-all-times, .refine-results-today-hours').toggleClass('hidden');
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
            htmlContent: template(_getData())
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
            extrasPlural = extrasCount > 1 ? 's' : '';

        return {
            hospitalType: hospitalType === 'customise' ? 'Comprehensive' : 'Limited',
            hospitalBtnText: hospitalType === 'customise' ? (hospitalCount > 0 ? 'Change' : 'Add Hospital') : 'Change',
            hospitalCountText: hospitalType === 'customise' ? comprehensiveText : '',
            extrasBtnText: extrasCount > 0 ? 'Change' : 'Add Extras',
            extrasCountText: extrasCount > 0 ? extrasCount + ' Extra' + extrasPlural + ' selected' : 'No Extras'
        };
    }

    meerkat.modules.register('healthResultsRefineMobile', {
        initHealthResultsRefineMobile: initHealthResultsRefineMobile
    });

})(jQuery);
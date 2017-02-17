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
            modalTemplate: $('#refine-mobile-modal-template')
        };
    }

    function _applyEventListeners() {
        $elements.refineBtn.on('click', function() {
            _showModal();
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
        var template = _.template($elements.modalTemplate.html()),
            hospitalType = meerkat.modules.benefits.getHospitalType(),
            hospitalCount = meerkat.modules.benefits.getHospitalCount(),
            comprehensiveText = hospitalCount > 0 ? hospitalCount + ' Benefits selected' : 'No Hospital',
            extrasCount = meerkat.modules.benefits.getExtrasCount(),
            data = {
                hospitalType: hospitalType === 'customise' ? 'Comprehensive' : 'Limited',
                hospitalCountText: hospitalType === 'customise' ? comprehensiveText : '',
                extrasCountText: extrasCount > 0 ? extrasCount + ' Extra selected' : 'No Extras'
            };

        modalId = meerkat.modules.dialogs.show({
            title: 'Refine Results',
            className: 'refine-mobile-modal',
            htmlContent: template(data)
        });

        return modalId;
    }

    function _hideModal() {
        if (modalId !== null) {
            $('#' + modalId).modal('hide');
        }
    }

    meerkat.modules.register('healthResultsRefineMobile', {
        initHealthResultsRefineMobile: initHealthResultsRefineMobile
    });

})(jQuery);
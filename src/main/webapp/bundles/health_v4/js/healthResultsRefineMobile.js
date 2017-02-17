;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

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
    }

    function _showModal() {
        var template = _.template($elements.modalTemplate.html());

        modalId = meerkat.modules.dialogs.show({
            className: 'refine-mobile-modal',
            htmlContent: template()
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
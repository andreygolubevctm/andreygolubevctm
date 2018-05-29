;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var lhcHelpCopy = '',
        _template = null;

    function initHealthPriceBreakdown() {
        _getLHCHelpCopy();
        _applyEventListeners();

        _template = $('#price-breakdown-template');
    }

    function showBreakdown() {
        return (!_.isNull(meerkat.modules.journeyEngine.getCurrentStep()) &&
                meerkat.modules.journeyEngine.getCurrentStep().navigationId !== 'results') ||
                meerkat.site.pageAction === 'confirmation';
    }

    function _applyEventListeners() {
        $(document).on('click', '.lhc-loading-help', function() {
            meerkat.modules.dialogs.show({
                title: 'LHC Loading',
                htmlContent: lhcHelpCopy,
                showCloseBtn: true
            });
        });
    }

    function _getLHCHelpCopy() {
        meerkat.modules.comms.get({
            url: 'spring/content/get.json',
            data: {
                vertical: 'HEALTH',
                key: 'priceBreakdownLHCHelpCopy'
            },
            cache: true,
            dataType: 'json',
            useDefaultErrorHandling: false,
            errorLevel: 'silent',
            timeout: 5000,
            onSuccess: function onSubmitSuccess(data) {
                lhcHelpCopy = data.contentValue;
            }
        });
    }

    function renderTemplate(premium, frequency, showCopyPanel) {
        var html = _.template(_template.html());
        return html({
            premium: premium,
            frequency: frequency,
            showCopyPanel: showCopyPanel
        });
    }

    function showLHC(product, frequency) {
        return (product.premium[frequency].lhc !== '$0.00' && product.premium[frequency].lhcfreepricing.indexOf('The premium may be affected by LHC<br/>') < 0) ||
            (!_.isNull(meerkat.modules.healthLHC.getNewLHC()) && meerkat.modules.healthLHC.getNewLHC() > 0);
    }

    meerkat.modules.register('healthPriceBreakdown', {
        initHealthPriceBreakdown: initHealthPriceBreakdown,
        showBreakdown: showBreakdown,
        renderTemplate: renderTemplate,
        showLHC: showLHC
    });

})(jQuery);

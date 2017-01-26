;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var modalId = false,
        $modal,
        $noDecline;

    function initRedemptionForm(modalIdParam, baseURL) {
        modalId = modalIdParam.modalId;

        if (modalId) {

            $modal = $('#' + modalId);
            $noDecline = $modal.find('.noDecline');

            meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($('#redemptionForm'));
            meerkat.modules.elasticAddress.setupElasticAddressPlugin(baseURL);
            meerkat.modules.autocomplete.setBaseURL(baseURL);
            meerkat.modules.autocomplete.setTypeahead();
            meerkat.modules.address_lookup.setBaseURL(baseURL);
            applyEventListeners();
            _toggleSignOnReceiptWarning();
        }
    }

    function applyEventListeners() {
        $modal.find('.rewardType input').on('change', function toggleDecline() {
            if($(this).is(':checked')) {
                $noDecline.removeClass('hidden');
                $modal.find('.declineReward input').prop('checked', false);
            }
        });

        $modal.find('.declineReward input').on('change', function toggleDecline() {
            if($(this).is(':checked')) {
                $noDecline.addClass('hidden');
                $modal.find('.rewardType input').prop('checked', false).trigger('change');
            }
        });

        $modal.find('.signature input').on('change', _toggleSignOnReceiptWarning);
    }
    
    function _toggleSignOnReceiptWarning() {
        var $signatureSection =  $modal.find('.signature');
        $signatureSection.find('.fieldrow_legend').toggle($signatureSection.find('input:checked').val() === 'N');
    }

    meerkat.modules.register("redemptionForm", {
        initRedemptionForm: initRedemptionForm
    });

})(jQuery);
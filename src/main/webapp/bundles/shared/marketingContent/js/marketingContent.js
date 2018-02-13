;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception;

    var _ajaxURL = 'marketingContent/get.json',
        _ajaxGetHandler = null,
        _hasContent = false;

    function init() {
        var transactionId = meerkat.modules.transactionId.get();

        // get marketing content
        _ajaxGetHandler = meerkat.modules.comms.get({
            url: _ajaxURL,
            cache: false,
            errorLevel: 'silent',
            dataType: 'json',
            useDefaultErrorHandling: false,
            data: {
                transactionId: transactionId
            }
        })
        .done(function onSuccess(json) {
            if (json.marketingContentId > 0) {
                meerkat.modules.bannerPlacement.render({
                    type: 'marketing-content',
                    url: json.url
                });

                _hasContent = true;
            }
        })
        .fail(function onError(obj, txt, errorThrown) {
            exception(txt + ': ' + errorThrown);
        });
    }

    function hasContent() {
        return _hasContent;
    }

    meerkat.modules.register('marketingContent', {
        init: init,
        hasContent: hasContent
    });
})(jQuery);
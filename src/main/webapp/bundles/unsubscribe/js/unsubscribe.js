;(function ($, undefined) {
    var meerkat = window.meerkat;

    var events = {
        };

    function initUnsubscribeComponent() {
        $(document).ready(function () {
            applyEventListeners();
        });
    }

    function applyEventListeners() {
        $('.btn-unsubscribe').on('click', function() {
            var $this = $(this);
            meerkat.modules.loadingAnimation.showInside($this, true);
            meerkat.modules.comms.post({
                url: "ajax/json/unsubscribe.jsp",
                errorLevel: "warning",
                useDefaultErrorHandling: false,
                dataType: 'json',
                cache: false
            }).then(function () {
                $('.postUnsubscribeTextContainer, .preUnsubscribeTextContainer').toggleClass('hidden');
                $('.unsubscribeButtonContainer').addClass('hidden');
            }).catch(function (jqXHR, textStatus, errorThrown) {
                $('.unsubscribeButtonContainer').removeClass('hidden');
                var response = $.parseJSON(jqXHR.responseText);
                meerkat.modules.errorHandling.error({
                    message: (typeof response === 'object' && response !== null ? response.error : "An unknown error occurred, please try again."),
                    page: "unsubscribe.js:unsubscribe()",
                    errorLevel: "warning",
                    description: "Unsubscribe Failed: " + errorThrown
                });
            }).always(function () {
                meerkat.modules.loadingAnimation.hide($this);
            });
        });
    }

    meerkat.modules.register('unsubscribeComponent', {
        init: initUnsubscribeComponent,
        events: events
    });

})(jQuery);
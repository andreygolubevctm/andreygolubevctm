;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function init() {
        $(document).ready(function() {
            meerkat.modules.utils.pluginReady('popovers').done(function() {
                var $simplesHelpBox = $('#simples-help-box');

                if ($simplesHelpBox.length) {
                    meerkat.modules.popovers.create({
                        element: $simplesHelpBox,
                        contentValue: $simplesHelpBox.data('content'),
                        contentType: 'content',
                        showEvent: 'click',
                        position: {
                            my: 'bottom right',
                            at: 'top left'
                        },
                        style: {
                            classes: 'helpBoxTip'
                        }
                    });
                }
            });
        });
    }

    meerkat.modules.register('healthHelpBox', {
        init: init
    });

})(jQuery);
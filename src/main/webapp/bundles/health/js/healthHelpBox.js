;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var _getCurrentHelpBoxAjax = null;

    function init() {
        $(document).ready(function() {
            _getCurrentHelpBoxAjax = meerkat.modules.comms.get({
                url: 'simples/admin/helpbox/getCurrentRecords.json',
                cache: true,
                dataType: 'json',
                useDefaultErrorHandling: false,
                errorLevel: 'silent',
                timeout: 5000,
                onSuccess: function (data) {
                    // if not null
                    if (data !== null) {
                        // create ? link
                        meerkat.modules.utils.pluginReady('popovers').done(function() {
                            _createHelpBoxLink(data);
                        });
                    }
                }
            });
        });
    }

    function _createHelpBoxLink(data) {
        $('#footer .container').append('<div id="simples-help-box"><a href="javascript:;">?</a></div>');

        meerkat.modules.popovers.create({
            element: $('#simples-help-box'),
            contentValue: data.content,
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

    meerkat.modules.register('healthHelpBox', {
        init: init
    });

})(jQuery);
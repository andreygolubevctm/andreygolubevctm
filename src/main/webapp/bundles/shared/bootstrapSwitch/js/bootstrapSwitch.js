;(function ($, undefined) {

    var meerkat = window.meerkat;

    function initBootstrapSwitch(options) {

        if ($('input.checkbox-switch').length) {
            $('input.checkbox-switch').bootstrapSwitch().bootstrapSwitch('setOnLabel', options.on).bootstrapSwitch('setOffLabel', options.off);
        }
    }

    meerkat.modules.register("bootstrapSwitch", {
        initBootstrapSwitch: initBootstrapSwitch
    });

})(jQuery);
/**
 * Description: Waits for the page to load and then loads of all the images src that have been set with data-src instead of src. This has for effect to increase the initial page load
 * IMPORTANT: This file cannot be loaded asynchronously
 */

;(function ($) {

    var meerkat = window.meerkat;

    function init() {
        $(document).ready(function () {
            $("[data-defer-src]").each(function allDeferSrcLoadLoop() {
                var $this = $(this);
                var targetSrc = $this.attr('data-defer-src');

                // Little kludge to ensure that images are loaded absolutely.
                // Used due to images previously being loaded relatively to subfolders and getting 404s
                if(targetSrc.charAt(0) !== '/') {
                    targetSrc = '/' + meerkat.site.urls.context + targetSrc;
                }

                $this.attr('src', targetSrc).removeAttr('data-defer-src');
            });
        });
    }

    meerkat.modules.register("deferSrcLoad", {
        init: init
    });

})(jQuery);
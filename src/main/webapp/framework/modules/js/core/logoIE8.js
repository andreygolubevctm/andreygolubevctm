;(function($, undefined){

    /**
     * logoIE8 updates the logo image html for IE8 and below to render the logo correctly.
     * IE8 doesn't support background-size so we replace the background image with an actual
     * image which fills defined the space.
     **/

    var meerkat = window.meerkat,
        meerkatEvents =  meerkat.modules.events;


    function init(){
        $(document).ready(support);
    }

    function support() {
        // Only proceed if IE8 or less
        $logo = $('html.lt-ie9 #logo');
        if($logo.length) {
            var url = $logo.css("background-image").slice(5,-2);
            var brand = $logo.text();
            $logo.css("background-image","none");
            $img = $("<img/>",{
                src:url,
                alt:brand
            }).attr("style","width:100%;height:100%");
            $logo.empty().append($img);
        }
    }

    meerkat.modules.register("logoIE8", {
        init: init
    });

})(jQuery);
;
(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};
    var REQUEST_PARAM = "verificationToken";
    var verificationToken = "";

    function initVerificationToken() {
        jQuery(document).ready(function($) {
            setTokenFromPage();
        });
    }

    function get() {
        return verificationToken;
    }

    function set( _verificationToken ) {
        verificationToken = _verificationToken;
    }

    function setTokenFromPage(){
        set(meerkat.site.verificationToken );
    }

    function addTokenToRequest(ajaxProperties){
        var verificationToken = get();
        // only send verificationToken if using post
        if(ajaxProperties.type === 'POST'){
            if (_.isString(ajaxProperties.data)) {
                ajaxProperties.data += '&' + REQUEST_PARAM + '=' + verificationToken;
            }else if (_.isArray(ajaxProperties.data)) {
                ajaxProperties.data.push({
                    name: REQUEST_PARAM,
                    value: verificationToken
                });
            } else if (_.isObject(ajaxProperties.data)) {
                ajaxProperties.data[REQUEST_PARAM] = verificationToken;
            }
        }
    }

    meerkat.modules.register("verificationToken", {
        init: initVerificationToken,
        events: events,
        get: get,
        set: set,
        addTokenToRequest : addTokenToRequest
    });
})(jQuery);
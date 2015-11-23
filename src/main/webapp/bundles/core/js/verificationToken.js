(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};
    var REQUEST_PARAM = "verificationToken";
    var verificationToken;

    function initVerificationToken(){

    }

    function get() {
        if(typeof verificationToken === 'undefined' || verificationToken === '' ){
            setTokenFromPage();
        }
        return verificationToken;
    }

    function set( _verificationToken ) {
        verificationToken = _verificationToken;
    }

    function setTokenFromPage(){
        set(meerkat.site.verificationToken );
    }

    /* Adds verificationToken as a param to ajaxProperties.data
     only send verificationToken if ajaxProperties.type is POST */
    function addTokenToRequest(ajaxProperties) {
        if (meerkat.site.tokenEnabled === 'true') {
            var verificationToken = get();
            if (ajaxProperties.type === 'POST') {
                if (_.isString(ajaxProperties.data)) {
                    ajaxProperties.data += '&' + REQUEST_PARAM + '=' + verificationToken;
                } else if (_.isArray(ajaxProperties.data)) {
                    ajaxProperties.data.push({
                        name: REQUEST_PARAM,
                        value: verificationToken
                    });
                } else if (_.isObject(ajaxProperties.data)) {
                    ajaxProperties.data[REQUEST_PARAM] = verificationToken;
                }
            }
        }
    }

    function readTokenFromResponse(response){
        if(typeof response.verificationToken !== 'undefined' && response.verificationToken !== ''){
            set(response.verificationToken);
        }
    }

    function readIfTokenError(error){
        if(error !== 'undefined' && error.type == "InvalidVerificationToken") {
            meerkat.modules.session.expire();
        }
    }

    function getDecodedToken(){
        return jwt_decode(get());
    }

    meerkat.modules.register("verificationToken", {
        init: initVerificationToken,
        events: events,
        get: get,
        set: set,
        addTokenToRequest : addTokenToRequest,
        readTokenFromResponse : readTokenFromResponse,
        getDecodedToken : getDecodedToken,
        readIfTokenError : readIfTokenError
    });
})(jQuery);
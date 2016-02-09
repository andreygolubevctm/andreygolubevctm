$(function () {
    var commsModule = meerkat.modules.comms;
    var oldAjax = $.ajax;

// to test open the following in your browser
// file:///C:/Dev/web_ctm/src/main/frontend/qunit/index.html?notrycatch=true
    module( "meerkat.modules.comms" );
    function setup(){
        meerkat.modules.verificationToken.set();
        meerkat.site.tokenEnabled = 'true';
    }

    QUnit.test("should set token on post", function (assert) {
        setup();
        var testToken = "testToken";
        meerkat.modules.verificationToken.set(testToken );
        var instanceSettings = {
            data : {},
            errorLevel : 'silent',
            onSuccess : function(){

            },
            onComplete  : function(){

            },
        };
        var result;
        function mockAjax(ajaxProperties) {
            result = ajaxProperties.data;
            return {
                then : function mockThen(onAjaxSuccess, onAjaxError) {
                }
            };
        }


        $.ajax = mockAjax;
        commsModule.post(instanceSettings);

        setTimeout(1000);
        assert.equal(testToken, result["verificationToken"]);

        $.ajax = oldAjax;
    });


});


$(function () {
// to test open the following in your browser
// file:///C:/Dev/web_ctm/src/main/frontend/qunit/index.html?notrycatch=true

    module( "meerkat.modules.verificationToken" );

    QUnit.test("should set token on request", function (assert) {
        var testToken = "testToken";
        meerkat.modules.verificationToken.set(testToken );
        var ajaxProperties = {
            type : "POST",
            data : {}
        };
        var settings = {};
        meerkat.modules.verificationToken.addTokenToRequest(ajaxProperties);

        assert.equal(testToken, ajaxProperties.data["verificationToken"]);

    });

    QUnit.test("should set token from page", function (assert) {
        var testToken = "testToken2";
        meerkat.site.verificationToken = testToken;
        meerkat.modules.verificationToken.init();
        assert.equal(testToken, meerkat.modules.verificationToken.get());
    });

});


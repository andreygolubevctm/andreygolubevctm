$(function () {
    var verificationTokenModule = meerkat.modules.verificationToken;
    var tokenEnabled =  meerkat.site.tokenEnabled;
// to test open the following in your browser
// file:///C:/Dev/web_ctm/src/main/frontend/qunit/index.html?notrycatch=true

    module( "meerkat.modules.verificationToken" );

    function setup(){
        verificationTokenModule.set();
        meerkat.site.tokenEnabled = 'true';
    }

    function cleanUp(){
        meerkat.site.tokenEnabled = tokenEnabled;
    }

    QUnit.test("should set token on request", function (assert) {
        setup();
        var testToken = "testToken";
        verificationTokenModule.set(testToken );
        var ajaxProperties = {
            type : "POST",
            data : {}
        };
        var settings = {};
        verificationTokenModule.addTokenToRequest(ajaxProperties);

        assert.equal(testToken, ajaxProperties.data["verificationToken"]);
        cleanUp();
    });

    QUnit.test("should read token from response", function (assert) {
        setup();
        var testToken = "testTokenResponse";
        var response = {
            verificationToken : testToken
        };
        verificationTokenModule.readTokenFromResponse(response);

        assert.equal(testToken, verificationTokenModule.get());
        cleanUp();
    });

    QUnit.test("should set token from page", function (assert) {
        setup();
        var testToken = "testTokenFromPage";
        meerkat.site.verificationToken = testToken;
        verificationTokenModule.init();
        assert.equal(testToken, verificationTokenModule.get());

        var testToken2 = "testToken2";
        verificationTokenModule.set(testToken2)
        assert.equal(testToken2, verificationTokenModule.get());
        cleanUp();
    });

});


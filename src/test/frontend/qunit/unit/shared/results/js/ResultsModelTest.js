$(function () {
// to test open the following in your browser
// file:///C:/Dev/web_ctm/main/webapp/framework/modules/js/tests/index.html?notrycatch=true

    module( "ResultsModel" );

    QUnit.test("should send verification token if available", function (assert) {
        var url= "test";
        var data = [];
        var testToken = "verificationToken";
        var sentToken = "";
        $.ajax = function(request){
            sentToken = request.data[0].name;
        };
        meerkat.modules.verificationToken.set(testToken );
        Results.init({
            url: url,
            data: data
        });
        ResultsModel.fetch(url, data );
        setTimeout(function(){}, 500);
        assert.equal(sentToken, testToken);
    });

});


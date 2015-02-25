$(function () {
// to test open the following in your browser
// file:///C:/Dev/web_ctm/WebContent/framework/modules/js/tests/index.html?notrycatch=true

    QUnit.test("should validate name", function (assert) {
        ok(meerkat.modules.validation.validatePersonName("John Show"), "John Show should be valid");
        ok(meerkat.modules.validation.validatePersonName("Mathias d'Arras"), "Mathias d'Arras should be valid");
        ok(meerkat.modules.validation.validatePersonName("Martin Luther King, Jr."), "Martin Luther King, Jr. should be valid");
        ok(meerkat.modules.validation.validatePersonName("Hector Sausage-Hausen"), "Hector Sausage-Hausen should be valid");

        ok(!meerkat.modules.validation.validatePersonName("Mädchen Müller"), "Mädchen Müller should be invalid");
        ok(!meerkat.modules.validation.validatePersonName("Aimé Côté"), "Aimé Côté" + " should be invalid");
        ok(!meerkat.modules.validation.validatePersonName("ABC *"), "ABC *" + " should be invalid");
        ok(!meerkat.modules.validation.validatePersonName("ABC (abc)"), "ABC (abc)" + " should be invalid");
        ok(!meerkat.modules.validation.validatePersonName("ABC123"), "ABC123" + " should be invalid");
        ok(!meerkat.modules.validation.validatePersonName("123ABC"), "123ABC" + " should be invalid");
        ok(!meerkat.modules.validation.validatePersonName("Русский"), "Русский" + " should be invalid");
        ok(!meerkat.modules.validation.validatePersonName("日本語"), "日本語" + " should be invalid");
        ok(!meerkat.modules.validation.validatePersonName("العربية"), "العربية" + " should be invalid");
    });

    QUnit.test("should set age message", function (assert) {
        var title = "test";
        var ageMin = 42;
        var expectedMessage = title + ' age cannot be under ' + ageMin;
        var resultMessage = "";
        var Field = {
            rules :  function(action, request ){
                resultMessage = request.messages.min_DateOfBirth
            }
        }
        var field = Object.create(Field);


        meerkat.modules.validation.setMinAgeValidation(field, 42, title);
        ok(resultMessage == expectedMessage, "min age should be set");
    });
});


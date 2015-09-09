$(function () {
// to test open the following in your browser
// file:///C:/Dev/web_ctm/main/webapp/framework/modules/js/tests/index.html?notrycatch=true

    QUnit.test("should validate name", function (assert) {
        ok(validatePersonName("John Show"), "John Show should be valid");
        ok(validatePersonName("Mathias d'Arras"), "Mathias d'Arras should be valid");
        ok(validatePersonName("Martin Luther King, Jr."), "Martin Luther King, Jr. should be valid");
        ok(validatePersonName("Hector Sausage-Hausen"), "Hector Sausage-Hausen should be valid");

        ok(!validatePersonName("Mädchen Müller"), "Mädchen Müller should be invalid");
        ok(!validatePersonName("Aimé Côté"), "Aimé Côté" + " should be invalid");
        ok(!validatePersonName("ABC *"), "ABC *" + " should be invalid");
        ok(!validatePersonName("ABC (abc)"), "ABC (abc)" + " should be invalid");
        ok(!validatePersonName("ABC123"), "ABC123" + " should be invalid");
        ok(!validatePersonName("123ABC"), "123ABC" + " should be invalid");
        ok(!validatePersonName("Русский"), "Русский" + " should be invalid");
        ok(!validatePersonName("日本語"), "日本語" + " should be invalid");
        ok(!validatePersonName("العربية"), "العربية" + " should be invalid");
    });

});


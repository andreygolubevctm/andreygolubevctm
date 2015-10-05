// mock all ajax calls
meerkat.modules.comms.post = function (instanceSettings) {
};
meerkat.modules.comms.get = function (instanceSettings) {
};

test("should set to second day of month", function () {
    meerkat.modules.healthPaymentDate.init();
    var $policyDateHiddenField = $('.health_details-policyDate');
    var $messageField = $(".health_credit-card-details_policyDay-message");
    meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay($messageField, "10/08/2014", [2], 1);

    ok($policyDateHiddenField.val() === '2014-09-02', "field value does not match!" + $policyDateHiddenField.val());
    ok($messageField.text() == 'Your payment will be deducted on: Tuesday, 2 September 2014', "message value does not match!" + $messageField.val());
});

test("should set to 15th day of month", function () {
    meerkat.modules.healthPaymentDate.init();
    var $policyDateHiddenField = $('.health_details-policyDate');
    var $messageField = $(".health_credit-card-details_policyDay-message");
    meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay($messageField, "10/08/2014", [2, 20], 1);

    ok($policyDateHiddenField.val() === '2014-08-20', "field value does not match!" + $policyDateHiddenField.val());
    ok($messageField.text() == 'Your payment will be deducted on: Wednesday, 20 August 2014', "message value does not match!" + $messageField.text());
});

test("should default day of month", function () {
    meerkat.modules.healthPaymentDate.init();
    var $policyDateHiddenField = $('.health_details-policyDate');
    var $messageField = $(".health_credit-card-details_policyDay-message");
    meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay($messageField, "10/08/2014");

    ok($policyDateHiddenField.val() === '2014-09-01', "field value does not match!" + $policyDateHiddenField.val());
    ok($messageField.text() == 'Your payment will be deducted on: Monday, 1 September 2014', "message value does not match!" + $messageField.val());
});
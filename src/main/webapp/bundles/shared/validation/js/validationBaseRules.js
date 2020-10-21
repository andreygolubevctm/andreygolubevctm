$.validator.addMethod('regex', function(value, element, param) {
    return value.match(new RegExp('^' + param + '$'));
});

$.validator.addMethod("digitsIgnoreComma", function(value, element, params) {
    // Replace commas with blanks.
    value = value.replace(/,/g, "");
    // Do the normal digit check.
    return this.optional(element) || /^\d+$/.test(value);
});

$.validator.addMethod("isCheckedYes", function(value, element, params) {
    return value == "Y" && $(element).prop("checked") === true;
});

$.validator.addMethod("isCheckedNo", function(value, element, params) {
    return value == "N" && $(element).prop("checked") === true;
});

$.validator.addMethod("isUnique", function (value, element, param) {
    return value !== $(element).attr('data-isUniqueTo');
});

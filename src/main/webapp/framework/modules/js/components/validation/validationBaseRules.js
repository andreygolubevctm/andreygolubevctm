 // TODO CTMIT-555: What is the value in this one.
$.validator.addMethod('regex', function(value, element, param) {
    return value.match(new RegExp('^' + param + '$'));
});

//TODO CTMIT-555: Used only on Car, can it be removed if $.number is sufficient?
$.validator.addMethod("digitsIgnoreComma", function(value, element, params) {
    // Replace commas with blanks.
    value = value.replace(/,/g, "");
    // Do the normal digit check.
    return this.optional(element) || /^\d+$/.test(value);
});
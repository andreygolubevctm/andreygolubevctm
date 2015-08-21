// TODO: delete this when all vertical are on the new framework
// Name is alpha and .'\-, only with no foreign characters as providers don't support them
// Ensures that an email address or URL is not being entered
//
if (typeof meerkat === 'undefined' || typeof meerkat.modules.validation === 'undefined') {
    var validNameCharsRegex = /^([a-zA-Z .'\-,]*)$/;
    var isUrlRegex = /(?:[^\s])\.(com|co|net|org|asn|ws|us|mobi)(\.[a-z][a-z])?/;
    $.validator.addMethod("personName",
        function validatePersonName(value, element) {
            return value.match(isUrlRegex) === null && validNameCharsRegex.test(value);
        },
        "Please enter alphabetic characters only. Unfortunately, international " +
        "alphabetic characters, numbers and symbols are not supported by many of our " +
        "partners at this time.");
}
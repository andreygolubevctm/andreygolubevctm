(function($) {

    var urlRegex = /(?:[^\s])\.(com|co|net|org|asn|ws|us|mobi)(\.[a-z][a-z])?/,
        personNameRegex = /^([a-zA-Z .'\-,]*)$/;

    /**
     * To enable this rule on an element, it needs the "data-rule-personName='true'" attribute to be added.
     * To override the message, use data-msg-personName="your new message".
     */
    $.validator
        .addMethod(
        "personName", function (value, element, param) {
            var isURL = value.match(urlRegex) !== null;
            return !isURL && personNameRegex.test(value);
        }, "Please enter alphabetic characters only. " +
        "Unfortunately, international alphabetic characters, numbers and symbols are not " +
        "supported by many of our partners at this time."
    );

})(jQuery);

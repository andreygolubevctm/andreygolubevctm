
$.validator.addMethod('regex', function(value, element, param) {
    return value.match(new RegExp('^' + param + '$'));
});

String.prototype.startsWith = function(prefix) {
    return (this.substr(0, prefix.length) === prefix);
};
String.prototype.endsWith = function(suffix) {
    return (this.substr(this.length - suffix.length) === suffix);
};

// TODO: delete this when all vertical are on the new framework
// Validate only numeric only fields with no foreign characters as providers don't support them
// Ensures that an email address or URL is not being entered
if (typeof meerkat === 'undefined' || typeof meerkat.modules.validation === 'undefined') {
    var validNumericRegex = /^(\d+)$/;
    $.validator.addMethod("numericOnly",
        function validateNumericOnly(value, element) {
            return validNumericRegex.test(value);
        },
        "Please enter a valid number.");
}

//
// Ensures that client agrees to the field
// Makes sure that checkbox for 'Y' is checked
//
$.validator.addMethod("agree", function (value, element) {
    if (value === "Y") {
        return $(element).is(":checked");
    } else {
        return false;
    }
}, "");

//
// Is used to reset the number of form errors when moving between slides
//
(function($) {
    $.extend($.validator.prototype, {
        resetNumberOfInvalids : function() {
            this.invalid = {};
            $(this.containers).find(".error, li").remove();
        }
    });
})(jQuery);

//
// Any input field with a class of 'numeric' will only be allowed to input
// numeric characters
//
$(function() {
    try {
        $("input.numeric").numeric();
    } catch (e) {/* IGNORE */
    }
});

//
//Validates OK to email which ensure we have a email address if they select yes
//
$.validator.addMethod("marketing", function () {
    if ($('input[name="quote_contact_marketing"]:checked').val() === "Y"
        && $('input[name="quote_contact_email"]').val() === "") {
        return false;
    } else {
        $('input[name="quote_contact_email"]').parent().removeClass('state-right state-error');
        return true;
    }

}, "");


$.validator.addMethod("digitsIgnoreComma", function(value, element, params) {
    // Replace commas with blanks.
    value = value.replace(/,/g, "");
    // Do the normal digit check.
    return this.optional(element) || /^\d+$/.test(value);
});
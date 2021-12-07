////////////////////////////////////////////////////////////////
//// STRING UTILITIES MODULE                                ////
////--------------------------------------------------------////
//// stringUtils provides a common module to share useful   ////
//// string operations.                                     ////
////--------------------------------------------------------////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function($, undefined){

    var meerkat = window.meerkat;

    function isAllUppercase(input) {
        return /^[^a-z]*$/.test(input);
    }

    function hasMultipleUppercase(input) {
        return /.*[A-Z].*[A-Z].*/.test(input);
    }

    function startsWithLowercase(input) {
        return /^[a-z]/.test(input);
    }

    function hasWordsStartingLowercase(input) {
        return /\b[a-z]/.test(input);
    }

    function hasWordsWithMultipleUppercase(input) {
        return /\b[A-Z]\w*[A-Z]/.test(input);
    }

    meerkat.modules.register('stringUtils', {
        isAllUppercase: isAllUppercase,
        hasMultipleUppercase: hasMultipleUppercase,
        startsWithLowercase: startsWithLowercase,
        hasWordsStartingLowercase: hasWordsStartingLowercase,
        hasWordsWithMultipleUppercase: hasWordsWithMultipleUppercase
    });

})(jQuery);
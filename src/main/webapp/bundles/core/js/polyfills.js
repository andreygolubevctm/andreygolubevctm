;(function ($, undefined) {

    var meerkat = window.meerkat,
        noButtons = document.createElement('button').type === 'button';

//This file defines additional polyfills to those already included in the meerkat and meerkat.logging:

    // included in Meerkat.logging - Mozilla implementation of Array.indexOf, for IE < 9
    // See http://stackoverflow.com/questions/143847/best-way-to-find-an-item-in-a-javascript-array

    // included in Meerkat.logging - Mozilla implementation of ISODateString call
    // https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference:Global_Objects:Date

    // included in Meerkat.logging - JSON support for older browsers. Public domain.
    // https://github.com/douglascrockford/JSON-js/blob/master/json2.js

    // included in Meerkat.logging - Universal stack trace method. Public domain.
    // https://raw.github.com/eriwen/javascript-stacktrace/master/stacktrace.js

    // included in Meerkat.logging - IE9/IEx Console patch.

    function initPolyfills() {

        $(document).ready(function () {

            // Internet Explorer 10 in Windows 8 and Windows Phone 8
            // Internet Explorer 10 doesn't differentiate device width from viewport width, and thus doesn't properly apply the media queries in Bootstrap's CSS.
            // For more information and usage guidelines, read Windows Phone 8 and Device-Width.
            if (navigator.userAgent.match(/IEMobile\/10\.0/)) {
                var msViewportStyle = document.createElement("style");
                msViewportStyle.appendChild(
                    document.createTextNode(
                        "@-ms-viewport{width:auto!important}"
                    )
                );
                document.getElementsByTagName("head")[0].appendChild(msViewportStyle);
            }

            //This just fixes ie's stupid lack of button type=submit support (instead of input type submit)
            if (noButtons) {
                $(document).on('click', 'form button[type="submit"]', function (event) {
                    event.preventDefault();
                    $(this).closest('form').submit();
                })/*.on('keypress', 'form input', function (event) {
                 if (event.which === 13) {
                 $(this).closest('form').submit();
                 }
                 })*/;
            }

            //Add the needsclick class to an element to prevent the behaviour.
            if (Modernizr.touch) {
                // yepnope.injectJs(meerkat.site.urls.base + 'assets/js/bundles/plugins/fastclick' + meerkat.site.minifiedFileString + '.js', function initFastClick() {
                //     FastClick.attach(document.body);
                // });
            }

            // Add the startsWith ES6 prototype method
            if (!String.prototype.startsWith) {
                String.prototype.startsWith = function (searchString, position) {
                    position = position || 0;
                    return this.indexOf(searchString, position) === position;
                };
            }
            // https://tc39.github.io/ecma262/#sec-array.prototype.find
            if (!Array.prototype.find) {
              Object.defineProperty(Array.prototype, 'find', {
                value: function(predicate) {
                 // 1. Let O be ? ToObject(this value).
                  if (this == null) {
                    throw new TypeError('"this" is null or not defined');
                  }

                  var o = Object(this);

                  // 2. Let len be ? ToLength(? Get(O, "length")).
                  var len = o.length >>> 0;

                  // 3. If IsCallable(predicate) is false, throw a TypeError exception.
                  if (typeof predicate !== 'function') {
                    throw new TypeError('predicate must be a function');
                  }

                  // 4. If thisArg was supplied, let T be thisArg; else let T be undefined.
                  var thisArg = arguments[1];

                  // 5. Let k be 0.
                  var k = 0;

                  // 6. Repeat, while k < len
                  while (k < len) {
                    // a. Let Pk be ! ToString(k).
                    // b. Let kValue be ? Get(O, Pk).
                    // c. Let testResult be ToBoolean(? Call(predicate, T, « kValue, k, O »)).
                    // d. If testResult is true, return kValue.
                    var kValue = o[k];
                    if (predicate.call(thisArg, kValue, k, o)) {
                      return kValue;
                    }
                    // e. Increase k by 1.
                    k++;
                  }

                  // 7. Return undefined.
                  return undefined;
                }
              });
            }
        });
    }

    meerkat.modules.register("polyfills", {
        init: initPolyfills
    });

})(jQuery);
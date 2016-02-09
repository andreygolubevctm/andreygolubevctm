// yepnope.js
// v2.0.0
//
// by
// Alex Sexton - @slexaxton - alexsexton[at]gmail.com
// Ralph Holzmann - @rlph - ralphholzmann[at]gmail.com
//
// http://yepnopejs.com/
// https://github.com/SlexAxton/yepnope.js/
//

/**
 * Modified by Ben Thompson <ben.thompson@comparethemarket.com.au> to remove the useless yepnope function, which only served to create a URL that we would have to construct an endpoint to interpret and generate scripts on the fly, which is ultimately useless to us.
 * Also removed the isOldIE Check, as that assumes that the request is JSONP, instead of an actual javascript file (it breaks all IE)
 * Also removed a few unused functions and variables.
 */
window.yepnope = (function (window, document, undef) {
    // Yepnope's style is intentionally very flat to aid in
    // minification. The authors are usually against too much
    // self-minification, but in the case of a script loader, we're
    // especially file size sensitive.

    // Some aliases
    var sTimeout = window.setTimeout;
    var firstScript;

    function noop(){}

    // Helper functions
    function isObject(obj) {
        return Object(obj) === obj;
    }

    function isString(s) {
        return typeof s == 'string';
    }

    function readFirstScript() {
        if (!firstScript || !firstScript.parentNode) {
            firstScript = document.getElementsByTagName('script')[0];
        }
    }

    function isFileReady(readyState) {
        // Check to see if any of the ways a file can be ready are available as properties on the file's element
        return (!readyState || readyState == 'loaded' || readyState == 'complete' || readyState == 'uninitialized');
    }

    function runWhenReady(src, cb) {
        cb.call(window);
    }

    // Inject a script into the page and know when it's done
    function injectJs(options, cb) {
        var src;
        var attrs;
        var timeout;

        if (isString(options)) {
            src = options;
        }
        else if (isObject(options)) {
            // Allow rewritten url to take precedence
            src = options._url || options.src;
            attrs = options.attrs;
            timeout = options.timeout;
        }

        cb = cb || noop;
        attrs = attrs || {};

        var script = document.createElement('script');
        var done;
        var i;

        timeout = timeout || yepnope.errorTimeout;

        script.src = src;

        // Add our extra attributes to the script element
        for (i in attrs) {
            if(attrs.hasOwnProperty(i)) {
                script.setAttribute(i, attrs[i]);
            }
        }

        // Bind to load events
        script.onreadystatechange = script.onload = function () {

            if ( !done && isFileReady(script.readyState) ) {
                // Set done to prevent this function from being called twice.
                done = 1;

                // Just run the callback
                runWhenReady(src, cb);
            }

            // Handle memory leak in IE
            script.onload = script.onreadystatechange = script.onerror = null;
        };

        // This won't work in every browser, but
        // would be helpful in those that it does.
        // http://stackoverflow.com/questions/2027849/how-to-trigger-script-onerror-in-internet-explorer/2032014#2032014
        // For those that don't support it, the timeout will be the backup
        script.onerror = function () {
            // Don't call the callback again, so we mark it done
            done = 1;
            cb(new Error('Script Error: ' + src));
            // We don't waste bytes on cleaning up memory in error cases
            // because hopefully it doesn't happen often enough to matter.
            // And you're probably already in an 'uh-oh' situation.
        };

        // 404 Fallback
        sTimeout(function () {
            // Don't do anything if the script has already finished
            if (!done) {
                // Mark it as done, which means the callback won't run again
                done = 1;

                // Might as well pass in an error-state if we fire the 404 fallback
                cb(new Error('Timeout: ' + src));
                // Maybe...
                script.parentNode.removeChild(script);
            }
        }, timeout);

        // Inject script into to document
        readFirstScript();
        firstScript.parentNode.insertBefore(script, firstScript);
    }

    function injectCss(options, cb) {
        var attrs = {};
        var href;
        var i;

        // optionally accept an object of settings
        // or a string that's the url
        if (isObject(options)) {
            // allow the overriden _url property to take precendence
            href = options._url || options.href;
            attrs = options.attrs || {};
        }
        else if (isString(options)) {
            href = options;
        }

        // Create stylesheet link
        var link = document.createElement('link');

        cb = cb || noop;

        // Add attributes
        link.href = href;
        link.rel = 'stylesheet';
        // Technique to force non-blocking loading from:
        // https://github.com/filamentgroup/loadCSS/blob/master/loadCSS.js#L20
        link.media = 'only x';
        link.type = 'text/css';

        // On next tick, just set the media to what it's supposed to be
        sTimeout(function() {
            link.media = attrs.media || 'all';
        });

        // Add our extra attributes to the link element
        for (i in attrs) {
            if(attrs.hasOwnProperty(i)) {
                link.setAttribute(i, attrs[i]);
            }
        }

        readFirstScript();
        // We append link tags so the cascades work as expected.
        // A little more dangerous, but if you're injecting CSS
        // dynamically, you probably can handle it.
        firstScript.parentNode.appendChild(link);

        // Always just run the callback for CSS on next tick. We're not
        // going to try to normalize this, so don't worry about runwhenready here.
        sTimeout(function() {
            cb.call(window);
        });
    }

    var yepnope = {};
    // Add a default for the error timer
    yepnope.errorTimeout = 10e3;
    // Expose no BS script injection
    yepnope.injectJs = injectJs;
    // Expose super-lightweight css injector
    yepnope.injectCss = injectCss;

    return yepnope;
})(window, document);
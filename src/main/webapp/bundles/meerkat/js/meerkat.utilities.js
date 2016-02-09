// Add any utilities here that should appear before modules are added, but after other meerkat libraries.

/**
 * The template settings used by underscore templating.
 * @type {{evaluate: RegExp, interpolate: RegExp, escape: RegExp}}
 */
_.templateSettings = {
    evaluate: /\{\{(.+?)\}\}/g,
    interpolate: /\{\{=(.+?)\}\}/g,
    escape: /\{\{-(.+?)\}\}/g
};
/**
 * byString is used in Results to find a nested object from a strong.
 * @param o
 * @param s
 * @returns {*}
 */

Object.byString = function (o, s) {
    try {
        s = s.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
        s = s.replace(/^\./, ''); // strip a leading dot
        var a = s.split('.');
        while (a.length) {
            var n = a.shift();
            if (typeof (o) == "object") {
                if (n in o) {
                    o = o[n];
                } else {
                    return;
                }
            } else
                return false;
        }
        return o;
    } catch (e) {
        return false;
    }
};

function showDoc(url, title) {
    if (title) {
        title = title.replace(/ /g, "_");
    }
    window.open(url, title, "width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");
}

/* Shim for ECMA-262 level browsers (NOT ES5 or JS1.6 level) that don't
 * support the Array.filter method. This would be ie8, ie7 etc etc.
 * This works, assuming no other shims are in effect on object,
 * typeError, fun.call is Function.prototype.call, and
 * Array.prototype.push is in it's original value too. From:
 * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter
 * */
if (!Array.prototype.filter) {
    Array.prototype.filter = function (fun /*, thisp*/) {
        'use strict';
        if (!this) {
            throw new TypeError();
        }
        var objects = Object(this);
        objects.length >>> 0;
        if (typeof fun !== 'function') {
            throw new TypeError();
        }
        var res = [];
        var thisp = arguments[1];
        for (var i in objects) {
            if (objects.hasOwnProperty(i)) {
                if (fun.call(thisp, objects[i], i, objects)) {
                    res.push(objects[i]);
                }
            }
        }
        return res;
    };
}
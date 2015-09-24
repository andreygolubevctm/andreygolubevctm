// Add any utilities here that should appear before modules are added, but after other meerkat libraries.

var _tmplCache = {};
window.parseTemplate = function(str, data) {
    /// <summary>
    /// Client side template parser that uses &lt;#= #&gt; and &lt;# code #&gt; expressions.
    /// and # # code blocks for template expansion.
    /// NOTE: chokes on single quotes in the document in some situations
    ///       use &amp;rsquo; for literals in text and avoid any single quote
    ///       attribute delimiters.
    /// </summary>
    /// <param name="str" type="string">The text of the template to expand</param>
    /// <param name="data" type="var">
    /// Any data that is to be merged. Pass an object and
    /// that object's properties are visible as variables.
    /// </param>
    /// <returns type="string" />
    /// http://ejohn.org/blog/javascript-micro-templating/
    var err = "";
    try {
        var func = _tmplCache[str];
        if (!func) {
            var strFunc =
                "var p=[],print=function(){p.push.apply(p,arguments);};" +
                "with(obj){p.push('" +
                str.replace(/[\r\t\n]/g, " ")
                    .replace(/'(?=[^#]*#\])/g, "\t")
                    .split("'").join("\\'")
                    .split("\t").join("'")
                    .replace(/\[#=(.+?)#\]/g, "',$1,'")
                    .split("[#").join("');")
                    .split("#]").join("p.push('")
                + "');}return p.join('');";

            /*jshint -W054 */
            func = new Function("obj", strFunc);
            _tmplCache[str] = func;
        }
        return func(data);
    } catch (e) { err = e.message; }
    return "< # ERROR: " + err + " # >";
};

/**
 * byString is used in Results to find a nested object from a strong.
 * @param o
 * @param s
 * @returns {*}
 */

Object.byString = function(o, s) {
    try{
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
    } catch (e){
        return false;
    }
};

function showDoc(url,title){
    if (title) {
        title=title.replace(/ /g,"_");
    }
    window.open(url,title,"width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");
}

/* Shim for ECMA-262 level browsers (NOT ES5 or JS1.6 level) that don't
 * support the Array.filter method. This would be ie8, ie7 etc etc.
 * This works, assuming no other shims are in effect on object,
 * typeError, fun.call is Function.prototype.call, and
 * Array.prototype.push is in it's original value too. From:
 * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter
 * */
if (!Array.prototype.filter) {
    Array.prototype.filter = function(fun /*, thisp*/) {
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
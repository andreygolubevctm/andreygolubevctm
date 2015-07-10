/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat, settings;
    meerkat = window.meerkat = window.meerkat || {};
    settings = {};
    meerkat.messaging = {};
    meerkat.messaging.channels = {};
    meerkat.messaging.subscribe = function(channel, fn, context) {
        handler = {
            callback: fn,
            context: context || window
        };
        if (!meerkat.messaging.channels[channel]) {
            meerkat.messaging.channels[channel] = [];
        }
        meerkat.messaging.channels[channel].push(handler);
        return handler;
    };
    meerkat.messaging.unsubscribe = function(channel, handler) {
        var channelArray = meerkat.messaging.channels[channel];
        if (meerkat.messaging.channels[channel]) {
            var objectIndex = channelArray.indexOf(handler);
            if (objectIndex > -1) {
                channelArray.splice(objectIndex, 1);
                return true;
            }
        }
        return false;
    };
    meerkat.messaging.publish = function(channel) {
        var args;
        if (!meerkat.messaging.channels[channel]) {
            return false;
        }
        args = Array.prototype.slice.call(arguments, 1);
        for (var i = 0; i < meerkat.messaging.channels[channel].length; i++) {
            var subscription = meerkat.messaging.channels[channel][i];
            subscription.callback.apply(subscription.context, args);
        }
        return this;
    };
    meerkat.site = {};
    meerkat.site.init = function(siteConfig) {
        $.extend(meerkat, {
            site: siteConfig
        });
    };
    meerkat.getModule = function(target, type, subtype) {
        var module = $(target).closest("[data-module]"), isModule = function() {
            var result = true;
            if (!module.length || !module.data("module")) {
                return false;
            }
            if (type) {
                result = result && module.data("module").type === type;
            }
            if (subtype) {
                result = result && module.data("module").subtype === subtype;
            }
            return result;
        };
        isModule(module);
        while (!isModule(module) && module.length) {
            module = module.parent().closest("[data-module]");
        }
        return isModule(module) && module;
    };
    meerkat.init = function(siteConfig, options) {
        $.extend(settings, options || {});
        meerkat.site.init(siteConfig);
        meerkat.logging.init();
        meerkat.modules.init();
    };
})(jQuery);

meerkat.logging = {};

var Driftwood = new function() {
    this.logger = function() {
        var levels = [ "NONE", "DEBUG", "INFO", "ERROR", "EXCEPTION", "NONE" ];
        var config = {
            consoleLevel: "DEBUG",
            consoleLevelId: 0,
            exceptionLevel: "NONE",
            exceptionLevelId: 99,
            mode: "development",
            serverPath: "/exceptions/notify?payload=",
            applicationName: "js_client",
            cors: true
        };
        var findLevel = function(level) {
            return levels.indexOf(level.toUpperCase());
        };
        function genScriptTag(src) {
            var script = document.createElement("script");
            script.src = src;
            document.body.appendChild(script);
        }
        function postViaAjax(src, data) {
            debugger;
        }
        function genExceptionUrl(error) {
            var url = config.serverPath + encodeURIComponent(JSON.stringify(error));
            return url;
        }
        function createBlackBox(error) {
            var blackBox = {
                application_name: config.applicationName,
                message: error || "",
                url: window.location.toString(),
                language: "javascript",
                custom_data: {
                    hostname: window.location.hostname,
                    user_agent: navigator.userAgent || "",
                    referrer: document.referrer || "",
                    cookies: document.cookie || ""
                },
                backtrace: getBackTrace(error),
                exception_class: "Javascript#Unknown"
            };
            return blackBox;
        }
        function getBackTrace(message, url, line) {
            var backTrace = [ "no backtrace" ];
            if (typeof message === "object") {
                backTrace = printStackTrace({
                    e: message
                });
            } else {
                backTrace = printStackTrace();
            }
            return backTrace;
        }
        function transmit(message, additionalData) {
            var e = null;
            if (typeof message === "object") {
                e = message;
                message = e.message;
            }
            var error = createBlackBox(message, additionalData);
            var src = genExceptionUrl(error);
            if (config.cors === true) {
                genScriptTag(src);
            } else {
                postViaAjax(src);
            }
        }
        var loggedMessages = [];
        function hasLoggedMessage(errorString) {
            for (var i = 0; i < loggedMessages.length; i++) {
                if (loggedMessages[i] === errorString) return true;
            }
            return false;
        }
        function log(args, level, fn) {
            var levelId = findLevel(level);
            var d = new Date();
            var originalErrorMessage = args[0];
            if (levelId >= config.consoleLevelId) {
                args[0] = level + ":" + "[" + ISODateString(d) + "] " + args[0];
            }
            if (levelId >= config.exceptionLevelId) {
                var message = "Sorry, we have encountered an error. Please try again.";
                if (config.mode == "development") {
                    message += "[" + originalErrorMessage + "]";
                }
                var logDetails = {
                    errorLevel: "silent",
                    page: "meerkat.logging.js",
                    message: message,
                    description: originalErrorMessage
                };
                var logReferenceObject = {
                    message: logDetails.message,
                    page: logDetails.page
                };
                if (meerkat.site.useNewLogging) {
                    logDetails.data = {};
                    if (typeof args[1] !== "undefined") {
                        logDetails.data.stack = args[1];
                        logDetails.data.stack.error = args[0];
                        logReferenceObject.stack = logDetails.data.stack.stack;
                    } else {
                        logDetails.data.stack = args[0];
                    }
                    logDetails.data.browser = {
                        userAgent: navigator.userAgent || "",
                        referrer: document.referrer || "",
                        cookiesEnabled: navigator.cookieEnabled || ""
                    };
                }
                var logReference = JSON.stringify(logReferenceObject).replace(/\s{1,}/g, " ");
                if (!hasLoggedMessage(logReference)) {
                    meerkat.modules.errorHandling.error(logDetails);
                    loggedMessages.push(logReference);
                }
            }
            if (config.mode !== "production" && navigator.appName != "Microsoft Internet Explorer") {
                if (typeof fn !== "undefined" && typeof fn.apply === "function") {
                    fn.apply(console, Array.prototype.slice.call(args));
                }
            }
        }
        return {
            setServerPath: function(murl) {
                config.serverPath = murl;
            },
            env: function(menv) {
                menv = menv.toLowerCase();
                if (menv == "development") {
                    config.consoleLevel = "DEBUG";
                    config.exceptionLevel = "none";
                    config.consoleLevelId = 0;
                    config.exceptionLevelId = 4;
                    config.mode = menv;
                } else if (menv == "production") {
                    config.consoleLevel = "ERROR";
                    config.exceptionLevel = "none";
                    config.consoleLevelId = 2;
                    config.exceptionLevelId = 3;
                    config.mode = menv;
                } else {
                    console.log("Unknown environment level");
                }
            },
            applicationName: function(appname) {
                config.applicationName = appname;
            },
            logLevel: function(level) {
                var id = findLevel(level);
                if (id > -1) {
                    config.consoleLevel = level.toUpperCase();
                    config.consoleLevelId = id;
                } else {
                    console.log("Setting an invalid log level: " + level);
                }
            },
            exceptionLevel: function(level) {
                var id = findLevel(level);
                if (id > -1) {
                    config.exceptionLevel = level.toUpperCase();
                    config.exceptionLevelId = id;
                } else {
                    console.log("Setting an invalid log level: " + level);
                }
            },
            debug: function() {
                log(arguments, "DEBUG", console.debug);
            },
            info: function() {
                log(arguments, "INFO", console.info);
            },
            error: function() {
                log(arguments, "ERROR", console.error);
            },
            exception: function(args) {
                log(args, "EXCEPTION", console.error);
            }
        };
    };
    defaultLogger = new this.logger();
    this.exception = function() {
        defaultLogger.exception(arguments);
    };
    this.applicationName = function(appname) {
        defaultLogger.applicationName(appname);
    };
    this.debug = defaultLogger.debug;
    this.info = defaultLogger.info;
    this.error = defaultLogger.error;
    this.env = function(mode) {
        defaultLogger.env(mode);
    };
    this.setServerPath = function(u) {
        defaultLogger.setServerPath(u);
    };
    this.exceptionLevel = function(level) {
        if (level != "NONE") {
            defaultLogger.exceptionLevel(level);
        } else {
            this.debug = _.bind(console.debug, console);
            this.info = _.bind(console.info, console);
            this.error = _.bind(console.error, console);
            this.log = _.bind(console.log, console);
        }
    };
    this.logLevel = function(level) {
        defaultLogger.logLevel(level);
    };
}();

if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(searchElement) {
        "use strict";
        if (this === void 0 || this === null) throw new TypeError();
        var t = Object(this);
        var len = t.length >>> 0;
        if (len === 0) return -1;
        var n = 0;
        if (arguments.length > 0) {
            n = Number(arguments[1]);
            if (n !== n) n = 0; else if (n !== 0 && n !== 1 / 0 && n !== -(1 / 0)) n = (n > 0 || -1) * Math.floor(Math.abs(n));
        }
        if (n >= len) return -1;
        var k = n >= 0 ? n : Math.max(len - Math.abs(n), 0);
        for (;k < len; k++) {
            if (k in t && t[k] === searchElement) return k;
        }
        return -1;
    };
}

function ISODateString(d) {
    function pad(n) {
        return n < 10 ? "0" + n : n;
    }
    return d.getUTCFullYear() + "-" + pad(d.getUTCMonth() + 1) + "-" + pad(d.getUTCDate()) + "T" + pad(d.getUTCHours()) + ":" + pad(d.getUTCMinutes()) + ":" + pad(d.getUTCSeconds()) + "Z";
}

var JSON;

JSON || (JSON = {}), function() {
    function f(a) {
        return a < 10 ? "0" + a : a;
    }
    function quote(a) {
        return escapable.lastIndex = 0, escapable.test(a) ? '"' + a.replace(escapable, function(a) {
            var b = meta[a];
            return typeof b == "string" ? b : "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + a + '"';
    }
    function str(a, b) {
        var c, d, e, f, g = gap, h, i = b[a];
        i && typeof i == "object" && typeof i.toJSON == "function" && (i = i.toJSON(a)), 
        typeof rep == "function" && (i = rep.call(b, a, i));
        switch (typeof i) {
          case "string":
            return quote(i);

          case "number":
            return isFinite(i) ? String(i) : "null";

          case "boolean":
          case "null":
            return String(i);

          case "object":
            if (!i) return "null";
            gap += indent, h = [];
            if (Object.prototype.toString.apply(i) === "[object Array]") {
                f = i.length;
                for (c = 0; c < f; c += 1) h[c] = str(c, i) || "null";
                return e = h.length === 0 ? "[]" : gap ? "[\n" + gap + h.join(",\n" + gap) + "\n" + g + "]" : "[" + h.join(",") + "]", 
                gap = g, e;
            }
            if (rep && typeof rep == "object") {
                f = rep.length;
                for (c = 0; c < f; c += 1) typeof rep[c] == "string" && (d = rep[c], e = str(d, i), 
                e && h.push(quote(d) + (gap ? ": " : ":") + e));
            } else for (d in i) Object.prototype.hasOwnProperty.call(i, d) && (e = str(d, i), 
            e && h.push(quote(d) + (gap ? ": " : ":") + e));
            return e = h.length === 0 ? "{}" : gap ? "{\n" + gap + h.join(",\n" + gap) + "\n" + g + "}" : "{" + h.join(",") + "}", 
            gap = g, e;
        }
    }
    "use strict", typeof Date.prototype.toJSON != "function" && (Date.prototype.toJSON = function(a) {
        return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null;
    }, String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function(a) {
        return this.valueOf();
    });
    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, gap, indent, meta = {
        "\b": "\\b",
        "	": "\\t",
        "\n": "\\n",
        "\f": "\\f",
        "\r": "\\r",
        '"': '\\"',
        "\\": "\\\\"
    }, rep;
    typeof JSON.stringify != "function" && (JSON.stringify = function(a, b, c) {
        var d;
        gap = "", indent = "";
        if (typeof c == "number") for (d = 0; d < c; d += 1) indent += " "; else typeof c == "string" && (indent = c);
        rep = b;
        if (!b || typeof b == "function" || typeof b == "object" && typeof b.length == "number") return str("", {
            "": a
        });
        throw new Error("JSON.stringify");
    }), typeof JSON.parse != "function" && (JSON.parse = function(text, reviver) {
        function walk(a, b) {
            var c, d, e = a[b];
            if (e && typeof e == "object") for (c in e) Object.prototype.hasOwnProperty.call(e, c) && (d = walk(e, c), 
            d !== undefined ? e[c] = d : delete e[c]);
            return reviver.call(a, b, e);
        }
        var j;
        text = String(text), cx.lastIndex = 0, cx.test(text) && (text = text.replace(cx, function(a) {
            return "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4);
        }));
        if (/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, ""))) return j = eval("(" + text + ")"), 
        typeof reviver == "function" ? walk({
            "": j
        }, "") : j;
        throw new SyntaxError("JSON.parse");
    });
}();

function printStackTrace(a) {
    a = a || {
        guess: !0
    };
    var b = a.e || null;
    a = !!a.guess;
    var c = new printStackTrace.implementation(), b = c.run(b);
    return a ? c.guessAnonymousFunctions(b) : b;
}

printStackTrace.implementation = function() {};

printStackTrace.implementation.prototype = {
    run: function(a, b) {
        a = a || this.createException();
        b = b || this.mode(a);
        return "other" === b ? this.other(arguments.callee) : this[b](a);
    },
    createException: function() {
        try {
            this.undef();
        } catch (a) {
            return a;
        }
    },
    mode: function(a) {
        return a.arguments && a.stack ? "chrome" : a.stack && a.sourceURL ? "safari" : a.stack && a.number ? "ie" : a.stack && a.fileName ? "firefox" : a.message && a["opera#sourceloc"] ? !a.stacktrace || -1 < a.message.indexOf("\n") && a.message.split("\n").length > a.stacktrace.split("\n").length ? "opera9" : "opera10a" : a.message && a.stack && a.stacktrace ? 0 > a.stacktrace.indexOf("called from line") ? "opera10b" : "opera11" : a.stack && !a.fileName ? "chrome" : "other";
    },
    instrumentFunction: function(a, b, c) {
        a = a || window;
        var d = a[b];
        a[b] = function() {
            c.call(this, printStackTrace().slice(4));
            return a[b]._instrumented.apply(this, arguments);
        };
        a[b]._instrumented = d;
    },
    deinstrumentFunction: function(a, b) {
        a[b].constructor === Function && a[b]._instrumented && a[b]._instrumented.constructor === Function && (a[b] = a[b]._instrumented);
    },
    chrome: function(a) {
        return (a.stack + "\n").replace(/^[\s\S]+?\s+at\s+/, " at ").replace(/^\s+(at eval )?at\s+/gm, "").replace(/^([^\(]+?)([\n$])/gm, "{anonymous}() ($1)$2").replace(/^Object.<anonymous>\s*\(([^\)]+)\)/gm, "{anonymous}() ($1)").replace(/^(.+) \((.+)\)$/gm, "$1@$2").split("\n").slice(0, -1);
    },
    safari: function(a) {
        return a.stack.replace(/\[native code\]\n/m, "").replace(/^(?=\w+Error\:).*$\n/m, "").replace(/^@/gm, "{anonymous}()@").split("\n");
    },
    ie: function(a) {
        return a.stack.replace(/^\s*at\s+(.*)$/gm, "$1").replace(/^Anonymous function\s+/gm, "{anonymous}() ").replace(/^(.+)\s+\((.+)\)$/gm, "$1@$2").split("\n").slice(1);
    },
    firefox: function(a) {
        return a.stack.replace(/(?:\n@:0)?\s+$/m, "").replace(/^(?:\((\S*)\))?@/gm, "{anonymous}($1)@").split("\n");
    },
    opera11: function(a) {
        var b = /^.*line (\d+), column (\d+)(?: in (.+))? in (\S+):$/;
        a = a.stacktrace.split("\n");
        for (var c = [], d = 0, f = a.length; d < f; d += 2) {
            var e = b.exec(a[d]);
            if (e) {
                var g = e[4] + ":" + e[1] + ":" + e[2], e = e[3] || "global code", e = e.replace(/<anonymous function: (\S+)>/, "$1").replace(/<anonymous function>/, "{anonymous}");
                c.push(e + "@" + g + " -- " + a[d + 1].replace(/^\s+/, ""));
            }
        }
        return c;
    },
    opera10b: function(a) {
        var b = /^(.*)@(.+):(\d+)$/;
        a = a.stacktrace.split("\n");
        for (var c = [], d = 0, f = a.length; d < f; d++) {
            var e = b.exec(a[d]);
            e && c.push((e[1] ? e[1] + "()" : "global code") + "@" + e[2] + ":" + e[3]);
        }
        return c;
    },
    opera10a: function(a) {
        var b = /Line (\d+).*script (?:in )?(\S+)(?:: In function (\S+))?$/i;
        a = a.stacktrace.split("\n");
        for (var c = [], d = 0, f = a.length; d < f; d += 2) {
            var e = b.exec(a[d]);
            e && c.push((e[3] || "{anonymous}") + "()@" + e[2] + ":" + e[1] + " -- " + a[d + 1].replace(/^\s+/, ""));
        }
        return c;
    },
    opera9: function(a) {
        var b = /Line (\d+).*script (?:in )?(\S+)/i;
        a = a.message.split("\n");
        for (var c = [], d = 2, f = a.length; d < f; d += 2) {
            var e = b.exec(a[d]);
            e && c.push("{anonymous}()@" + e[2] + ":" + e[1] + " -- " + a[d + 1].replace(/^\s+/, ""));
        }
        return c;
    },
    other: function(a) {
        for (var b = /function\s*([\w\-$]+)?\s*\(/i, c = [], d, f, e = Array.prototype.slice; a && a.arguments && 10 > c.length; ) {
            d = b.test(a.toString()) ? RegExp.$1 || "{anonymous}" : "{anonymous}";
            f = e.call(a.arguments || []);
            c[c.length] = d + "(" + this.stringifyArguments(f) + ")";
            try {
                a = a.caller;
            } catch (g) {
                c[c.length] = "" + g;
                break;
            }
        }
        return c;
    },
    stringifyArguments: function(a) {
        for (var b = [], c = Array.prototype.slice, d = 0; d < a.length; ++d) {
            var f = a[d];
            void 0 === f ? b[d] = "undefined" : null === f ? b[d] = "null" : f.constructor && (b[d] = f.constructor === Array ? 3 > f.length ? "[" + this.stringifyArguments(f) + "]" : "[" + this.stringifyArguments(c.call(f, 0, 1)) + "..." + this.stringifyArguments(c.call(f, -1)) + "]" : f.constructor === Object ? "#object" : f.constructor === Function ? "#function" : f.constructor === String ? '"' + f + '"' : f.constructor === Number ? f : "?");
        }
        return b.join(",");
    },
    sourceCache: {},
    ajax: function(a) {
        var b = this.createXMLHTTPObject();
        if (b) try {
            return b.open("GET", a, !1), b.send(null), b.responseText;
        } catch (c) {}
        return "";
    },
    createXMLHTTPObject: function() {
        for (var a, b = [ function() {
            return new XMLHttpRequest();
        }, function() {
            return new ActiveXObject("Msxml2.XMLHTTP");
        }, function() {
            return new ActiveXObject("Msxml3.XMLHTTP");
        }, function() {
            return new ActiveXObject("Microsoft.XMLHTTP");
        } ], c = 0; c < b.length; c++) try {
            return a = b[c](), this.createXMLHTTPObject = b[c], a;
        } catch (d) {}
    },
    isSameDomain: function(a) {
        return "undefined" !== typeof location && -1 !== a.indexOf(location.hostname);
    },
    getSource: function(a) {
        a in this.sourceCache || (this.sourceCache[a] = this.ajax(a).split("\n"));
        return this.sourceCache[a];
    },
    guessAnonymousFunctions: function(a) {
        for (var b = 0; b < a.length; ++b) {
            var c = /^(.*?)(?::(\d+))(?::(\d+))?(?: -- .+)?$/, d = a[b], f = /\{anonymous\}\(.*\)@(.*)/.exec(d);
            if (f) {
                var e = c.exec(f[1]);
                e && (c = e[1], f = e[2], e = e[3] || 0, c && this.isSameDomain(c) && f && (c = this.guessAnonymousFunction(c, f, e), 
                a[b] = d.replace("{anonymous}", c)));
            }
        }
        return a;
    },
    guessAnonymousFunction: function(a, b, c) {
        var d;
        try {
            d = this.findFunctionName(this.getSource(a), b);
        } catch (f) {
            d = "getSource failed with url: " + a + ", exception: " + f.toString();
        }
        return d;
    },
    findFunctionName: function(a, b) {
        for (var c = /function\s+([^(]*?)\s*\(([^)]*)\)/, d = /['"]?([$_A-Za-z][$_A-Za-z0-9]*)['"]?\s*[:=]\s*function\b/, f = /['"]?([$_A-Za-z][$_A-Za-z0-9]*)['"]?\s*[:=]\s*(?:eval|new Function)\b/, e = "", g, l = Math.min(b, 20), h, k = 0; k < l; ++k) if (g = a[b - k - 1], 
        h = g.indexOf("//"), 0 <= h && (g = g.substr(0, h)), g) if (e = g + e, (g = d.exec(e)) && g[1] || (g = c.exec(e)) && g[1] || (g = f.exec(e)) && g[1]) return g[1];
        return "(?)";
    }
};

if (typeof console == "undefined") {
    var console = {
        log: function() {}
    };
}

if (Function.prototype.bind && console && typeof console.log == "object") {
    [ "log", "info", "warn", "error", "assert", "dir", "clear", "profile", "profileEnd" ].forEach(function(method) {
        console[method] = this.bind(console[method], console);
    }, Function.prototype.call);
}

if (typeof console.debug == "undefined") {
    console.debug = console.log;
}

meerkat.logging.logger = Driftwood;

meerkat.logging.debug = meerkat.logging.logger.debug;

meerkat.logging.info = meerkat.logging.logger.info;

meerkat.logging.error = meerkat.logging.logger.error;

meerkat.logging.exception = meerkat.logging.logger.exception;

window.onerror = function(message, url, line) {
    Driftwood.exception(message, {
        url: url,
        line: line
    });
};

var wrapMethod, polyFill, hijackTimeFunctions;

function initializeNewLogging() {
    wrapMethod = function(func) {
        if (!func._wrapped) {
            func._wrapped = function() {
                try {
                    func.apply(this, arguments);
                } catch (e) {
                    if (e.message && e.fileName && e.lineNumber && e.columnNumber && e.stack) {
                        window.onerror(e.message, e.fileName, e.lineNumber, e.columnNumber, e);
                    } else if (e.message && e.sourceURL && e.line) {
                        window.onerror(e.message, e.sourceURL, e.line, null, e);
                    } else {
                        throw e;
                    }
                }
            };
        }
        return func._wrapped;
    };
    polyFill = function(obj, name, makeReplacement) {
        var original = obj[name];
        var replacement = makeReplacement(original);
        obj[name] = replacement;
        if (window.undo) {
            window.undo.push(function() {
                obj[name] = original;
            });
        }
    };
    hijackTimeFunctions = function(_super) {
        return function(f, t) {
            if (typeof f === "function") {
                f = wrapMethod(f);
                var args = Array.prototype.slice.call(arguments, 2);
                return _super(function() {
                    f.apply(this, args);
                }, t);
            } else {
                return _super(f, t);
            }
        };
    };
    window.onerror = function(message, file, line, column, error) {
        var column = column || window.event && window.event.errorCharacter;
        var stack = "";
        var url = file.substring(file.lastIndexOf("/ctm"), file.length);
        url = file.substring(file.lastIndexOf("/app"), file.length);
        if (!error) {
            stack = [];
            var f = arguments.callee.caller;
            while (f) {
                stack.push(f.name);
                f = f.caller;
            }
            stack = stack.join("");
        } else {
            stack = error.stack;
        }
        stack = stack.replace(/(\r\n|\n|\r)/gm, "");
        Driftwood.exception(message, {
            url: window.location.pathname + window.location.hash,
            file: url,
            line: parseInt(line),
            column: parseInt(column),
            stack: stack
        });
    };
    polyFill(window, "setTimeout", hijackTimeFunctions);
    polyFill(window, "setInterval", hijackTimeFunctions);
    if (window.requestAnimationFrame) {
        polyFill(window, "requestAnimationFrame", hijackTimeFunctions);
    }
    if (window.setImmediate) {
        polyFill(window, "setImmediate", function(_super) {
            return function(f) {
                var args = Array.prototype.slice.call(arguments);
                args[0] = wrapMethod(args[0]);
                return _super.apply(this, args);
            };
        });
    }
    "EventTarget Window Node ApplicationCache AudioTrackList ChannelMergerNode CryptoOperation EventSource FileReader HTMLUnknownElement IDBDatabase IDBRequest IDBTransaction KeyOperation MediaController MessagePort ModalWindow Notification SVGElementInstance Screen TextTrack TextTrackCue TextTrackList WebSocket WebSocketWorker Worker XMLHttpRequest XMLHttpRequestEventTarget XMLHttpRequestUpload".replace(/\w+/g, function(global) {
        var prototype = window[global] && window[global].prototype;
        if (prototype && prototype.hasOwnProperty && prototype.hasOwnProperty("addEventListener")) {
            polyFill(prototype, "addEventListener", function(_super) {
                return function(e, f, capture, secure) {
                    if (f && f.handleEvent) {
                        f.handleEvent = wrapMethod(f.handleEvent, {
                            eventHandler: true
                        });
                    }
                    return _super.call(this, e, wrapMethod(f, {
                        eventHandler: true
                    }), capture, secure);
                };
            });
            polyFill(prototype, "removeEventListener", function(_super) {
                return function(e, f, capture, secure) {
                    _super.call(this, e, f, capture, secure);
                    return _super.call(this, e, wrapMethod(f), capture, secure);
                };
            });
        }
    });
}

meerkat.logging.init = function() {
    if (meerkat.site.useNewLogging) {}
    var theAppName = "";
    if (meerkat.site.vertical !== "") {
        theAppName = "[" + meerkat.site.vertical + "]";
    } else {
        theAppName = "";
    }
    meerkat.logging.logger.applicationName(theAppName);
    var devStateString = meerkat.site.showLogging ? "development" : "production";
    meerkat.logging.logger.env(devStateString);
    meerkat.logging.info("[logging]", "Sergei sees you runnings on " + meerkat.site.environment + " (" + devStateString + "s " + "mode).");
};

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info, modules = {}, events = {}, initStack = [];
    function register(moduleName, module) {
        if (modules[moduleName]) {
            throw "A module is already defined with the key: " + moduleName;
        }
        modules[moduleName] = module;
        modules[moduleName].moduleName = moduleName;
        if (typeof module.init === "function") {
            initStack.push(moduleName);
        }
        if (typeof module.events === "function") {
            $.extend(true, events, modules[moduleName].events());
        } else if (typeof modules.events === "object") {
            $.extend(true, events, modules[moduleName].events);
        }
    }
    function initialiseModules() {
        initStack = initStack.reverse();
        while (initStack.length) {
            var moduleName = initStack.pop();
            modules[moduleName].init();
        }
    }
    modules = meerkat.modules = {
        register: register,
        init: initialiseModules
    };
    meerkat.modules.events = events;
})(jQuery);

var Results = new Object();

Results = {
    view: new Object(),
    model: new Object(),
    moduleEvents: {
        RESULTS_INITIALISED: "RESULTS_INITIALISED",
        RESULTS_ERROR: "RESULTS_ERROR"
    },
    init: function(userSettings) {
        Results.view = ResultsView;
        Results.model = ResultsModel;
        Results.pagination = ResultsPagination;
        var settings = {
            url: "ajax/json/results.jsp",
            formSelector: "#mainform",
            runShowResultsPage: true,
            paths: {
                results: {
                    rootElement: "results",
                    list: "results.result",
                    general: "results.info",
                    errors: "error"
                },
                price: {
                    annually: "price.annual.total",
                    quarterly: "price.quarterly.total",
                    monthly: "price.monthly.total",
                    fortnightly: "price.fortnightly.total",
                    weekly: "price.weekly.total",
                    daily: "price.daily.total"
                },
                availability: {
                    price: {
                        annually: "price.annual.available",
                        quarterly: "price.quarterly.available",
                        monthly: "price.monthly.available",
                        fortnightly: "price.fortnightly.available",
                        weekly: "price.weekly.available",
                        daily: "price.daily.available"
                    },
                    product: "productAvailable"
                },
                productId: "productId",
                features: "compareFeatures.features"
            },
            sort: {
                sortBy: "price.annually",
                sortByMethod: Results.model.defaultSortMethod,
                sortDir: "asc"
            },
            frequency: "annually",
            displayMode: "price",
            pagination: {
                mode: "slide",
                touchEnabled: false,
                emptyContainerFunction: false,
                afterPaginationRefreshFunction: false
            },
            availability: {
                product: [ "equals", "Y" ],
                price: [ "equals", "Y" ]
            },
            animation: {
                results: {
                    individual: {
                        active: true,
                        delay: -50,
                        acceleration: 25
                    },
                    delay: 100,
                    options: {
                        effect: "slide",
                        direction: "right",
                        easing: "easeInOutQuart",
                        duration: 400
                    }
                },
                shuffle: {
                    active: true,
                    options: {
                        duration: 400,
                        easing: "easeInOutQuart",
                        queue: "shuffle"
                    }
                },
                filter: {
                    active: true,
                    queue: "filter",
                    reposition: {
                        options: {
                            duration: 1e3,
                            easing: "easeInOutQuart"
                        }
                    },
                    appear: {
                        options: {
                            duration: 1200
                        }
                    },
                    disappear: {
                        options: {
                            duration: 1e3
                        }
                    }
                },
                features: {
                    scroll: {
                        active: true,
                        duration: 1e3,
                        percentage: 1
                    }
                }
            },
            elements: {
                frequency: ".frequency",
                reviseButton: ".reviseButton",
                page: "#resultsPage",
                container: ".results-table",
                rows: ".result-row",
                productHeaders: ".result",
                templates: {
                    result: "#result-template",
                    unavailable: "#unavailable-template",
                    unavailableCombined: "#unavailable-combined-template",
                    error: "#error-template",
                    currentProduct: "#current-product-template",
                    feature: "#feature-template"
                },
                noResults: ".noResults",
                resultsFetchError: ".resultsFetchError",
                resultsContainer: ".resultsContainer",
                resultsOverflow: ".resultsOverflow",
                features: {
                    headers: ".featuresHeaders",
                    list: ".featuresList",
                    allElements: ".featuresElements",
                    expandable: ".expandable",
                    expandableHover: ".expandableHover",
                    values: ".featuresValues",
                    extras: ".featuresExtras"
                }
            },
            render: {
                templateEngine: "microTemplate",
                features: {
                    mode: "build",
                    headers: true,
                    expandRowsOnComparison: true,
                    numberOfXSColumns: 2
                },
                dockCompareBar: true
            },
            templates: {
                pagination: {
                    pageItem: '<li><a class="btn-pagination" data-results-pagination-control="{{= pageNumber}}">{{= label}}</a></li>',
                    pageText: "Page {{=currentPage}} of {{=totalPages}}"
                }
            },
            show: {
                featuresCategories: true,
                topResult: true,
                currentProduct: true,
                nonAvailableProducts: true,
                nonAvailablePrices: true,
                savings: true,
                unavailableCombined: false
            },
            dictionary: {
                loadingMessage: "Loading Your Quotes...",
                valueMap: []
            },
            rankings: {
                filterUnavailableProducts: true
            },
            incrementTransactionId: true
        };
        $.extend(true, settings, userSettings);
        Results.settings = settings;
        Results.view.$containerElement = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.container);
        Results.pagination.init();
        Results.view.setDisplayMode(Results.settings.displayMode, true);
        if (typeof meerkat !== "undefined") {
            meerkat.messaging.publish(Results.moduleEvents.RESULTS_INITIALISED);
        }
    },
    get: function(url, data) {
        Results.model.fetch(url, data);
    },
    render: function() {
        Results.view.show();
        Results.pagination.refresh();
    },
    reset: function() {
        $(Results.settings.elements.resultsContainer).trigger("resultsReset");
        Results.model.flush();
        Results.pagination.reset();
        if (typeof QuoteEngine != "undefined") QuoteEngine.updateAddress();
    },
    reviseDetails: function() {
        if (typeof QuoteEngine !== "undefined") QuoteEngine.setOnResults(false);
        if (typeof Track !== "undefined" && typeof Track.quoteLoadRefresh !== "undefined") {
            Track.quoteLoadRefresh("Refresh");
        }
        Results.view.toggleResultsPage();
        Results.reset();
    },
    sortBy: function(sortBy, sortDir) {
        if (Results.setSortBy(sortBy)) {
            if (sortDir) {
                Results.setSortDir(sortDir);
            }
            Results.model.sort();
            return true;
        } else {
            return false;
        }
    },
    getSortBy: function() {
        return Results.settings.sort.sortBy;
    },
    getSortByMethod: function() {
        return Results.settings.sort.sortByMethod;
    },
    getSortDir: function() {
        return Results.settings.sort.sortDir;
    },
    setSortBy: function(sortBy) {
        if (typeof Object.byString(Results.settings.paths, sortBy) !== "undefined") {
            Results.settings.sort.sortBy = sortBy;
            return true;
        }
        console.log("Results.setSortBy() has been called but it could not find the path to the property it should be sorted by: sortBy=", sortBy);
        return false;
    },
    setSortByMethod: function(sortByMethod) {
        if (typeof sortByMethod === "function") {
            Results.settings.sort.sortByMethod = sortByMethod;
            return true;
        }
        if (sortByMethod === null) {
            Results.settings.sort.sortByMethod = Results.model.defaultSortMethod;
        }
        console.log("Results.setSortByMethod() has been called but the parameter is not a function.", sortByMethod);
        return false;
    },
    setSortDir: function(sortDir) {
        if (sortDir && sortDir.length > 0 && $.inArray(sortDir, [ "asc", "desc" ]) != -1) {
            Results.settings.sort.sortDir = sortDir;
            return true;
        }
        console.log("Results.setSortDir() has been called but it was provided an invalid argument: sortDir=", sortDir);
        return false;
    },
    filterBy: function(filterBy, condition, options, renderView) {
        if (typeof Object.byString(Results.settings.paths, filterBy) !== "undefined") {
            Results.model.addFilter(filterBy, condition, options);
            Results.model.filter(renderView);
        } else {
            console.log("This filter could not find the path to the property it should be filtered by: filterBy= filterBy=", filterBy, "| condition=", condition, "| options=", options);
        }
    },
    unfilterBy: function(filterBy, condition, renderView) {
        if (typeof Object.byString(Results.settings.paths, filterBy) !== "undefined") {
            Results.model.removeFilter(filterBy, condition);
            if (renderView) {
                Results.model.filter(renderView);
            }
        } else {
            console.log("This filter could not find the path to the property it should be unfiltered by: filterBy=", filterBy, "| condition=", condition);
        }
    },
    applyFiltersAndSorts: function() {
        Results.model.filterAndSort(true);
        Results.view.toggleFrequency(Results.settings.frequency);
    },
    getFrequency: function() {
        return Results.settings.frequency;
    },
    setFrequency: function(frequency, renderView) {
        if (typeof renderView === "undefined") renderView = true;
        if (!Results.settings.show.nonAvailablePrices) {
            $.each(Results.settings.paths.price, function(currentFrequency, pricePath) {
                Results.unfilterBy("availability.price." + currentFrequency, "value", false);
            });
            var options = {};
            options[Results.settings.availability.price[0]] = Results.settings.availability.price[1];
            Results.filterBy("availability.price." + frequency, "value", options, renderView);
        }
        Results.model.setFrequency(frequency, renderView);
        if (renderView !== false) {
            Results.sortBy("price." + frequency);
        }
    },
    addCurrentProduct: function(identifierPathName, product) {
        Results.model.addCurrentProduct(product);
        Results.setCurrentProduct(identifierPathName, Object.byString(product, identifierPathName));
    },
    removeCurrentProduct: function() {
        Results.model.currentProduct = false;
    },
    setCurrentProduct: function(identifierPathName, currentProduct) {
        if (typeof Object.byString(Results.settings.paths, identifierPathName) != "undefined") {
            Results.model.setCurrentProduct(identifierPathName, currentProduct);
        } else {
            console.log("You have been trying to set the current product but the path to the identifier does not seem to exists: identifierPathName=", identifierPathName, "| currentProduct=", currentProduct);
        }
    },
    getResult: function(identifierPathName, value) {
        if (typeof Object.byString(Results.settings.paths, identifierPathName) != "undefined") {
            return Results.model.getResult(identifierPathName, value);
        } else {
            console.log("You have been trying to retrieve a result through an identifier, but the path to that identifier does not seem to exist in the results objects: identifierPathName=", identifierPathName, "| value=", value);
        }
    },
    getResultIndex: function(identifierPathName, value) {
        if (typeof Object.byString(Results.settings.paths, identifierPathName) != "undefined") {
            return Results.model.getResultIndex(identifierPathName, value);
        } else {
            console.log("You have been trying to retrieve a result through an identifier, but the path to that identifier does not seem to exist in the results objects: identifierPathName=", identifierPathName, "| value=", value);
        }
    },
    getResultByIndex: function(productIndex) {
        return Results.model.returnedProducts[productIndex];
    },
    getResultByProductId: function(productId) {
        return Results.getResult(Results.settings.paths.productId, productId);
    },
    getTopResult: function() {
        return Results.model.sortedProducts && Results.model.sortedProducts.length > 0 ? Results.model.sortedProducts[0] : false;
    },
    getReturnedGeneral: function() {
        return Results.model.returnedGeneral;
    },
    getReturnedResults: function() {
        return Results.model.returnedProducts;
    },
    getAjaxRequest: function() {
        return Results.model.ajaxRequest;
    },
    getSortedResults: function() {
        return Results.model.sortedProducts;
    },
    getFilteredResults: function() {
        return Results.model.filteredProducts;
    },
    getSelectedProduct: function() {
        return Results.model.selectedProduct;
    },
    setSelectedProduct: function(productId) {
        return Results.model.setSelectedProduct(productId);
    },
    removeSelectedProduct: function() {
        Results.model.removeSelectedProduct();
    },
    getDisplayMode: function() {
        if (typeof Results.settings === "undefined" || Results.settings.hasOwnProperty("displayMode") !== true) return null;
        return Results.settings.displayMode;
    },
    setDisplayMode: function(mode, forceRefresh) {
        Results.view.setDisplayMode(mode, forceRefresh);
    },
    isResultDisplayed: function(resultModel) {
        if ($.inArray(resultModel, Results.model.filteredProducts) == -1) {
            return false;
        }
        return true;
    },
    setPerformanceMode: function(level) {
        var profile = meerkat.modules.performanceProfiling.PERFORMANCE;
        switch (level) {
          case profile.LOW:
            Results.settings.animation.filter.active = false;
            Results.settings.animation.shuffle.active = false;
            Results.settings.animation.features.scroll.active = false;
            Results.settings.render.features.expandRowsOnComparison = false;
            break;

          case profile.MEDIUM:
            Results.settings.animation.filter.active = false;
            Results.settings.animation.shuffle.active = false;
            Results.settings.animation.features.scroll.active = true;
            Results.settings.render.features.expandRowsOnComparison = true;
            break;

          case profile.HIGH:
            Results.settings.animation.filter.active = true;
            Results.settings.animation.shuffle.active = true;
            Results.settings.animation.features.scroll.active = true;
            Results.settings.render.features.expandRowsOnComparison = true;
            break;
        }
    },
    onError: function(message, page, description, data) {
        if (typeof meerkat !== "undefined") {
            meerkat.messaging.publish(Results.moduleEvents.RESULTS_ERROR);
            meerkat.modules.errorHandling.error({
                errorLevel: "warning",
                message: message,
                page: page,
                description: description,
                data: data
            });
        } else if (typeof FatalErrorDialog !== "undefined") {
            FatalErrorDialog.exec({
                message: message,
                page: page,
                description: description,
                data: data
            });
        }
    },
    startResultsFetch: function() {
        Results.model.startResultsFetch();
    },
    finishResultsFetch: function() {
        Results.model.finishResultsFetch();
    },
    publishResultsDataReady: function() {
        Results.model.publishResultsDataReady();
    }
};

var ResultsModel = new Object();

ResultsModel = {
    ajaxRequest: false,
    returnedGeneral: false,
    isBlockedQuote: false,
    returnedProducts: false,
    filteredProducts: false,
    sortedProducts: false,
    hasValidationErrors: false,
    currentProduct: false,
    selectedProduct: false,
    filters: new Array(),
    resultsLoadedOnce: false,
    moduleEvents: {
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK",
        RESULTS_DATA_READY: "RESULTS_DATA_READY",
        RESULTS_BEFORE_DATA_READY: "RESULTS_BEFORE_DATA_READY",
        RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW: "RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW",
        RESULTS_UPDATED_INFO_RECEIVED: "RESULTS_UPDATED_INFO_RECEIVED"
    },
    fetch: function(url, data) {
        Results.model.startResultsFetch();
        try {
            Results.model.flush();
            if (typeof Loading !== "undefined") {
                Loading.show(Results.settings.dictionary.loadingMessage);
            }
            if (typeof Compare !== "undefined") {
                Compare.reset();
            }
            if (Results.settings.runShowResultsPage === true) {
                Results.view.showResultsPage();
            }
            try {
                $.address.parameter("stage", "results", false);
            } catch (e) {}
            if (typeof url == "undefined") {
                url = Results.settings.url;
            }
            if (typeof data == "undefined") {
                var data;
                if (typeof meerkat !== "undefined") {
                    data = meerkat.modules.form.getData($(Results.settings.formSelector));
                    data.push({
                        name: "transactionId",
                        value: meerkat.modules.transactionId.get()
                    });
                    if (meerkat.site.isCallCentreUser) {
                        data.push({
                            name: meerkat.modules.comms.getCheckAuthenticatedLabel(),
                            value: true
                        });
                    }
                } else {
                    data = Results.model.getFormData($(Results.settings.formSelector));
                    data.push({
                        name: "transactionId",
                        value: referenceNo.getTransactionID()
                    });
                }
            }
        } catch (e) {
            Results.onError("Sorry, an error occurred fetching results", "Results.js", "Results.model.fetch(); " + e.message, e);
        }
        if (Results.model.resultsLoadedOnce == true) {
            var hasIncTranIdSetting = Results.settings.hasOwnProperty("incrementTransactionId");
            if (!hasIncTranIdSetting || hasIncTranIdSetting && Results.settings.incrementTransactionId === true) {
                url += (url.indexOf("?") == -1 ? "?" : "&") + "id_handler=increment_tranId";
            }
        }
        Results.model.ajaxRequest = $.ajax({
            url: url,
            data: data,
            type: "POST",
            async: true,
            dataType: "json",
            cache: false,
            success: function(jsonResult) {
                Results.model.updateTransactionIdFromResult(jsonResult);
                if (typeof meerkat != "undefined") {
                    if (jsonResult.hasOwnProperty("results")) {
                        if (jsonResult.results.hasOwnProperty("info")) {
                            Results.model.isBlockedQuote = typeof jsonResult.results.info !== "undefined" && typeof jsonResult.results.info.blocked === "boolean" && jsonResult.results.info.blocked === true;
                            meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_UPDATED_INFO_RECEIVED, jsonResult.results.info);
                        }
                    }
                }
                try {
                    if (jsonResult && jsonResult.messages && jsonResult.messages.length > 0) {}
                    if (typeof meerkat !== "undefined" && typeof jsonResult.error !== "undefined" && jsonResult.error == meerkat.modules.comms.getCheckAuthenticatedLabel()) {
                        if (typeof Loading !== "undefined") Loading.hide();
                        _.defer(function() {
                            meerkat.modules.journeyEngine.gotoPath("previous");
                        });
                        if (!meerkat.modules.dialogs.isDialogOpen(jsonResult.error)) {
                            meerkat.modules.errorHandling.error({
                                errorLevel: "warning",
                                id: jsonResult.error,
                                message: "Your Simples login session has been lost. Please open Simples in a separate tab, login, then you can continue with this quote.",
                                page: "ResultsModel.js",
                                description: "Error loading url: " + url + " : " + jsonResult.error,
                                data: data
                            });
                        }
                    } else if (typeof jsonResult.error !== "undefined" && jsonResult.error.type == "validation") {
                        if (typeof Loading !== "undefined") {
                            Loading.hide();
                        }
                        Results.model.hasValidationErrors = typeof Object.byString(jsonResult, Results.settings.paths.results.errors) === "object";
                        Results.reviseDetails();
                        ServerSideValidation.outputValidationErrors({
                            validationErrors: jsonResult.error.errorDetails.validationErrors,
                            startStage: 0
                        });
                    } else if (!jsonResult || typeof Object.byString(jsonResult, Results.settings.paths.results.rootElement) == "undefined") {
                        Results.model.handleFetchError(jsonResult, "Returned results did not have the expected format");
                    } else {
                        Results.model.update(jsonResult);
                    }
                    Results.model.triggerEventsFromResult(jsonResult);
                } catch (e) {
                    Results.model.handleFetchError(data, "Try/Catch fail on success: " + e.message);
                }
            },
            error: function(jqXHR, txt, errorThrown) {
                Results.model.ajaxRequest = false;
                if (jqXHR.status === 429) {
                    Results.model.isBlockedQuote = true;
                } else if (jqXHR.status !== 0 && jqXHR.readyState !== 0 || txt == "timeout") {
                    Results.model.handleFetchError(data, "AJAX request failed: " + txt + " " + errorThrown);
                }
            },
            complete: function() {
                Results.model.ajaxRequest = false;
                Results.model.finishResultsFetch();
            }
        });
    },
    triggerEventsFromResult: function(jsonResult) {
        if (typeof meerkat !== "undefined" && typeof jsonResult == "object" && jsonResult.hasOwnProperty("results") && jsonResult.results.hasOwnProperty("events")) {
            for (var i in jsonResult.results.events) {
                if (jsonResult.results.events.hasOwnProperty(i)) {
                    meerkat.messaging.publish(i, jsonResult.results.events[i]);
                }
            }
        }
    },
    updateTransactionIdFromResult: function(jsonResult) {
        var newTranID = 0;
        if (jsonResult.hasOwnProperty("info") && jsonResult.info.hasOwnProperty("transactionId")) {
            newTranID = jsonResult.info.transactionId;
        } else if (jsonResult.hasOwnProperty("error") && jsonResult.error.hasOwnProperty("transactionId")) {
            newTranID = jsonResult.error.transactionId;
        } else if (jsonResult.hasOwnProperty("results")) {
            if (jsonResult.results.hasOwnProperty("transactionId")) {
                newTranID = jsonResult.results.transactionId;
            } else if (jsonResult.results.hasOwnProperty("info") && jsonResult.results.info.hasOwnProperty("transactionId")) {
                newTranID = jsonResult.results.info.transactionId;
            } else if (jsonResult.results.hasOwnProperty("noresults") && jsonResult.results.noresults.hasOwnProperty("transactionId")) {
                newTranID = jsonResult.results.noresults.transactionId;
            }
        }
        if (newTranID !== 0) {
            if (typeof meerkat !== "undefined") {
                meerkat.modules.transactionId.set(newTranID);
            } else if (typeof referenceNo !== "undefined") {
                referenceNo.setTransactionId(newTranID);
            }
        }
    },
    handleFetchError: function(data, description) {
        if (typeof Loading !== "undefined") Loading.hide();
        Results.reviseDetails();
        var callString = "";
        if (typeof meerkat !== "undefined" && typeof meerkat.site !== "undefined" && typeof meerkat.site.content !== "undefined" && typeof meerkat.site.content.callCentreHelpNumber != "undefined" && meerkat.site.content.callCentreHelpNumber.length > 0) {
            callString = "If the problem persists, please feel free to discuss your comparison needs with our call centre on " + meerkat.site.content.callCentreHelpNumber + ".";
        }
        Results.onError("Sorry, an error occurred while retrieving your results.<br />Please close this message and try again. " + callString, "common/js/Results.js for " + Results.model.getVertical(), "Results.model.fetch(). " + description, data);
    },
    getVertical: function() {
        var vertical = "unknown";
        if (Results.settings.hasOwnProperty("vertical")) {
            vertical = Results.settings.vertical;
        } else if (typeof meerkat == "object" && meerkat.site.hasOwnProperty("vertical")) {
            vertical = meerkat.site.vertical;
        }
        return vertical;
    },
    reset: function() {
        Results.model.flush();
        Results.model.currentProduct = false;
        Results.settings.frequency = "annual";
        Results.model.filters = [];
    },
    flush: function() {
        Results.model.returnedGeneral = [];
        Results.model.returnedProducts = [];
        Results.model.sortedProducts = [];
        Results.model.filteredProducts = [];
        Results.view.flush();
    },
    getFormData: function(form) {
        return form.find(":input:visible, input[type=hidden], :input[data-visible=true]").filter(function() {
            return $(this).val() != "" && $(this).val() != "Please choose...";
        }).serializeArray();
    },
    update: function(jsonResult) {
        try {
            if (Object.byString(jsonResult, Results.settings.paths.results.rootElement) != "" && Object.byString(jsonResult, Results.settings.paths.results.list) && (Object.byString(jsonResult, Results.settings.paths.results.list).length > 0 || typeof Object.byString(jsonResult, Results.settings.paths.results.list) == "object")) {
                if (Object.byString(jsonResult, Results.settings.paths.results.general) && Object.byString(jsonResult, Results.settings.paths.results.general) != "") {
                    Results.model.returnedGeneral = Object.byString(jsonResult, Results.settings.paths.results.general);
                    $(Results.settings.elements.resultsContainer).trigger("generalReturned");
                }
                if (!Object.byString(jsonResult, Results.settings.paths.results.list).length) {
                    Results.model.returnedProducts = [ Object.byString(jsonResult, Results.settings.paths.results.list) ];
                } else {
                    Results.model.returnedProducts = Object.byString(jsonResult, Results.settings.paths.results.list);
                }
                if (Results.model.currentProduct && Results.model.currentProduct.product) {
                    Results.model.returnedProducts.push(Results.model.currentProduct.product);
                }
                if (typeof meerkat !== "undefined") {
                    meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW);
                }
                $(Results.settings.elements.resultsContainer).trigger("resultsReturned");
                var options = {};
                if (!Results.settings.show.nonAvailableProducts) {
                    options[Results.settings.availability.product[0]] = Results.settings.availability.product[1];
                    Results.model.addFilter("availability.product", "value", options);
                }
                options = {};
                if (!Results.settings.show.nonAvailablePrices) {
                    options[Results.settings.availability.price[0]] = Results.settings.availability.price[1];
                    Results.model.addFilter("availability.price." + Results.settings.frequency, "value", options);
                }
                Results.model.filterAndSort(false);
                Results.view.show();
            } else {
                Results.view.showNoResults();
                $(Results.settings.elements.resultsContainer).trigger("noResults");
            }
        } catch (e) {
            Results.onError("Sorry, an error occurred updating results", "Results.js", "Results.model.update(); " + e.message, e);
        }
        Results.model.resultsLoadedOnce = true;
    },
    filterAndSort: function(renderView) {
        Results.model.sort(renderView);
        Results.model.filter(renderView);
        $(Results.settings.elements.resultsContainer).trigger("resultsDataReady");
        if (typeof meerkat !== "undefined") {
            meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_BEFORE_DATA_READY);
            _.defer(function() {
                meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_DATA_READY);
            });
        }
    },
    sort: function(renderView) {
        if (Results.settings.sort.sortBy === false) return false;
        if (Results.model.returnedProducts.length > 0) {
            if (Results.model.sortedProducts.length > 0) {
                var previousSortedResults = Results.model.sortedProducts.slice();
            }
            var results = Results.model.returnedProducts.slice();
            var sortByMethod = typeof Results.getSortByMethod() === "function" ? Results.getSortByMethod() : Results.model.defaultSortMethod();
            Results.model.sortedProducts = results.sort(sortByMethod);
            if (typeof previousSortedResults != "undefined" && renderView !== false) {
                Results.view.shuffle(previousSortedResults);
            }
            Results.pagination.gotoStart(true);
        }
    },
    defaultSortMethod: function(resultA, resultB) {
        var valueA = Object.byString(resultA, Object.byString(Results.settings.paths, Results.settings.sort.sortBy));
        var valueB = Object.byString(resultB, Object.byString(Results.settings.paths, Results.settings.sort.sortBy));
        if (isNaN(valueA) || isNaN(valueB)) {
            valueA = String(valueA).toLowerCase();
            valueB = String(valueB).toLowerCase();
        }
        var frequencyPriceAvailability = Results.settings.paths.availability.price[Results.settings.frequency];
        if (frequencyPriceAvailability && frequencyPriceAvailability != "") {
            var availabilityA = Object.byString(resultA, frequencyPriceAvailability);
            var availabilityB = Object.byString(resultB, frequencyPriceAvailability);
            if (availabilityB == "N" || !valueB || valueB == "") {
                return -1;
            }
            if (availabilityA == "N" || !valueA || valueA == "") {
                return 1;
            }
        }
        if (valueA < valueB) {
            returnValue = -1;
        } else if (valueA > valueB) {
            returnValue = 1;
        } else if (Results.settings.sort.sortBy.indexOf("price.") == -1) {
            var currentFrequencyPricePath = Object.byString(Results.settings.paths, "price." + Results.settings.frequency);
            valueA = Object.byString(resultA, currentFrequencyPricePath);
            valueB = Object.byString(resultB, currentFrequencyPricePath);
            if (valueA == null || valueB == null) {
                return 0;
            }
            return valueA - valueB;
        } else {
            returnValue = valueA - valueB;
        }
        if (Results.settings.sort.sortDir == "desc") {
            returnValue *= -1;
        }
        return returnValue;
    },
    addFilter: function(filterBy, condition, options) {
        if (typeof filterBy !== "undefined" && typeof condition !== "undefined" && typeof options !== "undefined" && filterBy !== "" && condition !== "") {
            var path = Object.byString(Results.settings.paths, filterBy);
            if (typeof path !== "undefined") {
                var filterIndex = Results.model.findFilter(path, condition);
                if (filterIndex !== false) {
                    Results.model.filters[filterIndex].options = options;
                } else {
                    Results.model.filters.push({
                        path: path,
                        condition: condition,
                        options: options
                    });
                }
            } else {
                console.log("This filter could not find the path to the property it should be filtered by: filterBy=", filterBy, "| condition=", condition, "| options=", options);
            }
        }
    },
    removeFilter: function(filterBy, condition) {
        if (typeof filterBy != "undefined" && typeof condition != "undefined") {
            var path = Object.byString(Results.settings.paths, filterBy);
            if (typeof path != "undefined") {
                var filterIndex = Results.model.findFilter(path, condition);
                if (filterIndex !== false) {
                    Results.model.filters.splice(filterIndex, 1);
                }
            } else {
                console.log("This filter could not find the path to the property it should be unfiltered by: filterBy=", filterBy, "| condition=", condition);
            }
        }
    },
    findFilter: function(path, condition) {
        if (typeof path !== "undefined" && typeof condition !== "undefined") {
            var filterIndex = false;
            $.each(Results.model.filters, function(index, filter) {
                if (filter.path == path && filter.condition == condition) {
                    filterIndex = index;
                    return false;
                }
            });
            return filterIndex;
        }
        return false;
    },
    filter: function(renderView) {
        var initialProducts = Results.model.sortedProducts.slice();
        var finalProducts = new Array();
        var valid, value;
        $.each(initialProducts, function(productIndex, product) {
            valid = true;
            $.each(Results.model.filters, function(filterIndex, filter) {
                value = Object.byString(product, filter.path);
                if (typeof value !== "undefined") {
                    switch (filter.condition) {
                      case "value":
                        valid = Results.model.filterByValue(value, filter.options);
                        break;

                      case "range":
                        valid = Results.model.filterByRange(value, filter.options);
                        break;

                      default:
                        console.log("The filter condition type seems to be erroneous");
                        break;
                    }
                }
                if (!valid) {
                    return false;
                }
            });
            if (valid) {
                finalProducts.push(product);
            }
        });
        Results.model.filteredProducts = finalProducts;
        if (typeof Compare !== "undefined") Compare.applyFilters();
        if (renderView !== false) {
            if (Results.getFilteredResults().length === 0) {
                Results.view.showNoFilteredResults();
                $(Results.settings.elements.resultsContainer).trigger("noFilteredResults");
            } else {
                Results.view.filter();
                Results.pagination.gotoStart(true);
            }
        }
    },
    filterByValue: function(value, options) {
        if (!options || typeof options === "undefined") {
            console.log("Check the parameters passed to Results.model.filterByValue()");
            return true;
        } else {
            if (options.hasOwnProperty("equals")) {
                return value == options.equals;
            } else if (options.hasOwnProperty("notEquals")) {
                return value != options.notEquals;
            } else if (options.hasOwnProperty("inArray") && $.isArray(options.inArray)) {
                return $.inArray(String(value), options.inArray) != -1;
            } else {
                console.log("Options from this value filter are incorrect and has not been applied: ", value, options);
                return true;
            }
        }
    },
    filterByRange: function(value, options) {
        if (!options || typeof options == "undefined") {
            console.log("Check the parameters passed to Results.model.filterByRange()");
            return true;
        } else if (options.hasOwnProperty("min") || options.hasOwnProperty("max")) {
            if (options.hasOwnProperty("min") && value < options.min || options.hasOwnProperty("max") && value > options.max) {
                return false;
            } else {
                return true;
            }
        } else {
            console.log("Options from this range filter are incorrect and have not been applied: ", value, options);
            return true;
        }
    },
    filterByDateRange: function(value, options) {},
    addCurrentProduct: function(product) {
        if (Results.model.currentProduct) {
            $.extend(Results.model.currentProduct, {
                product: product
            });
        } else {
            Results.model.currentProduct = new Object();
            Results.model.currentProduct = {
                product: product
            };
        }
    },
    setCurrentProduct: function(identifierPathName, currentProduct) {
        if (Results.model.currentProduct) {
            $.extend(Results.model.currentProduct, {
                path: Object.byString(Results.settings.paths, identifierPathName),
                value: currentProduct
            });
        } else {
            Results.model.currentProduct = new Object();
            Results.model.currentProduct = {
                path: Object.byString(Results.settings.paths, identifierPathName),
                value: currentProduct
            };
        }
    },
    setSelectedProduct: function(productId) {
        return Results.model.selectedProduct = Results.model.getResult("productId", productId);
    },
    removeSelectedProduct: function() {
        Results.model.selectedProduct = false;
    },
    getResult: function(identifierPathName, value, returnIndex) {
        var result = false;
        var resultIndex = false;
        $.each(Results.model.returnedProducts, function(index, product) {
            var productValue = Object.byString(product, Object.byString(Results.settings.paths, identifierPathName));
            if (productValue == value) {
                result = product;
                resultIndex = index;
                return false;
            }
        });
        if (returnIndex) {
            return resultIndex;
        } else {
            return result;
        }
    },
    getResultIndex: function(identifierPathName, value) {
        return Results.model.getResult(identifierPathName, value, true);
    },
    setFrequency: function(frequency, refreshView) {
        Results.settings.frequency = frequency;
        if (refreshView !== false) {
            Results.view.toggleFrequency(frequency);
        }
    },
    startResultsFetch: function() {
        if (typeof meerkat != "undefined") {
            meerkat.messaging.publish(Results.model.moduleEvents.WEBAPP_LOCK, {
                source: "resultsModel"
            });
        }
        $(Results.settings.elements.resultsContainer).trigger("resultsFetchStart");
    },
    finishResultsFetch: function() {
        if (typeof Loading !== "undefined") Loading.hide();
        if (typeof meerkat != "undefined") {
            _.defer(function() {
                meerkat.messaging.publish(Results.model.moduleEvents.WEBAPP_UNLOCK, {
                    source: "resultsModel"
                });
            });
        }
        $(Results.settings.elements.resultsContainer).trigger("resultsFetchFinish");
    },
    publishResultsDataReady: function() {
        if (typeof meerkat !== "undefined") {
            $(Results.settings.elements.resultsContainer).trigger("resultsReturned");
            meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_DATA_READY);
        }
    }
};

var ResultsPagination = new Object();

ResultsPagination = {
    NEXT: "next",
    PREVIOUS: "previous",
    $pagesContainer: null,
    $nextButton: null,
    $previousButton: null,
    $pageText: null,
    invalidated: true,
    currentPageNumber: null,
    currentPageMeasurements: null,
    scrollMode: null,
    previousScrollPosition: 0,
    isLocked: false,
    isHidden: false,
    isTouching: false,
    isScrolling: false,
    touchendSnapTimeout: false,
    scrollCheckTimeout: false,
    init: function() {
        $(document).on("click", "[data-results-pagination-control]", function paginationControlClick(event) {
            Results.pagination.controlListener(event);
        });
        Results.pagination.$pagesContainer = $("[data-results-pagination-pages-cell]");
        Results.pagination.$nextButton = $('[data-results-pagination-control="next"]');
        Results.pagination.$previousButton = $('[data-results-pagination-control="previous"]');
        Results.pagination.$pageText = $('[data-results-pagination-pagetext="true"]').removeClass("hidden");
        Results.pagination.setScrollMode();
        if (typeof meerkat !== "undefined") {
            meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function paginationBreakPointChange(event) {
                if (event.state === "xs") return;
                Results.pagination.resync();
            });
        }
    },
    resync: function() {
        if (Results.pagination.isHidden === true) return false;
        Results.pagination.invalidate();
        Results.pagination.gotoPage(Results.pagination.getCurrentPageNumber(), true, true);
        Results.pagination.refresh();
    },
    reposition: function() {
        Results.pagination.gotoPage(Results.pagination.getCurrentPageNumber(), false, true);
    },
    isSlideMode: function() {
        return Results.settings.pagination.mode === "slide";
    },
    isPageMode: function() {
        return Results.settings.pagination.mode === "page";
    },
    getCurrentHorizontalPosition: function() {
        return ResultsUtilities.getScroll("x", Results.view.$containerElement);
    },
    invalidate: function() {
        Results.pagination.isLocked = false;
        Results.pagination.invalidated = true;
        Results.pagination.currentPageMeasurements = null;
        Results.pagination.isHidden = false;
    },
    reset: function() {
        Results.pagination.invalidate();
        Results.pagination.$nextButton.addClass("inactive");
        Results.pagination.$previousButton.addClass("inactive");
        Results.pagination.$pageText.empty();
        if (Results.pagination.isSlideMode()) {} else if (Results.pagination.isPageMode()) {
            Results.pagination.empty(Results.pagination.$pagesContainer);
        }
    },
    refresh: function() {
        if (Results.pagination.isHidden === true) return;
        if (Results.pagination.isPageMode()) {
            var pageMeasurements = Results.pagination.getPageMeasurements();
            if (pageMeasurements === null) return false;
            if (Results.pagination.invalidated === true) {
                Results.pagination.invalidated = false;
                var pageItemTemplate = _.template(Results.settings.templates.pagination.pageItem);
                Results.pagination.empty(Results.pagination.$pagesContainer);
                if (pageMeasurements.numberOfPages > 1 && pageMeasurements.numberOfPages != Number.POSITIVE_INFINITY) {
                    for (var i = 0; i < pageMeasurements.numberOfPages; i++) {
                        var num = i + 1;
                        var htmlString = pageItemTemplate({
                            pageNumber: num,
                            label: num
                        });
                        Results.pagination.$pagesContainer.append(htmlString);
                    }
                }
            }
            if (Results.pagination.$pageText != null && Results.pagination.$pageText.length > 0) {
                var pageTextTemplate = _.template(Results.settings.templates.pagination.pageText);
                var htmlString = pageTextTemplate({
                    currentPage: Results.pagination.getCurrentPageNumber(),
                    totalPages: pageMeasurements.numberOfPages
                });
                Results.pagination.$pageText.html(htmlString);
            }
            var pageNumber = Results.pagination.getCurrentPageNumber();
            $("[data-results-pagination-control].active").removeClass("active");
            $('[data-results-pagination-control="' + pageNumber + '"]').addClass("active");
            Results.pagination.addCurrentPageClasses(pageNumber, pageMeasurements);
            if (Results.pagination.getCurrentPageNumber() == 1) {
                Results.pagination.$previousButton.addClass("inactive");
            } else {
                Results.pagination.$previousButton.removeClass("inactive");
            }
            if (Results.pagination.getCurrentPageNumber() === pageMeasurements.numberOfPages) {
                Results.pagination.$nextButton.addClass("inactive");
            } else {
                Results.pagination.$nextButton.removeClass("inactive");
            }
            if (typeof Results.settings.pagination.afterPaginationRefreshFunction === "function") {
                Results.settings.pagination.afterPaginationRefreshFunction(Results.pagination.$pagesContainer);
            }
        } else {
            Results.pagination.toggleScrollButtons(Results.pagination.previousScrollPosition);
        }
    },
    controlListener: function(event) {
        if (Results.pagination.isSlideMode()) {
            Results.pagination.scrollResults($(event.currentTarget));
        } else if (Results.pagination.isPageMode()) {
            Results.pagination.gotoPage($(event.currentTarget).attr("data-results-pagination-control"));
        }
    },
    empty: function($container) {
        if (typeof Results.settings.pagination.emptyContainerFunction === "function") {
            Results.settings.pagination.emptyContainerFunction($container);
        } else {
            $container.empty();
        }
    },
    gotoPage: function(pageNumber, reset, forceReposition) {
        if (Results.pagination.isLocked) return false;
        if (reset !== true) reset = false;
        if (forceReposition !== true) forceReposition = false;
        if (pageNumber === ResultsPagination.NEXT) {
            pageNumber = Results.pagination.getCurrentPageNumber() + 1;
        } else if (pageNumber === ResultsPagination.PREVIOUS) {
            pageNumber = ResultsPagination.getCurrentPageNumber() - 1;
        }
        if (isNaN(pageNumber) === true) return false;
        if (pageNumber < 1) pageNumber = 1;
        pageNumber = Number(pageNumber);
        var info = Results.pagination.getPageMeasurements();
        var scrollPosition = 0;
        if (pageNumber !== 1) {
            var pageWidth = info.pageWidth;
            if (pageNumber > info.numberOfPages) pageNumber = info.numberOfPages;
            var pageNumberMultiplier = pageNumber - 1;
            scrollPosition = 0 - pageWidth * pageNumberMultiplier;
        }
        var previousPageNumber = Results.pagination.getCurrentPageNumber();
        if (pageNumber === previousPageNumber && forceReposition == false) {
            return false;
        }
        Results.pagination.setCurrentPageNumber(pageNumber);
        Results.pagination.removeCurrentPageClasses();
        if (reset || forceReposition) {
            Results.pagination.scroll(scrollPosition);
        } else {
            Results.pagination.animateScroll(scrollPosition);
        }
        var event = jQuery.Event("resultPageChange");
        event.pageData = {
            pageNumber: pageNumber,
            measurements: info
        };
        $(Results.settings.elements.resultsContainer).trigger(event);
    },
    gotoPosition: function(positionNumber, reset, forceReposition) {
        if (Results.pagination.isLocked) return false;
        var info = Results.pagination.getPageMeasurements();
        var pageNumber = Math.ceil(positionNumber / info.columnsPerPage);
        Results.pagination.gotoPage(pageNumber, reset, forceReposition);
    },
    getCurrentPageNumber: function() {
        if (Results.pagination.currentPageNumber === null) {
            return Results.pagination.calculateCurrentPageNumber();
        }
        return Results.pagination.currentPageNumber;
    },
    setCurrentPageNumber: function(pageNumber) {
        Results.pagination.currentPageNumber = pageNumber;
    },
    calculateCurrentPageNumber: function() {
        var pageMeasurements = Results.pagination.getPageMeasurements();
        if (pageMeasurements === null) return false;
        var pageWidth = pageMeasurements.pageWidth;
        var currentHorizontalPosition = 0 - Results.pagination.getCurrentHorizontalPosition();
        var pageNumber = Math.round(currentHorizontalPosition / pageWidth) + 1;
        return pageNumber;
    },
    getPageMeasurements: function() {
        if (Results.pagination.currentPageMeasurements === null || Results.view.currentlyColumnWidthTracking === true) {
            return Results.pagination.calculatePageMeasurements();
        }
        return Results.pagination.currentPageMeasurements;
    },
    calculatePageMeasurements: function() {
        var $container = Results.view.$containerElement;
        var viewableArea = $container.parent().width();
        var $rows = $container.find(Results.settings.elements.rows + ".notfiltered");
        if ($rows.length == 0) return null;
        var numberOfColumns = $rows.length;
        var columnWidth = 0;
        var columnsPerPage = 0;
        var mediaState = typeof meerkat != "undefined" ? meerkat.modules.deviceMediaState.get().toLowerCase() : false;
        if (mediaState !== false && mediaState !== "xs" && Results.pagination.hasLessDrivenColumns(mediaState)) {
            columnsPerPage = Results.pagination.getColumnCountFromContainer(mediaState);
            columnWidth = Math.round(viewableArea / columnsPerPage);
        } else {
            columnWidth = $rows.outerWidth(true);
            columnsPerPage = Math.round(viewableArea / columnWidth);
        }
        var pageWidth = columnWidth * columnsPerPage;
        var obj = {
            pageWidth: pageWidth,
            columnsPerPage: columnsPerPage,
            numberOfColumns: numberOfColumns,
            numberOfPages: Math.ceil(numberOfColumns / columnsPerPage)
        };
        Results.pagination.currentPageMeasurements = obj;
        return obj;
    },
    hasLessDrivenColumns: function(mediaState) {
        return $('.resultsContainer[class*="results-columns-' + mediaState + '-"]').length > 0;
    },
    getColumnCountFromContainer: function(mediaState) {
        var noColumns = 0;
        var $container = $(".resultsContainer");
        if ($container.length) {
            var classes = $container[0].className.split(" ");
            for (var i = 0; i < classes.length; i++) {
                if (!_.isEmpty(classes[i]) && classes[i].indexOf("results-columns-" + mediaState + "-") === 0) {
                    noColumns = Number(classes[i].replace(/^\D+/g, ""));
                }
            }
        }
        return noColumns;
    },
    gotoStart: function(invalidate) {
        if (invalidate) {
            Results.pagination.invalidate();
        }
        if (Results.pagination.isSlideMode()) {
            var newScroll = 0;
            Results.pagination.animateScroll(newScroll);
        } else if (Results.pagination.isPageMode()) {
            Results.pagination.gotoPage(1);
            if (invalidate) {
                Results.pagination.refresh();
            }
        }
    },
    setScrollMode: function() {
        var isIos6 = false;
        if (typeof meerkat != "undefined") {
            isIos6 = meerkat.modules.performanceProfiling.isIos6();
        }
        if (Results.settings.pagination.touchEnabled === true) {
            Results.pagination.scrollMode = "scrollto";
        } else if (Modernizr.csstransforms3d && isIos6 == false) {
            Results.pagination.scrollMode = "csstransforms3d";
        } else if (Modernizr.csstransitions) {
            Results.pagination.scrollMode = "csstransitions";
        } else {
            Results.pagination.scrollMode = "jquery";
        }
    },
    animateScroll: function(newScroll) {
        if (newScroll === Results.pagination.previousScrollPosition) {
            _.defer(function() {
                Results.pagination.refresh();
            });
            return false;
        }
        if (Results.settings.animation.features.scroll.active === false) {
            Results.pagination.scroll(newScroll);
            Results.pagination._afterPaginationMotion(false);
        } else {
            Results.pagination.lock();
            $(Results.settings.elements.resultsContainer).trigger("pagination.scrolling.start");
            switch (Results.pagination.scrollMode) {
              case "scrollto":
                var rowEq = (Results.pagination.getCurrentPageNumber() - 1) * Results.pagination.currentPageMeasurements.columnsPerPage;
                $(Results.settings.elements.resultsOverflow).scrollTo($(Results.settings.elements.rows).not(".filtered").eq(rowEq), 500, {
                    onAfter: function() {
                        Results.pagination._afterPaginationMotion(true);
                    }
                });
                break;

              case "csstransforms3d":
                var css = {
                    marginLeft: 0
                };
                css[Modernizr.prefixed("transform")] = "translate3d(" + ResultsPagination.previousScrollPosition + "px,0,0)";
                Results.view.$containerElement.css(css);
                _.delay(function() {
                    Results.view.$containerElement.addClass("resultsTransformTransition");
                    Results.view.$containerElement.css(Modernizr.prefixed("transform"), "translate3d(" + newScroll + "px,0,0)");
                    _.delay(function() {
                        Results.view.$containerElement.removeClass("resultsTransformTransition");
                        var css = {
                            marginLeft: newScroll + "px"
                        };
                        css[Modernizr.prefixed("transform")] = "";
                        Results.view.$containerElement.css(css);
                        Results.pagination._afterPaginationMotion(true);
                    }, Results.view.$containerElement.transitionDuration() + 10);
                }, 25);
                break;

              case "csstransitions":
                if (!Results.view.$containerElement.hasClass("resultsTableLeftMarginTransition")) {
                    Results.view.$containerElement.addClass("resultsTableLeftMarginTransition");
                }
                _.defer(function() {
                    var duration = Results.view.$containerElement.transitionDuration();
                    Results.view.$containerElement.css("margin-left", newScroll);
                    _.delay(function() {
                        Results.pagination._afterPaginationMotion(true);
                        Results.view.$containerElement.removeClass("resultsTableLeftMarginTransition");
                    }, duration);
                });
                break;

              default:
                var duration = Results.settings.animation.features.scroll.duration;
                Results.view.$containerElement.animate({
                    "margin-left": newScroll
                }, duration, function() {
                    Results.pagination._afterPaginationMotion(true);
                });
                break;
            }
            ResultsPagination.previousScrollPosition = newScroll;
        }
    },
    _afterPaginationMotion: function(wasAnimated) {
        Results.pagination.unlock();
        Results.pagination.refresh();
        if (wasAnimated) {
            $(Results.settings.elements.resultsContainer).trigger("pagination.scrolling.end");
        }
    },
    scroll: function(scrollPosition) {
        ResultsPagination.previousScrollPosition = scrollPosition;
        var recalc = function() {
            Results.pagination.currentPageMeasurements = Results.pagination.calculatePageMeasurements();
            $(Results.settings.elements.resultsContainer).trigger(" pagination.instantScroll");
        };
        if (Results.settings.pagination.touchEnabled === true && !_.isNull(Results.pagination.currentPageMeasurements) && Results.pagination.currentPageMeasurements.hasOwnProperty("pageWidth")) {
            var baseDuration = 150;
            var width = Results.pagination.currentPageMeasurements.pageWidth;
            var start = $(Results.settings.elements.resultsOverflow).scrollLeft();
            var finish = Math.abs(scrollPosition);
            var gap = Math.abs(start - finish);
            var duration = Math.floor(gap / width * baseDuration);
            var maxScroll = width * (Results.pagination.currentPageMeasurements.numberOfColumns - 1);
            if (start > 0 || start < maxScroll) {
                $(Results.settings.elements.resultsOverflow).stop(true, true).animate({
                    scrollLeft: Math.abs(scrollPosition)
                }, {
                    duration: duration,
                    step: function() {
                        if (Results.pagination.isTouching === true || Results.pagination.isScrolling === true) {
                            $(Results.settings.elements.resultsOverflow).stop(true, true);
                        }
                    },
                    complete: function() {
                        _.defer(recalc);
                    }
                });
            } else {
                _.defer(recalc);
            }
        } else {
            Results.view.$containerElement.css("margin-left", scrollPosition);
            recalc();
        }
    },
    scrollResults: function(clickedButton) {
        if (clickedButton.hasClass("inactive") == false) {
            if (Results.pagination.isLocked === false) {
                Results.pagination.lock();
                var fullWidth = Results.view.$containerElement.parent().width();
                var widthAllColumns = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows).first().outerWidth(true) * $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered").length;
                var scrollWidth = fullWidth * Results.settings.animation.features.scroll.percentage;
                var currentScroll = ResultsUtilities.getScroll("x", Results.view.$containerElement);
                var newScroll;
                if (clickedButton.attr("data-results-pagination-control") == "previous") {
                    newScroll = currentScroll + scrollWidth;
                    if (newScroll >= 0) {
                        newScroll = 0;
                    }
                } else {
                    newScroll = currentScroll - scrollWidth;
                    if (widthAllColumns <= fullWidth) {
                        newScroll = 0;
                    } else if (Math.abs(newScroll) >= widthAllColumns - fullWidth && fullWidth < widthAllColumns) {
                        newScroll = widthAllColumns * -1 + fullWidth;
                    }
                }
                Results.pagination.animateScroll(newScroll);
            }
        }
    },
    toggleScrollButtons: function(expectedHorizontalPosition) {
        var container = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.container);
        var currentHorizontalPosition = ResultsUtilities.getScroll("x", Results.view.$containerElement);
        if (expectedHorizontalPosition != currentHorizontalPosition) {
            window.setTimeout(function() {
                Results.pagination.toggleScrollButtons(expectedHorizontalPosition, leftStatus, rightStatus);
            }, 100);
        } else {
            var viewableWidth = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.resultsOverflow).width();
            var contentWidth = container.width();
            var rightStatus;
            var leftStatus;
            if (contentWidth <= viewableWidth) {
                rightStatus = "inactive";
            } else {
                if (0 - currentHorizontalPosition + viewableWidth < contentWidth) {
                    rightStatus = "active";
                } else {
                    rightStatus = "inactive";
                }
            }
            if (currentHorizontalPosition >= 0) {
                leftStatus = "inactive";
            } else {
                leftStatus = "active";
            }
            if (rightStatus == "active") {
                Results.pagination.$nextButton.removeClass("inactive");
            } else {
                Results.pagination.$nextButton.addClass("inactive");
            }
            if (leftStatus == "active") {
                Results.pagination.$previousButton.removeClass("inactive");
            } else {
                Results.pagination.$previousButton.addClass("inactive");
            }
        }
    },
    lock: function() {
        Results.pagination.isLocked = true;
        Results.pagination.$nextButton.addClass("inactive");
        Results.pagination.$previousButton.addClass("inactive");
        Results.pagination.$pagesContainer.find("a").addClass("inactive");
    },
    unlock: function() {
        Results.pagination.isLocked = false;
        Results.pagination.$pagesContainer.find("a").removeClass("inactive");
    },
    hide: function() {
        Results.pagination.isHidden = true;
        Results.pagination.$pagesContainer.addClass("hidden");
        Results.pagination.$nextButton.addClass("hidden");
        Results.pagination.$previousButton.addClass("hidden");
        Results.pagination.$pageText.addClass("hidden");
    },
    show: function(performResync) {
        Results.pagination.isHidden = false;
        Results.pagination.$pagesContainer.removeClass("hidden");
        Results.pagination.$nextButton.removeClass("hidden");
        Results.pagination.$previousButton.removeClass("hidden");
        Results.pagination.$pageText.removeClass("hidden");
        if (performResync === true) {
            Results.pagination.resync();
        }
    },
    addCurrentPageClasses: function(pageNumber, pageMeasurements) {
        Results.pagination.removeCurrentPageClasses();
        if (isNaN(pageMeasurements.columnsPerPage)) return;
        var startVar = (pageNumber - 1) * pageMeasurements.columnsPerPage;
        var endVar = pageNumber * pageMeasurements.columnsPerPage;
        var looking = true;
        var i = startVar;
        var columnsFound = 0;
        while (looking) {
            var columnNumber = i;
            if ($("[data-position='" + columnNumber + "']").hasClass("notfiltered")) {
                $("[data-position='" + columnNumber + "']").addClass("currentPage");
                columnsFound++;
            }
            i++;
            if (columnsFound === pageMeasurements.columnsPerPage || i === Results.getReturnedResults().length || i > 1e3) {
                looking = false;
            }
        }
    },
    removeCurrentPageClasses: function() {
        $(Results.settings.elements.rows + ".currentPage").removeClass("currentPage");
    },
    setupNativeScroll: function() {
        if (Results.settings.pagination.touchEnabled !== true) {
            return;
        }
        var $featuresModeContainer = $(Results.settings.elements.resultsContainer + ".featuresMode");
        var columnsLength = Results.getFilteredResults().length;
        if ($featuresModeContainer.find(".result-row.result_unavailable_combined").length) {
            columnsLength++;
        }
        var numPages = Math.ceil(columnsLength / Results.pagination.currentPageMeasurements.columnsPerPage);
        var newWidth = Results.pagination.currentPageMeasurements.pageWidth * numPages;
        $(Results.settings.elements.container, $featuresModeContainer).width(newWidth);
        $(Results.settings.elements.resultsOverflow).off("scroll.results").on("scroll.results", Results.pagination.nativePaginationOnScroll);
        if (Modernizr.touch) {
            $(Results.settings.elements.resultsOverflow, $featuresModeContainer).off("touchstart.results").on("touchstart.results", function() {
                Results.pagination.isTouching = true;
                Results.pagination.cancelExistingSnapTo();
            }).off("touchend.results").on("touchend.results", function() {
                Results.pagination.isTouching = false;
                Results.pagination.isScrolling = false;
                Results.pagination.cancelExistingSnapTo();
                setTimeout(function() {
                    if (Results.pagination.isScrolling === false) {
                        Results.pagination.nativeScrollSnapTo();
                    }
                }, 250);
            });
        }
    },
    nativePaginationOnScroll: _.debounce(function(event) {
        if (Results.pagination.isLocked) {
            return;
        }
        Results.pagination.isScrolling = true;
        var divisor = 3;
        var widthToDivide = Results.pagination.currentPageMeasurements.pageWidth;
        var experiencePadding = Math.floor(widthToDivide / divisor);
        var pxFromLeft = $(event.target).scrollLeft() + experiencePadding;
        var pageNumber = Math.floor(pxFromLeft / Results.pagination.currentPageMeasurements.pageWidth) + 1;
        var isMidPage = $(event.target).scrollLeft() % Results.pagination.currentPageMeasurements.pageWidth != 0;
        var isNewPage = Results.pagination.getCurrentPageNumber() != pageNumber;
        if ((isNewPage === true || isMidPage === true) && pageNumber <= Results.pagination.currentPageMeasurements.numberOfPages) {
            Results.pagination.invalidate();
            Results.pagination.setCurrentPageNumber(pageNumber);
            Results.pagination.refresh();
            if (meerkat.modules.deviceMediaState.get() == "xs" && Results.pagination.isTouching === false && isNewPage === true) {
                Results.pagination.isScrolling = false;
                Results.pagination.nativeScrollSnapTo();
            }
            var eventData = $.Event("resultPageChange");
            eventData.pageData = {
                pageNumber: pageNumber,
                measurements: Results.pagination.getPageMeasurements()
            };
            $(Results.settings.elements.resultsContainer).trigger(eventData);
        }
    }, 25),
    nativeScrollSnapTo: function() {
        Results.pagination.cancelExistingSnapTo();
        Results.pagination.touchendSnapTimeout = setTimeout(function() {
            if (Results.pagination.isTouching === false && Results.pagination.isScrolling === false) {
                var pNum = Results.pagination.currentPageNumber;
                var pWidth = Results.pagination.currentPageMeasurements.pageWidth;
                Results.pagination.scroll(pWidth * (pNum - 1));
            }
        }, 750);
    },
    cancelExistingSnapTo: function() {
        $(Results.settings.elements.resultsOverflow).stop(true, true);
        clearTimeout(Results.pagination.touchendSnapTimeout);
    }
};

var ResultsUtilities = new Object();

ResultsUtilities = {
    setContainerWidth: function(elements, container) {
        var width = $(elements).first().outerWidth(true) * $(elements).length;
        $(container).css("width", width + "px");
    },
    makeElementSticky: function(stickySide, element, extraClass, startPosition) {
        if (element.attr("data-fixed") != "true") {
            var msie6 = $.browser == "msie" && $.browser.version < 7;
            if (!msie6) {
                var $window = $(window);
                var elementHeight = element.height();
                var scrollTop = $window.scrollTop();
                var windowHeight = $window.height();
                $window.smartscroll(function(e) {
                    scrollTop = $window.scrollTop();
                    windowHeight = $window.height();
                    if (stickySide == "top") {
                        if (scrollTop >= startPosition) {
                            element.addClass(extraClass);
                        } else {
                            element.removeClass(extraClass);
                            if ($.browser.version == 8 && element.is(":visible") && scrollTop == 0) {
                                element.delay(5).hide(0).show(0);
                            }
                        }
                    } else if (stickySide == "bottom") {
                        if (elementHeight + startPosition > scrollTop + windowHeight) {
                            element.addClass(extraClass);
                        } else {
                            element.removeClass(extraClass);
                        }
                    }
                });
            }
            element.attr("data-fixed", "true");
        }
    },
    position: function(position, elements, orientation) {
        switch (position) {
          case "absolute":
            ResultsUtilities.positionAbsolute(elements, orientation);
            break;

          case "relative":
          case "static":
            ResultsUtilities.positionStaticOrRelative(position, elements);
            break;
        }
    },
    positionAbsolute: function($elements, orientation) {
        if (!$elements.parent().hasClass("absoluteContainer")) {
            $elements.wrapAll('<div class="absoluteContainer" />');
        }
        var $container = $elements.parent();
        $container.css("position", "relative");
        var totalDimension;
        var $firstElement = $elements.first();
        if (orientation === "vertical") {
            totalDimension = $firstElement.outerWidth(true) * $elements.length;
            var maxHeight = 0;
            $elements.each(function() {
                var height = $(this).outerHeight(true);
                if (height > maxHeight) {
                    maxHeight = height;
                }
            });
            $container.css("height", maxHeight);
            $container.css("width", totalDimension);
        } else {
            totalDimension = $firstElement.outerHeight(true) * $elements.length;
            $container.css("height", totalDimension);
        }
        $elements.each(function(index, element) {
            var $element = $(element);
            var elementPosition = $element.position();
            if (orientation === "horizontal") {
                $element.css("top", elementPosition.top);
            }
            $element.css("left", elementPosition.left);
        });
        $elements.css("position", "absolute");
    },
    positionStaticOrRelative: function(position, $elements) {
        var $container = $elements.parent();
        if ($container.hasClass("absoluteContainer")) {
            $elements.unwrap();
        } else {
            if ($container.children(".absoluteContainer").length > 0) {
                $container.children(".absoluteContainer").remove();
            }
            $container.css({
                position: position,
                height: "auto"
            });
        }
        $elements.css({
            top: "auto",
            left: "auto",
            position: position
        });
    },
    getScroll: function(axis, element) {
        if (axis != "x" & axis != "y" && axis != "z") {
            return;
        }
        switch (axis) {
          case "x":
            return parseInt(element.css("margin-left"));

          case "y":
            return parseInt(element.css("margin-top"));

          case "z":
            return 0;
        }
    }
};

var deBouncer = function($, cf, of, interval) {
    var debounce = function(func, threshold, execAsap) {
        var timeout;
        return function debounced() {
            var obj = this, args = arguments;
            function delayed() {
                if (!execAsap) func.apply(obj, args);
                timeout = null;
            }
            if (timeout) clearTimeout(timeout); else if (execAsap) func.apply(obj, args);
            timeout = setTimeout(delayed, threshold || interval);
        };
    };
    jQuery.fn[cf] = function(fn) {
        return fn ? this.bind(of, debounce(fn)) : this.trigger(cf);
    };
};

deBouncer(jQuery, "smartscroll", "scroll", 50);

(function($) {
    $.fn.transitionDuration = function() {
        var properties = [ "transition-duration", "-webkit-transition-duration", "-ms-transition-duration", "-moz-transition-duration", "-o-transition-duration" ];
        var property;
        while (property = properties.shift()) {
            var $el = $(this);
            if ($el.css(property)) {
                return Math.round(parseFloat($el.css(property)) * 1e3);
            }
        }
        return 0;
    };
})(jQuery);

var ResultsView = new Object();

ResultsView = {
    rowHeight: false,
    rowWidth: false,
    orientation: "horizontal",
    shuffleTransitionDuration: false,
    filterTransitionDuration: false,
    $containerElement: false,
    currentlyColumnWidthTracking: false,
    noResultsMode: false,
    moduleEvents: {
        RESULTS_SORTED: "RESULTS_SORTED",
        RESULTS_TOGGLE_MODE: "RESULTS_TOGGLE_MODE"
    },
    show: function() {
        try {
            $.address.parameter("stage", "results", false);
        } catch (e) {}
        if (typeof Filters != "undefined" && $(Filters.settings.elements.filtersBar).length > 0) {
            Results.view.toggleFilters("show");
        }
        if (typeof Compare != "undefined") {
            if ($(Compare.settings.elements.bar).length > 0) {
                Results.view.toggleCompare("show");
                if (Results.settings.render.dockCompareBar === true) {
                    ResultsUtilities.makeElementSticky("top", $(Compare.settings.elements.bar), "fixed-top", $(Compare.settings.elements.bar).offset().top);
                    ResultsUtilities.makeElementSticky("top", $(Results.settings.elements.page), "fixedThree", $(Compare.settings.elements.bar).offset().top);
                }
            }
        }
        Results.view.showResults();
        Results.view.flush();
        $(Results.settings.elements.resultsContainer).find(".noResults.clone").remove();
        Results.view.buildHtml();
        Results.view.setDisplayMode(Results.settings.displayMode, true);
        var animatedElement;
        if (Results.settings.animation.results.individual.active) {
            Results.view.animateIndividualResults();
            animatedElement = $(Results.settings.elements.rows).last();
        } else {
            Results.view.animateAllResults();
            animatedElement = $(Results.settings.elements.resultsContainer);
        }
        if (Results.settings.show.savings && Results.model.currentProduct && Results.model.currentProduct.product) {
            var currentFrequencyPricePath = Results.settings.paths.price[Results.settings.frequency];
            var currentPrice = Object.byString(Results.model.currentProduct.product, currentFrequencyPricePath);
            if (currentPrice && typeof currentPrice != "undefined") {
                var topResult = Results.getTopResult();
                var topResultPrice = Object.byString(topResult, currentFrequencyPricePath);
                var savings = currentPrice - topResultPrice;
                if (typeof Compare != "undefined") Compare.setSavings(savings);
            }
        }
        $(animatedElement).queue("fx", function(next) {
            $(Results.settings.elements.resultsContainer).trigger("resultsAnimated");
            next();
        });
    },
    setDisplayMode: function(mode, forceRefresh) {
        if (mode != Results.settings.displayMode || forceRefresh) {
            $(Results.settings.elements.resultsContainer).removeClass(Results.settings.displayMode + "Mode");
            $(Results.settings.elements.resultsContainer).addClass(mode + "Mode");
            Results.settings.displayMode = mode;
            if (mode == "features") {
                Results.view.orientation = "vertical";
                $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.features.allElements).css("display", "block");
                Results.view.calculateResultsContainerWidth();
            } else {
                Results.view.$containerElement.css("margin-left", "0px");
                Results.view.$containerElement.css("width", "auto");
                $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.features.allElements).css("display", "none");
            }
            if (mode == "price") {
                Results.view.orientation = "horizontal";
            }
            if (forceRefresh === true) {
                $(Results.settings.elements.resultsContainer).trigger(mode + "DisplayMode");
            }
            if (typeof meerkat !== "undefined") {
                meerkat.messaging.publish(Results.view.moduleEvents.RESULTS_TOGGLE_MODE);
            }
        }
    },
    calculateResultsContainerWidth: function() {
        ResultsUtilities.setContainerWidth(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered", Results.settings.elements.resultsContainer + " " + Results.settings.elements.container);
    },
    setColumnWidth: function($container, nbColumns, hasOutsideGutters) {
        if (typeof hasOutsideGutters === "undefined") {
            hasOutsideGutters = true;
        }
        var columnMargin = parseInt($(Results.settings.elements.rows).first().css("margin-right"));
        var nbMargins = nbColumns * 2;
        if (!hasOutsideGutters) {
            nbMargins -= 2;
        }
        var width = ($container.width() - nbMargins * columnMargin) / nbColumns;
        $(Results.settings.elements.rows).width(width);
        if (typeof Features != "undefined" && Features) {
            Features.balanceVisibleRowsHeight();
        }
        if (Results.settings.pagination.touchEnabled === true) {
            ResultsUtilities.setContainerWidth($(Results.settings.elements.rows).not(".filtered"), $(Results.settings.elements.container));
        } else {
            ResultsUtilities.setContainerWidth($(Results.settings.elements.rows), $(Results.settings.elements.container));
        }
        Results.pagination.reposition();
    },
    setOverflowWidthToWindowWidth: function() {
        $(Results.settings.elements.resultsOverflow).width($(window).width());
    },
    startColumnWidthTracking: function($container, nbColumns, hasOutsideGutters) {
        if (Results.view.currentlyColumnWidthTracking === true) {
            $(window).off("resize.ResultsView.columnWidthTracking");
        }
        Results.view.currentlyColumnWidthTracking = true;
        Results.view.setColumnWidth($container, nbColumns, hasOutsideGutters);
        Results.view.setOverflowWidthToWindowWidth();
        if (typeof Features !== "undefined") {
            Features.balanceVisibleRowsHeight();
        }
        $(window).on("resize.ResultsView.columnWidthTracking", _.debounce(function debounceColumnWidthTracking() {
            Results.view.setColumnWidth($container, nbColumns, hasOutsideGutters);
            Results.view.setOverflowWidthToWindowWidth();
        }));
    },
    stopColumnWidthTracking: function() {
        Results.view.currentlyColumnWidthTracking = false;
        $(window).off("resize.ResultsView.columnWidthTracking");
        _.defer(function() {
            $(Results.settings.elements.rows).width("");
            $(Results.settings.elements.resultsOverflow).width("");
            if (typeof Features !== "undefined" && Results.getDisplayMode() === "features") {
                Features.balanceVisibleRowsHeight();
            }
            Results.pagination.resync();
        });
    },
    buildHtml: function() {
        var results;
        var resultRow = "";
        var resultsHtml = "";
        var resultTemplate = $(Results.settings.elements.templates.result).html();
        if (resultTemplate == "") {
            console.log("The result template could not be found: templateSelector=", Results.settings.elements.templates.result, "This template is mandatory, make sure to pass the correct selector to the Results.settings.elements.templates.result user setting when calling Results.init()");
        }
        if (Results.settings.elements.templates.unavailable) {
            var unavailableTemplate = $(Results.settings.elements.templates.unavailable).html();
            if (unavailableTemplate == "") {
                console.log("The unavailable template could not be found: templateSelector=", Results.settings.elements.templates.unavailable, "If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.unavailable user setting when calling Results.init()");
            }
        }
        if (Results.settings.elements.templates.unavailableCombined) {
            var unavailableCombinedTemplate = $(Results.settings.elements.templates.unavailableCombined).html();
            if (unavailableCombinedTemplate == "") {
                console.log("The unavailable combined template could not be found: templateSelector=", Results.settings.elements.templates.unavailableCombinedTemplate, "If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.unavailableCombinedTemplate user setting when calling Results.init()");
            }
        }
        if (Results.settings.elements.templates.error) {
            var errorTemplate = $(Results.settings.elements.templates.error).html();
            if (errorTemplate == "") {
                console.log("The error template could not be found: templateSelector=", Results.settings.elements.templates.error, "If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.error user setting when calling Results.init()");
            }
        }
        if (Results.settings.elements.templates.currentProduct) {
            var currentProductTemplate = $(Results.settings.elements.templates.currentProduct).html();
            if (currentProductTemplate == "") {
                console.log("The current Product template could not be found: templateSelector=", Results.settings.elements.templates.currentProduct, "If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.currentProduct user setting when calling Results.init()");
            }
        }
        var topResult = Results.model.sortedProducts[0];
        var topResultRow = false;
        var countVisible = 0;
        var countUnavailable = 0;
        results = Results.model.sortedProducts;
        $.each(results, function(index, result) {
            var productAvailability = null;
            if (Results.settings.paths.availability.product && Results.settings.paths.availability.product != "") {
                var productAvailability = Object.byString(result, Results.settings.paths.availability.product);
            }
            if (typeof productAvailability !== "undefined" && productAvailability !== "Y" && !unavailableTemplate) {
                countUnavailable++;
                resultRow = $(Results.view.parseTemplate("<div></div>", result));
            } else if (typeof productAvailability !== "undefined" && productAvailability === "E") {
                countUnavailable++;
                resultRow = $(Results.view.parseTemplate(errorTemplate, result));
            } else if (typeof productAvailability !== "undefined" && productAvailability !== "Y") {
                countUnavailable++;
                resultRow = $(Results.view.parseTemplate(unavailableTemplate, result));
            } else {
                if (Results.model.currentProduct && Results.model.currentProduct.value == Object.byString(result, Results.model.currentProduct.path)) {
                    resultRow = $(Results.view.parseTemplate(currentProductTemplate, result));
                } else {
                    resultRow = $(Results.view.parseTemplate(resultTemplate, result));
                }
            }
            if ($.inArray(result, Results.model.filteredProducts) == -1) {
                $row = $(resultRow);
                $row.addClass("filtered");
                $row.hide();
                $row.attr("data-position", "undefined");
            } else {
                $(resultRow).addClass("notfiltered").attr("data-position", countVisible);
                countVisible++;
            }
            $(resultRow).attr("id", "result-row-" + index).attr("data-sort", index);
            if (result == topResult) {
                topResultRow = "#result-row-" + index;
            }
            resultsHtml += $(resultRow)[0].outerHTML || new XMLSerializer().serializeToString($(resultRow)[0]);
        });
        if (Results.settings.show.hasOwnProperty("unavailableCombined") && Results.settings.show.unavailableCombined === true && countUnavailable > 0) {
            resultRow = $(Results.view.parseTemplate(unavailableCombinedTemplate, results));
            resultsHtml += $(resultRow)[0].outerHTML;
        }
        $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.container).append(resultsHtml);
        Results.view.setTopResult($(topResultRow));
        Results.view.toggleFrequency(Results.settings.frequency);
        $(Results.settings.elements.resultsContainer).trigger("resultsLoaded");
        Results.pagination.refresh();
    },
    parseTemplate: function(template, data) {
        if (Results.settings.render.templateEngine == "microTemplate") {
            htmlString = parseTemplate(template, data);
        } else {
            htmlTemplate = _.template(template);
            htmlString = htmlTemplate(data);
        }
        return htmlString;
    },
    getRowHeight: function() {
        if (Results.view.orientation == "horizontal" && !Results.view.rowHeight) {
            Results.view.rowHeight = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered").first().outerHeight(true);
        }
        return Results.view.rowHeight;
    },
    getRowWidth: function() {
        if (Results.view.orientation == "vertical" && !Results.view.rowWidth) {
            Results.view.rowWidth = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered").first().outerWidth(true);
        }
        return Results.view.rowWidth;
    },
    setTopResult: function(element) {
        if (Results.settings.show.topResult) {
            $(Results.settings.elements.rows).find(".topResult").remove();
            $(element).prepend('<div class="topResult"></div>');
            $(Results.settings.elements.resultsContainer).trigger("topResultSet");
        }
    },
    animateIndividualResults: function() {
        var delay = Results.settings.animation.results.delay;
        var individualDelay = Results.settings.animation.results.options.duration + Results.settings.animation.results.individual.delay;
        $(Results.settings.elements.rows).each(function() {
            delay += individualDelay;
            $(this).stop(true, true).delay(delay).show(Results.settings.animation.results.options);
            if (individualDelay - Results.settings.animation.results.individual.acceleration >= 0) {
                individualDelay -= Results.settings.animation.results.individual.acceleration;
            }
        });
    },
    animateAllResults: function() {
        $(Results.settings.elements.rows + ".notFiltered").show();
        $(Results.settings.elements.resultsContainer).css("opacity", 0);
        $(Results.settings.elements.resultsContainer).stop(true, true).delay(Results.settings.animation.results.delay).animate({
            opacity: 1
        }, Results.settings.animation.results.options);
    },
    showResults: function() {
        if (Results.view.noResultsMode === true) {
            Results.view.noResultsMode = false;
            Results.view.toggleFilters("show");
            Results.view.toggleCompare("show");
            $(Results.settings.elements.features.headers + ", " + Results.settings.elements.resultsOverflow).show();
            $(Results.settings.elements.resultsContainer).find(".noResults.clone").remove();
        }
    },
    showNoFilteredResults: function() {
        Results.view.noResultsMode = true;
        Results.view.toggleFilters("hide");
        Results.view.toggleCompare("hide");
        $(Results.settings.elements.features.headers + ", " + Results.settings.elements.resultsOverflow).hide();
        $(Results.settings.elements.resultsContainer).find(".noResults.clone").remove().end().append($(Results.settings.elements.noResults).clone().addClass("clone").stop(true, true).delay(500).fadeIn(800));
        Results.pagination.reset();
    },
    showNoResults: function() {
        Results.view.noResultsMode = true;
        Results.view.toggleFilters("hide");
        Results.view.toggleCompare("hide");
        Results.view.flush();
        $(Results.settings.elements.features.headers).hide();
        $(Results.settings.elements.resultsOverflow).hide();
        $(Results.settings.elements.resultsContainer).find(".noResults.clone").remove();
        $(Results.settings.elements.resultsContainer).append($(Results.settings.elements.noResults).clone().addClass("clone").stop(true, true).delay(500).fadeIn(800));
        Results.pagination.reset();
    },
    shuffle: function(previousSortedResults) {
        var allRows = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows);
        if (Results.settings.animation.shuffle.active === true) {
            ResultsUtilities.position("absolute", allRows, Results.view.orientation);
        }
        setTimeout(function shuffleSetTimeout() {
            if (typeof previousSortedResults == "undefined") {
                previousSortedResults = Results.model.returnedProducts.slice();
            }
            var currentTop = 0;
            var currentLeft = 0;
            var topResultIndex = 0;
            var rowHeight = Results.view.getRowHeight();
            var rowWidth = Results.view.getRowWidth();
            $(Results.settings.elements.resultsContainer).trigger("results.view.animation.start");
            $.each(Results.model.sortedProducts, function(sortedIndex, sortedResult) {
                var previousIndex;
                $.each(previousSortedResults, function(currentPreviousIndex, previousResult) {
                    if (sortedResult == previousResult) {
                        previousIndex = currentPreviousIndex;
                        return false;
                    }
                });
                var currentResult = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId='" + Object.byString(sortedResult, "productId") + "']");
                var posDifference = sortedIndex - previousIndex;
                var shuffleOptions = false;
                if (Results.settings.animation.shuffle.active === true) {
                    shuffleOptions = Results.settings.animation.shuffle.options;
                }
                Results.view.moveResult(currentResult, sortedIndex, posDifference, currentTop, currentLeft, shuffleOptions);
                if (!Results.view.shuffleTransitionDuration) {
                    Results.view.shuffleTransitionDuration = currentResult.transitionDuration();
                }
                currentResult.attr("data-sort", sortedIndex);
                if (currentResult.hasClass("notfiltered")) {
                    if (sortedIndex == topResultIndex) {
                        Results.view.setTopResult(currentResult);
                    }
                    currentTop += rowHeight;
                    currentLeft += rowWidth;
                } else {
                    topResultIndex++;
                }
            });
            var animationDuration = Results.view.shuffleTransitionDuration != 0 ? Results.view.shuffleTransitionDuration : Results.settings.animation.shuffle.options.duration + 50;
            $(Results.settings.elements.rows).clearQueue(Results.settings.animation.filter.queue).dequeue(Results.settings.animation.shuffle.options.queue);
            Results.view.afterAnimation(animationDuration, function() {
                $(Results.settings.elements.resultsContainer).trigger("resultsSorted");
                if (typeof meerkat !== "undefined") {
                    meerkat.messaging.publish(Results.view.moduleEvents.RESULTS_SORTED);
                }
                Results.pagination.invalidate();
                Results.pagination.refresh();
                $(Results.settings.elements.resultsContainer).trigger("results.view.animation.end");
            });
        }, 0);
    },
    filter: function() {
        Results.view.showResults();
        if (Results.settings.animation.filter.active === true) {
            Results.view.beforeAnimation();
        }
        var firstVisible = false;
        var countVisible = 0;
        var currentTop = 0;
        var currentLeft = 0;
        var countMoved = 0;
        var countFadedIn = 0;
        var countFadedOut = 0;
        var repositionAnimationOptions = false;
        if (Results.settings.animation.filter.active === true) {
            repositionAnimationOptions = $.extend(Results.settings.animation.filter.reposition.options, {
                queue: Results.settings.animation.filter.queue
            });
        }
        if (typeof Features !== "undefined" && Features.target !== false) {
            var items = [];
            for (var i = 0; i < Results.model.filteredProducts.length; i++) {
                var product = Results.model.filteredProducts[i];
                var productId = Object.byString(product, Results.settings.paths.productId);
                items.push(Results.settings.elements.rows + "[data-productId='" + productId + "'].filtered");
            }
            if (items.length > 0) {
                $items = $(items.join(","));
                if ($items.length > 0) {
                    $items.show();
                    Features.balanceVisibleRowsHeight();
                    $(Results.settings.elements.rows + ".filtered").hide();
                }
            }
        }
        $.each(Results.model.sortedProducts, function iterateSortedProducts(sortedIndex, product) {
            var productId = Object.byString(product, Results.settings.paths.productId);
            var currentResult = $(Results.settings.elements.rows + "[data-productId='" + productId + "']");
            if ($.inArray(product, Results.model.filteredProducts) == -1) {
                Results.view.fadeResultOut(currentResult, Results.settings.animation.filter.active);
                countFadedOut++;
            } else {
                if (!firstVisible) {
                    firstVisible = true;
                    Results.view.setTopResult(currentResult);
                }
                if (currentResult.hasClass("filtered")) {
                    Results.view.fadeResultIn(currentResult, countVisible, Results.settings.animation.filter.active);
                    countFadedIn++;
                } else {
                    var prevPosition = currentResult.attr("data-position");
                    if (countVisible != prevPosition) {
                        var posDifference = countVisible - prevPosition;
                        Results.view.moveResult(currentResult, countVisible, posDifference, currentTop, currentLeft, repositionAnimationOptions);
                        countMoved++;
                    }
                }
                countVisible++;
                currentTop += Results.view.getRowHeight();
                currentLeft += Results.view.getRowWidth();
            }
            if (Results.settings.animation.filter.active === true) {
                if (!Results.view.filterTransitionDuration || currentResult.transitionDuration() > Results.view.filterTransitionDuration) {
                    Results.view.filterTransitionDuration = currentResult.transitionDuration();
                }
            }
        });
        setTimeout(function() {
            Results.view.setDisplayMode(Results.settings.displayMode, "partial");
        }, 0);
        if (Results.settings.animation.filter.active === true) {
            $(Results.settings.elements.rows).clearQueue(Results.settings.animation.shuffle.options.queue).dequeue(Results.settings.animation.filter.queue);
            var animationDuration = 0;
            if (countMoved == 0 && countFadedIn == 0 && countFadedOut == 0) {
                animationDuration = 1;
            } else if (Results.view.filterTransitionDuration != 0) {
                animationDuration = Results.view.filterTransitionDuration;
                animationDuration += 200;
            } else {
                var durations = new Array();
                if (countMoved != 0) durations.push(Results.settings.animation.filter.reposition.options.duration);
                if (countFadedIn != 0) durations.push(Results.settings.animation.filter.appear.options.duration);
                if (countFadedOut != 0) durations.push(Results.settings.animation.filter.disappear.options.duration);
                $.each(durations, function(index, duration) {
                    if (duration > animationDuration) {
                        animationDuration = duration;
                    }
                });
                animationDuration += 50;
            }
        } else {
            animationDuration = 0;
        }
        Results.view.afterAnimation(animationDuration, function() {
            $(Results.settings.elements.resultsContainer).trigger("resultsFiltered");
            $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".filtered").css("display", "none");
            Results.view.setDisplayMode(Results.settings.displayMode, "partial");
            _.defer(function() {
                Results.pagination.invalidate();
                Results.pagination.refresh();
                $(Results.settings.elements.resultsContainer).trigger("results.view.animation.end");
            });
        });
    },
    beforeAnimation: function() {
        var allRows = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows);
        ResultsUtilities.position("absolute", allRows, Results.view.orientation);
        $(Results.settings.elements.resultsContainer).trigger("results.view.animation.start");
        Results.view.disableDuringAnimation();
    },
    afterAnimation: function(animationDuration, callback) {
        var allRows = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows);
        setTimeout(function() {
            ResultsUtilities.position("relative", allRows);
            allRows.sort(function(a, b) {
                var sortA = parseInt($(a).attr("data-sort"));
                var sortB = parseInt($(b).attr("data-sort"));
                return sortA < sortB ? -1 : sortA > sortB ? 1 : 0;
            }).each(function() {
                $(this).appendTo(Results.settings.elements.resultsContainer + " " + Results.settings.elements.container);
            });
            if (animationDuration !== 0) {
                if (Modernizr.csstransforms3d) {
                    allRows.removeClass("transformTransition").removeClass("opacityTransition").addClass("noTransformTransition").css(Modernizr.prefixed("transform"), "");
                    setTimeout(function() {
                        allRows.removeClass("noTransformTransition");
                    }, 0);
                } else if (Modernizr.csstransitions) {
                    allRows.removeClass("leftTransition").removeClass("topTransition").removeClass("opacityTransition");
                }
            }
            Results.view.enableAfterAnimation();
            if (typeof callback == "function") {
                callback();
            }
        }, animationDuration);
    },
    disableDuringAnimation: function() {
        if (typeof Compare != "undefined") {
            Compare.view.toggleButton("disable");
        }
    },
    enableAfterAnimation: function() {
        if (typeof Compare != "undefined") {
            Compare.view.toggleButton("enable");
        }
    },
    moveResult: function(resultElement, position, posDifference, top, left, animationOptions) {
        var currentPosition = resultElement.attr("data-position");
        if (currentPosition == position) {
            return true;
        }
        resultElement.attr("data-position", position);
        if (animationOptions !== false) {
            if (Modernizr.csstransitions) {
                resultElement.addClass("hardwareAcceleration");
                _.defer(function() {
                    if (Results.view.orientation == "horizontal") {
                        resultElement.addClass("topTransition");
                        resultElement.css("top", top);
                    } else {
                        resultElement.addClass("leftTransition");
                        resultElement.css("left", left);
                    }
                });
                _.delay(function() {
                    resultElement.removeClass("hardwareAcceleration");
                }, animationOptions.duration + 100);
            } else {
                var animatedProperty = new Object();
                if (Results.view.orientation == "horizontal") {
                    animatedProperty = {
                        top: top
                    };
                } else {
                    animatedProperty = {
                        left: left
                    };
                }
                resultElement.animate(animatedProperty, animationOptions);
            }
        } else {
            if (Results.view.orientation == "horizontal") {
                resultElement.css("top", top);
            } else {
                resultElement.css("left", left);
            }
        }
    },
    fadeResultIn: function(resultElement, position, animate) {
        if (Results.view.orientation == "vertical") {
            resultElement.css("left", position * Results.view.getRowWidth());
        } else {
            resultElement.css("top", position * Results.view.getRowHeight());
        }
        if (animate === true) {
            if (Modernizr.csstransitions) {
                resultElement.addClass("hardwareAcceleration");
                resultElement.addClass("opacityTransition").css("display", "block");
                setTimeout(function() {
                    resultElement.removeClass("filtered").addClass("notfiltered");
                }, 0);
                _.delay(function() {
                    resultElement.removeClass("hardwareAcceleration");
                }, 1e3);
            } else {
                resultElement.removeClass("filtered").addClass("notfiltered");
                var options = $.extend(Results.settings.animation.filter.appear.options, {
                    queue: Results.settings.animation.filter.queue
                });
                resultElement.fadeIn(options);
            }
        } else {
            resultElement.removeClass("filtered").addClass("notfiltered");
            resultElement.css("display", "block");
        }
        resultElement.attr("data-position", position);
    },
    fadeResultOut: function(resultElement, animate) {
        if (animate === true) {
            if (Modernizr.csstransitions) {
                resultElement.addClass("hardwareAcceleration");
                resultElement.addClass("opacityTransition").addClass("filtered").removeClass("notfiltered");
                _.delay(function() {
                    resultElement.removeClass("hardwareAcceleration");
                }, 1e3);
            } else {
                var options = $.extend(Results.settings.animation.filter.disappear.options, {
                    queue: Results.settings.animation.filter.queue,
                    complete: function() {
                        $(this).addClass("filtered").removeClass("notfiltered");
                    }
                });
                resultElement.fadeOut(options);
            }
        } else {
            resultElement.addClass("filtered").removeClass("notfiltered");
        }
        resultElement.attr("data-position", "undefined");
    },
    showResultsPage: function() {
        if (Results.settings.runShowResultsPage === false) {
            return;
        }
        if (!$(Results.settings.elements.page).is(":visible")) {
            $("body, html").animate({
                scrollTop: 0
            }, 500);
            Results.view.toggleReferenceNo();
            $(Results.settings.formSelector).find(":input").removeAttr("data-visible");
            $(Results.settings.formSelector).find(":input:visible, .ui-dialog :input, .force-invisible-select :input").attr("data-visible", "true");
            if ($("#page").length > 0) {
                $("#page").slideUp("fast", function() {
                    $(Results.settings.elements.page).show();
                    Results.view.toggleHeaderSize();
                    Results.view.toggleProgressBar();
                    Results.view.toggleResultsSummary();
                });
            }
            if (typeof btnInit !== "undefined") {
                btnInit._show();
            }
        }
    },
    hideResultsPage: function() {
        if ($(Results.settings.elements.page).is(":visible")) {
            $("body, html").scrollTop(0);
            Results.view.toggleHeaderSize();
            Results.view.toggleProgressBar();
            Results.view.toggleReferenceNo();
            Results.view.toggleFilters("hide");
            Results.view.toggleCompare("hide");
            Results.view.toggleResultsSummary();
            if ($("#page").length > 0) {
                $("#page").slideDown(300);
                $(Results.settings.elements.page).hide();
            }
            $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.container).css("margin-left", 0);
            Results.pagination.reset();
            $(Results.settings.elements.page + " .resultsOverlay").hide(0);
        }
    },
    toggleResultsPage: function() {
        if ($(Results.settings.elements.page).is(":visible")) {
            Results.view.hideResultsPage();
        } else {
            Results.view.showResultsPage();
        }
    },
    toggleProgressBar: function() {
        $("#steps").toggle(0);
    },
    toggleReferenceNo: function() {
        if (typeof referenceNo != "undefined" && referenceNo.showReferenceNumber) {
            $(referenceNo.elements.root).slideToggle(200);
        }
    },
    toggleCompare: function(action) {
        if (typeof Compare != "undefined") {
            if (action && action == "hide") {
                $(Compare.settings.elements.bar).hide();
            } else if (action && action == "show") {
                $(Compare.settings.elements.bar).fadeIn(400, function() {
                    Compare.topPosition = $(Compare.settings.elements.bar).offset().top;
                });
            } else {
                $(Compare.settings.elements.bar).toggle(0);
                Compare.topPosition = $(Compare.settings.elements.bar).offset().top;
            }
        }
    },
    toggleFilters: function(action) {
        if (typeof Filters != "undefined") {
            if (action && action == "hide") {
                $(Filters.settings.elements.filtersBar).hide();
            } else if (action && action == "show") {
                $(Filters.settings.elements.filtersBar).fadeIn();
            } else {
                $(Filters.settings.elements.filtersBar).toggle(0);
            }
        }
    },
    toggleHeaderSize: function() {
        if ($("#header").hasClass("normal-header")) {
            $("#header").removeClass("normal-header");
            $("#header").addClass("narrow-header");
        } else {
            $("#header").removeClass("narrow-header");
            $("#header").addClass("normal-header");
        }
    },
    toggleResultsSummary: function() {
        $("#resultsDes").hide();
        if ($("#navContainer #summary-header").length === 0) {
            $("#summary-header").prependTo("#navContainer");
            $("#summary-header").show();
        } else {
            $("#summary-header").toggle();
        }
    },
    toggleFrequency: function(frequency) {
        try {
            $(Results.settings.elements.frequency).hide();
            $("." + frequency + Results.settings.elements.frequency).show();
        } catch (e) {
            Results.onError("Sorry, an error occurred toggling frequencies", "ResultsView.js", "Results.view.toggleFrequency(); " + e.message, e);
        }
    },
    flush: function() {
        $(Results.settings.elements.rows).remove();
    }
};

Features = new Object();

Features = {
    template: false,
    target: false,
    results: false,
    featuresIds: false,
    emptyAdditionalInfoCategory: true,
    init: function(target) {
        if (typeof target === "undefined") {
            Features.target = Results.settings.elements.resultsContainer;
        } else {
            Features.target = target;
        }
        if (typeof meerkat !== "undefined") {
            meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function deviceMediaStateChange(state) {
                if (Results.getDisplayMode() !== "features") return;
                if ($(Results.settings.elements.resultsContainer + " :visible").length > 0) {
                    Results.view.calculateResultsContainerWidth();
                    Features.clearSetHeights();
                    Features.balanceVisibleRowsHeight();
                }
            });
        }
        Features.applyExpandableEvents();
    },
    buildHtml: function(results) {
        if (typeof results === "undefined") {
            Features.results = Results.model.sortedProducts;
        } else {
            Features.results = results;
        }
        Features.template = $(Results.settings.elements.templates.feature).html();
        if (Features.template == "") {
            console.log("The comparison feature template could not be found: templateSelector=", Compare.settings.elements.templates.feature, "This template is mandatory, make sure to pass the correct selector to the Compare.settings.elements.templates.feature user setting when calling Compare.init()");
        } else {
            $(Results.settings.elements.resultsContainer).trigger("populateFeaturesStart");
            Features.populateHeaders();
            Features.populateFeatures();
            Features.setExpandableRows();
            _.defer(function() {
                Features.clearSetHeights();
                Features.balanceVisibleRowsHeight();
                $(Results.settings.elements.resultsContainer).trigger("populateFeaturesEnd");
            });
            Features.hideEmptyRows();
            $(Features.target).trigger("FeaturesRendered");
        }
    },
    populateHeaders: function() {
        if (Results.settings.render.features.headers === true) {
            Features.emptyAdditionalInfoCategory = true;
            var featuresIds = new Array();
            var html = "";
            $.each(Features.results, function(index, result) {
                var productAvailability = null;
                if (Results.settings.paths.availability.product && Results.settings.paths.availability.product != "") {
                    var productAvailability = Object.byString(result, Results.settings.paths.availability.product);
                }
                if (productAvailability == "Y" || typeof productAvailability == "undefined") {
                    var features = Object.byString(result, Results.settings.paths.features);
                    if (typeof features != "undefined" && features.length > 0) {
                        var currentCategory = "";
                        $.each(features, function(index, feature) {
                            if (Features.emptyAdditionalInfoCategory && feature.categoryId == 9 && feature.extra != "") {
                                Features.emptyAdditionalInfoCategory = false;
                            }
                            if ($.inArray(feature.featureId, featuresIds) == -1) {
                                featuresIds.push(feature.featureId);
                                if (Results.settings.show.featuresCategories && currentCategory != feature.categoryId) {
                                    parsedCategory = Results.view.parseTemplate(Features.template, {
                                        value: feature.categoryName,
                                        featureId: "category-" + feature.categoryId,
                                        extra: "",
                                        cellType: "category"
                                    });
                                    html += parsedCategory;
                                    currentCategory = feature.categoryId;
                                }
                                if (!isNaN(feature.desc)) {
                                    feature.desc = "";
                                }
                                var parsedFeatureId = Results.view.parseTemplate(Features.template, {
                                    featureId: feature.featureId,
                                    value: feature.desc,
                                    extra: "&nbsp;",
                                    cellType: "feature"
                                });
                                html += parsedFeatureId;
                            }
                        });
                    }
                }
            });
            $(Features.target + " " + Results.settings.elements.features.headers + " " + Results.settings.elements.features.list).html(html);
            Features.featuresIds = featuresIds;
        }
    },
    populateFeatures: function() {
        $.each(Features.results, function(index, product) {
            var productAvailability = null;
            if (Results.settings.paths.availability.product && Results.settings.paths.availability.product != "") {
                var productAvailability = Object.byString(product, Results.settings.paths.availability.product);
            }
            if ((productAvailability == "Y" || typeof productAvailability == "undefined") && (!Results.model.currentProduct || Results.model.currentProduct.value != Object.byString(product, Results.model.currentProduct.path))) {
                var productId = Object.byString(product, Results.settings.paths.productId);
                var $targetContainer = $(Features.target + " " + Results.settings.elements.rows + "[data-productId='" + productId + "']").find(Results.settings.elements.features.list);
                var html = "";
                if (Results.settings.render.features.mode == "populate") {
                    html = Features.populateTemplate(product);
                } else {
                    html = Features.buildAndPopulateTemplate(product);
                }
                $targetContainer.html(html);
            }
        });
        if (Features.emptyAdditionalInfoCategory) {
            $(Features.target + " [data-featureId=category-9]").next().remove();
            $(Features.target + " [data-featureId=category-9]").remove();
        }
    },
    populateTemplate: function(product) {
        var currentProductTemplate = $(Results.settings.elements.templates.feature).html();
        return Results.view.parseTemplate(currentProductTemplate, product);
    },
    buildAndPopulateTemplate: function(product) {
        var html = "";
        var currentCategory = "";
        $.each(Features.featuresIds, function(featureIdIndex, featureId) {
            var features = Object.byString(product, Results.settings.paths.features);
            var foundFeature = false;
            var parsedFeature = "";
            $.each(features, function(featureIndex, feature) {
                if (feature.featureId == featureId) {
                    foundFeature = feature;
                    feature.value = Features.parseFeatureValue(feature.value);
                    if (feature.extra == "") {
                        feature.extra = "&nbsp;";
                    }
                    if (feature.value == "" && feature.extra != "") {
                        feature.value = feature.extra;
                        feature.extra = "&nbsp;";
                    }
                    parsedFeature = Results.view.parseTemplate(Features.template, $.extend(feature, {
                        cellType: "feature"
                    }));
                    return false;
                }
            });
            if (!foundFeature) {
                var parsedFeature = Results.view.parseTemplate(Features.template, {
                    value: "&nbsp;",
                    featureId: featureId,
                    extra: "",
                    cellType: "feature"
                });
            } else {
                if (Results.settings.show.featuresCategories && currentCategory != foundFeature.categoryId) {
                    parsedCategory = Results.view.parseTemplate(Features.template, {
                        value: "&nbsp;",
                        featureId: "category-" + foundFeature.categoryId,
                        extra: "",
                        cellType: "category"
                    });
                    html += parsedCategory;
                    currentCategory = foundFeature.categoryId;
                }
            }
            html += parsedFeature;
        });
        return html;
    },
    parseFeatureValue: function(value) {
        if (typeof value === "undefined" || value === "") {
            value = "&nbsp;";
        } else {
            var obj = _.findWhere(Results.settings.dictionary.valueMap, {
                key: value
            });
            if (typeof obj !== "undefined") {
                value = obj.value;
            }
        }
        return value;
    },
    setExpandableRows: function() {
        if ($(Features.target + " .expandable").length == 0) {
            $(Features.target + " " + Results.settings.elements.rows + ".notfiltered " + Results.settings.elements.features.extras + " " + Results.settings.elements.features.values).filter(function() {
                return $(this).html() != "&nbsp;" && $(this).html() != "";
            }).parent().parent().addClass(Results.settings.elements.features.expandable.replace(/[#\.]/g, ""));
        }
    },
    applyExpandableEvents: function() {
        $(document.body).on("click", Features.target + " .expandable > " + Results.settings.elements.features.values, function(e) {
            var featureId = $(this).attr("data-featureId");
            var $extras = $(Features.target + ' .children[data-fid="' + featureId + '"]');
            var $parents = $extras.parent();
            if ($parents.hasClass("expanded") === false) {
                Features.toggleOpen($extras, $parents);
            } else {
                Features.toggleClose($parents);
            }
        }).on("click", ".expandAllFeatures, .collapseAllFeatures", function(e) {
            e.preventDefault();
            $(this).parent().find(".active").removeClass("active");
            $(this).addClass("active");
            var $extras = $(Features.target + " .children[data-fid]"), $parents = $extras.parent();
            if ($(this).hasClass("expandAllFeatures")) {
                Features.toggleOpen($extras, $parents);
            } else {
                Features.toggleClose($parents);
            }
        });
    },
    toggleClose: function($parents) {
        $parents.removeClass("expanded").addClass("collapsed");
    },
    toggleOpen: function($extras, $parents) {
        _.defer(function() {
            $parents.removeClass("collapsed").addClass("expanding");
            _.defer(function() {
                Features.sameHeightRows($extras.find(Results.settings.elements.features.values + ":visible"));
                $parents.removeClass("expanding").addClass("expanded");
            });
        });
    },
    clearSetHeights: function() {
        $(Features.target + " " + Results.settings.elements.features.values).removeClass(function(index, css) {
            return (css.match(/\height\S+/g) || []).join(" ");
        });
        $(Features.target + " " + Results.settings.elements.features.values).css("height", "");
    },
    balanceVisibleRowsHeight: function() {
        if (Features.target === false || typeof Results.getDisplayMode === "function" && Results.getDisplayMode() == "price") {
            return;
        }
        var visibleMultirowElements = $(Features.target + " " + Results.settings.elements.features.values + ":visible");
        Features.sameHeightRows(visibleMultirowElements);
    },
    sameHeightRows: function(elements) {
        var featureRowCache = [];
        elements.each(function elementsEach(elementIndex, element) {
            $e = $(element);
            var featureId = $e.attr("data-featureId");
            var item = _.findWhere(featureRowCache, {
                featureId: featureId
            });
            if (typeof item != "undefined") {
                item.height = Math.max(getHeight($e), item.height);
                item.elements.push($e);
            } else {
                var obj = {};
                obj.featureId = featureId;
                obj.height = getHeight($e);
                obj.elements = [];
                obj.elements.push($e);
                featureRowCache.push(obj);
            }
        });
        for (var i = 0; i < featureRowCache.length; i++) {
            var item2 = featureRowCache[i];
            for (var j = 0; j < item2.elements.length; j++) {
                var $ee = item2.elements[j];
                var roundedHeight = Math.ceil(item2.height / 10) * 10;
                if (typeof meerkat !== "undefined") {
                    if (meerkat.site.vertical == "car" || meerkat.site.vertical == "home") {
                        roundedHeight = roundedHeight - 5;
                    }
                }
                if (roundedHeight <= 270) {
                    $ee.addClass("height" + roundedHeight);
                } else {
                    $ee.height(item2.height);
                }
            }
        }
        function getHeight($h) {
            if ($h.hasClass("isMultiRow") || $h.hasClass("h")) {
                return $h.innerHeight();
            } else {
                return 0;
            }
        }
    },
    hideEmptyRows: function() {
        $.each(Features.featuresIds, function(featureIdIndex, featureId) {
            var found = false;
            $currentRow = $(Features.target + ' [data-featureId="' + featureId + '"]');
            $currentRow.each(function() {
                var value = $(this).html();
                if (!found && value != "" && value != "&nbsp;") {
                    found = true;
                }
            });
            if (!found) {
                $currentRow.parent().hide();
            }
        });
    },
    flush: function() {
        $(Features.target).find(Results.settings.elements.features.list).html("");
    }
};

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var moduleEvents = {
        ADDRESS_CHANGE: "ADDRESS_CHANGE"
    };
    var settings = {
        defaultHash: ""
    }, previousHash;
    function setHash(value) {
        window.location.hash = value;
        previousHash = value;
    }
    function setStartHash(value) {
        settings.defaultHash = value;
        previousHash = value;
    }
    function appendToHash(value) {
        if (_.indexOf(getWindowHashAsArray(), value) == -1) {
            window.location.hash = getWindowHash() + "/" + value;
            previousHash = window.location.hash;
        }
    }
    function getPreviousHash() {
        return previousHash;
    }
    function removeFromHash(value) {
        var hashArray = meerkat.modules.address.getWindowHashAsArray();
        for (var j = hashArray.length - 1; j >= 0; j--) {
            if (hashArray[j] == value) {
                hashArray.splice(j, 1);
            }
        }
        window.location.hash = hashArray.join("/");
    }
    function initAddress() {
        var self = this;
        $(window).on("hashchange", function onHashChange(eventObject) {
            meerkat.messaging.publish(moduleEvents.ADDRESS_CHANGE, {
                previousHash: meerkat.modules.address.getPreviousHash(),
                hash: meerkat.modules.address.getWindowHash(),
                hashArray: meerkat.modules.address.getWindowHashAsArray()
            });
        });
    }
    function getWindowHashAsArray() {
        return getWindowHash().split("/");
    }
    function getWindowHashAt(position) {
        var hashArray = getWindowHashAsArray();
        if (position >= hashArray.length) return "";
        return hashArray[position];
    }
    function getWindowHash() {
        var hash = window.location.hash;
        if (hash != null) return hash.replace("#", "");
        return "";
    }
    meerkat.modules.register("address", {
        init: initAddress,
        events: moduleEvents,
        getWindowHashAsArray: getWindowHashAsArray,
        getWindowHash: getWindowHash,
        getPreviousHash: getPreviousHash,
        setHash: setHash,
        appendToHash: appendToHash,
        removeFromHash: removeFromHash,
        setStartHash: setStartHash,
        getWindowHashAt: getWindowHashAt
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        address_lookup: {
            HIDDEN_FIELDS_POPULATED: "HIDDEN_FIELDS_POPULATED"
        }
    };
    var moduleEvents = events.address_lookup;
    var $currentAjaxRequest = null, dpIdCache = {}, addressFieldId;
    function initAddressLookup() {
        meerkat.messaging.subscribe(meerkatEvents.autocomplete.ELASTIC_SEARCH_COMPLETE, function elasticAddress(data) {
            getAddressData(data);
        });
    }
    function getAddressData(addressFieldData) {
        addressFieldId = addressFieldData.addressFieldId;
        dpId = addressFieldData.dpid;
        if ($currentAjaxRequest) {
            $currentAjaxRequest.abort();
            $currentAjaxRequest = null;
        }
        if (dpIdCache.hasOwnProperty(dpId)) {
            setAddressDataFields(dpIdCache[dpId]);
        } else {
            var $navButton = $(".journeyNavButton");
            if (meerkat.site.vertical != "home") {
                meerkat.modules.loadingAnimation.showInside($navButton);
                meerkat.messaging.publish(meerkat.modules.events.WEBAPP_LOCK, {
                    source: "address_lookup"
                });
            }
            if (typeof dpId !== "undefined" && dpId !== "") {
                $currentAjaxRequest = meerkat.modules.comms.post({
                    url: "address/get.json",
                    errorLevel: "mandatory",
                    data: {
                        dpId: dpId
                    },
                    onSuccess: function ajaxGetTypeaheadAddressDataSuccess(data) {
                        dpIdCache[dpId] = data;
                        setAddressDataFields(data);
                        if (typeof data.dpId === "undefined" || data.dpId === "") {
                            meerkat.modules.errorHandling.error({
                                page: "elastic_search.js",
                                errorLevel: "slient",
                                description: "Could not find address with dpId of " + dpId,
                                data: data
                            });
                        } else {
                            meerkat.messaging.publish(moduleEvents.HIDDEN_FIELDS_POPULATED, {
                                addressData: data
                            });
                        }
                    },
                    onError: function ajaxGetTypeaheadAddressDataError(xhr, status) {
                        if (status !== "abort") {
                            meerkat.modules.errorHandling.error({
                                page: "elastic_search.js",
                                errorLevel: "warning",
                                description: "Something went wrong and the elastic address lookup failed for " + dpId,
                                message: "Sorry, there was a problem loading your address details, please try again.",
                                data: xhr
                            });
                            if (meerkat.site.vertical == "home") {
                                meerkat.modules.journeyEngine.gotoPath("start");
                            }
                            $("#" + addressFieldId + "_nonStd").trigger("click").prop("checked", true);
                        }
                    },
                    onComplete: function ajaxGetTypeaheadAddressDataComplete() {
                        meerkat.messaging.publish(meerkat.modules.events.WEBAPP_UNLOCK, {
                            source: "address_lookup"
                        });
                        meerkat.modules.loadingAnimation.hide($navButton);
                    }
                });
            }
        }
    }
    function setAddressDataFields(data) {
        for (var addressItem in data) {
            var $hiddenAddressElement = $("#" + addressFieldId + "_" + addressItem);
            $hiddenAddressElement.val(data[addressItem]).trigger("change");
        }
    }
    meerkat.modules.register("address_lookup", {
        init: initAddressLookup,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var meerkatEvents = meerkat.modules.events;
    var log = window.meerkat.logging.info;
    var events = {
        affix: {
            AFFIXED: "CORE_AFFIX_AFFIXED",
            UNAFFIXED: "CORE_AFFIX_UNAFFIXED"
        }
    }, moduleEvents = events.affix;
    function topDockBasedOnOffset($elems) {
        $elems.each(function(index, val) {
            $item = $(val);
            $item.affix({
                offset: {
                    top: function() {
                        var offsetTop = $item.offset().top;
                        var attr = $item.attr("data-affix-after");
                        if (attr && $(attr).length) {
                            offsetTop = $(attr).offset().top;
                            if ($item.is(":visible")) {
                                this.top = offsetTop;
                            }
                        } else {
                            this.top = offsetTop;
                        }
                        return offsetTop;
                    }
                }
            });
            $item.on("affixed.bs.affix", function(event) {
                meerkat.messaging.publish(moduleEvents.AFFIXED, $item);
            });
            $item.on("affixed-top.bs.affix", function(event) {
                meerkat.messaging.publish(moduleEvents.UNAFFIXED, $item);
            });
        });
    }
    function init() {
        meerkat.messaging.subscribe(meerkatEvents.journeyProgressBar.INIT, function affixNavbar(step) {
            if (meerkat.modules.deviceMediaState.get() === "xs") {
                var messagingId = meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function affixXsBreakpointLeave() {
                    meerkat.messaging.unsubscribe(messagingId);
                    topDockBasedOnOffset($(".navbar-affix"));
                });
            } else {
                topDockBasedOnOffset($(".navbar-affix"));
            }
        });
    }
    meerkat.modules.register("affix", {
        init: init,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        autocomplete: {
            CANT_FIND_ADDRESS: "EVENT_CANT_FIND_ADDRESS",
            ELASTIC_SEARCH_COMPLETE: "ELASTIC_SEARCH_COMPLETE",
            INIT: "INIT"
        }
    };
    var moduleEvents = events.autocomplete;
    function initAutoComplete() {
        $(document).ready(function() {
            setTypeahead();
        });
    }
    function _isElasticSearch(addressFieldId) {
        return $("#" + addressFieldId + "_elasticSearch").val() === "Y";
    }
    function setTypeahead() {
        var $typeAheads = $("input.typeahead"), params = null;
        $typeAheads.each(function eachTypeaheadElement() {
            var $component = $(this), fieldId = $component.attr("id"), fieldIdEnd = fieldId.match(/(_)[a-zA-Z]{1,}$/g), addressFieldId = fieldId.replace(fieldIdEnd, ""), elasticSearch = _isElasticSearch(addressFieldId), url;
            $component.data("addressfieldid", addressFieldId);
            if (elasticSearch) {
                url = "address/search.json";
                params = {
                    name: $component.attr("name"),
                    remote: {
                        beforeSend: function(jqXhr, settings) {
                            autocompleteBeforeSend($component);
                            jqXhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                            settings.type = "POST";
                            settings.hasContent = true;
                            settings.url = url;
                            var $addressField = $("#" + addressFieldId + "_autofilllessSearch");
                            var query = $addressField.val();
                            settings.data = $.param({
                                query: decodeURI(query)
                            });
                        },
                        filter: function(parsedResponse) {
                            autocompleteComplete($component);
                            return parsedResponse;
                        },
                        url: url,
                        error: function(xhr, status) {
                            meerkat.modules.errorHandling.error({
                                page: "autocomplete.js",
                                errorLevel: "warning",
                                title: "Address lookup failed",
                                message: "<p>Sorry, we are having troubles connecting to our address servers.</p><p>Please manually enter your address.</p>",
                                description: "Could not connect to the elastic search.json",
                                data: xhr
                            });
                            $("#" + addressFieldId + "_nonStd").trigger("click").prop("checked", true);
                            autocompleteComplete($component);
                        }
                    },
                    limit: 150
                };
            } else if ($component.attr("data-varname") == "countrySelectionList") {
                params = meerkat.modules.travelCountrySelector.getCountrySelectorParams($component);
            } else {
                url = $component.attr("data-source-url");
                params = {
                    name: $component.attr("name"),
                    remote: {
                        beforeSend: function() {
                            autocompleteBeforeSend($component);
                        },
                        filter: function(parsedResponse) {
                            autocompleteComplete($component);
                            return parsedResponse;
                        },
                        url: $component.attr("data-source-url") + "%QUERY"
                    },
                    limit: 150
                };
            }
            params = checkIfAddressSearch($component, params);
            $component.typeahead(params);
            if ($component.hasClass("input-lg")) {
                $component.prev(".tt-hint").addClass("hint-lg");
            }
            if ($component.hasClass("input-sm")) {
                $component.prev(".tt-hint").addClass("hint-sm");
            }
            if ($component.hasClass("blur-on-select")) {
                $component.bind("typeahead:selected", function blurOnSelect(event, datum, name) {
                    if (datum.hasOwnProperty("value") && datum.value === "Type your address...") {
                        return;
                    }
                    if (event && event.target && event.target.blur) {
                        event.target.blur();
                    }
                });
            }
        });
    }
    function autocompleteBeforeSend($component) {
        if ($component.hasClass("show-loading")) {
            meerkat.modules.loadingAnimation.showInside($component.parent(".twitter-typeahead"));
        }
    }
    function autocompleteComplete($component) {
        if ($component.hasClass("show-loading")) {
            meerkat.modules.loadingAnimation.hide($component.parent(".twitter-typeahead"));
        }
    }
    function checkIfAddressSearch($element, typeaheadParams) {
        if ($element && $element.hasClass("typeahead-address")) {
            var addressFieldId = $element.data("addressfieldid"), elasticSearch = _isElasticSearch(addressFieldId);
            typeaheadParams.remote.url = $element.attr("id");
            typeaheadParams.remote.replace = addressSearch;
            typeaheadParams.valueKey = "value";
            typeaheadParams.template = _.template("<p>{{= highlight }}</p>");
            if ($element.hasClass("typeahead-autofilllessSearch") || $element.hasClass("typeahead-streetSearch")) {
                typeaheadParams.remote.filter = function(parsedResponse) {
                    autocompleteComplete($element);
                    if (elasticSearch) {
                        $.each(parsedResponse, function(index, addressObj) {
                            if (addressObj.hasOwnProperty("text") && addressObj.hasOwnProperty("payload")) {
                                addressObj.value = addressObj.text;
                                addressObj.highlight = addressObj.text;
                                addressObj.dpId = addressObj.payload;
                            }
                        });
                    }
                    parsedResponse.push({
                        value: "Type your address...",
                        highlight: "Can't find your address? <u>Click here.</u>"
                    });
                    return parsedResponse;
                };
                $element.bind("typeahead:selected", function catchEmptyValue(event, datum, name) {
                    if (datum.hasOwnProperty("value") && datum.value === "Type your address...") {
                        var id = "";
                        if (!elasticSearch) {
                            if (event.target && event.target.id) {
                                id = event.target.id.replace("_streetSearch", "");
                            }
                        }
                        meerkat.messaging.publish(moduleEvents.CANT_FIND_ADDRESS, {
                            fieldgroup: id
                        });
                    } else if (elasticSearch) {
                        meerkat.messaging.publish(moduleEvents.ELASTIC_SEARCH_COMPLETE, {
                            dpid: datum.dpId,
                            addressFieldId: addressFieldId
                        });
                        $element.valid();
                    }
                });
            }
        }
        return typeaheadParams;
    }
    function addressSearch(url, uriEncodedQuery) {
        var $element = $("#" + url);
        url = "";
        $element.trigger("getSearchURL");
        if ($element.data("source-url")) {
            url = $element.data("source-url");
        }
        return url;
    }
    meerkat.modules.register("autocomplete", {
        init: initAutoComplete,
        events: events,
        autocompleteBeforeSend: autocompleteBeforeSend,
        autocompleteComplete: autocompleteComplete
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        callMeBack: {
            REQUESTED: "CALL_ME_BACK_REQUESTED",
            VALID: "CALL_ME_BACK_VALID",
            INVALID: "CALL_ME_BACK_INVALID"
        }
    }, moduleEvents = events.callMeBack;
    var $name = null;
    var nameSelector = ".callmeback_name";
    var $phone = null;
    var phoneSelector = ".callmeback_phone";
    var $time = null;
    var timeSelector = ".callmeback_timeOfDay";
    var $optin = null;
    var optinSelector = ".callmeback_optin";
    var $submitButton = null;
    var $currentForm = null;
    var $forms = null;
    var callbackAjaxObject = null;
    var isRequested = false;
    var formName = null;
    var formMobileNumber = null;
    var formOtherNumber = null;
    function init() {
        jQuery(document).ready(function($) {
            updateSelectedElements();
        });
        msg.subscribe(meerkat.modules.events.contactDetails.name.FIELD_CHANGED, function(fieldDetails) {
            if (typeof fieldDetails.$otherField !== "undefined") {
                if (fieldDetails.fieldIndex === 1) {
                    formName = $.trim(fieldDetails.$field.val() + " " + fieldDetails.$otherField.val());
                } else {
                    formName = $.trim(fieldDetails.$otherField.val() + " " + fieldDetails.$field.val());
                }
            } else {
                formName = fieldDetails.$field.val();
            }
        });
        msg.subscribe(meerkat.modules.events.contactDetails.mobile.FIELD_CHANGED, function(fieldDetails) {
            formMobileNumber = fieldDetails.$field.val();
        });
        msg.subscribe(meerkat.modules.events.contactDetails.otherPhone.FIELD_CHANGED, function(fieldDetails) {
            formOtherNumber = fieldDetails.$field.val();
        });
        msg.subscribe(moduleEvents.VALID, enableSubmitButton);
        msg.subscribe(moduleEvents.INVALID, disableSubmitButton);
    }
    function updateSelectedElements() {
        $name = $(nameSelector);
        $phone = $(phoneSelector);
        $time = $(timeSelector);
        $optin = $(optinSelector);
        $name.off("keyup").on("keyup", checkFormValid);
        $phone.off("keyup").on("keyup", checkFormValid);
        $phone.off("focusout").on("focusout", function() {
            $(this).siblings("[type=hidden]").val($(this).val().replace(/[^0-9]+/g, ""));
        });
        $time.off("change").on("change", checkFormValid);
        $submitButton = $(".call-me-back-submit");
        $forms = $(".call-me-back-form");
        $submitButton.off("click").on("click", function() {
            submitCallMeBack($(this).parents("form").first());
        });
        setValidation();
    }
    function prefillForm($form) {
        if (formName !== null) {
            $form.find(nameSelector).val(formName);
        }
        if (formMobileNumber !== null) {
            $form.find(phoneSelector).val(formMobileNumber);
        } else if (formOtherNumber !== null) {
            $form.find(phoneSelector).val(formOtherNumber);
        }
    }
    function checkFormValid() {
        setCurrentForm($(this).parents("form").first());
        var notEmptyName = $currentForm.find($name).val() !== "";
        var notEmptyPhone = $currentForm.find($phone).val() !== "";
        var notEmptyTime = $currentForm.find($time).val() !== "";
        if (notEmptyName && notEmptyPhone && notEmptyTime && $currentForm.valid()) {
            msg.publish(moduleEvents.VALID);
        } else {
            msg.publish(moduleEvents.INVALID);
        }
    }
    function submitCallMeBack($form) {
        setCurrentForm($form);
        if (callbackAjaxObject && callbackAjaxObject.state() === "pending") return;
        if (!$currentForm.valid()) return;
        if (isRequested) return;
        $currentForm.find(optinSelector).val("Y");
        var dat = [];
        var quoteForm = meerkat.modules.form.getData($currentForm);
        var jeForm = meerkat.modules.journeyEngine.getFormData();
        dat = quoteForm.concat(jeForm);
        dat.push({
            name: "quoteType",
            value: meerkat.site.vertical
        });
        msg.publish(moduleEvents.INVALID);
        meerkat.modules.loadingAnimation.showAfter($submitButton);
        callbackAjaxObject = meerkat.modules.comms.post({
            url: "ajax/write/request_callback.jsp",
            data: dat,
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            onSuccess: function submitCallMeBackSuccess(result) {
                isRequested = true;
                meerkat.messaging.publish(moduleEvents.REQUESTED, {
                    phone: $currentForm.find($phone).val(),
                    name: $currentForm.find($name).val()
                });
                hideForms();
                showThanks();
                var $mainForm = $("#mainform");
                $currentForm.find(":input").each(function() {
                    $this = $(this);
                    meerkat.modules.form.appendHiddenField($mainForm, $this.attr("name"), $this.val());
                });
                meerkat.modules.form.appendHiddenField($mainForm, meerkat.site.vertical + "_callmeback_time", result.time);
                meerkat.modules.form.appendHiddenField($mainForm, meerkat.site.vertical + "_callmeback_date", result.date);
                if ($("#requested_callmeback_time").length === 0) {
                    meerkat.modules.form.appendHiddenField($mainForm, "requested_callmeback_time", result.time);
                }
                if ($("#requested_callmeback_date").length === 0) {
                    meerkat.modules.form.appendHiddenField($mainForm, "requested_callmeback_date", result.date);
                }
            },
            onError: function submitCallMeBackError() {
                hideForms();
                showErrors();
                msg.publish(moduleEvents.VALID);
            },
            onComplete: function() {
                meerkat.modules.loadingAnimation.hide($submitButton);
            }
        });
    }
    function hasCallbackBeenRequested() {
        return isRequested;
    }
    function hideForms() {
        $forms.each(function() {
            $(this).hide();
        });
    }
    function showThanks() {
        $forms.each(function() {
            $(this).after(getThankYouMessage());
        });
    }
    function showErrors() {
        $forms.each(function() {
            $(this).after('<form class="callmeback-feedback"><h5>Call back service offline</h5><p>Sadly our call back service is offline - Please try again later.</p></form>');
        });
    }
    function getThankYouMessage() {
        return '<form class="callmeback-feedback"><h5>Someone will call you</h5><p>Thank you, a member of our staff will call you in the ' + getTimeInLetters($currentForm.find($time).val()) + "</p></form>";
    }
    function getTimeInLetters(letterCode) {
        switch (letterCode) {
          case "M":
            time = "morning";
            break;

          case "A":
            time = "afternoon";
            break;

          default:
            time = "evening (excludes WA)";
            break;
        }
        return time;
    }
    function setCurrentForm($form) {
        $currentForm = $form;
    }
    function setValidation() {
        $forms.each(function() {
            setupDefaultValidationOnForm($(this));
        });
        if ($name.length > 0) {
            $name.add("rules", {
                required: true,
                messages: {
                    required: "Please enter your name"
                }
            });
        }
        if ($phone.length > 0) {
            $phone.add("rules", {
                validateTelNo: true,
                messages: {
                    validateTelNo: "Please enter the contact number in the format (area code)(local number) for landline or 04xxxxxxxx for mobile"
                }
            });
        }
        if ($time.length > 0) {
            $time.add("rules", {
                required: true,
                messages: {
                    required: "Please select when you want us to call you back"
                }
            });
        }
    }
    function enableSubmitButton() {
        if ($currentForm !== null) {
            $currentForm.find($submitButton).removeClass("disabled");
        }
    }
    function disableSubmitButton() {
        if ($currentForm !== null) {
            $currentForm.find($submitButton).addClass("disabled");
        }
    }
    meerkat.modules.register("callMeBack", {
        init: init,
        events: events,
        hasCallbackBeenRequested: hasCallbackBeenRequested,
        prefillForm: prefillForm,
        updateSelectedElements: updateSelectedElements,
        submitCallMeBack: submitCallMeBack
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, msg = meerkat.messaging, log = meerkat.logging.info;
    var events = {
        callMeBackTab: {}
    }, moduleEvents = events.callMeBackTab;
    $currentCallMeBackModal = null;
    isRequested = false;
    function init() {
        jQuery(document).ready(function($) {
            $modalContent = $("#callMeBackModalContent");
            $openButton = $("#callMeBackTabButton");
            $openButton.on("click", open);
        });
        msg.subscribe(meerkatEvents.callMeBack.VALID, enableSubmitButton);
        msg.subscribe(meerkatEvents.callMeBack.INVALID, disableSubmitButton);
        msg.subscribe(meerkatEvents.callMeBack.REQUESTED, onCallMeBackRequested);
    }
    function open() {
        var callMeBackDialogId = meerkat.modules.dialogs.show({
            title: "Get a call back",
            htmlContent: $modalContent.html(),
            buttons: [ {
                label: isRequested ? "Close" : "Cancel",
                className: "btn-cancel modal-call-me-back-close",
                closeWindow: true
            }, {
                label: "Call me",
                className: "btn-cta disabled modal-call-me-back-submit" + (isRequested ? " displayNone" : ""),
                action: submitCallMeBack
            } ],
            onClose: function() {
                $openButton.fadeIn();
            }
        });
        $currentCallMeBackModal = $("#" + callMeBackDialogId);
        meerkat.modules.callMeBack.updateSelectedElements();
        meerkat.modules.callMeBack.prefillForm($currentCallMeBackModal.find("form"));
        $currentCallMeBackModal.find("h5").hide();
        $currentCallMeBackModal.find(".call-me-back-submit").hide();
        $openButton.fadeOut();
        var $name = $currentCallMeBackModal.find(".callmeback_name");
        var $phone = $currentCallMeBackModal.find(".callmeback_phone");
        if ($name.val() === "") {
            $name.focus();
        } else if ($phone.val() === "") {
            $phone.focus();
        } else {
            $currentCallMeBackModal.find(".callmeback_timeOfDay").focus();
        }
    }
    function submitCallMeBack() {
        meerkat.modules.callMeBack.submitCallMeBack($currentCallMeBackModal.find("form"));
    }
    function enableSubmitButton() {
        if ($currentCallMeBackModal !== null) {
            $currentCallMeBackModal.find(".modal-call-me-back-submit").removeClass("disabled");
        }
    }
    function disableSubmitButton() {
        if ($currentCallMeBackModal !== null) {
            $currentCallMeBackModal.find(".modal-call-me-back-submit").addClass("disabled");
        }
    }
    function onCallMeBackRequested() {
        isRequested = true;
        if ($currentCallMeBackModal !== null) {
            $currentCallMeBackModal.find(".modal-call-me-back-submit").hide();
            $currentCallMeBackModal.find(".modal-call-me-back-close").html("Close");
        }
    }
    meerkat.modules.register("callMeBackTab", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    function init() {
        $(document).ready(support);
    }
    function support() {
        $forms = $("html.lt-ie9 form, html.lt-ie9 #dynamic_dom");
        if ($forms.length) {
            $forms.off("change.checkedForIE").on("change.checkedForIE", ".checkbox input, .compareCheckbox input", function applyCheckboxClicks() {
                var $this = $(this);
                if ($this.is(":checked")) {
                    $this.addClass("checked");
                } else {
                    $this.removeClass("checked");
                }
            });
            $forms.find(".checkbox input").change();
        }
    }
    meerkat.modules.register("checkboxIE8", {
        init: init,
        support: support
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, expiredNoticeShown = false, loadQuoteModalId = false, pending_results_handler = false, settings = {
        dateField: null,
        getResults: null,
        updateData: null,
        renderCompletedEvent: null
    };
    var moduleEvents = {
        commencementDate: {
            COMMENCEMENT_DATE_UPDATED: "COMMENCEMENT_DATE_UPDATED",
            RESULTS_RENDER_COMPLETED: "RESULTS_RENDER_COMPLETED"
        }
    };
    function initCommencementDate(settingsIn) {
        settings = _.pick(settingsIn, "dateField", "getResults", "updateData");
        $(document).ready(function() {
            if (!_.isEmpty(settings.dateField) && $(settings.dateField) && _.isFunction(settings.getResults)) {
                meerkat.messaging.subscribe(moduleEvents.commencementDate.COMMENCEMENT_DATE_UPDATED, commencementDateUpdated);
                meerkat.messaging.subscribe(meerkatEvents.emailLoadQuote.TRIGGERS_MODAL, triggerLoadQuoteModal);
                $(settings.dateField).attr("data-attach", "true");
            } else {}
        });
    }
    function commencementDateUpdated(updatedDate) {
        alert(updatedDate);
        $(settings.dateField).datepicker("update", updatedDate);
        _.defer(function() {
            showSimpleModal(updatedDate);
        });
    }
    function showSimpleModal(updatedDate) {
        var $e = $("#expired-commencement-date-template");
        if ($e.length > 0) {
            templateCallback = _.template($e.html());
        }
        var obj = {
            updatedDate: updatedDate
        };
        var htmlContent = templateCallback(obj);
        var modalOptions = {
            htmlContent: htmlContent,
            hashId: "call",
            className: "expired-commencement-date-modal",
            closeOnHashChange: true,
            openOnHashChange: false,
            onOpen: function(modalId) {}
        };
        _.defer(function() {
            callbackModalId = meerkat.modules.dialogs.show(modalOptions);
        });
    }
    function triggerLoadQuoteModal(data) {
        if (_.isFunction(settings.updateData)) {
            settings.updateData(data);
        }
        _.defer(_.bind(showLoadQuoteModal, this, data));
    }
    function showLoadQuoteModal(data) {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, _.bind(deviceStateChanged, this, true));
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, _.bind(deviceStateChanged, this, false));
        var $e = $("#edit-details-template");
        if ($e.length > 0) {
            templateCallback = _.template($e.html());
        }
        var originalDate = $(settings.dateField).val();
        var htmlContent = templateCallback(data);
        var modalOptions = {
            htmlContent: '<div class="edit-details-wrapper expired-quote"></div>',
            hashId: "expiredCommencementDate",
            className: "edit-details-modal",
            closeOnHashChange: false,
            openOnHashChange: false,
            onOpen: function(modalId) {
                loadQuoteModalId = modalId;
                expiredNoticeShown = true;
                var $editDetails = $(".edit-details-wrapper", $("#" + modalId));
                $editDetails.html(htmlContent);
                meerkat.modules.contentPopulation.render("#" + modalId + " .edit-details-wrapper");
                $(".accordion-collapse").on("show.bs.collapse", function() {
                    $(this).prev(".accordion-heading").addClass("active-panel");
                }).on("hide.bs.collapse", function() {
                    $(this).prev(".accordion-heading").removeClass("active-panel");
                });
                $form = $("#modal-commencement-date-form");
                setupDefaultValidationOnForm($form);
                $(settings.dateField + "_mobile").attr("data-msg-required", "Commencement date required");
                $(settings.dateField + "_mobile option:first").remove();
                $("#modal-commencement-date-get-quotes").on("click", function(event) {
                    event.preventDefault();
                    var $btn = $(this);
                    if ($form.valid()) {
                        $(settings.dateField).datepicker("update", $(settings.dateField + "_mobile").val());
                        meerkat.modules.dialogs.close(loadQuoteModalId);
                        if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results" && originalDate != $(settings.dateField).val()) {
                            if (!_.isUndefined(Results.getAjaxRequest()) && Results.getAjaxRequest() !== false && Results.getAjaxRequest().readyState !== 4 && Results.getAjaxRequest().status !== 200) {
                                $btn.addClass("disabled");
                                pending_results_handler = meerkat.messaging.subscribe(meerkatEvents.commencementDate.RESULTS_RENDER_COMPLETED, getFreshResults);
                            } else {
                                settings.getResults();
                            }
                        }
                    }
                });
                $editDetails.find("a.btn-edit").on("click", function editDetails(event) {
                    event.preventDefault();
                    if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results" && !_.isUndefined(Results.getAjaxRequest()) && Results.getAjaxRequest() !== false && Results.getAjaxRequest().readyState !== 4 && Results.getAjaxRequest().status !== 200) {
                        Results.getAjaxRequest().abort();
                    }
                    meerkat.modules.dialogs.close(loadQuoteModalId);
                    meerkat.modules.journeyEngine.gotoPath($(this).attr("href").substring(1));
                });
                if (meerkat.modules.deviceMediaState.get() === "xs") {
                    $editDetails.show();
                } else {
                    $editDetails.find(".accordion-collapse").addClass("in").end().show();
                }
            },
            onClose: function(modalId) {
                $(settings.dateField).datepicker("update", $(settings.dateField + "_mobile").val());
                loadQuoteModalId = false;
            }
        };
        meerkat.modules.dialogs.show(modalOptions);
    }
    function getFreshResults() {
        meerkat.messaging.unsubscribe(meerkatEvents.commencementDate.RESULTS_RENDER_COMPLETED, pending_results_handler);
        _.defer(settings.getResults);
    }
    function deviceStateChanged(enterXS) {
        enterXS = enterXS || false;
        if (loadQuoteModalId !== false && meerkat.modules.dialogs.isDialogOpen(loadQuoteModalId)) {
            var $modal = $(".edit-details-wrapper", $("#" + loadQuoteModalId));
            if (enterXS === true) {
                $modal.find(".accordion-collapse").not(".expired-panel").removeClass("in");
                $modal.find(".accordion-heading.active-panel").next(".accordion-collapse").addClass("in");
            } else {
                $modal.find(".accordion-collapse").each(function() {
                    $that = $(this);
                    $that.addClass("in").css({
                        height: "auto"
                    });
                });
            }
        }
    }
    function getExpiredNoticeShown() {
        return expiredNoticeShown;
    }
    meerkat.modules.register("commencementDate", {
        initCommencementDate: initCommencementDate,
        events: moduleEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var cache = [];
    var AJAX_REQUEST_ABORTED = "abort";
    var CHECK_AUTHENTICATED_LABEL = "checkAuthenticated";
    var requestPool = [];
    var defaultSettings = {
        url: "not-set",
        data: null,
        dataType: false,
        numberOfAttempts: 1,
        attemptCallback: null,
        timeout: 6e4,
        cache: false,
        errorLevel: null,
        useDefaultErrorHandling: true,
        returnAjaxObject: true,
        onSuccess: function(result, textStatus, jqXHR) {},
        onError: function(jqXHR) {},
        onComplete: function(jqXHR, textStatus) {},
        onErrorDefaultHandling: function(jqXHR, textStatus, errorThrown, settings, data) {
            if (textStatus !== AJAX_REQUEST_ABORTED) {
                var statusMap = {
                    "400": "There was a problem with the last request to the server [400]. Please try again.",
                    "401": "There was a problem accessing the data for the last request [401].",
                    "403": "There was a problem accessing the data for the last request [403].",
                    "404": "The requested page could not be found [404]. Please try again.",
                    "412": "Supplied parameters failed to meet preconditions [412].",
                    "500": "There was a problem with your last request to the server [500]. Please try again.",
                    "503": "There was a problem with your last request to the server [503]. Please try again."
                };
                var message = "";
                var errorObject = {
                    errorLevel: settings.errorLevel,
                    message: message,
                    page: "comms.js",
                    description: "Error loading url: " + settings.url + " : " + textStatus + " " + errorThrown,
                    data: data
                };
                if (jqXHR.status && jqXHR.status != 200) {
                    message = statusMap[jqXHR.status];
                } else if (textStatus == "parsererror") {
                    message += "There was a problem handling the response from the server [parsererror]. Please try again.";
                } else if (textStatus == "timeout") {
                    message += "There was a problem connecting to the server. Please check your internet connection and try again. [Request Time out].";
                } else if (textStatus == "abort") {
                    message += "There was a problem handling the response from the server [abort]. Please try again.";
                }
                if ((!message || message === "") && errorThrown == CHECK_AUTHENTICATED_LABEL) {
                    message = "Your Simples login session has been lost. Please open Simples in a separate tab, login, then you can continue with this quote.";
                    if (!meerkat.modules.dialogs.isDialogOpen(CHECK_AUTHENTICATED_LABEL)) {
                        meerkat.modules.journeyEngine.gotoPath("previous");
                    }
                    $.extend(errorObject, {
                        errorLevel: "warning",
                        id: CHECK_AUTHENTICATED_LABEL
                    });
                } else if (!message || message === "") {
                    message = "Unknown Error";
                }
                $.extend(errorObject, {
                    message: message
                });
                if (errorThrown != CHECK_AUTHENTICATED_LABEL || errorThrown == CHECK_AUTHENTICATED_LABEL && !meerkat.modules.dialogs.isDialogOpen(CHECK_AUTHENTICATED_LABEL)) {
                    meerkat.modules.errorHandling.error(errorObject);
                }
            }
        }
    };
    function post(instanceSettings) {
        return getAndPost("POST", instanceSettings);
    }
    function get(instanceSettings) {
        return getAndPost("GET", instanceSettings);
    }
    function getAndPost(requestMethod, instanceSettings) {
        var settings = $.extend({}, defaultSettings, instanceSettings);
        if (typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null) {
            console.error("Message to dev: please provide an errorLevel to the comms.post() or comms.get() function.");
        }
        var usedCache = checkCache(settings);
        if (usedCache === true) {
            var cachedResult = findInCache(settings);
            return $.Deferred(function(dfd) {
                if (settings.onSuccess != null) settings.onSuccess(cachedResult.result);
                if (settings.onComplete != null) settings.onComplete();
                return dfd.resolveWith(this, [ cachedResult.result ]).promise();
            });
        }
        settings.attemptsCounter = 1;
        return ajax(settings, {
            url: settings.url,
            data: settings.data,
            dataType: settings.dataType,
            type: requestMethod,
            timeout: settings.timeout
        });
    }
    function ajax(settings, ajaxProperties) {
        var tranId = meerkat.modules.transactionId.get();
        try {
            if (ajaxProperties.data == null) {
                ajaxProperties.data = {};
            }
            if (_.isString(ajaxProperties.data)) {
                ajaxProperties.data += "&transactionId=" + tranId;
                if (meerkat.site.isCallCentreUser) {
                    ajaxProperties.data += "&" + CHECK_AUTHENTICATED_LABEL + "=true";
                }
            } else if (_.isArray(ajaxProperties.data)) {
                ajaxProperties.data = $.merge([], settings.data);
                if (_.indexOf(ajaxProperties.data, "transactionId") === -1) {
                    ajaxProperties.data.push({
                        name: "transactionId",
                        value: tranId
                    });
                }
                if (meerkat.site.isCallCentreUser) {
                    ajaxProperties.data.push({
                        name: CHECK_AUTHENTICATED_LABEL,
                        value: true
                    });
                }
            } else if (_.isObject(ajaxProperties.data)) {
                ajaxProperties.data = $.extend(true, {}, settings.data);
                if (ajaxProperties.data.hasOwnProperty("transactionId") === false) {
                    ajaxProperties.data.transactionId = tranId;
                }
                if (meerkat.site.isCallCentreUser) {
                    ajaxProperties.data[CHECK_AUTHENTICATED_LABEL] = true;
                }
            }
        } catch (e) {}
        var jqXHR = $.ajax(ajaxProperties);
        var deferred = jqXHR.then(function onAjaxSuccess(result, textStatus, jqXHR) {
            var data = typeof settings.data !== "undefined" ? settings.data : null;
            if (containsServerGeneratedError(result) === true) {
                handleError(jqXHR, "Server generated error", getServerGeneratedError(result), settings, data, ajaxProperties);
            } else {
                if (settings.cache === true) addToCache(settings.url, data, result);
                if (settings.onSuccess != null) settings.onSuccess(result);
                if (settings.onComplete != null) settings.onComplete(jqXHR, textStatus);
                if (typeof result.timeout != "undefined" && result.timeout) meerkat.modules.session.update(result.timeout);
            }
        }, function onAjaxError(jqXHR, textStatus, errorThrown) {
            var data = typeof settings.data != "undefined" ? settings.data : null;
            handleError(jqXHR, textStatus, errorThrown, settings, data, ajaxProperties);
            if (settings.onComplete != null) settings.onComplete(jqXHR, textStatus);
        });
        if (settings.hasOwnProperty("returnAjaxObject") && settings.returnAjaxObject === true) {
            return jqXHR;
        } else {
            return deferred;
        }
    }
    function addToCache(url, postData, result) {
        cache.push({
            url: url,
            postData: postData,
            result: result
        });
    }
    function findInCache(settings) {
        for (var i = 0; i < cache.length; i++) {
            var cacheItem = cache[i];
            if (settings.url === cacheItem.url) {
                if (settings.data === null && cacheItem.postData === null) {
                    return cacheItem;
                } else if (settings.data !== null && cacheItem.postData !== null) {
                    if (_.isEqual(settings.data, cacheItem.postData)) {
                        return cacheItem;
                    }
                }
            }
        }
        return null;
    }
    function checkCache(settings) {
        if (settings.cache === true) {
            var cachedResult = findInCache(settings);
            if (cachedResult !== null) {
                meerkat.logging.info("Retrieved from cache", cachedResult);
                return true;
            }
        }
        return false;
    }
    function containsServerGeneratedError(data) {
        if (typeof data.error !== "undefined" || typeof data.errors !== "undefined" && data.errors.length > 0) {
            return true;
        }
        return false;
    }
    function getServerGeneratedError(data) {
        var target;
        if (!_.isUndefined(data.errors)) {
            target = data.errors;
        } else if (!_.isUndefined(data.error)) {
            target = data.error;
        } else return "";
        if (_.isArray(target) && target.length > 0) {
            if (target[0].hasOwnProperty("message")) {
                target = target[0].message;
            } else target = target[0];
        }
        if (_.isString(target)) {
            return target;
        } else {
            return "";
        }
    }
    function handleError(jqXHR, textStatus, errorThrown, settings, data, ajaxProperties) {
        if (textStatus !== AJAX_REQUEST_ABORTED) {
            if (settings.numberOfAttempts > settings.attemptsCounter++) {
                ajax(settings, ajaxProperties);
            } else {
                if (typeof settings === "undefined") {
                    settings = {};
                }
                if (settings.useDefaultErrorHandling) {
                    settings.onErrorDefaultHandling(jqXHR, textStatus, errorThrown, settings, data);
                }
                if (settings.onError != null) {
                    settings.onError(jqXHR, textStatus, errorThrown, settings, data);
                }
            }
        }
    }
    function getCheckAuthenticatedLabel() {
        return CHECK_AUTHENTICATED_LABEL;
    }
    meerkat.modules.register("comms", {
        post: post,
        get: get,
        getCheckAuthenticatedLabel: getCheckAuthenticatedLabel
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        compare: {
            RENDER_BASKET: "RENDER_BASKET",
            BEFORE_ADD_COMPARE_PRODUCT: "BEFORE_ADD_COMPARE_PRODUCT",
            ADD_PRODUCT: "COMPARE_ADD_PRODUCT",
            REMOVE_PRODUCT: "COMPARE_REMOVE_PRODUCT",
            ENTER_COMPARE: "ENTER_COMPARE",
            AFTER_ENTER_COMPARE_MODE: "AFTER_ENTER_COMPARE_MODE",
            EXIT_COMPARE: "EXIT_COMPARE_MODE"
        }
    }, moduleEvents = events.compare;
    var comparedProducts = [], comparisonOpen = false, resultsFiltered = false, previousMode, resultsContainer, productIdPath, defaults = {
        minProducts: 2,
        maxProducts: 3,
        autoCompareAtMax: true,
        elements: {
            basketLocationFeatures: $(".resultInsert.controlContainer"),
            basketLocationPrice: $("#navbar-compare > .compare-basket"),
            enterCompareMode: $(".enter-compare-mode"),
            clearCompare: $(".clear-compare"),
            exitCompareButton: $(".back-to-price-mode"),
            compareBar: $("#navbar-compare"),
            priceModeToggle: $(".filter-pricemode"),
            featuresModeToggle: $(".filter-featuresmode")
        },
        templates: {
            compareBasketFeatures: $("#compare-basket-features-template"),
            compareBasketPrice: $("#compare-basket-price-template")
        },
        callbacks: {
            switchMode: function(mode) {
                switch (mode) {
                  case "features":
                    settings.elements.featuresModeToggle.trigger("click");
                    break;

                  case "price":
                    settings.elements.priceModeToggle.trigger("click");
                    $(".featuresHeaders .expandable.expanded, .featuresList .expandable.expanded").removeClass("expanded").addClass("collapsed");
                    break;

                  default:
                    log("[compare:switchMode] No mode specified");
                    break;
                }
            }
        }
    }, settings = {};
    function initCompare(options) {
        options = typeof options === "object" && options !== null ? options : {};
        settings = $.extend({}, defaults, options);
        productIdPath = Results.settings.paths.productId;
        jQuery(document).ready(function($) {
            applyEventListeners();
            eventSubscriptions();
        });
    }
    function applyEventListeners() {
        resultsContainer = $(Results.settings.elements.resultsContainer);
        resultsContainer.on("change", ".compare-tick", toggleProductEvent);
        settings.elements.basketLocationPrice.on("click", ".remove-compare", toggleProductEvent);
        resultsContainer.on("click", ".clear-compare", resetComparison);
        $(document).on("click", ".enter-compare-mode", enterCompareMode);
        resultsContainer.on("resultsReset resultsFetchStart", resetComparison);
        settings.elements.exitCompareButton.on("click", resetComparison);
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.ADD_PRODUCT, addProductToCompare);
        meerkat.messaging.subscribe(moduleEvents.REMOVE_PRODUCT, removeProduct);
        meerkat.messaging.subscribe(moduleEvents.RENDER_BASKET, renderBasket);
        meerkat.messaging.subscribe(moduleEvents.ENTER_COMPARE, enterCompareMode);
        meerkat.messaging.subscribe(ResultsView.moduleEvents.RESULTS_TOGGLE_MODE, toggleViewMode);
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, resetComparison);
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, resetComparison);
    }
    function toggleProductEvent(event) {
        var $element = $(this), eventType, productId = $element.attr("data-productId");
        if ($element.is(":checked")) {
            eventType = moduleEvents.ADD_PRODUCT;
            $element.addClass("checked");
        } else {
            eventType = moduleEvents.REMOVE_PRODUCT;
            $element.removeClass("checked");
        }
        meerkat.messaging.publish(eventType, {
            element: $element,
            productId: productId,
            product: Results.getResult("productId", productId)
        });
    }
    function addProductToCompare(eventObject) {
        meerkat.messaging.publish(moduleEvents.BEFORE_ADD_COMPARE_PRODUCT);
        var productId = eventObject.productId;
        var success = addComparedProduct(productId, eventObject.product);
        if (success) {
            toggleSelectedState(productId, true);
            if (isAtMaxQueue() && settings.autoCompareAtMax === true) {
                meerkat.messaging.publish(moduleEvents.ENTER_COMPARE);
            } else {
                meerkat.messaging.publish(moduleEvents.RENDER_BASKET);
            }
        } else {
            log("[compare] Failed to add product");
        }
    }
    function removeProduct(eventObject) {
        var productId = eventObject.productId;
        if (typeof productId === "undefined") {
            return;
        }
        var success = removeComparedProductId(productId);
        if (success) {
            if (isCompareOpen()) {
                filterResults();
            }
            meerkat.messaging.publish(moduleEvents.RENDER_BASKET);
            toggleSelectedState(productId, false);
        } else {
            log("[compare] Failed to remove product");
        }
    }
    function resetComparison() {
        if (Results.getFilteredResults() === false) return;
        comparedProducts = [];
        meerkat.messaging.publish(moduleEvents.RENDER_BASKET);
        toggleSelectedState(false, false);
        if (isCompareOpen()) {
            comparisonOpen = false;
            if (previousMode == "price") {
                if (typeof settings.callbacks.switchMode === "function") {
                    settings.callbacks.switchMode(previousMode);
                }
            } else {
                if (typeof meerkat.modules[meerkat.site.vertical + "Results"].publishExtraSuperTagEvents === "function") {
                    meerkat.modules[meerkat.site.vertical + "Results"].publishExtraSuperTagEvents();
                }
            }
            settings.elements.exitCompareButton.addClass("hidden");
            _.defer(function() {
                unfilterResults();
            });
            meerkat.messaging.publish(moduleEvents.EXIT_COMPARE);
        }
    }
    function enterCompareMode() {
        comparisonOpen = true;
        settings.elements.enterCompareMode.addClass("disabled");
        settings.elements.exitCompareButton.removeClass("hidden");
        previousMode = Results.getDisplayMode();
        if (previousMode == "price") {
            if (typeof settings.callbacks.switchMode === "function") {
                settings.callbacks.switchMode("features");
            }
        } else {
            if (typeof meerkat.modules[meerkat.site.vertical + "Results"].publishExtraSuperTagEvents === "function") {
                meerkat.modules[meerkat.site.vertical + "Results"].publishExtraSuperTagEvents();
            }
        }
        filterResults();
        meerkat.messaging.publish(moduleEvents.AFTER_ENTER_COMPARE_MODE);
        trackComparison();
        setTimeout(function() {
            settings.elements.enterCompareMode.removeClass("disabled");
        }, 250);
    }
    function renderBasket(eventObject) {
        switch (Results.getDisplayMode()) {
          case "features":
            $template = settings.templates.compareBasketFeatures;
            $location = settings.elements.basketLocationFeatures;
            $(settings.elements.basketLocationPrice).empty();
            break;

          case "price":
            $template = settings.templates.compareBasketPrice;
            $location = settings.elements.basketLocationPrice;
            $(settings.elements.basketLocationFeatures).empty();
            break;
        }
        if (typeof $template === "undefined" || $template.length === 0) {
            return;
        }
        var templateCallback = _.template($template.html()), templateObj = {
            maxAllowable: getMaxToCompare(),
            resultsCount: Results.getFilteredResults().length,
            comparedResultsCount: getComparedProducts().length,
            products: getComparedProducts(),
            isCompareOpen: isCompareOpen()
        };
        $location.html(templateCallback(templateObj));
        if (Results.getDisplayMode() == "price") {
            if (getComparedProducts().length) {
                $location.closest("nav").removeClass("hidden");
            } else {
                $location.closest("nav").addClass("hidden");
            }
        }
    }
    function toggleSelectedState(productId, status) {
        var $collectionCheckboxes, $collectionRows;
        if (productId === false) {
            $collectionCheckboxes = $(".compare-tick[data-productId]");
            $collectionRows = $(".result-row.compared", resultsContainer);
        } else {
            $collectionCheckboxes = $('.compare-tick[data-productId="' + productId + '"]');
            $collectionRows = $('.result-row[data-productId="' + productId + '"]', resultsContainer);
        }
        $collectionCheckboxes.each(function() {
            var $el = $(this);
            $el.prop("checked", status).toggleClass("checked", status);
        });
        $collectionRows.each(function() {
            $(this).toggleClass("compared", status);
        });
    }
    function toggleViewMode() {
        meerkat.messaging.publish(moduleEvents.RENDER_BASKET);
        switch (Results.getDisplayMode()) {
          case "features":
            settings.elements.compareBar.addClass("hidden");
            break;
        }
    }
    function filterResults() {
        var comparedIds = getComparedProductIds();
        if (comparedIds.length > 1) {
            resultsFiltered = true;
            Results.filterBy("productId", "value", {
                inArray: comparedIds
            }, true);
            if (Results.settings.show.unavailableCombined === true) {
                _.defer(function() {
                    Results.view.fadeResultOut($(".result_unavailable_combined"), Results.settings.animation.filter.active);
                });
            }
        } else {
            resetComparison();
        }
    }
    function unfilterResults() {
        Results.unfilterBy("productId", "value", resultsFiltered);
        if (Results.settings.show.unavailableCombined === true) {
            _.defer(function() {
                Results.view.fadeResultIn($(".result_unavailable_combined"), Results.getFilteredResults().length + 1, Results.settings.animation.filter.active);
            });
        }
        resultsFiltered = false;
    }
    function getComparedProducts() {
        return typeof comparedProducts === "object" && comparedProducts !== null ? comparedProducts : [];
    }
    function getMaxToCompare() {
        return settings.maxProducts;
    }
    function getComparedProductIds(asObj) {
        var productIds = [], products = getComparedProducts();
        for (var i = 0; i < products.length; i++) {
            if (typeof products[i][productIdPath] === "undefined") {
                log("[getComparedProductIds] No Product Id in Object: ", products[i]);
                continue;
            }
            if (asObj) {
                var data = {
                    productID: products[i][productIdPath]
                };
                if (typeof products[i].brandCode !== "undefined") {
                    data.productBrandCode = products[i].brandCode;
                }
                productIds.push(data);
            } else {
                productIds.push(products[i][productIdPath]);
            }
        }
        return productIds;
    }
    function addComparedProduct(productId, obj) {
        if (typeof comparedProducts === "object" && comparedProducts !== null) {
            var item = findById(getComparedProducts(), productId);
            if (item === null) {
                comparedProducts.push(obj);
                return true;
            }
        }
        return false;
    }
    function removeComparedProductId(productId) {
        var list = getComparedProducts();
        var removeIndex = findById(list, productId, true, productIdPath);
        if (typeof list[removeIndex] !== "undefined") {
            list.splice(removeIndex, 1);
            return true;
        }
        return false;
    }
    function findById(array, id, returnKey, index) {
        index = !index ? productIdPath : index;
        for (var i = 0, len = array.length; i < len; i++) {
            if (id == array[i][index]) {
                if (returnKey) {
                    return i;
                } else {
                    return array[i];
                }
            }
        }
        return null;
    }
    function isCompareOpen() {
        return comparisonOpen;
    }
    function isAtMaxQueue() {
        return getMaxToCompare() == getComparedProducts().length;
    }
    function trackComparison() {
        meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
            touchType: "H",
            touchComment: "ResCompare"
        });
        var verticalCode = meerkat.site.vertical === "home" ? "Home_Contents" : meerkat.site.vertical;
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteComparison",
            object: {
                products: getComparedProductIds(true),
                vertical: verticalCode,
                verticalFilter: typeof meerkat.modules[meerkat.site.vertical].getVerticalFilter === "function" ? meerkat.modules[meerkat.site.vertical].getVerticalFilter() : null
            }
        });
    }
    meerkat.modules.register("compare", {
        initCompare: initCompare,
        events: events,
        isCompareOpen: isCompareOpen
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        contactDetails: {
            name: {
                FIELD_CHANGED: "NAME_FIELD_CHANGED",
                OPTIN_FIELD_CHANGED: "NAME_OPTIN_FIELD_CHANGED"
            },
            email: {
                FIELD_CHANGED: "EMAIL_FIELD_CHANGED",
                OPTIN_FIELD_CHANGED: "EMAIL_OPTIN_FIELD_CHANGED"
            },
            phone: {
                FIELD_CHANGED: "PHONE_FIELD_CHANGED",
                OPTIN_FIELD_CHANGED: "PHONE_OPTIN_FIELD_CHANGED"
            },
            mobile: {
                FIELD_CHANGED: "MOBILE_FIELD_CHANGED",
                OPTIN_FIELD_CHANGED: "MOBILE_OPTIN_FIELD_CHANGED"
            },
            otherPhone: {
                FIELD_CHANGED: "OTHERPHONE_FIELD_CHANGED",
                OPTIN_FIELD_CHANGED: "OTHERPHONE_OPTIN_FIELD_CHANGED"
            }
        }
    }, moduleEvents = events.contactDetails;
    var fields = {};
    prefillLaterFields = true;
    function init() {}
    function configure(contactDetailsFields) {
        $(document).ready(function() {
            $.extend(fields, contactDetailsFields);
            _.each(fields, function(fieldTypeEntities, fieldType) {
                _.each(fieldTypeEntities, function(fieldTypeEntity, index) {
                    var fieldDetails = $.extend(fieldTypeEntity, {
                        index: index,
                        type: fieldType,
                        fieldIndex: 1
                    });
                    setFieldChangeEvent(fieldDetails);
                    setOptinFieldChangeEvent(fieldDetails);
                    if (typeof fieldDetails.$otherField !== "undefined") {
                        fieldDetails = $.extend({}, fieldDetails, {
                            alternateOtherField: true,
                            fieldIndex: 2
                        });
                        setFieldChangeEvent(fieldDetails);
                    }
                });
            });
            prefillLaterFields = true;
        });
    }
    function setFieldChangeEvent(fieldDetails) {
        var $fieldElement = getInputField(fieldDetails);
        if (typeof fieldDetails.alternateOtherField !== "undefined" && fieldDetails.alternateOtherField) {
            $fieldElement = fieldDetails.$otherField;
        }
        $fieldElement.on("change.contactDetails", function() {
            $this = $(this);
            _.defer(function() {
                onFieldChangeEvent($this, fieldDetails);
            });
        });
        onFieldChangeEvent($fieldElement, fieldDetails, false);
    }
    function onFieldChangeEvent($element, fieldDetails, publishEvent) {
        if (typeof publishEvent === "undefined") publishEvent = true;
        if ($element.isValid()) {
            if (needsOptInValueCheckFromDbOnChange(fieldDetails)) {
                fetchOptIn(fieldDetails, publishEvent);
            } else {
                var eventObject = getChangeEventObject(fieldDetails);
                if (publishEvent) {
                    publishFieldChangeEvent(eventObject);
                }
                fieldChanged(eventObject);
            }
        }
    }
    function needsOptInValueCheckFromDbOnChange(fieldDetails) {
        var supportedOptIns = [ "email" ];
        if (fieldDetails.$optInField != "undefined" && $.inArray(fieldDetails.type, supportedOptIns) !== -1) {
            return true;
        }
        return false;
    }
    function fetchOptIn(fieldDetails, publishEvent) {
        meerkat.modules.loadingAnimation.showAfter(fieldDetails.$field);
        var fieldInfo = {
            data: {
                type: fieldDetails.type,
                value: fieldDetails.$field.val()
            },
            onComplete: function() {
                meerkat.modules.loadingAnimation.hide(fieldDetails.$field);
            },
            onSuccess: function(result) {
                var optins = {
                    optins: {
                        email: result.optInMarketing
                    }
                };
                var eventObject = $.extend(getChangeEventObject(fieldDetails), optins);
                if (publishEvent) {
                    publishFieldChangeEvent(eventObject);
                }
                fieldChanged(eventObject);
            },
            onError: function() {
                showOptInField(fieldDetails.$optInField);
            }
        };
        meerkat.modules.optIn.fetch(fieldInfo);
    }
    function setOptinFieldChangeEvent(fieldDetails) {
        if (typeof fieldDetails.$optInField !== "undefined") {
            fieldDetails.$optInField.on("change.contactDetails", function() {
                var eventObject = getChangeEventObject(fieldDetails);
                publishOptInFieldChangeEvent(eventObject);
                optInFieldChanged(eventObject);
            });
        }
    }
    function getChangeEventObject(fieldDetails) {
        var eventObject = {
            index: fieldDetails.index,
            type: fieldDetails.type,
            $field: getInputField(fieldDetails),
            $otherField: fieldDetails.$otherField,
            fieldIndex: fieldDetails.fieldIndex,
            $savedField: fieldDetails.$field,
            $optInField: fieldDetails.$optInField
        };
        if (typeof fieldDetails.alternateOtherField !== "undefined" && fieldDetails.alternateOtherField) {
            eventObject.$otherField = eventObject.$field;
            eventObject.$field = fieldDetails.$otherField;
        }
        return eventObject;
    }
    function publishFieldChangeEvent(eventObject) {
        msg.publish(eventObject.type.toUpperCase() + "_FIELD_CHANGED", eventObject);
    }
    function publishOptInFieldChangeEvent(eventObject) {
        msg.publish(eventObject.type.toUpperCase() + "_OPTIN_FIELD_CHANGED", eventObject);
    }
    function fieldChanged(fieldDetails) {
        if (typeof fieldDetails.$optInField !== "undefined" && isOptInFieldVisibilityUpdatable(fieldDetails)) {
            updateOptInFieldVisibility(fieldDetails.$optInField, fieldDetails.optins[fieldDetails.type]);
        }
        if (prefillLaterFields && fieldDetails.index !== fields[fieldDetails.type].length) {
            updateLaterFieldsValues(fieldDetails);
        }
    }
    function isOptInFieldVisibilityUpdatable(fieldDetails) {
        return hasOptInValue(fieldDetails) && !isPartOfOptInGroup(fieldDetails);
    }
    function hasOptInValue(fieldDetails) {
        if (typeof fieldDetails.optins !== "undefined" && typeof fieldDetails.optins[fieldDetails.type] !== "undefined") {
            return true;
        }
        return false;
    }
    function isPartOfOptInGroup(fieldDetails) {
        return getFieldsFromOptInGroup(fieldDetails).length > 1;
    }
    function isOptInGroupValid(fieldDetails) {
        var fieldsInOptInGroup = getFieldsFromOptInGroup(fieldDetails);
        var valid = true;
        _.each(fieldsInOptInGroup, function(currentFieldDetails) {
            if (!currentFieldDetails.$field.isValid()) {
                valid = false;
            }
        });
        return valid;
    }
    function getFieldsFromOptInGroup(fieldDetails) {
        var listOfFieldsWithSameOptInField = [];
        _.each(getAllFieldsArray(), function(currentFieldDetails) {
            if (typeof currentFieldDetails.$optInField !== "undefined" && currentFieldDetails.$optInField.is(fieldDetails.$optInField)) {
                listOfFieldsWithSameOptInField.push(currentFieldDetails);
            }
        });
        return listOfFieldsWithSameOptInField;
    }
    function getAllFieldsArray() {
        var allFields = [];
        _.each(fields, function(fieldTypeEntities, fieldType) {
            _.each(fieldTypeEntities, function(fieldTypeEntity, index) {
                allFields.push($.extend(fieldTypeEntity, {
                    type: fieldType
                }));
            });
        });
        return allFields;
    }
    function updateOptInFieldVisibility($optInField, isOptedIn) {
        if (isOptedIn) {
            hideOptInField($optInField);
        } else {
            showOptInField($optInField);
        }
    }
    function showOptInField($element) {
        setOptInFieldValue($element, false);
        $element.parents(".fieldrow").first().slideDown();
    }
    function hideOptInField($element) {
        $element.parents(".fieldrow").first().slideUp();
        $element.attr("data-visible", "true");
        setOptInFieldValue($element, true);
    }
    function optInFieldChanged(fieldDetails) {
        if (prefillLaterFields && fieldDetails.index !== fields[fieldDetails.type].length) {
            updateLaterOptInFields(fieldDetails);
        }
    }
    function getInputField(fieldEntity) {
        var $fieldElement = null;
        if (typeof fieldEntity.$fieldInput !== "undefined") {
            $fieldElement = fieldEntity.$fieldInput;
        } else {
            $fieldElement = fieldEntity.$field;
        }
        return $fieldElement;
    }
    function updateLaterFieldsValues(fieldDetails) {
        var $updatedElement = fieldDetails.$field;
        var updatedElementPreviousValue = typeof $updatedElement.attr("data-previous-value") === "undefined" ? "" : $updatedElement.attr("data-previous-value");
        var updatedElementValue = $updatedElement.val();
        $updatedElement.attr("data-previous-value", updatedElementValue);
        var updatedElementOptInValue;
        if (typeof fieldDetails.$optInField === "undefined") {
            updatedElementOptInValue = null;
        } else if (hasOptInValue(fieldDetails)) {
            updatedElementOptInValue = fieldDetails.optins[fieldDetails.type] || getOptInFieldIsChecked(fieldDetails.$optInField);
        } else {
            updatedElementOptInValue = getOptInFieldIsChecked(fieldDetails.$optInField);
        }
        for (var i = fieldDetails.index + 1; i < fields[fieldDetails.type].length; i++) {
            var laterFieldDetails = $.extend(fields[fieldDetails.type][i], {
                type: fieldDetails.type
            });
            var $fieldElement = getInputField(laterFieldDetails);
            if (($fieldElement.val() === "" || updatedElementPreviousValue === $fieldElement.val()) && (typeof laterFieldDetails.$otherField === "undefined" || laterFieldDetails.$otherField.val() === "")) {
                if (fieldDetails.type == "name" && typeof laterFieldDetails.$otherField !== "undefined") {
                    var splitName = updatedElementValue.split(" ");
                    $fieldElement.val(splitName[0]);
                    laterFieldDetails.$otherField.val(splitName.slice(1).join(" "));
                } else if (fieldDetails.type === "alternatePhone" && typeof laterFieldDetails.$otherField !== "undefined") {
                    var testableNumber = updatedElementValue.replace(/\D/g, "");
                    if (testableNumber.match(/^(04|614|6104)/g)) {
                        $fieldElement.val(updatedElementValue);
                    } else {
                        laterFieldDetails.$otherField.val(updatedElementValue);
                    }
                } else {
                    $fieldElement.val(updatedElementValue).attr("data-previous-value", updatedElementValue);
                }
                if (meerkat.modules.performanceProfiling.isIE8() || meerkat.modules.performanceProfiling.isIE9()) {
                    if (typeof laterFieldDetails.$fieldInput !== "undefined") {
                        meerkat.modules.placeholder.invalidatePlaceholder(laterFieldDetails.$fieldInput);
                    } else {
                        meerkat.modules.placeholder.invalidatePlaceholder($fieldElement);
                    }
                }
                if (typeof laterFieldDetails.$fieldInput !== "undefined") {
                    $fieldElement.trigger("change").trigger("blur").trigger("focusout");
                }
                if (typeof laterFieldDetails.$optInField !== "undefined" && !isPartOfOptInGroup(laterFieldDetails)) {
                    updateOptInFieldVisibility(laterFieldDetails.$optInField, updatedElementOptInValue);
                }
            }
        }
    }
    function updateLaterOptInFields(fieldDetails) {
        var updatedElementIsChecked = getOptInFieldIsChecked(fieldDetails.$optInField);
        var updatedElementOptInValue = null;
        if (hasOptInValue(fieldDetails)) {
            updatedElementOptInValue = fieldDetails.optins[fieldDetails.type];
        }
        if (typeof updatedElementIsChecked !== "undefined") {
            for (var i = fieldDetails.index + 1; i < fields[fieldDetails.type].length; i++) {
                var laterFieldDetails = $.extend(fields[fieldDetails.type][i], {
                    type: fieldDetails.type
                });
                if (typeof laterFieldDetails.$optInField !== "undefined") {
                    if (updatedElementIsChecked && !isPartOfOptInGroup(laterFieldDetails)) {
                        updateOptInFieldVisibility(laterFieldDetails.$optInField, updatedElementIsChecked);
                    } else {
                        showOptInField(laterFieldDetails.$optInField);
                        setOptInFieldValue(laterFieldDetails.$optInField, updatedElementIsChecked);
                    }
                }
            }
        }
    }
    function getOptInFieldIsChecked($element) {
        var updatedElementType = $element.attr("type");
        var updatedElementIsChecked = null;
        if (updatedElementType == "checkbox") {
            updatedElementIsChecked = $element.is(":checked");
        } else if (updatedElementType == "radio") {
            $element.each(function() {
                if ($(this).is(":checked")) {
                    updatedElementIsChecked = $element.val() == "Y";
                    return false;
                }
            });
        } else {
            return false;
        }
        return updatedElementIsChecked;
    }
    function setOptInFieldValue($element, isChecked) {
        var updatedElementType = $element.attr("type");
        if (updatedElementType == "checkbox") {
            $element.prop("checked", isChecked);
        } else if (updatedElementType == "radio") {
            var updateElementValue = null;
            if (isChecked) {
                updateElementValue = "Y";
            } else {
                updateElementValue = "N";
            }
            $element.each(function() {
                if ($(this).val() == updateElementValue) {
                    $(this).prop("checked", true).trigger("change");
                    return false;
                }
            });
        } else {}
    }
    function getFields() {
        return fields;
    }
    function getLatestValue(type) {
        var value = "";
        var fieldsForType = getFields()[type];
        _.each(fieldsForType, function(fieldObj) {
            if (typeof fieldObj.$field !== "undefined" && fieldObj.$field.val() !== "") {
                value = fieldObj.$field.val();
            }
        });
        return value;
    }
    meerkat.modules.register("contactDetails", {
        init: init,
        events: events,
        configure: configure,
        getFields: getFields,
        getFieldsFromOptInGroup: getFieldsFromOptInGroup,
        isOptInGroupValid: isOptInGroupValid,
        isPartOfOptInGroup: isPartOfOptInGroup,
        getLatestValue: getLatestValue
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        contentPopulation: {}
    }, moduleEvents = events.contentPopulation;
    function init() {}
    function empty(container) {
        $("[data-source]", $(container)).each(function() {
            $(this).empty();
        });
    }
    function render(container) {
        $("[data-source]", $(container)).each(function() {
            var output = "", $el = $(this), $sourceElement = $($el.attr("data-source")), $alternateSourceElement = $($el.attr("data-alternate-source"));
            if (!$sourceElement.length) return;
            sourceType = $sourceElement.get(0).tagName.toLowerCase(), dataType = $el.attr("data-type"), 
            callback = $el.attr("data-callback");
            if (callback) {
                try {
                    var namespaces = callback.split(".");
                    if (namespaces.length) {
                        var func = namespaces.pop(), context = window;
                        for (var i = 0; i < namespaces.length; i++) {
                            context = context[namespaces[i]];
                        }
                        output = context[func].apply(context, [ $sourceElement ]);
                    } else {
                        output = callback.apply(window, [ $sourceElement ]);
                    }
                } catch (e) {
                    meerkat.modules.errorHandling.error({
                        message: "Unable to perform render Content Population Callback properly.",
                        page: "contentPopulation.js:render()",
                        errorLevel: "silent",
                        description: "Unable to perform contentPopulation callback labelled: " + callback,
                        data: {
                            error: e.toString(),
                            sourceElement: $el.attr("data-source")
                        }
                    });
                    output = "";
                }
            } else if (!dataType) {
                switch (sourceType) {
                  case "select":
                    var $selected = $sourceElement.find("option:selected");
                    if ($selected.val() === "") {
                        output = "";
                    } else {
                        output = $selected.text() || "";
                        if (output === "" && $alternateSourceElement.length) {
                            $selected = $alternateSourceElement.find("option:selected");
                            if ($selected.val() === "") {
                                output = "";
                            } else {
                                output = $selected.text() || "";
                            }
                        }
                    }
                    break;

                  case "input":
                    output = $sourceElement.val() || $alternateSourceElement.val() || "";
                    break;

                  default:
                    output = $sourceElement.html() || $alternateSourceElement.html() || "";
                    break;
                }
            } else {
                var selectedParent;
                switch (dataType) {
                  case "checkboxgroup":
                    selectedParent = $sourceElement.parent().find(":checked").next("label");
                    if (selectedParent.length) {
                        output = selectedParent.text() || "";
                    }
                    break;

                  case "radiogroup":
                    selectedParent = $sourceElement.find(":checked").parent("label");
                    if (selectedParent.length) {
                        output = selectedParent.text() || "";
                    }
                    break;

                  case "list":
                    var $listElements = $sourceElement.find("li");
                    if ($listElements.length > 0) {
                        $listElements.each(function() {
                            output += "<li>" + $(this).find("span:eq(0)").text() + "</li>";
                        });
                    } else {
                        output += "<li>None selected</li>";
                    }
                    break;

                  case "optional":
                    output = $sourceElement.val() || $alternateSourceElement.val() || "";
                    if (output !== "") {
                        $(".noDetailsEntered").remove();
                    }
                    break;

                  case "object":
                    break;
                }
            }
            $el.html(output);
        });
    }
    meerkat.modules.register("contentPopulation", {
        init: init,
        events: events,
        render: render,
        empty: empty
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, debug = meerkat.logging.debug, exception = meerkat.logging.exception;
    var events = {
        coupon: {}
    };
    var $couponIdField, $couponCodeField, $couponOptinField, $couponOptinGroup, $couponErrorContainer, $couponSuccessContainer, currentCoupon = false, hasAutoPoped = false, isAvailable = false;
    function init() {
        $(document).ready(function() {
            checkCouponsAvailability();
            if (isAvailable === true) {
                $couponIdField = $(".coupon-id-field"), $couponCodeField = $(".coupon-code-field"), 
                $couponOptinField = $(".coupon-optin-field"), $couponOptinGroup = $(".coupon-optin-group"), 
                $couponErrorContainer = $(".coupon-error-container"), $couponSuccessContainer = $(".coupon-success-container");
                preload();
                _.defer(function() {
                    eventSubscriptions();
                });
            }
        });
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function() {
            resetWhenChangeStep();
        });
    }
    function checkCouponsAvailability() {
        if ($(".coupon-id-field").length > 0) {
            isAvailable = true;
        }
    }
    function preload() {
        if (meerkat.site.isCallCentreUser && meerkat.site.vdn !== "") {
            loadCoupon("vdn", meerkat.site.vdn);
        } else if (meerkat.site.couponId !== "") {
            loadCoupon("couponId", meerkat.site.couponId);
        }
    }
    function loadCoupon(type, dataParam, successCallBack) {
        if (isAvailable !== true) return;
        if (!type) return;
        var url = "", data = {};
        data.transactionId = meerkat.modules.transactionId.get();
        switch (type) {
          case "couponId":
            url = "coupon/id/get.json";
            data.couponId = dataParam;
            break;

          case "vdn":
            url = "coupon/vdn/get.json";
            data.vdn = dataParam;
            break;

          case "filter":
            if (isCurrentCouponValid() === true) {
                if (typeof successCallBack === "function") {
                    successCallBack();
                }
                return;
            }
            url = "coupon/filter.json";
            break;

          default:
            exception("invalid type to load coupon");
            return;
        }
        meerkat.modules.comms.get({
            url: url,
            cache: false,
            errorLevel: "silent",
            dataType: "json",
            data: data
        }).done(function onSuccess(json) {
            setCurrentCoupon(json);
            populateFields();
            if (typeof successCallBack === "function") {
                successCallBack();
            }
        }).fail(function onError(obj, txt, errorThrown) {
            exception(txt + ": " + errorThrown);
        });
    }
    function validateCouponCode(couponCode) {
        if (isAvailable !== true) return;
        var transactionId = meerkat.modules.transactionId.get();
        meerkat.modules.comms.get({
            url: "coupon/code/validate.json",
            cache: false,
            errorLevel: "silent",
            dataType: "json",
            useDefaultErrorHandling: false,
            data: {
                transactionId: transactionId,
                couponCode: couponCode
            }
        }).done(function onSuccess(json) {
            setCurrentCoupon(json);
            validateField();
        }).fail(function onError(obj, txt, errorThrown) {
            exception(txt + ": " + errorThrown);
        });
    }
    function renderCouponBanner() {
        if (isCurrentCouponValid() === true && currentCoupon.hasOwnProperty("contentBanner")) {
            $(".coupon-banner-container").html(currentCoupon.contentBanner);
            if (currentCoupon.showPopup === true && hasAutoPoped === false) {
                _.defer(function() {
                    $(".coupon-banner").click();
                    hasAutoPoped = true;
                });
            }
        }
    }
    function isCurrentCouponValid() {
        if (currentCoupon === false || !currentCoupon.hasOwnProperty("couponId")) {
            debug("Coupon has not been stored correctly - can not render");
            return false;
        }
        if (isNaN(currentCoupon.couponId) || currentCoupon.couponId <= 0) {
            debug("No valid coupon found - can not render");
            return false;
        }
        return true;
    }
    function validateField() {
        if ($couponCodeField.val().trim() === "") {
            $couponCodeField.parent().removeClass("has-custom-error");
            $couponErrorContainer.addClass("hidden");
            resetWhenError();
        } else if (isCurrentCouponValid() === false) {
            $couponCodeField.parent().addClass("has-custom-error");
            $couponErrorContainer.find("label").html("Oops! This offer has now expired or you have entered an invalid code. To continue, simply remove the promo code or try re-entering your code.");
            $couponErrorContainer.removeClass("hidden");
            resetWhenError();
        } else if (currentCoupon.hasOwnProperty("errors") && currentCoupon.errors.length > 0) {
            $couponCodeField.parent().addClass("has-custom-error");
            $couponErrorContainer.find("label").html(currentCoupon.errors[0].message);
            $couponErrorContainer.removeClass("hidden");
            resetWhenError();
        } else {
            resetWhenError();
            $couponIdField.val(currentCoupon.couponId);
            $couponCodeField.parent().removeClass("has-custom-error");
            $couponErrorContainer.addClass("hidden");
            if (currentCoupon.hasOwnProperty("contentSuccess") && currentCoupon.contentSuccess !== "") {
                $couponSuccessContainer.html(currentCoupon.contentSuccess);
                $couponSuccessContainer.removeClass("hidden");
            }
            if (currentCoupon.hasOwnProperty("contentCheckbox") && currentCoupon.contentCheckbox !== "") {
                $couponOptinGroup.find(".checkbox label").html(currentCoupon.contentCheckbox);
                $couponOptinGroup.removeClass("hidden");
            } else {
                $couponOptinField.prop("type", "hidden");
            }
        }
    }
    function resetWhenError() {
        $couponSuccessContainer.addClass("hidden");
        $couponIdField.val("");
        $couponOptinField.prop("type", "checkbox");
        $couponOptinField.attr("checked", false);
        $couponOptinGroup.addClass("hidden");
    }
    function resetWhenChangeStep() {
        $couponCodeField.parent().removeClass("has-custom-error");
        $couponSuccessContainer.addClass("hidden");
        $couponErrorContainer.addClass("hidden");
        $couponOptinField.prop("type", "checkbox");
        $couponOptinField.attr("checked", false);
        $couponOptinGroup.addClass("hidden");
    }
    function populateFields() {
        if (isCurrentCouponValid() === true && currentCoupon.canPrePopulate === true) {
            $couponIdField.val(currentCoupon.couponId);
            $couponCodeField.val(currentCoupon.couponCode);
        }
    }
    function getCurrentCoupon() {
        return currentCoupon;
    }
    function setCurrentCoupon(coupon) {
        currentCoupon = coupon;
    }
    meerkat.modules.register("coupon", {
        init: init,
        events: events,
        loadCoupon: loadCoupon,
        getCurrentCoupon: getCurrentCoupon,
        validateCouponCode: validateCouponCode,
        renderCouponBanner: renderCouponBanner
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    function applyEventListeners($this) {
        var entryName = getEntryName($this);
        entryName.on("blur", function() {
            entryName.val($.trim(entryName.val().replace(/[^\d.-]/g, "")));
            if (entryName.val() === "") {
                entryName.val("0");
            }
            if (entryName.val() !== "") {
                $this.val(entryName.asNumber());
            } else {
                $this.val("");
            }
            entryName.formatCurrency({
                symbol: "$",
                roundToDecimalPlace: -2
            });
        });
        entryName.on("focus", function() {
            entryName.toNumber().setCursorPosition(entryName.val().length, entryName.val().length);
            if (entryName.val() == "0") {
                entryName.val("");
            }
        });
    }
    function getEntryName($this) {
        var entryName = "#" + $this.attr("id") + "entry";
        return $(entryName);
    }
    function initCurrencyField() {
        var $this = $(this);
        var entryName = getEntryName($this);
        applyEventListeners($this);
        if (entryName.val() !== "" && entryName.val() !== "$0") {
            entryName.trigger("blur");
        }
    }
    function initCurrencyFields() {
        var inputsThatNeedCurrency = $("#journeyEngineSlidesContainer").find(".currency");
        inputsThatNeedCurrency.each(initCurrencyField);
    }
    function formatCurrency(number, options) {
        if (typeof $.fn.formatCurrency === "function") {
            options = options || {};
            return $("<input value=''/>").val(number).formatCurrency(options).val();
        }
        return "$" + number;
    }
    function initCurrency() {
        $.fn.setCursorPosition = function(pos) {
            var $el = $(this).get(0);
            if ($el.setSelectionRange) {
                $el.setSelectionRange(pos, pos);
            } else if ($el.createTextRange) {
                var range = $el.createTextRange();
                if (typeof range.collapse === "function") {
                    range.collapse(true).moveEnd("character", pos).moveStart("character", pos).select();
                }
            }
        };
        initCurrencyFields();
        log("[Currency] Initialised");
    }
    meerkat.modules.register("currencyField", {
        initCurrency: initCurrency,
        formatCurrency: formatCurrency,
        initSingleCurrencyField: initCurrencyField
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, debug = meerkat.logging.debug, exception = meerkat.logging.exception, $datePickerElms, datePickerSelector;
    function bindSeparatedAddonClick($passedElement) {
        $passedElement.closest(".dateinput_container").find(".withDatePicker .input-group-addon-button").on("click", function showDatePickerOnAddonClick() {
            $passedElement.datepicker("show");
        });
    }
    function bindComponentBlurBehaviour(thisDatePickerSelector) {
        $(document).on("hide", thisDatePickerSelector, function(e) {
            var $target = $(e.target);
            if (!e.target) {
                return;
            }
            if ($target.is("input")) {
                $target.blur();
                return;
            }
            if ($target.find("input").is(":focus")) {
                return;
            }
            $target.find("input").blur();
            if (meerkat.modules.performanceProfiling.isIE8() || meerkat.modules.performanceProfiling.isIE9()) {
                meerkat.modules.placeholder.invalidatePlaceholder($("input.dateinput-date"));
            }
        });
    }
    function setDefaultSettings() {
        if (typeof $.fn.datepicker.defaults === "object") {
            $.fn.datepicker.defaults.format = "dd/mm/yyyy";
            $.fn.datepicker.defaults.autoclose = true;
            $.fn.datepicker.defaults.forceParse = false;
            $.fn.datepicker.defaults.weekStart = 1;
            $.fn.datepicker.defaults.todayHighlight = true;
            $.fn.datepicker.defaults.clearBtn = false;
            $.fn.datepicker.defaults.keyboardNavigation = false;
        } else {
            exception("core/datepicker:(lib-defaults-not-setable)");
        }
    }
    function initComponentDatepicker() {
        bindComponentBlurBehaviour(datePickerSelector);
    }
    function initSeparatedDatepicker($this) {
        bindSeparatedAddonClick($this);
        $this.on("serialised.meerkat.formDateInput", function updateCalendarOnInputChanges() {
            $this.datepicker("update").blur();
        });
        $this.on("hide", function updateInputsOnCalenderChanges() {
            $this.closest(".dateinput_container").find(".withDatePicker input").blur();
            $this.blur();
        });
    }
    function initDatepickerModule() {
        datePickerSelector = "[data-provide=datepicker]";
        $datePickerElms = $(datePickerSelector);
        log("[datepicker]", "Initialised");
        if ($datePickerElms.length > 0) {
            if (typeof $.fn.datepicker !== "function") {
                exception("core/datepicker:(lib-not-loaded-err)");
                return;
            }
            setDefaultSettings();
        } else {
            debug("[datepicker]", "No datepickers found");
        }
        $datePickerElms.each(function() {
            var $this = $(this);
            var mode = $this.data("date-mode");
            if (typeof mode === "undefined") {
                mode = "component";
            }
            switch (mode) {
              case "component":
                initComponentDatepicker();
                break;

              case "inline":
                break;

              case "range":
                break;

              case "separated":
                initSeparatedDatepicker($this);
                break;
            }
        });
    }
    function init() {
        $(document).ready(function() {
            meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, function lateDomready() {
                initDatepickerModule();
            });
        });
    }
    meerkat.modules.register("datepicker", {
        init: init,
        initModule: initDatepickerModule,
        initSeparated: initSeparatedDatepicker,
        initComponent: initComponentDatepicker,
        setDefaults: setDefaultSettings
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat;
    function init() {
        jQuery(document).ready(function($) {
            $(window).load(function() {
                $("[data-defer-src]").each(function allDeferSrcLoadLoop() {
                    $this = $(this);
                    $this.attr("src", $this.attr("data-defer-src")).removeAttr("data-defer-src");
                });
            });
        });
    }
    meerkat.modules.register("deferSrcLoad", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    function initRefreshCSS() {
        function refreshStyles(event) {
            var target = event.target, tagName = target.tagName.toLowerCase(), linkTags;
            if (!(event.shiftKey && event.which === 83)) {
                return;
            }
            if (tagName === "input" || tagName === "textarea" || tagName === "select") {
                return;
            }
            linkTags = document.getElementsByTagName("link");
            for (var i = 0; i < linkTags.length; i++) {
                var linkTag = linkTags[i];
                if (linkTag.rel.toLowerCase().indexOf("stylesheet") >= 0) {
                    var href = linkTag.getAttribute("href");
                    href = href.replace(/(&|\?)forceReload=\d+/, "");
                    href = href + (href.indexOf("?") >= 0 ? "&" : "?") + "forceReload=" + new Date().getTime();
                    linkTag.setAttribute("href", href);
                }
            }
        }
        if (window.addEventListener) {
            window.addEventListener("keypress", refreshStyles);
        }
    }
    function initDevelopment() {
        if (meerkat.site.isDev === true) {
            initRefreshCSS();
        }
    }
    meerkat.modules.register("development", {
        init: initDevelopment
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        device: {
            RESIZE_DEBOUNCED: "DEVICE_RESIZE_DEBOUNCED",
            STATE_CHANGE: "DEVICE_MEDIA_STATE_CHANGE",
            STATE_ENTER_XS: "DEVICE_STATE_ENTER_XS",
            STATE_ENTER_SM: "DEVICE_STATE_ENTER_SM",
            STATE_ENTER_MD: "DEVICE_STATE_ENTER_MD",
            STATE_ENTER_LG: "DEVICE_STATE_ENTER_LG",
            STATE_LEAVE_XS: "DEVICE_STATE_LEAVE_XS",
            STATE_LEAVE_SM: "DEVICE_STATE_LEAVE_SM",
            STATE_LEAVE_MD: "DEVICE_STATE_LEAVE_MD",
            STATE_LEAVE_LG: "DEVICE_STATE_LEAVE_LG"
        }
    }, moduleEvents = events.device;
    var previousState = false;
    function getState() {
        return $("html").css("font-family").replace(/'/g, "").replace(/\"/g, "");
    }
    function init() {
        previousState = getState();
        $(window).resize(_.debounce(function() {
            var state = getState();
            meerkat.messaging.publish(moduleEvents.RESIZE_DEBOUNCED, {
                previousState: previousState,
                state: state
            });
            if (state !== previousState) {
                meerkat.messaging.publish(moduleEvents.STATE_CHANGE, {
                    previousState: previousState,
                    state: state
                });
                meerkat.messaging.publish(moduleEvents["STATE_ENTER_" + state.toUpperCase()]);
                if (previousState) {
                    meerkat.messaging.publish(moduleEvents["STATE_LEAVE_" + previousState.toUpperCase()]);
                }
                previousState = state;
            }
        }));
    }
    meerkat.modules.register("deviceMediaState", {
        init: init,
        events: events,
        get: getState
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, isXS;
    var windowCounter = 0, dialogHistory = [], openedDialogs = [], defaultSettings = {
        title: "",
        htmlContent: null,
        url: null,
        cacheUrl: false,
        buttons: [],
        className: "",
        leftBtn: {
            label: "Back",
            icon: "",
            className: "btn-sm btn-close-dialog",
            callback: null
        },
        rightBtn: {
            label: "",
            icon: "",
            className: "",
            callback: null
        },
        tabs: [],
        htmlHeaderContent: "",
        hashId: null,
        destroyOnClose: true,
        closeOnHashChange: false,
        openOnHashChange: true,
        fullHeight: false,
        templates: {
            dialogWindow: '<div id="{{= id }}" class="modal" tabindex="-1" role="dialog" aria-labelledby="{{= id }}_title" aria-hidden="true"{{ if(fullHeight===true){ }} data-fullheight="true"{{ } }}>' + '<div class="modal-dialog {{= className }}">' + '<div class="modal-content">' + '<div class="modal-closebar">' + '	<a href="javascript:;" class="btn btn-close-dialog"><span class="icon icon-cross"></span></a>' + "</div>" + '<div class="navbar navbar-default xs-results-pagination visible-xs">' + '<div class="container">' + '<ul class="nav navbar-nav">' + "<li>" + '<button data-button="leftBtn" class="btn btn-back {{= leftBtn.className }}">{{= leftBtn.icon }} {{= leftBtn.label }}</button>' + "</li>" + '<li class="navbar-text modal-title-label">' + "	{{= title }}" + "</li>" + '{{ if(rightBtn.label != "" || rightBtn.icon != "") { }}' + '<li class="right">' + '<button data-button="rightBtn" class="btn btn-save {{= rightBtn.className }}">{{= rightBtn.label }} {{= rightBtn.icon }}</button>' + "</li>" + "{{ } }}" + "</ul>" + "</div>" + "</div>" + '{{ if(title != "" || tabs.length > 0 || htmlHeaderContent != "" ) { }}' + '<div class="modal-header">' + "{{ if (tabs.length > 0) { }}" + '<ul class="nav nav-tabs tab-count-{{= tabs.length }}">' + "{{ _.each(tabs, function(tab, iterator) { }}" + '<li><a href="javascript:;" data-target="{{= tab.targetSelector }}" title="{{= tab.xsTitle }}">{{= tab.title }}</a></li>' + "{{ }); }}" + "</ul>" + '{{ } else if(title != "" ){ }}' + '<h4 class="modal-title hidden-xs" id="{{= id }}_title">{{= title }}</h4>' + '{{ } else if(htmlHeaderContent != "") { }}' + "{{= htmlHeaderContent }}" + "{{ } }}" + "</div>" + "{{ } }}" + '<div class="modal-body">' + "{{= htmlContent }}" + "</div>" + '{{ if(typeof buttons !== "undefined" && buttons.length > 0 ){ }}' + '<div class="modal-footer {{ if(buttons.length > 1 ){ }} mustShow {{ } }}">' + "{{ _.each(buttons, function(button, iterator) { }}" + '<button data-index="{{= iterator }}" type="button" class="btn {{= button.className }} ">{{= button.label }}</button>' + "{{ }); }}" + "</div>" + "{{ } }}" + "</div>" + "</div>" + "</div>"
        },
        onOpen: function(dialogId) {},
        onClose: function(dialogId) {},
        onLoad: function(dialogId) {}
    };
    function show(instanceSettings) {
        var settings = $.extend({}, defaultSettings, instanceSettings);
        isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;
        var id = "mkDialog_" + windowCounter;
        if (!_.isUndefined(settings.id)) {
            if (isDialogOpen(settings.id)) {
                close(settings.id);
            }
        } else {
            settings.id = id;
            windowCounter++;
        }
        if (settings.hashId != null) {
            meerkat.modules.address.appendToHash(settings.hashId);
        }
        var htmlTemplate = _.template(settings.templates.dialogWindow);
        if (settings.url != null || settings.externalUrl != null) {
            settings.htmlContent = meerkat.modules.loadingAnimation.getTemplate();
        }
        var htmlString = htmlTemplate(settings);
        $("#dynamic_dom").append(htmlString);
        var $modal = $("#" + settings.id);
        $modal.modal({
            show: true,
            backdrop: settings.buttons && settings.buttons.length > 0 ? "static" : true,
            keyboard: false
        });
        $modal.css("z-index", parseInt($modal.eq(0).css("z-index")) + openedDialogs.length * 10);
        var $backdrop = $(".modal-backdrop");
        $backdrop.eq($backdrop.length - 1).css("z-index", parseInt($backdrop.eq(0).css("z-index")) + openedDialogs.length * 10);
        $modal.on("hidden.bs.modal", function(event) {
            if (typeof event.target === "undefined") return;
            var $target = $(event.target);
            if ($target.length === 0 || $target.hasClass("modal") === false) return;
            doClose($target.attr("id"));
        });
        $modal.on("shown.bs.tab", function(event) {
            resizeDialog(settings.id);
        });
        $modal.find("button").on("click", function onModalButtonClick(eventObject) {
            var button = settings.buttons[$(eventObject.currentTarget).attr("data-index")];
            if (!_.isUndefined(button)) {
                if (button.closeWindow === true) {
                    $(eventObject.currentTarget).closest(".modal").modal("hide");
                }
                if (typeof button.action === "function") button.action(eventObject);
            }
        });
        $modal.find(".navbar-nav button").off().on("click", function onModalTitleButtonClick(eventObject) {
            var button = settings[$(eventObject.currentTarget).attr("data-button")];
            if (typeof button != "undefined" && typeof button.callback == "function") button.callback(eventObject);
        });
        if (settings.url != null) {
            meerkat.modules.comms.get({
                url: settings.url,
                cache: settings.cacheUrl,
                errorLevel: "warning",
                onSuccess: function dialogSuccess(result) {
                    changeContent(settings.id, result);
                    if (typeof settings.onLoad === "function") settings.onLoad(settings.id);
                }
            });
        }
        if (settings.externalUrl != null) {
            var iframe = '<iframe class="displayNone" id="' + settings.id + '_iframe" width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true" src="' + settings.externalUrl + '"></iframe>';
            appendContent(settings.id, iframe);
            $("#" + settings.id + "_iframe").on("load", function() {
                $(this).show();
                meerkat.modules.loadingAnimation.hide($("#" + settings.id));
            });
        }
        window.setTimeout(function() {
            resizeDialog(settings.id);
        }, 0);
        if (typeof settings.onOpen === "function") settings.onOpen(settings.id);
        openedDialogs.push(settings);
        return settings.id;
    }
    function close(dialogId) {
        $("#" + dialogId).modal("hide");
    }
    function doClose(dialogId) {
        if (openedDialogs.length > 1) {
            _.defer(function() {
                if (openedDialogs.length > 0 && openedDialogs[0].id !== dialogId) {
                    $(document.body).addClass("modal-open");
                }
            });
        }
        var settings = getSettings(dialogId);
        if (settings !== null && typeof settings.onClose === "function") settings.onClose(dialogId);
        if (settings.destroyOnClose === true) {
            destroyDialog(dialogId);
        } else {
            meerkat.modules.address.removeFromHash(settings.hashId);
        }
    }
    function calculateLayout(eventObject) {
        $("#dynamic_dom .modal").each(function resizeModalItem(index, element) {
            resizeDialog($(element).attr("id"));
        });
    }
    function changeContent(dialogId, htmlContent, callback) {
        $("#" + dialogId + " .modal-body").html(htmlContent);
        if (typeof callback === "function") {
            callback();
        }
        calculateLayout();
    }
    function appendContent(dialogId, htmlContent) {
        $("#" + dialogId + " .modal-body").append(htmlContent);
        calculateLayout();
    }
    function resizeDialog(dialogId) {
        isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;
        var $dialog = $("#" + dialogId);
        if ($dialog.find(".modal-header").outerHeight(true) === 0) {
            window.setTimeout(function() {
                resizeDialog(dialogId);
            }, 20);
        } else {
            var viewport_height, content_height, dialogTop, $modalContent = $dialog.find(".modal-content"), $modalBody = $dialog.find(".modal-body"), $modalDialog = $dialog.find(".modal-dialog");
            viewport_height = $(window).height();
            if (!isXS) {
                viewport_height -= 60;
            }
            content_height = viewport_height;
            content_height -= $dialog.find(".modal-header").outerHeight(true);
            content_height -= $dialog.find(".modal-footer").outerHeight(true);
            content_height -= $dialog.find(".modal-closebar").outerHeight(true);
            if (isXS) {
                $modalContent.css("height", viewport_height);
                $dialog.find(".modal-body").css("max-height", "none").css("height", content_height);
                dialogTop = 0;
                $modalDialog.css("top", dialogTop);
            } else {
                $modalContent.css("max-height", viewport_height);
                if ($dialog.attr("data-fullheight") === "true") {
                    $modalContent.css("height", viewport_height);
                    $modalBody.css("height", content_height);
                } else {
                    $modalContent.css("height", "auto");
                    $modalBody.css("height", "auto");
                }
                $dialog.find(".modal-body").css("max-height", content_height);
                dialogTop = viewport_height / 2 - $modalDialog.height() / 2;
                if ($modalContent.height() < viewport_height) {
                    dialogTop = dialogTop / 2;
                }
                $modalDialog.css("top", dialogTop);
            }
        }
    }
    function destroyDialog(dialogId) {
        if (!dialogId || dialogId.length === 0) return;
        var $dialog = $("#" + dialogId);
        $dialog.find("button").off().end().remove();
        var settings = getSettings(dialogId);
        if (settings != null) {
            if (settings.hashId != null) {
                meerkat.modules.address.removeFromHash(settings.hashId);
                var previousInstance = _.findWhere(dialogHistory, {
                    hashId: settings.hashId
                });
                if (previousInstance == null) dialogHistory.push(settings);
            }
            openedDialogs.splice(settings.index, 1);
        }
    }
    function getSettings(dialogId) {
        var index = getDialogSettingsIndex(dialogId);
        if (index !== null) {
            openedDialogs[index].index = index;
            return openedDialogs[index];
        }
        return null;
    }
    function getDialogSettingsIndex(dialogId) {
        for (var i = 0; i < openedDialogs.length; i++) {
            if (openedDialogs[i].id == dialogId) return i;
        }
        return null;
    }
    function isDialogOpen(dialogId) {
        return !_.isNull(getDialogSettingsIndex(dialogId));
    }
    function initDialogs() {
        $(document).ready(function() {
            $(document).on("click", ".btn-close-dialog", function() {
                $(this).closest(".modal").modal("hide");
            });
            if (!Modernizr.touch) return;
            $(document).on("touchmove", ".modal", function(e) {
                e.preventDefault();
            });
            $(document).on("touchmove", ".modal .modal-body", function(e) {
                e.stopPropagation();
            });
        });
        var self = this;
        meerkat.messaging.subscribe(meerkatEvents.dynamicContentLoading.PARSED_DIALOG, function dialogClicked(event) {
            var dialogInfoObject;
            var hashValue = event.element.attr("data-dialog-hash-id");
            var hashId = null;
            if (hashValue !== "") hashId = hashValue;
            if (event.contentType === "url") {
                dialogInfoObject = {
                    title: event.element.attr("data-title"),
                    url: event.contentValue,
                    cacheUrl: event.element.attr("data-cache") ? true : false
                };
            } else if (event.contentType === "externalUrl") {
                dialogInfoObject = {
                    title: event.element.attr("data-title"),
                    externalUrl: event.contentValue
                };
            } else {
                dialogInfoObject = {
                    title: $(event.contentValue).attr("data-title"),
                    htmlContent: event.contentValue
                };
            }
            var instanceSettings = $.extend({
                hashId: hashId,
                closeOnHashChange: true,
                className: event.element.attr("data-class")
            }, dialogInfoObject);
            show(instanceSettings);
        });
        var lazyLayout = _.debounce(calculateLayout, 300);
        $(window).resize(lazyLayout);
        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function dialogHashChange(event) {
            for (var i = openedDialogs.length - 1; i >= 0; i--) {
                var dialog = openedDialogs[i];
                if (dialog.closeOnHashChange === true) {
                    if (_.indexOf(event.hashArray, dialog.hashId) == -1) {
                        self.close(dialog.id);
                    }
                }
            }
            for (var j = 0; j < event.hashArray.length; j++) {
                var windowOpen = _.findWhere(openedDialogs, {
                    hashId: event.hashArray[j]
                });
                if (windowOpen == null) {
                    var previousInstance = _.findWhere(dialogHistory, {
                        hashId: event.hashArray[j]
                    });
                    if (previousInstance != null) {
                        if (previousInstance.openOnHashChange === true) {
                            meerkat.modules.dialogs.show(previousInstance);
                        }
                    }
                }
            }
        }, window);
    }
    meerkat.modules.register("dialogs", {
        init: initDialogs,
        show: show,
        changeContent: changeContent,
        close: close,
        isDialogOpen: isDialogOpen,
        resizeDialog: resizeDialog
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $newBackdropElement = $('<div class="dropdown-backdrop" />');
    function init() {
        $(document).ready(function() {
            if (!Modernizr.touch) return;
            $(document).on("touchmove", ".dropdown-backdrop, .dropdown-interactive form", function(e) {
                e.preventDefault();
                e.stopPropagation();
            });
            $(document).on("touchmove", ".dropdown-interactive .scrollable", function(e) {
                e.stopPropagation();
            });
        });
        $(document).on("show.bs.dropdown", function(event) {
            if (!event.target) return;
            var $target = $(event.target);
            if ($target.hasClass("dropdown-interactive") === false) return;
            addBackdrop($target);
        });
        $(document).on("shown.bs.dropdown", function(event) {
            if (!event.target) return;
            var $target = $(event.target);
            if ($target.hasClass("dropdown-interactive") === false) return;
            var useCache = true;
            if (meerkat.modules.deviceMediaState.get() === "xs") useCache = false;
            _.defer(function() {
                if (fitIntoViewport($target, useCache)) {
                    $(document.body).addClass("dropdown-fitviewport");
                }
            });
            $(document.body).addClass("dropdown-open");
        });
        $(document).on("hidden.bs.dropdown", function(event) {
            $(document.body).removeClass("dropdown-open").removeClass("dropdown-fitviewport");
        });
        meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function resizeDropdowns(state) {
            $(".dropdown-interactive").each(function() {
                var $this = $(this);
                $this.removeAttr("data-maxheight");
                resetFit($this);
                if ($this.hasClass("open")) {
                    if (fitIntoViewport($this, false)) {
                        $(document.body).addClass("dropdown-fitviewport");
                    }
                    $(document.body).addClass("dropdown-open");
                }
            });
        });
    }
    function addBackdrop($dropdown) {
        var $backdropBase = $dropdown.closest(".dropdown-interactive-base"), $backdropAlternative = $dropdown.closest(".dropdown-interactive");
        if ($backdropBase.length && $backdropAlternative.length) {
            return $newBackdropElement.prependTo($backdropBase).on("click", clearMenus);
        } else if ($backdropAlternative.length) {
            return $newBackdropElement.prependTo($backdropAlternative).on("click", clearMenus);
        }
    }
    function fitIntoViewport($dropdown, useCache) {
        if (!$dropdown || $dropdown.length === 0) {
            return;
        }
        var viewportHeight = 0, maxHeight = 0, extraHeights = 0;
        if (useCache === true && $dropdown.attr("data-maxheight")) {
            maxHeight = $dropdown.attr("data-maxheight");
        } else {
            viewportHeight = $(window).height();
            if (meerkat.modules.deviceMediaState.get() === "xs") {
                extraHeights += $("header .dynamicTopHeaderContent").outerHeight();
                extraHeights += $("header .navbar-header").outerHeight();
                extraHeights += $dropdown.find(".activator").outerHeight();
                $dropdown.prevAll("li:visible").each(function() {
                    extraHeights += $(this).outerHeight();
                });
            } else {
                extraHeights += 20;
                $dropdown.closest(".navbar-affix").each(function() {
                    extraHeights += $(this).outerHeight();
                });
            }
            extraHeights += $dropdown.find("form").outerHeight() - $dropdown.find(".scrollable").outerHeight();
            maxHeight = viewportHeight - extraHeights;
            $dropdown.attr("data-maxheight", maxHeight);
        }
        if (maxHeight > 0) {
            $dropdown.find(".dropdown-container .scrollable").css("max-height", maxHeight).css("overflow-y", "auto").hide().show(0);
            return true;
        } else {
            resetFit($dropdown);
            return false;
        }
    }
    function resetFit($dropdown) {
        $dropdown.find(".dropdown-container .scrollable").css("max-height", "");
    }
    function clearMenus() {
        $('[data-toggle="dropdown"]').parent(".open").children('[data-toggle="dropdown"]').dropdown("toggle");
    }
    meerkat.modules.register("dropdownInteractive", {
        init: init,
        fitIntoViewport: fitIntoViewport,
        addBackdrop: addBackdrop
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        dynamicContentLoading: {
            PARSED_POPOVER: "DYNAMIC_CONTENT_PARSED_POPOVER",
            PARSED_DIALOG: "DYNAMIC_CONTENT_PARSED_DIALOG"
        }
    }, moduleEvents = events.dynamicContentLoading;
    function init() {
        applyDynamicContentListeners();
    }
    function applyDynamicContentListeners() {
        $(document.body).on("click", "a[data-content]", function(eventObject) {
            eventObject.preventDefault();
            eventObject.stopPropagation();
            parseDynamicContent(eventObject);
        });
        $(document.body).on("mouseenter", '[data-trigger=mouseenter], [data-trigger="mouseenter click"]', function(eventObject) {
            parseDynamicContent(eventObject);
        });
    }
    function parseDynamicContent(eventObject) {
        var contentType = null;
        var contentValue = null;
        var $currentTarget = $(eventObject.currentTarget);
        var targetContent = $currentTarget.attr("data-content");
        var targetType = $currentTarget.attr("data-toggle");
        if (typeof targetType !== "undefined" && targetType !== "") {
            var contentUrlTest = targetContent.split(".");
            if (targetContent[0] === "#" || targetContent[0] === ".") {
                contentType = "selector";
                contentValue = $(targetContent).html();
            } else if (targetContent.substr(0, 7) == "helpid:") {
                contentType = "url";
                contentValue = "ajax/xml/help.jsp?id=" + targetContent.substr(7, targetContent.length);
            } else if (targetContent.substring(0, 4) === "http" || targetContent.substring(0, 3) === "www") {
                contentType = "externalUrl";
                contentValue = targetContent;
            } else if (contentUrlTest[contentUrlTest.length - 1] == "jsp" || contentUrlTest[contentUrlTest.length - 1] == "html") {
                contentType = "url";
                contentValue = targetContent;
            } else {
                contentType = "content";
                contentValue = targetContent;
            }
            meerkat.messaging.publish(moduleEvents["PARSED_" + targetType.toUpperCase()], {
                element: $currentTarget,
                contentType: contentType,
                contentValue: contentValue
            });
        } else {}
    }
    meerkat.modules.register("dynamicContentLoading", {
        init: init,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, emailBrochuresSettings = {}, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        emailBrochures: {
            QUOTE_SAVED: "EMAIL_BROCHURE_SAVED",
            DESTROY: "EMAIL_BROCHURE_DESTROY"
        }
    }, moduleEvents = events.emailBrochures;
    var defaultSettings = {
        sendEmailDataFunction: getEmailData,
        canEnableSubmit: canEnableSubmit,
        submitUrl: "productBrochures/send/email.json",
        lockoutOnCheckUserExists: true
    };
    function setup(instanceSettings) {
        var settings = $.extend({}, defaultSettings, instanceSettings);
        tearDown(settings);
        settings = meerkat.modules.sendEmail.setup(settings);
        settings.emailBrochuresOnClickFunction = function() {
            meerkat.messaging.publish(meerkat.modules.events.sendEmail.REQUEST_SEND, {
                instanceSettings: settings
            });
        };
        settings.submitButton.on("click", settings.emailBrochuresOnClickFunction);
        emailBrochuresSettings[settings.identifier] = settings;
        return settings;
    }
    function tearDown(instanceSettings) {
        var existingSettings = emailBrochuresSettings[instanceSettings.identifier];
        if (typeof existingSettings !== "undefined" && existingSettings != null) {
            emailBrochuresSettings[existingSettings.identifier] = null;
            meerkat.modules.sendEmail.tearDown(existingSettings);
            existingSettings.submitButton.off("click", existingSettings.emailBrochuresOnClickFunction);
        }
    }
    function canEnableSubmit(instanceSettings) {
        return instanceSettings.emailInput.valid();
    }
    function getEmailData(settings) {
        var dat = null;
        if (typeof settings.productData !== "undefined") {
            dat = settings.productData;
        } else {
            dat = [];
        }
        dat.push({
            name: "premiumFrequency",
            value: Results.settings.frequency
        });
        dat.push({
            name: "marketing",
            value: settings.marketing.val()
        });
        return dat;
    }
    meerkat.modules.register("emailBrochures", {
        setup: setup,
        events: events,
        tearDown: tearDown
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging, handlers = {
        data_ready: false,
        validation_error: false
    };
    var events = {
        emailLoadQuote: {
            TRIGGERS_MODAL: "TRIGGERS_MODAL"
        }
    }, moduleEvents = events;
    var emailTypes = [ "expired", "promotion" ];
    function init() {
        if (isApplicable()) {
            handlers.step_init = meerkat.messaging.subscribe(meerkat.modules.events.journeyEngine.STEP_INIT, _.bind(action, this, true));
            handlers.validation_error = meerkat.messaging.subscribe(meerkat.modules.events.journeyEngine.STEP_VALIDATION_ERROR, _.bind(action, this, false));
        }
    }
    function action(valid) {
        meerkat.messaging.unsubscribe(meerkat.modules.events.journeyEngine.STEP_INIT, handlers.step_init);
        meerkat.messaging.unsubscribe(meerkat.modules.events.journeyEngine.STEP_VALIDATION_ERROR, handlers.validation_error);
        var publish = function() {
            meerkat.messaging.publish(events.emailLoadQuote.TRIGGERS_MODAL, {
                action: meerkat.site.pageAction,
                valid: valid
            });
        };
        if (valid && meerkat.modules.performanceProfiling.isIE8()) {
            _.defer(publish);
        } else {
            publish();
        }
    }
    function isApplicable() {
        return !meerkat.site.isNewQuote && _.indexOf(emailTypes, meerkat.site.pageAction) > -1;
    }
    function getStartStepOverride(startStep) {
        if (isApplicable()) {
            return "results";
        }
        return startStep;
    }
    meerkat.modules.register("emailLoadQuote", {
        init: init,
        events: events,
        getStartStepOverride: getStartStepOverride
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var log = meerkat.logging.info;
    var events = {
        errorHandling: {
            OK_CLICKED: "OK_CLICKED"
        }
    }, moduleEvents = events.errorHandling;
    var defaultSettings = {
        errorLevel: "silent",
        page: "unknown",
        title: "Error",
        message: "Sorry, an error has occurred",
        description: "unknown",
        data: null,
        id: null
    };
    function error(instanceSettings) {
        if (typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null) {
            console.error("Message to dev: please provide an errorLevel to the errorHandling.error() function.");
        }
        var settings = $.extend({}, defaultSettings, instanceSettings);
        var fatal;
        switch (settings.errorLevel) {
          case "warning":
            fatal = false;
            showErrorMessage(fatal, settings);
            break;

          case "fatal":
            fatal = true;
            showErrorMessage(fatal, settings);
            break;

          default:
            fatal = false;
            break;
        }
        settings.fatal = fatal;
        var transactionId = "";
        if (typeof meerkat.modules.transactionId != "undefined") {
            transactionId = meerkat.modules.transactionId.get();
            if (transactionId === null) transactionId = "";
        }
        settings.transactionId = transactionId;
        if (typeof settings.data == "object" && settings.data !== null) settings.data = JSON.stringify(settings.data);
        if (fatal) {
            try {
                meerkat.modules.writeQuote.write({
                    triggeredsave: "fatalerror",
                    triggeredsavereason: settings.description
                }, false);
            } catch (e) {}
        }
        meerkat.modules.comms.post({
            url: "ajax/write/register_fatal_error.jsp",
            data: settings,
            useDefaultErrorHandling: false,
            errorLevel: "silent",
            onError: function() {}
        });
    }
    function showErrorMessage(fatal, data) {
        var buttons;
        if (fatal) {
            if (data.closeWindow === true) {
                buttons = [ {
                    label: "Close page",
                    className: "btn-cta",
                    action: function(eventObject) {
                        window.close();
                    },
                    closeWindow: false
                } ];
            } else {
                buttons = [ {
                    label: "Refresh page",
                    className: "btn-cta",
                    action: function(eventObject) {
                        location.reload();
                    },
                    closeWindow: false
                } ];
            }
            if (meerkat.site.isDev === true) {
                buttons.push({
                    label: "Attempt to continue [dev only]",
                    className: "btn-cancel",
                    action: null,
                    closeWindow: true
                });
            }
        } else {
            buttons = [ {
                label: "OK",
                className: "btn-cta",
                closeWindow: true,
                action: function() {
                    meerkat.messaging.publish(moduleEvents.OK_CLICKED);
                }
            } ];
        }
        var dialogSettings = {
            title: data.title,
            htmlContent: data.message,
            buttons: buttons
        };
        if (!_.isNull(data.id)) {
            $.extend(dialogSettings, {
                id: data.id
            });
        }
        var modal = meerkat.modules.dialogs.show(dialogSettings);
        if (fatal && !meerkat.site.isDev) {
            $("#" + modal + " .modal-closebar").remove();
        }
    }
    meerkat.modules.register("errorHandling", {
        error: error,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var deviceType = null;
    var headerAffixed = false;
    var isV3 = null;
    function init() {
        deviceType = $("#deviceType").attr("data-deviceType");
        jQuery(document).ready(function($) {
            applyEventListeners();
            eventSubscriptions();
        });
    }
    function applyEventListeners() {
        $(document).on("results.view.animation.start, pagination.scrolling.start", function onAnimationStart() {
            calculateDockedHeader("startPaginationScroll");
        });
        $(document).on("pagination.scrolling.end", function onPaginationEnd() {
            calculateDockedHeader("endPaginationScroll");
        });
        $(document).on("results.view.animation.end", function onAnimationEnd() {
            $(".result-row").css({
                position: ""
            });
            calculateDockedHeader("filterAnimationEnded");
        });
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            headerAffixed = true;
            calculateDockedHeader("affixed");
        });
        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            headerAffixed = false;
            calculateDockedHeader("unaffixed");
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function onDeviceMediaStateChange() {
            calculateDockedHeader("deviceMediaStateChange");
        });
        meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function onExitCompareMode() {
            calculateDockedHeader("startPaginationScroll");
        });
        meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function onAfterEnterCompareMode() {
            calculateDockedHeader("endPaginationScroll");
        });
    }
    function calculateDockedHeader(event) {
        if (_.isNull(isV3)) {
            isV3 = $("#results_v3").length > 0;
        }
        var $featuresDockedHeader = $(".featuresDockedHeader"), $originalHeader = $(".headers");
        if (isV3 === true && deviceType != "TABLET" && meerkat.modules.deviceMediaState.get() != "xs") {
            var featuresView = Results.getDisplayMode() == "features" ? true : false, redrawFixedHeader = true, pagePaginationActive = event == "startPaginationScroll" || event == "endPaginationScroll" || event == "filterAnimationEnded";
            if (featuresView) {
                var $fixedDockedHeader = $(".fixedDockedHeader");
                if (headerAffixed) {
                    if ($originalHeader.parent().hasClass("featuresHeaders") === false) {
                        $originalHeader.hide();
                    }
                    var $currentPage = $(".currentPage"), topPosition = $("#navbar-filter").height() + $("#navbar-main").outerHeight(), dockedHeaderTop = event == "startPaginationScroll" ? "0" : topPosition + "px", dockedHeaderWidth = $(".result-row").first().width();
                    var pageContentOffSet = $("#pageContent").offset(), navFilterOffSet = $("#navbar-filter").offset(), offSetFromTopPlusNav = (_.isUndefined(navFilterOffSet) ? 0 : navFilterOffSet.top) - (_.isUndefined(pageContentOffSet) ? 0 : pageContentOffSet.top) + 7, dockedHeaderPosition = event == "startPaginationScroll" ? "absolute" : "fixed", dockedHeaderPaddingTop = event == "startPaginationScroll" ? offSetFromTopPlusNav + "px" : "0px";
                    if (!pagePaginationActive) {
                        $currentPage.find($featuresDockedHeader).css({
                            top: dockedHeaderTop,
                            width: dockedHeaderWidth
                        }).show();
                    } else {
                        redrawFixedHeader = false;
                        $featuresDockedHeader.css({
                            position: dockedHeaderPosition,
                            top: dockedHeaderTop,
                            width: dockedHeaderWidth,
                            "padding-top": dockedHeaderPaddingTop
                        }).show();
                        if (event == "endPaginationScroll" || event == "filterAnimationEnded") {
                            if ($currentPage.length >= 1) {
                                $currentPage.siblings(":not(.currentPage)").find($featuresDockedHeader).hide();
                            } else {
                                $featuresDockedHeader.hide();
                            }
                            redrawFixedHeader = true;
                        }
                    }
                    recalculateFixedHeader(redrawFixedHeader);
                } else {
                    $featuresDockedHeader.hide();
                    $fixedDockedHeader.hide();
                    $originalHeader.show();
                }
            } else {
                $originalHeader.show();
                $featuresDockedHeader.hide();
            }
        } else {
            $originalHeader.show();
            $featuresDockedHeader.hide();
        }
    }
    function recalculateFixedHeader(redrawFixedHeader) {
        var $fixedDockedHeader = $(".fixedDockedHeader"), $currentPage = $(".currentPage"), topPosition = $("#navbar-filter").height() + $("#navbar-main").outerHeight();
        if (redrawFixedHeader) {
            var cellFeatureWidth = $(".cell.feature").width() + 2 + "px", dockedHeaderHeight = "100px";
            if ($currentPage.length >= 1) {
                dockedHeaderHeight = $(".resultInsert.featuresMode:visible").first().innerHeight() + 1 + "px";
            }
            $fixedDockedHeader.css({
                top: topPosition,
                width: cellFeatureWidth,
                height: dockedHeaderHeight
            }).show();
        }
    }
    meerkat.modules.register("featuresDockedHeader", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    function init() {
        jQuery(document).ready(function($) {
            if (meerkat.modules.performanceProfiling.isFFAffectedByDropdownMenuBug()) {
                $("html").addClass("ff-no-custom-menu");
            }
        });
    }
    meerkat.modules.register("firefoxMenuFix", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        form: {}
    }, moduleEvents = events.form;
    function init() {}
    function getData($element) {
        return filterData($element).serializeArray();
    }
    function getSerializedData($element) {
        return filterData($element).serialize();
    }
    function filterData($element) {
        return $element.find(":input:visible, input[type=hidden], :input[data-visible=true], :input[data-initValue=true], :input[data-attach=true]").filter(function() {
            return $(this).val() !== "" && $(this).val() !== "Please choose...";
        });
    }
    function markFieldsAsVisible($parentElement) {
        clearInitialFieldsAttribute($parentElement);
        $parentElement.find(":input[data-visible]").removeAttr("data-visible");
        $parentElement.find(":input:visible").attr("data-visible", "true");
    }
    function clearInitialFieldsAttribute($parentElement) {
        $parentElement.find(":input[data-initValue]").removeAttr("data-initValue");
    }
    function markInitialFieldsWithValue($parentElement) {
        $elements = $parentElement.find(":input").filter(function() {
            return $(this).val() !== "" && $(this).val() !== "Please choose...";
        });
        $elements.attr("data-initValue", "true");
    }
    function appendHiddenField($form, name, value) {
        $form.append('<input type="hidden" id="' + name + '" name="' + name + '" data-visible="true" value="' + value + '" />');
    }
    meerkat.modules.register("form", {
        init: init,
        events: events,
        getData: getData,
        getSerializedData: getSerializedData,
        appendHiddenField: appendHiddenField,
        markFieldsAsVisible: markFieldsAsVisible,
        markInitialFieldsWithValue: markInitialFieldsWithValue,
        clearInitialFieldsAttribute: clearInitialFieldsAttribute
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    function init() {
        var iOS = meerkat.modules.performanceProfiling.isIos();
        var iOS5 = meerkat.modules.performanceProfiling.isIos5();
        var Android = meerkat.modules.performanceProfiling.isAndroid();
        var Chrome = meerkat.modules.performanceProfiling.isChrome();
        $(document).ready(function() {
            var nativePickerEnabled = false;
            if (Modernizr.inputtypes.date && (iOS && !iOS5 || Android && Chrome)) {
                nativePickerEnabled = true;
            }
            $("[data-provide=dateinput]").each(function setupDateInput() {
                var $component = $(this);
                if (nativePickerEnabled) {
                    $component.attr("data-dateinput-type", "native");
                    $component.find(".dateinput-tripleField").addClass("hidden");
                    $component.find(".dateinput-nativePicker").removeClass("hidden").find("input").on("change", serialise);
                } else {
                    $component.find("input.dateinput-day, input.dateinput-month, input.dateinput-year").on("input", moveToNextInput).on("change", serialise);
                }
                var $serialise = $component.find(".serialise");
                populate($component, $serialise.val());
                $serialise.on("change", function() {
                    populate($component, this.value);
                });
            });
        });
    }
    function populate($component, value) {
        var parts = value.split("/"), nativeValue = "";
        if ($component.attr("data-locked") == 1) return;
        $component.attr("data-locked", 1);
        if (value.length === 0 || parts.length !== 3) {
            parts = [ "", "", "" ];
        } else {
            if (parts[0].length === 1) parts[0] = "0" + parts[0];
            if (parts[1].length === 1) parts[1] = "0" + parts[1];
            if (parts[2].length === 4 && parts[1].length === 2 && parts[0].length === 2) {
                nativeValue = parts[2] + "-" + parts[1] + "-" + parts[0];
            }
        }
        $component.find("input.dateinput-day").val(parts[0]);
        $component.find("input.dateinput-month").val(parts[1]);
        $component.find("input.dateinput-year").val(parts[2]);
        $component.find(".dateinput-nativePicker input").val(nativeValue);
        if (meerkat.modules.performanceProfiling.isIE8() || meerkat.modules.performanceProfiling.isIE9()) {
            meerkat.modules.placeholder.invalidatePlaceholder($component.find("input.dateinput-day"));
            meerkat.modules.placeholder.invalidatePlaceholder($component.find("input.dateinput-month"));
            meerkat.modules.placeholder.invalidatePlaceholder($component.find("input.dateinput-year"));
        }
        $component.removeAttr("data-locked");
        var populatedEvent = $.Event("populated.meerkat.formDateInput");
        $component.trigger(populatedEvent);
    }
    function moveToNextInput() {
        var $this = $(this);
        if (!$this.attr("maxlength")) {
            return;
        }
        if ($this.hasClass("year") || $this.hasClass("dateinput-year")) {
            return;
        }
        if ($this.val().length == $this.attr("maxlength")) {
            var next = $this.hasClass("dateinput-day") ? "input.dateinput-month" : "input.dateinput-year";
            $this.closest('[data-provide="dateinput"]').find(next).focus().select();
        }
    }
    function serialise() {
        var $component = $(this).parents('[data-provide="dateinput"]'), $destination = $component.find(".serialise"), day = "", month = "", year = "";
        if ($component.attr("data-locked") == 1) return;
        $component.attr("data-locked", 1);
        if ($component.attr("data-dateinput-type") == "native") {
            var parts = this.value.length > 0 ? this.value.split("-") : [ "", "", "" ];
            year = parts[0];
            month = parts[1];
            day = parts[2];
        } else {
            day = $component.find("input.dateinput-day").val();
            month = $component.find("input.dateinput-month").val();
            year = $component.find("input.dateinput-year").val();
        }
        if (day.length === 1) day = "0" + day;
        if (month.length === 1) month = "0" + month;
        if ($component.attr("data-dateinput-type") != "native") {
            $component.find("input.dateinput-day").val(day);
            $component.find("input.dateinput-month").val(month);
        }
        if (day.length > 0 && Number(day) > 0 && month.length > 0 && Number(month) > 0 && year.length > 0 && Number(year) > 0) {
            $destination.val(day + "/" + month + "/" + year);
            $destination.valid();
            var serialiseEvent = $.Event("serialised.meerkat.formDateInput");
            $destination.trigger(serialiseEvent, $destination.val());
        } else {
            $destination.val("");
        }
        $destination.change();
        $component.removeAttr("data-locked");
    }
    meerkat.modules.register("formDateInput", {
        init: init,
        populate: populate,
        serialise: serialise
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {}, moduleEvents = events;
    function init() {
        jQuery(document).ready(function($) {
            if ($.hasOwnProperty("number") && _.isFunction($.number)) {
                $("input.liveFormatNumber").each(function() {
                    var $that = $(this);
                    var decimals = 0;
                    if ($that.hasClass("formattedInteger")) {
                        decimals = 0;
                    } else if ($that.hasClass("formattedDecimal")) {
                        $($that.attr("class").split(" ")).each(function() {
                            if (this.indexOf("formattedDecimal_") === 0) {
                                decimals = Number(this.split("_")[1]);
                            }
                        });
                    }
                    $that.number(true, decimals);
                });
            }
        });
    }
    meerkat.modules.register("formNumberFormatInputs", {
        init: init,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    function initPlaceholders() {
        if (Modernizr.input.placeholder) {
            setUpUnfocused();
        }
    }
    function setUpUnfocused() {
        var $inputs = $("input[data-placeholder-unfocused]");
        $inputs.each(function eachInput() {
            var $element = $(this);
            var original = "";
            if ($element.attr("placeholder")) {
                original = $element.attr("placeholder");
            }
            $element.attr("data-placeholder", original);
            $element.attr("placeholder", $element.attr("data-placeholder-unfocused"));
            $element.on("focus.formPlaceholders.unfocused", function swapPlaceholderFocus() {
                $(this).attr("placeholder", $(this).attr("data-placeholder"));
            });
            $element.on("blur.formPlaceholders.unfocused", function swapPlaceholderBlur() {
                if ($(this).val().length > 0) return;
                $(this).attr("placeholder", $(this).attr("data-placeholder-unfocused"));
            });
        });
    }
    meerkat.modules.register("formPlaceholders", {
        init: initPlaceholders
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {}, moduleEvents = events;
    function init() {
        jQuery(document).ready(function($) {
            $(".help-icon").prop("tabindex", -1);
        });
    }
    meerkat.modules.register("helpIcons", {
        init: init,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    function initIe8SelectMenuAutoExpand() {}
    function bindEvents($parent, selector) {
        if (!meerkat.modules.performanceProfiling.isIE8()) {
            return;
        }
        $parent.on("focus", selector, function() {
            var el = $(this);
            el.data("width", el.width());
            el.width("auto");
            el.data("width-auto", $(this).width());
            if (el.data("width-auto") < el.data("width")) {
                el.width(el.data("width"));
            } else {
                el.width(el.data("width-auto") + 15);
            }
        }).on("blur", selector, function() {
            var el = $(this);
            el.width(el.data("width"));
        });
    }
    meerkat.modules.register("ie8SelectMenuAutoExpand", {
        init: initIe8SelectMenuAutoExpand,
        bindEvents: bindEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        journeyEngine: {
            BEFORE_STEP_CHANGED: "BEFORE_STEP_CHANGED",
            STEP_CHANGED: "STEP_CHANGED",
            STEP_INIT: "STEP_INIT",
            READY: "JOURNEY_READY",
            STEP_VALIDATION_ERROR: "STEP_VALIDATION_ERROR"
        }
    }, moduleEvents = events.journeyEngine;
    var currentStep = null, webappLock = false, furtherestStep = null;
    var DIRECTION_FORWARD = "DIRECTION_FORWARD", DIRECTION_BACKWARD = "DIRECTION_BACKWARD";
    var settings = {
        startStepId: null,
        steps: [],
        progressBarSteps: [],
        slideContainer: "#journeyEngineContainer",
        slideClassName: "journeyEngineSlide",
        transition: null
    };
    var defaultStepSettings = {
        title: null,
        navigationId: null,
        slideId: null,
        initialised: false,
        onInitialise: null,
        onBeforeEnter: null,
        onAfterEnter: null,
        onBeforeLeave: null,
        onAfterLeave: null,
        additionalHashInfo: null,
        validation: {
            validate: true,
            customValidation: null
        },
        slideScrollTo: "html, body",
        tracking: null,
        externalTracking: null
    };
    function configure(instanceSettings) {
        if (instanceSettings === null) {
            hideInitialLoader();
            return false;
        }
        $.extend(settings, instanceSettings);
        $(settings.slideContainer + " ." + settings.slideClassName).removeClass("active").addClass("hiddenSlide");
        for (var i = 0; i < settings.steps.length; i++) {
            settings.steps[i] = $.extend({}, defaultStepSettings, settings.steps[i]);
        }
        settings.steps.sort(function(a, b) {
            if (a.slideIndex < b.slideIndex) {
                return -1;
            } else if (a.slideIndex > b.slideIndex) {
                return 1;
            } else {
                return 0;
            }
        });
        if (settings.startStepId === null && meerkat.modules.address.getWindowHash() === "") {
            settings.startStepId = settings.steps[0].navigationId;
            meerkat.modules.address.setStartHash(settings.startStepId);
            onNavigationChange({
                navigationId: settings.startStepId
            });
        } else {
            if (settings.startStepId === null) {
                var hashValue = meerkat.modules.address.getWindowHashAt(0);
                var requestedStep = getStep(hashValue);
                if (requestedStep === null) {
                    settings.startStepId = settings.steps[0].navigationId;
                } else {
                    settings.startStepId = hashValue;
                }
            }
            var eventObject = {};
            eventObject.direction = DIRECTION_FORWARD;
            eventObject.isForward = true;
            eventObject.isBackward = false;
            eventObject.isStartMode = true;
            var stepToShow = settings.steps[0];
            processStep(0, function(step, validated) {
                if (step == null) step = stepToShow;
                settings.startStepId = step.navigationId;
                if (validated) {
                    currentStep = null;
                    furtherestStep = null;
                } else {
                    showSlide(currentStep, false, null);
                    onShowNextStep(eventObject, null, false);
                }
                var startStepId = settings.startStepId;
                if (typeof step !== "undefined" && typeof step.additionalHashInfo === "function") startStepId += "/" + step.additionalHashInfo();
                if (meerkat.modules.address.getWindowHash() !== "" && meerkat.modules.address.getWindowHash() !== startStepId) {
                    meerkat.modules.address.setHash(startStepId);
                } else {
                    meerkat.modules.address.setStartHash(startStepId);
                    onNavigationChange({
                        navigationId: settings.startStepId
                    });
                }
            });
        }
        meerkat.messaging.publish(moduleEvents.READY, this);
        function processStep(index, callback) {
            if (index >= settings.steps.length) callback(null);
            var step = settings.steps[index];
            if (step.navigationId === settings.startStepId) {
                callback(step, true);
            } else {
                try {
                    onStepEnter(step, eventObject);
                    if (step.onAfterEnter != null) step.onAfterEnter(eventObject);
                    currentStep = step;
                    setFurtherestStep();
                    validateStep(step, function successCallback() {
                        if (currentStep.onBeforeLeave != null) currentStep.onBeforeLeave(eventObject);
                        if (currentStep.onAfterLeave != null) currentStep.onAfterLeave(eventObject);
                        _.defer(function() {
                            processStep(index + 1, callback);
                        });
                    });
                } catch (e) {
                    meerkat.logging.info("[journeyEngine]", e);
                    callback(step, false);
                }
            }
        }
    }
    function onStepEnter(step, eventObject) {
        if (step.initialised === false && step.onInitialise != null) step.onInitialise(eventObject);
        step.initialised = true;
        updateCurrentStepHiddenField(step);
        if (step.onBeforeEnter != null) step.onBeforeEnter(eventObject);
    }
    function onNavigationChange(eventObject) {
        try {
            eventObject.isStartMode = false;
            if (eventObject.navigationId === "") eventObject.navigationId = settings.startStepId;
            var step = getStep(eventObject.navigationId);
            if (step === null) {
                step = getStep(0);
            }
            step.stepIndex = getStepIndex(step.navigationId);
            if (currentStep === null) {
                eventObject.direction = DIRECTION_FORWARD;
                eventObject.isForward = true;
                eventObject.isBackward = false;
                _goToStep(step, eventObject);
            } else {
                eventObject.previousNavigationId = currentStep.navigationId;
                if (eventObject.navigationId == currentStep.navigationId) {
                    return false;
                }
                if (getStepIndex(step.navigationId) < getStepIndex(currentStep.navigationId)) {
                    eventObject.direction = DIRECTION_BACKWARD;
                    eventObject.isForward = false;
                    eventObject.isBackward = true;
                    _goToStep(step, eventObject);
                } else if (getStepIndex(step.navigationId) == getStepIndex(currentStep.navigationId) + 1) {
                    eventObject.direction = DIRECTION_FORWARD;
                    eventObject.isForward = true;
                    eventObject.isBackward = false;
                    if ($(settings.slideContainer).attr("data-prevalidation-completed") == "1") {
                        $(settings.slideContainer).removeAttr("data-prevalidation-completed");
                        _goToStep(step, eventObject);
                    } else {
                        validateStep(currentStep, function afterValidation() {
                            _goToStep(step, eventObject);
                        });
                    }
                } else {
                    throw "Moving forward too many steps. " + currentStep.navigationId + " to " + eventObject.navigationId;
                }
            }
        } catch (e) {
            unlock();
            meerkat.modules.address.setHash(currentStep.navigationId);
            meerkat.logging.info("[journeyEngine]", e);
            return false;
        }
        return true;
    }
    function _goToStep(step, eventObject) {
        meerkat.messaging.publish(moduleEvents.BEFORE_STEP_CHANGED);
        if (currentStep !== null && currentStep.onBeforeLeave != null) currentStep.onBeforeLeave(eventObject);
        onStepEnter(step, eventObject);
        _goToSlide(step, eventObject);
    }
    function _goToSlide(step, eventObject) {
        var previousStep = currentStep;
        if (currentStep === null || step.slideIndex == currentStep.slideIndex) {
            onHidePreviousStep();
            if (currentStep === null) showSlide(step, false);
            currentStep = step;
            setFurtherestStep();
            onShowNextStep(eventObject, previousStep, true);
        } else {
            $slide = $(settings.slideContainer + " ." + settings.slideClassName + ":eq(" + currentStep.slideIndex + ")");
            $slide.fadeOut(250, function afterHide() {
                $slide.removeClass("active").addClass("hiddenSlide");
                onHidePreviousStep();
                currentStep = step;
                setFurtherestStep();
                showSlide(step, true, function onShown() {
                    onShowNextStep(eventObject, previousStep, true);
                    sessionCamRecorder(currentStep);
                });
            });
        }
        function onHidePreviousStep() {
            if (currentStep != null && currentStep.onAfterLeave != null) currentStep.onAfterLeave(eventObject);
        }
    }
    function sessionCamRecorder(step) {
        meerkat.modules.sessionCamHelper.updateVirtualPageFromJourneyEngine(step);
    }
    function onShowNextStep(eventObject, previousStep, triggerEnterMethod) {
        $("body").attr("data-step", currentStep.navigationId);
        var title = meerkat.site.title;
        if (currentStep.title != null) title = currentStep.title + " - " + title;
        window.document.title = title;
        if (currentStep.slideScrollTo && currentStep.slideScrollTo !== null) {
            meerkat.modules.utils.scrollPageTo(currentStep.slideScrollTo);
        }
        if (triggerEnterMethod === true) {
            if (currentStep.onAfterEnter != null) currentStep.onAfterEnter(eventObject);
        }
        unlock();
        var eventType = moduleEvents.STEP_INIT;
        if (previousStep !== null) {
            eventType = moduleEvents.STEP_CHANGED;
        }
        if (eventType === moduleEvents.STEP_INIT) {
            hideInitialLoader();
        }
        eventObject.step = currentStep;
        eventObject.navigationId = currentStep.navigationId;
        meerkat.messaging.publish(eventType, eventObject);
        if (currentStep.tracking != null) {
            meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, currentStep.tracking);
            $(".journeyNavButton").removeClass("poke");
        } else {
            $(".journeyNavButton").addClass("poke");
        }
        if (currentStep.externalTracking != null) {
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, currentStep.externalTracking);
        }
    }
    function showSlide(step, animate, callback) {
        $slide = $(settings.slideContainer + " ." + settings.slideClassName + ":eq(" + step.slideIndex + ")");
        if (animate === true) {
            $slide.fadeIn(250, function onShow() {
                $slide.removeClass("hiddenSlide").addClass("active");
                if (callback != null) callback();
            });
        } else {
            $slide.removeClass("hiddenSlide").addClass("active");
            if (callback != null) callback();
        }
    }
    function hideInitialLoader() {
        $(document.body).removeClass("jeinit");
    }
    function getStepIndex(navigationId) {
        for (var i = 0; i < settings.steps.length; i++) {
            var step = settings.steps[i];
            if (step.navigationId == navigationId) {
                return i;
            }
        }
    }
    function getStepsTotalNum() {
        return settings.steps.length;
    }
    function getStep(navigationId) {
        var index = getStepIndex(navigationId);
        if (index == null) return null;
        return settings.steps[index];
    }
    function getCurrentStepIndex() {
        var navId = 0;
        if (currentStep !== null) {
            navId = currentStep.navigationId;
        }
        return getStepIndex(navId);
    }
    function setFurtherestStep() {
        if (_.isNull(furtherestStep) || getStepIndex(furtherestStep.navigationId) < getStepIndex(currentStep.navigationId)) {
            furtherestStep = currentStep;
        }
    }
    function getFurtherestStepIndex() {
        return getStepIndex(furtherestStep.navigationId);
    }
    function getCurrentStep() {
        return currentStep;
    }
    function getPreviousStepId() {
        var previousIndex = 0;
        var currentIndex = getCurrentStepIndex();
        if (currentIndex > 0) {
            previousIndex = --currentIndex;
        }
        return settings.steps[previousIndex].navigationId;
    }
    function validateStep(step, successCallback, failureCallback) {
        var waitForCallback = false;
        if (step.validation != null) {
            if (step.validation.validate === true) {
                var isAlreadyVisible = false;
                if ($("." + settings.slideClassName + ":eq(" + step.slideIndex + "):visible").length > 0) {
                    isAlreadyVisible = true;
                }
                var $slide = $("." + settings.slideClassName + ":eq(" + step.slideIndex + ")");
                $slide.removeClass("hiddenSlide").addClass("active");
                meerkat.modules.form.markFieldsAsVisible($slide);
                var isValid = true;
                $slide.find("form").each(function(index, element) {
                    $element = $(element);
                    var formValid = $element.valid();
                    if (formValid === false) isValid = false;
                });
                if (isAlreadyVisible === false) $slide.removeClass("active").addClass("hiddenSlide");
                if (isValid === false) {
                    if (typeof failureCallback === "function") {
                        failureCallback();
                    }
                    meerkat.messaging.publish(moduleEvents.STEP_VALIDATION_ERROR, step);
                    throw "Validation failed on " + step.navigationId;
                }
            }
            if (step.validation.customValidation != null) {
                waitForCallback = true;
                step.validation.customValidation(function(valid) {
                    if (valid) {
                        successCallback(true);
                    } else {
                        if (typeof failureCallback === "function") {
                            failureCallback();
                        }
                        meerkat.messaging.publish(moduleEvents.STEP_VALIDATION_ERROR, step);
                        throw "Custom validation failed on " + step.navigationId;
                    }
                });
            }
        }
        if (waitForCallback === false) successCallback(true);
        return true;
    }
    function isCurrentStepValid() {
        return $(settings.slideContainer + " ." + settings.slideClassName + ":eq(" + currentStep.slideIndex + ") form").valid();
    }
    function lock() {
        $(settings.slideContainer).attr("data-locked", "1");
    }
    function unlock() {
        $(settings.slideContainer).removeAttr("data-locked");
    }
    function isLocked() {
        return $(settings.slideContainer).attr("data-locked") == "1";
    }
    function onSlideControlClick(eventObject) {
        var $target = $(eventObject.currentTarget);
        if ($target.is(".disabled, :disabled")) return false;
        eventObject.preventDefault();
        gotoPath($target.attr("data-slide-control"), $target);
    }
    function gotoPath(path, $target) {
        if (typeof $target !== "undefined" && $target.hasClass("show-loading")) {
            var spinnerPos = $target.attr("data-loadinganimation");
            if (!_.isUndefined(spinnerPos) && !_.isEmpty(spinnerPos)) {
                if (spinnerPos === "inside") {
                    meerkat.modules.loadingAnimation.showInside($target);
                } else {
                    meerkat.modules.loadingAnimation.showAfter($target);
                }
            } else {
                meerkat.modules.loadingAnimation.showAfter($target);
            }
        }
        try {
            if (isLocked()) {
                throw "Journey engine action in progress (isLocked)";
            } else {
                lock();
            }
            var navigationId = path;
            if (currentStep !== null && currentStep.navigationId !== navigationId) {
                var direction;
                if (navigationId == "next" || navigationId == "previous") {
                    var currentStepIndex = getStepIndex(currentStep.navigationId);
                    var newStepIndex = null;
                    if (navigationId == "next") {
                        direction = "forward";
                        newStepIndex = currentStepIndex + 1;
                        if (newStepIndex >= settings.steps.length) {
                            throw "No next steps";
                        }
                    } else {
                        direction = "backward";
                        newStepIndex = currentStepIndex - 1;
                        if (newStepIndex < 0) {
                            throw "No previous steps";
                        }
                    }
                    navigationId = settings.steps[newStepIndex].navigationId;
                    if (typeof settings.steps[newStepIndex].additionalHashInfo === "function") {
                        navigationId += "/" + settings.steps[newStepIndex].additionalHashInfo();
                    }
                }
                if (getStepIndex(navigationId) == getStepIndex(currentStep.navigationId) + 1 && direction == "forward") {
                    validateStep(currentStep, function() {
                        $(settings.slideContainer).attr("data-prevalidation-completed", "1");
                        meerkat.modules.address.setHash(navigationId);
                        if (typeof $target !== "undefined") meerkat.modules.loadingAnimation.hide($target);
                    }, logValidationErrors);
                } else {
                    meerkat.modules.address.setHash(navigationId);
                    if (typeof $target !== "undefined") meerkat.modules.loadingAnimation.hide($target);
                }
            }
        } catch (e) {
            unlock();
            meerkat.logging.info("[journeyEngineListener]", e);
            if (typeof $target !== "undefined") meerkat.modules.loadingAnimation.hide($target);
        }
    }
    function getValue($el) {
        if ($el.attr("type") == "radio" || $el.attr("type") == "checkbox") {
            return $("input[name=" + $el.attr("name") + "]:checked").val() || "";
        }
        return $el.val();
    }
    function logValidationErrors() {
        var data = [], i = 0;
        data.push({
            name: "stepId",
            value: meerkat.modules.journeyEngine.getCurrentStep().navigationId
        });
        data.push({
            name: "hasPrivacyOptin",
            value: meerkat.modules.optIn.isPrivacyOptedIn()
        });
        $(".error-field:visible", ".journeyEngineSlide.active").each(function() {
            var $label = $(this).find("label"), xpath = $label.attr("for");
            if (typeof xpath === "undefined") {
                return;
            }
            data.push({
                name: xpath,
                value: getValue($(":input[name=" + xpath + "]")) + "::" + $label.text()
            });
            i++;
        });
        if (i === 0) {
            return false;
        }
        return meerkat.modules.comms.post({
            url: "logging/validation.json",
            data: data,
            dataType: "json",
            cache: true,
            errorLevel: "silent",
            useDefaultErrorHandling: false
        });
    }
    function initJourneyEngine() {
        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function hashChange(event) {
            if (webappLock === true) {
                meerkat.modules.address.setHash(currentStep.navigationId);
                return;
            }
            onNavigationChange({
                navigationId: event.hashArray[0]
            });
        }, window);
        $(document.body).on("click", "a[data-slide-control]", onSlideControlClick);
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function jeAppLock(event) {
            webappLock = true;
            $("a[data-slide-control]").each(function() {
                $(this).addClass("disabled").addClass("inactive");
            });
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function jeAppUnlock(event) {
            webappLock = false;
            $("a[data-slide-control]").each(function() {
                $(this).removeClass("disabled").removeClass("inactive");
            });
        });
        $(document).on("keydown", function(e) {
            if (e.ctrlKey && e.keyCode == 39) {
                gotoPath("next");
            }
            if (e.ctrlKey && e.keyCode == 37) {
                gotoPath("previous");
            }
        });
        $("#journeyEngineLoading .loading-logo").after(meerkat.modules.loadingAnimation.getTemplate());
    }
    function getFormData() {
        return meerkat.modules.form.getData($("#mainform"));
    }
    function getSerializedFormData() {
        return meerkat.modules.form.getSerializedData($("#mainform"));
    }
    function loadingShow(message, showInstantly) {
        message = message || "Please wait...";
        showInstantly = showInstantly || false;
        var $ele = $("#journeyEngineLoading");
        if ($ele.attr("data-active") !== "1") {
            $ele.attr("data-active", "1");
            $ele.find(".message").attr("data-oldtext", $ele.find(".message").text()).text(message);
            $ele.addClass("displayBlock");
            if (showInstantly) {
                $ele.addClass("opacity1");
            } else {
                _.defer(function() {
                    $ele.addClass("opacity1");
                });
            }
        }
    }
    function loadingHide() {
        var $ele = $("#journeyEngineLoading");
        $ele.attr("data-active", "0");
        $ele.removeClass("opacity1");
        var speed = $ele.transitionDuration();
        _.delay(function() {
            if ($ele.attr("data-active") !== "1") {
                $ele.removeClass("displayBlock");
                $ele.find(".message").text($ele.find(".message").attr("data-oldtext"));
            }
        }, speed);
    }
    function updateCurrentStepHiddenField(step) {
        var verticalCode = meerkat.site.vertical == "car" ? "quote" : meerkat.site.vertical;
        $("#" + verticalCode + "_journey_stage").val(step.navigationId);
    }
    meerkat.modules.register("journeyEngine", {
        init: initJourneyEngine,
        events: events,
        configure: configure,
        getStepIndex: getStepIndex,
        getCurrentStepIndex: getCurrentStepIndex,
        getFurtherestStepIndex: getFurtherestStepIndex,
        getStepsTotalNum: getStepsTotalNum,
        isCurrentStepValid: isCurrentStepValid,
        getFormData: getFormData,
        getSerializedFormData: getSerializedFormData,
        getCurrentStep: getCurrentStep,
        loadingShow: loadingShow,
        loadingHide: loadingHide,
        gotoPath: gotoPath,
        getPreviousStepId: getPreviousStepId,
        sessionCamRecorder: sessionCamRecorder,
        unlockJourney: unlock
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var events = {
        journeyProgressBar: {
            INIT: "PROGRESS_BAR_INITED"
        }
    }, moduleEvents = events.journeyProgressBar;
    var $target = null;
    var progressBarSteps = null;
    var currentStepNavigationId = null;
    var isDisabled = false;
    var isVisible = true;
    function init() {
        $(document).ready(function() {
            $target = $(".journeyProgressBar");
        });
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function jeStepInit(step) {
            currentStepNavigationId = step.navigationId;
            $(document).ready(function() {
                render(true);
            });
        });
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(step) {
            currentStepNavigationId = step.navigationId;
            render(false);
        });
    }
    function configure(progressBarStepsArgument) {
        progressBarSteps = progressBarStepsArgument;
        var progressBarElementWidthPercentage = 99 / progressBarSteps.length;
        $("head").append("<style>.journeyProgressBar>li{ width: " + progressBarElementWidthPercentage + "% }</style>");
    }
    function render(fireEvent) {
        var html = "";
        var openTag = "";
        var closeTag = "";
        var lastIndex = _.isArray(progressBarSteps) ? progressBarSteps.length - 1 : 0;
        var className = null;
        var tabindex = null;
        var foundCurrent = false;
        var isCurrentStep = false;
        if (isVisible) {
            $target.removeClass("invisible");
        } else {
            $target.addClass("invisible");
        }
        _.each(progressBarSteps, function(progressBarStep, index) {
            className = "";
            tabindex = "";
            isCurrentStep = currentStepNavigationId === progressBarStep.navigationId || _.indexOf(progressBarStep.matchAdditionalSteps, currentStepNavigationId) != -1;
            if (isCurrentStep) {
                className = ' class="current"';
                foundCurrent = true;
            } else {
                if (foundCurrent) {
                    tabindex = ' tabindex="-1"';
                } else {
                    className = ' class="complete"';
                }
            }
            if (isDisabled || isCurrentStep || foundCurrent) {
                openTag = closeTag = "div";
            } else {
                openTag = 'a href="javascript:;"' + tabindex + ' data-slide-control="' + progressBarStep.navigationId + '"';
                closeTag = "a";
            }
            html += "<li" + className + "><" + openTag + ">" + progressBarStep.label + "</" + closeTag + "></li>";
            if (index == lastIndex) {
                className = "";
                if (currentStepNavigationId == "complete") {
                    className = " complete";
                }
                html += '<li class="end' + className + '"><div></div></li>';
            }
        });
        $target.html(html);
        if (fireEvent) {
            meerkat.messaging.publish(moduleEvents.INIT);
        }
    }
    function showSteps() {
        return progressBarSteps;
    }
    function checkLabel(labelToCheck) {
        _.each(progressBarSteps, function(progressBarStep, index) {
            if (progressBarStep.label === labelToCheck) {
                return true;
            }
        });
    }
    function addAdditionalStep(labelToCheck, navigationId) {
        _.each(progressBarSteps, function(progressBarStep, index) {
            if (progressBarStep.label === labelToCheck) {
                progressBarStep.matchAdditionalSteps = [ navigationId ];
            }
        });
    }
    function setComplete() {
        currentStepNavigationId = "complete";
        $target.addClass("complete");
        render();
    }
    function enable() {
        isDisabled = false;
        render();
    }
    function disable() {
        isDisabled = true;
        render();
    }
    function show() {
        isVisible = true;
        render();
    }
    function hide() {
        isVisible = false;
        render();
    }
    meerkat.modules.register("journeyProgressBar", {
        init: init,
        render: render,
        events: events,
        configure: configure,
        disable: disable,
        enable: enable,
        show: show,
        hide: hide,
        setComplete: setComplete,
        showSteps: showSteps,
        checkLabel: checkLabel,
        addAdditionalStep: addAdditionalStep
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var $component, _formId = "", _prevId = "";
    function setFormId(newFormId) {
        if (isKampyleEnabled() === false) return;
        if (newFormId === _formId) {
            return;
        }
        $component.html(replaceFormId($component.html(), newFormId));
        _prevId = _formId;
        _formId = newFormId;
    }
    function revertId() {
        if (isKampyleEnabled() === false) return;
        if (_prevId !== "" && _prevId !== _formId) {
            $component.html(replaceFormId($component.html(), _prevId));
            _formId = _prevId;
            _prevId = "";
        }
    }
    function replaceFormId(str, newFormId) {
        if (isKampyleEnabled() === false) return;
        var r = new RegExp(_formId, "g");
        return str.replace(r, newFormId);
    }
    function updateTransId() {
        if (isKampyleEnabled() === false) return;
        var transId = 0;
        try {
            if (typeof meerkat !== "undefined") {
                transId = meerkat.modules.transactionId.get();
            } else if (typeof Track !== "undefined" && Track._getTransactionId) {
                transId = Track._getTransactionId();
            }
        } catch (err) {}
        k_button.setCustomVariable(7891, transId);
    }
    function init() {
        $(document).ready(function() {
            $component = $("#kampyle");
            if (isKampyleEnabled() === false) return;
            $component.prependTo($("#footer .container"));
            if ($component.attr("data-kampyle-formid")) {
                _formId = $component.attr("data-kampyle-formid");
            }
            $component.on("click", "#kampylink", function kampyleLink(event) {
                updateTransId();
                if (typeof k_button !== "undefined") {
                    event.preventDefault();
                    k_button.open_ff("site_code=7343362&lang=en&form_id=" + _formId);
                }
                meerkat.modules.writeQuote.write({
                    triggeredsave: "kampyle"
                });
            });
        });
    }
    function isKampyleEnabled() {
        if ($component.length === 0) {
            return false;
        }
        return true;
    }
    meerkat.modules.register("kampyle", {
        init: init,
        setFormId: setFormId
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, events = {};
    function init() {}
    function generate(data, settings) {
        settings = settings || {};
        var request_obj = {
            url: "leadfeed/" + data.vertical + "/getacall.json",
            data: data,
            dataType: "json",
            cache: false,
            useDefaultErrorHandling: false,
            numberOfAttempts: 3,
            errorLevel: "silent"
        };
        if (!_.isObject(settings) && !_.isEmpty(settings)) {
            request_obj = $.extend(request_obj, settings);
        }
        meerkat.modules.comms.post(request_obj);
    }
    meerkat.modules.register("leadFeed", {
        init: init,
        events: events,
        generate: generate
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        leavePageWarning: {}
    }, moduleEvents = events.leavePageWarning;
    var safeToLeave = true;
    function initLeavePageWarning() {
        var supportsUnload = !meerkat.modules.performanceProfiling.isIos() && !meerkat.modules.performanceProfiling.isIE8() && !meerkat.modules.performanceProfiling.isIE9() && !meerkat.modules.performanceProfiling.isIE10();
        $(document).ready(function() {
            safeToLeave = meerkat.site.vertical === "generic" || meerkat.site.pageAction == "confirmation" ? true : false;
            if (supportsUnload === false && $("#js-logo-link").length) {
                $("#js-logo-link").on("click", function(e) {
                    meerkat.modules.leavePageWarning.disable();
                    if (!confirm(fetchMessage())) {
                        return false;
                    }
                });
            }
        });
        if (meerkat.site.leavePageWarning.enabled && meerkat.site.isCallCentreUser === false && supportsUnload === true) {
            window.onbeforeunload = function() {
                if (safeToLeave === false) {
                    return fetchMessage();
                } else {
                    return;
                }
            };
            meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(step) {
                safeToLeave = false;
            });
            meerkat.messaging.subscribe(meerkatEvents.saveQuote.QUOTE_SAVED, function quoteSaved() {
                safeToLeave = true;
            });
        }
    }
    function fetchMessage() {
        if (meerkat.modules.saveQuote.isAvailable() === true) {
            return meerkat.site.leavePageWarning.message;
        } else {
            if (typeof meerkat.site.leavePageWarning.defaultMessage !== "undefined") {
                return meerkat.site.leavePageWarning.defaultMessage;
            }
            return;
        }
    }
    function disable() {
        safeToLeave = true;
    }
    meerkat.modules.register("leavePageWarning", {
        init: initLeavePageWarning,
        events: events,
        disable: disable
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    function hide($elements) {
        $elements.each(function() {
            var $element = $(this);
            var attr = $element.attr("data-loadinganimation");
            if (attr === "after") {
                $element.next(".spinner").hide();
            } else {
                $element.find(".spinner").hide();
            }
        });
        return $elements.find(".spinner");
    }
    function showAfter($elements) {
        $elements.each(function() {
            var $element = $(this);
            var $spinner = $element.next(".spinner");
            if ($spinner.length > 0) {
                $spinner.show();
            } else {
                $element.attr("data-loadinganimation", "after");
                $element.after(getTemplate());
            }
        });
        return $elements.find(".spinner");
    }
    function showInside($elements, showAtEnd) {
        $elements.each(function() {
            var $element = $(this);
            var $spinner = $element.find(".spinner");
            if ($spinner.length > 0) {
                $spinner.show();
            } else {
                $element.attr("data-loadinganimation", "inside");
                if (showAtEnd === true) {
                    $element.append(getTemplate());
                } else {
                    $element.prepend(getTemplate());
                }
            }
        });
        return $elements.find(".spinner");
    }
    function getTemplate() {
        return '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>';
    }
    meerkat.modules.register("loadingAnimation", {
        hide: hide,
        showAfter: showAfter,
        showInside: showInside,
        getTemplate: getTemplate
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    function init() {
        $(document).ready(support);
    }
    function support() {
        $logo = $("html.lt-ie9 #logo");
        if ($logo.length) {
            var url = $logo.css("background-image").slice(5, -2);
            var brand = $logo.text();
            $logo.css("background-image", "none");
            $img = $("<img/>", {
                src: url,
                alt: brand
            }).attr("style", "width:100%;height:100%");
            $logo.empty().append($img);
        }
    }
    meerkat.modules.register("logoIE8", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {}, moduleEvents = events;
    var emailDomains = null, secondLevelDomains = null, $emailField = null, $attemptsField = null, $selectionsField = null, $outputField = null, lastEmailEntered = null;
    function init() {
        $(document).ready(function() {
            var $dataField = $("#mailCheckData");
            if ($dataField.length) {
                var data = JSON.parse($dataField.val());
                emailDomains = data.emailDomains;
                secondLevelDomains = [];
                for (var i = 0; i < emailDomains.length; i++) {
                    secondLevelDomains.push(emailDomains[i].split(".")[0]);
                }
                $emailField = $(data.emailField);
                $attemptsField = $(data.attemptsField);
                $selectionsField = $(data.selectionsField);
                $outputField = $(data.outputField);
                addListener();
            }
        });
    }
    var levenshteinDistance = function(s, t) {
        if (!s || !t) {
            return 99;
        }
        var m = s.length;
        var n = t.length;
        var d = [];
        for (var i = 0; i <= m; i++) {
            d[i] = [];
            d[i][0] = i;
        }
        for (var j = 0; j <= n; j++) {
            d[0][j] = j;
        }
        var cost = 0;
        for (j = 1; j <= n; j++) {
            for (i = 1; i <= m; i++) {
                cost = s.charAt(i - 1) == t.charAt(j - 1) ? 0 : 1;
                d[i][j] = Math.min(d[i][j - 1] + 1, Math.min(d[i - 1][j] + 1, d[i - 1][j - 1] + cost));
            }
        }
        return d[m][n];
    };
    var addListener = function() {
        $emailField.on("blur", function(event) {
            var email = $(this).val();
            $(this).mailcheck({
                domains: emailDomains,
                secondLevelDomains: secondLevelDomains,
                topLevelDomains: null,
                distanceFunction: levenshteinDistance,
                suggested: function(element, suggestion) {
                    if (!_.isEmpty(email) && email != lastEmailEntered) {
                        lastEmailEntered = email;
                        appendEmailTo($attemptsField, email);
                    }
                    $link = $("<a/>", {
                        title: "use " + suggestion.full + " instead?",
                        text: suggestion.full
                    });
                    $link.on("click", _.bind(useSuggestion, this, suggestion.full));
                    $outputField.empty().append("Did you mean ").append($link).append("&nbsp;?");
                },
                empty: function(element) {
                    $outputField.empty();
                }
            });
        });
    };
    var useSuggestion = function(suggestion) {
        appendEmailTo($selectionsField, suggestion);
        $emailField.val(suggestion).trigger("blur");
    };
    var appendEmailTo = function($field, email) {
        var emails = $field.val();
        emails = _.isEmpty(emails) ? email : emails + "," + email;
        $field.val(emails);
    };
    meerkat.modules.register("mailCheck", {
        init: init,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        moreInfo: {
            bridgingPage: {
                CHANGE: "BRIDGINGPAGE_CHANGE",
                SHOW: "BRIDGINGPAGE_SHOW",
                HIDE: "BRIDGINGPAGE_HIDE"
            }
        }
    }, moduleEvents = events.moreInfo;
    var product, htmlTemplate, isModalOpen = false, isBridgingPageOpen = false, modalId, jsonResult, defaults = {
        container: $(".bridgingContainer"),
        template: $("#more-info-template").html(),
        hideAction: "slideUp",
        showAction: "slideDown",
        modalOptions: false,
        runDisplayMethod: null,
        onBeforeShowBridgingPage: null,
        onBeforeShowTemplate: null,
        onBeforeShowModal: null,
        onAfterShowTemplate: null,
        onAfterShowModal: null,
        onBeforeHideTemplate: null,
        onAfterHideTemplate: null,
        onBeforeApply: null,
        onClickApplyNow: null,
        onApplySuccess: null,
        retrieveExternalCopy: null,
        additionalTrackingData: null,
        onBreakpointChangeCallback: null
    }, settings = {}, visibleBodyClass = "moreInfoVisible";
    function initMoreInfo(options) {
        settings = $.extend({}, defaults, options);
        if (meerkat.site.pageAction === "confirmation") return false;
        jQuery(document).ready(function($) {
            if (typeof settings.template != "undefined") {
                htmlTemplate = _.template(settings.template);
                applyEventListeners();
                eventSubscriptions();
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, onBreakpointChange);
    }
    function applyEventListeners() {
        if (typeof Results.settings !== "undefined") {
            $(Results.settings.elements.page).on("click", ".btn-more-info", openBridgingPage);
            $(Results.settings.elements.page).on("click", ".btn-close-more-info", closeBridgingPage);
        }
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            closeBridgingPage();
        });
        $(document.body).on("click", ".btn-more-info-apply", function applyClick(event) {
            event.preventDefault();
            var $this = $(this);
            $this.addClass("inactive").addClass("disabled");
            meerkat.modules.loadingAnimation.showInside($this, true);
            if (typeof settings.onBeforeApply == "function") {
                settings.onBeforeApply();
            }
            Results.setSelectedProduct($this.attr("data-productId"));
            var product = Results.getSelectedProduct();
            if (product) {
                if (typeof settings.onClickApplyNow == "function") {
                    return settings.onClickApplyNow(product, applyCallback);
                }
            } else {
                applyCallback(false);
                return false;
            }
        });
        $(document.body).on("click", ".dialogPop", function promoConditionsLinksClick() {
            meerkat.modules.dialogs.show({
                title: $(this).attr("title"),
                htmlContent: $(this).attr("data-content")
            });
        });
        $(document.body).on("click", ".more-info", function moreInfoLinkClick(event) {
            setProduct(meerkat.modules.carResults.getSelectedProduct());
            openModal();
        });
    }
    function eventSubscriptions() {
        $(document).on("resultPageChange", function() {
            if (isBridgingPageOpen) {
                closeBridgingPage();
            }
        });
    }
    function openBridgingPage(event) {
        var $this = $(this);
        if (typeof $this.attr("data-productId") === "undefined") return;
        if (typeof $this.attr("data-available") !== "undefined" && $this.attr("data-available") !== "Y") return;
        if (typeof settings.onBeforeShowBridgingPage == "function") {
            settings.onBeforeShowBridgingPage();
        }
        var productId = $this.attr("data-productId"), showApply = $this.hasClass("more-info-showapply");
        setProduct(Results.getResult("productId", productId), showApply);
        settings.runDisplayMethod(productId);
        meerkat.modules.sessionCamHelper.setMoreInfoModal();
    }
    function showTemplate(moreInfoContainer) {
        toggleBodyClass(true);
        moreInfoContainer.html(meerkat.modules.loadingAnimation.getTemplate()).show();
        prepareProduct(function moreInfoShowSuccess() {
            var htmlString = htmlTemplate(product);
            moreInfoContainer.find(".spinner").fadeOut();
            moreInfoContainer.html(htmlString);
            if (typeof settings.onBeforeShowTemplate == "function") {
                settings.onBeforeShowTemplate(jsonResult);
            }
            var animDuration = 400;
            var scrollToTopDuration = 250;
            var totalDuration = 0;
            if (isBridgingPageOpen) {
                moreInfoContainer.find(".more-info-content")[settings.showAction](animDuration, function() {
                    if (typeof settings.onAfterShowTemplate == "function") {
                        settings.onAfterShowTemplate();
                    }
                });
                totalDuration = animDuration;
            } else {
                meerkat.modules.utils.scrollPageTo(".resultsHeadersBg", scrollToTopDuration, -$("#navbar-main").height(), function() {
                    if (typeof updatePosition == "function") {
                        updatePosition();
                        moreInfoContainer.css({
                            top: topPosition
                        });
                    }
                    moreInfoContainer.find(".more-info-content")[settings.showAction](animDuration, showTemplateCallback);
                    isBridgingPageOpen = true;
                    if (typeof settings.onAfterShowTemplate == "function") {
                        settings.onAfterShowTemplate();
                    }
                });
                totalDuration = animDuration + scrollToTopDuration;
            }
            _.delay(function() {
                meerkat.messaging.publish(moduleEvents.bridgingPage.SHOW, {
                    isOpen: isBridgingPageOpen
                });
            }, totalDuration);
            var trackData = {
                productID: product.productId
            };
            if (settings.additionalTrackingData !== null && typeof settings.additionalTrackingData === "object") {
                trackData = $.extend({}, trackData, settings.additionalTrackingData);
            }
            if (product.hasOwnProperty("brandCode")) {
                trackData.productBrandCode = product.brandCode;
            }
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackProductView",
                object: trackData
            });
            meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
                touchType: "H",
                touchComment: "MoreInfo"
            });
            meerkat.modules.session.poke();
        });
    }
    function showModal() {
        prepareProduct(function moreInfoShowModalSuccess() {
            toggleBodyClass(true);
            var options = {
                htmlContent: htmlTemplate(product),
                hashId: "moreinfo",
                closeOnHashChange: true
            };
            if (typeof settings.onBeforeShowModal == "function") {
                options.onOpen = function(dialogId) {
                    settings.onBeforeShowModal(jsonResult);
                };
            }
            if (typeof settings.modalOptions == "object") {
                options = $.extend(options, settings.modalOptions);
            }
            modalId = meerkat.modules.dialogs.show(options);
            isModalOpen = true;
            $(".bridgingContainer, .more-info-content").show();
            if (typeof settings.onAfterShowModal == "function") {
                settings.onAfterShowModal();
            }
            _.delay(function() {
                meerkat.messaging.publish(moduleEvents.bridgingPage.SHOW, {
                    isOpen: isModalOpen
                });
            }, 0);
            var trackData = {
                productID: product.productId
            };
            if (settings.additionalTrackingData !== null && typeof settings.additionalTrackingData === "object") {
                trackData = $.extend({}, trackData, settings.additionalTrackingData);
            }
            if (product.hasOwnProperty("brandCode")) {
                trackData.productBrandCode = product.brandCode;
            }
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackProductView",
                object: trackData
            });
            meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
                touchType: "H",
                touchComment: "MoreInfo"
            });
        });
    }
    function closeBridgingPage() {
        if (isModalOpen) {
            hideModal();
            meerkat.modules.address.removeFromHash("moreinfo");
            meerkat.modules.sessionCamHelper.setResultsShownPage();
        }
        if (isBridgingPageOpen) {
            hideTemplate(settings.container);
            meerkat.modules.address.removeFromHash("moreinfo");
            meerkat.modules.sessionCamHelper.setResultsShownPage();
        }
    }
    function hideTemplate(moreInfoContainer) {
        if (typeof settings.onBeforeHideTemplate == "function") {
            settings.onBeforeHideTemplate();
        }
        moreInfoContainer[settings.hideAction](400, function() {
            toggleBodyClass(false);
            hideTemplateCallback(moreInfoContainer);
            if (typeof settings.onAfterHideTemplate == "function") {
                settings.onAfterHideTemplate();
            }
        });
    }
    function hideModal() {
        $("#" + modalId).modal("hide");
        $(".bridgingContainer, .more-info-content").hide(function() {
            toggleBodyClass(false);
        });
        isModalOpen = false;
    }
    function showTemplateCallback() {
        meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {
            isOpen: true
        });
    }
    function hideTemplateCallback(moreInfoContainer) {
        moreInfoContainer.empty().hide();
        isBridgingPageOpen = false;
        meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {
            isOpen: isBridgingPageOpen
        });
        meerkat.messaging.publish(moduleEvents.bridgingPage.HIDE, {
            isOpen: isBridgingPageOpen
        });
    }
    function setProduct(productToParse, showApply) {
        if (typeof productToParse !== "undefined" && typeof productToParse.productId !== "undefined") {
            Results.setSelectedProduct(productToParse.productId);
        }
        product = productToParse;
        if (product !== false) {
            if (showApply === true) {
                product.showApply = true;
            } else {
                product.showApply = false;
            }
        }
        return product;
    }
    function getOpenProduct() {
        if (isBridgingPageOpen === false && isModalOpen === false) return null;
        return product;
    }
    function prepareProduct(successCallback) {
        if (typeof settings.prepareCover == "function") {
            settings.prepareCover();
        }
        prepareExternalCopy(successCallback);
    }
    function prepareExternalCopy(successCallback) {
        $.when(settings.retrieveExternalCopy(product)).then(successCallback);
    }
    function applyCallback(success) {
        _.delay(function deferApplyCallback() {
            $(".btn-more-info-apply").removeClass("inactive").removeClass("disabled");
            meerkat.modules.loadingAnimation.hide($(".btn-more-info-apply"));
        }, 1e3);
        if (success === true) {
            if (settings.onApplySuccess == "function") {
                settings.onApplySuccess();
            }
        }
    }
    function getisBridgingPageOpen() {
        return isBridgingPageOpen;
    }
    function getisModalOpen() {
        return isModalOpen;
    }
    function setDataResult(result) {
        jsonResult = result;
    }
    function getDataResult() {
        return jsonResult;
    }
    function updateSettings(updatedSettings) {
        if (typeof updatedSettings !== "object") {
            return;
        }
        settings = $.extend(true, {}, settings, updatedSettings);
    }
    function toggleBodyClass(show) {
        show = show || false;
        if (show) {
            $("body").addClass(visibleBodyClass);
        } else {
            $("body").removeClass(visibleBodyClass);
        }
    }
    function onBreakpointChange() {
        if (_.isFunction(settings.onBreakpointChangeCallback)) {
            _.defer(settings.onBreakpointChangeCallback);
        }
    }
    meerkat.modules.register("moreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        open: openBridgingPage,
        close: closeBridgingPage,
        showTemplate: showTemplate,
        hideTemplate: hideTemplate,
        showModal: showModal,
        hideModal: hideModal,
        isBridgingPageOpen: getisBridgingPageOpen,
        isModalOpen: getisModalOpen,
        getOpenProduct: getOpenProduct,
        setProduct: setProduct,
        setDataResult: setDataResult,
        getDataResult: getDataResult,
        applyCallback: applyCallback,
        updateSettings: updateSettings
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    debug = meerkat.logging.debug;
    var events = {
        navMenu: {
            READY: "NAVMENU_READY"
        }
    }, moduleEvents = events.navMenu;
    var $toggleElement, $contentPane, $navMenuRow, $underlayContainer;
    function disable() {
        $toggleElement.addClass("disabled");
    }
    function enable() {
        $toggleElement.removeClass("disabled");
    }
    function open() {
        if ($toggleElement.hasClass("collapsed") === true) {
            $contentPane.addClass("in");
            $navMenuRow.addClass("active");
            $toggleElement.removeClass("collapsed");
            $('<div class="navMenu-backdrop-underlay" />').prependTo($underlayContainer).on("click", close);
        }
    }
    function close() {
        if ($toggleElement.hasClass("collapsed") === false) {
            $contentPane.removeClass("in");
            $navMenuRow.removeClass("active");
            $toggleElement.addClass("collapsed");
            $(".navMenu-backdrop-underlay").remove();
        }
    }
    function toggleNavMenu() {
        if (hasContent()) {
            enable();
        } else {
            disable();
        }
    }
    function hasContent() {
        var count = -1;
        $(".navMenu-contents").find(".navbar-nav").find("li").each(function() {
            if ($(this).css("display") == "block") {
                count++;
            }
            if (count > 0) return;
        });
        return count > 0;
    }
    function initNavmenu() {
        log("[navMenu] Initialised");
        $(document).ready(function domready() {
            $toggleElement = $("[data-toggle=navMenu]");
            $contentPane = $(".navMenu-contents");
            $navMenuRow = $(".navMenu-row");
            $underlayContainer = $(".navMenu-row .navMenu-row-fixed");
            if (meerkat.site.navMenu.type === "offcanvas") {
                $navMenuRow.addClass("navMenu-offcanvas");
                if (meerkat.site.navMenu.direction === "left") {
                    $navMenuRow.addClass("navMenu-left");
                } else {
                    $navMenuRow.addClass("navMenu-right");
                }
            }
            debug("[navMenu] Configured as: " + meerkat.site.navMenu.type + " " + meerkat.site.navMenu.direction);
            $toggleElement.on("click", function() {
                if ($toggleElement.hasClass("disabled") === false) {
                    if ($toggleElement.hasClass("collapsed") === true) {
                        open();
                    } else {
                        close();
                    }
                }
            });
            toggleNavMenu();
        });
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange() {
            meerkat.modules.navMenu.close();
            toggleNavMenu();
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function closeXsMenus() {
            meerkat.modules.navMenu.close();
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function openXsMenus() {
            if ($(".navbar-nav .open").length > 0) {
                meerkat.modules.navMenu.open();
            }
            toggleNavMenu();
        });
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function jeStepInit() {
            toggleNavMenu();
        });
        meerkat.messaging.publish(moduleEvents.READY, this);
    }
    meerkat.modules.register("navMenu", {
        init: initNavmenu,
        events: events,
        close: close,
        open: open,
        enable: enable,
        disable: disable,
        toggleNavMenu: toggleNavMenu
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        optIn: {}
    }, moduleEvents = events.optIn;
    function init() {}
    function isPrivacyOptedIn() {
        var $cBox = $(':input[id$="privacyoptin"]');
        if ($cBox.attr("type") == "checkbox") {
            return $cBox.is(":checked");
        }
        return $cBox.val() === "Y";
    }
    function manageEmailMarketing() {
        meerkat.modules.loadingAnimation.showAfter($(this));
        var emailInfo = {
            data: {
                type: "email",
                value: $(this).val()
            },
            onComplete: function() {
                meerkat.modules.loadingAnimation.hide($(this));
            },
            onSuccess: function(result) {},
            onError: function() {}
        };
        fetch(emailInfo);
    }
    function fetch(infoToCheck) {
        var data = {
            save_email: infoToCheck.data.value,
            vertical: meerkat.site.vertical
        };
        var settings = {
            url: "ajax/json/get_user_exists.jsp",
            data: data,
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            onSuccess: function fetchSuccess(result) {
                if (typeof infoToCheck.onSuccess === "function") infoToCheck.onSuccess(result);
            },
            onError: function fetchError() {
                if (typeof infoToCheck.onError === "function") infoToCheck.onError();
            },
            onComplete: function() {
                if (typeof infoToCheck.onComplete === "function") infoToCheck.onComplete();
            }
        };
        if (infoToCheck.hasOwnProperty("returnAjaxObject")) {
            settings.returnAjaxObject = infoToCheck.returnAjaxObject;
        }
        return meerkat.modules.comms.post(settings);
    }
    meerkat.modules.register("optIn", {
        init: init,
        events: events,
        fetch: fetch,
        isPrivacyOptedIn: isPrivacyOptedIn
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var log = meerkat.logging.info, url = null;
    var defaultSettings = {
        product: null,
        trackHandover: true,
        applyNowCallback: null,
        errorMessage: "An error occurred. Sorry about that!",
        errorDescription: "There is an issue with the handover url.",
        closeBridgingModalDialog: true
    }, moduleEvents = {
        partnerTransfer: {
            TRANSFER_TO_PARTNER: "TRANSFER_TO_PARTNER"
        }
    };
    function buildURL(settings) {
        var product = settings.product, handoverType = product.handoverType && product.handoverType.toLowerCase() === "post" ? "POST" : "GET", brand = settings.brand ? settings.brand : product.provider, msg = settings.msg ? settings.msg : "";
        var tracking = _.omit(settings.tracking, "brandCode");
        tracking.brandXCode = settings.tracking.brandCode;
        tracking = encodeURIComponent(JSON.stringify(tracking));
        try {
            url = "transferring.jsp?transactionId=" + meerkat.modules.transactionId.get() + "&trackCode=" + product.trackCode + "&brand=" + brand + "&msg=" + msg + "&vertical=" + meerkat.site.vertical + "&productId=" + product.productId + "&tracking=" + tracking;
            if (handoverType.toLowerCase() === "post") {
                url += "&handoverType=" + product.handoverType + "&handoverData=" + encodeURIComponent(product.handoverData) + "&handoverURL=" + encodeURIComponent(product.handoverUrl) + "&handoverVar=" + product.handoverVar;
            }
            if (!$.isEmptyObject(settings.extraParams)) {
                $.each(settings.extraParams, function transferExtraParam(key, value) {
                    url += "&" + key + "=" + escape(value);
                });
            }
            return url;
        } catch (e) {
            meerkat.modules.errorHandling.error({
                errorLevel: "warning",
                message: settings.errorMessage,
                page: "partnerTransfer.js:buildURL",
                description: settings.errorDescription,
                data: product
            });
            return null;
        }
    }
    function getQueryStringFromURL(url) {
        var qs = null;
        if (!_.isUndefined(url) && _.isString(url)) {
            var pieces = url.split("?");
            if (pieces.length == 2) {
                qs = pieces[1];
            }
        }
        return qs;
    }
    function addTrackingDataToSettings(settings) {
        var tracking = _.pick(settings, "actionStep", "brandCode", "currentJourney", "lastFieldTouch", "productBrandCode", "productID", "productName", "quoteReferenceNumber", "rootID", "trackingKey", "transactionID", "type", "vertical", "verticalFilter", "handoverQS", "simplesUser"), originatingTab = typeof meerkat.modules.coverLevelTabs === "undefined" ? "default" : meerkat.modules.coverLevelTabs.getOriginatingTab(), departingTab = typeof meerkat.modules.coverLevelTabs === "undefined" ? "default" : meerkat.modules.coverLevelTabs.getDepartingTabJourney();
        meerkat.modules.tracking.updateObjectData(tracking);
        tracking = $.extend({
            actionStep: null,
            brandCode: null,
            currentJourney: null,
            lastFieldTouch: null,
            productBrandCode: settings.product.provider,
            productID: settings.product.productId,
            productName: settings.product.name,
            quoteReferenceNumber: typeof settings.product.leadNo !== "undefined" ? settings.product.leadNo : tracking.transactionID,
            rootID: null,
            transactionID: null,
            type: "ONLINE",
            vertical: null,
            verticalFilter: null,
            originatingTab: originatingTab,
            departingTab: departingTab,
            handOverQS: getQueryStringFromURL(settings.product.quoteUrl),
            simplesUser: meerkat.site.isCallCentreUser
        }, tracking);
        if (_.isEmpty(tracking.actionStep)) {
            tracking.actionStep = $.trim(tracking.vertical + " transfer " + tracking.type);
        }
        return tracking;
    }
    function transferToPartner(options) {
        var settings = $.extend({}, defaultSettings, options), product = settings.product;
        settings.tracking = addTrackingDataToSettings(settings);
        url = buildURL(settings);
        if (url != null) {
            if (settings.closeBridgingModalDialog === true && (meerkat.modules.moreInfo.isBridgingPageOpen() || meerkat.modules.moreInfo.isModalOpen())) {
                meerkat.modules.moreInfo.close();
            }
            if ($("html").hasClass("ie")) {
                var popOptions = "location=1,menubar=1,resizable=1,scrollbars=1,status=1,titlebar=1,toolbar=1,top=0,left=0,height=" + screen.availHeight + ",width=" + screen.availWidth;
                window.open(url, "_blank", popOptions);
            } else {
                window.open(url, "_blank");
            }
            if ($("#transferring-popup").length > 0) {
                $("#transferring-popup").delay(4e3).queue(function(next) {
                    next();
                });
            }
            if (settings.trackHandover === true) {
                trackHandover(settings.tracking, {
                    type: "A",
                    productId: settings.product.productId,
                    comment: "Apply Online"
                });
            }
            if (_.has(settings, "noSaleLead") && !_.isEmpty(settings.noSaleLead)) {
                meerkat.modules.leadFeed.generate(settings.noSaleLead.data, settings.noSaleLead.settings);
            }
            meerkat.messaging.publish(moduleEvents.partnerTransfer.TRANSFER_TO_PARTNER, {
                transactionID: settings.tracking.transactionID,
                partnerID: settings.product.trackCode,
                productDescription: settings.product.productId
            });
        }
        if (typeof settings.applyNowCallback == "function") {
            settings.applyNowCallback(true);
        }
    }
    function trackHandover(trackData, touchData) {
        touchData = touchData || false;
        if (touchData !== false && _.isObject(touchData) && _.has(touchData, "type")) {
            meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
                touchType: touchData.type,
                touchComment: _.has(touchData, "comment") ? touchData.comment : "",
                productId: touchData.productId
            });
        }
        var data = _.pick(trackData, "actionStep", "brandCode", "currentJourney", "departingTab", "lastFieldTouch", "originatingTab", "productBrandCode", "productID", "productName", "quoteReferenceNumber", "rootID", "trackingKey", "transactionID", "type", "vertical", "verticalFilter", "handoverQS", "simplesUser");
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteHandoverClick",
            object: data
        });
        meerkat.modules.session.poke();
    }
    function trackHandoverEvent(trackData, touchData) {
        trackData = addTrackingDataToSettings(trackData || {});
        touchData = touchData || false;
        trackHandover(trackData, touchData);
    }
    function applyEventListeners() {
        $(document.body).on("click", ".btn-apply", function(e) {
            e.preventDefault();
            var product = Results.getResultByProductId($(this).attr("data-productid"));
            var options = {
                product: product
            };
            transferToPartner(options);
        });
    }
    function initTransfer() {
        $(document).ready(function() {
            applyEventListeners();
        });
    }
    meerkat.modules.register("partnerTransfer", {
        initTransfer: initTransfer,
        transferToPartner: transferToPartner,
        trackHandoverEvent: trackHandoverEvent,
        buildURL: buildURL,
        events: moduleEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        paymentGateway: {
            SUCCESS: "PAYMENT_GATEWAY_SUCCESS",
            FAIL: "PAYMENT_GATEWAY_FAIL"
        }
    }, moduleEvents = events.paymentGateway;
    var $launcher;
    var $success;
    var $fail;
    var $registered;
    var calledBack = false, successEventHandlerId = null, failEventHandlerId = null, _type = "";
    var settings = {
        paymentEngine: null,
        name: "",
        handledType: {
            credit: false,
            bank: false
        }
    };
    function hasRegistered() {
        return $registered.val() === "1";
    }
    function resetRegistered() {
        return $registered.val("");
    }
    function success(params) {
        paymentStatusChange();
        $registered.val("1").valid();
        settings.paymentEngine.success(params);
        hideLauncherPanels();
        showSuccessPanel();
    }
    function fail(_msg) {
        showLauncherPanels();
        showFailPanel();
        if (_msg && _msg.length > 0) {
            paymentStatusChange();
            settings.paymentEngine.fail(_msg);
            meerkat.modules.errorHandling.error({
                message: _msg,
                page: "paymentGateway.js",
                description: "meerkat.modules.paymentGateway.fail()",
                errorLevel: "silent",
                data: settings
            });
        }
    }
    function paymentStatusChange() {
        calledBack = true;
        meerkat.modules.dialogs.close(modalId);
    }
    function setTypeFromControl() {
        var type = "cc";
        if (typeof settings.getSelectedPaymentMethod === "function") {
            type = settings.getSelectedPaymentMethod();
        }
        if (_type !== type) {
            resetRegistered();
        }
        if (type == "cc" && settings.handledType.credit || type == "ba" && settings.handledType.bank) {
            _type = type;
        } else {
            _type = "";
        }
        togglePanels();
        return _type !== "";
    }
    function showSuccessPanel() {
        $success.slideDown();
        $fail.slideUp();
    }
    function showFailPanel() {
        $success.slideUp();
        $fail.slideDown();
    }
    function hideStatusesPanels() {
        $success.slideUp();
        $fail.slideUp();
    }
    function showLauncherPanels() {
        $launcher.slideDown();
    }
    function hideLauncherPanels() {
        $launcher.slideUp();
    }
    function togglePanels() {
        if (hasRegistered()) {
            hideLauncherPanels();
            showSuccessPanel();
        } else {
            resetRegistered();
            showLauncherPanels();
            hideStatusesPanels();
        }
        toggleCreditCardFields();
    }
    function toggleCreditCardFields() {
        switch (_type) {
          case "cc":
            $("." + settings.name + "-credit").slideDown();
            $registered.rules("add", {
                required: true,
                messages: {
                    required: "Please register your credit card details"
                }
            });
            break;

          default:
            $("." + settings.name + "-credit").slideUp("", "", function() {
                $(this).hide();
            });
            clearValidation();
        }
    }
    function reset() {
        settings.handledType = {
            credit: false,
            bank: false
        };
        _type = "";
        togglePanels();
        $("body").removeClass(settings.name + "-active");
        clearValidation();
        resetRegistered();
        $('[data-provide="paymentGateway"]').off("click", '[data-gateway="launcher"]', launch);
        $("#update-premium").off("click." + settings.name, setTypeFromControl);
        if (typeof settings.paymentTypeSelector !== "undefined") {
            settings.paymentTypeSelector.trigger("change");
        }
        meerkat.messaging.unsubscribe(moduleEvents.SUCCESS, successEventHandlerId);
        meerkat.messaging.unsubscribe(moduleEvents.FAIL, failEventHandlerId);
    }
    function clearValidation() {
        $registered.rules("remove", "required");
    }
    function init() {}
    function setup(instanceSettings) {
        settings = $.extend({}, settings, instanceSettings);
        $('[data-provide="paymentGateway"]').on("click", '[data-gateway="launcher"]', launch);
        if (settings.paymentEngine == null) {
            return false;
        }
        $launcher = $("." + settings.name + " .launcher");
        $success = $("." + settings.name + " .success");
        $fail = $("." + settings.name + " .fail");
        $registered = $("#" + settings.name + "-registered");
        settings.paymentEngine.setup(settings);
        $("body").addClass(settings.name + "-active");
        $("#update-premium").on("click." + settings.name, setTypeFromControl);
        if (typeof settings.clearValidationSelectors === "object") {
            settings.clearValidationSelectors.on("change", clearValidation);
        }
        successEventHandlerId = meerkat.messaging.subscribe(moduleEvents.SUCCESS, success);
        failEventHandlerId = meerkat.messaging.subscribe(moduleEvents.FAIL, fail);
    }
    function launch() {
        calledBack = false;
        meerkat.modules.tracking.recordSupertag("trackCustomPage", "Payment gateway popup");
        modalId = meerkat.modules.dialogs.show({
            htmlContent: meerkat.modules.loadingAnimation.getTemplate(),
            onOpen: settings.paymentEngine.onOpen,
            onClose: function() {
                if (!calledBack) {
                    fail();
                }
            }
        });
    }
    meerkat.modules.register("paymentGateway", {
        init: init,
        events: events,
        reset: reset,
        setup: setup
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, tests = [], PERFORMANCE = {
        LOW: "low",
        MEDIUM: "medium",
        HIGH: "high"
    };
    var USER_AGENT = navigator.userAgent.toLowerCase();
    function startTest(name) {
        var start = new Date().getTime();
        var obj = {
            name: name,
            startTime: start
        };
        tests.push(obj);
    }
    function endTest(name) {
        var end = new Date().getTime();
        var testObj = _.findWhere(tests, {
            name: name
        });
        if (typeof testObj === "undefined") return null;
        var index = tests.indexOf(testObj);
        tests.splice(index, 1);
        var time = end - testObj.startTime;
        return time;
    }
    function isIos() {
        return !!navigator.platform.match(/iPhone|iPod|iPad/i);
    }
    function isAndroid() {
        return USER_AGENT.indexOf("android") > -1;
    }
    function isChrome() {
        return USER_AGENT.indexOf("chrome") > -1;
    }
    function isOpera() {
        return USER_AGENT.indexOf("opera mini") > -1;
    }
    function isBlackBerry() {
        return USER_AGENT.indexOf("blackBerry") > -1;
    }
    function isWindows() {
        return USER_AGENT.indexOf("iemobile") > -1;
    }
    function isMobile() {
        return isIos() || isAndroid() || isBlackBerry() || isOpera() || isWindows();
    }
    function isFFAffectedByDropdownMenuBug() {
        return USER_AGENT.match(/firefox\/(30|31|32|33|34).*/i);
    }
    function isSafariAffectedByColumnCountBug() {
        return USER_AGENT.match(/(8\.\d+\.?\d?|7\.1|6\.2) safari/i);
    }
    function isIE8() {
        if (getIEVersion() === 8) {
            return true;
        }
        return false;
    }
    function isIE9() {
        if (getIEVersion() === 9) {
            return true;
        }
        return false;
    }
    function isIE10() {
        if (getIEVersion() === 10) {
            return true;
        }
        return false;
    }
    function isIE11() {
        if (getIEVersion() === 11) {
            return true;
        }
        return false;
    }
    function isIos5() {
        if (isIos() && USER_AGENT.match(/os 5/)) {
            return true;
        }
        return false;
    }
    function isIos6() {
        if (isIos() && USER_AGENT.match(/os 6/)) {
            return true;
        }
        return false;
    }
    function isIos7() {
        if (isIos() && USER_AGENT.match(/os 7/)) {
            return true;
        }
        return false;
    }
    function getIEVersion() {
        var ua = USER_AGENT;
        var isIE = ua.indexOf("msie ") > 0 || ua.indexOf("trident") > 0;
        if (isIE) {
            var msieIndex = ua.indexOf("msie");
            if (msieIndex == -1) {
                var version = ua.match(/trident.*rv[ :]*(11|12)\./i);
                return parseInt(version[1]);
            }
            return parseInt(ua.substring(msieIndex + 5, ua.indexOf(".", msieIndex)));
        } else {
            return null;
        }
    }
    meerkat.modules.register("performanceProfiling", {
        PERFORMANCE: PERFORMANCE,
        startTest: startTest,
        endTest: endTest,
        isIos5: isIos5,
        isIos6: isIos6,
        isIos7: isIos7,
        isIos: isIos,
        isAndroid: isAndroid,
        isChrome: isChrome,
        isBlackBerry: isBlackBerry,
        isOpera: isOpera,
        isWindows: isWindows,
        isMobile: isMobile,
        isFFAffectedByDropdownMenuBug: isFFAffectedByDropdownMenuBug,
        isSafariAffectedByColumnCountBug: isSafariAffectedByColumnCountBug,
        isIE8: isIE8,
        isIE9: isIE9,
        isIE10: isIE10,
        isIE11: isIE11,
        getIEVersion: getIEVersion
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info, placeholdersSupported = Modernizr.input.placeholder;
    function initPlaceholderInput() {
        var $this = $(this), placeholder;
        if ($this.data("fakeplaceholder") || $this.is("[type=checkbox]") || $this.is("[type=radio]") || $this.is("[type=hidden]") || $this.is("[type=file]")) {
            return;
        }
        placeholder = $("<div/>", {
            "class": "fakeplaceholder"
        });
        placeholder.height($this.height() - $this.css("padding-bottom").replace("px", "")).css({
            "margin-top": $this.css("margin-top"),
            "margin-bottom": $this.css("margin-bottom"),
            "margin-left": $this.css("margin-left"),
            "margin-right": $this.css("margin-right"),
            "padding-top": $this.css("padding-top"),
            "padding-bottom": $this.css("padding-bottom"),
            "padding-left": $this.css("padding-left"),
            "padding-right": $this.css("padding-right"),
            "font-size": $this.css("font-size"),
            "line-height": $this.css("line-height"),
            color: $this.css("color")
        }).data("for", $this);
        $this.before(placeholder.text($this.attr("placeholder"))).data("fakeplaceholder", placeholder);
        $this.val() && placeholder.hide();
    }
    function initPlaceholders(target) {
        if (placeholdersSupported) {
            return;
        }
        var inputsThatNeedPlaceholders = $(target || document).find("[placeholder]");
        inputsThatNeedPlaceholders.each(initPlaceholderInput);
    }
    function initPlaceholder() {
        if (placeholdersSupported) {
            return;
        }
        initPlaceholders();
        $(document).on("focus.fakeplaceholder", "input[placeholder]", function() {
            var $this = $(this), placeholder = $this.data("fakeplaceholder");
            if (typeof placeholder !== "undefined") {
                placeholder.hide();
            }
        }).on("blur.fakeplaceholder", "input[placeholder]", function() {
            var $this = $(this), placeholder = $this.data("fakeplaceholder");
            !$this.val() && typeof placeholder !== "undefined" && placeholder.show();
        }).on("click.fakeplaceholder", ".fakeplaceholder", function() {
            $(this).data("for").focus();
        });
        log("[Placeholder] Initialised");
    }
    function invalidatePlaceholder($this) {
        placeholder = $this.data("fakeplaceholder");
        if (placeholder && placeholder.length > 0) {
            if ($this.val()) {
                placeholder.hide();
            } else {
                placeholder.show();
            }
        }
    }
    meerkat.modules.register("placeholder", {
        init: initPlaceholder,
        initPlaceholders: initPlaceholders,
        invalidatePlaceholder: invalidatePlaceholder
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, noButtons = document.createElement("button").type === "button";
    function initPolyfills() {
        if (navigator.userAgent.match(/IEMobile\/10\.0/)) {
            var msViewportStyle = document.createElement("style");
            msViewportStyle.appendChild(document.createTextNode("@-ms-viewport{width:auto!important}"));
            document.getElementsByTagName("head")[0].appendChild(msViewportStyle);
        }
        if (noButtons) {
            $(document).on("click", 'form button[type="submit"]', function(event) {
                event.preventDefault();
                $(this).closest("form").submit();
            }).on("keypress", "form input", function(event) {
                if (event.which === 13) {
                    $(this).closest("form").submit();
                }
            });
        }
        $(function() {
            if (typeof FastClick === "undefined") return;
            FastClick.attach(document.body);
        });
    }
    meerkat.modules.register("polyfills", {
        init: initPolyfills
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var log = meerkat.logging.info;
    var defaultSettings = {
        element: null,
        contentType: null,
        contentValue: null,
        showEvent: "click",
        onOpen: function() {},
        onClose: function() {},
        onLoad: function() {}
    };
    function create(instanceSettings) {
        var settings = $.extend({}, defaultSettings, instanceSettings);
        var title = "";
        var htmlContent = null;
        if (settings.contentType == "url") {
            htmlContent = function(event, api) {
                var returnString = meerkat.modules.loadingAnimation.getTemplate();
                meerkat.modules.comms.get({
                    url: settings.contentValue,
                    cache: true,
                    errorLevel: "silent",
                    onSuccess: function popoverSuccess(content) {
                        var html = "";
                        $(content).find("help").each(function() {
                            if (title === "") title = $(this).attr("header");
                            html += $(this).text();
                        });
                        returnString = html;
                        api.set("content.text", html);
                        api.set("content.title", title);
                        api.reposition();
                    },
                    onError: function popoverError() {
                        api.set("content.text", "Apologies. This information did not download successfully.");
                        api.reposition();
                    }
                });
                return returnString;
            };
        } else {
            htmlContent = settings.contentValue;
            title = settings.element.attr("data-title");
        }
        var showEvent = null;
        if (settings.element.attr("data-trigger")) {
            showEvent = settings.element.attr("data-trigger");
        } else {
            showEvent = settings.showEvent;
        }
        var hideEvent = null;
        switch (showEvent) {
          case "mouseenter":
            hideEvent = "mouseleave";
            break;

          case "mouseenter click":
          case "click mouseenter":
            hideEvent = "mouseleave unfocus click";
            break;

          default:
            hideEvent = "unfocus click";
            break;
        }
        settings.element.qtip({
            content: {
                text: htmlContent,
                title: title
            },
            position: settings.position ? settings.position : {
                my: settings.element.attr("data-my") ? settings.element.attr("data-my") : "left center",
                at: settings.element.attr("data-at") ? settings.element.attr("data-at") : "right center",
                effect: false,
                adjust: {
                    method: "flipinvert none",
                    x: settings.element.attr("data-adjust-x") ? parseInt(settings.element.attr("data-adjust-x")) : 0,
                    y: settings.element.attr("data-adjust-y") ? parseInt(settings.element.attr("data-adjust-y")) : 0
                },
                viewport: $(window)
            },
            show: {
                event: showEvent
            },
            hide: {
                event: hideEvent,
                fixed: true,
                delay: 150
            },
            style: settings.style ? settings.style : {
                classes: settings.element.attr("data-class") ? "popover " + settings.element.attr("data-class") : "popover",
                tip: {
                    corner: true,
                    width: 12,
                    height: 6
                }
            }
        });
    }
    function init() {
        meerkat.messaging.subscribe("DYNAMIC_CONTENT_PARSED_POPOVER", function popoverDynamicCreation(event) {
            if (!event.element.attr("data-hasqtip")) {
                create(event);
                event.element.qtip("toggle", true);
            }
        });
    }
    meerkat.modules.register("popovers", {
        init: init,
        create: create
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    function initRadioGroup() {
        $(document).on("change", "[data-toggle^=radio] input", function(e) {
            var $btn, $target = $(e.target);
            $btn = $target.parent().parent().find(".btn");
            $btn.removeClass("active");
            if ($target.is(":checked")) {
                $btn = $target.parent();
                $btn.addClass("active");
            }
        });
        $(document).on("focusin", "[data-toggle^=radio] input", function(e) {
            var $btn = $(e.target).parent().parent().find(".btn");
            $btn.removeClass("focus");
            $btn = $(e.target).parent();
            $btn.addClass("focus");
        });
        $(document).on("focusout", "[data-toggle^=radio] input", function(e) {
            var $btn = $(e.target).parent().parent().find(".btn");
            $btn.removeClass("focus");
        });
    }
    function changeLabelText($radioGroup, positionNumber, newText) {
        if (typeof $radioGroup === "undefined" || $radioGroup.length === 0) return;
        var $label = $radioGroup.find("label:eq(" + positionNumber + ")");
        $label.contents().filter(function() {
            return this.nodeType === 3;
        }).each(function() {
            var pattern = /[a-z0-9]+/i;
            if (this.textContent) {
                if (pattern.test(this.textContent) === false) return;
                this.textContent = newText;
            } else if (this.innerText) {
                if (pattern.test(this.innerText) === false) return;
                this.innerText = newText;
            }
        });
        return $label;
    }
    meerkat.modules.register("radioGroup", {
        init: initRadioGroup,
        changeLabelText: changeLabelText
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, $renderingModeFld;
    function init() {
        if (typeof meerkat.site === "undefined") {
            return;
        }
        if (meerkat.site.pageAction == "confirmation") {
            return;
        }
        var fld = meerkat.site.vertical == "car" ? "quote" : meerkat.site.vertical;
        $renderingModeFld = $("#" + fld + "_renderingMode");
        if (!$renderingModeFld.length) {
            $("#mainform").append('<input type="hidden" name="' + fld + '_renderingMode" id="' + fld + '_renderingMode" class="" value="' + meerkat.modules.deviceMediaState.get() + '" data-autosave="true">');
        } else {
            meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, record);
        }
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.BEFORE_STEP_CHANGED, record);
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_INITIALISED, record);
    }
    function record() {
        $renderingModeFld.val(meerkat.modules.deviceMediaState.get());
    }
    meerkat.modules.register("renderingMode", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = window.meerkat.logging.info;
    var events = {
        resultsHeaderBar: {}
    }, moduleEvents = events.resultsHeaderBar;
    var $resultsHeaderBg, $affixOnScroll, $resultsContainer, navBarHeight, topStartOffset = 0, previousStartOffset = 0, contentAnimating = false, enterXsSubscription, leaveXsSubscription;
    function init() {
        $resultsHeaderBg = $(".resultsHeadersBg");
        $affixOnScroll = $(".affixOnScroll");
        $resultsContainer = $(".resultsContainer");
        navBarHeight = $("#navbar-main").height();
    }
    function setHeaderBarStartOffset(forceUpdate) {
        if (topStartOffset === 0 || forceUpdate) {
            var dynamicTopHeaderContentHeight = 0;
            $(".dynamicTopHeaderContent > *").each(function() {
                if ($(this).hasClass("simplesHidden") && meerkat.site.isCallCentreUser) {
                    return;
                }
                dynamicTopHeaderContentHeight += $(this).height();
            });
            topStartOffset = dynamicTopHeaderContentHeight + $(".header-top .container").height() + $resultsHeaderBg.position().top;
        }
    }
    function isWindowInAffixPosition() {
        if ($(window).scrollTop() >= topStartOffset) return true;
        return false;
    }
    function isWindowInCompactPosition() {
        if ($(window).scrollTop() >= topStartOffset + 5) return true;
        return false;
    }
    function isContentAffixed() {
        return $resultsContainer.hasClass("affixed");
    }
    function isContentCompact() {
        return $resultsContainer.hasClass("affixed-compact");
    }
    function isContentAffixedForPagination() {
        return $resultsContainer.hasClass("affixed-absoluted");
    }
    function onScroll() {
        setHeaderBarStartOffset();
        if (isWindowInAffixPosition() === true) {
            if (isContentAffixed() === false) {
                $affixOnScroll.addClass("affixed");
                $resultsContainer.addClass("affixed-settings");
            }
            if (isWindowInCompactPosition() === true && isContentCompact() === false) {
                $affixOnScroll.addClass("affixed-compact");
                $resultsContainer.find(".result .productSummary").addClass("compressed");
            } else if (isWindowInCompactPosition() === false && isContentCompact() === true) {
                removeCompactClasses();
            }
        } else if (isWindowInAffixPosition() === false && isContentAffixed() === true) {
            removeAffixClasses();
        }
    }
    function removeCompactClasses() {
        $affixOnScroll.removeClass("affixed-compact");
        $resultsContainer.find(".result .productSummary").removeClass("compressed");
    }
    function removeAffixClasses() {
        removeCompactClasses();
        $affixOnScroll.removeClass("affixed");
        $resultsContainer.removeClass("affixed-settings");
    }
    function onAnimationStart() {
        if (isContentAffixed() && contentAnimating === false) {
            contentAnimating = true;
            var top = $(window).scrollTop() + navBarHeight - $resultsContainer.offset().top;
            $resultsContainer.find(".result").css("top", top + "px");
            $resultsContainer.removeClass("affixed");
            $resultsContainer.addClass("affixed-absoluted");
        }
    }
    function onAnimationEnd() {
        if (isContentAffixedForPagination() && contentAnimating === true) {
            contentAnimating = false;
            $resultsContainer.removeClass("affixed-absoluted");
            $resultsContainer.addClass("affixed");
            $resultsContainer.find(".result").css("top", "");
        }
    }
    function refreshHeadersLayout() {
        if (isContentCompact()) {
            $(Results.settings.elements.productHeaders).refreshLayout();
        }
    }
    function enableAffixMode() {
        if (meerkat.modules.deviceMediaState.get() !== "xs") {
            _.defer(function() {
                onScroll();
            });
            $(window).on("scroll.resultsHeaderBar", _.throttle(onScroll, 25));
            enterXsSubscription = meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function() {
                disableAffixMode();
            });
        }
    }
    function disableAffixMode() {
        meerkat.messaging.unsubscribe(enterXsSubscription);
        removeAffixClasses();
        $(window).off("scroll.resultsHeaderBar");
        subscribeToLeaveXs();
    }
    function subscribeToLeaveXs() {
        leaveXsSubscription = meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function() {
            meerkat.messaging.unsubscribe(leaveXsSubscription);
            registerEventListeners();
        });
    }
    function registerEventListeners() {
        if (meerkat.modules.deviceMediaState.get() === "xs") {
            subscribeToLeaveXs();
        } else {
            enableAffixMode();
        }
        $(Results.settings.elements.resultsContainer).off("pagination.instantScroll").on("pagination.instantScroll", refreshHeadersLayout);
        $(Results.settings.elements.resultsContainer).off("pagination.scrolling.start").on("pagination.scrolling.start", onAnimationStart);
        $(Results.settings.elements.resultsContainer).off("pagination.scrolling.end").on("pagination.scrolling.end", onAnimationEnd);
        $(Results.settings.elements.resultsContainer).off("results.view.animation.start").on("results.view.animation.start", onAnimationStart);
        $(Results.settings.elements.resultsContainer).off("results.view.animation.end").on("results.view.animation.end", onAnimationEnd);
        $resultsHeaderBg.prevAll(".simples-dialogue.toggle").off("click.updateHeaderBarOffset").on("click.updateHeaderBarOffset", function() {
            _.delay(function() {
                setHeaderBarStartOffset(true);
            }, 300);
        });
    }
    function removeEventListeners() {
        if (typeof enterXsSubscription !== "undefined") {
            meerkat.messaging.unsubscribe(enterXsSubscription);
        }
        if (typeof leaveXsSubscription !== "undefined") {
            meerkat.messaging.unsubscribe(leaveXsSubscription);
        }
        $(window).off("scroll.resultsHeaderBar");
        $(Results.settings.elements.resultsContainer).off("pagination.instantScroll");
        $(Results.settings.elements.resultsContainer).off("pagination.scrolling.start");
        $(Results.settings.elements.resultsContainer).off("pagination.scrolling.end");
        $(Results.settings.elements.resultsContainer).off("results.view.animation.start");
        $(Results.settings.elements.resultsContainer).off("results.view.animation.end");
    }
    meerkat.modules.register("resultsHeaderBar", {
        init: init,
        registerEventListeners: registerEventListeners,
        removeEventListeners: removeEventListeners,
        enableAffixMode: enableAffixMode,
        disableAffixMode: disableAffixMode
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = window.meerkat.logging.info;
    var events = {
        RESULTS_RANKING_READY: "RESULTS_RANKING_READY",
        RESULTS_INITIALISED: "RESULTS_INITIALISED",
        RESULTS_DATA_READY: "RESULTS_DATA_READY",
        RESULTS_SORTED: "RESULTS_SORTED"
    }, moduleEvents = events;
    var defaultRankingTriggers = [ "RESULTS_DATA_READY", "RESULTS_SORTED" ], trackingProductObject = [];
    function write(trigger) {
        if (!Results.settings.hasOwnProperty("rankings")) {
            return;
        }
        var config = Results.settings.rankings;
        if (!_.isObject(config)) {
            return;
        }
        var sortedAndFiltered = fetchProductsToRank(config.filterUnavailableProducts), rankingData = getWriteRankData(config, sortedAndFiltered);
        if (!rankingData) {
            return;
        }
        buildTrackingDataObject(config, sortedAndFiltered);
        sendQuoteRanking(trigger, rankingData);
        meerkat.messaging.publish(meerkatEvents.RESULTS_RANKING_READY);
    }
    function sendQuoteRanking(trigger, rankingData) {
        log("[resultsRankings] sendWriteRank", {
            trigger: trigger,
            data: rankingData
        });
        if (Results.getFilteredResults().length) {
            meerkat.modules.comms.post({
                url: "ajax/write/quote_ranking.jsp",
                data: rankingData,
                cache: false,
                errorLevel: "silent",
                onError: function onWriteRankingsError(jqXHR, textStatus, errorThrown, settings, resultData) {
                    meerkat.modules.errorHandling.error({
                        message: "Failed to write ranking results.",
                        page: "core:resultsRankings.js:runWriteRank()",
                        errorLevel: "silent",
                        description: "Failed to write ranking results: " + errorThrown,
                        data: {
                            settings: settings,
                            resultsData: resultData
                        }
                    });
                }
            });
        }
    }
    function fetchProductsToRank(includeOnlyFilteredResults) {
        var sortedAndFiltered = [], sorted = Results.getSortedResults(), filtered = Results.getFilteredResults();
        if (includeOnlyFilteredResults === true) {
            for (var i = 0; i < sorted.length; i++) {
                for (var j = 0; j < filtered.length; j++) {
                    if (sorted[i] == filtered[j]) {
                        sortedAndFiltered[sortedAndFiltered.length] = sorted[i];
                    }
                }
            }
        } else {
            sortedAndFiltered = sorted;
        }
        return sortedAndFiltered;
    }
    function getWriteRankData(config, sortedAndFiltered) {
        var rankingData = {
            rootPath: meerkat.site.vertical,
            rankBy: Results.getSortBy() + "-" + Results.getSortDir(),
            rank_count: sortedAndFiltered.length,
            transactionId: meerkat.modules.transactionId.get()
        };
        var method = null;
        if (config.hasOwnProperty("paths") && _.isObject(config.paths)) {
            method = "paths";
        } else if (config.hasOwnProperty("callback") && _.isFunction(config.callback)) {
            method = "callback";
        }
        if (method === null) {
            return null;
        }
        for (var i = 0; i < sortedAndFiltered.length; i++) {
            var productObj = sortedAndFiltered[i];
            switch (method) {
              case "paths":
                for (var p in config.paths) {
                    if (config.paths.hasOwnProperty(p)) {
                        var item = Object.byString(productObj, config.paths[p]);
                        rankingData[p + i] = item;
                    }
                }
                break;

              case "callback":
                var response = config.callback(productObj, i);
                if (_.isObject(response) && !_.isEmpty(response)) {
                    _.extend(rankingData, response);
                }
                break;
            }
        }
        return rankingData;
    }
    function buildTrackingDataObject(config, sortedAndFiltered) {
        trackingProductObject = [];
        var forceNumber = false;
        if (config.hasOwnProperty("forceIdNumeric") && _.isBoolean(config.forceIdNumeric)) {
            forceNumber = config.forceIdNumeric;
        }
        for (var rank = 0, i = 0; i < sortedAndFiltered.length; i++) {
            rank++;
            var productObj = sortedAndFiltered[i];
            if (typeof productObj !== "object") {
                continue;
            }
            var productId = productObj.productId;
            if (forceNumber) {
                productId = String(productId).replace(/\D/g, "");
            }
            data = {
                productID: productId,
                productName: Object.byString(productObj, Results.settings.paths.productName) || null,
                productBrandCode: Object.byString(productObj, Results.settings.paths.productBrandCode) || null,
                ranking: rank,
                available: Object.byString(productObj, Results.settings.paths.availability.product) || "N"
            };
            trackingProductObject.push(data);
        }
    }
    function getTrackingProductObject() {
        return trackingProductObject;
    }
    function resetTrackingProductObject() {
        var config = Results.settings.rankings;
        if (!_.isObject(config)) {
            return;
        }
        var sortedAndFiltered = fetchProductsToRank(true);
        buildTrackingDataObject(config, sortedAndFiltered);
    }
    function registerSubscriptions() {
        var config = Results.settings.rankings;
        if (_.isObject(config)) {
            if (config.hasOwnProperty("paths") && !_.isEmpty(config.paths) || config.hasOwnProperty("callback") && _.isFunction(config.callback)) {
                var triggers = defaultRankingTriggers;
                if (config.hasOwnProperty("triggers") && _.isArray(config.triggers)) {
                    triggers = config.triggers;
                }
                for (var i = 0; i < triggers.length; i++) {
                    if (meerkatEvents.hasOwnProperty(triggers[i])) {
                        meerkat.messaging.subscribe(meerkatEvents[triggers[i]], _.bind(write, this, triggers[i]));
                    }
                }
            }
        }
    }
    function initResultsRankings() {
        var self = this;
        $(document).ready(function() {
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_INITIALISED, registerSubscriptions);
        });
    }
    meerkat.modules.register("resultsRankings", {
        init: initResultsRankings,
        events: moduleEvents,
        write: write,
        getTrackingProductObject: getTrackingProductObject,
        resetTrackingProductObject: resetTrackingProductObject,
        sendQuoteRanking: sendQuoteRanking,
        fetchProductsToRank: fetchProductsToRank,
        getWriteRankData: getWriteRankData
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        resultsTracking: {
            TRACK_QUOTE_RESULTS_LIST: "TRACK_QUOTE_RESULTS_LIST"
        }
    }, moduleEvents = events.resultsTracking;
    var resultsEventMode = "Load";
    function initResultsTracking() {
        if (meerkat.site.vertical === "generic" || meerkat.site.vertical === "") {
            return;
        }
        meerkat.messaging.subscribe(moduleEvents.TRACK_QUOTE_RESULTS_LIST, trackQuoteResultsList);
    }
    function setResultsEventMode(mode) {
        resultsEventMode = mode;
    }
    function getResultsEventMode() {
        return resultsEventMode;
    }
    function getTrackingDisplayMode() {
        var display;
        if (meerkat.modules.compare.isCompareOpen() === true) {
            display = "compare";
        } else {
            display = Results.getDisplayMode();
            display = display.indexOf("f") === 0 ? display.slice(0, -1) : display;
        }
        return display;
    }
    function trackQuoteResultsList(eventObject) {
        log("[trackQuoteResultsList]", eventObject);
        eventObject = eventObject || {};
        var trackingVertical = meerkat.modules.tracking.getTrackingVertical();
        var data = {
            actionStep: trackingVertical + " results",
            display: getTrackingDisplayMode(),
            event: resultsEventMode,
            products: meerkat.modules.resultsRankings.getTrackingProductObject(),
            rankingFilter: typeof meerkat.modules.coverLevelTabs !== "undefined" ? meerkat.modules.coverLevelTabs.getRankingFilter() : "default",
            recordRanking: "Y",
            offeredCouponID: meerkat.modules.coupon.getCurrentCoupon() ? meerkat.modules.coupon.getCurrentCoupon().couponId : null
        };
        if (typeof eventObject.additionalData === "object") {
            data = $.extend({}, data, eventObject.additionalData);
        }
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteResultsList",
            object: data
        });
        if (typeof eventObject.onAfterEventMode === "string") {
            setResultsEventMode(eventObject.onAfterEventMode);
        }
    }
    meerkat.modules.register("resultsTracking", {
        init: initResultsTracking,
        events: events,
        setResultsEventMode: setResultsEventMode,
        getResultsEventMode: getResultsEventMode,
        trackQuoteResultsList: trackQuoteResultsList
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        saveQuote: {
            QUOTE_SAVED: "SAVE_QUOTE_SAVED"
        }
    }, moduleEvents = events.saveQuote;
    var $container = null;
    var $dropdown = null;
    var $form = null;
    var $instructions = null;
    var $email = null;
    var $password = null;
    var $passwordConfirm = null;
    var $marketing = null;
    var $submitButton = null;
    var $passwords = null;
    var $saveQuoteSuccess = null;
    var $saveQuoteFields = null;
    var $callMeBackForm = null;
    var submitButtonClass = ".btn-save-quote";
    var lastEmailChecked = null;
    var emailTypingTimer = null;
    var checkUserAjaxObject = null;
    var userExists = null;
    var saveAjaxObject = null;
    var isConfirmed = false;
    var isEnabled = false;
    function init() {
        jQuery(document).ready(function($) {
            $dropdown = $("#email-quote-dropdown");
            $auxilleryActivator = $("[data-opensavequote=true]");
            $container = $dropdown.find(".dropdown-container");
            $form = $("#email-quote-component");
            $callMeBackForm = $("#callmeback-save-quote-dropdown");
            $instructions = $(".saveQuoteInstructions");
            $email = $("#save_email");
            $password = $("#save_password");
            $passwordConfirm = $("#save_confirm");
            $marketing = $("#save_marketing");
            $submitButton = $(submitButtonClass);
            $passwords = $(".saveQuotePasswords");
            $saveQuoteSuccess = $("#saveQuoteSuccess");
            $saveQuoteFields = $(".saveQuoteFields");
            if (hasVerticalSpecificCopy()) {
                var button_label = meerkat.modules[meerkat.site.vertical + "SaveQuote"].getCopy("buttonLabel");
                if (button_label !== false) {
                    $submitButton.text(button_label);
                }
                var success_copy = meerkat.modules[meerkat.site.vertical + "SaveQuote"].getCopy("saveSuccess");
                if (success_copy !== false) {
                    $saveQuoteSuccess.empty().append(success_copy);
                }
            }
            $email.on("keyup change", emailKeyChange);
            $email.on("blur", function() {
                $(this).val($.trim($(this).val()));
            });
            $passwordConfirm.on("keyup change", passwordConfirmKeyChange);
            $password.on("keyup change", passwordConfirmKeyChange);
            $form.on("click", ".btn-save-quote", save);
            $dropdown.find(".activator").on("click", onOpen);
            $container.on("click", ".btn-cancel", close);
            if ($(".save-quote-openAsModal").length) {
                $(".save-quote-openAsModal").on("click", function(event) {
                    event.preventDefault();
                    if ($(this).hasClass("disabled") || $(this).hasClass("inactive")) {
                        return false;
                    }
                    openAsModal();
                });
            }
            setValidation();
            updateInstructions("init");
            hideMarketingCheckbox();
            meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, disable);
            meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, enable);
        });
        msg.subscribe(meerkat.modules.events.contactDetails.email.FIELD_CHANGED, function(fieldDetails) {
            if ($email.val() === "") {
                $email.val(fieldDetails.$field.val()).trigger("change");
            }
        });
    }
    function hasVerticalSpecificCopy() {
        return !_.isUndefined(meerkat.modules[meerkat.site.vertical + "SaveQuote"]) && meerkat.modules[meerkat.site.vertical + "SaveQuote"].hasOwnProperty("getCopy");
    }
    function onOpen() {
        if (isConfirmed) {
            $callMeBackForm.hide();
            $saveQuoteSuccess.hide();
            $form.show();
            $saveQuoteFields.hide();
        } else {
            $callMeBackForm.hide();
            if ($email.val() !== "" && $submitButton.hasClass("disabled") && !$(".saveQuotePasswords").is(":visible")) {
                $email.trigger("change");
            }
        }
        if ($callMeBackForm.length !== 0) {
            $container.find(".callmeback-feedback").remove();
        }
    }
    function openAsModal() {
        meerkat.modules.dialogs.show({
            hashId: "email-quote",
            closeOnHashChange: true,
            onOpen: function(dialogId) {
                $container.after('<div id="email-quote-placeholder"></div>');
                $container.appendTo($("#" + dialogId + " .modal-body"));
                $container.on("click.modal", ".btn-cancel", function() {
                    $("#" + dialogId).modal("hide");
                });
                onOpen();
            },
            onClose: function(dialogId) {
                var $placeholder = $("#email-quote-placeholder");
                $container.insertAfter($placeholder);
                $placeholder.remove();
            }
        });
    }
    function setValidation() {
        if ($form === null || $form.length === 0) {
            return;
        }
        setupDefaultValidationOnForm($form);
        if ($password.length > 0) {
            $password.rules("add", {
                required: true,
                minlength: 6,
                messages: {
                    required: "Please enter a password",
                    minlength: jQuery.format("Password must be at least {0} characters")
                }
            });
        }
        if ($passwordConfirm.length > 0) {
            $passwordConfirm.rules("add", {
                required: true,
                equalTo: "#" + $password.attr("id"),
                messages: {
                    required: "Please confirm your password",
                    equalTo: jQuery.format("Password and confirmation password must match")
                }
            });
        }
    }
    function emailKeyChange(event) {
        if (event.keyCode == 13 || event.keyCode == 9) {
            emailChanged();
        } else {
            if (lastEmailChecked != $email.val()) {
                disableSubmitButton();
                clearInterval(emailTypingTimer);
                emailTypingTimer = setTimeout(emailChanged, 800);
            } else if ($password.val() !== "" && $password.val() !== "") {
                enableSubmitButton();
            }
        }
    }
    function passwordConfirmKeyChange(event) {
        if ($password.valid() && $passwordConfirm.valid()) {
            enableSubmitButton();
        } else {
            disableSubmitButton();
        }
    }
    function emailChanged() {
        var valid = $email.valid();
        if (valid) {
            checkUserExists();
        }
    }
    function checkUserExists() {
        var emailAddress = $email.val();
        lastEmailChecked = emailAddress;
        if (checkUserAjaxObject && checkUserAjaxObject.state() === "pending") {
            if (typeof checkUserAjaxObject.abort === "function") {
                checkUserAjaxObject.abort();
            }
        }
        disableSubmitButton();
        meerkat.modules.loadingAnimation.showAfter($email);
        var emailInfo = {
            returnAjaxObject: true,
            data: {
                type: "email",
                value: emailAddress
            },
            onComplete: function() {
                enableSubmitButton();
                meerkat.modules.loadingAnimation.hide($email);
            },
            onSuccess: function checkUserExistsSuccess(result) {
                userExists = result.exists;
                if (result.optInMarketing) {
                    hideMarketingCheckbox();
                    $marketing.prop("checked", true);
                } else {
                    showMarketingCheckbox();
                }
                if (!meerkat.site.isCallCentreUser) {
                    if (result.exists) {
                        updateInstructions("clickSubmit");
                        hidePasswords();
                    } else {
                        updateInstructions("createLogin");
                        showPasswords();
                    }
                }
            },
            onError: function checkUserExistsError() {
                userExists = false;
                if (!meerkat.site.isCallCentreUser) {
                    updateInstructions("createLogin");
                    showPasswords();
                }
            }
        };
        checkUserAjaxObject = meerkat.modules.optIn.fetch(emailInfo);
    }
    function updateInstructions(instructionsType) {
        var text = "";
        if (hasVerticalSpecificCopy()) {
            text = meerkat.modules[meerkat.site.vertical + "SaveQuote"].getCopy(instructionsType);
        }
        if (_.isEmpty(text)) {
            switch (instructionsType) {
              case "clickSubmit":
                text = "Enter your email address to retrieve your quote at any time.";
                break;

              case "createLogin":
                text = "Create a login to retrieve your quote at any time.";
                break;

              case "saveAgain":
                text = 'Click \'Save Quote\' to update your saved quote <a href="javascript:;" class="btn btn-save btn-save-quote">Email Quote</a>';
                break;

              case "init":
                if (meerkat.site.isCallCentreUser) {
                    text = "Please enter the email you want the quote sent to.";
                } else {
                    text = "We will check if you have an existing login or help you set one up.";
                }
                break;
            }
        }
        $instructions.html(text);
        if (instructionsType === "saveAgain") {
            $submitButton = $(submitButtonClass);
            $submitButton.html("Save Quote");
        }
    }
    function save() {
        if ($form.valid()) {
            if (saveAjaxObject && saveAjaxObject.state() === "pending") {
                return;
            }
            disableSubmitButton();
            var $mainForm = $("#mainform");
            if ($("#saved_email").length === 0) {
                meerkat.modules.form.appendHiddenField($mainForm, "saved_email", $email.val());
            }
            if ($("#saved_marketing").length === 0) {
                meerkat.modules.form.appendHiddenField($mainForm, "saved_marketing", $marketing.val());
            }
            var dat = [];
            var sendConfirm;
            if ($.inArray(meerkat.site.vertical, [ "home", "car", "ip", "life" ]) !== -1) {
                sendConfirm = "no";
            } else {
                sendConfirm = "yes";
            }
            var quoteForm = meerkat.modules.form.getData($form);
            var jeForm = meerkat.modules.journeyEngine.getFormData();
            dat = quoteForm.concat(jeForm);
            dat.push({
                name: "quoteType",
                value: meerkat.site.vertical
            });
            dat.push({
                name: "vertical",
                value: meerkat.site.vertical
            });
            dat.push({
                name: "sendConfirm",
                value: sendConfirm
            });
            meerkat.modules.loadingAnimation.showAfter($submitButton);
            if (isConfirmed) {
                meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
                    touchType: "S",
                    touchComment: null,
                    includeFormData: true,
                    callback: function saveQuoteTouchSuccess(result) {
                        saveSuccess(result.result.success, result.result.transactionId);
                    }
                });
            } else {
                meerkat.modules.comms.post({
                    url: "ajax/json/save_email_quote.jsp",
                    data: dat,
                    dataType: "json",
                    cache: false,
                    errorLevel: "silent",
                    onSuccess: function saveQuoteSuccess(result) {
                        saveSuccess(result.result === "OK", result.transactionId);
                    },
                    onError: function saveQuoteError() {
                        if (meerkat.site.isCallCentreUser || $password.val() !== "" && $passwordConfirm.val() !== "") {
                            enableSubmitButton();
                        }
                    },
                    onComplete: function() {
                        meerkat.modules.loadingAnimation.hide($submitButton);
                    }
                });
            }
        }
    }
    function saveSuccess(success, transactionId) {
        enableSubmitButton();
        meerkat.modules.loadingAnimation.hide($submitButton);
        if (success) {
            $form.hide();
            $saveQuoteSuccess.fadeIn();
            if ($callMeBackForm.length !== 0 && !isConfirmed && !meerkat.modules.callMeBack.hasCallbackBeenRequested() && !meerkat.site.isCallCentreUser) {
                meerkat.modules.callMeBack.prefillForm($callMeBackForm);
                $callMeBackForm.fadeIn();
            }
            if (!isConfirmed) {
                isConfirmed = true;
                updateInstructions("saveAgain");
                $dropdown.find(".activator span:not([class])").html("Save Quote");
                $auxilleryActivator.find("span:not([class])").html("Save Quote");
            }
            if (typeof transactionId !== "undefined") {
                meerkat.modules.transactionId.set(transactionId);
            }
            if ($.inArray(meerkat.site.vertical, [ "car", "ip", "life", "health", "home" ]) !== -1) {
                var verticalCode = meerkat.site.vertical === "home" ? "Home_Contents" : meerkat.site.vertical;
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteEvent",
                    object: {
                        action: "Save",
                        transactionID: transactionId,
                        vertical: verticalCode,
                        simplesUser: meerkat.site.isCallCentreUser
                    }
                });
            }
            meerkat.messaging.publish(moduleEvents.QUOTE_SAVED);
        } else {}
    }
    function showPasswords() {
        $passwords.slideDown();
    }
    function hidePasswords() {
        $passwords.slideUp();
    }
    function hideMarketingCheckbox() {
        $marketing.parents(".row").first().hide();
    }
    function showMarketingCheckbox() {
        $marketing.parents(".row").first().show();
    }
    function enableSubmitButton() {
        $submitButton.removeClass("disabled");
    }
    function disableSubmitButton() {
        $submitButton.addClass("disabled");
    }
    function enable(obj) {
        $dropdown.children(".activator").removeClass("inactive").removeClass("disabled");
        $auxilleryActivator.find("a").removeClass("inactive").removeClass("disabled");
    }
    function disable(obj) {
        close();
        $dropdown.children(".activator").addClass("inactive").addClass("disabled");
        $auxilleryActivator.find("a").addClass("inactive").addClass("disabled");
    }
    function isAvailable() {
        return $dropdown.is(":visible");
    }
    function close() {
        if ($dropdown.hasClass("open")) {
            $dropdown.find(".activator").dropdown("toggle");
        }
    }
    meerkat.modules.register("saveQuote", {
        init: init,
        events: events,
        close: close,
        enable: enable,
        disable: disable,
        enableSubmitButton: enableSubmitButton,
        disableSubmitButton: disableSubmitButton,
        isAvailable: isAvailable,
        openAsModal: openAsModal
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var $selectObj = $(".select-tags"), selectedTagsListClass = ".selected-tags", fadeSpeed = "fast", optionSelectedIcon = "[selected] ", selectedItems = {};
    function init() {
        $selectObj.each(function initializeSelectTagsObj() {
            var $this = $(this), variableName = $this.data("varname"), list = window[variableName];
            if ($this.is("select")) {
                if (typeof list !== "undefined" && typeof list.options !== "undefined" && _.isArray(list.options) && list.options.length) {
                    _addOptionsToList($this, list.options);
                }
                $this.on("change", function onSelectTagCallback() {
                    _onOptionSelect(this);
                });
            }
            selectedItems[$this.index()] = [ "0000" ];
        });
    }
    function _addOptionsToList($element, options) {
        var optionsHTML = "";
        for (var i = 0; i < options.length; i++) {
            var option = options[i];
            optionsHTML += '<option value="' + option.value + '">' + option.text + "</option>";
        }
        $element.append(optionsHTML);
    }
    function _onOptionSelect(selectElement) {
        var $select = $(selectElement), $selected = $select.find("option:selected"), value = $select.val(), $list = getListElement($select), selectedText = $selected.text(), selectedTextHTML = selectedText;
        if (selectedTextHTML.length > 25) {
            selectedTextHTML = selectedTextHTML.substr(0, 20) + "...";
        }
        selectedTextHTML = "<span>" + selectedTextHTML + "</span>";
        if ($selected.not("[readonly]").length && !isAlreadySelected(value)) {
            $select[0].selectedIndex = 0;
            $select.find('option[value="' + value + '"]').text(optionSelectedIcon + selectedText).attr("disabled", "disabled");
            appendToTagList($list, selectedTextHTML, selectedText, value);
        }
    }
    function isAlreadySelected($list, selectedValue) {
        if (typeof $list == "undefined") {
            return false;
        }
        var index = $list.index();
        if (typeof selectedItems[index] == "undefined") {
            selectedItems[index] = [ "0000" ];
        }
        return selectedItems[index].indexOf(selectedValue) !== -1;
    }
    function appendToTagList($list, selectedTextHTML, selectedText, value) {
        _.defer(function delayTagAppearance() {
            if (typeof selectedItems[$list.index()] == "undefined") {
                selectedItems[$list.index()] = [ "0000" ];
            }
            selectedItems[$list.index()].push(value);
            $list.append($("<li>").html(selectedTextHTML).data("value", value).data("fulltext", selectedText).addClass("selected-tag").hide().append($("<button>").html("&times;").attr("type", "button").addClass("btn").on("click", function onClickRemoveTagCallback() {
                _onRemoveListItem(this);
            }).hover(function onSelectTagHoverIn() {
                $(this).parents("li").addClass("hover");
            }, function onSelectTagHoverOut() {
                $(this).parents("li").removeClass("hover");
            })).fadeIn(fadeSpeed, function() {
                _updateHiddenInputs();
            }));
        });
    }
    function _onRemoveListItem(listItem) {
        var $this = $(listItem), $select = $this.closest(".row").prev(".select-tags-row").find(":input"), $listItem = $this.closest("li"), value = $listItem.data("value"), text = $listItem.data("fulltext");
        if ($select.is("select")) {
            $select.find('option[value="' + value + '"]').text(text).removeAttr("disabled");
        }
        var $list = getListElement($select), index = $list.index();
        if (typeof selectedItems[index] == "undefined") {
            selectedItems[index] = [ "0000" ];
        }
        var selectedItemIndex = selectedItems[index].indexOf(value);
        if (selectedItemIndex != -1) {
            selectedItems[index].splice(selectedItemIndex, 1);
        }
        $listItem.fadeOut(fadeSpeed, function removeTagFadeOutCallback() {
            $(this).remove();
            _updateHiddenInputs();
        });
    }
    function _updateHiddenInputs() {
        $selectObj.each(function updateHiddenInputsCallback() {
            var $this = $(this), $parent = $this.closest(".row"), $list = getListElement($this), $hiddenField = $parent.find(".validate"), selectedTags = [];
            $list.find("li").each(function() {
                selectedTags.push($(this).data("value"));
            });
            $hiddenField.val(selectedTags.join(","));
        });
    }
    function getListElement($el) {
        return $el.closest(".row").next(selectedTagsListClass + "-row").find(selectedTagsListClass);
    }
    function getItemsSelected(index) {
        return selectedItems[index];
    }
    meerkat.modules.register("selectTags", {
        init: init,
        getListElement: getListElement,
        appendToTagList: appendToTagList,
        isAlreadySelected: isAlreadySelected,
        getItemsSelected: getItemsSelected
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, msg = meerkat.messaging;
    var events = {
        sendEmail: {
            REQUEST_SEND: "REQUEST_SEND"
        }
    }, moduleEvents = events.sendEmail;
    var defaultSettings = {
        form: null,
        instructions: null,
        email: null,
        marketing: null,
        submitButton: null,
        emailResultsSuccess: null,
        emailResultsFields: null,
        lastEmailChecked: null,
        emailTypingTimer: null,
        checkUserAjaxObject: null,
        userExists: null,
        isConfirmed: false,
        isEnabled: false,
        emailResultsFailCallback: defaultEmailResultsFail
    };
    function init() {
        msg.subscribe(moduleEvents.REQUEST_SEND, function emailRequestFunction(request) {
            sendEmail(request.instanceSettings);
        });
    }
    function setup(instanceSettings) {
        var settings = $.extend({}, defaultSettings, instanceSettings);
        setValidation(settings);
        hideMarketingCheckbox(settings);
        settings.emailInputOnChangeFunction = function(event) {
            emailKeyChange(event, settings);
        };
        settings.emailInputBlurFunction = function(event) {
            emailKeyChange(event, settings);
            $(this).val($.trim($(this).val()));
        };
        settings.fieldChangedFunction = function(fieldDetails) {
            if (settings.emailInput.val() === "") {
                settings.emailInput.val(fieldDetails.$field.val()).trigger("change");
            }
        };
        settings.emailRequestFunction = function(request) {
            if (settings.identifier === request.instanceSettings.identifier) {
                sendEmail(instanceSettings);
            }
        };
        msg.subscribe(meerkatEvents.contactDetails.email.FIELD_CHANGED, settings.fieldChangedFunction);
        settings.emailInput.on("keyup change", settings.emailInputOnChangeFunction);
        settings.emailInput.on("blur", settings.emailInputBlurFunction);
        return settings;
    }
    function tearDown(settings) {
        settings.emailInput.off("blur", settings.emailInputBlurFunction);
        settings.emailInput.off("keyup change", settings.emailInputOnChangeFunction);
        settings.submitButton.off("click", settings.submitClickButtonFunction);
        msg.unsubscribe(meerkatEvents.contactDetails.email.FIELD_CHANGED, settings.fieldChangedFunction);
    }
    function setValidation(settings) {
        if (settings.form === null || settings.form.length === 0) {
            return false;
        }
        meerkat.modules.validation.setupDefaultValidationOnForm(settings.form);
        return true;
    }
    function emailKeyChange(event, settings) {
        if (event.keyCode == 13 || event.keyCode == 9) {
            emailChanged(settings);
        } else {
            var emailHasChanged = settings.lastEmailChecked != settings.emailInput.val();
            if (emailHasChanged) {
                clearInterval(settings.emailTypingTimer);
                settings.emailTypingTimer = setTimeout(function() {
                    emailChanged(settings);
                }, 800);
            }
        }
    }
    function emailChanged(settings) {
        if (typeof settings.emailInput == "undefined") {
            meerkat.modules.errorHandling.error({
                errorLevel: "info",
                page: "sendEmail.js:emailChanged",
                description: "settings.emailInput is undefined"
            });
            disableSubmitButton(settings);
            tearDown(settings);
        } else {
            var validEmailAddress = true;
            if (settings.form !== null && settings.form.length > 0) {
                validEmailAddress = settings.emailInput.valid();
            }
            var hasCompared = settings.lastEmailChecked != settings.emailInput.val();
            if (validEmailAddress && hasCompared) {
                checkUserExists(settings);
            }
            if (settings.canEnableSubmit(settings)) {
                enableSubmitButton(settings);
            } else {
                disableSubmitButton(settings);
            }
        }
    }
    function showInProgess(settings) {
        disableSubmitButton(settings);
        meerkat.modules.loadingAnimation.showAfter(settings.emailInput);
    }
    function stopInProgess(settings) {
        if (settings.canEnableSubmit(settings)) {
            enableSubmitButton(settings);
        }
        meerkat.modules.loadingAnimation.hide(settings.emailInput);
    }
    function checkUserExists(instanceSettings) {
        if (instanceSettings.checkUserAjaxObject && instanceSettings.checkUserAjaxObject.state() === "pending") {
            if (typeof settings.checkUserAjaxObject.abort === "function") {
                instanceSettings.checkUserAjaxObject.abort();
            }
        }
        if (instanceSettings.lockoutOnCheckUserExists) {
            showInProgess(instanceSettings);
            meerkat.modules.loadingAnimation.showAfter(instanceSettings.emailInput);
        }
        var emailAddress = instanceSettings.emailInput.val();
        instanceSettings.lastEmailChecked = emailAddress;
        instanceSettings.checkUserAjaxObject = meerkat.modules.optIn.fetch({
            returnAjaxObject: true,
            data: {
                type: "email",
                value: emailAddress
            },
            onComplete: function() {
                if (instanceSettings.lockoutOnCheckUserExists) {
                    meerkat.modules.loadingAnimation.hide(instanceSettings.emailInput);
                    if (instanceSettings.canEnableSubmit(instanceSettings)) {
                        stopInProgess(instanceSettings);
                    }
                }
            },
            onSuccess: function checkUserExistsSuccess(result) {
                if (result.optInMarketing) {
                    hideMarketingCheckbox(instanceSettings);
                } else {
                    showMarketingCheckbox(instanceSettings);
                }
            },
            onError: function checkUserExistsError() {
                userExists = false;
                showMarketingCheckbox(instanceSettings);
            }
        });
    }
    function sendEmail(settings) {
        if (settings.isPending) {
            return;
        }
        if (settings.form.valid()) {
            settings.isPending = true;
            var dat = settings.sendEmailDataFunction(settings);
            dat.push({
                name: "vertical",
                value: meerkat.site.vertical
            });
            dat.push({
                name: "email",
                value: settings.emailInput.val()
            });
            showInProgess(settings);
            meerkat.modules.comms.post({
                url: settings.submitUrl,
                data: dat,
                dataType: "json",
                cache: false,
                errorLevel: "warning",
                onSuccess: function emailResultsSuccess(result) {
                    if (typeof result.transactionId !== "undefined" && result.transactionId !== "") {
                        meerkat.modules.transactionId.set(result.transactionId);
                    }
                    if (typeof settings.emailResultsSuccessCallback === "function") {
                        settings.emailResultsSuccessCallback(result, settings);
                    }
                },
                onError: function emailResultsError() {
                    settings.emailResultsFailCallback(settings);
                },
                onComplete: function() {
                    settings.isPending = false;
                    stopInProgess(settings);
                }
            });
        }
    }
    function defaultEmailResultsFail(settings) {
        enableSubmitButton(settings);
    }
    function hideMarketingCheckbox(settings) {
        settings.marketing.parents(".row").first().slideUp();
    }
    function showMarketingCheckbox(settings) {
        settings.marketing.parents(".row").first().slideDown();
    }
    function enableSubmitButton(settings) {
        settings.submitButton.removeClass("disabled");
    }
    function disableSubmitButton(settings) {
        settings.submitButton.addClass("disabled");
    }
    meerkat.modules.register("sendEmail", {
        init: init,
        events: events,
        setup: setup,
        tearDown: tearDown,
        sendEmail: sendEmail,
        emailChanged: emailChanged,
        enableSubmitButton: enableSubmitButton,
        disableSubmitButton: disableSubmitButton,
        checkUserExists: checkUserExists
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var init = function() {};
    var outputValidationErrors = function(options) {
        "use strict";
        handleServerSideValidation(options);
        triggerErrorContainer();
    };
    var handleServerSideValidation = function(options) {
        var matches = null;
        var erroredElements = [];
        for (var i = 0; i < options.validationErrors.length; i++) {
            var error = options.validationErrors[i];
            var partialName = error.elementXpath.replace(/\//g, "_");
            matches = $(":input[name$='" + partialName + "']");
            if (matches.length === 0 && error.elements !== "") {
                var elements = error.elements.split(",");
                for (var x = 0; x < elements.length; x++) {
                    var fieldName = partialName + "_" + $.trim(elements[x]);
                    matches = $('input[name*="' + fieldName + '"]');
                    if (matches.length === 0) matches = $('input[id*="' + fieldName + '"]');
                }
            }
            for (var b = 0; b < matches.length; b++) {
                var element = matches[b];
                erroredElements.push(element);
                var $element = $(element);
                $(element).parent().removeClass("has-success");
                $(element).parent().addClass("has-error");
                var $referenceElement = $element;
                if ($element.attr("data-validation-placement") !== null && $element.attr("data-validation-placement") !== "") {
                    $referenceElement = $($element.attr("data-validation-placement"));
                }
                var parent = $referenceElement.closest(".row-content, .fieldrow_value");
                if (parent.length === 0) parent = $element.parent();
                var errorContainer = parent.children(".error-field");
                var message = "invalid field";
                if (error.message === "ELEMENT REQUIRED") {
                    message = "This field is required.";
                }
                if (errorContainer.length === 0) {
                    parent.prepend('<div class="error-field"></div>');
                    errorContainer = parent.children(".error-field");
                    errorContainer.hide().slideDown(100);
                }
                errorContainer.append(message);
            }
        }
        if (matches.length > 0) {
            if (typeof options.startStage === "undefined") {
                options.startStage = "start";
            }
            meerkat.modules.address.setHash(options.startStage);
        }
    };
    var triggerErrorContainer = function() {
        if (typeof FormElements != "undefined") {
            if (!FormElements.errorContainer.is(":visible") && FormElements.errorContainer.find("li").length > 0) {
                FormElements.rightPanel.addClass("hidden");
                FormElements.errorContainer.show();
                FormElements.errorContainer.find("li").show();
                FormElements.errorContainer.find("li .error").show();
            }
        }
    };
    meerkat.modules.register("serverSideValidationOutput", {
        init: init,
        outputValidationErrors: outputValidationErrors
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var windowTimeout = null, isModalOpen = false, lastClientPoke = 0, deferredPokeTimeout = null, sessionAlertModal = null, countDownInterval = null, ajaxRequestTimeoutCount = 0;
    firstPoke = true;
    function init() {
        if (!meerkat.modules.simplesTickler && meerkat.site.session.firstPokeEnabled) {
            updateTimeout(meerkat.site.session.windowTimeout);
            poke().done(function firstPokeDone(data) {
                firstPoke = false;
                if (data.timeout < 0 && typeof data.bigIP !== "undefined" && data.bigIP !== meerkat.site.session.bigIP) {
                    meerkat.modules.errorHandling.error({
                        errorLevel: "silent",
                        message: "Session poke failed on first load",
                        description: "Session poke failed on first load",
                        page: "session_poke.json",
                        data: {
                            transactionId: meerkat.modules.transactionId.get(),
                            bigIP_onPageLoad: meerkat.site.session.bigIP,
                            bigIP_onFirstSessionPoke: data.bigIP
                        },
                        id: meerkat.modules.transactionId.get()
                    });
                    updateTimeout(meerkat.site.session.windowTimeout);
                }
            });
            $(document).on("click.session", ".poke, .btn:not(.journeyNavButton,.dontPoke), .btn-back, .dropdown-toggle, .btn-pagination", function(e) {
                deferredPoke();
            });
        }
    }
    function poke(check) {
        var ajaxURL = "session_poke.json";
        ajaxURL += check === true ? "?check" : "";
        return meerkat.modules.comms.get({
            url: ajaxURL,
            dataType: "json",
            onSuccess: function onPokeSuccess(data) {
                ajaxRequestTimeoutCount = 0;
                updateTimeout(data.timeout);
            },
            useDefaultErrorHandling: false,
            errorLevel: "silent",
            onError: function onPokeError(obj, txt, errorThrown) {
                if (txt === "timeout" && ajaxRequestTimeoutCount < 3) {
                    setTimeout(function retrySessionPoke() {
                        poke(check);
                        ajaxRequestTimeoutCount++;
                    }, 3e4);
                } else {
                    showModal(false);
                    meerkat.modules.errorHandling.error({
                        errorLevel: "silent",
                        message: "Session poke error",
                        description: "An error occurred with your browsing session, session poke failed to return: " + txt + " " + errorThrown,
                        data: {
                            status: txt,
                            error: errorThrown,
                            transactionId: meerkat.modules.transactionId.get()
                        },
                        id: meerkat.modules.transactionId.get()
                    });
                }
            }
        });
    }
    function check() {
        return poke(true);
    }
    function deferredPoke() {
        if (lastClientPoke <= getClientTimestamp - meerkat.site.session.deferredPokeDuration) {
            poke();
        } else {
            if (!deferredPokeTimeout) deferredPokeTimeout = window.setTimeout(poke, meerkat.site.session.deferredPokeDuration);
        }
    }
    function getClientTimestamp() {
        return parseInt(+new Date());
    }
    function updateTimeout(timeout) {
        if (timeout > 0) {
            lastClientPoke = getClientTimestamp();
            window.clearTimeout(windowTimeout);
            windowTimeout = window.setTimeout(function setTimeoutWindowTimeout() {
                check();
            }, timeout);
            hideModal();
        } else {
            if (!firstPoke) {
                if (isModalOpen) {
                    showModal(false);
                } else {
                    showModal(true);
                }
            }
        }
    }
    function redirect(reload) {
        meerkat.modules.leavePageWarning.disable();
        hideModal();
        meerkat.modules.utils.scrollPageTo("body");
        if (typeof reload === "boolean" && reload) {
            meerkat.modules.journeyEngine.loadingShow("Reloading...");
            window.location.reload();
        } else {
            meerkat.modules.journeyEngine.loadingShow("Redirecting...");
            window.location = meerkat.site.urls.exit;
        }
    }
    function showModal(canRecover) {
        hideModal();
        isModalOpen = true;
        var modalConfig = {
            title: "Hi, are you still there?",
            className: "sessionModalContainer",
            leftBtn: {
                label: ""
            },
            onOpen: function onSessionModalOpen(dialogId) {
                $("#" + dialogId).find(".modal-closebar").remove();
            }
        };
        if (canRecover) {
            var modalCountdownDuration = 180;
            runModalCountdown(modalCountdownDuration);
            modalConfig.htmlContent = [ '<p id="sessionModalCountDown">', getModalCountdownText(modalCountdownDuration), "</p>", "<p>We haven't noticed any activity from you for a while, so we wanted to let you know that your session will automatically time out in 3 minutes.</p>", "<p>If you are still there, great!</p>", '<p>To continue with your session, please click the "Continue" button below.</p>' ].join("");
            modalConfig.buttons = [ {
                label: "Continue",
                className: "btn btn-success",
                closeWindow: true,
                action: poke
            } ];
        } else {
            modalConfig.htmlContent = [ "<p>We didn't see any activity from you for a while, or your connection was interrupted, so we wanted to let you know your session has timed out.</p>" ].join("");
            modalConfig.buttons = [ {
                label: "Reload Page",
                className: "btn btn-success",
                closeWindow: true,
                action: function sessionModalReloadPage() {
                    redirect(true);
                }
            }, {
                label: "Visit " + meerkat.site.name + "'s Home Page",
                className: "btn btn-success",
                closeWindow: true,
                action: redirect
            } ];
        }
        sessionAlertModal = meerkat.modules.dialogs.show(modalConfig);
    }
    function getModalCountdownText(countDownSecs) {
        var minutes = Math.floor(countDownSecs / 60), seconds = ("0" + (countDownSecs - minutes * 60)).slice(-2);
        return minutes + ":" + seconds;
    }
    function runModalCountdown(modalCountdownDuration) {
        var countDownSecs = modalCountdownDuration, countDown = function sessionModalCountDown() {
            $(document).find("#sessionModalCountDown").text(getModalCountdownText(countDownSecs));
            if (countDownSecs <= 0) {
                check().then(function sessionLastBreath(data) {
                    if (data.timeout <= 0) {
                        meerkat.modules.writeQuote.write({
                            triggeredsave: "sessionpop"
                        }, false, function writeQuoteCallback() {
                            window.clearInterval(countDownInterval);
                            redirect();
                        });
                    } else {
                        hideModal();
                    }
                });
            }
            countDownSecs -= 1;
        };
        countDownInterval = window.setInterval(countDown, 1e3);
    }
    function hideModal() {
        window.clearInterval(countDownInterval);
        meerkat.modules.dialogs.close(sessionAlertModal);
        isModalOpen = false;
    }
    meerkat.modules.register("session", {
        init: init,
        poke: poke,
        check: check,
        update: updateTimeout
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {}, moduleEvents = events;
    var skipStepForSessionCam = [ "results" ];
    var activeNavigationId = false;
    var ignoreSetResultsDisplayMode = true;
    var stepCopy = {
        RESULTS_LOADING: "resultsLoading",
        RESULTS_PAGE: "resultsPage",
        MOREINFO_PAGE: "MoreInfo"
    };
    function init() {
        msg.subscribe(ResultsModel.moduleEvents.WEBAPP_LOCK, setResultsLoadingPage);
        msg.subscribe(meerkat.modules.events.RESULTS_RANKING_READY, _.bind(setResultsShownPage, this, 2e3));
        msg.subscribe(ResultsView.moduleEvents.RESULTS_TOGGLE_MODE, onResultsDisplayTypeSet);
        msg.subscribe(meerkat.modules.events.journeyEngine.READY, setInitialPage);
    }
    function addStepToIgnoreList(navigationId) {
        if (_.indexOf(skipStepForSessionCam, navigationId) === -1) {
            skipStepForSessionCam.push(navigationId);
        }
    }
    function updateVirtualPageFromJourneyEngine(step, delay) {
        if (!_.isArray(skipStepForSessionCam) || _.indexOf(skipStepForSessionCam, step.navigationId) === -1) {
            updateVirtualPage(step, delay);
        }
    }
    function updateVirtualPage(step, delay) {
        delay = delay || 1e3;
        if (step.navigationId !== activeNavigationId) {
            activeNavigationId = step.navigationId;
            if (window.sessionCamRecorder) {
                if (window.sessionCamRecorder.createVirtualPageLoad) {
                    setTimeout(function() {
                        log("[sessionCamHelper:createVirtualPageLoad]", step);
                        window.sessionCamRecorder.createVirtualPageLoad(location.pathname + "/" + activeNavigationId);
                    }, delay);
                }
            }
        }
    }
    function setInitialPage() {
        setTimeout(function() {
            updateVirtualPageFromJourneyEngine(meerkat.modules.journeyEngine.getCurrentStep());
        }, 2e3);
    }
    function setResultsLoadingPage(data, delay) {
        data = data || false;
        delay = delay || false;
        if (data !== false && _.has(data, "source") && data.source === "resultsModel") {
            updateVirtualPage({
                navigationId: stepCopy.RESULTS_LOADING
            }, delay);
        }
    }
    function setResultsShownPage(delay) {
        delay = delay || false;
        updateVirtualPage(getResultsStep(), delay);
    }
    function onResultsDisplayTypeSet() {
        if (ignoreSetResultsDisplayMode === false) {
            setResultsShownPage();
        }
        ignoreSetResultsDisplayMode = false;
    }
    function setMoreInfoModal(delay) {
        delay = delay || false;
        updateVirtualPage(getMoreInfoStep(), delay);
    }
    function getResultsStep() {
        return {
            navigationId: stepCopy.RESULTS_PAGE + "-" + Results.getDisplayMode()
        };
    }
    function getMoreInfoStep(suffix) {
        suffix = suffix || false;
        return appendToStep({
            navigationId: stepCopy.MOREINFO_PAGE
        }, suffix);
    }
    function appendToStep(step, suffix) {
        suffix = suffix || false;
        if (suffix !== false && !_.isEmpty(suffix)) {
            step.navigationId += "-" + suffix;
        }
        return step;
    }
    meerkat.modules.register("sessionCamHelper", {
        init: init,
        events: events,
        updateVirtualPage: updateVirtualPage,
        updateVirtualPageFromJourneyEngine: updateVirtualPageFromJourneyEngine,
        addStepToIgnoreList: addStepToIgnoreList,
        setResultsLoadingPage: setResultsLoadingPage,
        setResultsShownPage: setResultsShownPage,
        setMoreInfoModal: setMoreInfoModal,
        getMoreInfoStep: getMoreInfoStep
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    function showTermsDocument(event) {
        event.preventDefault();
        var $el = $(this), title = $el.attr("data-title");
        url = $el.attr("href");
        if (typeof $el.attr("data-url") !== "undefined") {
            url = $el.attr("data-url");
        }
        if (title) {
            title = title.replace(/ /g, "_");
        }
        window.open(url, title, "width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");
    }
    function initShowDoc(options) {
        jQuery(document).ready(function($) {
            $(document.body).on("click", ".showDoc", showTermsDocument);
        });
    }
    meerkat.modules.register("showDoc", {
        init: initShowDoc
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info, meerkatEvents = meerkat.modules.events;
    var events = {
        sliders: {
            EVENT_UPDATE_RANGE: "EVENT_UPDATE_RANGE",
            EVENT_SET_VALUE: "SET_VALUE"
        }
    };
    var moduleEvents = events.sliders;
    function initModule() {
        $(document).ready(initSliders);
    }
    function initSliders() {
        if (typeof $.fn.noUiSlider !== "function") {
            log("[sliders.js]", "noUiSlider plugin is not available.");
            return;
        }
        $(".slider-control").each(function() {
            var $controller = $(this), $slider = $controller.find(".slider"), $field = $controller.find("input"), $selection = $controller.find(".selection"), initialValue = $slider.data("value"), range = $slider.data("range").split(","), markerCount = $slider.data("markers"), step = $slider.data("step"), legend = $slider.data("legend").split(","), type = $slider.data("type"), useDefaultOutput = $slider.data("use-default-output");
            var serialization = null;
            range = {
                min: Number(range[0]),
                max: Number(range[1])
            };
            var customSerialise, update = false;
            customSerialise = function(value) {
                $selection.text(value);
            };
            if ("excess" === type) {
                if (useDefaultOutput === false) {
                    $field = $("#health_excess");
                }
                if ($field.length > 0 && $field.val().length > 0) {
                    initialValue = $field.val();
                }
                customSerialise = function(value) {
                    if (value > 0 && value <= legend.length) {
                        $selection.text(legend[value - 1]);
                    } else {
                        $selection.text(" ");
                    }
                    $field.val(value);
                };
                serialization = {
                    lower: [ $.Link({
                        target: customSerialise,
                        format: {
                            decimals: 0
                        }
                    }) ]
                };
            }
            if ("price" === type) {
                if (useDefaultOutput === false) {
                    $field = $("#health_filter_priceMin");
                }
                if ($field.length > 0 && $field.val().length > 0) {
                    initialValue = $field.val();
                }
                customSerialise = function(value, handleElement, slider) {
                    if (value <= range.min || isNaN(value)) {
                        $field.val(0);
                        $selection.text("All prices");
                    } else {
                        $field.val(value);
                        $selection.text("from $" + value);
                    }
                };
                serialization = {
                    lower: [ $.Link({
                        target: customSerialise,
                        format: {
                            decimals: 0,
                            encoder: function(value) {
                                value = Math.round(value);
                                return Math.floor(value / 5) * 5;
                            }
                        }
                    }) ]
                };
                update = function(event, min, max, isUpdateFrequency) {
                    var oldMin = range.min;
                    var oldMax = range.max;
                    var oldValue = $field.val();
                    $slider.val(oldValue);
                    range = {
                        min: min,
                        max: max
                    };
                    changeRange($slider, {
                        min: 0,
                        "1%": min,
                        max: max
                    }, true);
                    if (isUpdateFrequency) {
                        if (oldValue == oldMin || oldValue == "0") {
                            $slider.val(0);
                        } else if (oldValue == oldMax) {
                            $slider.val(range.max);
                        } else {
                            var percentSelected = (oldValue - oldMin) / (oldMax - oldMin);
                            var newValue = range.min + (range.max - range.min) * percentSelected;
                            $slider.val(newValue);
                        }
                    }
                };
            }
            if (typeof update === "function") {
                $(this).on(moduleEvents.EVENT_UPDATE_RANGE, update);
            }
            $slider.on(moduleEvents.EVENT_SET_VALUE, function(event, value) {
                setValue($slider, value);
            });
            $slider.noUiSlider({
                range: range,
                step: step,
                start: [ initialValue ],
                serialization: serialization,
                behaviour: "extend-tap"
            });
            addMarkers($controller, markerCount);
            addLegend($controller, legend);
        });
    }
    function addMarkers($controller, markerCount) {
        var $htmls, $e, i;
        if (markerCount > 1) {
            markerCount = markerCount - 1;
            $htmls = $("<div />");
            for (i = 0; i < markerCount; i++) {
                $e = $("<div />");
                $e.addClass("slider-marker");
                $e.css("width", 100 / markerCount + "%");
                $htmls.append($e);
            }
            $htmls.find(".slider-marker:first").addClass("first");
            $htmls.find(".slider-marker").appendTo($controller.find(".noUi-base"));
        }
    }
    function addLegend($controller, legendArray) {
        var $htmls, $e, i;
        if (legendArray.length > 1) {
            $htmls = $("<div />");
            for (i = 0; i < legendArray.length; i++) {
                $e = $("<div><span><b /></span></div>");
                $e.addClass("slider-legend");
                $e.css("width", 100 / (legendArray.length - 1) + "%");
                $e.find("b").text(legendArray[i]);
                $htmls.append($e);
            }
            $htmls.find(".slider-legend:first").addClass("first");
            $htmls.find(".slider-legend:last").addClass("last");
            $htmls.find(".slider-legend").appendTo($controller.find(".slider-legends"));
        }
    }
    function changeRange($slider, range) {
        $slider.noUiSlider({
            range: range
        }, true);
        var markerCount = $slider.data("markers");
        var $controller = $slider.closest(".slider-control");
        if (typeof markerCount !== "undefined" && $controller.length > 0) {
            addMarkers($controller, markerCount);
        }
    }
    function setValue($slider, value) {
        $slider.val(value);
    }
    meerkat.modules.register("sliders", {
        init: initModule,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, currentJourney = null, currentJourneyList = [], currentJourneyFieldLabel = "currentJourney", $currentJourney = null;
    var events = {
        splitTest: {
            SPLIT_TEST_READY: "SPLIT_TEST_READY"
        }
    }, moduleEvents = events.splitTest;
    function init() {
        $(document).ready(function() {
            var prefix = meerkat.site.vertical == "car" ? "quote" : meerkat.site.vertical;
            var name = prefix + "_" + currentJourneyFieldLabel;
            $currentJourney = $("#" + name);
            var current_journey = $currentJourney.val();
            if (!_.isEmpty(current_journey)) {
                set(current_journey);
            }
            meerkat.messaging.publish(moduleEvents.SPLIT_TEST_READY);
        });
    }
    function set(current_journey) {
        currentJourney = current_journey;
        currentJourneyList = _.isEmpty(currentJourney) ? [] : currentJourney.split("-");
        $currentJourney.val(currentJourney);
    }
    function get(to_list) {
        to_list = to_list || false;
        return to_list === true ? _.extend({}, currentJourneyList) : currentJourney;
    }
    function isActive(jrny) {
        if (_.isArray(jrny)) {
            for (var i = 0; i < jrny.length; i++) {
                if (_.indexOf(currentJourneyList, String(jrny[i])) >= 0) {
                    return true;
                }
            }
            return false;
        } else {
            return _.indexOf(currentJourneyList, String(jrny)) >= 0;
        }
    }
    meerkat.modules.register("splitTest", {
        init: init,
        events: events,
        get: get,
        isActive: isActive
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var events = {
        tracking: {
            TOUCH: "TRACKING_TOUCH",
            EXTERNAL: "TRACKING_EXTERNAL"
        }
    }, moduleEvents = events.tracking;
    var lastFieldTouch = null;
    var lastFieldTouchXpath = null;
    function recordTouch(touchType, touchComment, productId, includeFormData, callback) {
        var data = [];
        if (includeFormData) {
            data = meerkat.modules.journeyEngine.getFormData();
        }
        data.push({
            name: "quoteType",
            value: meerkat.site.vertical
        });
        data.push({
            name: "touchtype",
            value: touchType
        });
        data.push({
            name: "comment",
            value: touchComment
        });
        data.push({
            name: "productId",
            value: productId
        });
        meerkat.modules.comms.post({
            url: "ajax/json/access_touch.jsp",
            data: data,
            errorLevel: "silent",
            onSuccess: function recordTouchSuccess(response) {
                if (_.has(response, "result") && _.has(response.result, "transactionId") && _.isNumber(response.result.transactionId) && response.result.transactionId > 0) {
                    meerkat.modules.transactionId.set(response.result.transactionId);
                }
                if (typeof callback === "function") callback(response);
            }
        });
    }
    function recordDTM(method, value) {
        try {
            if (typeof _satellite === "undefined") {
                throw "_satellite is undefined";
            }
            for (var key in value) {
                if (value.hasOwnProperty(key) && typeof value[key] !== "function") {
                    if (value[key] !== null) {
                        var setVarValue = typeof value[key] === "string" ? value[key].toLowerCase() : value[key];
                        _satellite.setVar(key, setVarValue);
                    } else {
                        _satellite.setVar(key, "");
                    }
                }
            }
            meerkat.logging.info("DTM", method, value);
            _satellite.track(method);
        } catch (e) {
            meerkat.logging.info("_satellite catch", method, value, e);
        }
    }
    function recordSupertag(method, value) {
        try {
            if (typeof superT === "undefined") {
                throw "Supertag is undefined";
            }
            superT[method](value);
            meerkat.logging.info("Supertag", method, value);
        } catch (e) {
            meerkat.logging.info("Supertag catch", method, value, e);
        }
    }
    function getEmailId(emailAddress, marketing, oktocall, callback) {
        return meerkat.modules.comms.post({
            url: "ajax/json/get_email_id.jsp",
            data: {
                vertical: meerkat.site.vertical,
                email: emailAddress,
                m: marketing,
                o: oktocall
            },
            cache: true,
            errorLevel: "silent"
        });
    }
    function updateLastFieldTouch(label) {
        if (!_.isUndefined(label) && !_.isEmpty(label) && label !== lastFieldTouch) {
            lastFieldTouch = label;
            $("#" + lastFieldTouchXpath).val(lastFieldTouch);
            meerkat.logging.debug("last touched field: " + lastFieldTouch);
        }
    }
    function applyLastFieldTouchListener() {
        $(document.body).on("click focus", "form input, form select", function(e) {
            updateLastFieldTouch($(this).closest(":input").attr("name"));
        });
        $("a[data-slide-control]").on("click", function() {
            updateLastFieldTouch($(this).attr("data-slide-control") + "-" + meerkat.modules.journeyEngine.getCurrentStep().navigationId);
        });
    }
    function initLastFieldTracking() {
        var vertical = meerkat.site.vertical;
        vertical = vertical === "car" ? "quote" : vertical;
        lastFieldTouchXpath = vertical + "_lastFieldTouch";
        $("#mainform").append($("<input/>", {
            type: "hidden",
            name: lastFieldTouchXpath,
            id: lastFieldTouchXpath,
            value: ""
        }));
        applyLastFieldTouchListener();
    }
    function initTracking() {
        $(document).on("click", "a[data-tracking-type]", function onTrackedLinkClick(eventObject) {
            var touchType = $(eventObject.currentTarget).attr("data-tracking-type");
            var touchValue = $(eventObject.currentTarget).attr("data-tracking-value");
            meerkat.modules.tracking.recordTouch(touchType, touchValue);
        });
        $(document).on("click", "a[data-supertag-method]", function onTrackedSupertagLinkClick(eventObject) {
            var supertagMethod = $(eventObject.currentTarget).attr("data-supertag-method");
            var supertagValue = $(eventObject.currentTarget).attr("data-supertag-value");
            meerkat.modules.tracking.recordSupertag(supertagMethod, supertagValue);
        });
        meerkat.messaging.subscribe(moduleEvents.TOUCH, function(eventObject) {
            if (typeof eventObject === "undefined") return;
            var includeFormData = false;
            if (typeof eventObject.includeFormData !== "undefined" && eventObject.includeFormData === true) includeFormData = true;
            recordTouch(eventObject.touchType, eventObject.touchComment, eventObject.productId, includeFormData, eventObject.callback);
        });
        meerkat.messaging.subscribe(moduleEvents.EXTERNAL, runTrackingCall);
        $(document).ready(function() {
            initLastFieldTracking();
            if (typeof meerkat !== "undefined" && typeof meerkat.site !== "undefined" && typeof meerkat.site.tracking !== "undefined" && meerkat.site.tracking.userTrackingEnabled === true) {
                meerkat.modules.utils.pluginReady("sessionCamRecorder").done(function() {
                    initUserTracking();
                });
            }
        });
    }
    function runTrackingCall(eventObject, override) {
        override = override || false;
        if (typeof eventObject === "undefined") {
            return;
        }
        if (typeof meerkat.site.tracking !== "object") {
            meerkat.site.tracking = {};
        }
        var values, object = eventObject.object;
        if (meerkat.site.tracking.superTagEnabled === true || meerkat.site.tracking.DTMEnabled === true) {
            values = typeof object === "function" ? object() : object;
        } else {
            values = object;
        }
        values = override === false ? updateObjectData(values) : values;
        var deferred = $.Deferred().resolve().promise();
        if (typeof values === "object") {
            if (values.email !== null && values.email !== "" && values.emailID === null) {
                deferred = getEmailId(values.email, values.marketOptIn, values.okToCall).done(function(result) {
                    if (typeof result.emailId !== "undefined") {
                        values.emailID = result.emailId;
                        values.email = null;
                    }
                });
            }
        }
        deferred.always(function() {
            if (meerkat.site.tracking.superTagEnabled === true) {
                recordSupertag(eventObject.method, values);
            }
            if (meerkat.site.tracking.DTMEnabled === true) {
                recordDTM(eventObject.method, values);
            }
        });
    }
    function getCurrentJourney() {
        return meerkat.modules.splitTest.get();
    }
    function getTrackingVertical() {
        var vertical = meerkat.site.vertical;
        if (vertical === "home") {
            vertical = "Home_Contents";
        }
        return vertical;
    }
    function updateObjectData(object) {
        if (typeof object.brandCode === "undefined") {
            object.brandCode = meerkat.site.tracking.brandCode;
        }
        if (typeof object.transactionID === "undefined") {
            object.transactionID = meerkat.modules.transactionId.get();
        }
        if (typeof object.rootID === "undefined") {
            object.rootID = meerkat.modules.transactionId.getRootId();
        }
        if (typeof object.currentJourney === "undefined") {
            object.currentJourney = getCurrentJourney();
        }
        if (typeof object.vertical === "undefined") {
            object.vertical = getTrackingVertical();
        }
        if (typeof object.simplesUser === "undefined") {
            object.simplesUser = meerkat.site.isCallCentreUser;
        }
        if (typeof object.contactCentreID === "undefined") {
            object.contactCentreID = meerkat.site.userId || null;
        }
        if (typeof object.campaignID === "undefined") {
            object.campaignID = $("input[name$=tracking_cid]").val() || null;
        }
        if (typeof object.verticalFilter === "undefined") {
            object.verticalFilter = typeof meerkat.modules[meerkat.site.vertical].getVerticalFilter === "function" ? meerkat.modules[meerkat.site.vertical].getVerticalFilter() : null;
        }
        object.trackingKey = meerkat.modules.trackingKey.get();
        object.lastFieldTouch = lastFieldTouch;
        return object;
    }
    function initUserTracking() {
        if (typeof window.sessionCamRecorder === "undefined") {
            return;
        }
        if (typeof window.sessioncamConfiguration !== "object") {
            window.sessioncamConfiguration = {};
        }
        if (typeof window.sessioncamConfiguration.customDataObjects !== "object") {
            window.sessioncamConfiguration.customDataObjects = [];
        }
        var item = {
            key: "transactionId",
            value: meerkat.modules.transactionId.get()
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
        item = {
            key: "brandCode",
            value: meerkat.site.tracking.brandCode
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
        item = {
            key: "vertical",
            value: meerkat.site.vertical
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
        item = {
            key: "rootID",
            value: meerkat.modules.transactionId.getRootId()
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
        item = {
            key: "currentJourney",
            value: getCurrentJourney()
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
    }
    meerkat.modules.register("tracking", {
        init: initTracking,
        events: events,
        recordTouch: recordTouch,
        recordSupertag: recordSupertag,
        updateLastFieldTouch: updateLastFieldTouch,
        applyLastFieldTouchListener: applyLastFieldTouchListener,
        getCurrentJourney: getCurrentJourney,
        updateObjectData: updateObjectData,
        getTrackingVertical: getTrackingVertical
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, trackingKey = null, $trackingKeyFld = null;
    function init() {
        $(document).ready(function() {
            if (typeof ResultsModel != "undefined") {
                var prefix = meerkat.site.vertical == "car" ? "quote" : meerkat.site.vertical;
                var name = prefix + "_trackingKey";
                $trackingKeyFld = $("#" + name);
                if (!$trackingKeyFld.length) {
                    $("#mainform").append($("<input />", {
                        id: name,
                        name: name,
                        value: trackingKey
                    }).attr("type", "hidden").attr("data-autosave", "true"));
                } else {
                    var key = $trackingKeyFld.val();
                    if (!_.isEmpty(key)) {
                        set(key);
                    }
                }
                meerkat.messaging.subscribe(ResultsModel.moduleEvents.RESULTS_UPDATED_INFO_RECEIVED, update);
            }
        });
    }
    function update(data) {
        if (data.hasOwnProperty("trackingKey")) {
            set(data.trackingKey);
        }
    }
    function set(key) {
        trackingKey = key;
        $trackingKeyFld.val(trackingKey);
    }
    function get() {
        return trackingKey;
    }
    meerkat.modules.register("trackingKey", {
        init: init,
        get: get
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        transactionId: {
            CHANGED: "CHANGED"
        }
    }, moduleEvents = events.transactionId;
    var transactionId, rootId, waitingOnNewTransactionId = false;
    var $transactionId;
    var $rootId;
    function init() {
        setTransactionIdFromPage();
        jQuery(document).ready(function($) {
            $transactionId = $(".transactionId");
            $rootId = $(".rootId");
            set(transactionId, rootId);
            updateSimples();
        });
    }
    function get() {
        if (typeof transactionId === "undefined") {
            setTransactionIdFromPage();
        }
        return transactionId;
    }
    function getRootId() {
        if (typeof rootId === "undefined") {
            setTransactionIdFromPage();
        }
        return rootId;
    }
    function set(newTransactionId, newRootId) {
        if (newTransactionId != transactionId) {
            meerkat.messaging.publish(moduleEvents.CHANGED, {
                transactionId: transactionId
            });
        }
        transactionId = newTransactionId;
        if (typeof newRootId != "undefined") {
            rootId = newRootId;
        }
        render();
        updateSimples();
    }
    function setTransactionIdFromPage() {
        if (meerkat.site.initialTransactionId !== null && typeof meerkat.site.initialTransactionId === "number") {
            transactionId = meerkat.site.initialTransactionId;
            rootId = meerkat.site.initialTransactionId;
            meerkat.site.initialTransactionId = null;
        }
    }
    function fetch(isAsync, actionId, retryAttempts, callback) {
        meerkat.modules.comms.post({
            url: "ajax/json/get_transactionid.jsp",
            dataType: "json",
            async: isAsync,
            errorLevel: "silent",
            numberOfAttempts: _.isNumber(retryAttempts) ? retryAttempts : 1,
            data: {
                quoteType: meerkat.site.vertical,
                id_handler: actionId
            },
            onSuccess: function fetchTransactionIdSuccess(msg) {
                if (msg.transactionId !== transactionId) {
                    set(msg.transactionId, msg.rootId);
                }
                if (typeof callback === "function") {
                    callback(transactionId);
                }
            },
            onError: function fetchTransactionIdError(jqXHR, textStatus, errorThrown, settings, resultData) {
                meerkat.modules.errorHandling.error({
                    message: "An error occurred fetching a transaction ID. Please check your connection or try again later.",
                    page: "core/transactionId.js module",
                    description: "fetch() AJAX request(s) returned an error: " + textStatus + " " + errorThrown + ". Original transactionId: " + transactionId,
                    errorLevel: "fatal",
                    data: transactionId
                });
                if (typeof callback == "function") {
                    callback(0);
                }
            }
        });
    }
    function getNew(retryAttempts, callback) {
        waitingOnNewTransactionId = true;
        fetch(true, "increment_tranId", retryAttempts, function(transactionId) {
            waitingOnNewTransactionId = false;
            if (typeof callback == "function") {
                callback(transactionId);
            }
        });
    }
    function updateSimples() {
        try {
            if (meerkat.site.isCallCentreUser) {
                parent.postMessage({
                    eventType: "transactionId",
                    transactionId: transactionId
                }, "*");
            }
        } catch (e) {}
    }
    function render() {
        if (typeof transactionId === "number" && transactionId > 0) {
            $transactionId.html(transactionId);
        }
    }
    meerkat.modules.register("transactionId", {
        init: init,
        events: events,
        get: get,
        getRootId: getRootId,
        set: set,
        getNew: getNew
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        unsupportedBrowser: {}
    }, moduleEvents = events.unsupportedBrowser, closeButton = "#js-close-unsupported-browser";
    function init() {
        jQuery(document).ready(function($) {
            if ($(closeButton).length) {
                eventSubscriptions();
                applyEventListeners();
            }
        });
    }
    function eventSubscriptions() {
        var $el = $(closeButton);
        if (Modernizr.localstorage === true) {
            if (localStorage.getItem("closedUnsupportedBrowser") !== null) {
                $el.parent().remove();
            }
        }
        if ($el.length) {
            $el.off("click").on("click", function(e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).parent().remove();
                if (Modernizr.localstorage === true) {
                    localStorage.setItem("closedUnsupportedBrowser", "true");
                }
                return false;
            });
        }
    }
    function applyEventListeners() {
        $(document).on("resultsLoaded", function() {
            $(closeButton).click();
        });
    }
    meerkat.modules.register("unsupportedBrowser", {
        init: init,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var log = meerkat.logging.info;
    function slugify(text) {
        text = text.replace(/[^\w\s-]/g, "");
        text = text.replace(/^\s+/, "").replace(/\s+$/, "").toLowerCase();
        text = text.replace(/[-\s]+/g, "-");
        return text;
    }
    function scrollPageTo(element, timing, offsetFromTop, callback) {
        var $ele = $(element);
        var tm = 250;
        var offset = 0;
        var didAnAnimation;
        var calledBack = false;
        if (typeof timing !== "undefined") {
            tm = timing;
        }
        if (typeof offsetFromTop !== "undefined") {
            offset = offsetFromTop;
        }
        if ($ele.offset().top < $(window).scrollTop()) {
            $("html, body").animate({
                scrollTop: $ele.offset().top + offset
            }, tm, function() {
                didAnAnimation = true;
                if (!calledBack && typeof callback == "function") {
                    calledBack = true;
                    callback(this, didAnAnimation);
                }
            });
        } else {
            didAnAnimation = false;
            if (typeof callback == "function") callback(this, didAnAnimation);
        }
    }
    jQuery.fn.animateAuto = function(prop, speed, callback) {
        var elem, height, width;
        return this.each(function(i, el) {
            el = jQuery(el), elem = el.clone().css({
                height: "auto",
                width: "auto"
            }).appendTo("body");
            height = elem.css("height"), width = elem.css("width"), elem.remove();
            if (prop === "height") el.animate({
                height: height
            }, speed, callback); else if (prop === "width") el.animate({
                width: width
            }, speed, callback); else if (prop === "both") el.animate({
                width: width,
                height: height
            }, speed, callback);
        });
    };
    function UTCToday() {
        var today = new Date();
        return Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), today.getUTCDate(), today.getUTCHours(), 0, 0, 0);
    }
    function returnAge(_dobString, round) {
        var _now = new Date();
        _now.setHours(0, 0, 0);
        var _dob = returnDate(_dobString);
        var _years = _now.getFullYear() - _dob.getFullYear();
        if (_years < 1) {
            return (_now - _dob) / (1e3 * 60 * 60 * 24 * 365);
        }
        var _leapYears = _years - _now.getFullYear() % 4;
        _leapYears = (_leapYears - _leapYears % 4) / 4;
        var _offset1 = (_leapYears * 366 + (_years - _leapYears) * 365) / _years;
        var _offset2 = +.005;
        if (_dob.getMonth() == _now.getMonth() && _dob.getDate() > _now.getDate()) {
            _offset2 = -.005;
        }
        var _age = (_now - _dob) / (1e3 * 60 * 60 * 24 * _offset1) + _offset2;
        if (round) {
            return Math.floor(_age);
        } else {
            return _age;
        }
    }
    function returnDate(_dateString) {
        return new Date(_dateString.substring(6, 10), _dateString.substring(3, 5) - 1, _dateString.substring(0, 2));
    }
    function returnDateValue(_date) {
        var _dayString = leadingZero(_date.getDate());
        var _monthString = leadingZero(_date.getMonth() + 1);
        return _date.getFullYear() + "-" + _monthString + "-" + _dayString;
    }
    function invertDate(dt, del) {
        del = del || "/";
        return dt.split(del).reverse().join(del);
    }
    function isValidNumericKeypressEvent(e, decimal) {
        decimal = _.isBoolean(decimal) ? decimal : false;
        var key;
        var keychar;
        if (window.event) {
            key = window.event.keyCode;
        } else if (e) {
            key = e.which;
        } else {
            return true;
        }
        keychar = String.fromCharCode(key);
        var safeList = [ 8, 35, 37, 39 ];
        if (key == null || key === 0 || key == 9 || key == 12 || key == 13 || key == 27) {
            return true;
        } else if (_.indexOf(safeList, key) !== -1 || "0123456789".indexOf(keychar) > -1) {
            return true;
        } else if (decimal && keychar == ".") {
            return true;
        } else {
            return false;
        }
    }
    function pluginReady(plugin) {
        var pluginDef = $.Deferred();
        if (!!jQuery.fn[plugin] || !!window[plugin]) {
            pluginDef.resolve();
            return pluginDef.promise();
        }
        var pluginInterval = setInterval(function() {
            if (!!jQuery.fn[plugin] || !!window[plugin]) pluginDef.resolve();
        }, 300);
        setTimeout(function() {
            clearInterval(pluginInterval);
        }, 1e4);
        $.when(pluginDef).then(function() {
            clearInterval(pluginInterval);
        });
        return pluginDef.promise();
    }
    function calcWorkingDays(fromDate, days) {
        var count = 0;
        while (count < days) {
            fromDate.setDate(fromDate.getDate() + 1);
            if (fromDate.getDay() !== 0 && fromDate.getDay() !== 6) count++;
        }
        return fromDate;
    }
    function formatUKToUSDate(date) {
        var delimiter = date.match(/(-)/) ? "-" : "/";
        date = date.split(delimiter);
        var day = date[0];
        date[0] = date[1];
        date[1] = day;
        return date.join(delimiter);
    }
    function getTimeAgo(date) {
        if (date instanceof Date === false) date = new Date(date);
        var seconds = Math.floor((new Date() - date) / 1e3), interval = Math.floor(seconds / 31536e3);
        if (interval > 1) return interval + " years";
        interval = Math.floor(seconds / 2592e3);
        if (interval > 1) return interval + " months";
        interval = Math.floor(seconds / 86400);
        if (interval > 1) return interval + " days";
        interval = Math.floor(seconds / 3600);
        if (interval > 1) return interval + " hours";
        interval = Math.floor(seconds / 60);
        if (interval > 1) return interval + " minutes";
        return Math.floor(seconds) + " seconds";
    }
    meerkat.modules.register("utils", {
        slugify: slugify,
        scrollPageTo: scrollPageTo,
        getUTCToday: UTCToday,
        returnAge: returnAge,
        returnDate: returnDate,
        isValidNumericKeypressEvent: isValidNumericKeypressEvent,
        invertDate: invertDate,
        returnDateValue: returnDateValue,
        pluginReady: pluginReady,
        calcWorkingDays: calcWorkingDays,
        getTimeAgo: getTimeAgo,
        formatUKToUSDate: formatUKToUSDate
    });
})(jQuery);

jQuery.fn.extend({
    refreshLayout: function() {
        var $trick = $("<div>");
        $(this).append($trick);
        _.defer(function() {
            $(this).remove($trick);
        });
    }
});

(function($, undefined) {
    var meerkat = window.meerkat;
    var events = {
        validation: {}
    };
    function init() {
        $.validator.addMethod("personName", validatePersonName, "Please enter alphabetic characters only. " + "Unfortunately, international alphabetic characters, numbers and symbols are not " + "supported by many of our partners at this time.");
    }
    var validNameCharsRegex = /^([a-zA-Z .'\-,]*)$/;
    var isUrlRegex = /(?:[^\s])\.(com|co|net|org|asn|ws|us|mobi)(\.[a-z][a-z])?/;
    function validatePersonName(value) {
        var isURL = value.match(isUrlRegex) !== null;
        return !isURL && validNameCharsRegex.test(value);
    }
    function setMinAgeValidation($field, ageMin, title) {
        $field.rules("add", {
            messages: {
                min_DateOfBirth: title + " age cannot be under " + ageMin
            },
            min_DateOfBirth: {
                ageMin: ageMin
            }
        });
    }
    function isValid($element, displayErrors) {
        if (displayErrors) return $element.valid();
        var $journeyEngineForm = $(document).find(".journeyEngineSlide").eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).children("form");
        if ($journeyEngineForm.length) $form = $journeyEngineForm; else $form = $("#mainForm");
        try {
            return $form.validate().check($element);
        } catch (e) {
            return true;
        }
    }
    function setupDefaultValidationOnForm($formElement) {
        $formElement.validate({
            submitHandler: function(form) {
                form.submit();
            },
            invalidHandler: function(form, validator) {
                if (!validator.numberOfInvalids()) return;
                if (jQuery.validator.scrollingInProgress) return;
                var $ele = $(validator.errorList[0].element), $parent = $ele.closest(".row-content, .fieldrow_value");
                if ($ele.attr("data-validation-placement") !== null && $ele.attr("data-validation-placement") !== "") {
                    $ele2 = $($ele.attr("data-validation-placement"));
                    if ($ele2.length > 0) $ele = $ele2;
                }
                if ($parent.length > 0) $ele = $parent;
                jQuery.validator.scrollingInProgress = true;
                meerkat.modules.utils.scrollPageTo($ele, 500, -50, function() {
                    jQuery.validator.scrollingInProgress = false;
                });
            },
            ignore: ":hidden,:disabled",
            meta: "validate",
            debug: true,
            errorClass: "has-error",
            validClass: "has-success",
            errorPlacement: function($error, $element) {
                var $referenceElement = $element;
                if ($element.attr("data-validation-placement") !== null && $element.attr("data-validation-placement") !== "") {
                    $referenceElement = $($element.attr("data-validation-placement"));
                }
                var parent = $referenceElement.closest(".row-content, .fieldrow_value");
                if (parent.length === 0) parent = $element.parent();
                var errorContainer = parent.children(".error-field");
                if (errorContainer.length === 0) {
                    parent.prepend('<div class="error-field"></div>');
                    errorContainer = parent.children(".error-field");
                    errorContainer.hide().slideDown(100);
                }
                errorContainer.append($error);
            },
            onkeyup: function(element) {
                var element_id = jQuery(element).attr("id");
                if (!this.settings.rules.hasOwnProperty(element_id) || !this.settings.rules[element_id].onkeyup) {
                    return;
                }
                if (validation && element.name !== "captcha_code") {
                    this.element(element);
                }
            },
            onfocusout: function(element, event) {
                var $ele = $(element);
                if ($ele.hasClass("tt-query")) {
                    var $menu = $ele.nextAll(".tt-dropdown-menu");
                    if ($menu.length > 0 && $menu.first().is(":visible")) {
                        return false;
                    }
                }
                $.validator.defaults.onfocusout.call(this, element, event);
            },
            highlight: function(element, errorClass, validClass) {
                if (element.type === "radio") {
                    this.findByName(element.name).addClass(errorClass).removeClass(validClass);
                } else {
                    $(element).addClass(errorClass).removeClass(validClass);
                }
                var $wrapper = $(element).closest(".row-content, .fieldrow_value");
                $wrapper.addClass(errorClass).removeClass(validClass);
                var errorContainer = $wrapper.find(".error-field");
                if (errorContainer.find("label:visible").length === 0) {
                    if (errorContainer.is(":visible")) {
                        errorContainer.stop();
                    }
                    errorContainer.delay(10).slideDown(100);
                }
            },
            unhighlight: function(element, errorClass, validClass) {
                return this.ctm_unhighlight(element, errorClass, validClass);
            }
        });
    }
    meerkat.modules.register("validation", {
        init: init,
        events: events,
        isValid: isValid,
        setupDefaultValidationOnForm: setupDefaultValidationOnForm,
        validatePersonName: validatePersonName,
        setMinAgeValidation: setMinAgeValidation
    });
})(jQuery);

jQuery.fn.extend({
    isValid: function(displayErrors) {
        return meerkat.modules.validation.isValid($(this), displayErrors);
    }
});

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, debug = meerkat.logging.debug, exception = meerkat.logging.exception;
    var events = {
        writeQuote: {}
    }, watchedFields = null, autoSaveTimeout = null, autoSaveTimeoutMs = 3e3, liteXhrRequest = false, dataValues = {};
    function init() {
        if (meerkat.site.isCallCentreUser === false) {
            initWriteQuoteLite();
        }
    }
    function initWriteQuoteLite() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function() {
            if (typeof meerkat.site.watchedFields == "undefined" || meerkat.site.watchedFields === "") {
                return false;
            }
            watchedFields = meerkat.site.watchedFields;
            if (!$(watchedFields).length) {
                debug("[writeQuote] No fields identified from selector provided.");
                return false;
            }
            $(watchedFields).attr("data-autoSave", "true");
            setDefaultValues();
            _.defer(function() {
                eventSubscriptions();
                applyEventListeners();
            });
        });
    }
    function applyEventListeners() {
        $(document).on("change", ".journeyEngineSlide.active :input[data-autoSave]", function() {
            triggerSaveTimeout($(this));
        }).on("focus", ".journeyEngineSlide.active :input[data-autoSave]", function() {
            triggerSaveTimeout($(this));
        });
    }
    function setDefaultValues() {
        $(":input", $(".journeyEngineSlide")).each(function() {
            setDataValueForField($(this));
        });
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function() {
            if (autoSaveTimeout) {
                clearTimeout(autoSaveTimeout);
            }
            if (liteXhrRequest !== false) {
                if (typeof liteXhrRequest.state === "function" && liteXhrRequest.state() == "pending") {
                    liteXhrRequest.abort();
                }
            }
            setDefaultValues();
        });
    }
    function setDataValueForField($el) {
        var xpath = getXpathFromElement($el);
        if (xpath !== false) {
            dataValues[xpath] = getValue($el);
        }
    }
    function getXpathFromElement($el) {
        return $el.attr("name") || $el.attr("id") || false;
    }
    function getValue($el) {
        if ($el.attr("type") == "radio" || $el.attr("type") == "checkbox") {
            return $("input[name=" + $el.attr("name") + "]:checked").val() || "";
        }
        return $el.val();
    }
    function triggerSaveTimeout($el) {
        if (autoSaveTimeout || autoSaveTimeout && typeof liteXhrRequest !== false && typeof liteXhrRequest.state === "function" && liteXhrRequest.state() == "pending") {
            clearTimeout(autoSaveTimeout);
        }
        autoSaveTimeout = setTimeout(writeQuoteLite, autoSaveTimeoutMs);
    }
    function writeQuoteLite() {
        var data = [];
        $(":input", $(".journeyEngineSlide")).add($("input[id*=lastFieldTouch]")).each(function() {
            var $el = $(this), xpath = getXpathFromElement($el);
            if (xpath !== false) {
                var value = getValue($el);
                if (dataValues[xpath] !== value) {
                    data.push({
                        name: xpath,
                        value: value
                    });
                    dataValues[xpath] = value;
                }
            }
        });
        if (!data.length) {
            return;
        }
        if (meerkat.modules.journeyEngine.getCurrentStep() !== null) {
            data.push({
                name: $(".journey_stage").attr("name"),
                value: meerkat.modules.journeyEngine.getCurrentStep().navigationId
            });
        }
        data.push({
            name: "hasPrivacyOptin",
            value: meerkat.modules.optIn.isPrivacyOptedIn()
        });
        liteXhrRequest = meerkat.modules.comms.post({
            url: "quote/write_lite.json",
            data: data,
            dataType: "json",
            timeout: 2e4,
            numberOfAttempts: 1,
            cache: false,
            returnAjaxObject: true,
            errorLevel: "silent",
            useDefaultErrorHandling: false
        });
    }
    function write(extraDataToSave, triggerFatalError, callback) {
        var data = [];
        $.extend(data, meerkat.modules.journeyEngine.getFormData());
        data.push({
            name: "quoteType",
            value: meerkat.site.vertical
        });
        if (meerkat.modules.journeyEngine.getCurrentStep() !== null) {
            data.push({
                name: "stage",
                value: meerkat.modules.journeyEngine.getCurrentStep().navigationId
            });
        }
        if (typeof extraDataToSave === "object") {
            for (var i in extraDataToSave) {
                if (extraDataToSave.hasOwnProperty(i)) {
                    data.push({
                        name: i,
                        value: extraDataToSave[i]
                    });
                }
            }
        }
        meerkat.modules.comms.post({
            url: "ajax/write/write_quote.jsp",
            data: data,
            dataType: "json",
            cache: false,
            errorLevel: triggerFatalError ? "fatal" : "silent",
            onSuccess: function writeQuoteSuccess(result) {
                if (typeof callback === "function") callback(result);
            }
        });
    }
    meerkat.modules.register("writeQuote", {
        init: init,
        events: events,
        write: write
    });
})(jQuery);
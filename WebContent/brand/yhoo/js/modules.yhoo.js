/*!
 * CTM-Platform v0.8.3
 * Copyright 2014 Compare The Market Pty Ltd
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
        _.extend(meerkat, {
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
        _.extend(settings, options || {});
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
                } else {}
                meerkat.modules.errorHandling.error({
                    errorLevel: "silent",
                    page: "meerkat.logging.js",
                    message: message,
                    description: originalErrorMessage
                });
            }
            if (config.mode !== "production" && navigator.appName != "Microsoft Internet Explorer") {
                fn.apply(console, Array.prototype.slice.call(args));
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

window.onerror = function(message, url, line) {
    Driftwood.exception(message, {
        url: url,
        line: line
    });
};

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

meerkat.logging.init = function() {
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
            _.extend(events, modules[moduleName].events());
        } else if (typeof modules.events === "object") {
            _.extend(events, modules[moduleName].events);
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

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var moduleEvents = {
        ADDRESS_CHANGE: "ADDRESS_CHANGE"
    };
    var settings = {
        defaultHash: ""
    };
    function setHash(value) {
        window.location.hash = value;
    }
    function setStartHash(value) {
        settings.defaultHash = value;
    }
    function appendToHash(value) {
        if (_.indexOf(getWindowHashAsArray(), value) == -1) {
            window.location.hash = getWindowHash() + "/" + value;
        }
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
        setHash: setHash,
        appendToHash: appendToHash,
        removeFromHash: removeFromHash,
        setStartHash: setStartHash,
        getWindowHashAt: getWindowHashAt
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
                        return this.top = offsetTop;
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
    function topDockBasedOnParentHeight($elems) {
        $elems.each(function(index, val) {
            $item = $(val);
            $item.affix({
                offset: {
                    top: function() {
                        var offsetTop = $item.parent().height() - $item.height();
                        return this.top = offsetTop;
                    }
                }
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
    var meerkat = window.meerkat;
    var moduleEvents = {
        CANT_FIND_ADDRESS: "EVENT_CANT_FIND_ADDRESS"
    };
    function initialiseAutoCompleteFields() {
        var $typeAheads = $("input.typeahead");
        $typeAheads.each(function eachTypeaheadElement() {
            var $component = $(this);
            var params = {
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
                    if (datum.hasOwnProperty("value") && datum.value === "Type your address...") return;
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
            typeaheadParams.remote.url = $element.attr("id");
            typeaheadParams.remote.replace = addressSearch;
            typeaheadParams.valueKey = "value";
            typeaheadParams.template = _.template("<p><%= highlight %></p>");
            if ($element.hasClass("typeahead-streetSearch")) {
                typeaheadParams.remote.filter = function(parsedResponse) {
                    autocompleteComplete($element);
                    if (parsedResponse.length === 0) {
                        parsedResponse.push({
                            value: "Type your address...",
                            highlight: "Can't find your address? <u>Click here.</u>"
                        });
                    }
                    return parsedResponse;
                };
                $element.bind("typeahead:selected", function catchEmptyValue(event, datum, name) {
                    if (datum.hasOwnProperty("value") && datum.value === "Type your address...") {
                        var id = "";
                        if (event.target && event.target.id) {
                            id = event.target.id.replace("_streetSearch", "");
                        }
                        meerkat.messaging.publish(moduleEvents.CANT_FIND_ADDRESS, {
                            fieldgroup: id
                        });
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
        init: initialiseAutoCompleteFields,
        events: moduleEvents
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
    var meerkat = window.meerkat;
    var cache = [];
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
        onSuccess: function(result, textStatus, jqXHR) {},
        onError: function(jqXHR) {},
        onComplete: function(jqXHR, textStatus) {},
        onErrorDefaultHandling: function(jqXHR, textStatus, errorThrown, settings, data) {
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
                _.extend(errorObject, {
                    errorLevel: "warning",
                    id: CHECK_AUTHENTICATED_LABEL
                });
            } else if (!message || message === "") {
                message = "Unknown Error";
            }
            _.extend(errorObject, {
                message: message
            });
            if (errorThrown != CHECK_AUTHENTICATED_LABEL || errorThrown == CHECK_AUTHENTICATED_LABEL && !meerkat.modules.dialogs.isDialogOpen(CHECK_AUTHENTICATED_LABEL)) {
                meerkat.modules.errorHandling.error(errorObject);
            }
        }
    };
    function post(instanceSettings) {
        var settings = $.extend({}, defaultSettings, instanceSettings);
        if (typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null) {
            console.error("Message to dev: please provide an errorLevel to the comms.post() or comms.get() function.");
        }
        var usedCache = checkCache(settings);
        if (usedCache === true) return true;
        settings.attemptsCounter = 1;
        return ajax(settings, {
            url: settings.url,
            data: settings.data,
            dataType: settings.dataType,
            type: "POST",
            timeout: settings.timeout
        });
    }
    function get(instanceSettings) {
        var settings = $.extend({}, defaultSettings, instanceSettings);
        if (typeof instanceSettings.errorLevel === "undefined" || instanceSettings.errorLevel === null) {
            console.error("Message to dev: please provide an errorLevel to the comms.post() or comms.get() function.");
        }
        var usedCache = checkCache(settings);
        if (usedCache === true) return true;
        settings.attemptsCounter = 1;
        return ajax(settings, {
            url: settings.url,
            data: settings.data,
            dataType: settings.dataType,
            type: "GET",
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
                if (ajaxProperties.data.hasOwnProperty("transactionId") === false) {
                    ajaxProperties.data.transactionId = tranId;
                }
                if (meerkat.site.isCallCentreUser) {
                    ajaxProperties.data[CHECK_AUTHENTICATED_LABEL] = true;
                }
            }
        } catch (e) {}
        return $.ajax(ajaxProperties).then(function onAjaxSuccess(result, textStatus, jqXHR) {
            var data = typeof settings.data != "undefined" ? settings.data : null;
            if (containsServerGeneratedError(result) === true) {
                handleError(jqXHR, "Server generated error", result.error, settings, data, ajaxProperties);
            } else {
                if (settings.cache === true) addToCache(settings.url, data, result);
                if (settings.onSuccess != null) settings.onSuccess(result);
                if (settings.onComplete != null) settings.onComplete(jqXHR, textStatus);
            }
        }, function onAjaxError(jqXHR, textStatus, errorThrown) {
            var data = typeof settings.data != "undefined" ? settings.data : null;
            handleError(jqXHR, textStatus, errorThrown, settings, data, ajaxProperties);
            if (settings.onComplete != null) settings.onComplete(jqXHR, textStatus);
        });
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
                if (settings.onSuccess != null) settings.onSuccess(cachedResult.result);
                if (settings.onComplete != null) settings.onComplete();
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
    function handleError(jqXHR, textStatus, errorThrown, settings, data, ajaxProperties) {
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
        fields = _.extend(fields, contactDetailsFields);
        _.each(fields, function(fieldTypeEntities, fieldType) {
            _.each(fieldTypeEntities, function(fieldTypeEntity, index) {
                var fieldDetails = _.extend(fieldTypeEntity, {
                    index: index,
                    type: fieldType,
                    fieldIndex: 1
                });
                setFieldChangeEvent(fieldDetails);
                setOptinFieldChangeEvent(fieldDetails);
                if (typeof fieldDetails.$otherField !== "undefined") {
                    fieldDetails = _.extend({}, fieldDetails, {
                        alternateOtherField: true,
                        fieldIndex: 2
                    });
                    setFieldChangeEvent(fieldDetails);
                }
            });
        });
        prefillLaterFields = true;
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
                var eventObject = _.extend(getChangeEventObject(fieldDetails), optins);
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
                allFields.push(_.extend(fieldTypeEntity, {
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
            var laterFieldDetails = _.extend(fields[fieldDetails.type][i], {
                type: fieldDetails.type
            });
            var $fieldElement = getInputField(laterFieldDetails);
            if (($fieldElement.val() === "" || updatedElementPreviousValue === $fieldElement.val()) && (typeof laterFieldDetails.$otherField === "undefined" || laterFieldDetails.$otherField.val() === "")) {
                if (fieldDetails.type == "name" && typeof laterFieldDetails.$otherField !== "undefined") {
                    var splitName = updatedElementValue.split(" ");
                    $fieldElement.val(splitName[0]);
                    laterFieldDetails.$otherField.val(splitName.slice(1).join(" "));
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
                var laterFieldDetails = _.extend(fields[fieldDetails.type][i], {
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
    meerkat.modules.register("contactDetails", {
        init: init,
        events: events,
        configure: configure,
        getFields: getFields,
        getFieldsFromOptInGroup: getFieldsFromOptInGroup,
        isOptInGroupValid: isOptInGroupValid,
        isPartOfOptInGroup: isPartOfOptInGroup
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
            var output = "", $el = $(this), $sourceElement = $($el.attr("data-source"));
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
                    if ($selected.val() === "") output = ""; else output = $selected.text() || "";
                    break;

                  case "input":
                    output = $sourceElement.val() || "";
                    break;

                  default:
                    output = $sourceElement.html() || "";
                    break;
                }
            } else {
                switch (dataType) {
                  case "radiogroup":
                    var selectedParent = $sourceElement.find(":checked").parent("label");
                    if (selectedParent.length) {
                        output = selectedParent.text() || "";
                    }
                    break;

                  case "list":
                    $sourceElement.find("li").each(function() {
                        output += "<li>" + $(this).find("span:eq(0)").text() + "</li>";
                    });
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
    var meerkat = window.meerkat, log = meerkat.logging.info;
    function init() {
        $(document).ready(function() {
            if (!$.fn.datepicker) {
                log("core/datepicker", "Datepicker library is not available.");
                return;
            }
            $.fn.datepicker.defaults.format = "dd/mm/yyyy";
            $.fn.datepicker.defaults.autoclose = true;
            $.fn.datepicker.defaults.forceParse = false;
            $.fn.datepicker.defaults.weekStart = 1;
            $.fn.datepicker.defaults.todayHightlight = true;
            $.fn.datepicker.defaults.clearBtn = true;
            $("[data-provide=datepicker]").each(function() {
                var datepicker = $(this);
                datepicker.siblings(".input-group-addon").on("click", function() {
                    datepicker.datepicker("show");
                });
            });
        });
        $(document).on("hide", '[data-provide="datepicker"]', function(e) {
            if (!e.target) return;
            if ($(e.target).is(":focus")) return;
            $(e.target).blur();
        });
    }
    meerkat.modules.register("datepicker", {
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;
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
        closeOnHashChange: false,
        openOnHashChange: true,
        fullHeight: false,
        templates: {
            dialogWindow: '<div id="{{= id }}" class="modal" tabindex="-1" role="dialog" aria-labelledby="{{= id }}_title" aria-hidden="true"{{ if(fullHeight===true){ }} data-fullheight="true"{{ } }}>\n						<div class="modal-dialog {{= className }}">\n\n							<div class="modal-content">\n								<div class="modal-closebar">\n									<a href="javascript:;" class="btn btn-close-dialog"><span class="icon icon-cross"></span></a>\n								</div>\n\n								<div class="navbar navbar-default xs-results-pagination visible-xs">\n									<div class="container">\n										<ul class="nav navbar-nav">\n											<li>\n												<button data-button="leftBtn" class="btn btn-back {{= leftBtn.className }}">{{= leftBtn.icon }} {{= leftBtn.label }}</button>\n											</li>\n											<li class="navbar-text modal-title-label">\n												{{= title }}\n											</li>\n											{{ if(rightBtn.label != "" || rightBtn.icon != "") { }}\n												<li class="right">\n													<button data-button="rightBtn" class="btn btn-save {{= rightBtn.className }}">{{= rightBtn.label }} {{= rightBtn.icon }}</button>\n												</li>\n								{{ } }}\n										</ul>\n									</div>\n								</div>\n\n								<!-- title OR tab list OR htmlHeaderContent e.g. search box -->\n								{{ if(title != "" || tabs.length > 0 || htmlHeaderContent != "" ) { }}\n								<div class="modal-header">\n									{{ if (tabs.length > 0) { }}\n										<ul class="nav nav-tabs tab-count-{{= tabs.length }}">\n											{{ _.each(tabs, function(tab, iterator) { }}\n												<li><a href="javascript:;" data-target="{{= tab.targetSelector }}" title="{{= tab.xsTitle }}">{{= tab.title }}</a></li>\n											{{ }); }}\n										</ul>\n									{{ } else if(title != "" ){ }}\n										<h4 class="modal-title hidden-xs" id="{{= id }}_title">{{= title }}</h4>\n									{{ } else if(htmlHeaderContent != "") { }}\n										{{= htmlHeaderContent }}\n									{{ } }}\n								</div>\n								{{ } }}\n\n								<div class="modal-body">\n									{{= htmlContent }}\n								</div>\n								{{ if(typeof buttons !== "undefined" && buttons.length > 0 ){ }}\n									<div class="modal-footer {{ if(buttons.length > 1 ){ }} mustShow {{ } }}">\n										{{ _.each(buttons, function(button, iterator) { }}\n											<button data-index="{{= iterator }}" type="button" class="btn {{= button.className }} ">{{= button.label }}</button>\n										{{ }); }}\n									</div>\n								{{ } }}\n							</div>\n						</div>\n					</div>'
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
        destroyDialog(dialogId);
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
            var viewport_height, content_height, dialogTop, $modalContent = $dialog.find(".modal-content"), $modalDialog = $dialog.find(".modal-dialog");
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
                $dialog.find(".modal-body").css("height", content_height);
                dialogTop = 0;
                $modalDialog.css("top", dialogTop);
            } else {
                $modalContent.css("max-height", viewport_height);
                if ($dialog.attr("data-fullheight") === "true") {
                    $modalContent.css("height", viewport_height);
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
        $dialog.find("button").unbind();
        $dialog.remove();
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
        if (!$dropdown || $dropdown.length === 0) return;
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
            $dropdown.find(".dropdown-container .scrollable").css("max-height", maxHeight).css("overflow-y", "auto");
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        emailResults: {}
    }, moduleEvents = events.emailResults;
    var $dropdown = null;
    var $form = null;
    var $instructions = null;
    var $email = null;
    var $password = null;
    var $passwordConfirm = null;
    var $marketing = null;
    var $submitButton = null;
    var $passwords = null;
    var $emailResultsSuccess = null;
    var $emailResultsFields = null;
    var $callMeBackForm = null;
    var submitButtonClass = ".btn-email-results";
    var lastEmailChecked = null;
    var emailTypingTimer = null;
    var checkUserAjaxObject = null;
    var userExists = null;
    var emailresultsAjaxObject = null;
    var isConfirmed = false;
    var isEnabled = false;
    function init() {
        jQuery(document).ready(function($) {
            $dropdown = $("#email-results-dropdown");
            $form = $("#email-results-component");
            $instructions = $(".emailResultsInstructions");
            $email = $("#emailresults_email");
            $marketing = $("#emailresults_marketing");
            $submitButton = $(submitButtonClass);
            $emailResultsSuccess = $("#emailResultsSuccess");
            $emailResultsFields = $(".emailResultsFields");
            $email.on("keyup change", emailKeyChange);
            $email.on("blur", function() {
                $(this).val($.trim($(this).val()));
            });
            $form.on("click", ".btn-email-results", emailResults);
            $dropdown.find(".activator").on("click", onDropdownOpen);
            $dropdown.on("click", ".btn-cancel", close);
            setValidation();
            updateInstructions();
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
    function onDropdownOpen() {
        if (isConfirmed) {
            $emailResultsSuccess.hide();
            $form.show();
            $emailResultsFields.hide();
        } else {
            if ($email.val() !== "" && $submitButton.hasClass("disabled")) {
                $email.trigger("change");
            }
        }
    }
    function setValidation() {
        if ($form === null || $form.length === 0) {
            return;
        }
        setupDefaultValidationOnForm($form);
    }
    function emailKeyChange(event) {
        if (event.keyCode == 13 || event.keyCode == 9) {
            emailChanged();
        } else {
            if (lastEmailChecked != $email.val()) {
                disableSubmitButton();
                clearInterval(emailTypingTimer);
                emailTypingTimer = setTimeout(emailChanged, 800);
            } else {
                enableSubmitButton();
            }
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
        if (checkUserAjaxObject && checkUserAjaxObject.state() === "pending" && checkUserAjaxObject) {
            checkUserAjaxObject.abort();
        }
        disableSubmitButton();
        meerkat.modules.loadingAnimation.showAfter($email);
        var emailInfo = {
            data: {
                type: "email",
                value: emailAddress
            },
            onComplete: function() {
                enableSubmitButton();
                meerkat.modules.loadingAnimation.hide($email);
                updateInstructions("emailresultsReady");
            },
            onSuccess: function checkUserExistsSuccess(result) {
                if (result.optInMarketing) {
                    hideMarketingCheckbox();
                    $marketing.prop("checked", true);
                } else {
                    showMarketingCheckbox();
                }
            },
            onError: function checkUserExistsError() {
                userExists = false;
                updateInstructions();
            }
        };
        checkUserAjaxObject = meerkat.modules.optIn.fetch(emailInfo);
    }
    function updateInstructions(instructionsType) {
        var text = "Please enter the email you want your results sent to.";
        switch (instructionsType) {
          case "emailresultsAgain":
            text = 'Click the button to send an email of these results.  <a href="javascript:;" class="btn btn-save btn-email-results">Email Results</a>';
            break;

          case "emailresultsReady":
            text = "Click the button to send the results to this email address.";
            break;

          default:
            text = "Please enter the email address you want these results sent to.";
            break;
        }
        $instructions.html(text);
        if (instructionsType === "emailresultsAgain") {
            $submitButton = $(submitButtonClass);
            $submitButton.html("Email Results");
        }
    }
    function emailResults() {
        if ($form.valid()) {
            if (emailresultsAjaxObject && emailresultsAjaxObject.state() === "pending") {
                return;
            }
            disableSubmitButton();
            var dat = [];
            dat.push("emailresults_email=" + encodeURIComponent($email.val()));
            dat.push("transactionId=" + meerkat.modules.transactionId.get());
            dat = dat.join("&");
            switch (Track._type) {
              case "Health":
                if (Health._rates !== false) {
                    dat += Health._rates;
                }
                break;

              default:
                break;
            }
            meerkat.modules.loadingAnimation.showAfter($submitButton);
            meerkat.modules.comms.post({
                url: "ajax/json/email_results.jsp",
                data: dat,
                dataType: "json",
                cache: false,
                errorLevel: "silent",
                onSuccess: function emailResultsSuccess(result) {
                    emailresultsSuccess(result.success, result.transactionId);
                },
                onError: function emailResultsError() {
                    enableSubmitButton();
                },
                onComplete: function() {
                    meerkat.modules.loadingAnimation.hide($submitButton);
                }
            });
        }
    }
    function emailresultsSuccess(success, transactionId) {
        enableSubmitButton();
        meerkat.modules.loadingAnimation.hide($submitButton);
        if (success) {
            $form.hide();
            $emailResultsSuccess.fadeIn();
            if (!isConfirmed) {
                isConfirmed = true;
                updateInstructions("emailresultsAgain");
                $dropdown.find(".activator span:not([class])").html("Email Results");
            }
            if (typeof transactionId !== "undefined") {
                meerkat.modules.transactionId.set(transactionId);
            }
        } else {}
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
    }
    function disable(obj) {
        close();
        $dropdown.children(".activator").addClass("inactive").addClass("disabled");
    }
    function close() {
        if ($dropdown.hasClass("open")) {
            $dropdown.find(".activator").dropdown("toggle");
        }
    }
    meerkat.modules.register("emailResults", {
        init: init,
        events: events,
        close: close,
        enable: enable,
        disable: disable,
        enableSubmitButton: enableSubmitButton,
        disableSubmitButton: disableSubmitButton
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
            buttons = [ {
                label: "Refresh page",
                className: "btn-cta",
                action: function(eventObject) {
                    location.reload();
                },
                closeWindow: false
            } ];
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
            title: "Error",
            htmlContent: data.message,
            buttons: buttons
        };
        if (!_.isNull(data.id)) {
            _.extend(dialogSettings, {
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
        $parentElement.find(":input[data-initValue]").removeAttr("data-initValue");
        $parentElement.find(":input[data-visible]").removeAttr("data-visible");
        $parentElement.find(":input:visible").attr("data-visible", "true");
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
        markInitialFieldsWithValue: markInitialFieldsWithValue
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
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
    }
    function moveToNextInput() {
        var $this = $(this);
        if (!$this.attr("maxlength")) return;
        if ($this.hasClass("year")) return;
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
        if (day.length > 0 && Number(day) > 0 && month.length > 0 && Number(month) > 0 && year.length > 0 && Number(year) > 0) {
            $destination.val(day + "/" + month + "/" + year);
            $destination.valid();
        } else {
            $destination.val("");
        }
        $destination.change();
        $component.removeAttr("data-locked");
    }
    meerkat.modules.register("formDateInput", {
        init: init
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        journeyEngine: {
            STEP_CHANGED: "STEP_CHANGED",
            STEP_INIT: "STEP_INIT",
            READY: "JOURNEY_READY"
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
                if (meerkat.modules.address.getWindowHash() !== "" && meerkat.modules.address.getWindowHash() !== settings.startStepId) {
                    meerkat.modules.address.setHash(settings.startStepId);
                } else {
                    meerkat.modules.address.setStartHash(settings.startStepId);
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
                });
            });
        }
        function onHidePreviousStep() {
            if (currentStep != null && currentStep.onAfterLeave != null) currentStep.onAfterLeave(eventObject);
        }
    }
    function onShowNextStep(eventObject, previousStep, triggerEnterMethod) {
        $("body").attr("data-step", currentStep.navigationId);
        var title = meerkat.site.title;
        if (currentStep.title != null) title = currentStep.title + " - " + title;
        window.document.title = title;
        if (currentStep.slideScrollTo && currentStep.slideScrollTo !== null) {
            meerkat.modules.utilities.scrollPageTo(currentStep.slideScrollTo);
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
    function validateStep(step, successCallback) {
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
                if (isValid === false) throw "Validation failed on " + step.navigationId;
            }
            if (step.validation.customValidation != null) {
                waitForCallback = true;
                step.validation.customValidation(function(valid) {
                    if (valid) {
                        successCallback(true);
                    } else {
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
        eventObject.stopPropagation();
        gotoPath($target.attr("data-slide-control"), $target);
    }
    function gotoPath(path, $target) {
        if (typeof $target !== "undefined" && $target.hasClass("show-loading")) {
            meerkat.modules.loadingAnimation.showAfter($target);
        }
        try {
            if (isLocked()) {
                throw "Journey engine action in progress (isLocked)";
            } else {
                lock();
            }
            var navigationId = path;
            if (currentStep.navigationId !== navigationId) {
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
                }
                if (getStepIndex(navigationId) == getStepIndex(currentStep.navigationId) + 1 && direction == "forward") {
                    validateStep(currentStep, function() {
                        $(settings.slideContainer).attr("data-prevalidation-completed", "1");
                        meerkat.modules.address.setHash(navigationId);
                        if (typeof $target !== "undefined") meerkat.modules.loadingAnimation.hide($target);
                    });
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
            if (e.keyCode == 13 || e.keyCode == 108 || e.ctrlKey && e.keyCode == 39) {
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
            $ele.removeClass("displayBlock");
            $ele.find(".message").text($ele.find(".message").attr("data-oldtext"));
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
        getPreviousStepId: getPreviousStepId
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
        var lastIndex = progressBarSteps.length - 1;
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
        setComplete: setComplete
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        leavePageWarning: {}
    }, moduleEvents = events.leavePageWarning;
    var safeToLeave = true;
    function initLeavePageWarning() {
        var ie10OrBelow = meerkat.modules.performanceProfiling.isIE8() || meerkat.modules.performanceProfiling.isIE9() || meerkat.modules.performanceProfiling.isIE10();
        if (meerkat.site.leavePageWarning.enabled && meerkat.site.isCallCentreUser === false && ie10OrBelow === false) {
            window.onbeforeunload = function() {
                if (safeToLeave === false && meerkat.modules.saveQuote.isAvailable() === true) {
                    return meerkat.site.leavePageWarning.message;
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
    function disable() {
        safeToLeave = true;
    }
    meerkat.modules.register("leavePageWarning", {
        init: initLeavePageWarning,
        events: events,
        disable: disable
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, debug = meerkat.logging.debug;
    window.lpMTagConfig = window.lpMTagConfig || {};
    window.lpMTagConfig.vars = window.lpMTagConfig.vars || [];
    window.lpSettings = window.lpSettings || {};
    var options, oldIE;
    function getPageName(navigationId) {
        var step, page;
        if (typeof navigationId === "undefined") {
            step = meerkat.modules.journeyEngine.getCurrentStep();
            page = step.navigationId;
        } else {
            page = navigationId;
        }
        if (options.brand == "ctm") {
            return [ options.brand, "quote-form", options.vertical, page ].join(":");
        } else {
            return [ "ctm:whiteLabel", options.brand, "quote-form", options.vertical, page ].join(":");
        }
    }
    function fire(stepPassed, confirmationBool, confirmationNavigationId) {
        if (meerkat.site.liveChat.enabled === false) return;
        lpMTagConfig.vars.push([ "page", "ConversionStage", stepPassed ]);
        var tran_id = false;
        tran_id = meerkat.modules.transactionId.get();
        lpMTagConfig.vars.push([ "visitor", "transactionID", tran_id ]);
        if (options.hasOwnProperty("unit")) {
            lpMTagConfig.vars.push([ "page", "unit", options.unit ]);
            lpMTagConfig.vars.push([ "unit", options.unit ]);
        }
        if (confirmationBool) {
            lpMTagConfig.vars.push([ "page", "PageName", getPageName(confirmationNavigationId) ]);
            lpMTagConfig.vars.push([ "page", "OrderNumber", tran_id ]);
            lpMTagConfig.loadTag();
        } else {
            lpMTagConfig.vars.push([ "page", "PageName", getPageName() ]);
        }
        lpSendData();
    }
    function init() {
        $(document).ready(function($) {
            oldIE = $("html").hasClass("lt-ie9");
            if (typeof meerkat.site === "undefined") return;
            if (typeof meerkat.site.liveChat === "undefined" || meerkat.site.liveChat.enabled === false) return;
            if (meerkat.site.isCallCentreUser) return;
            window.lpMTagConfig = _.extend(lpMTagConfig, meerkat.site.liveChat.config);
            options = _.extend({}, meerkat.site.liveChat.instance);
            window.lpMTagConfig = window.lpMTagConfig || {};
            window.lpMTagConfig.vars = window.lpMTagConfig.vars || [];
            window.lpMTagConfig.dynButton = window.lpMTagConfig.dynButton || [];
            window.lpMTagConfig.lpProtocol = document.location.toString().indexOf("https:") === 0 ? "https" : "http";
            window.lpMTagConfig.pageStartTime = new Date().getTime();
            if (!window.lpMTagConfig.pluginsLoaded) window.lpMTagConfig.pluginsLoaded = !1;
            window.lpMTagConfig.loadTag = function() {
                for (var a = document.cookie.split(";"), b = {}, c = 0; c < a.length; c++) {
                    var d = a[c].substring(0, a[c].indexOf("="));
                    b[d.replace(/^\s+|\s+$/g, "")] = a[c].substring(a[c].indexOf("=") + 1);
                }
                for (var a = b.HumanClickRedirectOrgSite, b = b.HumanClickRedirectDestSite, c = [ "lpTagSrv", "lpServer", "lpNumber", "deploymentID" ], d = !0, e = 0; e < c.length; e++) window.lpMTagConfig[c[e]] || (d = !1, 
                typeof console != "undefined" && console.log && console.log("LivePerson : lpMTagConfig." + c[e] + " is required and has not been defined before lpMTagConfig.loadTag()."));
                if (!window.lpMTagConfig.pluginsLoaded && d) window.lpMTagConfig.pageLoadTime = new Date().getTime() - window.lpMTagConfig.pageStartTime, 
                a = "?site=" + (a == window.lpMTagConfig.lpNumber ? b : window.lpMTagConfig.lpNumber) + "&d_id=" + window.lpMTagConfig.deploymentID + "&default=simpleDeploy", 
                lpAddMonitorTag(window.lpMTagConfig.deploymentConfigPath != null ? window.lpMTagConfig.lpProtocol + "://" + window.lpMTagConfig.deploymentConfigPath + a : window.lpMTagConfig.lpProtocol + "://" + window.lpMTagConfig.lpTagSrv + "/visitor/addons/deploy2.asp" + a), 
                window.lpMTagConfig.pluginsLoaded = !0;
            };
            function lpAddMonitorTag(a) {
                if (!window.lpMTagConfig.lpTagLoaded) {
                    if (typeof a == "undefined" || typeof a == "object") a = window.lpMTagConfig.lpMTagSrc ? window.lpMTagConfig.lpMTagSrc : window.lpMTagConfig.lpTagSrv ? window.lpMTagConfig.lpProtocol + "://" + window.lpMTagConfig.lpTagSrv + "/hcp/html/mTag.js" : "/hcp/html/mTag.js";
                    a.indexOf("http") !== 0 ? a = window.lpMTagConfig.lpProtocol + "://" + window.lpMTagConfig.lpServer + a + "?site=" + window.lpMTagConfig.lpNumber : a.indexOf("site=") < 0 && (a += a.indexOf("?") < 0 ? "?" : "&", 
                    a = a + "site=" + window.lpMTagConfig.lpNumber);
                    var b = document.createElement("script");
                    b.setAttribute("type", "text/javascript");
                    b.setAttribute("charset", "iso-8859-1");
                    b.setAttribute("src", a);
                    document.getElementsByTagName("head").item(0).appendChild(b);
                }
            }
            window.attachEvent ? window.attachEvent("onload", function() {
                window.lpMTagConfig.disableOnLoad || window.lpMTagConfig.loadTag();
            }) : window.addEventListener("load", function() {
                window.lpMTagConfig.disableOnLoad || window.lpMTagConfig.loadTag();
            }, !1);
            window.lpAddMonitorTag = lpAddMonitorTag;
            function lpSendData(a, b, c) {
                if (arguments.length > 0) window.lpMTagConfig.vars = window.lpMTagConfig.vars || [], 
                window.lpMTagConfig.vars.push([ a, b, c ]);
                if (typeof lpMTag != "undefined" && typeof window.lpMTagConfig.pluginCode != "undefined" && typeof window.lpMTagConfig.pluginCode.simpleDeploy != "undefined") {
                    var d = window.lpMTagConfig.pluginCode.simpleDeploy.processVars();
                    lpMTag.lpSendData(d, !0);
                }
            }
            function lpAddVars(a, b, c) {
                window.lpMTagConfig.vars = window.lpMTagConfig.vars || [];
                window.lpMTagConfig.vars.push([ a, b, c ]);
            }
            window.lpSendData = lpSendData;
            var $container = $('div[data-livechat="target"]');
            if ($container.length) {
                if (typeof options.button !== "undefined") {
                    var buttonHtml = "" + '<div id="' + options.button + '" data-livechat="button"></div>';
                    $container.append(buttonHtml);
                    $("#" + options.button).on("click", "a", function() {
                        lpMTagConfig.dynButton0.actionHook();
                    });
                }
            }
            function liveChatDomEvents(event) {
                var content = "";
                var $contentElem = $("#" + options.button);
                if ($contentElem.length) {
                    content = $contentElem.html();
                }
                if (content === "" || content == "<span></span>" || content == "<SPAN></SPAN>") {
                    $('[data-livechat="target"]').attr("data-livechat-state", false);
                } else {
                    $('[data-livechat="target"]').attr("data-livechat-state", true);
                }
            }
            if (!oldIE) {
                $(document).on("DOMSubtreeModified", '[data-livechat="target"]', _.debounce(liveChatDomEvents, 100));
            } else {
                $container.on("propertychange", _.debounce(liveChatDomEvents, 100));
            }
            meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function journeyEngineStepInit(journeyInitData) {
                var initialSlideIndex = journeyInitData.step.slideIndex + 1;
                var initialStepIndex = journeyInitData.step.stepIndex + 1;
                var latestNavigationId = journeyInitData.navigationId;
                fire(initialStepIndex);
                meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function journeyEngineSlideChange(journeyStepChangedData) {
                    var latestSlideIndex = journeyStepChangedData.step.slideIndex + 1;
                    var latestStepIndex = journeyStepChangedData.step.stepIndex + 1;
                    latestNavigationId = journeyStepChangedData.navigationId;
                    fire(latestStepIndex);
                });
            });
            liveChatDomEvents();
            $container = $('[data-livechat="target"]');
            if ($container.length) {
                var manualFireCall = $container.data("livechat-fire");
                if (typeof manualFireCall === "object") {
                    debug("manual fire", lpMTagConfig.vars);
                    fire(manualFireCall.step, manualFireCall.confirmation, manualFireCall.navigationId);
                }
            }
        });
    }
    meerkat.modules.register("liveChat", {
        init: init,
        fire: fire
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
        retrieveExternalCopy: null
    }, settings = {};
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
    }
    function applyEventListeners() {
        if (typeof Results.settings !== "undefined") {
            $(Results.settings.elements.page).on("click", ".btn-more-info", openBridgingPage);
            $(Results.settings.elements.page).on("click", ".btn-close-more-info", closeBridgingPage);
        }
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            closeBridgingPage();
        });
        $(document.body).on("click", ".btn-more-info-apply", function applyClick() {
            var $this = $(this);
            $this.addClass("inactive").addClass("disabled");
            meerkat.modules.loadingAnimation.showInside($this, true);
            _.defer(function deferApplyNow() {
                if (typeof settings.onBeforeApply == "function") {
                    settings.onBeforeApply();
                }
                Results.setSelectedProduct($this.attr("data-productId"));
                var product = Results.getSelectedProduct();
                if (product) {
                    if (typeof settings.onClickApplyNow == "function") {
                        settings.onClickApplyNow(product, applyCallback);
                    }
                } else {
                    applyCallback(false);
                }
            });
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
        if ($(".showDoc").length) {
            $(document.body).on("click", ".showDoc", function showTermsDocument(event) {
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
            });
        }
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
    }
    function showTemplate(moreInfoContainer) {
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
                meerkat.modules.utilities.scrollPageTo(".resultsHeadersBg", scrollToTopDuration, -$("#navbar-main").height(), function() {
                    if (typeof updatePosition == "function") {
                        updatePosition();
                        moreInfoContainer.css({
                            top: topPosition
                        });
                    }
                    moreInfoContainer.find(".more-info-content")[settings.showAction](animDuration, showTemplateCallback);
                    if (typeof settings.onAfterShowTemplate == "function") {
                        settings.onAfterShowTemplate();
                    }
                });
                totalDuration = animDuration + scrollToTopDuration;
            }
            isBridgingPageOpen = true;
            _.delay(function() {
                meerkat.messaging.publish(moduleEvents.bridgingPage.SHOW, {
                    isOpen: isBridgingPageOpen
                });
            }, totalDuration);
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackProductView",
                object: {
                    productID: product.productId,
                    vertical: meerkat.site.vertical
                }
            });
        });
    }
    function showModal() {
        prepareProduct(function moreInfoShowModalSuccess() {
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
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackProductView",
                object: {
                    productID: product.productId,
                    vertical: meerkat.site.vertical
                }
            });
        });
    }
    function closeBridgingPage() {
        if (isModalOpen) {
            hideModal();
        }
        if (isBridgingPageOpen) {
            hideTemplate(settings.container);
        }
        meerkat.modules.address.removeFromHash("moreinfo");
    }
    function hideTemplate(moreInfoContainer) {
        if (typeof settings.onBeforeHideTemplate == "function") {
            settings.onBeforeHideTemplate();
        }
        moreInfoContainer[settings.hideAction](400, function() {
            hideTemplateCallback(moreInfoContainer);
            if (typeof settings.onAfterHideTemplate == "function") {
                settings.onAfterHideTemplate();
            }
        });
    }
    function hideModal() {
        $("#" + modalId).modal("hide");
        $(".bridgingContainer, .more-info-content").hide();
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
        $.when(settings.retrieveExternalCopy(product)).then(successCallback, successCallback);
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
        applyCallback: applyCallback
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
        });
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange() {
            meerkat.modules.navMenu.close();
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function closeXsMenus() {
            meerkat.modules.navMenu.close();
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function openXsMenus() {
            if ($(".navbar-nav .open").length > 0) {
                meerkat.modules.navMenu.open();
            }
        });
        meerkat.messaging.publish(moduleEvents.READY, this);
    }
    meerkat.modules.register("navMenu", {
        init: initNavmenu,
        events: events,
        close: close,
        open: open,
        enable: enable,
        disable: disable
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        optIn: {}
    }, moduleEvents = events.optIn;
    function init() {}
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
        return meerkat.modules.comms.post({
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
        });
    }
    meerkat.modules.register("optIn", {
        init: init,
        events: events,
        fetch: fetch
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
        settings = _.extend({}, settings, instanceSettings);
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
        return navigator.userAgent.toLowerCase().indexOf("android") > -1;
    }
    function isChrome() {
        return navigator.userAgent.toLowerCase().indexOf("chrome") > -1;
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
    function isIos5() {
        if (isIos() && navigator.userAgent.match(/OS 5/)) {
            return true;
        }
        return false;
    }
    function isIos6() {
        if (isIos() && navigator.userAgent.match(/OS 6/)) {
            return true;
        }
        return false;
    }
    function isIos7() {
        if (isIos() && navigator.userAgent.match(/OS 7/)) {
            return true;
        }
        return false;
    }
    function getIEVersion() {
        var ua = window.navigator.userAgent;
        var msie = ua.indexOf("MSIE ");
        if (msie > 0) {
            return parseInt(ua.substring(msie + 5, ua.indexOf(".", msie)));
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
        isIE8: isIE8,
        isIE9: isIE9,
        isIE10: isIE10,
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
            placeholder.hide();
        }).on("blur.fakeplaceholder", "input[placeholder]", function() {
            var $this = $(this), placeholder = $this.data("fakeplaceholder");
            !$this.val() && placeholder.show();
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
        RESULTS_DATA_READY: "RESULTS_DATA_READY",
        RESULTS_SORTED: "RESULTS_SORTED"
    }, moduleEvents = events;
    var supertagEventMode = "Load";
    function write() {
        if (!_.isUndefined(Results.settings.rankings)) {
            var config = Results.settings.rankings;
            var externalTrackingData = [];
            var sorted = Results.getSortedResults();
            var filtered = Results.getFilteredResults();
            var vertical = meerkat.site.vertical;
            var sortedAndFiltered = [];
            for (var i = 0; i < sorted.length; i++) {
                for (var j = 0; j < filtered.length; j++) {
                    if (sorted[i] == filtered[j]) {
                        sortedAndFiltered[sortedAndFiltered.length] = sorted[i];
                    }
                }
            }
            var data = {
                rootPath: vertical,
                rankBy: Results.getSortBy() + "-" + Results.getSortDir(),
                rank_count: sortedAndFiltered.length,
                transactionId: meerkat.modules.transactionId.get()
            };
            for (var k = 0; k < sortedAndFiltered.length; k++) {
                var productId = Object.byString(sortedAndFiltered[k], config.paths.productId);
                var price = Object.byString(sortedAndFiltered[k], config.paths.price);
                data[config.parameters.productId + k] = productId;
                if (price) {
                    data[config.parameters.price + k] = price;
                }
                var rank = k + 1;
                externalTrackingData.push({
                    productID: productId,
                    ranking: rank
                });
            }
            meerkat.modules.comms.post({
                url: "ajax/write/quote_ranking.jsp",
                data: data,
                cache: false,
                errorLevel: "silent",
                onSuccess: function onRankingsWritten() {
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: "trackQuoteProductList",
                        object: {
                            products: externalTrackingData,
                            vertical: meerkat.site.vertical
                        }
                    });
                    supertagEventMode = "Refresh";
                },
                onError: function onWriteRankingsError(jqXHR, textStatus, errorThrown, settings, resultData) {
                    meerkat.modules.errorHandling.error({
                        message: "Failed to write ranking results.",
                        page: "core:resultsRankings.js:write()",
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
    function registerSubscriptions() {
        switch (meerkat.site.vertical) {
          case "car":
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, write);
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, write);
            break;

          default:
            break;
        }
    }
    function initResultsRankings() {
        var self = this;
        $(document).ready(function() {
            registerSubscriptions();
        });
    }
    meerkat.modules.register("resultsRankings", {
        init: initResultsRankings,
        events: moduleEvents,
        write: write
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
            if ($.inArray(meerkat.site.vertical, [ "car", "ip", "life" ]) !== -1) {
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
                    url: "ajax/json/save_email_quote_mysql.jsp",
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
            if ($.inArray(meerkat.site.vertical, [ "car", "ip", "life", "health" ]) !== -1) {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteEvent",
                    object: {
                        action: "Save",
                        transactionID: transactionId,
                        vertical: meerkat.site.vertical
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    function poke() {
        sessionExpiry.poke();
    }
    function initSession() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(event) {
            poke();
        });
    }
    meerkat.modules.register("session", {
        init: initSession,
        poke: poke
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
    var meerkat = window.meerkat;
    var events = {
        tracking: {
            TOUCH: "TRACKING_TOUCH",
            EXTERNAL: "TRACKING_EXTERNAL"
        }
    }, moduleEvents = events.tracking;
    function recordTouch(touchType, touchComment, includeFormData, callback) {
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
        meerkat.modules.comms.post({
            url: "ajax/json/access_touch.jsp",
            data: data,
            errorLevel: "silent",
            onSuccess: function recordTouchSuccess(result) {
                if (typeof callback === "function") callback(result);
            }
        });
    }
    function recordSupertag(method, object) {
        var value;
        try {
            if (typeof object === "function") {
                value = object();
            } else {
                value = object;
            }
            if (typeof superT === "undefined") {
                throw "Supertag is undefined";
            }
            if (typeof value.brandCode === "undefined") {
                value.brandCode = meerkat.site.tracking.brandCode;
            }
            if (value.email !== null && value.email !== "" && value.emailID === null) {
                getEmailId(value.email, value.marketOptIn, value.okToCall, function getEmailId(emailId) {
                    value.emailID = emailId;
                    value.email = null;
                    superT[method](value);
                    meerkat.logging.info("Supertag", method, value);
                });
            } else {
                superT[method](value);
                meerkat.logging.info("Supertag", method, value);
            }
        } catch (e) {
            meerkat.logging.info("Supertag catch", method, value, e);
        }
    }
    function getEmailId(emailAddress, marketing, oktocall, callback) {
        meerkat.modules.comms.post({
            url: "ajax/json/get_email_id.jsp",
            data: {
                vertical: meerkat.site.vertical,
                email: emailAddress,
                m: marketing,
                o: oktocall
            },
            errorLevel: "silent",
            onSuccess: function onSuccess(result) {
                callback(result.emailId);
            }
        });
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
            recordTouch(eventObject.touchType, eventObject.touchComment, includeFormData, eventObject.callback);
        });
        meerkat.messaging.subscribe(moduleEvents.EXTERNAL, function(eventObject) {
            if (typeof eventObject === "undefined") return;
            recordSupertag(eventObject.method, eventObject.object);
        });
    }
    meerkat.modules.register("tracking", {
        init: initTracking,
        events: events,
        recordTouch: recordTouch,
        recordSupertag: recordSupertag
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        transactionId: {
            CHANGED: "CHANGED"
        }
    }, moduleEvents = events.transactionId;
    var transactionId, waitingOnNewTransactionId = false;
    var $transactionId;
    function init() {
        setTransactionIdFromPage();
        jQuery(document).ready(function($) {
            $transactionId = $(".transactionId");
            set(transactionId);
            updateSimples();
        });
    }
    function get() {
        if (typeof transactionId === "undefined") {
            setTransactionIdFromPage();
        }
        return transactionId;
    }
    function set(newTransactionId) {
        transactionId = newTransactionId;
        render();
        updateSimples();
    }
    function setTransactionIdFromPage() {
        if (meerkat.site.initialTransactionId !== null && typeof meerkat.site.initialTransactionId === "number") {
            transactionId = meerkat.site.initialTransactionId;
            meerkat.site.initialTransactionId = null;
        }
    }
    function fetch(isAsync, actionId, retryAttempts, callback) {
        meerkat.modules.comms.post({
            url: "ajax/json/get_transactionid.jsp",
            dataType: "json",
            async: isAsync,
            errorLevel: "silent",
            data: {
                quoteType: meerkat.site.vertical,
                id_handler: actionId
            },
            onSuccess: function fetchTransactionIdSuccess(msg) {
                if (msg.transaction_id !== transactionId) {
                    set(msg.transaction_id);
                    meerkat.messaging.publish(moduleEvents.CHANGED, {
                        transactionId: transactionId
                    });
                }
                if (typeof callback === "function") {
                    callback(transactionId);
                }
            },
            onError: function fetchTransactionIdError(jqXHR, textStatus, errorThrown, settings, resultData) {
                if (retryAttempts > 0 && waitingOnNewTransactionId) {
                    fetch(isAsync, data, retryAttempts - 1, callback);
                } else {
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
        set: set,
        getNew: getNew
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
    meerkat.modules.register("utilities", {
        slugify: slugify,
        scrollPageTo: scrollPageTo,
        getUTCToday: UTCToday,
        returnAge: returnAge,
        returnDate: returnDate
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        validation: {}
    }, moduleEvents = events.validation;
    var $form = null;
    function init() {
        jQuery(document).ready(function($) {
            $form = $("#mainform");
        });
    }
    function isValid($element, displayErrors) {
        if (displayErrors) {
            return $element.valid();
        }
        return $form.validate().check($element) === false ? false : true;
    }
    meerkat.modules.register("validation", {
        init: init,
        events: events,
        isValid: isValid
    });
})(jQuery);

jQuery.fn.extend({
    isValid: function(displayErrors) {
        return meerkat.modules.validation.isValid($(this), displayErrors);
    }
});

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {
        writeQuote: {}
    }, moduleEvents = events.writeQuote;
    function init() {}
    function write(extraDataToSave, triggerFatalError, callback) {
        var data = [];
        _.extend(data, meerkat.modules.journeyEngine.getFormData());
        data.push({
            name: "quoteType",
            value: meerkat.site.vertical
        });
        data.push({
            name: "stage",
            value: meerkat.modules.journeyEngine.getCurrentStep().navigationId
        });
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
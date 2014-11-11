////////////////////////////////////////////////////////////////
//// MEERKAT.LOGGING                                        ////
////--------------------------------------------------------////
//// Please be aware meerkat.logging is currently mostly    ////
//// shameless integration of driftwood.js because it's     ////
//// a good start. Because i wanted it to live under        ////
//// the meerkat namespace it has changes. They are noted   ////
//// are noted before, through & at the bottom of the file. ////
//// Changes might be made here to handle the right         ////
//// format for the .jsp which inserts logs into the db.    ////
////--------------------------------------------------------////
//// REQUIRES: meerkat.js                                   ////
////--------------------------------------------------------////
//// Driftwood.js file included verbatim below.             ////
////////////////////////////////////////////////////////////////

//JSHINT IGNORES DEFINED HERE:
/*jshint -W061 */ //Ignore warning about the use of eval()
/*jshint -W058 */ //Missing the optional () on constructor invokation
/*jshint -W079 */ //Overrides console, and that's okay.
/*jshint -W020 */ //Assigns to JSON which is read only, and that's okay for IE.
/*jshint -W057 */ //var Driftwood = new function() probably doesn't need the new, but since it was from driftwood i'm leaving it for safety.
//Line 302 seems to cause these:
/*jshint -W004 */ //Already defined variables
/*jshint -W083 */ //Don't make functions within a loop

//////////////////////////////////////////////////////////////
//// MEERKAT.LOGGING                                      ////
////------------------------------------------------------////
//// Customisations are included after this line.         ////
////------------------------------------------------------////
// Bind in the meerkat namespace and define variables
	//var meerkat = window.meerkat;
	meerkat.logging = {};
	//meerkat.logging.logs = {}; //Experimental. TBA.
////------------------------------------------------------////
//// Customisations finish before this line line.         ////
////------------------------------------------------------////
//////////////////////////////////////////////////////////////


// **Driftwood.js** is a super simple logging and exception tracking library for client side javascript. Works in all major browsers.
//
//[Driftwood on Github](https://github.com/errplane/driftwood.js)
//
//Matthew Kanwisher [Errplane Inc](http://errplane.com)
//MIT License
//Copyright 2012 Errplane

// Driftwood namespace is a static namespace for logging, if you want instances of loggers do:
//
//      var logger = new Driftwood.logger();


//TODO REMOVE
var Driftwood = new function() {

	this.logger  = function() {
		var levels = ["NONE", "DEBUG", "INFO", "ERROR", "EXCEPTION", "NONE"];
		//Don't change the config directly. Instead use the helper methods below.
		var config =  {
				consoleLevel: "DEBUG", //This get changed if you change the environment
				consoleLevelId: 0,
				exceptionLevel: "NONE", //In dev you probably don't want to transmit exceptions to the server
				exceptionLevelId: 99,
				mode: "development", //This should either be development or production
				serverPath: "/exceptions/notify?payload=",
				applicationName: "js_client", // this should be overriden by the user
				cors: true //default to cross origin sending of logs because the ajax implementation isn't done.
			};
		var findLevel = function(level) {
			return levels.indexOf(level.toUpperCase());
		};

		//Generates the script tag, you could replace this implementation with one that loads images instead
		function genScriptTag(src) {
			var script = document.createElement("script");
			script.src = src;
			document.body.appendChild(script);
		}

		function postViaAjax(src, data){
			debugger;
		}

		function genExceptionUrl(error) {
			var url = config.serverPath + encodeURIComponent(JSON.stringify(error));
			return url;
		}

		//While this function is technically supposed to be private, we still expose it so you can modify it.
		function createBlackBox(error) {
			var blackBox = {
				"application_name": config.applicationName,
				"message": error || "",

				// Request
				"url": window.location.toString(),
				"language":"javascript",
				"custom_data": {
					"hostname": window.location.hostname,
					"user_agent": navigator.userAgent || "",
					"referrer": document.referrer || "",
					"cookies": document.cookie || ""
				},
				"backtrace": getBackTrace(error),
				"exception_class": "Javascript#Unknown" //TODO figure out what the class should be
			};
			return blackBox;
		}

		//You can pass an exception or string to this function
		function getBackTrace(message, url, line) {
				var backTrace = ["no backtrace"];
				if (typeof message === "object") {
					backTrace = printStackTrace({"e": message});
				} else {
					backTrace = printStackTrace();
				}
				return backTrace;
		}


		//The actually function that sends the data to the server
		function transmit (message, additionalData) {
			var e = null;
			if (typeof message === "object") {
				e = message;
				message = e.message;
			}

			var error = createBlackBox(message, additionalData);
			var src = genExceptionUrl(error);
			//For cross origin domains use a script tag
			if(config.cors === true) {
				genScriptTag(src);
			} else {
				postViaAjax(src);
			}

		}

		var loggedMessages = [];

		function hasLoggedMessage(errorString) {
			for(var i = 0; i < loggedMessages.length; i++) {
				if(loggedMessages[i] === errorString)
					return true;
			}

			return false;
		}

		function log(args, level, fn) {
			var levelId = findLevel(level);
			var d = new Date();

			// CUSTOMISATION BY KV (... and a little by CD...) - NOT PART OF DRIFTWOOD.JS !!!!

			var originalErrorMessage = args[0];

			if( levelId >= config.consoleLevelId ) {
				args[0] =  level + ":" + "["  + ISODateString(d) + "] " + args[0] ;
			}

			if( levelId >= config.exceptionLevelId) {
				var message = "Sorry, we have encountered an error. Please try again.";
				if(config.mode == "development"){
					message += "["+originalErrorMessage+"]";
				}

				var logDetails = {
					errorLevel: "silent",
					page: 'meerkat.logging.js',
					message: message,
					description: originalErrorMessage
				};

				var logReferenceObject = {
					message: logDetails.message,
					page: logDetails.page
				};

				// Adding a little bit more info to our logs...
				if(meerkat.site.useNewLogging) {
					logDetails.data = {};

					if(typeof args[1] !== 'undefined') {
						logDetails.data.stack = args[1];
						logDetails.data.stack.error = args[0];

						logReferenceObject.stack = logDetails.data.stack.stack;
					} else {
						logDetails.data.stack = args[0];
					}

					// Get some information about the user
					logDetails.data.browser = {
						userAgent: navigator.userAgent || "",
						referrer: document.referrer || "",
						cookiesEnabled: navigator.cookieEnabled || ""
					};
				}

				var logReference = JSON.stringify(logReferenceObject).replace(/\s{1,}/g, ' ');

				if(!hasLoggedMessage(logReference)) {
					// This displays an error message to the user and logs it on the server.
					meerkat.modules.errorHandling.error(logDetails);
					loggedMessages.push(logReference);
				}
			}

			if (config.mode !== 'production' && navigator.appName != 'Microsoft Internet Explorer') {
				if (typeof fn !== 'undefined' && typeof fn.apply === 'function') {
					fn.apply(console,  Array.prototype.slice.call(args));
				}
			}
		}

		return {
			// Creates a notification URL
			// Currently were not validating that urls are under 2048 charecters, so this could cause problems in IE.
			// Will fix this in next rev
			//While this function is technically supposed to be private, we still expose it so you can modify it.

			//Its safe to use this function with external servers since we do everything on the query string
			setServerPath: function(murl) {
				config.serverPath = murl;
			},
			env: function(menv) {
				menv = menv.toLowerCase();
				if(menv == "development") {
					config.consoleLevel = "DEBUG";
					config.exceptionLevel = "none";
					config.consoleLevelId = 0;
					config.exceptionLevelId = 4;
					config.mode = menv;
				} else if(menv == "production") {
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
				if( id > -1 ) {
					config.consoleLevel = level.toUpperCase();
					config.consoleLevelId = id;
				} else {
					console.log("Setting an invalid log level: " + level);
				}
			},
			exceptionLevel: function(level) {
				var id = findLevel(level);
				if( id > -1 ) {
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
	this.applicationName = function(appname){
		defaultLogger.applicationName(appname);
	};

	//Convience methods around the logger to have a static instance
	this.debug = defaultLogger.debug;
	this.info = defaultLogger.info;
	this.error = defaultLogger.error;

	this.env = function(mode) {
		defaultLogger.env(mode);
	};

	this.setServerPath = function(u) {
		defaultLogger.setServerPath(u);
	};

	this.exceptionLevel =  function(level) {
		if(level != "NONE") {
			defaultLogger.exceptionLevel(level);
		}
		//NONE is a special case, we will override our methods and use the console.log methods
		else {
			this.debug = _.bind(console.debug, console);
			this.info = _.bind(console.info, console);
			this.error = _.bind(console.error, console);
			this.log = _.bind(console.log, console);
		}
	};

	this.logLevel =  function(level) {
		defaultLogger.logLevel(level);
	};

};

//Mozilla implementation of Array.indexOf, for IE < 9
//See http://stackoverflow.com/questions/143847/best-way-to-find-an-item-in-a-javascript-array
if(!Array.prototype.indexOf){Array.prototype.indexOf=function(searchElement){"use strict";if(this===void 0||this===null)throw new TypeError();var t=Object(this);var len=t.length>>>0;if(len===0)return-1;var n=0;if(arguments.length>0){n=Number(arguments[1]);if(n!==n)n=0;else if(n!==0&&n!==(1/0)&&n!==-(1/0))n=(n>0||-1)*Math.floor(Math.abs(n))}if(n>=len)return-1;var k=n>=0?n:Math.max(len-Math.abs(n),0);for(;k<len;k++){if(k in t&&t[k]===searchElement)return k}return-1}}

//https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference:Global_Objects:Date
function ISODateString(d){function pad(n){return n<10?'0'+n:n}return d.getUTCFullYear()+'-'+pad(d.getUTCMonth()+1)+'-'+pad(d.getUTCDate())+'T'+pad(d.getUTCHours())+':'+pad(d.getUTCMinutes())+':'+pad(d.getUTCSeconds())+'Z'}

// JSON support for older browsers. Public domain.
// https://github.com/douglascrockford/JSON-js/blob/master/json2.js
var JSON;JSON||(JSON={}),function(){function f(a){return a<10?"0"+a:a}function quote(a){return escapable.lastIndex=0,escapable.test(a)?'"'+a.replace(escapable,function(a){var b=meta[a];return typeof b=="string"?b:"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4)})+'"':'"'+a+'"'}function str(a,b){var c,d,e,f,g=gap,h,i=b[a];i&&typeof i=="object"&&typeof i.toJSON=="function"&&(i=i.toJSON(a)),typeof rep=="function"&&(i=rep.call(b,a,i));switch(typeof i){case"string":return quote(i);case"number":return isFinite(i)?String(i):"null";case"boolean":case"null":return String(i);case"object":if(!i)return"null";gap+=indent,h=[];if(Object.prototype.toString.apply(i)==="[object Array]"){f=i.length;for(c=0;c<f;c+=1)h[c]=str(c,i)||"null";return e=h.length===0?"[]":gap?"[\n"+gap+h.join(",\n"+gap)+"\n"+g+"]":"["+h.join(",")+"]",gap=g,e}if(rep&&typeof rep=="object"){f=rep.length;for(c=0;c<f;c+=1)typeof rep[c]=="string"&&(d=rep[c],e=str(d,i),e&&h.push(quote(d)+(gap?": ":":")+e))}else for(d in i)Object.prototype.hasOwnProperty.call(i,d)&&(e=str(d,i),e&&h.push(quote(d)+(gap?": ":":")+e));return e=h.length===0?"{}":gap?"{\n"+gap+h.join(",\n"+gap)+"\n"+g+"}":"{"+h.join(",")+"}",gap=g,e}}"use strict",typeof Date.prototype.toJSON!="function"&&(Date.prototype.toJSON=function(a){return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+f(this.getUTCMonth()+1)+"-"+f(this.getUTCDate())+"T"+f(this.getUTCHours())+":"+f(this.getUTCMinutes())+":"+f(this.getUTCSeconds())+"Z":null},String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(a){return this.valueOf()});var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},rep;typeof JSON.stringify!="function"&&(JSON.stringify=function(a,b,c){var d;gap="",indent="";if(typeof c=="number")for(d=0;d<c;d+=1)indent+=" ";else typeof c=="string"&&(indent=c);rep=b;if(!b||typeof b=="function"||typeof b=="object"&&typeof b.length=="number")return str("",{"":a});throw new Error("JSON.stringify")}),typeof JSON.parse!="function"&&(JSON.parse=function(text,reviver){function walk(a,b){var c,d,e=a[b];if(e&&typeof e=="object")for(c in e)Object.prototype.hasOwnProperty.call(e,c)&&(d=walk(e,c),d!==undefined?e[c]=d:delete e[c]);return reviver.call(a,b,e)}var j;text=String(text),cx.lastIndex=0,cx.test(text)&&(text=text.replace(cx,function(a){return"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4)}));if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,"")))return j=eval("("+text+")"),typeof reviver=="function"?walk({"":j},""):j;throw new SyntaxError("JSON.parse")})}()

// Universal stack trace method. Public domain.
// https://raw.github.com/eriwen/javascript-stacktrace/master/stacktrace.js
function printStackTrace(a){a=a||{guess:!0};var b=a.e||null;a=!!a.guess;var c=new printStackTrace.implementation,b=c.run(b);return a?c.guessAnonymousFunctions(b):b}printStackTrace.implementation=function(){};printStackTrace.implementation.prototype={run:function(a,b){a=a||this.createException();b=b||this.mode(a);return"other"===b?this.other(arguments.callee):this[b](a)},createException:function(){try{this.undef()}catch(a){return a}},mode:function(a){return a.arguments&&a.stack?"chrome":a.stack&&a.sourceURL?"safari":a.stack&&a.number?"ie":a.stack&&a.fileName?"firefox":a.message&&a["opera#sourceloc"]?!a.stacktrace||-1<a.message.indexOf("\n")&&a.message.split("\n").length>a.stacktrace.split("\n").length?"opera9":"opera10a":a.message&&a.stack&&a.stacktrace?0>a.stacktrace.indexOf("called from line")?"opera10b":"opera11":a.stack&&!a.fileName?"chrome":"other"},instrumentFunction:function(a,b,c){a=a||window;var d=a[b];a[b]=function(){c.call(this,printStackTrace().slice(4));return a[b]._instrumented.apply(this,arguments)};a[b]._instrumented=d},deinstrumentFunction:function(a,b){a[b].constructor===Function&&a[b]._instrumented&&a[b]._instrumented.constructor===Function&&(a[b]=a[b]._instrumented)},chrome:function(a){return(a.stack+"\n").replace(/^[\s\S]+?\s+at\s+/," at ").replace(/^\s+(at eval )?at\s+/gm,"").replace(/^([^\(]+?)([\n$])/gm,"{anonymous}() ($1)$2").replace(/^Object.<anonymous>\s*\(([^\)]+)\)/gm,"{anonymous}() ($1)").replace(/^(.+) \((.+)\)$/gm,"$1@$2").split("\n").slice(0,-1)},safari:function(a){return a.stack.replace(/\[native code\]\n/m,"").replace(/^(?=\w+Error\:).*$\n/m,"").replace(/^@/gm,"{anonymous}()@").split("\n")},ie:function(a){return a.stack.replace(/^\s*at\s+(.*)$/gm,"$1").replace(/^Anonymous function\s+/gm,"{anonymous}() ").replace(/^(.+)\s+\((.+)\)$/gm,"$1@$2").split("\n").slice(1)},firefox:function(a){return a.stack.replace(/(?:\n@:0)?\s+$/m,"").replace(/^(?:\((\S*)\))?@/gm,"{anonymous}($1)@").split("\n")},opera11:function(a){var b=/^.*line (\d+), column (\d+)(?: in (.+))? in (\S+):$/;a=a.stacktrace.split("\n");for(var c=[],d=0,f=a.length;d<f;d+=2){var e=b.exec(a[d]);if(e){var g=e[4]+":"+e[1]+":"+e[2],e=e[3]||"global code",e=e.replace(/<anonymous function: (\S+)>/,"$1").replace(/<anonymous function>/,"{anonymous}");c.push(e+"@"+g+" -- "+a[d+1].replace(/^\s+/,""))}}return c},opera10b:function(a){var b=/^(.*)@(.+):(\d+)$/;a=a.stacktrace.split("\n");for(var c=[],d=0,f=a.length;d<f;d++){var e=b.exec(a[d]);e&&c.push((e[1]?e[1]+"()":"global code")+"@"+e[2]+":"+e[3])}return c},opera10a:function(a){var b=/Line (\d+).*script (?:in )?(\S+)(?:: In function (\S+))?$/i;a=a.stacktrace.split("\n");for(var c=[],d=0,f=a.length;d<f;d+=2){var e=b.exec(a[d]);e&&c.push((e[3]||"{anonymous}")+"()@"+e[2]+":"+e[1]+" -- "+a[d+1].replace(/^\s+/,""))}return c},opera9:function(a){var b=/Line (\d+).*script (?:in )?(\S+)/i;a=a.message.split("\n");for(var c=[],d=2,f=a.length;d<f;d+=2){var e=b.exec(a[d]);e&&c.push("{anonymous}()@"+e[2]+":"+e[1]+" -- "+a[d+1].replace(/^\s+/,""))}return c},other:function(a){for(var b=/function\s*([\w\-$]+)?\s*\(/i,c=[],d,f,e=Array.prototype.slice;a&&a.arguments&&10>c.length;){d=b.test(a.toString())?RegExp.$1||"{anonymous}":"{anonymous}";f=e.call(a.arguments||[]);c[c.length]=d+"("+this.stringifyArguments(f)+")";try{a=a.caller}catch(g){c[c.length]=""+g;break}}return c},stringifyArguments:function(a){for(var b=[],c=Array.prototype.slice,d=0;d<a.length;++d){var f=a[d];void 0===f?b[d]="undefined":null===f?b[d]="null":f.constructor&&(b[d]=f.constructor===Array?3>f.length?"["+this.stringifyArguments(f)+"]":"["+this.stringifyArguments(c.call(f,0,1))+"..."+this.stringifyArguments(c.call(f,-1))+"]":f.constructor===Object?"#object":f.constructor===Function?"#function":f.constructor===String?'"'+f+'"':f.constructor===Number?f:"?")}return b.join(",")},sourceCache:{},ajax:function(a){var b=this.createXMLHTTPObject();if(b)try{return b.open("GET",a,!1),b.send(null),b.responseText}catch(c){}return""},createXMLHTTPObject:function(){for(var a,b=[function(){return new XMLHttpRequest},function(){return new ActiveXObject("Msxml2.XMLHTTP")},function(){return new ActiveXObject("Msxml3.XMLHTTP")},function(){return new ActiveXObject("Microsoft.XMLHTTP")}],c=0;c<b.length;c++)try{return a=b[c](),this.createXMLHTTPObject=b[c],a}catch(d){}},isSameDomain:function(a){return"undefined"!==typeof location&&-1!==a.indexOf(location.hostname)},getSource:function(a){a in this.sourceCache||(this.sourceCache[a]=this.ajax(a).split("\n"));return this.sourceCache[a]},guessAnonymousFunctions:function(a){for(var b=0;b<a.length;++b){var c=/^(.*?)(?::(\d+))(?::(\d+))?(?: -- .+)?$/,d=a[b],f=/\{anonymous\}\(.*\)@(.*)/.exec(d);if(f){var e=c.exec(f[1]);e&&(c=e[1],f=e[2],e=e[3]||0,c&&this.isSameDomain(c)&&f&&(c=this.guessAnonymousFunction(c,f,e),a[b]=d.replace("{anonymous}",c)))}}return a},guessAnonymousFunction:function(a,b,c){var d;try{d=this.findFunctionName(this.getSource(a),b)}catch(f){d="getSource failed with url: "+a+", exception: "+f.toString()}return d},findFunctionName:function(a,b){for(var c=/function\s+([^(]*?)\s*\(([^)]*)\)/,d=/['"]?([$_A-Za-z][$_A-Za-z0-9]*)['"]?\s*[:=]\s*function\b/,f=/['"]?([$_A-Za-z][$_A-Za-z0-9]*)['"]?\s*[:=]\s*(?:eval|new Function)\b/,e="",g,l=Math.min(b,20),h,k=0;k<l;++k)if(g=a[b-k-1],h=g.indexOf("//"),0<=h&&(g=g.substr(0,h)),g)if(e=g+e,(g=d.exec(e))&&g[1]||(g=c.exec(e))&&g[1]||(g=f.exec(e))&&g[1])return g[1];return"(?)"}};

if (typeof console == "undefined") {
	var console = { log: function() {} };
}


//Fix IE9
if (Function.prototype.bind && console && typeof console.log == "object") {
	[
		"log","info","warn","error","assert","dir","clear","profile","profileEnd"
	].forEach(function (method) {
			console[method] = this.bind(console[method], console);
	}, Function.prototype.call);
}

if(typeof console.debug == "undefined") {
	console.debug = console.log;
}


//simple Driftwood alias
//window.D = Driftwood;

//////////////////////////////////////////////////////////////
//// MEERKAT.LOGGING                                      ////
////------------------------------------------------------////
//// Customisations are included after this line.         ////
////------------------------------------------------------////

meerkat.logging.logger = Driftwood;

//The following are bound to the logging namespace instead of
//logging.logger since it's less to type, and makes sense.
//The full driftwood object is available at 'logger' of course.

//Set up the standard logger for use - save people thinking about it.
//Other loggers could be set up, like one for each vertical.
meerkat.logging.debug = meerkat.logging.logger.debug; //yes this is ridiculous but only needs to be written here.
meerkat.logging.info = meerkat.logging.logger.info;
meerkat.logging.error = meerkat.logging.logger.error;
meerkat.logging.exception = meerkat.logging.logger.exception;

// Global error handler
window.onerror = function(message, url, line) {
	Driftwood.exception(message, {"url": url, "line": line});
};

//////////////////////////////////////////////////////////
//New Logging
//This new logging method will remove the need for the
//following libraries:
//- StackTraceJS
//////////////////////////////////////////////////////////
var wrapMethod, polyFill, hijackTimeFunctions;

function initializeNewLogging() {
	wrapMethod = function (func) {
		// Ensure we only wrap the function once.
		if (!func._wrapped) {
			func._wrapped = function () {
				try{
					func.apply(this, arguments);
				} catch(e) {
					// Firefox
					if(e.message && e.fileName && e.lineNumber && e.columnNumber && e.stack) {
						window.onerror(e.message, e.fileName, e.lineNumber, e.columnNumber, e);
					// Safari
					} else if(e.message && e.sourceURL && e.line) {
						window.onerror(e.message, e.sourceURL, e.line, null, e);
					// Everything else
					} else {
						throw e;
					}
				}
			}
		}
		return func._wrapped;
	};

	polyFill = function (obj, name, makeReplacement) {
		var original = obj[name];
		var replacement = makeReplacement(original);
		obj[name] = replacement;

		if (window.undo) {
			window.undo.push(function () {
				obj[name] = original;
			});
		}
	};

	hijackTimeFunctions = function (_super) {
		// Note, we don't do `_super.call` because that doesn't work on IE 8,
		// luckily this is implicitly window so it just works everywhere.
		//
		// setTimout in all browsers except IE <9 allows additional parameters
		// to be passed, so in order to support these without resorting to call/apply
		// we need an extra layer of wrapping.
		return function (f, t) {
			if (typeof f === "function") {
				f = wrapMethod(f);
				var args = Array.prototype.slice.call(arguments, 2);
				return _super(function () {
					f.apply(this, args);
				}, t);
			} else {
				return _super(f, t);
			}
		};
	};

	window.onerror = function(message, file, line, column, error) {
		var column = column || (window.event && window.event.errorCharacter);
		var stack;
		var url = file.substring(file.lastIndexOf('/ctm'), file.length);

		if(!error) {
			stack = [];
			var f = arguments.callee.caller;
			while (f) {
				stack.push(f.name);
				f = f.caller;
			}
			stack = stack.join('');
		} else {
			stack = error.stack;
		}

		// Remove linebreaks
		stack = stack.replace(/(\r\n|\n|\r)/gm, '');

		Driftwood.exception(message, {
			url: window.location.pathname + window.location.hash,
			file: url,
			line: parseInt(line),
			column: parseInt(column),
			stack: stack
		});
	};

	// Set up polyFills
	polyFill(window, "setTimeout", hijackTimeFunctions);
	polyFill(window, "setInterval", hijackTimeFunctions);

	if (window.requestAnimationFrame) {
		polyFill(window, "requestAnimationFrame", hijackTimeFunctions);
	}

	if (window.setImmediate) {
		polyFill(window, "setImmediate", function (_super) {
			return function (f) {
				var args = Array.prototype.slice.call(arguments);
				args[0] = wrapMethod(args[0]);
				return _super.apply(this, args);
			};
		});
	}

	"EventTarget Window Node ApplicationCache AudioTrackList ChannelMergerNode CryptoOperation EventSource FileReader HTMLUnknownElement IDBDatabase IDBRequest IDBTransaction KeyOperation MediaController MessagePort ModalWindow Notification SVGElementInstance Screen TextTrack TextTrackCue TextTrackList WebSocket WebSocketWorker Worker XMLHttpRequest XMLHttpRequestEventTarget XMLHttpRequestUpload".replace(/\w+/g, function (global) {
		var prototype = window[global] && window[global].prototype;
		if (prototype && prototype.hasOwnProperty && prototype.hasOwnProperty("addEventListener")) {
			polyFill(prototype, "addEventListener", function (_super) {
				return function (e, f, capture, secure) {
					// HTML lets event-handlers be objects with a handlEvent function,
					// we need to change f.handleEvent here, as self.wrap will ignore f.
					if (f && f.handleEvent) {
						f.handleEvent = wrapMethod(f.handleEvent, {eventHandler: true});
					}
					return _super.call(this, e, wrapMethod(f, {eventHandler: true}), capture, secure);
				};
			});

			// We also need to hack removeEventListener so that you can remove any
			// event listeners.
			polyFill(prototype, "removeEventListener", function (_super) {
				return function (e, f, capture, secure) {
					_super.call(this, e, f, capture, secure);
					return _super.call(this, e, wrapMethod(f), capture, secure);
				};
			});
		}
	});
}

//////////////////////////////////////////////////////////
// Kick off logging configuration from within meerkat.js:
//////////////////////////////////////////////////////////

//Configure the settings for the meerkat.logger from the site object already set up by meerkat.
meerkat.logging.init = function () {
	// Use the new error logging code.
	// If useNewLogging is enabled then we get yummy stack traces
	// and better error logging in our DB.
	//
	// One day we will remove the old code in favour of this...
	if(meerkat.site.useNewLogging) {
		initializeNewLogging();
	}

	var theAppName = '';
	if (meerkat.site.vertical !== '') {
		theAppName = '['+meerkat.site.vertical+']';
	} else {
		theAppName = '';
	}
	meerkat.logging.logger.applicationName(theAppName);

	//Set server path and default environment level from site object.
	//We could set custom exception level values from 1-4 here
	//To force more errors to be posted to the server.
	var devStateString = meerkat.site.showLogging ? "development" : "production";
	meerkat.logging.logger.env(devStateString);
	meerkat.logging.info("[logging]","Sergei sees you runnings on "+meerkat.site.environment+" ("+devStateString+"s "+"mode).");

};
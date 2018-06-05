////////////////////////////////////////////////////////////////
//// MEERKAT.MODULES                                        ////
////--------------------------------------------------------////
//// Simple module loader defining a registration and       ////
//// initialisation handler which uses the meerkat .init()  ////
//// that calls at document.ready() and calls modules in    ////
//// an ordered manner for dependency.                      ////
//// It also provides uniqueness via registered naming.     ////
////--------------------------------------------------------////
//// If later implementing auto dependency handling         ////
//// between modules when concatenating all our js files,   ////
//// We could use browserify or add it to the               ////
//// meerkat.modules.register() functionality below.        ////
////--------------------------------------------------------////
//// REQUIRES: meerkat.js                                   ////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info,
		modules = {},
		events = {},
		initStack = [];


	///////////////////////////////////////////////////////////////////
	// Register new module. We could potentially flag deps one day.
	///////////////////////////////////////////////////////////////////

	function register(moduleName, module) {
		if (modules[moduleName]) {
			throw "A module is already defined with the key: "+moduleName;
		}

		modules[moduleName] = module;

		modules[moduleName].moduleName = moduleName;

		if (typeof module.init === "function") {
			initStack.push(moduleName);
		}

		// Register module's events
		if (typeof module.events === 'function') {
			$.extend(true, events, modules[moduleName].events());
		}
		else if (typeof modules.events === 'object') {
			$.extend(true, events, modules[moduleName].events);
		}
	}

	function extend(moduleName, module) {
		modules[moduleName] = $.extend(modules[moduleName], module);
	}


	///////////////////////////////////////////////////////////////////
	// Initialise Modules
	///////////////////////////////////////////////////////////////////

	function initialiseModules(){

		initStack = initStack.reverse();
		while(initStack.length){

			var moduleName = initStack.pop();

			//log('[modules]', 'initialising ' + moduleName);

			modules[moduleName].init();
		}
	}

	modules = meerkat.modules = {
		register: register,
		init: initialiseModules,
		extend: extend
	};

	meerkat.modules.events = events;

})(jQuery);

////////////////////////////////////////////////////////////////
//// MEERKAT                                                ////
////--------------------------------------------------------////
//// Meerkat is the new name i'm lending to this new        ////
//// iteration of the framework code, which is the product  ////
//// of ideas and bits of code that have been written and   ////
//// accumulated though my travels. It's here to bring a    ////
//// bit of simple framework to a site that needs modular   ////
//// cooperation and readyness for a team.                  ////
////--------------------------------------------------------////
//// REQUIRES: jquery as $                                  ////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function ($, undefined) {
	var meerkat, settings;

	// meerkat namespace
	meerkat = window.meerkat = window.meerkat || {};

	// settings (defaults)
	settings = {};

	/////////////////////////
	// Messaging
	/////////////////////////

	meerkat.messaging = {};
	meerkat.messaging.channels = {};

	meerkat.messaging.subscribe = function (channel, fn, context) {

		handler = {
				callback: fn,
				context: (context || window)
			};
		if (!meerkat.messaging.channels[channel]) {
			meerkat.messaging.channels[channel] = [];
		}
		meerkat.messaging.channels[channel].push(handler);

		return handler;
	};
	meerkat.messaging.unsubscribe = function (channel, handler) {
		var channelArray = meerkat.messaging.channels[channel];
		if (meerkat.messaging.channels[channel]) {

			var objectIndex = channelArray.indexOf(handler);
			if(objectIndex > -1) {
				channelArray.splice(objectIndex, 1);
				return true;
			}
		}
		return false;
	};
	meerkat.messaging.publish = function (channel) {
		var args;
		if (!meerkat.messaging.channels[channel]) {
			return false;
		}
		args = Array.prototype.slice.call(arguments, 1);

		for(var i=0;i<meerkat.messaging.channels[channel].length;i++){
			var subscription = meerkat.messaging.channels[channel][i];
			subscription.callback.apply(subscription.context, args);
		}

		return this;
	};

	/////////////////////////
	// Site
	/////////////////////////

	meerkat.site = {};
	meerkat.site.init = function (siteConfig) {
		$.extend(meerkat, {site: siteConfig});
	};

	/////////////////////////
	// Helpers
	/////////////////////////

	meerkat.getModule = function(target, type, subtype){
		var module = $(target).closest('[data-module]'),
			isModule = function(){
				var result = true;
				if(!module.length || !module.data('module')){
					return false;
				}
				if(type){
					result = result && module.data('module').type === type;
				}
				if(subtype){
					result = result && module.data('module').subtype === subtype;
				}

				return result;
			};

		isModule(module);

		while(!isModule(module) && module.length){
			module = module.parent().closest('[data-module]');
		}

		return isModule(module) && module;
	};

	meerkat.has = function (module) {
		return _.isObject(meerkat.modules[module]);
	};

	/////////////////////////
	// meerkat initialisation
	/////////////////////////

	// Create the initialisation function
	meerkat.init = function (siteConfig, options) {
		// Customise the settings
		$.extend(settings, options || {});

		// Initialise the site
		meerkat.site.init(siteConfig);

		// Initialise the logger
		meerkat.logging.init();

		// Initialise modules
		meerkat.modules.init();
	};

})(jQuery);

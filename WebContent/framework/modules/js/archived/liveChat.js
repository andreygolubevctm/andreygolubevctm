/* ========================================================================
 * Old Legacy Live chat tag has been ported over into this module, with lots of mods.
 * ======================================================================== */
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		debug = meerkat.logging.debug;

		//PREVIOUSLY IN THE HEAD: Provide settings for mtagconfig
		window.lpMTagConfig = window.lpMTagConfig || {}; //Preseved in case other areas modify 
		window.lpMTagConfig.vars = window.lpMTagConfig.vars || [];
		window.lpSettings = window.lpSettings || {};
		var options, oldIE;

	/* ==========================================================================
	 * PLEASE NOTE, IE8,9,10 - live chat breaks positioning of ".select select" boxes 
	 * on the page for no reason whatsoever, as soon as the live chat button is
	 * injected into the html of it's target container. Also, we can't watch for
	 * dom changes the live chat makes because there's no DOMSubtreeModified event
	 * in that browser and we don't want a constant poll of the page.
	 * Therefore, it's fairly useless on ie8.
	 * ======================================================================== */

	/*
	LiveChat provides an interface to trigger journey stage calls to Live Person.
	The module attempts to setup and handle this binding. It listens to journey engine reported step change for step names.

	Instantiated with these in health as an example:
	(These are in HealthSettings.liveChat)
		config: {
			lpServer		: "server.lon.liveperson.net",
			lpTagSrv		: "sr1.liveperson.net",
			lpNumber		: "1563103",
			deploymentID	: "1"
		},
		options: {
			brand	: 'ctm',
			vertical: 'Health',
			unit	: 'health-insurance-sales',
			button	: 'chat-health-insurance-sales'
		}

	These variables end up aggregated for reporting into people's chat records,...
	eg. "PageName (on URL #2)	ctm:quote-form:Health:health results"
	This is done by the getPageName function below, and is done to emulate supertag strings.

	NB: In the html side of things you need to add a data-livechat attribute with the value of button.
	NB: Actually that's not used anymore, but you could in future. Now the healthConfirmation.js vertical specific module will call fire manually. This would be implemented by other verticals that need to post livechat on confirmation.

	*/

	//These are used inside INIT.
	//Build a unique full page name (done in the same pattern by supertag)
	function getPageName(navigationId) { //can pass a hardcoded item or allow to fetch
		var step, page;
		if (typeof navigationId === "undefined") {
			step = meerkat.modules.journeyEngine.getCurrentStep();
			page = step.navigationId;
		} else {
			page = navigationId;
		}
		return [options.brand, 'quote-form', options.vertical, page].join(':');
	}

	function fire(stepPassed, confirmationBool, confirmationNavigationId) {
		var disabled = true;
		if(disabled) return;
		
		//Add the conversion stage
		//debug('fire begins',lpMTagConfig.vars);
		lpMTagConfig.vars.push(['page', 'ConversionStage', stepPassed]);
		//debug('[LiveChat]','stepIndex',stepPassed);

		//Add the current transaction ID to a custom variable.
		var tran_id = false;
		tran_id = meerkat.modules.transactionId.get();
		lpMTagConfig.vars.push(['visitor','transactionID',tran_id]);

		//Add UNIT param if defined by the options.
		if( options.hasOwnProperty('unit') ) {
			lpMTagConfig.vars.push(['page', 'unit', options.unit]);
			lpMTagConfig.vars.push(['unit', options.unit]);
		}

		//Add the current page, and a hardcoded value 
		if (confirmationBool) {
			lpMTagConfig.vars.push(['page', 'PageName', getPageName(confirmationNavigationId)]);
			//If at the confirmation page then also call this
			lpMTagConfig.vars.push(['page', 'OrderNumber', tran_id]);
			//debug('confirmation page bool state executed',lpMTagConfig.vars);
			lpMTagConfig.loadTag();
		} else {
			lpMTagConfig.vars.push(['page', 'PageName', getPageName()]);
		}

		//Send data to live person
		//debug('before send',lpMTagConfig.vars);
		lpSendData();
	}

	function init() {
		//lpSettings is a json object containing implementation settings if it exists already
		
		//Check if not at least IE9 - abort if it is
		oldIE = $('html').hasClass('lt-ie9');
		//if (oldIE) return;

		window.lpMTagConfig = _.extend(lpMTagConfig, HealthSettings.liveChat.config);
		options	= _.extend({}, HealthSettings.liveChat.instance); //Ensure we have an object
		//debug('init extends',lpMTagConfig);

		/*jshint -W058 */
		/*jshint -W004 */
		/*jshint -W032 */
			//----------------------------------------------------------------
			//HEED THIS WARNING, ALL YEE WHO ENTER: This is a modified version of the lpMTagConfig script which exports all it's contents specifically into window scope. This is because it's living in this module (required for the other code in this module) and hence isolated from global scope. The modifications support the access by the code imported in the embedded script tag which it dynamically inserts.
			//----------------------------------------------------------------
			//$(window).load(function() {

			//Settings for mtagconfig get passed in here on the first line, see?
			window.lpMTagConfig=window.lpMTagConfig||{};window.lpMTagConfig.vars=window.lpMTagConfig.vars||[];window.lpMTagConfig.dynButton=window.lpMTagConfig.dynButton||[];window.lpMTagConfig.lpProtocol=document.location.toString().indexOf("https:")===0?"https":"http";window.lpMTagConfig.pageStartTime=(new Date).getTime();if(!window.lpMTagConfig.pluginsLoaded)window.lpMTagConfig.pluginsLoaded=!1;
			window.lpMTagConfig.loadTag=function(){for(var a=document.cookie.split(";"),b={},c=0;c<a.length;c++){var d=a[c].substring(0,a[c].indexOf("="));b[d.replace(/^\s+|\s+$/g,"")]=a[c].substring(a[c].indexOf("=")+1)}for(var a=b.HumanClickRedirectOrgSite,b=b.HumanClickRedirectDestSite,c=["lpTagSrv","lpServer","lpNumber","deploymentID"],d=!0,e=0;e<c.length;e++)window.lpMTagConfig[c[e]]||(d=!1,typeof console!="undefined"&&console.log&&console.log("LivePerson : lpMTagConfig."+c[e]+" is required and has not been defined before lpMTagConfig.loadTag()."));
			if(!window.lpMTagConfig.pluginsLoaded&&d)window.lpMTagConfig.pageLoadTime=(new Date).getTime()-window.lpMTagConfig.pageStartTime,a="?site="+(a==window.lpMTagConfig.lpNumber?b:window.lpMTagConfig.lpNumber)+"&d_id="+window.lpMTagConfig.deploymentID+"&default=simpleDeploy",lpAddMonitorTag(window.lpMTagConfig.deploymentConfigPath!=null?window.lpMTagConfig.lpProtocol+"://"+window.lpMTagConfig.deploymentConfigPath+a:window.lpMTagConfig.lpProtocol+"://"+window.lpMTagConfig.lpTagSrv+"/visitor/addons/deploy2.asp"+a),window.lpMTagConfig.pluginsLoaded=!0};
			function lpAddMonitorTag(a){if(!window.lpMTagConfig.lpTagLoaded){if(typeof a=="undefined"||typeof a=="object")a=window.lpMTagConfig.lpMTagSrc?window.lpMTagConfig.lpMTagSrc:window.lpMTagConfig.lpTagSrv?window.lpMTagConfig.lpProtocol+"://"+window.lpMTagConfig.lpTagSrv+"/hcp/html/mTag.js":"/hcp/html/mTag.js";a.indexOf("http")!==0?a=window.lpMTagConfig.lpProtocol+"://"+window.lpMTagConfig.lpServer+a+"?site="+window.lpMTagConfig.lpNumber:a.indexOf("site=")<0&&(a+=a.indexOf("?")<0?"?":"&",a=a+"site="+window.lpMTagConfig.lpNumber);var b=document.createElement("script");b.setAttribute("type","text/javascript");b.setAttribute("charset","iso-8859-1");b.setAttribute("src",a);document.getElementsByTagName("head").item(0).appendChild(b)}}window.attachEvent?window.attachEvent("onload",function(){window.lpMTagConfig.disableOnLoad||window.lpMTagConfig.loadTag()}):window.addEventListener("load",function(){window.lpMTagConfig.disableOnLoad||window.lpMTagConfig.loadTag()},!1);
			window.lpAddMonitorTag=lpAddMonitorTag;
			function lpSendData(a,b,c){if(arguments.length>0)window.lpMTagConfig.vars=window.lpMTagConfig.vars||[],window.lpMTagConfig.vars.push([a,b,c]);if(typeof lpMTag!="undefined"&&typeof window.lpMTagConfig.pluginCode!="undefined"&&typeof window.lpMTagConfig.pluginCode.simpleDeploy!="undefined"){var d=window.lpMTagConfig.pluginCode.simpleDeploy.processVars();lpMTag.lpSendData(d,!0)}}function lpAddVars(a,b,c){window.lpMTagConfig.vars=window.lpMTagConfig.vars||[];window.lpMTagConfig.vars.push([a,b,c])};
			window.lpSendData=lpSendData;
		/*jshint +W058 */
		/*jshint +W004 */
		/*jshint +W032 */

		$(document).ready(function($) {
			//debug('DOMREADY',lpMTagConfig.vars);

			//Container target element
			var $container = $('div[data-livechat="target"]');
			if ($container.length) {
				//Set up the button.
				if (typeof options.button !== 'undefined' && !(oldIE)) {

					var buttonHtml = ""+'<div id="'+options.button+'" data-livechat="button"></div>';
					$container.append(buttonHtml);

					//As we're overriding the default button let's give the click event to its parent
					$("#"+options.button).on("click", "a", function() {
						lpMTagConfig.dynButton0.actionHook();
					});
				}
			}

			//Here we set a watcher on the dom manipulation of the chat, in order to set the css state of the area via attribute 'data-livechat-state'. Debounced since DOMSubtreeModified fires a hell of a lot when an update happens.
			function liveChatDomEvents(event) {
				var content = "";
				var $contentElem = $("#" + options.button);
				if ($contentElem.length) { content = $contentElem.html(); 
				}
				if(content === "" || content == "<span></span>"){
					$('[data-livechat="target"]').attr("data-livechat-state",false);
				} else {
					$('[data-livechat="target"]').attr("data-livechat-state",true);
				}
			}
			//Doesn't work on <IE9
			if (!(oldIE)) {
				$(document).on('DOMSubtreeModified', '[data-livechat="target"]', _.debounce(liveChatDomEvents, 100));
			}

			//When the journey is ready, we'll use all this stuff, since we need the journeyEngine to return it's steps. Without this however, we can call the above functions directly, and pass their required data in place of having a journey - aka, confirmation page.
			meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function journeyEngineStepInit(journeyInitData) {
				//debug('meerkatEvents.journeyEngine.STEP_INIT',lpMTagConfig.vars);
				//Fire event for first slide and add listener for balance of journey
				var initialSlideIndex = journeyInitData.step.slideIndex+1;
				var initialStepIndex = journeyInitData.step.stepIndex+1;
				var latestNavigationId = journeyInitData.navigationId;

				//This is the typical launch on stepchange
				fire(initialStepIndex);

				//Relaunches (into space!) the setup anew when we change slides.
				meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function journeyEngineSlideChange(journeyStepChangedData) {
					//debug('meerkatEvents.journeyEngine.STEP_CHANGED',lpMTagConfig.vars);
					var latestSlideIndex = journeyStepChangedData.step.slideIndex+1;
					var latestStepIndex = journeyStepChangedData.step.stepIndex+1;
					latestNavigationId = journeyStepChangedData.navigationId;
					//TODO: Test if on the confirmation page and reload mTag.
					//It seems though that the fire function already does this at it's end too. I'm assuming that in the past there was a need to call it before fire as well as at it's end? The confirmation page calls fire directly now via it's livechat-fire data attribute.
					//if( journey_end == (latestStepIndex) ) {
						//Reload the MTag (aka Monitor Tag). Implemented to be called from the confirmation page once when sold. 
						//lpMTagConfig.loadTag();
					//}
					fire(latestStepIndex);
				});

			});

			//liveChatDomEvents(); //call once to ensure state is set up once the button exists above.

			//NOTE:
			//This code chunk below used to allow livechat to do a manual fire call on domready by taking params defined in an object on a data attribute of the livechat parent 'target' element.

			//Container target element
			//$container = $('[data-livechat="target"]');
			//if ($container.length) {
			//	//Set up the manual trigger of fire for confirmation page use.
			//	var manualFireCall = $container.data("livechat-fire");
			//	if (typeof manualFireCall === "object") {
			//		debug('manual fire',lpMTagConfig.vars);
			//		fire(manualFireCall.step, manualFireCall.confirmation, manualFireCall.navigationId);
			//	}
			//}


		}); //domready close

	}


	meerkat.modules.register("liveChat", {
		init: init,
		fire: fire
	});

})(jQuery);
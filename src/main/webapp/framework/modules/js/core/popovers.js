////////////////////////////////////////////////////////////
//// qTip based POPOVERS								////
////----------------------------------------------------////
//// This allows you to display a popover which is		////
//// actually done with qTip instead of bootstrap		////
//// popover for extra control.							////
//// See qtip.less and tooltips.less					////
////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat;
	var log = meerkat.logging.info;

	var defaultSettings = {
		element: null,
		contentType: null,
		contentValue: null,
		showEvent: 'click',
		onOpen:function(){ // @todo

		},
		onClose:function(){ // @todo

		},
		onLoad:function(){ // @todo

		}
	}

	function create(instanceSettings){

		var settings = $.extend({}, defaultSettings, instanceSettings);
		var title = '';
		var htmlContent = null;

		if(settings.contentType == 'url'){

			htmlContent = function(event, api) {

				var returnString = meerkat.modules.loadingAnimation.getTemplate();

				meerkat.modules.comms.get({
					url: settings.contentValue,
					cache: true,
					errorLevel: "silent",
					onSuccess:  function popoverSuccess(content){

						var html = '';
						$(content).find("help").each(function() {

							if(title === '') title = $(this).attr("header");
							html += $(this).text();
						});

						returnString = html;

						api.set('content.text', html);
						api.set('content.title', title);
						api.reposition();

					},
					onError: function popoverError() {
						api.set('content.text', 'Apologies. This information did not download successfully.');
						api.reposition();
					}
				});

				return returnString;

			};

		} else {
			htmlContent = settings.contentValue;
			title = settings.element.attr('data-title');
		}

		var showEvent = null;
		if( settings.element.attr('data-trigger') ){
			showEvent = settings.element.attr('data-trigger');
		} else {
			showEvent = settings.showEvent;
		}

		var hideEvent = null;
		switch( showEvent ){
			case 'mouseenter':
				hideEvent = 'mouseleave';
				break;
			// This was used by Health, but the latest version of the plugin
			// doesn't seem to support mouseenter and click events simultaneously.
			case 'mouseenter click':
			case 'click mouseenter':
				hideEvent = 'mouseleave unfocus click';
				break;
			default:
				hideEvent = 'unfocus click';
				break;
		}

		settings.element.qtip({
			content: {
				text: htmlContent,
				title: title
			},
			position: settings.position ? settings.position : {
				my: settings.element.attr('data-my') ? settings.element.attr('data-my') : 'left center',
				at: settings.element.attr('data-at') ? settings.element.attr('data-at') : 'right center',
				effect: false,
				adjust: {
					method: 'flipinvert none',
					x: settings.element.attr('data-adjust-x') ? parseInt(settings.element.attr('data-adjust-x')) : 0,
					y: settings.element.attr('data-adjust-y') ? parseInt(settings.element.attr('data-adjust-y')) : 0
				},
				viewport: $(window)
			},
			show: {
				event: showEvent
			},
			hide:{
				event: hideEvent,
				fixed: true,
				delay: 150
			},
			style: settings.style ? settings.style : {
				classes: settings.element.attr('data-class') ? 'popover ' + settings.element.attr('data-class') : 'popover',
				tip:{
					corner: true,
					width: 12,
					height: 6
				}
			}
		});

	}

	// Initialise Dev helpers
	function init() {

		meerkat.messaging.subscribe('DYNAMIC_CONTENT_PARSED_POPOVER', function popoverDynamicCreation( event ) {
			if( !event.element.attr('data-hasqtip') ){
				create(event);
				event.element.qtip('toggle', true);
			}
		});

	}

	meerkat.modules.register('popovers', {
		init: init,
		create: create
	});


})(jQuery);
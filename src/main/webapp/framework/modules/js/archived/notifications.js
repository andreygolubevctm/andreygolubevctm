////////////////////////////////////////////////////////////////
//// HTML5 Notifications module                             ////
////--------------------------------------------------------////
//// This is a module to provide an out of the box API for  ////
//// HTML5 notifications use in the platform.               ////
//// http://www.w3.org/TR/notifications/                    ////
//// http://www.paulund.co.uk/html5-notifications           ////
//// REQUIRES A USER EVENT TO AUTHORISE NOTIFICATIONS       ////
//// FUNCTION, SUCH AS A BUTTON. THIS IS EASILY DONE BY     ////
//// ADDING data-notifications-auth ATTRIBUTE TO A BUTTON   ////
////--------------------------------------------------------////
//// REQUIRES: jquery as $                                  ////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function($, undefined) {

	var meerkat = window.meerkat;
	var log = meerkat.logging.info;
	var error = meerkat.logging.error;

	/* Helper Functions */

	/**
	* Check if the browser supports notifications
	* 
	* @return true if browser does support notifications
	*/
	function browserSupportNotification(){
		if (window.webkitNotifications) { return true; } else { return false; }
	}

	/**
	* Check browser support and hide elements that depend on it if they exist
	*/
	function showIfSupport() {
		if(browserSupportNotification()){
			$('.notificationsSupport').show();
		}
	}

	/**
	* Request notification permissions
	*/
	function requestPermissionCall(){
		if(browserSupportNotification()){
			// 0 means we have permission to display notifications
			if (window.webkitNotifications.checkPermission() !== 0) {
				window.webkitNotifications.requestPermission(checkPermissionIntercept);
			}
		}
	}

	/**
	* Checks to see if notification has permission. Does stuff after the request is answered.
	*/
	function checkPermissionIntercept() {
		if(browserSupportNotification()){
			switch(window.webkitNotifications.checkPermission()) {
			case 0:
				// Continue
				return true;

			case 2:
				error('Notifications Denied');
				break;
			
			default:
				// Fail
				//error('Notifications fail');
				return false;
			}
		}
	}

	/**
	* Create a plain text notification box
	*/
	function create(image, title, content) {
		if(browserSupportNotification()){
			if (window.webkitNotifications.checkPermission() === 0) {
				return window.webkitNotifications.createNotification(image, title, content);
			} else {
				error('Notification creation failed - no permission');
				return false
			}
		} else {
			return false
		}
	}

	function createAndShow(image, title, content) {
		var newCreated = create(image,title,content);
		if (newCreated) {
			newCreated.show();
		} else {
			error('No notification object was created');
		}
	}

	//Create a test one
	function testNotifications() {
		if(browserSupportNotification()){
			var test = create("brand/ctm/images/call_us_now/phone.png", "Title", "Message");
			if (test) {
				test.ondisplay = function() {
					log('ondisplay');
				};
				test.onclose = function() {
					log('onclose');
				};
				test.show();
			}
		} else {
			error('Notifications Not Supported');
		}
	}

	// Initialise
	function init() {
		// Checks run
		showIfSupport();
		if(browserSupportNotification()){
			$("[data-notifications-auth]").on('click', requestPermissionCall);
		}
	}

	meerkat.modules.register('notifications', {
		init: init,
		create: create,
		show: createAndShow,
		check: checkPermissionIntercept,
		request: requestPermissionCall,
		test: testNotifications
	});

})(jQuery);

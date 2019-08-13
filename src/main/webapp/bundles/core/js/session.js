;(function($, undefined){

	var meerkat = window.meerkat,
		exception = meerkat.logging.exception;

	var windowTimeout = null,
		isModalOpen = false,
		lastClientPoke = 0,
		deferredPokeTimeout = null,
		sessionAlertModal = null,
		// When the modal appears, this interval will run the count down
		countDownInterval = null,
		// A counter for failed AJAX requests
		// Lets us retry poking the server 3 times before calling it quits
		ajaxRequestTimeoutCount = 0,
		firstPoke = true,
		moduleEvents = {
			EXTERNAL: 'TRACKING_EXTERNAL'
		};
	
	function init() {
		// Don't run the initial setup if Simples is present
		// or if first poke is disabled
		if(!meerkat.modules.simplesTickler && meerkat.site.session.firstPokeEnabled) {
			// Initialize session poke for the first time using the default window timeout
			// This ensures a failed first poke will still timeout after the default duration
			updateTimeout(meerkat.site.session.windowTimeout);

			// Get the proper timeout as specified by the server
			poke().then(function firstPokeDone(data) { 
				firstPoke = false;
				if(data.timeout < 0 && typeof data.bigIP !== "undefined" && data.bigIP !== meerkat.site.session.bigIP) {
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
					
					// Give up and use the default :(
					updateTimeout(meerkat.site.session.windowTimeout);
				}
			})
			.catch(function onError(obj, txt, errorThrown) {
				exception(txt + ': ' + errorThrown);
			});
		
			// Poke / deferred poke when we need to :)
			$(document).on("click.session", ".poke, .btn:not(.journeyNavButton,.dontPoke), .btn-back, .dropdown-toggle, .btn-pagination", function(e) {
				deferredPoke();
			});
		}
	}
	
	/**
	 * Sends a poke / check request to the server
	 * @param check boolean Whether the poke should update the user's session or just retrieve the expected timeout duration 
	 */
	function poke(check) {
		var ajaxURL = "session_poke.json";
		
		ajaxURL += (check === true) ? "?check" : "";
		
		return meerkat.modules.comms.post({
			url: ajaxURL,
			dataType: "json",
			onSuccess: function onPokeSuccess(data){
				ajaxRequestTimeoutCount = 0;
				updateTimeout(data.timeout);
			},
			useDefaultErrorHandling: false,
			errorLevel: "silent",
			onError: function onPokeError(obj, txt, errorThrown){
				// If the AJAX request has timed out, try poking again after 30 seconds
				if(txt === "timeout" && ajaxRequestTimeoutCount < 3) {
					setTimeout(function retrySessionPoke() { 
						poke(check);
						ajaxRequestTimeoutCount++;
					}, 30000);
				} else {
					showModal(false);
					
					meerkat.modules.errorHandling.error({
						errorLevel: "silent",
						message: "Session poke error",
						description: "An error occurred with your browsing session, session poke failed to return: " + txt + ' ' + errorThrown,
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
	
	/**
	 * Runs poke with the check param set to true
	 */
	function check() { 
		return poke(true); 
	}
	
	/**
	 * It's not reasonable to poke the server all the time if we don't need to
	 * F5 may throw a fit from too many requests, so we can defer poke requests if we need to
	 */
	function deferredPoke() {
		if(lastClientPoke <= getClientTimestamp - meerkat.site.session.deferredPokeDuration) {
			poke();
		} else {
			if(!deferredPokeTimeout)
				deferredPokeTimeout = window.setTimeout(poke, meerkat.site.session.deferredPokeDuration);
		}
	}
	
	/**
	 * Gets a timestamp for right... Now!
	 */
	function getClientTimestamp() {
		return parseInt(+new Date());
	}
	
	/**
	 * (re)initializes the session poke timeout
	 * Can be done manually (as seen in init() and comms.js) or as part of poke()
	 * @param timeout int
	 */
	function updateTimeout(timeout) {
		if(timeout > 0) {
			lastClientPoke = getClientTimestamp();
			window.clearTimeout(windowTimeout);
			windowTimeout = window.setTimeout(function setTimeoutWindowTimeout() { check(); }, timeout);
			hideModal();
		} else {
			// If the timeout is negative, and the modal is open or is the first poke
			// there won't be an active session, so the user cannot recover their 
			// current journey
			if (!firstPoke) {
				if(isModalOpen) {
					showModal(false);
					meerkat.messaging.publish(moduleEvents.EXTERNAL, { method: 'quoteTimeout', object: {} });
				} else {
					showModal(true);
				}
			}
		}
	}
	
	/**
	 * Redirect the user
	 * @param reload boolean If true, will reload the journey
	 */
	function redirect(reload) {
		if(meerkat.modules.leavePageWarning) {
			meerkat.modules.leavePageWarning.disable();
		}
		
		hideModal();
		meerkat.modules.utils.scrollPageTo("body");
		
		if(typeof reload === "boolean" && reload) {
			meerkat.modules.journeyEngine.loadingShow("Reloading...");
			window.location.reload();
		} else {
			meerkat.modules.journeyEngine.loadingShow("Redirecting...");
			window.location = meerkat.site.urls.exit;
		}
	}
	
	/**
	 * @param canRecover boolean
	 */
	function showModal(canRecover) {
		hideModal();
		isModalOpen = true;
		
		var modalConfig = {
				title: "Hi, are you still there?",
				className: "sessionModalContainer",
				leftBtn: { label: "" },
				onOpen: function onSessionModalOpen(dialogId) {
					$("#" + dialogId).find(".modal-closebar").remove();
				}
			};
		
		if(canRecover) {
			var modalCountdownDuration = 180;
			runModalCountdown(modalCountdownDuration);
			
			modalConfig.htmlContent = [
				"<p id=\"sessionModalCountDown\">",
					getModalCountdownText(modalCountdownDuration),
				"</p>",
				"<p>We haven't noticed any activity from you for a while, so we wanted to let you know that your session will automatically time out in 3 minutes.</p>",
				"<p>If you are still there, great!</p>",
				"<p>To continue with your session, please click the \"Continue\" button below.</p>"
			].join("");
			
			modalConfig.buttons = [{
				label: "Continue",
				className: "btn btn-success",
				closeWindow: true,
				action: poke
			}];
		} else {
			modalConfig.htmlContent = [
				"<p>We didn't see any activity from you for a while, or your connection was interrupted, so we wanted to let you know your session has timed out.</p>"
			].join("");
			
			modalConfig.buttons = [
				{
					label: "Reload Page",
					className: "btn btn-success",
					closeWindow: true,
					action: function sessionModalReloadPage() { redirect(true); }
				}, {
					label: "Visit " + meerkat.site.name + "'s Home Page",
					className: "btn btn-success",
					closeWindow: true,
					action: redirect
				}
			];
		}
		
		sessionAlertModal = meerkat.modules.dialogs.show(modalConfig);
	}

	function expire(){
		showModal(false);
	}
	
	/**
	 * Returns a formatted 00:00 representation of a supplied number of seconds
	 * @param countDownSecs int
	 */
	function getModalCountdownText(countDownSecs) {
		var minutes = Math.floor(countDownSecs / 60),
			seconds = ("0" + (countDownSecs - (minutes * 60))).slice(-2);
		return minutes + ":" + seconds;
	}
	
	/**
	 * Runs the modal countdown
	 * @param modalCountdownDuration int
	 */
	function runModalCountdown(modalCountdownDuration) {
		var countDownSecs = modalCountdownDuration,
			countDown = function sessionModalCountDown() {
				$(document).find("#sessionModalCountDown").text(getModalCountdownText(countDownSecs));
				
				if(countDownSecs <= 0) {
					check().then(function sessionLastBreath(data) {
						if(data.timeout <= 0) {
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

		countDownInterval = window.setInterval(countDown, 1000);
	}
	
	/**
	 * Hide the session poke modal
	 */
	function hideModal() {
		window.clearInterval(countDownInterval);
		meerkat.modules.dialogs.close(sessionAlertModal);
		isModalOpen = false;
	}

	meerkat.modules.register("session", {
		init: init,
		poke: poke,
		check: check,
		update: updateTimeout,
		expire : expire
	});

})(jQuery);
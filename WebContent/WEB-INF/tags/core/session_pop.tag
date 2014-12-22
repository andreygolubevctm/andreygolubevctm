<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Handles a session which is about to timeout, and prompts the user to keep it active."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Was Previously exclusive for live - but is now on in development and test env. --%>

<%-- HTML --%>
<div id="session_overlay"></div>
<div id="session_pop" style="display:none;">
	<div class="recover">
		<p>Hi, are you still there? We haven't noticed any activity from you for a while so wanted to let you know your session will automatically timeout in 3 minutes.</p>
		<p>If you are still there, great!</p>
		<p>To continue with your session, please click the "Continue" button below.</p>
	<div id="session_countdown">&nbsp;</div>
		<a id="session_btn" href="javascript:void(0);">Continue</a>
</div>
	<div class="noRecover">
		<p>Hi, are you still there? We didn't see any activity from you for a while, or your connection was interrupted, so we wanted to let you know your session has timed out.</p>
		<p>To restart your quote, please click the "restart" button below.</p>
		<a id="session_btn_restart" href="javascript:void(0);">Restart Quote</a>
		<p>To return to the home page, please click the "home" button below</p>
		<a id="session_btn_exit" href="javascript:void(0);">Home</a>
	</div>

</div>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">
	$('#session_btn, #next-step, #slide-next').click(function(){
		sessionExpiry.poke().done(function(data) {
			if(data.timeout == -1) 
				sessionExpiry.canRecover(false);
	});
	});

	$('#session_btn_exit').click(function(){
		sessionExpiry.redirectUser();
	});
	
	$('#session_btn_restart').click(function(){
		if(typeof meerkat != 'undefined'){
			meerkat.modules.leavePageWarning.disable();
		}
		window.location.reload();
	});

	sessionExpiry.poke().done(function(data) {
		<%-- 
			This occurs when the user does not have an active session
			and they have returned to a cached copy of the page
			e.g. returning to the page from the brochureware after a
			long period of inactivity 
		--%>
		if(data.timeout == -1) {
			<%-- Original code. F5's being stupid, so we have to apply a "temporary" fix: --%>
			<%--
			sessionExpiry.canRecover(false);
			sessionExpiry.show();
			--%>
			<%-- Use default duration --%>
			sessionExpiry._timeoutLength = ${sessionDataService.getClientDefaultExpiryTimeout(pageContext.request)};
			<%-- "Temporary" code starts here: --%>
			<%-- Log applicable information to the DB --%>
			var bigIPPageLoad = "${sessionDataService.getCookieByName(pageContext.request, environmentService.getBIGIPCookieId())}";
			if(typeof data.bigIP !== "undefined" && data.bigIP !== bigIPPageLoad) {
				if (typeof FatalErrorDialog !== 'undefined') {
					FatalErrorDialog.exec({
						message: "Session poke failed on first load",
						page: "session_poke.json",
						description: "Session poke failed on first load",
						data: {
							transactionId: (typeof referenceNo == 'undefined') ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(),
							bigIP_onPageLoad: bigIPPageLoad,
							bigIP_onFirstSessionPoke: data.bigIP
						},
						silent: true
					});
				}
			}
			<%-- "Temporary" code ends here. --%>
		}
		
	sessionExpiry.init();
	});

	var pokeElements = '.poke, .btn:not(.journeyNavButton,.dontPoke), .btn-back, .dropdown-toggle, .btn-pagination';
	$(document).on('click.poke', pokeElements, function(e){
		sessionExpiry.deferredPoke();
	});
</go:script>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var sessionExpiry = new Object();
	sessionExpiry = {
		_secCount: 0,
		_totalSec: 180,
		_intervalTime: 1000,
		_timeoutLength: ${sessionDataService.getClientDefaultExpiryTimeout(pageContext.request)},
		_timeoutCounter: null,
		_sessionInt: 0,
		_pokeDeferDuration: 300000,
		_pokeDeferTimeout: null,
		_lastClientPoke: 0,
		_ajaxTimeoutCount: 0,
		
		show: function(){
			<%-- 
				TODO: In future, "poke" commands should be run through this method as it also handles
				the checking of if the session is active and shows the modal if it is not.
			--%>
			<%-- Check to see if there are any other active sessions to keep it alive --%>
			sessionExpiry.isActiveSession()
				.done(function(isActiveSession){
					<%-- 
						isActiveSession.timeout <= 0 was used because the jQuery used on older verticals 
						causes promised to be returned as an object.
					--%>
					if(isActiveSession === false || isActiveSession.timeout <= 0) {
						sessionExpiry.setInt();
						var $sessionOverlay = $('#session_overlay');
						$sessionOverlay.fadeIn(1000, function(){
							$sessionOverlay.css('filter', 'alpha(opacity=65)');
						});
		
						$('#session_pop').fadeIn(1000);
					}
				});
		},
		hide: function(){
			clearInterval(this._sessionInt);
			$('#session_countdown').html('&nbsp;');
			$('#session_pop, #session_overlay').hide();
		},
		<%-- This is for the countdown timer on the pop-up box itself --%>
		setInt: function(){
			if(this._sessionInt != 0){
				clearInterval(this._sessionInt);
				this._sessionInt = 0;
			}
			this._sessionInt = setInterval("sessionExpiry.interval()", this._intervalTime);
		},
		interval: function(){
			if(this._secCount > 0){
				count_min = Math.floor(this._secCount / 60);
				count_sec = ('0' + ((this._secCount--) - (count_min * 60))).slice(-2);
				$('#session_countdown').html('0' + count_min + ':' + count_sec + ' remaining');
			}else{
				// Check if session exists one last time
				clearInterval(this._sessionInt);
				sessionExpiry.isActiveSession()
					.done(function(isActiveSession){
						<%-- 
							isActiveSession.timeout > 0 was used because the jQuery used on older verticals 
							causes promised to be returned as an object. Same goes for getting the typeof isActiveSession
						--%>
						if((typeof isActiveSession == "boolean" && isActiveSession) || isActiveSession.timeout > 0) {
							// "Revive" the session and make the timeout match the other open tabs
							sessionExpiry.poke(true);
						} else {
							// Redirect the user to the brochureware
							var writeData = {
								triggeredsave: 'sessionpop'
							};
			
							$('#session_btn')
								.off('click')
								.text('Redirecting')
								.prop('disabled', true)
								.css({
									'background-color': '#ccc'
								});
			
							if( typeof meerkat !== "undefined" ){
								meerkat.modules.writeQuote.write(writeData, false, sessionExpiry.redirectUser);
							} else {
								write_quote_ajax.write(writeData, sessionExpiry.redirectUser);
							}					
						}
					});
			}
		},
		redirectUser: function(){
			if(typeof meerkat != 'undefined'){
				meerkat.modules.leavePageWarning.disable();
			}
			window.location = '${pageSettings.getSetting('exitUrl')}';
		},
		poke: function(options){
			window.clearTimeout(sessionExpiry._pokeDeferTimeout);
			sessionExpiry._pokeDeferTimeout = null;

			var ajaxURL = "session_poke.json";
			
			if(typeof options === "boolean") {
				ajaxURL += (options) ? "?check" : "";
			} else if (typeof options === "object") {
				if(options.hasOwnProperty("action")) {
					ajaxURL += "?" + options.action;
				}
			}
			
			return $.ajax({
				type: "GET",
				url: ajaxURL,
				dataType: 'json',
				timeout: 60000,
				cache: false,
				success: function(data){
					sessionExpiry.resetModalTimer();
					sessionExpiry._ajaxTimeoutCount = 0;
					sessionExpiry._timeoutLength = data.timeout;
					
					if(data.timeout >= 0) {
						sessionExpiry.canRecover(true);
					sessionExpiry.init();
					}
				},
				error: function(obj, txt, errorThrown){
					// If we've timed out, try poking again after 30 seconds
					if(txt === "timeout" && sessionExpiry._ajaxTimeoutCount < 3) {
						setTimeout(function retrySessionPoke() {
								sessionExpiry.poke(options);
							}, 30000);
						sessionExpiry._ajaxTimeoutCount++;
					} else {
					sessionExpiry.canRecover(false);
						
					if (typeof FatalErrorDialog !== 'undefined') {
						var data = {
							transactionId: (typeof referenceNo == 'undefined') ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID() 
						}; 
						
						FatalErrorDialog.exec({
							message: "Unfortunately, something went wrong while checking your session with us. <br /><br />It's possible you were temporarily disconnected, or your session may have simply expired for this page. <br /><br />Please try to refresh this page and try again.",
							page: ajaxURL,
							description: "An error occurred with your browsing session, session poke failed to return: " + txt + ' ' + errorThrown,
							data: data
						});
					}
				}
				}
			});
		},
		init: function(){
			sessionExpiry.hide();

			sessionExpiry.resetModalTimer();
			window.clearTimeout(sessionExpiry._timeoutCounter);
			sessionExpiry._timeoutCounter = window.setTimeout("sessionExpiry.show()", sessionExpiry._timeoutLength);
			sessionExpiry._lastClientPoke = sessionExpiry.getClientTimestamp();
		},
		resetModalTimer: function() {
			sessionExpiry._secCount = sessionExpiry._totalSec;
		},
		isActiveSession: function(){		
			return sessionExpiry.poke(true)
								.then(function(data){
									var isActiveSession = (data.timeout > 0);
									return isActiveSession; <%-- false for No other active session --%>
								});
		},
		canRecover: function(mode){
			if(mode === false){
				$('#session_pop').addClass('noRecover');
			} else {
				$('#session_pop').removeClass('noRecover');
			};
		},
		getClientTimestamp: function() {
			return parseInt(+new Date());
		},
		deferredPoke: function() {
			if(sessionExpiry._lastClientPoke <= sessionExpiry.getClientTimestamp() - sessionExpiry._pokeDeferDuration) {
				sessionExpiry.poke();
			} else {
				if(!sessionExpiry._pokeDeferTimeout) {
					sessionExpiry._pokeDeferTimeout = window.setTimeout(sessionExpiry.poke, sessionExpiry._pokeDeferDuration);
			}
		}
		}
	};
</go:script>


<!-- CSS -->
<go:style marker="css-head">
	#session_pop {
		display:none;
	    z-index:9011;
	    position:fixed;
	    top:130px; left:50%;
	    margin-left:-168px;
		width:325px;
	    background-color:#eee;
	    border:10px solid #fff;
	    padding:15px; font-size:14px;
	}
	#session_pop .noRecover,
	#session_pop.noRecover .recover {
		display:none;
	}
	#session_pop.noRecover .noRecover {
		display:block;
	}
	#session_pop p {
		display:block; margin:-2px 0 1em 0;
	    line-height:17px; font-size:13px;
	}
	#session_btn, #session_btn_exit, #session_btn_restart{
		display:block; width:80px;
		font-weight:bold;
		color:#fff; padding:5px 6px 6px 6px;
		background-color:#06f;
		margin:9px auto 5px auto;
		font-size:14px;
		cursor:pointer; cursor:hand; text-decoration:none;  
		text-align:center;
	}
		#session_btn_restart {
			width:160px;
			margin-bottom:2em;
		}
	#session_overlay {
		display:none;
	    z-index:9010;
	    position:absolute;
	    top:0; left:0;
	    opacity:0.65;
	    filter:alpha(opacity=65);
	    -moz-opacity:0.65;
		background-color:#000;
	}
	#session_countdown {
		text-align:center;
		font-weight:bold;
		margin:12px 0 14px 0;
		font-size:16px;
	}
	#session_pop, #session_btn, #session_btn_exit, #session_btn_restart {
		-moz-border-radius:6px; -webkit-border-radius:6px; -khtml-border-radius:6px; 
	}
</go:style>

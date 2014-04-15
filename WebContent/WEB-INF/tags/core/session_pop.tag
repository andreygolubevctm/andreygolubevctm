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
		sessionExpiry.poke();
	});
	
	$('#session_btn_exit').click(function(){
		window.location = '${pageSettings.getSetting('exitUrl')}';
	});
	$('#session_btn_restart').click(function(){
		window.location.reload();
	});

	sessionExpiry.init();
</go:script>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var sessionExpiry = new Object();
	sessionExpiry = {
		_secCount: 0,
		_totalSec: 180,
		_intTime: 1000,
		_expiryTime: 1200000,
		_sessionInt: 0,
		_ts: 0,
		
		show: function(){
			<%-- Check to see if there are any other active sessions to keep it alive --%>
			if(sessionExpiry.activeSession() === false) {
				sessionExpiry.setInt();
			$('#session_overlay').fadeIn(1000, function(){
				$("#session_overlay").css('filter', 'alpha(opacity=65)');
			});
			$('#session_pop').fadeIn(1000);
				if( typeof meerkat !== "undefined" ){
					meerkat.modules.writeQuote.write({triggeredsave:'sessionpop'});
				} else {
					write_quote_ajax.write({triggeredsave:'sessionpop'});
				}
			};
		},
		hide: function(){
			clearInterval(this._sessionInt);
			$('#session_countdown').html('&nbsp;');
			$('#session_pop').hide();
			$('#session_overlay').hide();
		},
		<%-- This is for the countdown timer on the pop-up box itself --%>
		setInt: function(){
			if(this._sessionInt!=0){
				clearInterval(this._sessionInt);
				this._sessionInt = 0;
			}
			this._sessionInt = setInterval("sessionExpiry.interval()", this._intTime);	
		},
		interval: function(){
			if(this._secCount > 0){
				count_min = Math.floor(this._secCount / 60);
				count_sec = ('0' + ((this._secCount--) - (count_min * 60))).slice(-2);
				$('#session_countdown').html('0' + count_min + ':' + count_sec + ' remaining');
			}else{
				clearInterval(this._sessionInt);
				window.location = '${pageSettings.getSetting('exitUrl')}';
			}
		},
		poke: function(update){
			if(update == false){
				sessionExpiry._ts = 0;
				var async = false;
			} else {
				sessionExpiry._ts = +new Date();
				var async = true;
			};

			// Transaction ID required for multitab session support.
			var data = new Object();
			if(typeof referenceNo == 'undefined'){
				data.transactionId = meerkat.modules.transactionId.get();
			}else{
				data.transactionId = referenceNo.getTransactionID();			
			}
			
			$.ajax({
				type: "POST",
				url: "ajax/json/session_poke.jsp?ts=" + sessionExpiry._ts,
				dataType: 'json',
				data:data,
				async: async,
				cache: false,
				timeout: 60000,
				success: function(data){
					sessionExpiry._ts = data.timestamp;
					sessionExpiry.canRecover(true);
					if(update != false){
					sessionExpiry.init();
					};
				},
				error: function(obj, txt, errorThrown){
					sessionExpiry.canRecover(false);
					FatalErrorDialog.exec({
						message:		"Unfortunately, something went wrong while checking your session with us. <br /><br />It's possible you were temporarily disconnected, or your session may have simply expired for this page. <br /><br />Please try to refresh this page and try again.",
						page:			"ajax/json/session_poke.jsp",
						description:	"An error occurred with your browsing session, session poke failed to return: " + txt + ' ' + errorThrown
					});
				}
			});
		},
		init: function(){
			sessionExpiry.hide();
			this._secCount = this._totalSec;
			window.clearInterval(sessionExpiry.timer);
			sessionExpiry.timer = window.setInterval("sessionExpiry.show()", sessionExpiry._expiryTime);
		},
		activeSession: function(){
			sessionExpiry.poke(false);
			return (+new Date() - sessionExpiry._expiryTime) <= sessionExpiry._ts; <%-- false for No other active session --%>
		},
		canRecover: function(mode){
			if(mode === false){
				$('#session_pop').addClass('noRecover');
			} else {
				$('#session_pop').removeClass('noRecover');
			};
		}
	}
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

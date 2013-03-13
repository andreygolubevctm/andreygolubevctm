<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Handles a session which is about to timeout, and prompts the user to keep it active."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Session Timeout Handler - Only Enabled for Live --%>
<c:set var="userIP" value="${pageContext.request.remoteAddr}" />
<c:if test="${!fn:startsWith(userIP, '192.168.') and !fn:startsWith(userIP, '10.1.') and !fn:startsWith(userIP, '10.9.') and !fn:startsWith(userIP, '0')}">

<%-- HTML --%>
<div id="session_overlay"></div>
<div id="session_pop">
	<p>We haven't noticed any recent activity, so this quote will be terminated automatically in 3 minutes.
	   If you wish to continue with this quote, please click the "Continue" button below.</p>
	<div id="session_countdown">&nbsp;</div>
	<a id="session_btn" href="javascript:;">Continue</a>
</div>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">
	$('#session_pop, #next-step, #slide-next').click(function(){
		sessionExpiry.poke();
	});
	
	sessionExpiry.init();
	$('#session_overlay').css({"height":$(document).height() + "px", "width":$(document).width()+"px"});
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
		_redirectUrl: '${data["settings/exit-url"]}',
		
		show: function(){
			$('#session_overlay').fadeIn(1000, function(){
				$("#session_overlay").css('filter', 'alpha(opacity=65)');
			});
			$('#session_pop').fadeIn(1000);
			this.setInt();
		},
		hide: function(){
			clearInterval(this._sessionInt);
			$('#session_countdown').html('&nbsp;');
			$('#session_pop').hide();
			$('#session_overlay').hide();
		},
		setInt: function(){
			if(this._sessionInt!=0){
				clearInterval(this._sessionInt);
				this._sessionInt = 0;
			}
			this._sessionInt = setInterval("sessionExpiry.interval()", this._intTime);	
		},
		interval: function(){
			if(this._secCount>=0){
				count_min = Math.floor(this._secCount / 60);
				count_sec = ('0' + ((this._secCount--) - (count_min * 60))).slice(-2);
				$('#session_countdown').html('0' + count_min + ':' + count_sec + ' remaining');
			}else{
				window.location = this._redirectUrl;
			}
		},
		poke: function(){
			$.ajax({
				type: "POST",
				url: "ajax/json/session_poke.jsp",
				dataType: 'json',
				async: false,
				cache: false,
				success: function(data){
					sessionExpiry.hide();
					sessionExpiry.init();
				}
			});
		},
		init: function(){
			this._secCount = this._totalSec;
			setTimeout("sessionExpiry.show()", this._expiryTime);
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
	    width:306px; height:135px;
	    background-color:#eee;
	    border:10px solid #fff;
	    padding:15px; font-size:14px;
	}
	#session_pop p {
		display:block; margin:-2px 0 0 0;
	    line-height:17px; font-size:13px;
	}
	#session_btn{
		display:block; width:80px;
		font-weight:bold;
		color:#fff; padding:5px 6px 6px 6px;
		background-color:#06f;
		margin:9px auto 5px auto;
		font-size:14px;
		cursor:pointer; cursor:hand; text-decoration:none;  
		text-align:center;
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
	#session_countdown{text-align:center;font-weight:bold;margin:12px 0 14px 0;font-size:15px;}
	#session_pop, #session_btn{
		-moz-border-radius:6px; -webkit-border-radius:6px; -khtml-border-radius:6px; 
	}
</go:style>

</c:if>
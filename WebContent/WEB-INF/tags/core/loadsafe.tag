<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="The load safe function"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var loadSafe = {
		keepAlive: function(){
			loadSafe.intervalID = window.setInterval(function(){ stickler._tickle(); }, 300000);
		},
		loader: function($_id, _delay, _newUrl){

			var action = function() {
				$_id.attr('src','loading.jsp');
				setTimeout( function(){ $_id.attr('src', _newUrl); }, _delay);
			};

			$.ajax({
				type: 		'GET',
				async: 		false,
				timeout: 	5000,
				url: 		"ajax/json/simples_authenticate_user.jsp",
				data:		null,
				dataType: 	"json",
				cache: 		false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				error: 		loadSafe.forceLogin,
				success: 	function(json) {
					if(json.authenticated === true) {
						action();
					} else {
						loadSafe.forceLogin();
					}
				}
			});
		},
		forceLogin: function() {
			document.location.href = "simples.jsp?r=" + Math.floor(Math.random()*10001);
		}
	};
</go:script>
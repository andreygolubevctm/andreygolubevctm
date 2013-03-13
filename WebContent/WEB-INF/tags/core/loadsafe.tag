<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="The load safe function"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var loadSafe = {
		keepAlive: function(){
			loadSafe.intervalID = window.setInterval(function(){ stickler._tickle(); }, 300000);
		},
		loader: function($_id, _delay, _newUrl){		
			$_id.attr('src','loading.jsp');			
			setTimeout( function(){ $_id.attr('src', _newUrl); }, _delay);		
		}	
	};
</go:script>

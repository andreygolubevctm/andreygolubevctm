<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Javascript Error Reporter Tag"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script language="javascript">
	var jErr = true;
	var ajaxErr = false;
	window.onerror = function(msg, err_url, line){
		if (!jErr){
			jErr = true;
			var ajaxUrl = 'https://ecommerce.disconline.com.au/pc/apply?hPID=COREEN&hTID=000000000' +
						  '&errMsg=' + msg + 
						  '&page=' + escape(window.location.href) +
						  '&ledNo=CaptComp' +
						  '&url=' + escape(err_url) +
						  '&line=' + line + 
						  '&browser=' + navigator.userAgent;
			$.ajax({ url: ajaxUrl });
		} 				
		return false;
	}
	function notifyError(msg,url,ajaxjsp){

		if (!ajaxErr){
			ajaxErr = true;
			var ajaxUrl = 'https://ecommerce.disconline.com.au/pc/apply?hPID=COREEN&hTID=000000000' +
						  '&errMsg=' + msg + 
						  '&page=' + escape(window.location.href) +
						  '&ledNo=CaptComp' +
						  '&url=' + escape(url) +
						  '&line=' + ajaxjsp +
						  '&browser=' + navigator.userAgent;
			$.ajax({ url: ajaxUrl });
		} 				
		return false;
	}
	
</script>	

<%-- JAVASCRIPT --%>
<go:script marker="onready">
$('select#quote_vehicle_model').ajaxError(function(e, jqxhr, settings) {
		var message = jqxhr.status+'-'+jqxhr.statusText;
		var code = e.type+'-'+this.id;
		notifyError(message,settings.url,code);
	});
</go:script>


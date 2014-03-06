<%@ tag description="Used to control the call centre phone recording for compliance when recording sensitive data"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- Main content --%>
<agg:privacy xpath="${xpath}/compliance" make_private="${callCentre}" callback="health_application_compliance.callback(state);" >
	<health:credit_card_details xpath="${xpath}/credit" />
	<health:bank_details xpath="${xpath}/bank" />
</agg:privacy>
	<simples:dialogue id="29" vertical="health" mandatory="true" />

<%-- JavaScript --%>
<go:script marker="js-head">
	var health_application_compliance = {
		callback: function(state){
			if(state == 'undefined'){
				return false;
			} else if(state === true){
				var audio = 1; <%-- mute recording --%>
			} else {
				var audio = 0; <%-- resume recording --%>
			};
			var success = false;
			$.ajax({
				url: "ajax/xml/verint_rcapi.jsp?audio=" + audio,
				dataType: "xml",
				type: "GET",
				async: false,
				cache: false,
				success: function(){
					success = true;
					health_application_compliance.seize(state);
				},
				error: function(obj,txt) {
					FatalErrorDialog.exec({
						message:		"The recording could not be paused/started. Please notify your supervisor if this continues to occur. :" + txt,
						page:			"application_compliance.tag",
						description:	"health_application_compliance.callback().  AJAX Request failed: " + txt,
						data:			"state = " + state
					});
				},
				timeout:20000
			});
			return success;
		},
		<%-- Help prevent operators from being able to move whilst recording is muted --%>
		seize: function(state){
			if(state === true){
				$('.button-wrapper, #navContainer').addClass('invisible');
			} else {
				$('.button-wrapper, #navContainer').removeClass('invisible');
			};
		}
	}
</go:script>

<%@ tag description="Used to control the call centre phone recording for compliance when recording sensitive data"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- Main content --%>
<agg:privacy xpath="${xpath}/compliance" make_private="${callCentre}" callback="health_application_compliance.callback(state);" >
	<health:credit_card_details xpath="${xpath}" />
	<health:bank_details xpath="${xpath}/bank" />
</agg:privacy>

<simples:dialogue id="29" vertical="health" mandatory="true" />

<%-- JavaScript --%>
<go:script marker="js-head">
	var health_application_compliance = {
		callback: function(isMuted) {
			if (typeof isMuted === 'undefined') {
				return false;
			} else if (isMuted === true) {
				var audio = 1; <%-- mute recording --%>
			} else {
				var audio = 0; <%-- resume recording --%>
			}

			var success = false;

			$.ajax({
				url: "ajax/xml/verint_rcapi.jsp?audio=" + audio,
				dataType: "xml",
				type: "GET",
				async: false,
				cache: false,
				isFatalError:false,
				useDefaultErrorHandling:false,
				success: function(){
					success = true;
					health_application_compliance.seize(isMuted);
				},
				error: function(obj, txt, errorThrown) {

					meerkat.modules.errorHandling.error({
						message:		"The recording could not be paused/started. Please notify your supervisor if this continues to occur: " + txt + ' ' + errorThrown,
						page:			"application_compliance.tag",
						description:	"health_application_compliance.callback().  AJAX Request failed: " + txt + ' ' + errorThrown,
						data:			"state = " + isMuted,
						errorLevel: 	"warning"
					});
				},
				timeout:20000
			});

			<%-- Returns here because the ajax is synchronous --%>
			return success;
		},

		<%-- Lock down the application whilst recording is muted --%>
		seize: function(isMuted) {
			if (isMuted === true) {
				//$('.button-wrapper, #navContainer').addClass('invisible');
				meerkat.messaging.publish(meerkat.modules.events.WEBAPP_LOCK, { source:'application_compliance', disableFields:true });
			} else {
				//$('.button-wrapper, #navContainer').removeClass('invisible');
				meerkat.messaging.publish(meerkat.modules.events.WEBAPP_UNLOCK, { source:'application_compliance' });
			}
		}
	}
</go:script>

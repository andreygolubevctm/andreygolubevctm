<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a captcha code"%>										
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ tag import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ tag import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>

<%-- HTML --%>
<iframe name="recaptcha" id="recaptcha" class="recaptcha" src="ajax/recaptcha/recaptcha.jsp" width="280" height="100" frameborder="0" scrolling="no" style="border:0px solid red;"></iframe>

<%-- CSS --%>
<go:style marker="css-head">
	.recaptcha { overflow: hidden; float: left; }
</go:style>

<go:script marker="onready">
	function submitForm() {
		$("#mainform").validate().resetNumberOfInvalids();
			$('#slide6 :input').each(function(index) {
				if ($(this).attr("id")){
					$("#mainform").validate().element("#" + $(this).attr("id"));
				}
			});	
			if ($("#mainform").validate().numberOfInvalids() == 0) {
				// Commented out the need for captcha validation
				//if (frames["recaptcha"].validateCaptcha()=="valid") {
					nav.next();
					progressBar(slideIdx);
					
					Interim.show();
					
				//}
			}
	}
</go:script>

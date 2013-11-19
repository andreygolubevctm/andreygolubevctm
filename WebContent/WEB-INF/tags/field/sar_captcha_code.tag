<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a captcha code"%>										
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ tag import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ tag import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="length" 	required="false" rtexprvalue="true"	 description="the length of the captcha code" %>


<%-- CSS --%>
<go:style marker="css-head">
	#captcha_row {
		height:60px;
		width:520px;
	} 
	#captcha_row .fieldrow_label{
		width:200px;		
	}
	#captcha_row .fieldrow_value {
		width:295px;
	}
	#captcha_row .help_icon{
		float:none;
		display:inline-block;
		margin-left:3px;
		*margin-top: -52px;
		*position:relative;
		*left:255px;
	}
	#captcha_code {
		margin: 15px 10px;
		width:75px;
	}	
	#captcha_image {
		display:inline-block;
		width:150px; 
		height:50px;
	}
	
</go:style>

<%-- HTML --%>
<form:row label="Please enter the numbers displayed in the security code box" id="captcha_row">
	<field:input xpath="captcha/code" title="security code" required="false" maxlength="6"/>
	<img src="<c:url value="captcha.png" />" id="captcha_image" title="Click to refresh image">
	
	<div class="help_icon" id="help_22"></div>
</form:row>

<go:validate selector="captcha_code" rule="captcha" parm="true" message="The security code is incorrect." />

<go:script marker="onready">
$("#captcha_image").click(function(){
	Captcha.reload();
});
$.validator.addMethod(
	"captcha",
	function(value, element) {
		var result = "error";
		var dat = { "captcha_code": value };
		$.ajax({
			url: "ajax/json/check_captcha.jsp",
	        type: 'GET',
	        data: dat,
	        async: false,
	        cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
	        timeout: 30000,
	        dataType: "json",
	        success: function(json){
	            if (json.result) {
	            	result=json.result;
	            }
	        },
	        error: function(obj,txt){
				result="error";
	        }
	    });
	    switch(result){
	    	case "ok":
	    		return true; 
	    	case "incorrect":
				Captcha.reload();
				return false;
			case "error":
				FatalErrorDialog.display("A error occurred", dat);
				return false;
			default:
				FatalErrorDialog.display("Session Timeout", dat);
				return false;
	    }
	}, 
	"The security code is incorrect."
);
</go:script>
<go:script marker="js-head">
Captcha = new Object();
Captcha = {
	reload : function(){
		var ts = new Date().getTime();
		$("#captcha_image").attr("src","captcha.png?ts="+ts);
		$("#captcha_code").val("");
	}

}
$("#captcha_code").validate({
	onfocusout: false
});
</go:script>

<go:script marker="onready">
	$("#captcha_code").val("");
	function submitForm() {
		$("#mainform").validate().resetNumberOfInvalids();
			$('#slide2 :input').each(function(index) {
				if ($(this).attr("id")){
					$("#mainform").validate().element("#" + $(this).attr("id"));
				}
			});	
			if ($("#mainform").validate().numberOfInvalids() == 0) {
					//nav.next();
					progressBar(slideIdx);
					//Results.show();
					Roadside.fetchPrices();
			}
	}
</go:script>

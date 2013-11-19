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
		margin-top:-3px;
	} 
	#captcha_row .fieldrow_value {
		width:295px;
		position:relative;
	}
	#captcha_row .help_icon{
		position:absolute;
		right:0px;
		top:12px;
	}
	#captcha_code {
		margin: 15px 10px;
		width:75px;
	}	
	#captcha_image {
		display:inline-block;
		width:150px; 
		height:50px;
		cursor:pointer; cursor:hand;
	}
	.captcha_refresh{
		font-size:10px;
		width:160px;
		margin-top:3px;
		margin-right:20px;
		margin:2px 6px -2px 0;
		float:right;
	}
	.captcha_refresh a{
		font-size:10px;
		text-align:right;
		padding:0; margin:0;
	}
</go:style>

<%-- HTML --%>
<form:row label="Please enter the numbers displayed in the security code box" id="captcha_row">
	<field:input xpath="captcha/code" title="security code" required="false" maxlength="6"/>
	<img src="<c:url value="genCaptcha.png?bgImage=ctm.jpg&col1=1B3F99&col2=549B37&col3=FFFFFF&col4=99CD69" />" id="captcha_image" title="Click to refresh image">
	
	<div class="help_icon" id="help_22"></div>
	<core:clear/>
	<div class="captcha_refresh"><a href="javascript:;">Refresh security code</a></div>
	
</form:row>

<go:validate selector="captcha_code" rule="captcha" parm="true" message="The security code is incorrect." />

<go:script marker="onready">
$("#captcha_image").click(function(){
	Captcha.reload();
});
$(".captcha_refresh a").click(function(){
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
		var s=$("#captcha_image").attr("src");
		if (s.indexOf('&ts=')!=-1){
			s=s.substring(0,s.indexOf('&ts='));
		}
		$("#captcha_image").attr("src",s+"&ts="+ts);
		$("#captcha_code").val("");
	}

}
$("#captcha_code").validate({
	onfocusout: false
});
</go:script>

<go:script marker="onready">
	$("#captcha_code").val("");
</go:script>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>

<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<html>
	<head>
	<script src="../../common/js/jquery-1.4.2.min.js"></script>	
	<script type="text/javascript">
	 var RecaptchaOptions = {
			    theme : 'custom',
			    custom_theme_widget: 'recaptcha_widget'
	 };
	function validateCaptcha(){
		var response = $.ajax({
		   url: "recaptchaValidate.jsp",
		   async: false,
		   data: "recaptcha_response_field=" + jQuery("#recaptcha_response_field").val() + 
		         "&recaptcha_challenge_field=" + jQuery("#recaptcha_challenge_field").val()
		}).responseText;
		if ($.trim(response)=="invalid") {
	   	 	 $("#recaptcha_error").slideDown('normal');
	   		 Recaptcha.reload(); 		
	   	} else {
	   		$("#recaptcha_error").slideUp('normal');
	   	}
	   	return response;
	}
	$(document).ready(function() {
		$("#recaptcha_error").hide();
	});
	function newWords() {
		Recaptcha.reload();
		$('#recaptcha_error').slideUp('normal');
	}	
	</script>
	<style type="text/css">
		div#recaptcha_image > img{
			height:46px;
			width:240px;
		}
		a {
			font-family:sans-serif, arial;
			font-size:11px;
			color: #000000;
		}
		#recaptcha_response_field {
			margin-right: 10px;
			margin-top:6px;
		}
		#recaptcha_error {
			margin-top: -10px;
		}
	</style>
	</head>
	<body style="margin: 0 0 0 0;">
		<form action="" method="post">
		<div id="recaptcha_widget" style="display:none">
			<nobr><input type="text" id="recaptcha_response_field" name="recaptcha_response_field" size/><a href="javascript:newWords()">Get two new words</a></nobr>
			<div id="recaptcha_image"></div>
			<div id="recaptcha_error" style="color:red">Incorrect please try again</div>
		</div>
		</form>
	</body>
</html>

<%
	ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LeWg7sSAAAAALASmdtzxnqFV1jh6Q8dJGnlJTRb", "6LeWg7sSAAAAAIBLAoU4fcFiq8OlEdPyPcjZGqie", false);
	out.print(c.createRecaptchaHtml(null, null));
%>	
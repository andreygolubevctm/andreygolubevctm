<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Utility tag to create the head tag including markers needed for the gadget object framework."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%--
	Insert Markers 
	------------------------------
	css-head 			: Used to add internal style rules				&lt;br/&gt;
	css-href 			: Used to add external stylesheets 				&lt;br/&gt;
	js-href 			: Used for external javascripts					&lt;br/&gt;
	js-head 			: Used for internal javascript code				&lt;br/&gt;
	onready 			: Executed by jQuery's "ready()" function		&lt;br/&gt;
	jquery-ui 			: Used for jQuery UI components					&lt;br/&gt;
	jquery-val-rules 	: Used for jQuery UI validation rules			&lt;br/&gt;
	jquery-val-messages	: Used for jQuery UI validation messages		&lt;br/&gt;
	jquery-val-classrules: Used for jQuery UI validation classrules		&lt;br/&gt;
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 			required="false" description="Optional window title suffix"%>
<%@ attribute name="form" 			required="false" description="The form name (defaults to mainform)"%>
<%@ attribute name="errorContainer" required="false" description="The error container (defaults to #slideErrorContainer)"%>

<c:choose>
	<c:when test="${not empty form}">
		<c:set var="formName" value="${form}" />
	</c:when>
	<c:otherwise>
		<c:set var="formName" value="mainform" />
	</c:otherwise>
</c:choose>
<c:choose>
	<c:when test="${not empty errorContainer}">
		<c:set var="errorCont" value="${errorContainer}" />
	</c:when>
	<c:otherwise>
		<c:set var="errorCont" value="#slideErrorContainer" />
	</c:otherwise>
</c:choose>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
	<meta http-equiv="Expires" content="Sun, 22 Mar 1998 16:18:35 GMT"> 
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="X-UA-Compatible" content="IE=8; IE=7;" >
	
	
<%-- PAGE TITLE --%>
	<title>
		<c:choose>
			<c:when test="${title != ''}">
				${data["settings/window-title"]} - ${title}
			</c:when>
			<c:otherwise>
				${data["settings/window-title"]}
			</c:otherwise>
		</c:choose>
	</title>
	
<%-- STYLESHEETS --%>
	<link rel="shortcut icon" type="image/x-icon" href="common/images/favicon.ico" />
	<link rel='stylesheet' type='text/css' href='common/reset.css' />
	<link rel='stylesheet' type='text/css' href='common/base.css' />

	<link rel='stylesheet' type='text/css' href='brand/${data["settings/stylesheet"]}' />
	<link rel='stylesheet' type='text/css' href='brand/${data["settings/jquery-stylesheet"]}' />



	<go:insertmarker format="HTML" name="css-href" />
		
	<%-- Inline css included with tags --%>
	<style type="text/css">
		<go:insertmarker format="STYLE" name="css-head" />
	</style>
	
	<!--[if IE 8]>
		<link rel='stylesheet' type='text/css' href='common/avea_ie8.css' />
	<![endif]-->
	
	<noscript><img src="https://aihbudgetdirectcomau.112.2O7.net/b/ss/aihbudgetdirectcomau/1/H.8--NS/0?[AQB]&cdp=3&[AQE]" height="1" width="1" border="0" alt="" /></noscript> 

<%-- JAVASCRIPT --%>

	<script type="text/javascript" src="common/js/logging.js"></script>

	<%-- jQuery, jQuery UI and plugins --%>
	<script type="text/javascript" src="common/js/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="common/js/jquery-ui-1.8.custom.min.js"></script>
	<script type="text/javascript" src="common/js/jquery.address-1.3.2.js"></script>
	<script type="text/javascript" src="brand/avea/quote-engine.js"></script>
	<script type="text/javascript" src="common/js/scrollable.js"></script>
	<script type="text/javascript" src="common/js/jquery.tooltip.min.js"></script>
	<script type="text/javascript" src="common/js/jquery.corner-2.11.js"></script>	
	<script type="text/javascript" src="common/js/jquery.numeric.pack.js"></script>	
	<script type="text/javascript" src="common/js/jquery.scrollTo.js"></script>	
	<script type="text/javascript" src="common/js/jquery.maxlength.js"></script>
	<script type="text/javascript" src="common/js/jquery.number.format.js"></script>
	<script type="text/javascript" src="common/js/jquery.titlecase.js"></script>
	<script type="text/javascript" src="common/js/jquery.aihcustom.js"></script>	
	<script type="text/javascript" src="common/js/jquery.bgiframe.js"></script>	
	<script type="text/javascript" src="common/js/jquery.pngFix.pack.js"></script>
	<script type="text/javascript" src="common/js/aTit.js"></script>	

	<%--core:javascript_error_catcher / --%>

	<%-- External (href) javascript files included with tags --%>
	<go:insertmarker format="HTML" name="js-href" />
	
	<%-- Inline Javascript included with tags --%>
	<go:script>
		function showDoc(url,title){
			if (title) {
				title=title.replace(/ /g,"_");
			}
			window.open(url,title,"width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");
		}
		var validation = false;	
		function aihObj(){ }
		aih = new aihObj;	
	
		// Head javascript
		<go:insertmarker format="SCRIPT" name="js-head" /> 

		// jQuery UI 
		$(function() {
			<go:insertmarker format="SCRIPT" name="jquery-ui" />
			// Used to clear the error messages and help 
			$(".qe-window :input").click(function() {
				$("#mainform").validate().resetForm();
				$("#mainform").validate().resetNumberOfInvalids();
				$("#helpPanel").fadeOut(300);				
			});			
		});
			
		// jQuery document.onready
		$(document).ready(function() {
			$(document).pngFix(); 
			
			// jQuery validation rules & messages	
			$("#${formName}").validate({
				rules: {
					<go:insertmarker format="SCRIPT" name="jquery-val-rules" delim=","/>
				},
				messages: {
					<go:insertmarker format="SCRIPT" name="jquery-val-messages" delim=","/>
				},
				submitHandler: function(form) {
					form.submit();
				},
				onkeyup: function(element) { 
                	if (validation && element.name != "captcha_code") { 
						this.element(element); 
					}
				},
				ignore: ":disabled",
				errorElement: "div",
				wrapper: 'div',
				errorPlacement: function(error, element) {
		            offset = element.offset();
		            position = element.position();
		            error.insertBefore(element)
		            error.addClass('message');  // add a class to the wrapper
		            error.css('position', 'absolute');
		            error.css('left', position.left);
		            error.css('top', (position.top+22));
     		    },
				debug: false, 
        		onfocusout: function(element) { 
                	if (validation && element.name != "captcha_code") { 
						this.element(element); 
					}
				}
							
			});	
			<go:insertmarker format="SCRIPT" name="onready" />			
		});

	</go:script>
	
	<%-- ADDITIONAL CONTENT --%>
	<jsp:doBody />
</head>
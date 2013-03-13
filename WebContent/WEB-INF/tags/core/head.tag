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
<%@ attribute name="quoteType" 		required="false"	 description="The vertical this quote is associated with."%>
<%@ attribute name="title" 			required="false" description="Optional window title suffix"%>
<%@ attribute name="form" 			required="false" description="The form name (defaults to mainform)"%>
<%@ attribute name="errorContainer" required="false" description="The error container (defaults to #slideErrorContainer)"%>
<%@ attribute name="mainJs" 		required="false" description="The main js File for this page"%>
<%@ attribute name="mainCss" 		required="false" description="The main css File for this page"%>
<%@ attribute name="nonQuotePage" 	required="false" description="Flag as to whether the page is a quote (requiring transaction id)"%>

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

<c:set var="nonQuotePage">
	<c:choose>
		<c:when test="${not empty nonQuotePage}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
	<meta http-equiv="Expires" content="-1">
	<meta http-equiv="Pragma" content="no-cache">	
	<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7;">
	<meta name="format-detection" content="telephone=no">
	
	
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
	<link rel="shortcut icon" type="image/x-icon" href="common/images/favicon.ico">
	<link rel='stylesheet' type='text/css' href='brand/${data["settings/font-stylesheet"]}'>
	<link rel='stylesheet' type='text/css' href='common/reset.css'>
	<link rel='stylesheet' type='text/css' href='common/base.css'>

	<link rel='stylesheet' type='text/css' href='brand/${data["settings/jquery-stylesheet"]}'>
	<link rel='stylesheet' type='text/css' href='brand/${data["settings/stylesheet"]}'>

	<c:if test="${not empty mainCss}">
		<link rel='stylesheet' type='text/css' href='${go:AddTimestampToHref(mainCss)}'>
	</c:if>

	<go:insertmarker format="HTML" name="css-href" />

	<!--[if (lte IE 9) & (!IEMobile)]>
	<link rel='stylesheet' type='text/css' href='brand/${data["settings/ie-stylesheet"]}'>
	<![endif]-->

	<!--[if (IE 8) & (!IEMobile)]>
	<link rel='stylesheet' type='text/css' href='brand/${data["settings/ie8-stylesheet"]}'>
	<![endif]-->

	<!--[if (IE 7) & (!IEMobile)]>
	<link rel='stylesheet' type='text/css' href='brand/${data["settings/ie7-stylesheet"]}'>
	<![endif]-->

	<%-- Inline css included with tags --%>
	<style type="text/css">
		<go:insertmarker format="STYLE" name="css-head" />
	</style>


<%-- JAVASCRIPT --%>

	<script type="text/javascript" src="common/js/logging.js"></script>

	<%-- jQuery, jQuery UI and plugins --%>
	<script type="text/javascript" src="common/js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="common/js/jquery-ui-1.8.22.custom.min.js"></script>
	<script type="text/javascript" src="common/js/jquery.address-1.3.2.js"></script>
	<script type="text/javascript" src="common/js/quote-engine.js"></script>
	<script type="text/javascript" src="common/js/scrollable.js"></script>
	<script type="text/javascript" src="common/js/jquery.tooltip.min.js"></script>
	<script type="text/javascript" src="common/js/jquery.corner-2.11.js"></script>
	<script type="text/javascript" src="common/js/jquery.numeric.pack.js"></script>
	<script type="text/javascript" src="common/js/jquery.scrollTo.js"></script>
	<script type="text/javascript" src="common/js/jquery.maxlength.js"></script>
	<script type="text/javascript" src="common/js/jquery.number.format.js"></script>
	<script type="text/javascript" src="common/js/jquery.titlecase.js"></script>
	<script type="text/javascript" src="common/js/jquery.aihcustom.js"></script>
	<script type="text/javascript" src="common/js/jquery.pngFix.pack.js"></script>

	<%-- 	Adds global isNewQuote var to session and creates JS object to test if new quote.
			Needs to be included before the verticals main JS 
	--%>
	<c:if test="${empty nonQuotePage or nonQuotePage eq false}">
		<core:quote_check quoteType="${quoteType}" />
	</c:if>

	<c:if test="${not empty mainJs}">
		<script type="text/javascript" src="${go:AddTimestampToHref(mainJs)}"></script>
	</c:if>

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
		});

		// jQuery document.onready
		$(document).ready(function() {
			$(document).pngFix();

			//FIX: need method to check if IE needs to validate form
			// jQuery validation rules & messages
			var container = $('${errorCont}');
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
					var element_id = jQuery(element).attr('id');
					if ( !this.settings.rules.hasOwnProperty(element_id) || this.settings.rules[element_id].onkeyup == false) {
						return;
					};

					if (validation && element.name != "captcha_code") {
						this.element(element);
					};
				},
				ignore: ":disabled",
				errorContainer: container,
				errorLabelContainer: $("ul", container),
				wrapper: 'li',
				meta: "validate",
				debug: true,
				onfocusout: function(element) {
					if (validation && element.name != "captcha_code") {
						this.element(element);
					};
				},
				highlight: function( element, errorClass, validClass ) {
					$(element).addClass(errorClass).removeClass(validClass);

					if( this.numberOfInvalids() > 0 ) {
						$('#page > .right-panel').addClass('hidden'); //hide the side content
					};

					<%-- Radio button check --%>
					if( $(element).is(':radio')  ){
						$(element).closest('.fieldrow').addClass('errorGroup');

						if( $(element).hasClass('first-child') ) {
							//first-child and will always add to the error group (and checking class)
							$(element).addClass('checking');
						};
					}

				},
				unhighlight: function( element, errorClass, validClass ) {
					$(element).removeClass(errorClass).addClass(validClass);

					if( this.numberOfInvalids() === 0 ) {
						$('#page > .right-panel').removeClass('hidden'); //show the side content
					};

					<%-- Radio button check --%>
					if( $(element).is(':radio')  ){
						if( !$(element).parent().children('input[type=radio].checking').length || $(element).hasClass('first-child') ) {
							$(element).closest('.fieldrow').removeClass('errorGroup'); //Legitimate call (or first radio), so remove the group error
						} else if ( $(element).hasClass('last-child') || $(element).hasClass('first-child')  ) {
							$(element).parent().children('input[type=radio].checking').removeClass('checking'); //Last or first element, so remove the 'checking' flag
						};
					}

				}
			});
			<go:insertmarker format="SCRIPT" name="onready" />
		});

	</go:script>

	<%-- ADDITIONAL CONTENT --%>
	<jsp:doBody />
</head>
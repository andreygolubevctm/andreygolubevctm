<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Utility tag to create the head tag including markers needed for the gadget object framework."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="formName" value="meerkatRewardsForm" />

<%-- HTML --%>
<head>
	<meta charset="utf-8" />
	<title>Aleksandr Orlov</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
	<meta http-equiv="Expires" content="-1">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width" />

<%-- STYLESHEETS --%>
	<link rel="shortcut icon" type="image/x-icon" href="common/images/favicon.ico">
	<link rel="stylesheet" href="brand/ctm/competition/meerkat_rewards/css/foundation.css" />
	<link rel="stylesheet" href="brand/ctm/competition/meerkat_rewards/css/custom.css" />
	<link rel="stylesheet" href="brand/ctm/competition/meerkat_rewards/css/custom_ecomm.css" />
	<script src="brand/ctm/competition/meerkat_rewards/js/vendor/custom.modernizr.js"></script>

	<%-- Inline css included with tags --%>
	<style type="text/css">
		<go:insertmarker format="STYLE" name="css-head" />
	</style>

	<!--[if gte IE 9]>
		<style type="text/css">
		  .buttonMeerkat,
		  .meerkatBtnArrow {
			 filter: none;
		  }
		</style>
	<![endif]-->

<%-- JAVASCRIPT --%>
	<%--<script type="text/javascript" src="common/js/logging.js"></script>--%>

	<%-- jQuery, jQuery UI and plugins--%>
	<script type="text/javascript" src="common/js/jquery-1.7.2.min.js"></script>
	<%--<script type="text/javascript" src="brand/ctm/competition/meerkat_rewards/js/vendor/jquery.js"></script>
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
	<script type="text/javascript" src="common/js/qtip/jquery.qtip.min.js"></script>

	<%-- External (href) javascript files included with tags --%>
	<go:insertmarker format="HTML" name="js-href" />

	<%-- Inline Javascript included with tags --%>
	<go:script>
		/*function showDoc(url,title){
			if (title) {
				title=title.replace(/ /g,"_");
			}
			window.open(url,title,"width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");
		}
		var validation = false;
		function aihObj(){ }
		aih = new aihObj;*/

		// Head javascript
		<go:insertmarker format="SCRIPT" name="js-head" />

		/*var Settings =  new Object();
		Settings.vertical = '${data['settings/vertical']}';
		Settings.brand = '${data['settings/styleCode']}';*/

		// jQuery UI
		$(function() {
			<go:insertmarker format="SCRIPT" name="jquery-ui" />
		});

		// jQuery document.onready
		$(document).ready(function() {
			//$(document).pngFix();

			//FIX: need method to check if IE needs to validate form
			// jQuery validation rules & messages
			//var container = $('${errorCont}');
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

					/*if (validation && element.name != "captcha_code") {
						this.element(element);
					};*/
				},
				ignore: ":disabled",
				/*errorContainer: container,
				errorLabelContainer: $("ul", container),
				wrapper: 'li',*/
				meta: "validate",
				debug: false<%--,
				onfocusout: function(element) {
					if (validation && element.name != "captcha_code") {
						this.element(element);
					};
					if($(element).hasClass("error")){
						this.element(element);
					}
				},
				highlight: function( element, errorClass, validClass ) {
					$(element).addClass(errorClass).removeClass(validClass);

					if( this.numberOfInvalids() > 0 ) {
						$('#page > .right-panel').addClass('hidden'); //hide the side content
					};

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

					if( $(element).is(':radio')  ){
						if( !$(element).parent().children('input[type=radio].checking').length || $(element).hasClass('first-child') ) {
							$(element).closest('.fieldrow').removeClass('errorGroup'); //Legitimate call (or first radio), so remove the group error
						} else if ( $(element).hasClass('last-child') || $(element).hasClass('first-child')  ) {
							$(element).parent().children('input[type=radio].checking').removeClass('checking'); //Last or first element, so remove the 'checking' flag
						};
					}

				}--%>
			});
			<%--$("#${formName} input[type=checkbox], #${formName} input[type=radio]").on("change", function(e){
				if($(this).closest('.fieldrow').hasClass("errorGroup")){
					$("#${formName}").validate().element(this);
				}
			});--%>

			<go:insertmarker format="SCRIPT" name="onready" />

			<%--// fix for jquery UI 1.8.22 which does not allow any mouse
			// movement to trigger the click event on buttons
			// can be removed once jQuery UI is updated to 1.9 or above
			$('label.ui-button').click(function() {
				var chkOrRadio = $(this);
				var inputField = chkOrRadio.prev();

				if(inputField.prop("tagName") == 'INPUT'){
					inputFieldType = inputField.attr('type');

					if(inputFieldType == 'radio'){
						if(!inputField[0].checked){
							inputField[0].checked = !inputField[0].checked;
							inputField.button("refresh");
							inputField.change();
						}
					}
				}

				return false;
			});--%>
		});

	</go:script>

	<%-- ADDITIONAL CONTENT --%>
	<jsp:doBody />
</head>
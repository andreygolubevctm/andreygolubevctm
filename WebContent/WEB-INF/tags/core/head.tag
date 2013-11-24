<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Utility tag to create the head tag including markers needed for the gadget object framework."%>

<% response.setHeader("Cache-Control","no-cache, max-age=0"); %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%--
	Insert Markers
	------------------------------
	css-head 			: Used to add internal style rules				&lt;br/&gt;
	css-head-ie 		: Used to add internal ie style rules			&lt;br/&gt;
	css-head-ie9 		: Used to add internal ie9 style rules			&lt;br/&gt;
	css-head-ie8 		: Used to add internal ie8 style rules			&lt;br/&gt;
	css-head-ie7 		: Used to add internal ie7 style rules			&lt;br/&gt;
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
<%@ attribute name="loadjQuery" 		required="false" 	description="Flag as to whether jQuery is loaded"%>
<%@ attribute name="jqueryVersion"	 	required="false" 	description="Optional jquery version to load rather than the default"%>
<%@ attribute name="loadjQueryUI" 		required="false" 	description="Flag as to whether jQueryUI is loaded"%>

<c:if test="${empty loadjQuery}"><c:set var="loadjQuery">true</c:set></c:if>
<c:if test="${empty loadjQueryUI}"><c:set var="loadjQueryUI">true</c:set></c:if>
<c:if test="${empty jqueryVersion}"><c:set var="jqueryVersion">${data["settings/jquery-version"]}</c:set></c:if>

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
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
	<meta http-equiv="Expires" content="-1">
	<meta http-equiv="Pragma" content="no-cache">	
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
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

	<c:if test="${not empty data[\"settings/font-stylesheet\"]}">
		<go:style marker="css-href" href='brand/${data["settings/font-stylesheet"]}'></go:style>
	</c:if>
	<go:style marker="css-href" href='common/reset.css'></go:style>
	<go:style marker="css-href" href='common/base.css'></go:style>
	<c:if test="${loadjQuery == true}">
	<go:style marker="css-href" href='common/js/qtip/jquery.qtip.min.css'></go:style>
	</c:if>
	<c:if test="${loadjQueryUI == true}">
		<c:if test="${not empty data[\"settings/jquery-stylesheet\"]}">
			<go:style marker="css-href" href='brand/${data["settings/jquery-stylesheet"]}'></go:style>
		</c:if>
	</c:if>
	<c:if test="${not empty data[\"settings/stylesheet\"]}">
		<go:style marker="css-href" href='brand/${data["settings/stylesheet"]}'></go:style>
	</c:if>
	<c:if test="${not empty mainCss}">
		<go:style marker="css-href" href='${go:AddTimestampToHref(mainCss)}'></go:style>
	</c:if>


	<go:insertmarker format="HTML" name="css-href" />
	<c:if test="${not empty data[\"settings/ie-stylesheet\"]}">
		<go:style marker="css-href-ie" href='brand/${data["settings/ie-stylesheet"]}' conditional='(lte IE 9) & (!IEMobile)'></go:style>
	</c:if>
	<c:if test="${not empty data[\"settings/ie9-stylesheet\"]}">
		<go:style marker="css-href-ie9" href='brand/${data["settings/ie9-stylesheet"]}' conditional='(IE 9) & (!IEMobile)'></go:style>
	</c:if>
	<c:if test="${not empty data[\"settings/ie8-stylesheet\"]}">
		<go:style marker="css-href-ie8" href='brand/${data["settings/ie8-stylesheet"]}' conditional='(IE 8) & (!IEMobile)'></go:style>
	</c:if>
	<c:if test="${not empty data[\"settings/ie7-stylesheet\"]}">
		<go:style marker="css-href-ie7" href='brand/${data["settings/ie7-stylesheet"]}' conditional='(IE 7) & (!IEMobile)'></go:style>
	</c:if>

	<go:insertmarker format="STYLE" name="css-href-ie" />
	<go:insertmarker format="STYLE" name="css-href-ie9" />
	<go:insertmarker format="STYLE" name="css-href-ie8" />
	<go:insertmarker format="STYLE" name="css-href-ie7" />

	<%-- Inline css included with tags --%>
	<style type="text/css">
		<go:insertmarker format="STYLE" name="css-head" />
	</style>


<%-- JAVASCRIPT --%>

	<%-- jQuery, jQuery UI and plugins --%>

	<c:if test="${loadjQuery == true}">
		<go:script href="common/js/jquery-${jqueryVersion}.js" marker="js-href" />
		<go:script href="common/js/jquery.address-1.3.2.js" marker="js-href" />
		<go:script href="common/js/jquery.tooltip.min.js" marker="js-href" />
		<go:script href="common/js/jquery.corner-2.11.js" marker="js-href" />
		<go:script href="common/js/jquery.numeric.pack.js" marker="js-href" />
		<go:script href="common/js/jquery.scrollTo.js" marker="js-href" />
		<go:script href="common/js/jquery.maxlength.js" marker="js-href" />
		<go:script href="common/js/jquery.number.format.js" marker="js-href" />
		<go:script href="common/js/jquery.titlecase.js" marker="js-href" />
		<go:script href="common/js/jquery.aihcustom.js" marker="js-href" />
		<go:script href="common/js/jquery.pngFix.pack.js" marker="js-href" />
		<go:script href="common/js/qtip/jquery.qtip.min.js" marker="js-href" />
	</c:if>

	<go:script href="common/js/logging.js" marker="js-href" />

	<c:if test="${loadjQueryUI == true}">
		<go:script href="common/js/jquery-ui-1.8.22.custom.min.js" marker="js-href" />
	</c:if>

	<go:script href="common/js/modernizr.min.js" marker="js-href" />
	<c:if test="${empty nonQuotePage or nonQuotePage eq false}">
	<go:script href="common/js/quote-engine.js" marker="js-href" />
	<go:script href="common/js/scrollable.js" marker="js-href" />
	</c:if>
	<go:script marker="js-href" href="common/js/fields/fields.js" />
	<go:script marker="js-href" href="common/js/fields/jquery.mask.min.js" />


	<%-- 	Adds global isNewQuote var to session and creates JS object to test if new quote.
			Needs to be included before the verticals main JS 
	--%>
	<c:if test="${empty nonQuotePage or nonQuotePage eq false}">
		<core:quote_check quoteType="${quoteType}" />
	</c:if>

	<c:if test="${not empty mainJs}">
		<go:script href="${go:AddTimestampToHref(mainJs)}" marker="js-href" />
	</c:if>

	<%--core:javascript_error_catcher / --%>

	<%-- External (href) javascript files included with tags --%>
	<go:insertmarker format="HTML" name="js-href" />

	<%-- Remove any pre-existing hashes from the URL unless --%>
	<go:script marker="onready">
		<c:if test="${empty nonQuotePage || nonQuotePage eq false && (empty param.latest && empty param.amend && empty param.ConfirmationID)}">
			$.address.parameter("stage", QuoteEngine.getCurrentSlide() == 0 ? "start" : QuoteEngine.getCurrentSlide(), false );
		</c:if>
		//IE7 and IE8 support
		setUpPlaceHolders();
	</go:script>

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

		var Settings =  new Object();
		Settings.vertical = '${data['settings/vertical']}';
		Settings.brand = '${data['settings/styleCode']}';

		<c:if test="${loadjQueryUI == true}">
		// jQuery UI
		$(function() {
			<go:insertmarker format="SCRIPT" name="jquery-ui" />
		});
		</c:if>
		<c:if test="${loadjQuery == true}">
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
				wrapper: 'li',
				meta: "validate",
				debug: false,
					errorPlacement: function ($error, $element) {
						if ($element.hasClass("inlineValidation")) {
							/* display inline validation */
							var errorContainer = $element.parent().find(".errorField");
							errorContainer.empty();
							errorContainer.append($error.text());
						} else {
							/* display validation in a error container*/
							$("ul", container).append($error);
						}
					},
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
							if (!$(element).hasClass("inlineValidation")) {
						$('#page > .right-panel').addClass('hidden'); //hide the side content
								container.show();
							}
						}

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
						if ($(element).hasClass("inlineValidation")) {
							$(element).parent().find(".errorField").empty();
						}
					$(element).removeClass(errorClass).addClass(validClass);
					if( this.numberOfInvalids() === 0 ) {
								container.hide();
						$('#page > .right-panel').removeClass('hidden'); //show the side content
							}
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
				<%-- To prevent JS error being thrown from Simples --%>
				try{

					$("#${formName}").validate().addWrapper(container);

				}catch(e){}

				$('.anyPhoneType' ).each( function() {
					setPhoneMask($(this));
					$(this).keyup(function(event) {
						setPhoneMask($(this));
			});
				});
				$('input.landline' ).inputMask('(00) 0000 0000');
				$('input.mobile' ).inputMask('(0000) 000 000');

				$('input.phone' ).on('blur', function(event) {
					var id = $(this).attr('id');
					var hiddenFieldName = id.substr(0, id.indexOf('input'));
					var hiddenField = $('#' + hiddenFieldName);
					triggerContactDetailsEvent($(this), hiddenField );
				});
			</c:if>
			<go:insertmarker format="SCRIPT" name="onready" />

			<c:if test="${loadjQueryUI == true}">

			// fix for jquery UI 1.8.22 which does not allow any mouse
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
			});
			</c:if>
		});

		function is_mobile_device() {
			if( navigator.userAgent.match(/Android/i)
			|| navigator.userAgent.match(/iPhone/i)
			|| navigator.userAgent.match(/iPod/i)
			|| navigator.userAgent.match(/BlackBerry/i)
			|| navigator.userAgent.match(/Windows Phone/i)){
				return true;
			}else{
				return false;
			}
		}

		<c:if test="${loadjQuery == true}">
			//Clear IE placeholder so that it isn't included in validation
			if (!Modernizr.input['placeholder']) {
				(function ($) {
					$.each($.validator.methods, function (key, value) {
						$.validator.methods[key] = function () {
							if(arguments.length > 1) {
								var inputElement = $(arguments[1]);
								clearPlaceholder(inputElement);
								arguments[0] = inputElement.val();
								setPlaceholder(inputElement);
								}
							return value.apply(this, arguments);
						};
					});
				} (jQuery));
			}
		</c:if>
	</go:script>

	<c:if test="${not empty quoteType}">
		<%-- AGG-1331: Add JS object to call when needing to write transaction data  --%>
		<agg:write_quote_ajax quoteType="${quoteType}" />
	</c:if>

	<%-- ADDITIONAL CONTENT --%>
	<jsp:doBody />
</head>
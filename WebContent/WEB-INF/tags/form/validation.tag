<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Setup of the validation rules."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="formName" 			required="true" 	description=""%>
<%@ attribute name="errorContainer" 	required="false" 	description="The error container (defaults to #slideErrorContainer)"%>

<go:script marker="js-href"	href="common/js/jquery.validate-1.11.1.min.js"/>
<go:script marker="js-href"	href="common/js/jquery.validate.custom.js"/>

<c:choose>
	<c:when test="${not empty errorContainer}">
		<c:set var="errorCont" value="${errorContainer}" />
	</c:when>
	<c:otherwise>
		<c:set var="errorCont" value="#slideErrorContainer" />
	</c:otherwise>
</c:choose>


var validation = false;
var FormElements =  new Object();
$(document).ready(function() {

	FormElements.errorContainer =  $('${errorCont}');
	FormElements.form = $('#${formName}');
	FormElements.rightPanel = $('#page > .right-panel');

	//FIX: need method to check if IE needs to validate form
	// jQuery validation rules & messages
	FormElements.form.validate({
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
				$("ul", FormElements.errorContainer).append($error);
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

			if(this.numberOfInvalids() > 0 ) {
				if (!$(element).hasClass("inlineValidation")) {
					$('#page > .right-panel').addClass('hidden'); //hide the side content
					FormElements.errorContainer.show();
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
				FormElements.errorContainer.hide();
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
		$("#${formName}").validate().addWrapper(FormElements.errorContainer);
	}catch(e){}

});

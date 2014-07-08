<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Setup of the validation rules."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="errorContainer" 	required="false" 	description="The error container (defaults to #slideErrorContainer)"%>

<c:choose>
	<c:when test="${not empty errorContainer}">
		<c:set var="errorCont" value="${errorContainer}" />
	</c:when>
	<c:otherwise>
		<c:set var="errorCont" value="#slideErrorContainer" />
	</c:otherwise>
</c:choose>

var validation = false;
$(document).ready(function() {

	if (typeof jQuery.validator !== 'function') {
		if (typeof console.log === 'function') console.log('jquery.validate library is not available.');
		return;
	}

	<%-- This is needed to override the Validation library's hide() usage, so that we can control it in highlight()/unhighlight() --%>
	jQuery.validator.prototype.hideErrors = function() {
		this.addWrapper( this.toHide );
	}

	<%-- Refactored unhighlight() into different scope so that we can call it specifically --%>
	jQuery.validator.prototype.ctm_unhighlight = function( element, errorClass, validClass ) {
		if (!element) return;
		errorClass = errorClass || this.settings.errorClass;
		validClass = validClass || this.settings.validClass;

		<%-- console.log('ctm_unhighlight', element, errorClass, validClass); --%>

		<%-- Apply correct classes to element --%>
		if (element.type === "radio") {
			this.findByName(element.name).removeClass(errorClass).addClass(validClass);
		} else {
			$(element).removeClass(errorClass).addClass(validClass);
		}

		<%-- Get the parent row --%>
		var $wrapper = $(element).closest('.row-content, .fieldrow_value');
		var $errorContainer = $wrapper.find('.error-field');

		<%-- Delete the error message for this element --%>
		$errorContainer.find('label[for="' + element.name + '"]').remove();

		<%-- Do any other inputs in this row have errors? If so we don't want to mark the row as being valid. --%>
		if ($wrapper.find(':input.has-error').length > 0) {
			return;
		}

		<%-- Apply correct classes to row --%>
		$wrapper.removeClass(errorClass).addClass(validClass);

		<%-- Hide validation messages container --%>
		if ($errorContainer.find('label').length > 0) {
			if ($errorContainer.is(':visible')) {
				$errorContainer.stop().slideUp(100);
				<%-- console.log('error-field slideUp()'); --%>
			}
			else {
				$errorContainer.hide();
			}
		}
	}

	<%-- Init validator on all forms on the page --%>
	$('.journeyEngineSlide form').each(function(index, element){
		setupDefaultValidationOnForm( $(element) );
	});

});


<%-- function that can add validation rules to any form, can be called after page load if adding new form dynamically on the page --%>
function setupDefaultValidationOnForm( $formElement ){

	$formElement.validate({
		rules: {
			<go:insertmarker format="SCRIPT" name="jquery-val-rules" delim=","/>
		},
		messages: {
			<go:insertmarker format="SCRIPT" name="jquery-val-messages" delim=","/>
		},
		submitHandler: function(form) {
			form.submit();
		},
		invalidHandler: function(form, validator) {

	    	if (!validator.numberOfInvalids()) return;
	    	if(jQuery.validator.scrollingInProgress == true) return;

	    	var $ele = $(validator.errorList[0].element),
	    		$parent = $ele.closest('.row-content, .fieldrow_value');


			if($ele.attr('data-validation-placement') != null && $ele.attr('data-validation-placement') != ''){
				$ele2 = $($ele.attr('data-validation-placement'));
				if ($ele2.length > 0) $ele = $ele2;
			}

	    	<%-- If the element has a row parent (where the error message gets inserted to), then scroll to that instead --%>
	    	if ($parent.length > 0) $ele = $parent;
	    	jQuery.validator.scrollingInProgress = true;
	        meerkat.modules.utilities.scrollPageTo($ele,500,-50, function(){
	        	jQuery.validator.scrollingInProgress = false;
	        });
	    },
		ignore: ':hidden,:disabled',
		//wrapper: 'li',
		meta: 'validate',
		debug: true,
		errorClass: 'has-error',
		validClass: 'has-success',
		errorPlacement: function ($error, $element) {
			<%-- Inline validation
				An error message placeholder will be injected above the form element, generally inside the parent .row-content
			--%>

			var $referenceElement = $element;
			if($element.attr('data-validation-placement') != null && $element.attr('data-validation-placement') != ''){
				$referenceElement = $($element.attr('data-validation-placement'));
			}

			var parent = $referenceElement.closest('.row-content, .fieldrow_value');

			if(parent.length == 0) parent = $element.parent();

			var errorContainer = parent.children('.error-field');

			if (errorContainer.length == 0) {
				parent.prepend('<div class="error-field"></div>');
				errorContainer = parent.children('.error-field');
				errorContainer.hide().slideDown(100);
			}
			errorContainer.append($error);
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
		onfocusout: function(element, event) {
			<%-- Autocomplete-specific rule: do not perform validation if the autocomplete menu is open.
				This prevents the issue of focus leaving the input when clicking a menu option which triggers validation and reports an error on the input.
			--%>
			var $ele = $(element);
			if ($ele.hasClass('tt-query')) {
				var $menu = $ele.nextAll('.tt-dropdown-menu');
				if ($menu.length > 0 && $menu.first().is(':visible')) {
					return false;
				}
			}

			<%--
			TODO: Review this old code
			if (validation && element.name != "captcha_code") {
				this.element(element);
			};
			if ($(element).hasClass('has-error')) {
				this.element(element);
			}
			--%>

			<%-- Call the default onfocusout --%>
			$.validator.defaults.onfocusout.call(this, element, event);
		},
		highlight: function( element, errorClass, validClass ) {
			<%-- console.log('highlight', element); --%>

			<%-- Apply correct classes to element --%>
			if (element.type === "radio") {
				this.findByName(element.name).addClass(errorClass).removeClass(validClass);
			} else {
				$(element).addClass(errorClass).removeClass(validClass);
			}

			<%-- Apply correct classes to row --%>
			var $wrapper = $(element).closest('.row-content, .fieldrow_value');
			$wrapper.addClass(errorClass).removeClass(validClass);

			<%-- If the error container is not visible, show it.
				Delay/animation is used to return back to the event loop so that interactions still behave nicely
					e.g. you're focused into an input, then click on a radio button - if an error message appeared immediately your click could miss the radio.
			--%>
			var errorContainer = $wrapper.find('.error-field');
			if (errorContainer.find('label:visible').length === 0) {
				if (errorContainer.is(':visible')) {
					errorContainer.stop();
				}
				errorContainer.delay(10).slideDown(100);
				<%-- console.log('error-field slideDown()'); --%>
			}
		},
		unhighlight: function( element, errorClass, validClass ) {
			return this.ctm_unhighlight( element, errorClass, validClass );
		}
	});
}

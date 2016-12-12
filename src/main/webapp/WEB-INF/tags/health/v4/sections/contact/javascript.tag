<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Old validation JS - not sure if this should be kept"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="contactName"	value="${go:nameFromXpath(xpath)}_name" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"			value="${go:nameFromXpath(xpath)}_call" />

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	var contactEmailElement = $('#health_contactDetails_email');
	var contactMobileElementInput = $('#${contactNumber}_mobileinput');
	var contactOtherElementInput = $('#${contactNumber}_otherinput');

	phoneNumberInteractFunction = function(){

	var tel = $(this).val();

	<%-- IE sees the placeholder as its value so let's clear that if necessary--%>
	if( tel.indexOf('(00') === 0 ) {
	tel = '';
	}

	<%-- Optin for callback only if phone entered AND universal optin checked --%>
	if( $('#${name}_optin').is(':checked') ) {
	$('#${optIn}').prop('checked', (tel.length ? true : false));
	} else {
	$('#${optIn}').prop('checked', false);
	}


	}

	contactMobileElementInput.on('keyup keypress blur change', phoneNumberInteractFunction);
	contactOtherElementInput.on('keyup keypress blur change', phoneNumberInteractFunction);

	<%-- Use both elements as the checkbox sits over the label --%>
	var universalOptinElements = [
	$('#${name}_optin'),
	$('#${name}_optin').siblings('label').first()
	];

	<%-- Trigger blur events on phone and email elements when the
		the optin checkbox is clicked --%>
	for(var i = 0; i < universalOptinElements.length; i++) {
	universalOptinElements[i].on('click', function(){
	contactEmailElement.trigger('blur');
	contactOtherElementInput.trigger('blur');
	contactMobileElementInput.trigger('blur');
	});
	}
</go:script>
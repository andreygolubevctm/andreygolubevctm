<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Number"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="fieldXpath" value="${xpath}/flexiContactNumber" />
<form_v3:row label="Your phone number" fieldXpath="${fieldXpath}" className="clear required_input">
	<field_v1:flexi_contact_number xpath="${fieldXpath}" required="${required}" maxLength="20"/>
</form_v3:row>


<group_v3:contact_numbers_hidden xpath="${xpath}/contactNumber" />
<field_v1:hidden xpath="health/altContactFormRendered" constantValue="Y" />

<%-- JAVASCRIPT --%>
<go:script marker="onready">
<%-- COMPETITION START --%>
$('#health_contactDetails_competition_optin').on('change', function() {
if ($(this).is(':checked')) {
$('#${contactName}').setRequired(true, 'Please enter your name to be eligible for the competition');
contactEmailElement.setRequired(true, 'Please enter your email address to be eligible for the competition');
contactMobileElementInput.addRule('requireOneContactNumber', true, 'Please enter your phone number to be eligible for the competition');
}
else {
<c:if test="${empty callCentre and required == false}">$('#${contactName}').setRequired(false);</c:if>
<%-- This rule applies to both call center and non call center users --%>
<c:if test="${not empty callCentre or required}">
	$('#${contactName}').setRequired(true, 'Please enter name');
</c:if>
<%-- These rules are separate to the callCenter one above as they only apply to non simples uers --%>
<c:if test="${required}">
	contactEmailElement.setRequired(true, 'Please enter your email address');
	contactMobileElementInput.addRule('requireOneContactNumber', true, 'Please include at least one phone number');
</c:if>
<c:if test="${required == false}">
	contactEmailElement.setRequired(false);
	contactMobileElementInput.removeRule('requireOneContactNumber');
	$('#${contactName}').valid();
	contactEmailElement.valid();
	contactMobileElementInput.valid();
	contactOtherElementInput.valid();
</c:if>
}
});
<%-- COMPETITION END --%>
</go:script>
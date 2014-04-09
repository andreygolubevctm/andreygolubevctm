<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-your_details">


	<form:fieldset legend="Your details" >

		<form:row label="First Name" className="health-your_details-name-group firstname">
			<field:input xpath="${xpath}/firstName" title="first name" required="true" className="health-your_details-first" size="13" />
		</form:row>

		<form:row label="Surname" className="health-your_details-name-group surname">
			<field:input xpath="${xpath}/surname" title="surname" required="true" className="health-your_details-surname" size="13" />
		</form:row>

		<form:row label="Date of Birth" className="health-your_details-dob-group">
			<field:person_dob xpath="${xpath}/dob" title="" required="true" />
		</form:row>

		<h5>Please enter at least one phone number</h5>

		<form:row label="Mobile" className="health-your_details-number-group mobile">
			<field:contact_mobile xpath="${xpath}/mobile" className="health-your_details-number-mobile health_your_details_number_required" required="false" />
		</form:row>

		<form:row label="Other" className="health-your_details-number-group other">
			<field:contact_telno xpath="${xpath}/otherNumber" className="health-your_details-number-other health_your_details_number_required" title="Please enter the other number" required="false" />
		</form:row>
		
		<h5>Please enter your email address</h5>

		<form:row label="Email" className="health-your_details-email-group">
			<field_new:email xpath="${xpath}/email" required="true" />
		</form:row>

		<form:row label="Can we contact you via" className="health-your_details-opt-group">
			<field:checkbox xpath="${xpath}/optEmail" value="Y" label="true" required="false" title="email" /> <span>and</span>
			<field:checkbox xpath="${xpath}/optPhone" value="Y" label="true" required="false" title="phone" />
		</form:row>
	
	</form:fieldset>

</div>

<go:script marker="js-head">
	<%-- Requiring at least ONE contact number --%>
	jQuery.validator.addMethod('health_your_details_number_required', function(val, el) {
    	var $module = $(el).parents('#${name}-selection');
    	return $module.find('input.health_your_details_number_required:filled').length;
	});
	jQuery.validator.addClassRules('health_your_details_number_required', {
	    'health_your_details_number_required' : true
	});
	jQuery.validator.messages.health_your_details_number_required = 'Please enter at least one phone number';
</go:script>
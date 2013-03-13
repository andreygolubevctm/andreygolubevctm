<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true"
	description="additional css class attribute"%>
<%@ attribute name="id" required="false" rtexprvalue="true"
	description="optional id for this slide"%>

<%-- VARIABLES --%>


<%-- HTML --%>
<form:fieldset legend="Now some info about the Regular Driver of the car" helpId="1">
	
	<form:row label="Gender" id="genderRow">
		<field:array_radio xpath="quote/drivers/regular/gender" required="true"
			className="regular_gender" id="regular_gender" items="M=Male,F=Female"
			title="the regular driver's gender" />
	</form:row>
	
	<form:row label="Date of birth">
		<field:person_dob xpath="quote/drivers/regular/dob" required="true"
			title="regular driver's" />
	</form:row>
	
	<form:row label="Age Regular Driver obtained a drivers licence">
		<field:age_licence xpath="quote/drivers/regular/licenceAge" required="true"
			title="regular" />
	</form:row>

	<form:row label="Owns another car" id="ownsAnotherCarRow">
		<field:array_radio xpath="quote/drivers/regular/ownsAnotherCar"
			required="true" className="other_car" id="other_car"
			items="Y=Yes,N=No" title="if the regular driver owns another car" />
	</form:row>
</form:fieldset>

<form:fieldset legend="Regular Driver's No Claims Discount or Rating Discount info">
	<group:ncd_selection xpath="quote/drivers/regular" />
</form:fieldset>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#other_car, #claims, #regular_gender, #next_slide1").buttonset();
	});
</go:script>








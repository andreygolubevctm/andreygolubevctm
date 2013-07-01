<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="dependant details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="count" 		required="true"	 rtexprvalue="true"	 description="The dependant number (step)" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}${count}" class="health_dependant_details dependant${count}" data-id="${count}">

	<h5>${count}</h5>
	
	<div class="items">

		<form:row label="Title" id="titleRow">
			<field:import_select xpath="${xpath}${count}/title" title="dependant ${count}'s title" required="false" url="/WEB-INF/option_data/titles_pithy.html" />	
		</form:row>
	
		<form:row label="First name" className="halfrow">
			<field:input xpath="${xpath}${count}/firstName" title="dependant ${count}'s first name" required="false" size="13" />
		</form:row>
	
		<form:row label="Surname" className="halfrow right">
			<field:input xpath="${xpath}${count}/lastname" title="dependant ${count}'s last name" required="false" size="13" />
		</form:row>
		
		<core:clear />
		
		<form:row label="Date of birth" >
			<health:dependent_dob xpath="${xpath}${count}/dob" required="true" title="dependant ${count}'s" />
		</form:row>
		
		<form:row label="Name of school your child is attending" id="${name}${count}_schoolGroup" className="health_dependant_details_schoolGroup" helpId="290">
			<field:input xpath="${xpath}${count}/school" title="dependant ${count}'s school" required="false" />
		</form:row>
		
		<form:row label="Student ID number" id="${name}${count}_schoolIDGroup" className="health_dependant_details_schoolIDGroup">
			<field:input xpath="${xpath}${count}/schoolID" title="dependant ${count}'s student ID number" required="false" />
		</form:row>
		
		<form:row label="Date study commenced" id="${name}${count}_schoolDateGroup" className="health_dependant_details_schoolDateGroup">
			<field:input xpath="${xpath}${count}/schoolDate" title="dependant ${count}'s study commencement date" required="false" />
		</form:row>

		<form:row label="Is this dependant not married or living in a defacto relationship and earning less than $20,500 p/annum?" id="${name}${count}_maritalincomestatusGroup" className="health_dependant_details_maritalincomestatus">
			<field:array_radio id="${name}${count}_maritalincomestatus" xpath="${xpath}${count}/maritalincomestatus" required="true" items="Y=Yes,N=No" title="if dependant ${count} is not married or living in a defacto relationship and earning less than $20,500 p/annum?" className="health-person-details" />
		</form:row>
	
	</div>
</div>

<%-- VALIDATION --%>
<go:validate selector="${name}${count}_maritalincomestatus" rule="defactoConfirmation" parm="true" message='Sorry, the highlighted dependant cannot be added to this policy.  Please contact us if you require assistance.' />
<go:validate selector="${name}${count}_title" rule="required" parm="true" message="Please select dependant ${count}'s title"/>
<go:validate selector="${name}${count}_firstName" rule="required" parm="true" message="Please enter dependant ${count}'s first name"/>
<go:validate selector="${name}${count}_lastname" rule="required" parm="true" message="Please enter dependant ${count}'s last name"/>
<go:validate selector="${name}${count}_school" rule="required" parm="true" message="Please enter dependant ${count}'s school"/>


<%-- CSS --%>
<go:style marker="css-head"> 
	#${name}${count}_maritalincomestatusGroup {
		display: none;
	}
	
	#${name}${count}_schoolGroup .fieldrow_value {
		padding-top: 8px;
	}
</go:style>

<go:script marker="onready">
	<%-- NOTE: additional binds and functionality can be found in the dependants tag --%>
	$(function() {
		$("#${name}${count}_maritalincomestatus").buttonset();
	});
</go:script>

<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="dependant details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="count" 		required="true"	 rtexprvalue="true"	 description="The dependant number (step)" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}${count}" class="health_dependant_details dependant${count}" data-id="${count}">

	<form_new:row>
		<div class="inlineHeadingWithButton">
			<h5>Dependant ${count}</h5> <a href="javascript:void(0);" class="remove-last-dependent btn btn-danger" title="Remove last dependent">Remove Dependant</a>
		</div>
	</form_new:row>
	
	<div class="items">

		<c:set var="fieldXpath" value="${xpath}${count}/title" />
		<form_new:row fieldXpath="${fieldXpath}" label="Title" >
			<field_new:import_select xpath="${fieldXpath}" title="dependant ${count}'s title" required="true" url="/WEB-INF/option_data/titles_pithy.html" />
		</form_new:row>
	
		<c:set var="fieldXpath" value="${xpath}${count}/firstName" />
		<form_new:row fieldXpath="${fieldXpath}" label="First Name" >
			<field_new:input xpath="${fieldXpath}" title="dependant ${count}'s first name" required="true" className="sessioncamexclude" />
		</form_new:row>
	
		<c:set var="fieldXpath" value="${xpath}${count}/middleName" />
		<form_new:row fieldXpath="${fieldXpath}" label="Middle Name" className="health_dependant_details_middleName">
			<field_new:input xpath="${fieldXpath}" title="dependant ${count}'s middle name" required="false" className="sessioncamexclude" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/lastname" />
		<form_new:row fieldXpath="${fieldXpath}" label="Last Name" >
			<field_new:input xpath="${fieldXpath}" title="dependant ${count}'s last name" required="true" className="sessioncamexclude" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/dob" />
		<form_new:row fieldXpath="${fieldXpath}" label="Date of Birth" >
			<field_new:person_dob xpath="${fieldXpath}" title="dependant ${count}'s" required="true" ageMin="0" className="sessioncamexclude"  />
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}${count}/school" />
		<form_new:row fieldXpath="${fieldXpath}" label="Name of school your child is attending" id="${name}${count}_schoolGroup" className="health_dependant_details_schoolGroup" helpId="290">
			<field_new:input xpath="${fieldXpath}" title="dependant ${count}'s school" required="true" className="sessioncamexclude" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/schoolID" />
		<form_new:row fieldXpath="${fieldXpath}" label="Student ID Number" id="${name}${count}_schoolIDGroup" className="health_dependant_details_schoolIDGroup">
			<field_new:input xpath="${fieldXpath}" title="dependant ${count}'s student ID number" required="false" className="sessioncamexclude" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/schoolDate" />
		<form_new:row fieldXpath="${fieldXpath}" label="Date Study Commenced" id="${name}${count}_schoolDateGroup" className="health_dependant_details_schoolDateGroup">
			<field_new:input xpath="${fieldXpath}" title="dependant ${count}'s study commencement date" required="false" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/maritalincomestatus" />
		<form_new:row fieldXpath="${fieldXpath}" label="Is this dependant not married or living in a defacto relationship and earning less than $20,500 p/annum?" id="${name}${count}_maritalincomestatusGroup" className="health_dependant_details_maritalincomestatus">
			<field_new:array_radio id="${name}${count}_maritalincomestatus" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="if dependant ${count} is not married or living in a defacto relationship and earning less than $20,500 p/annum?" className="health-person-details" />
		</form_new:row>

	</div>
</div>

<%-- VALIDATION --%>
<go:validate selector="${name}${count}_maritalincomestatus" rule="defactoConfirmation" parm="true" message='Sorry, the highlighted dependant cannot be added to this policy.  Please contact us if you require assistance.' />
<go:validate selector="${name}${count}_dob" rule="limitDependentAgeToUnder25" parm="true" message='Your child cannot be added to the policy as they are aged 25 years or older. You can still arrange cover for this dependant by applying for a separate singles policy or please contact us if you require assistance.' />

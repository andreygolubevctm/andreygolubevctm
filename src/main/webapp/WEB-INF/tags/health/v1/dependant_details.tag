<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="dependant details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="count" 		required="true"	 rtexprvalue="true"	 description="The dependant number (step)" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}${count}"/>


<%-- HTML --%>
<div id="${name}" class="health_dependant_details dependant${count}" data-id="${count}">

	<form_v2:row>
		<div class="inlineHeadingWithButton">
			<h5>Dependant ${count}</h5> <a href="javascript:void(0);" class="remove-last-dependent btn btn-danger" title="Remove last dependant">Remove Dependant</a>
		</div>
	</form_v2:row>
	
	<div class="items">

		<c:set var="fieldXpath" value="${xpath}${count}/title" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Title" >
			<field_v2:import_select xpath="${fieldXpath}" title="dependant ${count}'s title" required="true" url="/WEB-INF/option_data/titles_pithy.html" />
		</form_v2:row>
	
		<c:set var="fieldXpath" value="${xpath}${count}/firstName" />
		<form_v2:row fieldXpath="${fieldXpath}" label="First Name" >
			<field_v2:input xpath="${fieldXpath}" title="dependant ${count}'s first name" required="true" className="sessioncamexclude" additionalAttributes=" data-rule-personName='true' " />
		</form_v2:row>
	
		<c:set var="fieldXpath" value="${xpath}${count}/middleName" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Middle Name" className="health_dependant_details_middleName">
			<field_v2:input xpath="${fieldXpath}" title="dependant ${count}'s middle name" required="false" className="sessioncamexclude" additionalAttributes=" data-rule-personName='true' " />
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/lastname" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Last Name" >
			<field_v2:input xpath="${fieldXpath}" title="dependant ${count}'s last name" required="true" className="sessioncamexclude" additionalAttributes=" data-rule-personName='true' " />
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/dob" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Date of Birth" >
			<field_v2:person_dob xpath="${fieldXpath}" title="dependant ${count}'s date of birth" required="true" ageMin="0" additionalAttributes=" data-rule-limitDependentAgeToUnder25='true' " />
		</form_v2:row>

		<c:set var="fieldXpath" value="${xpath}${count}/fulltime" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Full-time student" id="${name}_fulltimeGroup"
					  className="health_dependant_details_fulltimeGroup">
			<field_v2:array_radio xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="dependant ${count}'s fulltime status" className="sessioncamexclude"
								  additionalAttributes=" data-rule-validateFulltime='true' " disableErrorContainer="${false}"/>
		</form_v2:row>

		<c:set var="fieldXpath" value="${xpath}${count}/school" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Name of school your child is attending" id="${name}_schoolGroup"
					  className="health_dependant_details_schoolGroup" helpId="290">
			<field_v2:input xpath="${fieldXpath}" title="dependant ${count}'s school" required="true" className="sessioncamexclude" />
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/schoolID" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Student ID Number" id="${name}_schoolIDGroup"
					  className="health_dependant_details_schoolIDGroup">
			<field_v2:input xpath="${fieldXpath}" title="dependant ${count}'s student ID number" required="false" className="sessioncamexclude" />
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/schoolDate" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Date Study Commenced" id="${name}_schoolDateGroup"
					  className="health_dependant_details_schoolDateGroup">
			<field_v2:basic_date xpath="${fieldXpath}" title="dependant ${count}'s study commencement date" required="false" />
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}${count}/maritalincomestatus" />
		<form_v2:row fieldXpath="${fieldXpath}"
					  label="Is this dependant not married or living in a defacto relationship and earning less than $20,500 p/annum?"
					  id="${name}_maritalincomestatusGroup" className="health_dependant_details_maritalincomestatus">
			<field_v2:array_radio id="${name}_maritalincomestatus" xpath="${fieldXpath}" required="true"
								   items="Y=Yes,N=No" additionalAttributes=" data-rule-defactoConfirmation='true' "
								   title="if dependant ${count} is not married or living in a defacto relationship and earning less than $20,500 p/annum?"
								   className="health-person-details"/>
		</form_v2:row>

		<c:set var="fieldXpath" value="${xpath}${count}/apprentice" />
		<form_v2:row fieldXpath="${fieldXpath}"
					label="Apprentice earning less than $30,000pa?"
					id="${name}_apprenticeGroup" className="health_dependant_details_apprenticeGroup">
			<field_v2:array_radio id="${name}_apprentice" xpath="${fieldXpath}" required="true"
								items="Y=Yes,N=No"
								title="if dependant ${count} is an apprentice earning less than $30,000pa?"
								className="health-person-details"/>
		</form_v2:row>

	</div>
</div>

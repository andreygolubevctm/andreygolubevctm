<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="title" required="false" rtexprvalue="true" description="the title"%>
<%@ attribute name="id" required="true" rtexprvalue="true" description="the id"%>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="field_firstname" value="${xpath}/firstname" />
<c:set var="field_firstname" value="${go:nameFromXpath(field_firstname)}" />
<c:set var="field_surname" value="${xpath}/surname" />
<c:set var="field_surname" value="${go:nameFromXpath(field_surname)}" />
<c:set var="field_dob" value="${xpath}/dob" />
<c:set var="field_dob" value="${go:nameFromXpath(field_dob)}" />

<c:set var="dobTitle">
	<c:choose>
		<c:when test="${id eq 'partner'}">applicant's partners</c:when>
		<c:otherwise>primary applicant's</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div class="health-person-details-${id} health-person-details ${id}">

	<form_new:fieldset legend="${title} Details">

		<c:set var="fieldXpath" value="${xpath}/title" />
		<form_new:row fieldXpath="${fieldXpath}" label="Title" >
			<field_new:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title"/>
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/firstname" />
		<form_new:row fieldXpath="${fieldXpath}" label="First Name" className="halfrow" >
			<field:person_name xpath="${fieldXpath}" required="true" title="${title} first name" className="contactField"/>
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/middleName" />
		<form_new:row fieldXpath="${fieldXpath}" label="Middle Name" className="health_person-details_middlename">
			<field:person_name xpath="${fieldXpath}" required="false" title="${title} middle name" />
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/surname" />
		<form_new:row fieldXpath="${fieldXpath}" label="Last Name" className="halfrow right" >
			<field:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField" />
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/dob" />
		<form_new:row fieldXpath="${fieldXpath}" label="Date of Birth" className="changes-premium">
			<field_new:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/gender" />
		<form_new:row fieldXpath="${fieldXpath}" label="Gender" id="${name}_genderRow">
			<field_new:array_radio id="${name}_gender" xpath="${fieldXpath}" required="true" items="M=Male,F=Female" title="${title} gender" className="health-person-details person-gender" />
		</form_new:row>

		<c:if test="${id == 'partner'}">
			<c:set var="fieldXpath" value="${xpath}/authority" />
			<form_new:row fieldXpath="${fieldXpath}" label="Would you like to give your partner authority to make claims, changes or enquire about the policy on behalf of anyone listed on the policy?" id="${name}_authority_group" className="health_person-details_authority_group hidden">
				<field_new:array_radio id="${name}_authority" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="${title} authority permission" className="health-person-details-authority" />
			</form_new:row>
		</c:if>

	</form_new:fieldset>

</div>
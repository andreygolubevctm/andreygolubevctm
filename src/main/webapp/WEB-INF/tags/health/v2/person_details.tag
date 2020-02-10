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
		<c:when test="${id eq 'partner'}">partner's</c:when>
		<c:otherwise>primary person's</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div class="health-person-details-${id} health-person-details ${id}">

	<form_v3:fieldset legend="${title} Details">

		<c:set var="fieldXpath" value="${xpath}/title" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Title" >
			<field_v2:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title" additionalAttributes=" data-rule-genderTitle='true' "/>
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/firstname" />
		<form_v3:row fieldXpath="${fieldXpath}" label="First Name">
			<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} first name" className="contactField" maxlength="24" />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/middleName" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Middle Name" className="health_person-details_middlename">
			<field_v1:person_name xpath="${fieldXpath}" required="false" title="${title} middle name" />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/surname" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Last Name">
			<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField" />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/dob" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Date of Birth" className="changes-premium">
			<field_v2:person_dob xpath="${fieldXpath}" title="${dobTitle}" required="true" ageMin="16" ageMax="120" />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/gender" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Gender" id="${name}_genderRow">
			<field_v2:array_radio id="${name}_gender" xpath="${fieldXpath}" required="true" items="M=Male,F=Female" title="${title} gender" className="health-person-details person-gender" />
		</form_v3:row>

		<c:if test="${id == 'partner'}">
			<c:set var="fieldXpath" value="${xpath}/authority" />
			<form_v3:row fieldXpath="${fieldXpath}" label="Would you like to give your partner authority to make claims, changes or enquire about the policy on behalf of anyone listed on the policy?" id="${name}_authority_group" className="health_person-details_authority_group hidden">
				<field_v2:array_radio id="${name}_authority" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="${title} authority permission" className="health-person-details-authority" />
			</form_v3:row>
		</c:if>

	</form_v3:fieldset>

</div>

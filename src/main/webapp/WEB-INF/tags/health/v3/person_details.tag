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



		<div class="health-person-details-${id} health-person-details ${id}">
			<field_v3:name_group xpath="${xpath}" />
		</div>

		<c:set var="fieldXpath" value="${xpath}/dob" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Date of Birth" className="changes-premium">
			<field_v2:person_dob xpath="${fieldXpath}" title="${dobTitle}" required="true" ageMin="16" ageMax="120" />
		</form_v2:row>

		<c:set var="fieldXpath" value="${xpath}/gender" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Gender" id="${name}_genderRow" smRowOverride="5">
			<field_v2:array_radio id="${name}_gender" xpath="${fieldXpath}" required="true" items="M=Male,F=Female" title="${title} gender" className="health-person-details person-gender" />
		</form_v2:row>

		<c:if test="${id == 'partner'}">
			<c:set var="fieldXpath" value="${xpath}/authority" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Would you like to give your partner authority to make claims, changes or enquire about the policy on behalf of anyone listed on the policy?" id="${name}_authority_group" className="health_person-details_authority_group hidden">
				<field_v2:array_radio id="${name}_authority" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="${title} authority permission" className="health-person-details-authority" />
			</form_v2:row>
		</c:if>



</div>
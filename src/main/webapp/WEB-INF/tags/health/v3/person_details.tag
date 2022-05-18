<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="title" required="false" rtexprvalue="true" description="the title"%>
<%@ attribute name="id" required="true" rtexprvalue="true" description="the id"%>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
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

		<c:if test="${id eq 'partner'}">
			<simples:dialogue id="159" vertical="health" mandatory="true"  className="simplesDynamicElements" />
			<field_v3:name_group xpath="${xpath}" showInitial="true" firstNameMaxlength="24" lastNameMaxlength="23" middleInitialMaxlength="1" label="Name as it appears on Medicare Card" className="no-label" />
		</c:if>

		<c:if test="${id eq 'partner'}">
			<simples:dialogue id="160" vertical="health" mandatory="true"  className="simplesDynamicElements" />
		</c:if>

		<c:set var="fieldXpath" value="${xpath}/dob" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Date of Birth" className="changes-premium no-label">
			<field_v2:person_dob xpath="${fieldXpath}" title="${dobTitle}" required="true" ageMin="16" ageMax="120" disableErrorContainer="${true}" />
		</form_v2:row>

		<c:choose>
			<c:when test="${id eq 'partner'}">
				<simples:dialogue id="161" vertical="health" mandatory="true"  className="simplesDynamicElements" />
			</c:when>
			<c:otherwise>
				<simples:dialogue id="147" vertical="health" mandatory="true"  className="simplesDynamicElements" />
			</c:otherwise>
		</c:choose>

		<c:choose>
			<c:when test="${id eq 'partner'}">
				<simples:dialogue id="162" vertical="health" mandatory="true"  className="simplesDynamicElements" />
			</c:when>
			<c:otherwise>
				<simples:dialogue id="148" vertical="health" mandatory="true"  className="simplesDynamicElements" />
			</c:otherwise>
		</c:choose>

		<c:set var="fieldXpath" value="${xpath}/gender" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Gender" id="${name}_genderRow" smRowOverride="5" className="no-label">
			<field_v2:array_radio id="${name}_gender" xpath="${fieldXpath}" required="true" items="M=Male,F=Female" title="${title} gender" className="health-person-details person-gender" disableErrorContainer="${true}" />
		</form_v2:row>

		<c:if test="${id == 'partner'}">
			<c:set var="fieldXpath" value="${xpath}/authority" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Would you like to give your partner authority to make claims, changes or enquire about the policy on behalf of anyone listed on the policy?" id="${name}_authority_group" className="health_person-details_authority_group hidden" renderLabelAsSimplesDialog="true">
				<field_v2:array_radio id="${name}_authority" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="${title} authority permission" className="health-person-details-authority" />
			</form_v2:row>
		</c:if>
</div>

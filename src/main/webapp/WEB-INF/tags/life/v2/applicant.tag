<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="label" 		required="false"	 rtexprvalue="true"	 description="The row heading label." %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<c:if test="${empty label}">
	<c:set var="label"  value="About You" />
</c:if>

<c:set var="error_phrase" value="the primary person's " />
<c:set var="error_phrase_postcode" value="" />
<c:if test="${fn:contains(name, 'partner')}">
	<c:set var="error_phrase" value="partner's " />
	<c:set var="error_phrase_postcode" value="partner's " />
</c:if>

<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
	</jsp:attribute>

	<jsp:body>
		<form_v2:fieldset legend="${label}">
			<form_v2:row label="First Name" id="firstName">
				<field_v1:person_name xpath="${xpath}/firstName" required="true" title="${error_phrase}first name" />
			</form_v2:row>

			<form_v2:row label="Last Name" id="lastName">
				<field_v1:person_name xpath="${xpath}/lastname" required="true" title="${error_phrase}surname" />
			</form_v2:row>

			<form_v2:row label="Gender">
				<field_v2:array_radio xpath="${xpath}/gender"
									  required="true"
									  items="F=Female,M=Male"
									  title="${error_phrase}gender" />
			</form_v2:row>

			<form_v2:row label="Date of Birth">
				<field_v2:person_dob xpath="${xpath}/dob" title="primary person's" required="true" ageMin="18" ageMax="65" />
			</form_v2:row>

			<field_v1:hidden xpath="${xpath}/age" required="false" />

			<form_v2:row label="Smoker status">
				<field_v2:array_radio xpath="${xpath}/smoker"
									  required="true"
									  items="N=Non-Smoker,Y=Smoker"
									  title="${error_phrase}smoker status" />
			</form_v2:row>

			<%-- COUNTRY SECTION --%>
			<%----%>

				<core_v1:select_tags
						fieldType="autocomplete"
						variableListName="occupationSelectionList"
						variableListArray="${life_util:occupationsJSON(pageContext.request)}"
						xpath="${xpath}/occupations"
						xpathhidden="${xpath}/occupation"
						label="Occupation"
						title="${error_phrase}occupation"
						limit="1"
						validationErrorPlacementSelector=".${go:nameFromXpath(xpath)}_occupations"
						helpId="525"
				/>
				<field_v1:hidden xpath="${xpath}/unknownOccupation" />
				<field_v1:hidden xpath="${xpath}/hannover" />
				<field_v1:hidden xpath="${xpath}/occupationTitle" />

		</form_v2:fieldset>
	</jsp:body>
</form_v2:fieldset_columns>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Regular Driver Form Component"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
	</jsp:attribute>

	<jsp:body>

		<form_v2:fieldset legend="Regular Driver Details" id="${name}FieldSet">

			<form_v2:row label="Gender" id="${name}_genderRow">
				<field_new:array_radio id="${name}_gender" xpath="${xpath}/gender" required="true" items="M=Male,F=Female" title="${title} gender" className="health-person-details person-gender" />
			</form_v2:row>

			<form_v2:row label="Date of Birth">
				<field_new:person_dob xpath="${xpath}/dob" title="primary person's" required="true" ageMin="16" ageMax="120" />
			</form_v2:row>

			<form_v2:row label="Employment status" helpId="27">
				<field_new:import_select xpath="${xpath}/employmentStatus"
					required="true" className="employment_status"
					url="/WEB-INF/option_data/employment_status.html"
					title="regular driver's employment status" />
			</form_v2:row>

			<form_v2:row label="Age drivers licence obtained" helpId="25">
				<field_new:age_licence xpath="${xpath}/licenceAge" required="true"	title="regular" />
			</form_v2:row>

			<form_v2:row label="Owns another car" id="ownsAnotherCar" helpId="26">
				<field_new:array_radio xpath="${xpath}/ownsAnotherCar" required="true" items="Y=Yes,N=No"
					title="if the regular driver owns another car" />
			</form_v2:row>

		</form_v2:fieldset>

	</jsp:body>
</form_v2:fieldset_columns>
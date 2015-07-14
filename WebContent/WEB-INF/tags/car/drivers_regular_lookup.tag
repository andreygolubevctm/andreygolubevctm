<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Regular Driver Form Component"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
        <ui:bubble variant="info" className="point-left">
            <h4>The Regular Driver</h4>
            <p>In order to supply car insurance quotes, we'll need to know some more information about the regular driver of the car (this is the person who will be driving the car the most).</p>
        </ui:bubble>
	</jsp:attribute>

    <jsp:body>

        <form_new:fieldset legend="Regular Driver Details" id="${name}FieldSet">

            <form_new:row label="Gender" id="${name}_genderRow">
                <field_new:array_radio id="${name}_gender" xpath="${xpath}/gender" required="true" items="M=Male,F=Female" title="${title} gender" className="health-person-details person-gender" />
            </form_new:row>

            <form_new:row label="Date of Birth">
                <field_new:person_dob xpath="${xpath}/dob" title="primary person's" required="true" ageMin="16" ageMax="120" />
            </form_new:row>

            <form_new:row label="Employment status" helpId="27">
                <field_new:import_select xpath="${xpath}/employmentStatus"
                                         required="true" className="employment_status"
                                         url="/WEB-INF/option_data/employment_status.html"
                                         title="regular driver's employment status" />
            </form_new:row>

            <form_new:row label="Age drivers licence obtained" helpId="25">
                <field_new:age_licence xpath="${xpath}/licenceAge" required="true"	title="regular" />
            </form_new:row>

            <form_new:row label="Owns another car" id="ownsAnotherCar" helpId="26">
                <field_new:array_radio xpath="${xpath}/ownsAnotherCar" required="true" items="Y=Yes,N=No"
                                       title="if the regular driver owns another car" />
            </form_new:row>

        </form_new:fieldset>

    </jsp:body>
</form_new:fieldset_columns>
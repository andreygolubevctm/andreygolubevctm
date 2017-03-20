<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Regular Driver Form Component"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>
<c:set var="displaySuffix"><c:out value="${data[xpath].exists}" escapeXml="true"/></c:set>
<c:if test="${empty displaySuffic}">
    <c:set var="displaySuffix">N</c:set>
</c:if>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
        <ui:bubble variant="info" className="ydSpeechBubbleDriverDetails">
            <h4>Want to add other drivers?</h4>
            <p>At this stage we only want to know about the youngest driver of the car. You'll be able to add other drivers to your policy during the application stage.</p>
        </ui:bubble>
	</jsp:attribute>

    <jsp:body>
        <%-- HTML --%>
        <form_v2:fieldset legend="Youngest Driver" id="${name}ExoticFieldSet">

            <form_v2:row label="Will anyone younger than the regular driver be driving this car? (This may include a spouse or household member)" helpId="12" id="quote_drivers_youngDriverExoticRow">
                <field_v2:array_radio xpath="${xpath}/exists"
                                      required="true"
                                      items="Y=Yes,N=No"
                                      title="if any driver (including a spouse or household member) is younger than the Regular Driver"/>
            </form_v2:row>

            <div id="${name}ToggleExoticArea" class="show_${displaySuffix}">
                <form_v2:row label="Gender" id="${name}_genderRow">
                    <field_v2:array_radio id="${name}_gender" xpath="${xpath}/gender" required="true" items="M=Male,F=Female" title="${title} gender" className="health-person-details person-gender" />
                </form_v2:row>

                <form_v2:row label="Date of Birth">
                    <field_v2:person_dob xpath="${xpath}/dob" title="primary person's" required="true" ageMin="16" ageMax="120" />
                </form_v2:row>

                <form_v2:row label="Employment status" helpId="27" id="employment_status_row">
                    <field_v2:import_select xpath="${xpath}/employmentStatus"
                        required="true" className="employment_status"
                        url="/WEB-INF/option_data/employment_status.html"
                        title="youngest driver's employment status" />
                </form_v2:row>

                <form_v2:row label="Age drivers licence obtained" helpId="25">
                    <field_v2:age_licence xpath="${xpath}/licenceAge" required="true"	title="youngest" />
                </form_v2:row>

                <form_v2:row label="Owns another car" id="ownsAnotherCar" helpId="26">
                    <field_v2:array_radio xpath="${xpath}/ownsAnotherCar" required="true" items="Y=Yes,N=No"
                        title="if the youngest driver owns another car" />
                </form_v2:row>
            </div>
        </form_v2:fieldset>
    </jsp:body>
</form_v2:fieldset_columns>
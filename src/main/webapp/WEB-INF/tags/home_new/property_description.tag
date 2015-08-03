<%@ tag description="Property Description" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_new:fieldset legend="Property Description">

	<%-- Property Type --%>
	<c:set var="fieldXpath" value="${xpath}/propertyType" />
	<form_new:row fieldXpath="${fieldXpath}" label="What type of property is the home?">
		<field_new:import_select xpath="${fieldXpath}"
			required="true"
			title="what type of property the home is"
			url="/WEB-INF/option_data/property_type.html"/>
	</form_new:row>

	<%-- Home Best Description --%>
	<c:set var="fieldXpath" value="${xpath}/bestDescribesHome" />
	<form_new:row fieldXpath="${fieldXpath}" label="Which best describes the home?" className="bestDescribesHome">
		<field_new:import_select xpath="${fieldXpath}"
			url="/WEB-INF/option_data/describe_home_type.html"
			title = "what type of property best describes the home"
			required="true" />
	</form_new:row>

	<%-- Wall Construction Material --%>
	<c:set var="fieldXpath" value="${xpath}/wallMaterial" />
	<form_new:row fieldXpath="${fieldXpath}" label="What is the main construction material for the walls?"  helpId="506">
		<field_new:import_select xpath="${fieldXpath}"
			required="true"
			title="the main construction material for the walls"
			url="/WEB-INF/option_data/property_wall_material.html"/>
	</form_new:row>

	<%-- Roof Construction Material --%>
	<c:set var="fieldXpath" value="${xpath}/roofMaterial" />
	<form_new:row fieldXpath="${fieldXpath}" label="What is the main construction material for the roof?">
		<field_new:import_select xpath="${fieldXpath}"
			required="true"
			title="the main construction material for the roof"
			url="/WEB-INF/option_data/property_roof_material.html"/>
	</form_new:row>

	<%-- Year Build --%>
	<c:set var="fieldXpath" value="${xpath}/yearBuilt" />
	<form_new:row fieldXpath="${fieldXpath}" label="What year was the home built?">
		<field_new:import_select xpath="${fieldXpath}"
			required="true"
			title="what year the home was built"
			url="/WEB-INF/option_data/property_built_year.html"/>
	</form_new:row>

	<%-- Heritage Listed --%>
	<c:set var="fieldXpath" value="${xpath}/isHeritage" />
	<form_new:row fieldXpath="${fieldXpath}" label="Is the home heritage listed?" className="heritage">
		<field_new:array_radio xpath="${fieldXpath}"
			required="true"
			className="pretty_buttons"
			items="Y=Yes,N=No"
			title="if the home is heritage listed?"/>
	</form_new:row>

	<%-- Body Corporate --%>
	<c:set var="fieldXpath" value="${xpath}/bodyCorp" />
	<form_new:row fieldXpath="${fieldXpath}" label="Is the home part of a body corporate/strata title complex?">
		<field_new:array_radio xpath="${fieldXpath}"
			title="if the home is part of a body corporate/strata title complex"
			required="true"
			className="pretty_buttons"
			items="Y=Yes,N=No" />
	</form_new:row>

	<%-- JAVASCRIPT HEAD --%>
	<go:script marker="onready">
	$.validator.addMethod("yearBuiltAfterMoveInYear",
		function(value, element, param) {
			var moveInField = $(".whenMovedInYear");
			var moveInYear = moveInField.first().find(":selected").val();
			if( !isNaN(moveInYear) && moveInYear < $(element).find(":selected").val() && moveInField.css("display") == 'block' ){
				return false;
			}
			return true;

		},
		"Custom message"
	);
	</go:script>
	<go:validate selector="${name}_yearBuilt" rule="yearBuiltAfterMoveInYear" parm="true" message="Please change the building year so that it is prior or equal to the year you moved in" />

</form_new:fieldset>
<%@ tag description="Property Description" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:fieldset legend="Property Description">

	<%-- Property Type --%>
	<c:set var="fieldXpath" value="${xpath}/propertyType" />
	<form_v2:row fieldXpath="${fieldXpath}" label="What type of property is the home?">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Property Type" quoteChar="\"" /></c:set>
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="what type of property the home is"
			url="/WEB-INF/option_data/property_type.html"
			additionalAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Home Best Description --%>
	<c:set var="fieldXpath" value="${xpath}/bestDescribesHome" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Which best describes the home?" className="bestDescribesHome">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Property Description" quoteChar="\"" /></c:set>
		<field_v2:import_select xpath="${fieldXpath}"
			url="/WEB-INF/option_data/describe_home_type.html"
			title = "what type of property best describes the home"
			required="true"
			additionalAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Wall Construction Material --%>
	<c:set var="fieldXpath" value="${xpath}/wallMaterial" />
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Construction Material - Tool Tip" quoteChar="\"" /></c:set>
	<form_v2:row fieldXpath="${fieldXpath}" label="What is the main construction material for the walls?"  helpId="506" tooltipAttributes="${analyticsAttr}">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Construction Material" quoteChar="\"" /></c:set>
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="the main construction material for the walls"
			url="/WEB-INF/option_data/property_wall_material.html"
			additionalAttributes="${analyticsAttr}"/>
	</form_v2:row>

	<%-- Roof Construction Material --%>
	<c:set var="fieldXpath" value="${xpath}/roofMaterial" />
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Roof Material - Tool Tip" quoteChar="\"" /></c:set>
	<form_v2:row fieldXpath="${fieldXpath}" label="What is the main construction material for the roof?" tooltipAttributes="${analyticsAttr}">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Roof Material" quoteChar="\"" /></c:set>
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="the main construction material for the roof"
			url="/WEB-INF/option_data/property_roof_material.html"
			additionalAttributes="${analyticsAttr}"/>
	</form_v2:row>

	<%-- Year Build --%>
	<c:set var="fieldXpath" value="${xpath}/yearBuilt" />
	<form_v2:row fieldXpath="${fieldXpath}" label="What year was the home built?">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Year Built" quoteChar="\"" /></c:set>
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="what year the home was built"
			url="/WEB-INF/option_data/property_built_year.html"
			additionalAttributes="data-rule-yearBuiltAfterMoveInYear='true' ${analyticsAttr}"/>
	</form_v2:row>

	<%-- Heritage Listed --%>
	<c:set var="fieldXpath" value="${xpath}/isHeritage" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Is the home heritage listed?" className="heritage">
		<field_v2:array_radio xpath="${fieldXpath}"
			required="true"
			className="pretty_buttons"
			items="Y=Yes,N=No"
			title="if the home is heritage listed?"/>
	</form_v2:row>

	<%-- Body Corporate --%>
	<c:set var="fieldXpath" value="${xpath}/bodyCorp" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Is the home part of a body corporate/strata title complex?">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Body Corporate" quoteChar="\"" /></c:set>
		<field_v2:array_radio xpath="${fieldXpath}"
			title="if the home is part of a body corporate/strata title complex"
			required="true"
			className="pretty_buttons"
			items="Y=Yes,N=No"
			additionalLabelAttributes="${analyticsAttr}" />
	</form_v2:row>

</form_v2:fieldset>
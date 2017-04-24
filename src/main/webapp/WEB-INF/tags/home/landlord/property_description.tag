<%@ tag description="Property Description" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:fieldset legend="Property Description">

    <home_property:property_type  xpath="${xpath}" label="What type of property are you insuring?" />
    <home_property:best_describes_home  xpath="${xpath}" label="Which best describes the home?" />
	<home_property:wall_material  xpath="${xpath}"/>
	<home_property:roof_constuction_material xpath="${xpath}"	/>
    <home_property:year_built 		xpath="${xpath}"  label="What year was the property built?" />
	<home_property:is_heritage		xpath="${xpath}" />
    <home_property:body_corp xpath="${xpath}"
                             label="Is the property part of a body corporate/strata title complex?"
                             title="if the property is part of a body corporate/strata title complex"/>


</form_v2:fieldset>
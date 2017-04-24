<%@ tag description="Property Description" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:fieldset legend="Property Description">

    <home_property:property_type  xpath="${xpath}" label="What type of property are you insuring?" />
    <home:best_describes_home  xpath="${xpath}"/>
	<home:wallMaterial  xpath="${xpath}"/>
	<home:roof_constuction_material xpath="${xpath}"	/>
	<home:year_built 		xpath="${xpath}" />
	<home:is_heritage		xpath="${xpath}" />
	<home:body_corp xpath="${xpath}" />

</form_v2:fieldset>
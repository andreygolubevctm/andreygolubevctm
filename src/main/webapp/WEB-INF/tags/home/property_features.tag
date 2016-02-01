<%@ tag description="Property Features" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:fieldset legend="Property Features" id="${name}">

	<%-- Security Features--%>
	<c:set var="fieldXpath" value="${xpath}/securityFeatures" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Which security features does the home have?" className="firstSecurityFeatureRow">
		<field_v2:checkbox xpath="${fieldXpath}/internalSiren" value="Y" title="An Internal Siren" 			required="false" label="true"/>
	</form_v2:row>
	<form_v2:row fieldXpath="${fieldXpath}" label="">
		<field_v2:checkbox xpath="${fieldXpath}/externalSiren" value="Y" title="An External Siren" 			required="false" label="true"/>
	</form_v2:row>
	<form_v2:row fieldXpath="${fieldXpath}" label="">
		<field_v2:checkbox xpath="${fieldXpath}/strobeLight" 	value="Y" title="An External Strobe Light" 		required="false" label="true"/>
	</form_v2:row>
	<form_v2:row fieldXpath="${fieldXpath}" label="" helpId="527">
		<field_v2:checkbox xpath="${fieldXpath}/backToBase" 	value="Y" title="Active Back To Base Monitoring" required="false" label="true" />
	</form_v2:row>

</form_v2:fieldset>
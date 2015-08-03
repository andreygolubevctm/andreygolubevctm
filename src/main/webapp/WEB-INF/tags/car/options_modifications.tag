<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for modifications"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset legend="Modifications" id="${name}FieldSet">

	<form_new:row label="Has the car been modified?" id="${name}FieldRow" className="initial" helpId="6">
		<field_new:array_radio xpath="${xpath}" required="true"
			className="" items="Y=Yes,N=No"
			id="${name}" title="if the car has been modified" />
	</form_new:row>

</form_new:fieldset>

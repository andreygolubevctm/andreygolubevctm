<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for modifications"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>

	<form_v2:row label="Has the car been modified?" id="${name}FieldRow" className="initial" helpId="6">
		<field_v2:array_radio xpath="${xpath}" required="true"
			className="" items="Y=Yes,N=No"
			id="${name}" title="if the car has been modified" />
	</form_v2:row>

<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Is anyone over 55? --%>
<c:set var="fieldXpath" value="${xpath}/retired" />
<form_v2:row fieldXpath="${fieldXpath}" label="Is any person living in the home over 55 and retired?" className="retired">
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Retired Person Living" quoteChar="\"" /></c:set>
	<field_v2:array_radio xpath="${fieldXpath}"
		items="Y=Yes,N=No"
		className="pretty_buttons"
		title="whether there is anyone over 55 and retired living at the home"
		required="true"
		additionalLabelAttributes="${analyticsAttr}" />
</form_v2:row>

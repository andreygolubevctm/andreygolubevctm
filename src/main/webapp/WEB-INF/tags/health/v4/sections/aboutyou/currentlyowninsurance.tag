<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Currently own private health insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/cover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="health insurance status" quoteChar="\"" /></c:set>
<form_v4:row label="Already have private health insurance cover?" fieldXpath="${fieldXpath}" id="${name}_primaryCover">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_health_cover" additionalLabelAttributes="${analyticsAttr}"/>
</form_v4:row>
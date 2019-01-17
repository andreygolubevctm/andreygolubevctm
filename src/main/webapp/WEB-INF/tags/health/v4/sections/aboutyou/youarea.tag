<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select element for what sort of relationship status a user eg Family, single, couple etc..."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/healthCvr" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="about you" quoteChar="\"" /></c:set>

<form_v4:row hideRowBorder="true" label="I want to compare private health insurance for:" fieldXpath="${fieldXpath}" className="health-cover lhcRebateCalcTrigger">
	<field_v2:array_radio xpath="${fieldXpath}"
		required="true"
		className="health-situation-healthCvr has-icons"
		items="SM=Single Male,SF=Single Female,C=Couple,SPF=Single Parent Family,F=Family"
		id="${go:nameFromXpath(fieldXPath)}"
		style="radio-rounded"
		title="the situation you are in"
		additionalLabelAttributes="${analyticsAttr}" />
</form_v4:row>
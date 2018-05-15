<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select your current health fund row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/fundName" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="current health fund" quoteChar="\"" /></c:set>
<c:set var="primaryCurrentHealthFund"><content:get key="primaryCurrentHealthFund" /></c:set>

<form_v4:row fieldXpath="${fieldXpath}" label="Your current health fund" id="${name}_primary_fundName" className="">
    <field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="your current health fund" required="false" additionalAttributes=" data-attach='true' ${analyticsAttr} " disableErrorContainer="${true}" />
</form_v4:row>

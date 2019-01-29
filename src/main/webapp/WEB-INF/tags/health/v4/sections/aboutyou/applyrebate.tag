<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Checkbox to apply the rebate to lower the premium"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/rebate" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate application" quoteChar="\"" /></c:set>
<form_v4:row label="Apply the Australian Government Rebate to lower my upfront premium?" fieldXpath="${fieldXpath}" id="${name}_rebate_field_row" helpId="240" className="lhcRebateCalcTrigger hidden">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="validate" id="${name}_rebate" additionalLabelAttributes="${analyticsAttr}" additionalAttributes=" data-attach='true'"/>
</form_v4:row>

<c:set var="fieldXpath" value="${xpath}/dependants" />
<form_v2:row hideRowBorder="true" label="How many dependents do you have?" id="${name}_dependants_field_row" className="lhcRebateCalcTrigger">
	<field_v2:count_select xpath="${fieldXpath}" max="12" min="1" placeHolder="Please choose..." title="number of dependants" required="true" className="${name}_health_cover_dependants dependants" />
</form_v2:row>
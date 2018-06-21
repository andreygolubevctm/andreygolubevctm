<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Living status row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<jsp:useBean id="financialYearUtils" class="com.ctm.web.health.utils.FinancialYearUtils" />
<c:set var="continuousCoverYear" value="${financialYearUtils.getContinuousCoverYear()}" />

<%-- Please note this xpath is misleading - it actually holds data to show if the partner has continious hospital cover --%>
<c:set var="fieldXpath" value="${xpath}/primary/healthCoverLoading" />

<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="continuous cover" quoteChar="\"" /></c:set>
<form_v4:row label="Have you had continuous private hospital cover since 1 July ${continuousCoverYear} or 1 July following your 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-primary" className="health-your_details-opt-group lhcRebateCalcTrigger" helpId="573">
    <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Have you had continuous private hospital cover?" required="true" id="${name}_health_cover_loading" className="loading" additionalLabelAttributes="${analyticsAttr}"/>
</form_v4:row>
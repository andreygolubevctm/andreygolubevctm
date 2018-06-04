<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="partner's health insurance status xpath" %>

<jsp:useBean id="financialYearUtils" class="com.ctm.web.health.utils.FinancialYearUtils" />
<c:set var="continuousCoverYear" value="${financialYearUtils.getContinuousCoverYear()}" />
<c:set var="fieldXpath" value="${xpath}/partner/healthCoverLoading" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner continuous cover" quoteChar="\"" /></c:set>
<form_v4:row label="Has your partner had continuous private hospital cover since 1 July ${continuousCoverYear} or 1 July following their 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-partner" className="health-your_details-opt-group partner lhcRebateCalcTrigger" helpId="573">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading" additionalLabelAttributes="${analyticsAttr}" />
</form_v4:row>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Does your partner have private health insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/partner/cover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner health insurance status" quoteChar="\"" /></c:set>
<c:set var="alreadyHaveHealthInsurance"><content:get key="alreadyHaveHealthInsurance" /></c:set>

<form_v4:row label="Does your partner currently hold Private Health Insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover" className="lhcRebateCalcTrigger" helpId="587">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Does your partner currently hold Private Health Insurance?" required="true" className="health-cover_details" id="${name}_partner_health_cover" additionalLabelAttributes="${analyticsAttr}" />

	<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
	<div class="${fieldXpathName}-help-text help-text success yes-help hidden">
		<div class="icon-area">
			<div class="tick"></div>
		</div>
		<div class="content">${alreadyHaveHealthInsurance}</div>
	</div>

</form_v4:row>
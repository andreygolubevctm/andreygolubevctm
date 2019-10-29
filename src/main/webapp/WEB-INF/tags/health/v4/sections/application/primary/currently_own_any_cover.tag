<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Currently own private health insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/cover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="health insurance status" quoteChar="\"" /></c:set>
<c:set var="alreadyHaveHealthInsurance"><content:get key="alreadyHaveHealthInsurance" /></c:set>

<form_v4:row label="Do you currently hold Private Health Insurance?" fieldXpath="${fieldXpath}" id="${name}_primaryCover" className="lhcRebateCalcTrigger" helpId="587">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Do you currently hold Private Health Insurance?" required="true" className="health-cover_details" id="${name}_health_cover" additionalLabelAttributes="${analyticsAttr}"/>
    <health_v4_application:abd_details className="abd-details-application-single-no-phi hidden" />
	<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
	<div class="${fieldXpathName}-help-text help-text success yes-help hidden">
		<div class="icon-area">
			<div class="tick"></div>
		</div>
		<div class="content">${alreadyHaveHealthInsurance}</div>
	</div>

</form_v4:row>
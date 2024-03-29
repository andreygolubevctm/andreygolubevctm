<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Have you ever owned private hospital insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="variant" 	required="false" rtexprvalue="true"	 description="used when two fields of a similar name share the same xpath" %>

<%-- VARIABLES --%>
<c:if test="${empty variant}">
	<c:set var="variant" value="" />
</c:if>

<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/everHadCover${variant}" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="ever had private hospital insurance status ${variant}" quoteChar="\"" /></c:set>

<form_v4:row label="Have you ever held private hospital cover?" fieldXpath="${fieldXpath}" id="${name}_primaryCoverEverHad${variant}" className="lhcRebateCalcTrigger" helpId="572">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Have you ever had private hospital cover?" required="true" className="health-cover_everHad" id="${name}_ever_had_health_cover${variant}" additionalLabelAttributes="${analyticsAttr}"/>
	<div class="applyFullLHCAdditionalText primary${variant} hidden">Full applicable LHC will be applied to your policy until your new fund receives a transfer certificate from your previous fund, it will then be adjusted from the start date of your policy and you will be credited any amount you have overpaid.</div>
</form_v4:row>
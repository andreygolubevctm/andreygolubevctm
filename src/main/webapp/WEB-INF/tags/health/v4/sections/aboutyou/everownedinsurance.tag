<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Have you ever owned private hospital insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/everHadCover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="ever had private hospital insurance status" quoteChar="\"" /></c:set>

<form_v4:row label="Have you ever held private hospital insurance cover?" fieldXpath="${fieldXpath}" id="${name}_primaryCoverEverHad" className="lhcRebateCalcTrigger">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Have you ever had private hospital cover?" required="true" className="health-cover_everHad" id="${name}_ever_had_health_cover" additionalLabelAttributes="${analyticsAttr}"/>
</form_v4:row>
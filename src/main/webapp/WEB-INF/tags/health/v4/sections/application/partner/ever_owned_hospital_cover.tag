<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Has your partner ever had private hospital insurance row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="variant" 	required="false" rtexprvalue="true"	 description="used when two fields of a similar name share the same xpath" %>

<%-- VARIABLES --%>
<c:if test="${empty variant}">
	<c:set var="variant" value="" />
</c:if>

<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/partner/everHadCover${variant}" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner ever had private hospital insurance status ${variant}" quoteChar="\"" /></c:set>

<form_v4:row label="Has your partner ever held private hospital cover?" fieldXpath="${fieldXpath}"  id="${name}_partnerCoverEverHad${variant}" className="lhcRebateCalcTrigger">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Has your partner ever had private hospital cover?" required="true" className="health-cover_everHad" id="${name}_partner_ever_had_health_cover${variant}" additionalLabelAttributes="${analyticsAttr}" />
</form_v4:row>
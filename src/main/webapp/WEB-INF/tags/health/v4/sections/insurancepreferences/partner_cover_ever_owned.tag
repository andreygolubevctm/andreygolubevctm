<%@ tag description="Has your partner ever had private hospital insurance row"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="partner's ever had private hospital insurance status xpath" %>

<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/partner/everHadCover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner ever had private hospital insurance status" quoteChar="\"" /></c:set>

<form_v4:row label="Has your partner ever held private hospital insurance cover?" fieldXpath="${fieldXpath}"  id="${name}_partnerCoverEverHad" className="lhcRebateCalcTrigger">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Has your partner ever had private hospital cover?" required="true" className="health-cover_everHad" id="${name}_partner_ever_had_health_cover" additionalLabelAttributes="${analyticsAttr}" />
</form_v4:row>
<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="partner's health insurance status xpath" %>

<c:set var="fieldXpath" value="${xpath}/partner/cover" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner health insurance status" quoteChar="\"" /></c:set>
<form_v4:row label="Does your partner currently hold private health insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_partner_health_cover" additionalLabelAttributes="${analyticsAttr}" />
</form_v4:row>
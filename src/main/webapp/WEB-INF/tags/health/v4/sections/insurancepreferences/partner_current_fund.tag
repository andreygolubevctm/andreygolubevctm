<%@ tag description="Select your partner's current health fund row"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="partner's current health fund xpath" %>

<c:set var="fieldXpath" value="${xpath}/partner/fundName" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner current health fund" quoteChar="\"" /></c:set>

<form_v4:row fieldXpath="${fieldXpath}" label="Your partner's current health fund" id="${name}_partner_fundName" className="">
    <field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="your partner's current health fund" required="false" additionalAttributes=" data-attach='true' ${analyticsAttr} " disableErrorContainer="${true}" />

</form_v4:row>
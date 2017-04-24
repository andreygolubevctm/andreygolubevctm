<%@ tag description="Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- Body Corporate --%>
<c:set var="fieldXpath" value="${xpath}/bodyCorp" />
<form_v2:row fieldXpath="${fieldXpath}" label="Is the home part of a body corporate/strata title complex?">
    <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Body Corporate" quoteChar="\"" /></c:set>
    <field_v2:array_radio xpath="${fieldXpath}"
                          title="if the home is part of a body corporate/strata title complex"
                          required="true"
                          className="pretty_buttons"
                          items="Y=Yes,N=No"
                          additionalLabelAttributes="${analyticsAttr}" />
</form_v2:row>
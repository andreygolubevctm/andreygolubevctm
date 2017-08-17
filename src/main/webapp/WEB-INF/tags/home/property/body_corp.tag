<%@ tag description="Body Corporate" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>
<%@ attribute name="label" 				required="false" rtexprvalue="true"	 description="label for the field"%>
<%@ attribute name="title" 				required="false" rtexprvalue="true"	 description="title for the field"%>

<%-- Body Corporate --%>
<c:set var="fieldXpath" value="${xpath}/bodyCorp" />
<form_v2:row fieldXpath="${fieldXpath}" label="${label}">
    <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Body Corporate" quoteChar="\"" /></c:set>
    <field_v2:array_radio xpath="${fieldXpath}"
                          title="${title}"
                          required="true"
                          className="pretty_buttons"
                          items="Y=Yes,N=No"
                          additionalLabelAttributes="${analyticsAttr}" />
</form_v2:row>
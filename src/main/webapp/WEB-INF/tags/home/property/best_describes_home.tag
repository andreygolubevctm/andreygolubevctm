<%@ tag description="Property Description" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>
<%@ attribute name="label" 				required="true" rtexprvalue="true"	 description="label for the field"%>

<%-- Home Best Description --%>
<c:set var="fieldXpath" value="${xpath}/bestDescribesHome" />
<form_v2:row fieldXpath="${fieldXpath}" label="${label}" className="bestDescribesHome">
    <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Property Description" quoteChar="\"" /></c:set>
    <field_v2:import_select xpath="${fieldXpath}"
                            url="/WEB-INF/option_data/describe_home_type.html"
                            title = "what type of property best describes the home"
                            required="true"
                            additionalAttributes="${analyticsAttr}" />
</form_v2:row>
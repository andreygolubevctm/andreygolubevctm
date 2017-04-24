<%@ tag description="Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>


<%-- Wall Construction Material --%>
<c:set var="fieldXpath" value="${xpath}/wallMaterial" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Construction Material - Tool Tip" quoteChar="\"" /></c:set>
<form_v2:row fieldXpath="${fieldXpath}" label="What is the main construction material for the walls?"  helpId="506" tooltipAttributes="${analyticsAttr}">
    <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Construction Material" quoteChar="\"" /></c:set>
    <field_v2:import_select xpath="${fieldXpath}"
                            required="true"
                            title="the main construction material for the walls"
                            url="/WEB-INF/option_data/property_wall_material.html"
                            additionalAttributes="${analyticsAttr}"
                            hideElement="${simplifiedJourneySplitTestActive ? 'true' : 'false'}" />

    <c:if test="${simplifiedJourneySplitTestActive}">
        <div id="wallMaterialContainer" data-selector="${go:nameFromXpath(fieldXpath)}"></div>
    </c:if>
</form_v2:row>
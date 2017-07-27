<%@ tag description="Property Type" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>
<%@ attribute name="label" 				required="false" rtexprvalue="true"	 description="label for the field"%>


<%-- Property Type --%>
<c:set var="fieldXpath" value="${xpath}/propertyType" />
<form_v2:row fieldXpath="${fieldXpath}" label="${label}">
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Property Type" quoteChar="\"" /></c:set>
	<field_v2:import_select xpath="${fieldXpath}"
							required="true"
							title="what type of property the home is"
							url="/WEB-INF/option_data/property_type.html"
							additionalAttributes="${analyticsAttr} data-attach='true'"
							hideElement="${simplifiedJourneySplitTestActive ? 'true' : 'false'}" />

	<c:if test="${simplifiedJourneySplitTestActive}">
		<div id="propertyTypeContainer" data-selector="${go:nameFromXpath(fieldXpath)}"></div>
	</c:if>
</form_v2:row>
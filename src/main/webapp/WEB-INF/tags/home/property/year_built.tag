<%@ tag description="Year Built" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>
<%@ attribute name="label" 				required="false" rtexprvalue="true"	 description="label for the field"%>


	<%-- Year Build --%>
	<c:set var="fieldXpath" value="${xpath}/yearBuilt" />
	<form_v2:row fieldXpath="${fieldXpath}" label="What year was the property built?">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Year Built" quoteChar="\"" /></c:set>
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="what year the home was built"
			url="/WEB-INF/option_data/property_built_year.html"
			additionalAttributes="data-rule-yearBuiltAfterMoveInYear='true' ${analyticsAttr}"/>
	</form_v2:row>
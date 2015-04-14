<%@ tag description="Select Tags Field -- Creates a select dropdown which, when a value is selected, will create a list of tags that present the options selected by the user."%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="false" description="Parent xpath to hold individual items"%>
<%@ attribute name="xpathhidden" required="true" rtexprvalue="false" description="xpath to hold hidden item"%>
<%@ attribute name="label" required="true" rtexprvalue="false" description="Label for the select field" %>
<%@ attribute name="title" required="true" rtexprvalue="false" description="Title for the select field" %>
<%@ attribute name="validationErrorPlacementSelector" required="false" rtexprvalue="false" description="Validation error placement selector" %>
<%@ attribute name="variableListName" required="true" rtexprvalue="false" description="Name of variable to contain a JS array of objects" %>
<%@ attribute name="variableListArray" required="true" rtexprvalue="true" description="JS array of objects to use in the select" %>
<%@ attribute name="helpId" required="false" rtexprvalue="true" description="Optional help Id" %>

<script type="text/javascript">
	var ${variableListName} = ${variableListArray};
</script>

<%-- HTML --%>
<form_new:row label="${label}" className="clear select-tags-row" helpId="${helpId}">
	<field_new:array_select items="" xpath="${xpath}" title="${title}" required="true" className="select-tags" extraDataAttributes="data-varname='${variableListName}'" />
	<field_new:validatedHiddenField xpath="${xpathhidden}" className="" title="${title}" validationErrorPlacementSelector=".content ${validationErrorPlacementSelector}" />
</form_new:row>

<form_new:row label="" className="selected-tags-row clear" hideHelpIconCol="true">
	<ul class="selected-tags col-xs-12 col-sm-12"></ul>
</form_new:row>
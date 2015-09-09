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
<%@ attribute name="fieldType" required="false" rtexprvalue="true" description="Which field type to use. Default is select" %>
<%@ attribute name="source" required="false" rtexprvalue="true" description="The URL for the Ajax call or a function that will handle the call (and potentially a callback) for autocomplete types only" %>
<c:if test="${empty fieldType}">
	<c:set var="fieldType" value="select" />
</c:if>

<script type="text/javascript">
	var ${variableListName} = ${variableListArray};
</script>

<%-- HTML --%>
<form_new:row label="${label}" className="clear select-tags-row" helpId="${helpId}">

	<c:choose>
		<c:when test="${fieldType eq 'autocomplete'}">
			<field_new:autocomplete xpath="${xpath}" className="blur-on-select show-loading select-tags" title="Postcode/Suburb" required="${required}" source="${source}" placeholder="${placeholder}" extraDataAttributes="data-varname='${variableListName}' data-transactionid='true'" />
		</c:when>
		<c:otherwise>
			<field_new:array_select items="" xpath="${xpath}" title="${title}" required="true" className="select-tags" extraDataAttributes="data-varname='${variableListName}'" />
		</c:otherwise>
	</c:choose>


	<field_new:validatedHiddenField xpath="${xpathhidden}" className="" title="${title}" validationErrorPlacementSelector=".content ${validationErrorPlacementSelector}" additionalAttributes=" required " />
</form_new:row>

<form_new:row label="" className="selected-tags-row clear" hideHelpIconCol="true">
	<ul class="selected-tags col-xs-12 col-sm-12"></ul>
</form_new:row>
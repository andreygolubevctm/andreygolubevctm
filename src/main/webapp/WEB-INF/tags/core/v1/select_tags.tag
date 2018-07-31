<%@ tag description="Select Tags Field -- Creates a select dropdown which, when a value is selected, will create a list of tags that present the options selected by the user."%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Parent xpath to hold individual items"%>
<%@ attribute name="xpathhidden" required="true" rtexprvalue="true" description="xpath to hold hidden item"%>
<%@ attribute name="label" required="true" rtexprvalue="true" description="Label for the select field" %>
<%@ attribute name="title" required="true" rtexprvalue="true" description="Title for the select field" %>
<%@ attribute name="validationErrorPlacementSelector" required="false" rtexprvalue="true" description="Validation error placement selector" %>
<%@ attribute name="variableListName" required="true" rtexprvalue="false" description="Name of variable to contain a JS array of objects" %>
<%@ attribute name="variableListArray" required="true" rtexprvalue="true" description="JS array of objects to use in the select" %>
<%@ attribute name="helpId" required="false" rtexprvalue="true" description="Optional help Id" %>
<%@ attribute name="fieldType" required="false" rtexprvalue="true" description="Which field type to use. Default is select" %>
<%@ attribute name="source" required="false" rtexprvalue="true" description="The URL for the Ajax call or a function that will handle the call (and potentially a callback) for autocomplete types only" %>
<%@ attribute name="limit" required="false" rtexprvalue="true" description="A number representing the maximum number of items that may be selected. Defaults to 0 for unlimited" %>
<%@ attribute name="additionalAttributes" 		required="false"	 rtexprvalue="true"	 description="Additional Attributes" %>

<c:if test="${empty fieldType}">
	<c:set var="fieldType" value="select" />
</c:if>

<c:if test="${empty limit}">
	<c:set var="limit" value="0" />
</c:if>

<script type="text/javascript">
	var ${variableListName} = ${variableListArray};
</script>

<%-- HTML --%>

<form_v2:row label="${label}" className="clear select-tags-row" helpId="${helpId}">

	<ul class="selected-tags col-xs-12 col-sm-12" data-selectlimit='${limit}'></ul>

	<c:choose>
		<c:when test="${fieldType eq 'autocomplete'}">
			<field_v2:autocomplete xpath="${xpath}" className="blur-on-select show-loading select-tags" title="Postcode/Suburb" required="${required}" source="${source}" placeholder="${placeholder}" additionalAttributes="${additionalAttributes}"  extraDataAttributes="data-varname='${variableListName}' data-transactionid='true'" />
		</c:when>
		<c:otherwise>
			<field_v2:array_select items="" xpath="${xpath}" title="${title}" required="true" className="select-tags" extraDataAttributes="data-varname='${variableListName}'" />
		</c:otherwise>
	</c:choose>


	<field_v2:validatedHiddenField xpath="${xpathhidden}" className="" title="${title}" validationErrorPlacementSelector=".content ${validationErrorPlacementSelector}" additionalAttributes=" required " />
</form_v2:row>

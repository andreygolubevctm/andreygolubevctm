<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" 				required="false" rtexprvalue="true"	 description="label for the field"%>
<%@ attribute name="fieldXpath"			required="false" rtexprvalue="true"	 description="The xpath of the field the label needs to point to"%>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 				required="false" rtexprvalue="true"	 description="optional id for this row"%>
<%@ attribute name="helpId"				required="false" rtexprvalue="true"	 description="Help tooltip ID"%>
<%@ attribute name="showHelpText"		required="false" rtexprvalue="true"	 description="Trigger to display help icon as text rather than icon" %>
<%@ attribute name="helpReplaceText" 	required="false" rtexprvalue="true"	 description="Used to populate placeholder text" %>
<%@ attribute name="legend"				required="false" rtexprvalue="true"	 description="Optional legend field, when an item is readonly"%>
<%@ attribute name="hideHelpIconCol"	required="false" rtexprvalue="true"	 description="Set to a value to hide the help icon placeholder column" %>
<%@ attribute name="labelAbove"			required="false" rtexprvalue="true"	 description="Have the label above the element instead of beside it" %>
<%@ attribute name="addForAttr" 		required="false" rtexprvalue="true"	 description="Bool to add or not the for attribute" %>

<%-- Added to deal with the new field sizes introduced in health --%>
<%@ attribute name="smRowOverride" 		required="false" rtexprvalue="true"	 description="Override the SM value" %>
<%@ attribute name="isNestedField" 		required="false" rtexprvalue="true"	 description="Toggle to automatically set some styling values for the nested fields eg name_group.tag" %>
<%@ attribute name="isNestedStyleGroup" required="false" rtexprvalue="true"	 description="Toggle to remove the col-xs-12 class. If not removed breaks the nesting design introduced to health" %>

<c:if test="${not isNestedField eq true}">
	<c:set var="formGroupClasses" value="form-group row" />
</c:if>
<c:if test="${isNestedStyleGroup eq true}">
	<c:set var="formGroupClasses" value="nestedGroup form-group" />
</c:if>

<%-- VARIABLES --%>
<c:if test="${empty labelAbove}">
	<c:set var="labelAbove" value="${false}" />
</c:if>

<c:if test="${empty addForAttr}">
	<c:set var="addForAttr" value="${true}" />
</c:if>
<%-- HTML --%>
<%--
	Bootstrap classes:
		form-group
		row
		col-XX-X
	New classes:
		row-content
	Old classes (may still be in use):
		fieldrow
		vertical_fieldrow_label
		fieldrow_label
		fieldrow_value
		fieldrow_legend
		help_icon
		label_icon
		readonly
		imgOnlyLabel
--%>
<div class="${formGroupClasses} fieldrow ${className}"<c:if test="${not empty id}"> id="${id}"</c:if>>

	<c:choose>
		<c:when test="${empty hideHelpIconCol}">
			<c:set var="toggleHelpColLarge" value="6" />
			<c:set var="toggleHelpColSmall" value="6" />
			<c:set var="toggleHelpColMobile" value="10" />
		</c:when>
		<c:otherwise>
			<c:set var="toggleHelpColLarge" value="8" />
			<c:set var="toggleHelpColSmall" value="6" />
			<c:set var="toggleHelpColMobile" value="12" />
		</c:otherwise>
	</c:choose>

	<c:if test="${not empty smRowOverride}">
		<c:set var="toggleHelpColSmall" value="${smRowOverride}" />
	</c:if>

	<c:choose>
		<c:when test="${labelAbove eq true}">
			<c:set var="labelClassName" value="col-sm-5 col-xs-${toggleHelpColMobile}" />
		</c:when>
		<c:otherwise>
			<c:set var="labelClassName" value="col-sm-5 col-xs-${toggleHelpColMobile}" />
		</c:otherwise>
	</c:choose>

	<c:if test="${isNestedField eq true}">
		<c:set var="labelClassName" value="${labelClassName} hidden-sm hidden-md hidden-lg" />
	</c:if>

	<c:if test="${isNestedStyleGroup eq true}">
		<c:set var="labelClassName" value="${labelClassName} hidden-xs" />
	</c:if>

	<c:choose>
		<c:when test="${not empty label and label ne ''}">

			<c:if test="${label eq 'empty'}">
				<c:set var="label" value="" />
			</c:if>

			<field_v2:label value="${label}" xpath="${fieldXpath}" className="${labelClassName}" addForAttr="${addForAttr}" />

			<div class="col-xs-1 visible-xs helpIconXSColumn">
				<field_v2:help_icon helpId="${helpId}" showText="${showHelpText}" placeholderText="${helpReplaceText}" />
			</div>

			<c:set var="helpIconCol" value="hidden-xs" />
			<c:set var="fieldCol" value="col-xs-12" />

		</c:when>
		<c:otherwise>
			<c:set var="offset" value="col-sm-offset-3" />
			<c:set var="helpIconCol" value="col-xs-2" />
			<c:set var="fieldCol" value="col-xs-${toggleHelpColMobile}" />
		</c:otherwise>
	</c:choose>

	<c:set var="rowClass">
		<c:if test="${isNestedStyleGroup eq true}"> row </c:if>
	</c:set>

	<c:if test="${isNestedStyleGroup eq true}">
		<c:set var="fieldCol" value=" " />
	</c:if>

	<div class="col-sm-<c:out value="${toggleHelpColSmall} " /> ${fieldCol} <c:out value=" ${rowClass}" /> <c:out value=" ${offset}" /> row-content">
		<jsp:doBody />
		<div class="fieldrow_legend"<c:if test="${not empty id}"> id="${id}_row_legend"</c:if>>${legend}</div>
	</div>

	<c:if test="${empty hideHelpIconCol}">
		<div class="col-sm-1 ${helpIconCol}">
			<field_v2:help_icon helpId="${helpId}" showText="${showHelpText}" placeholderText="${helpReplaceText}"/>
		</div>
	</c:if>

</div>
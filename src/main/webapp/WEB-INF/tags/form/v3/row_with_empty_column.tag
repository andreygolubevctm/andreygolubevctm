<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="fieldXpath"			required="false" rtexprvalue="true"	 description="The xpath of the field the label needs to point to"%>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 				required="false" rtexprvalue="true"	 description="optional id for this row"%>
<%@ attribute name="helpId"				required="false" rtexprvalue="true"	 description="Help tooltip ID"%>
<%@ attribute name="showHelpText"		required="false" rtexprvalue="true"	 description="Trigger to display help icon as text rather than icon" %>
<%@ attribute name="legend"				required="false" rtexprvalue="true"	 description="Optional legend field, when an item is readonly"%>
<%@ attribute name="hideHelpIconCol"	required="false" rtexprvalue="true"	 description="Set to a value to hide the help icon placeholder column" %>
<%@ attribute name="labelAbove"			required="false" rtexprvalue="true"	 description="Have the label above the element instead of beside it" %>
<%@ attribute name="addForAttr" 		required="false" rtexprvalue="true"	 description="Bool to add or not the for attribute" %>

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
<div class="${readonlyClass} form-group row fieldrow ${className}"<c:if test="${not empty id}"> id="${id}"</c:if>>

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

	<div class="col-sm-5 col-xs-${toggleHelpColMobile} row-content"></div>

	<div class="col-sm-<c:out value="${toggleHelpColSmall} " /> ${fieldCol} <c:out value=" ${offset}" /> row-content">
		<jsp:doBody />
		<div class="fieldrow_legend"<c:if test="${not empty id}"> id="${id}_row_legend"</c:if>>${legend}</div>
	</div>

	<c:if test="${empty hideHelpIconCol}">
		<div class="col-sm-1 ${helpIconCol}">
			<field_v2:help_icon helpId="${helpId}" showText="${showHelpText}"/>
		</div>
	</c:if>

</div>
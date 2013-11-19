<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" 				required="true"  rtexprvalue="true"	 description="label for the field"%>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="labelClassName" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 				required="false" rtexprvalue="true"	 description="optional id for this row"%>
<%@ attribute name="helpId" 			required="false" rtexprvalue="true"	 description="The rows help id (if non provided, help is not shown)" %>
<%@ attribute name="legend"				required="false" rtexprvalue="true"	 description="Optional legend field, when an item is readonly"%>
<%@ attribute name="readonly"			required="false" rtexprvalue="true"	 description="Legend field - with read Only used in online admin and simples, used to lock down field values"%>
<%@ attribute name="labelIcon" 			required="false" rtexprvalue="true"	 description="optional label icon"%>
<%@ attribute name="horizontal" 		required="false" rtexprvalue="true"	 description="display form horizontal defaults to true"%>

<c:if test="${empty horizontal}">
	<c:set var="horizontal" value="true" />
</c:if>

<c:set var="readonlyClass" value="" />
<c:if test="${readonly}">
	<c:set var="readonlyClass" value="readonly" />
</c:if>
<c:if test="${ empty(id) }">
	<c:set var="id">xfr_<%= java.lang.Math.round(java.lang.Math.random() * 32768) %></c:set>
</c:if>
<c:if test="${(labelIcon != null) && (label == '' || label == null)}">
	<c:set var="blankLabelClass">imgOnlyLabel</c:set>
</c:if>
<c:set var="id" value="${go:nameFromXpath(id)}" />

<%-- HTML --%>
<div class="${readonlyClass} fieldrow ${className}" id="${id}">
	<c:choose>
		<c:when test="${horizontal}">
			<c:set value="fieldrow_label " var="alignmentClass" />
		</c:when>
		<c:otherwise>
			<c:set value="vertical_fieldrow_label " var="alignmentClass" />
		</c:otherwise>
	</c:choose>
	<div class="${alignmentClass} ${labelClassName} ${blankLabelClass}">
		<c:if test="${labelIcon != null && labelIcon != ''}">
			<img src="${labelIcon}" class="label_icon" id="labelIcon_${label}" />
		</c:if>
		${label}
	</div>
	<div class="fieldrow_value">
		<jsp:doBody />
	</div>
	<c:if test="${helpId != null && helpId != ''}">
		<div class="help_icon" id="help_${helpId}"></div>
	</c:if>
	<c:if test="${readonly != true && not empty legend}">
		<div class="fieldrow_legend" id="${id}_row_legend">${legend}</div>
	</c:if>
	<core:clear />
</div>
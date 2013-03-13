<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" 				required="true"  rtexprvalue="true"	 description="label for the field"%>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="labelClassName" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 				required="false" rtexprvalue="true"	 description="optional id for this row"%>
<%@ attribute name="helpId" 			required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>
<%@ attribute name="legend" 			required="false" rtexprvalue="true"	 description="optional ledgend for this row"%>
<%@ attribute name="readonly" 			required="false" rtexprvalue="true"	 description="optional ledgend for this row"%>

<c:set var="readonlyClass" value="" />
<c:if test="${readonly}">
	<c:set var="readonlyClass" value="readonly" />
</c:if>
<c:if test="${ empty(id) }">
	<c:set var="id">xfr_<%= java.lang.Math.round(java.lang.Math.random() * 32768) %></c:set>
</c:if>

<c:set var="id" value="${go:nameFromXpath(id)}" />

<%-- HTML --%>
<div class="${readonlyClass} fieldrow ${className}" id="${id}">
	<div class="fieldrow_label ${labelClassName}">
		${label}
	</div>
	<div class="fieldrow_value">
		<jsp:doBody />
	</div>
	<c:if test="${helpId != null && helpId != ''}">
		<div class="help_icon" id="help_${helpId}"></div>
	</c:if>
	<c:if test="${readonly != true}">
		<div class="fieldrow_legend" id="${id}_row_legend">${legend}</div>
	</c:if>
		<core:clear />
</div>

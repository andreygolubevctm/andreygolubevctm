<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a DD MM YYYY field with a date picker or inline calendar."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 					required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 				required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="mobileClassName" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 					required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="startDate" 				required="false" rtexprvalue="true"	 description="Start date for the dropdown"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<div class="select">
	<span class="input-group-addon">
		<i class="icon-sort"></i>
	</span>
	<select name="${name}_mobile" id="${name}_mobile" class="form-control ${mobileClassName}">
		<%-- Write the initial "please choose" option --%>
		<option value="">Please choose...</option>

		<%-- Write the options for each day --%>
		<% int dayCount = 0; %>
		<% while (dayCount <= 30) { %>
			<jsp:useBean id="dateObject" class="java.util.GregorianCalendar" />
			<fmt:formatDate var="date" pattern="dd/MM/yyyy" value="${dateObject.time}" />
			<option value="${date}">${date}</option>
			<% dateObject.add(java.util.GregorianCalendar.DAY_OF_MONTH, 1); %>
			<% dayCount ++; %>
		<% } %>
	</select>
</div>

<go:validate selector="${name}_mobile" rule="commencementDateMobileDropdownCheck" parm="${required}" message="Please select a commencement date."/>
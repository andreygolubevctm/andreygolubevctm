<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="A pair of date selectors representing a date range."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="inputClassName"		required="false" rtexprvalue="true"	 description="additional css class attribute for the input field" %>
<%@ attribute name="mode" 			required="false"	rtexprvalue="true"	 description="The mode to be applied to the datepicker" %>

<%-- fields --%>
<%@ attribute name="title" 				required="true"	 rtexprvalue="true"	 description="The name/function of the Date field (e.g. 'departure')"%>
<%@ attribute name="minDate" 			required="false" rtexprvalue="true"	 description="Minimum Inclusive Date Value (rfc3339 yyyy-MM-dd)"%>
<%@ attribute name="maxDate" 			required="false" rtexprvalue="true"	 description="Maximum Inclusive Date Value (rfc3339 yyyy-MM-dd)"%>
<%@ attribute name="startView" 			required="false" rtexprvalue="true"	 description="The view either 0:Month|1:Year|2:Decade|"%>

<%@ attribute name="disableErrorContainer" 	required="false" 	rtexprvalue="true"    	 description="Show or hide the error message container" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="dateXpath" value="${xpath}/date" />

<%-- The default mode is component - if set to separate --%>
<c:if test="${empty mode}">
	<c:set var="mode" value="separated" />
</c:if>

<%-- HTML --%>
<field_v2:calendar_mm_yyyy mode="${mode}" validateMinMax="true" xpath="${xpath}" required="${required}" title="${title}" minDate="${minDate}" maxDate="${maxDate}" startView="0" nonLegacy="true" disableErrorContainer="${disableErrorContainer}"/>

<%-- VALIDATION --%>
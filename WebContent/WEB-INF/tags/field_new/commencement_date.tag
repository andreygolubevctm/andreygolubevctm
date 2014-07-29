<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Policy Commencement date - limited to the number of days from the current date"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	See corresponding module formDateInput.js
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 	rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 	rtexprvalue="true"	 description="is this field required?" %>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 	rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="days" 		required="true"  	rtexprvalue="true"	 description="No of valid days from the current date allowed." %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- Define policy commencement dates min/max --%>
<jsp:useBean id="now" class="java.util.Date"/>
<fmt:formatDate var="nowDate" pattern="dd-MM-yyyy" value="${now}" />
<%
	java.text.DateFormat df = new java.text.SimpleDateFormat("dd/MM/yyyy");
	java.util.Date minDate = new java.util.Date();
	java.util.Date maxDate = new java.util.Date();
	java.util.Calendar calendar = new java.util.GregorianCalendar();
	calendar.setTime(maxDate);
	calendar.add(java.util.Calendar.DATE, Integer.parseInt(days));
	maxDate = calendar.getTime();
	String minStartDate = df.format(minDate);
	String maxStartDate = df.format(maxDate);
%>
<go:script marker="js-head">
var commencementDateSettings = {
		min : '<%=minStartDate %>',
		max : '<%=maxStartDate %>'
}
</go:script>

<%-- HTML --%>
<field_new:calendar xpath="${xpath}" required="true" title="policy start date" className="${name}" mode="inline" />

<%-- Datepicker is rendered and set with min/max dates in the CommencementDate module:
		example:
		$("#quote_options_commencementDate_calendar")
		.datepicker({ clearBtn:false, format:"dd/mm/yyyy"})
		.datepicker('setStartDate', commencementDateSettings.min)
		.datepicker('setEndDate', commencementDateSettings.max);

--%>
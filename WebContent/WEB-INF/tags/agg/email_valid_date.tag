<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<%@tag import="java.text.SimpleDateFormat"%>
<%@tag import="java.util.Calendar"%>
<%@tag import="java.util.Date"%>

<%--Calculate the valid end date for quotes - presently this is a single calculated date which
	has a formated version for display and normal format for use in calculations. It is likely
	that individual verticals/quotes/providers may eventually have their own unique end dates.
	These may be provided directly in the providers SOAP response or need to be implemented here.
--%>

<%@ attribute name="dateFormat"	required="false"	 rtexprvalue="true"	 description="Email address to be posted to" %>

<c:if test="${empty dateFormat}">
	<c:set var="dateFormat">dd MMMMM yyyy</c:set>
</c:if>

<%
	Calendar c = Calendar.getInstance();
	Date dt = new Date();

	c.setTime(dt);
	c.add(Calendar.DATE, 30); // 30 days ahead

	SimpleDateFormat sdf_display = new SimpleDateFormat(dateFormat);
	sdf_display.setCalendar(c);

	SimpleDateFormat sdf_normal = new SimpleDateFormat("yyyy-MM-dd");
	sdf_normal.setCalendar(c);
%>
<c:set var="validateDate">
	<validateDate>
		<display><%=sdf_display.format(c.getTime())%></display>
		<normal><%=sdf_normal.format(c.getTime())%></normal>
	</validateDate>
</c:set>

${validateDate}
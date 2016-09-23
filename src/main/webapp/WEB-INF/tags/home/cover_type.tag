<%@ tag description="Cover type and address" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="now_Date" pattern="yyyy-MM-dd" value="${now}" />

<jsp:useBean id="end" class="java.util.GregorianCalendar" />
<% end.add(java.util.GregorianCalendar.DAY_OF_MONTH, 30); %>
<fmt:formatDate var="end_Date" pattern="yyyy-MM-dd" value="${end.time}" />


<form_v2:fieldset legend="Cover for your home">

	<%-- Commencement Date --%>
	<home:commencementDate xpath="${xpath}/startDate" />

	<%-- Address --%>
	<group_v2:elastic_address xpath="${xpath}/property/address" type="R" />

</form_v2:fieldset>
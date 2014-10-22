<%@ tag description="Cover type and address" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="now_Date" pattern="yyyy-MM-dd" value="${now}" />

<jsp:useBean id="end" class="java.util.GregorianCalendar" />
<% end.add(java.util.GregorianCalendar.DAY_OF_MONTH, 30); %>
<fmt:formatDate var="end_Date" pattern="yyyy-MM-dd" value="${end.time}" />


<form_new:fieldset legend="Cover for your home">

	<%-- Cover type --%>
	<c:set var="fieldXpath" value="${xpath}/coverType" />
	<form_new:row fieldXpath="${fieldXpath}" label="Type of cover">
		<field_new:import_select xpath="${fieldXpath}"
			required="true"
			title="the type of cover"
			url="/WEB-INF/option_data/home_contents_cover_type.html" />
	</form_new:row>

	<%-- Commencement date --%>
	<c:set var="fieldXpath" value="${xpath}/startDate" />
	<form_new:row fieldXpath="${fieldXpath}" label="Commencement date" className="${xpath}_startDateFieldset" helpId="500">
		<field_new:commencement_date xpath="${fieldXpath}" />
	</form_new:row>

	<%-- Address --%>
	<group_new:address xpath="${xpath}/property/address" type="R" showTitle="false" />

</form_new:fieldset>
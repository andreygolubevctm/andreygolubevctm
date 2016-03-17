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

	<%-- Cover type --%>
	<c:set var="fieldXpath" value="${xpath}/coverType" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Type of cover">
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="the type of cover"
			url="/WEB-INF/option_data/home_contents_cover_type.html" />
	</form_v2:row>

	<%-- Commencement Date --%>
	<home:commencementDate xpath="${xpath}/startDate" />

	<%-- Address --%>
	<group_v2:elastic_address xpath="${xpath}/property/address" type="R" />

</form_v2:fieldset>
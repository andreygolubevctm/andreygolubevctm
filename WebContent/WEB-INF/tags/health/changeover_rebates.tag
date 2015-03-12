<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Set global variables related to rebate calculation changes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="effective_date" required="false" rtexprvalue="true" description="Health policy commencement date (optional)" %>

<%-- VARIABLES --%>
<fmt:setLocale value="en_GB" scope="session" />

<%-- Work out which commencement date to use --%>
<c:choose>
	<c:when test="${empty effective_date}">
		<jsp:useBean id="commencement_date" class="java.util.Date" />
	</c:when>
	<c:otherwise>
		<fmt:parseDate var="commencement_date" pattern="dd/MM/yyyy" value="${effective_date}" type="both" />
	</c:otherwise>
</c:choose>

<%-- List of change-over dates --%>
<fmt:parseDate var="changeover_date_1" pattern="yyyy-MM-dd HH:mm" value="2014-04-01 00:00" type="both" scope="request" />
<fmt:parseDate var="changeover_date_2" pattern="yyyy-MM-dd HH:mm" value="2015-04-01 00:00" type="both" scope="request" />
<fmt:parseDate var="changeover_date_3" pattern="yyyy-MM-dd HH:mm" value="2016-04-01 00:00" type="both" scope="request" />

<%-- List of multiplier that align with change-over dates --%>
<c:set var="multiplier_2013" value="${1}" />
<c:set var="multiplier_2014" value="${0.968}" />
<c:set var="multiplier_2015" value="${0.968}" />
<c:set var="multiplier_2016" value="${0.968}" />

<%-- Tag loaded in multiple place so just ensure this is done once --%>
<c:if test="${empty rebate_multiplier_current}">

	<c:choose>
		<c:when test="${commencement_date < changeover_date_1}">
			<c:set var="rebate_multiplier_current" value="${multiplier_2013}" scope="request" />
			<c:set var="rebate_multiplier_future" value="${multiplier_2014}" scope="request" />
		</c:when>
		<c:when test="${commencement_date >= changeover_date_1 and commencement_date < changeover_date_2}">
			<c:set var="rebate_multiplier_current" value="${multiplier_2014}" scope="request" />
			<c:set var="rebate_multiplier_future" value="${multiplier_2015}" scope="request" />
		</c:when>
		<c:when test="${commencement_date >= changeover_date_2 and commencement_date < changeover_date_3}">
			<c:set var="rebate_multiplier_current" value="${multiplier_2015}" scope="request" />
			<c:set var="rebate_multiplier_future" value="${multiplier_2016}" scope="request" />
		</c:when>
		<c:otherwise>
			<c:set var="rebate_multiplier_current" value="${multiplier_2013}" scope="request" />
			<c:set var="rebate_multiplier_future" value="${multiplier_2013}" scope="request" />
		</c:otherwise>
	</c:choose>

</c:if>
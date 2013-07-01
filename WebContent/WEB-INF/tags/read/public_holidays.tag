<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Retrieves the public holidays from the database" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%@ attribute name="country"	required="true" rtexprvalue="true"	 description="The country for which to retrieve the public holidays" %>
<%@ attribute name="region"	 	required="false" rtexprvalue="true"	 description="The region for which to retrieve the public holidays" %>
<%@ attribute name="format"	 	required="false" rtexprvalue="true"	 description="The format in which to return the public holiday dates" %>
<%@ attribute name="fromDate" 	required="false" rtexprvalue="true"	 description="Start of the range for which to retrieve the public holidays" %>
<%@ attribute name="toDate" 	required="false" rtexprvalue="true"	 description="End of the range for which to retrieve the public holidays" %>

<c:if test="${empty format}"><c:set var="format" value="iso" /></c:if>

<%-- Let's help formatting the countries names --%>
<c:set var="country" value="${go:TitleCase(fn:toLowerCase(country))}" />

<%-- Let's avoid issues when trying to get the Australian regions --%>
<c:choose>
	<c:when test="${fn:toLowerCase(region) eq 'qld'}"><c:set var="region" value="Queensland" /></c:when>
	<c:when test="${fn:toLowerCase(region) eq 'nsw'}"><c:set var="region" value="New South Wales" /></c:when>
	<c:when test="${fn:toLowerCase(region) eq 'vic'}"><c:set var="region" value="Victoria" /></c:when>
	<c:when test="${fn:toLowerCase(region) eq 'tas'}"><c:set var="region" value="Tasmania" /></c:when>
	<c:when test="${fn:toLowerCase(region) eq 'nt'}"><c:set var="region" value="Northern Territory" /></c:when>
	<c:when test="${fn:toLowerCase(region) eq 'sa'}"><c:set var="region" value="South Australia" /></c:when>
	<c:when test="${fn:toLowerCase(region) eq 'wa'}"><c:set var="region" value="Western Australia" /></c:when>
	<c:when test="${fn:toLowerCase(region) eq 'act'}"><c:set var="region" value="Australian Capital Territory" /></c:when>
	<c:when test="${not empty region}"><c:set var="region" value="${go:TitleCase(fn:toLowerCase(region))}" /></c:when>
</c:choose>

<sql:query var="results">
	SELECT *
	FROM aggregator.public_holidays
	WHERE
	country=?
	AND region=?
	<c:choose>
		<c:when test="${not empty fromDate and not empty toDate}">AND date BETWEEN STR_TO_DATE(?, '%d/%m/%Y') AND STR_TO_DATE(?, '%d/%m/%Y')</c:when>
		<c:when test="${not empty fromDate}">AND date >= STR_TO_DATE(?, '%d/%m/%Y')</c:when>
		<c:when test="${not empty toDate}">AND date <= STR_TO_DATE(?, '%d/%m/%Y')</c:when>
	</c:choose>

	<sql:param value="${country}" />

	<sql:param value="${region}" />

	<c:choose>
		<c:when test="${not empty fromDate and not empty toDate}">
			<sql:param value="${fromDate}" />
			<sql:param value="${toDate}" />
		</c:when>
		<c:when test="${not empty fromDate}">
			<sql:param value="${fromDate}" />
		</c:when>
		<c:when test="${not empty toDate}">
			<sql:param value="${toDate}" />
		</c:when>
	</c:choose>

</sql:query>

<%--
Returns a JS array but will be evaluated as a String by JS,
so it will need eval(result) to be run in order to use it as an array by the calling script
and jQuery ajax's dataType param to be set as "script" or "text" (not json)
--%>
<c:set var="result">
	<c:choose>
		<c:when test="${format eq 'dates'}">
			[
			<c:forEach items="${results.rows}" var="row" varStatus="status">
				<c:set var="splitDate" value="${fn:split(row.date, '-')}" />
				<c:set var="splitDate">${splitDate[2]}/${splitDate[1]}/${splitDate[0]}</c:set>
				"${splitDate}"<c:if test="${not status.last}">,</c:if>
			</c:forEach>
			]
		</c:when>
		<c:when test="${format eq 'iso'}">
			[
			<c:forEach items="${results.rows}" var="row" varStatus="status">
				"${row.date}"<c:if test="${not status.last}">,</c:if>
			</c:forEach>
			]
		</c:when>
		<c:when test="${format eq 'objects'}">
			[
			<c:forEach items="${results.rows}" var="row" varStatus="status">
				<c:set var="splitDate" value="${fn:split(row.date, '-')}" />
				{"day": "${splitDate[2]}","month": "${splitDate[1]}","year": "${splitDate[0]}"}<c:if test="${not status.last}">,</c:if>
			</c:forEach>
			]
		</c:when>
	</c:choose>
</c:set>

<c:set var="result">${go:replaceAll(result, "\\r", "")}</c:set>
<c:set var="result">${go:replaceAll(result, "\\n", "")}</c:set>
<c:set var="result">${go:replaceAll(result, "\\t", "")}</c:set>
${result}
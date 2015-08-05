<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	The data will arrive in a single parameter called QuoteData
	Containing the xml for the request in the structure:
	request
	|--fuel-types
	|--location
	|---suburb
	|---postcode
--%>

<%-- SQL time --%>
<sql:setDataSource dataSource="jdbc/ctm"/>



<go:log>REGIONAL SEARCH</go:log>


<c:choose>
	<%-- GET MODE --%>
	<c:when test="${not empty param.fuels}">
		<c:set var="fuels" value="${param.fuels}" />
		<c:set var="location" value="${param.location}" />
		<c:set var="state" value="${param.state}" />
		<c:set var="postcode" value="${param.postcode}" />
		<c:set var="suburb" value="${param.suburb}" />
		<c:set var="state" value="${param.state}" />
	</c:when>
	<%-- XML MODE --%>
	<c:otherwise>
		<x:parse var="fuel" xml="${param.QuoteData}" />
			<c:set var="fuels"><x:out select="$fuel/request/details/fuels" /></c:set>
			<c:set var="location"><x:out select="$fuel/request/details/location" /></c:set>
			<c:set var="state"><x:out select="$fuel/request/details/state" /></c:set>
			<c:set var="postcode"><x:out select="$fuel/request/details/location" /></c:set>
			<c:set var="suburb"><x:out select="$fuel/request/details/location" /></c:set>
	</c:otherwise>
</c:choose>

<c:if test="${empty state}">
	<c:set var="state" value="" />
</c:if>

<%-- Get the time difference --%>
<sql:query var="timeResult">
	SELECT TIMESTAMPDIFF(SECOND, Time, Now() )
	FROM `aggregator`.`fuel_updates`
	WHERE Status = 200 AND Type = 'R' ORDER BY UpdateId DESC LIMIT 1;
</sql:query>
<c:if test="${not empty timeResult}">
	<c:set var="timeDiff" value="${timeResult.rows[0]['TIMESTAMPDIFF(SECOND, Time, Now() )']}" />
</c:if>

<%-- Need to have a STATE var. --%>
<c:if test="${state == ''}">
	<sql:query var="stateResult">
		SELECT state FROM aggregator.suburb_search
		WHERE suburb = ?
		OR postcode = ?
		LIMIT 1;
		<sql:param value="${suburb}" />
		<sql:param value="${postcode}" />
	</sql:query>
	<c:if test="${not empty stateResult}">
		<c:set var="state" value="${stateResult.rows[0]['state']}" />
	</c:if>
</c:if>


<%-- Need to process the FUEL types --%>
<c:set var="fuel1" value="" />
<c:set var="fuel2" value="" />
<c:forTokens delims="," items="${fuels}" varStatus="status" var="token">
	<c:choose>
		<c:when test="${status.count == 1}">
			<c:set var="fuel1" value="${token}" />
		</c:when>
		<c:when test="${status.count == 2}">
			<c:set var="fuel2" value="${token}" />
		</c:when>
	</c:choose>
</c:forTokens>


<%-- Main Query --%>
<c:if test="${not empty state}">
	<sql:query var="result">
		SELECT DISTINCT(a.City), a.State, a.RecordedTime, b.avgPrice as Price1, c.avgPrice as Price2
		FROM aggregator.fuel_rates_regional a
		LEFT JOIN aggregator.fuel_rates_regional b
		ON b.city = a.city and b.state = a.state and b.fuelID = ?
		LEFT JOIN aggregator.fuel_rates_regional c
		ON c.city = a.city and c.state = a.state and c.fuelID = ?
		WHERE a.state = ? AND FIND_IN_SET(a.FuelId, ?)
		<sql:param value="${fuel1}" />
		<sql:param value="${fuel2}" />
		<sql:param value="${state}" />
		<sql:param value="${fuels}" />
	</sql:query>
</c:if>

<c:set var="update"><fuel_new:schedule type="regional" /></c:set>

<%-- Build the xml data for each row --%>
<results type="regional">
	<fuel1>${fuel1}</fuel1>
	<fuel2>${fuel2}</fuel2>
	<c:if test="${timeDiff > 87300}"> <%-- FIX: 87300 --%>
		<error>delay</error> <%-- Test if the results are too old (technical issue) --%>
	</c:if>
	<time><field:time_ago time="${timeDiff}" timestamp="true" /></time>
	<c:if test="${update < 7200}">
		<update><field:time_ago time="${update}" timestamp="true" rounding="10" /></update>
	</c:if>
	<c:if test="${not empty result}" >
		<c:forEach var="row" items="${result.rows}">
			<c:set var="time" value="${row.RecordedTime}" />
			<c:set var="dy" value="${fn:substring(time, 8, 10)}" />
			<c:set var="mt" value="${fn:substring(time, 5, 7)}" />
			<c:set var="yr" value="${fn:substring(time, 0, 4)}" />
			<c:set var="dl" value="-" />
			<result>
				<name>${row.City}</name>
				<state>${row.State}</state>
				<premium>${row.Price1}</premium>
				<premium2>${row.Price2}</premium2>
				<created>${dy}${dl}${mt}${dl}${yr}</created>
			</result>
		</c:forEach>
		<c:if test="result.rowCount == 0">
			<result>
				<name></name>
				<state></state>
				<premium></premium>
				<premium2></premium2>
				<created>0</created>
			</result>
		</c:if>
	</c:if>
</results>
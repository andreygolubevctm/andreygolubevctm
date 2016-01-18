<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date,java.io.*,java.util.*,java.text.*,java.math.*, java.io.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.upload_regional_fuel_prices')}" />

<%--
AUTOMATIC CRON JOB FOR MOTORMOUTH FUEL SERVICE - REGIONAL
=========================================================
To be run at these times: 0900.

Update status codes:
100 (Pending)
200 (Successful)
400 (Failed - XML contains bad syntax, data does not conform)
403 (Failed - Denied or not authorised)
404 (Failed - XML not returned - or not XML)
500 (Failed - Server Error or SQL error)
501 (Failed - Inserting new Sites)

Process:
- Add new Update interval with the 100 pending code (if no update has been run in the last x minutes)
-- Get the returned UpdateId and pass as a parameter

- For EACH STATE (param) and EACH FUEL (param) - Call the XML
-- IF Any Errors, i.e. not found, malformed etc. cancel and append the 404 error
-- Insert the data into SQL and check for errors

-- Any Hard errors on the way through incur a 500 code
-- IF OK, update the ID to have a 200 code

--%>


<c:set var="url" value="https://partners.motormouth.com.au/Service.svc/CountryDailyAverageXml" />
<c:set var="fuels" value="2,3,4,5,6,7,8,9" />
<c:set var="states" value="ACT,NSW,NT,QLD,SA,TAS,VIC,WA" />
<%--
<c:set var="fuels" value="2" />
<c:set var="states" value="QLD" />
--%>
<c:set var="errorPool" value='' />
<c:set var="errorSoftPool" value='' />
<c:set var="sqlCount">0</c:set>


<sql:setDataSource dataSource="${datasource:getDataSource()}"/>



<%--
======================
ID
----------------------
--%>

<%-- Create a new ID  --%>
<c:catch var="error">
	<sql:update var="result">
		INSERT INTO aggregator.fuel_updates
		(UpdateId, Time, Status, Type) VALUES (NULL, NOW(), ?, ?);
		<sql:param>100</sql:param>
		<sql:param value="R" />;
	</sql:update>
</c:catch>


<%-- Get the ID or FAIL --%>
<c:choose>
	<c:when test="${not empty error}">
		<c:set var="errorPool" value="${errorPool} <error s='insert(new id)'>${error.rootCause}</error>" />
	</c:when>
	<c:otherwise>
		<sql:query var="result">
			SELECT UpdateId FROM aggregator.fuel_updates WHERE Type = 'R' ORDER BY UpdateId DESC LIMIT 1;
		</sql:query>
		<c:set var="updateId" value="${result.rows[0]['UpdateId']}" />
	</c:otherwise>
</c:choose>



<%--
========================
XML PARSE AND SQL UPDATE
------------------------
--%>

<%-- MAIN CALLER TO GENERATE THE MASTER XML FILE - THIS NEEDS TO BE ERROR FREE TO CONTINUE SAVING --%>
<c:if test="${empty errorPool }">
	<%-- For Each State and Each Fuel Type - get the XML and attempt to parse it --%>
	<c:forTokens var="stateToken" delims="," items="${states}">
	<c:if test="${empty errorPool }">
	<c:forTokens var="fuelToken" delims="," items="${fuels}">

		<%-- Attempt to import the XML and Parse it --%>
		<c:catch var="error">
			<c:import var="inbound" url="${url}">
				<c:param name="fuelType" value="${fuelToken}" />
				<c:param name="state" value="${stateToken}" />
			</c:import>
			<x:parse xml="${inbound}" var="data" />
		</c:catch>

		<%-- simple Parse/Import Error --%>
		<c:choose>
			<c:when test="${not empty error}">
				<c:set var="errorPool" value="${errorPool} <error x='parse' c='import'>${error.rootCause}</error>" />
				<sql:update>
					UPDATE aggregator.fuel_updates SET Status = ?
					WHERE UpdateId = ?;
					<sql:param>404</sql:param>
					<sql:param>${updateId}</sql:param>
				</sql:update>
			</c:when>
			<c:otherwise>
				<%-- See if the XML itself is ok --%>
				<x:choose>
					<x:when select="$data//ResultCode = 1">
						<c:set var="errorSoftPool">${errorSoftPool} <error x='parse' c='import'><x:out select="$data//ResultCode" />: <x:out select="$data//ResultMsg" /> [${stateToken} for ${fuelToken}]</error></c:set>
					</x:when>
					<x:when select="$data//ResultCode > 1">
						<c:set var="errorPool">${errorPool} <error x='parse' c='import'><x:out select="$data//ResultCode" />: <x:out select="$data//ResultMsg" /></error></c:set>
						<sql:update>
							UPDATE aggregator.fuel_updates SET Status = ?
							WHERE UpdateId = ?;
							<sql:param>403</sql:param>
							<sql:param>${updateId}</sql:param>
						</sql:update>
					</x:when>
				</x:choose>
			</c:otherwise>
		</c:choose>


		<%--
		=========================
		MAIN PARSE AND SQL UPDATE
		-------------------------
		--%>

		<%-- POUND THROUGH EACH XML RESULT AND INSERT IT WITH SQL --%>
		<c:if test="${empty errorPool }">
			<x:forEach select="$data//Result" var="x">

				<%-- Double check the data integrity --%>
				<x:if select="$x/AvgPrice">

					<%-- Run the SQL update based on the results, capture any errors --%>
					<c:catch var="error">
						<sql:update var="result">
							INSERT INTO aggregator.fuel_results_regional
							(UpdateId, State, FuelId, City, AvgPrice, RecordedTime) VALUES (?,?,?,?,?,?);
							<sql:param>${updateId}</sql:param>
							<sql:param value="${stateToken}" />
							<sql:param><x:out select="$x/FuelID" /></sql:param>
							<sql:param><x:out select="$x/City" /></sql:param>
							<sql:param><x:out select="$x/AvgPrice" /></sql:param>
							<sql:param><x:out select="$x/CollectedDate" /></sql:param>
						</sql:update>
					</c:catch>

					<%-- Capture the error and set the Status OR add to the count --%>
					<c:choose>
						<c:when test="${not empty error}">
							<%-- Look for a hard or soft error --%>
							<c:choose>
								<c:when test="${fn:contains(error.rootCause, 'Duplicate')}">
									<c:set var="errorSoftPool" value="${errorPool} <error s='insert result'>${error.rootCause}</error>" />
								</c:when>
								<c:otherwise>
									<c:set var="errorPool" value="${errorPool} <error s='insert result'>${error.rootCause}</error>" />
									<sql:update>
										UPDATE aggregator.fuel_updates SET Status = ?
										WHERE UpdateId = ?;
										<sql:param>500</sql:param>
										<sql:param>${updateId}</sql:param>
									</sql:update>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:set var="sqlCount" value="${sqlCount +1}" />
						</c:otherwise>
					</c:choose>

				</x:if>

			</x:forEach>
		</c:if>
		<%--  / MAIN XML AND PARSE --%>


		<%-- Send an Update to the server --%>
		${logger.info("Results for {}, {}, {}", log:kv("stateToken",stateToken), log:kv("fuelToken",fuelToken), log:kv("sqlCount",sqlCount))}
	</c:forTokens>
	</c:if>
	</c:forTokens>
</c:if>


<%-- Sound the all clear --%>
<c:if test="${empty errorPool }">
	<sql:update>
		UPDATE aggregator.fuel_updates SET Status = ?
		WHERE UpdateId = ?;
		<sql:param>200</sql:param>
		<sql:param>${updateId}</sql:param>
	</sql:update>
</c:if>


<%-- XML RESPONSE --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
	<id>${updateId}</id>
	<inserted>${sqlCount}</inserted>
	<c:if test="${not empty errorPool}">
		<errors>${errorPool}</errors>
	</c:if>
	<c:if test="${not empty errorSoftPool}">
		<errors type="soft">${errorSoftPool}</errors>
	</c:if>
</data>
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


<%-- SET Variables --%>
<c:set var="postcode" value="" />
<c:set var="PostcodeId" value="" />
<c:set var="PostcodeList" value="" />
<c:set var="suburb" value="" />

<x:parse var="fuel" xml="${param.QuoteData}" />
<c:set var="fuels"><x:out select="$fuel/request/details/fuels" /></c:set>
<c:set var="location"><x:out select="$fuel/request/details/location" /></c:set>

<%-- When regular diesel selected - always include premium diesel in the results (FUE-21)--%>
<c:if test="${fn:contains(fuels, '3') and not fn:contains(fuels, '9')}">
	<c:set var="fuels"><c:out value="${fuels}" />,9</c:set>
</c:if>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<%-- MAKE the postcode, suburb and state variables by splitting the location string (Suburb PCODE STATE) --%>
<c:forTokens items="${location}" delims=" " var="locationToken">
		<c:catch var="error">
			<c:set var="temp"><fmt:formatNumber value="${locationToken}" type="number" /></c:set>			
		</c:catch>			
		
		<%-- Grab the SQL for the result --%>
		<c:choose>
			<c:when test="${empty error}">				
				<c:set var="postcode">${locationToken}</c:set>
			</c:when>
			<c:otherwise>
				<%-- Strain away the state or anything after the postcode --%>
				<c:choose>
					<c:when test="${postcode == ''}">
						<c:set var="suburb" value="${suburb} ${locationToken}" />
					</c:when>
					<c:otherwise>
						<c:set var="state" value="${locationToken}" />
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>		
</c:forTokens>


<%-- Postcode is the best way to determine prices, otherwise use a suburb name  --%>
<c:if test="${postcode != ''}">
	<c:set var="suburb" value="" />
</c:if>
<c:set var="suburb" value="${fn:trim(suburb)}" />

<%-- Get the PostCode if it hasn't been previously identified --%>
<c:if test="${postcode == '' }">
	<sql:query var="isPostcode">
		SELECT postCode FROM aggregator.suburb_search
		WHERE suburb LIKE(?);
		<sql:param value="${suburb}%" />
	</sql:query>
	<%-- ***FIX: this may break if no match is found --%>	
	<c:set var="postcode" value="${isPostcode.rows[0]['postCode']}" />
</c:if>

<%-- CHECK: if the postcode is regional and REDIRECT to the regional search --%>
<sql:query var="isRegional">
	SELECT PostCode FROM aggregator.fuel_postcodes WHERE (PostCode = ? AND Type = 'R');
	<sql:param value="${postcode}" />
</sql:query>

<c:if test="${isRegional.rowCount > 0}">
	<%-- Create TEMP URL --%>
	<c:url value="fuel_price_result_regional.jsp" var="profileLink">
		<c:param name="fuels" value="${fuels}"/>
		<c:param name="location" value="${location}"/>
		<c:param name="postcode" value="${postcode}"/>
		<c:param name="suburb" value="${suburb}"/>
		<c:param name="state" value="${state}"/>
	</c:url>
	
	<%-- Go to the regional results page --%>
	<c:redirect url="${profileLink}" />

</c:if>


<%--
=================
MAIN METRO SEARCH
=================
--%>

<c:set var="update"><fuel_new:schedule type="metro" /></c:set>


<%-- Get the time difference --%>	
<sql:query var="timeResult">
	SELECT TIMESTAMPDIFF(SECOND, Time, Now() )
	FROM `aggregator`.`fuel_updates`
	WHERE Status = 200 AND Type = 'M' ORDER BY UpdateId DESC LIMIT 1;
</sql:query>
<c:if test="${not empty timeResult}">
	<c:set var="timeDiff" value="${timeResult.rows[0]['TIMESTAMPDIFF(SECOND, Time, Now() )']}" />
</c:if>


<%-- GET: all the Post Codes from the search criteria --%>
<sql:query var="PostcodeListResults" >
	SELECT PostcodeList FROM aggregator.postcode_relations WHERE FIND_IN_SET(PostcodeId, ?);
	<sql:param value="${postcode}" />
</sql:query>

<%-- PARSE: them into a single-string --%>
<c:forEach var="row" varStatus="status" items="${PostcodeListResults.rows}">
	<c:set var="PostcodeList">${PostcodeList} ${row.PostCodeList}<c:if test="${!status.last}">, </c:if></c:set>
</c:forEach>	
<c:set var="PostcodeList" value="${postcode},${PostcodeList}" />

<%-- RUN: the main search with all the results --%>
<sql:query var="result">
	SELECT *
	FROM aggregator.fuel_rates
	WHERE FIND_IN_SET(FuelId, ? )
	AND FIND_IN_SET(PostCode, ? )
	ORDER BY Price LIMIT 25;
	<sql:param value="${fuels}" />
	<sql:param value="${PostcodeList}" />
</sql:query>


<%-- Build the xml data for each row --%>
<results type="metro">
	<c:if test="${timeDiff > 86400}"> <%-- FIX: 86400 --%>
		<error>delay</error> <%-- Test if the results are too old (technical issue) --%>
	</c:if>
	<time><field_v1:time_ago time="${timeDiff}" timestamp="true" /></time>
	<c:if test="${update < 7200}">
	<update><field_v1:time_ago time="${update}" timestamp="true" rounding="10" /></update>
	</c:if>
	<c:forEach var="row" items="${result.rows}">
		<result>
			<brand>${row.Brand}</brand>
			<siteid>${row.SiteId}</siteid>
			<name>${row.Name}</name>
			<state>${row.State}</state>
			<suburb>${row.Suburb}</suburb>
			<address>${row.Address}</address>
			<postcode>${row.PostCode}</postcode>
			<lat>${row.Lat}</lat>
			<long>${row.Long}</long>
			<premium>${row.Price}</premium>
			<fuelid>${row.FuelId}</fuelid>
			<created>${row.RecordedTime}</created>

			<%-- Format recorded time as American date so JavaScript can parse it --%>
			<fmt:setLocale value="en_AU" scope="page" />
			<fmt:parseDate var="parsedRecordedTime" pattern="dd/MM/yyyy hh:mm:ss a" value="${row.RecordedTime}" />
			<fmt:formatDate var="formattedRecordedTime" value="${parsedRecordedTime}" pattern="MM/dd/yyyy hh:mm a"/>
			<createdFormatted>${formattedRecordedTime}</createdFormatted>
		</result>
	</c:forEach>
	<c:if test="result.rowCount == 0">
		<result>
			<siteid></siteid>
			<name></name>
			<fuelid></fuelid>
		</result>		
	</c:if>
</results>

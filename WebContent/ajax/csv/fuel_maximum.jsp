<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%  response.setHeader("Content-Disposition","attachment; filename=" + "cc_fuel_maximums.csv" ); %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%--
PROCESS:
-- Get the paramater to see if the fuel response = all (i.e. run all of the postcodes relations)
- get the full list of individual PostCodes
- for each post-code, get each fuel type
- add the results to the page
--%>

<c:set var="fuels" value="6,2,5,7,3,8,9,4" />

<sql:query var="postcodes">
	SELECT PostcodeId, PostcodeList
	FROM aggregator.postcode_relations
	ORDER BY PostcodeId
</sql:query>

<%-- CSV HEADER --%>
"PostCode","E10","ULP","PULP95","PULP98","DIESEL","BIO-DIESEL","PREM. DIESEL","LPG","TOTAL"
<%-- CHECK FOR EACH POST-CODE--%>
<c:forEach var="row" items="${postcodes.rows}">

	<%-- Switch the amount of postcodes to check, based on request --%>
	<c:choose>
		<c:when test="${not empty param.relations}">
			<c:set var="postCodeCheck" value="${row.PostcodeId},${row.PostcodeList}" />
		</c:when>
		<c:otherwise>
			<c:set var="postCodeCheck" value="${row.PostcodeId}" />
		</c:otherwise>
	</c:choose>
	
	<%-- reset the variables --%>
	<c:set var="count" value="${0}" />
	<c:set var="string">
	"${row.PostcodeId}",</c:set>
	
	<%-- Check each fuel type --%>
	<c:forTokens var="fuel" delims="," items="${fuels}">	
		
		<sql:query var="result">
			SELECT Price
			FROM aggregator.fuel_rates
			WHERE FuelId = ?
			AND FIND_IN_SET(Postcode, ? )
			<sql:param value="${fuel}" />
			<sql:param>${postCodeCheck}</sql:param>
		</sql:query>
		
		<c:set var="count" value="${count + result.rowCount}" />
		<c:set var="string">${string}"${result.rowCount}",
		</c:set>
	</c:forTokens>
	
	<c:set var="string">${string}"${count}"</c:set>
	${string}.
</c:forEach>
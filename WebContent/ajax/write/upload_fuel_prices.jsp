<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date,java.io.*,java.util.*,java.text.*,java.math.*, java.io.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>



<%--
AUTOMATIC CRON JOB FOR MOTORMOUTH FUEL SERVICE
==============================================
To be run at these times: 0900, 1300 and 1700.

Update status codes:
100 (Pending)
200 (Successful)
400 (Failed - XML contains bad syntax, data does not conform)
403 (Failed - Denied or not authorised)
404 (Failed - XML not returned - or not XML)
500 (Failed - Server Error or SQL error)
501 (Failed - Inserting new Sites)
502 (Failed - Updating Sites Lat/Long)

Process:
- Add new Update interval with the 100 pending code (if no update has been run in the last x minutes)
-- Get the returned UpdateId and pass as a parameter

- For EACH STATE (param) - Call the XML (for all fuels)
-- IF Any Errors, i.e. not found, malformed etc. cancel and append the 404 error
-- Insert the data into SQL and check for errors

- Check if there are any new sites, if so insert them into db
-- Check for errors and add them to seperate errors

- Check if there are sites without lat/long coordinates, if so update them into the SQL
-- Check for errors and add them to seperate errors

-- Any Hard errors on the way through incur a 500 code
-- IF OK, update the ID to have a 200 code


 --%>


<c:set var="url" value="https://partners.motormouth.com.au/Service.svc/StateSearchAllPricesXml" />
<c:set var="fuel" value="2,3,4,5,6,7,8,9" />
<%--
<c:set var="states" value="QLD" />
--%>
<c:set var="states" value="ACT,NSW,NT,QLD,SA,TAS,VIC,WA" />
<c:set var="errorPool" value='' />
<c:set var="errorSoftPool" value='' />
<c:set var="sqlCount">0</c:set>
<c:set var="newSites">0</c:set>


<sql:setDataSource dataSource="jdbc/aggregator"/>



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
    	<sql:param value="M" />;
	 </sql:update>
</c:catch>


<%-- Get the ID or FAIL --%>
<c:choose>
	<c:when test="${not empty error}">
		<c:set var="errorPool" value="${errorPool} <error s='insert(new id)'>${error.rootCause}</error>" />
	</c:when>
	<c:otherwise>
		<sql:query var="result">
			SELECT UpdateId FROM aggregator.fuel_updates WHERE Type = 'M' ORDER BY UpdateId DESC LIMIT 1;
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
	<%-- For Each State - get the XML and attempt to parse it --%>
	<c:forTokens var="token" delims="," items="${states}">	
		
		<%-- Attempt to import the XML and Parse it --%>
		<c:catch var="error">
			<c:import var="inbound" url="${url}">
				<c:param name="fuelTypes" value="${fuel}" />
				<c:param name="state" value="${token}" />
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
						<c:set var="errorSoftPool">${errorSoftPool} <error x='parse' c='import'><x:out select="$data//ResultCode" />: <x:out select="$data//ResultMsg" /></error></c:set>
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
			<%-- Double Check Data Integrity --%>
			<x:if select="$x/Price">
			
				<%-- Map the Fuel ID --%>
				<c:set var="FuelId"><x:out select="$x/Fuel" /></c:set>
				<c:choose>
					 <c:when test="${FuelId == 'Unleaded'}">
					 	<c:set var="FuelId" value="2" />
					 </c:when>
					 <c:when test="${FuelId == 'Diesel'}">
					 	<c:set var="FuelId" value="3" />
					 </c:when>
					 <c:when test="${FuelId == 'LPG'}">
					 	<c:set var="FuelId" value="4" />
					 </c:when>
					 <c:when test="${FuelId == 'Premium Unleaded 95'}">
					 	<c:set var="FuelId" value="5" />
					 </c:when>
					 <c:when test="${FuelId == 'E10'}">
					 	<c:set var="FuelId" value="6" />
					 </c:when>
					 <c:when test="${FuelId == 'Premium Unleaded 98'}">
					 	<c:set var="FuelId" value="7" />
					 </c:when>
					 <c:when test="${FuelId == 'Bio-Diesel 20'}">
					 	<c:set var="FuelId" value="8" />
					 </c:when>
					 <c:when test="${FuelId == 'Premium Diesel'}">
					 	<c:set var="FuelId" value="9" />
					 </c:when>					 			 			 			 			 			 			 
				    <c:otherwise>
				       <c:set var="FuelId" value="0" />
				    </c:otherwise>			 
				</c:choose>			
				
				<%-- Run the SQL update based on the results, capture any errors --%>
				<c:catch var="error">
					<sql:update var="result">
						INSERT INTO aggregator.fuel_results
						(UpdateId, SiteId, FuelId, Price, RecordedTime) VALUES (?,?,?,?,?);
						<sql:param>${updateId}</sql:param>
						<sql:param><x:out select="$x/SiteID" /></sql:param>
						<sql:param>${FuelId}</sql:param>
						<sql:param><x:out select="$x/Price" /></sql:param>
						<sql:param><x:out select="$x/RecordedTime" /></sql:param>
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
		<% System.out.println( "Results for " + pageContext.getAttribute("token") + " = " + pageContext.getAttribute("sqlCount") ); %>
		
		
		<%--
		=======================================
		AUXILLIARY XML AND PARSE UPDATE (SITES)
		---------------------------------------
		--%>				
				
		<c:if test="${empty errorPool}">
			<c:catch var="error">
				<sql:query var="result_u">
					SELECT DISTINCT fuel_results.SiteId FROM aggregator.fuel_results
						LEFT JOIN aggregator.fuel_sites ON aggregator.fuel_results.SiteId = aggregator.fuel_sites.SiteId
					WHERE aggregator.fuel_sites.SiteId IS NOT NULL AND fuel_results.UpdateId = ?;
					<sql:param>${updateId}</sql:param>
				</sql:query>
			</c:catch>

			<%-- ARE THERE ANY NEW SITES? IF SO UPDATE THEM --%>
			<%-- Capture the error and set the Status OR add to the count --%>
			<c:choose>
				<c:when test="${not empty error}">
					<c:set var="errorPool" value="${errorPool} <error s='select sites'>${error.rootCause}</error>" />
				</c:when>
				<c:otherwise>
					<%-- FOR EACH ROW RESULT / UPDATE SOME NEW SQL --%>
					<c:forEach var="row" items="${result_u.rows}">

						<c:set var="xID" value="${row.SiteId}" scope="page" />
						<x:set select="$data//Result[SiteID=$pageScope:xID][1]" var="res" />
						<c:set var="state"><x:out select="$res/StateID" /></c:set>
						<c:choose>
							<c:when test="${state == '1'}">
								<c:set var="state" value="QLD" />
							</c:when>
							<c:when test="${state == '2'}">
								<c:set var="state" value="NSW" />
							</c:when>
							<c:when test="${state == '3'}">
								<c:set var="state" value="VIC" />
							</c:when>
							<c:when test="${state == '4'}">
								<c:set var="state" value="SA" />
							</c:when>
							<c:when test="${state == '5'}">
								<c:set var="state" value="WA" />
							</c:when>
							<c:when test="${state == '6'}">
								<c:set var="state" value="ACT" />
							</c:when>
							<c:when test="${state == '7'}">
								<c:set var="state" value="TAS" />
							</c:when>
							<c:when test="${state == '8'}">
								<c:set var="state" value="NT" />
							</c:when>
							<c:otherwise>
							<c:set var="state" value="UNK" />
							</c:otherwise>
						</c:choose>

						<c:catch var="error2a">
							<sql:update var="result2">
								UPDATE aggregator.fuel_sites
								SET Name = ?, Brand = ?
								WHERE SiteId = ?;
								<sql:param><x:out select="$res/Name" /></sql:param>
								<sql:param><x:out select="$res/Brand" /></sql:param>
								<sql:param>${row.SiteId}</sql:param>
							</sql:update>
						</c:catch>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</c:if>


		<c:if test="${empty errorPool}">
			<c:catch var="error">
				<sql:query var="result">
					SELECT DISTINCT fuel_results.SiteId FROM aggregator.fuel_results 
					     LEFT JOIN aggregator.fuel_sites ON aggregator.fuel_results.SiteId = aggregator.fuel_sites.SiteId
					WHERE aggregator.fuel_sites.SiteId IS NULL AND fuel_results.UpdateId = ?;
					<sql:param>${updateId}</sql:param>
				</sql:query>
			</c:catch>
			
			<%-- ARE THERE ANY NEW SITES? IF SO UPDATE THEM --%>
			<%-- Capture the error and set the Status OR add to the count --%>
			<c:choose>
				<c:when test="${not empty error}">
					<c:set var="errorPool" value="${errorPool} <error s='select sites'>${error.rootCause}</error>" />					
				</c:when>
				<c:otherwise>		
					<%-- FOR EACH ROW RESULT / UPDATE SOME NEW SQL --%>
					<c:forEach var="row" items="${result.rows}">
							
					<c:set var="xID" value="${row.SiteId}" scope="page" /> 
						<x:set select="$data//Result[SiteID=$pageScope:xID][1]" var="res" />
							<c:set var="state"><x:out select="$res/StateID" /></c:set>
							<c:choose>
								 <c:when test="${state == '1'}">
								 	<c:set var="state" value="QLD" />
								 </c:when>
								 <c:when test="${state == '2'}">
								 	<c:set var="state" value="NSW" />
								 </c:when>
								 <c:when test="${state == '3'}">
								 	<c:set var="state" value="VIC" />
								 </c:when>
								 <c:when test="${state == '4'}">
								 	<c:set var="state" value="SA" />
								 </c:when>
								 <c:when test="${state == '5'}">
								 	<c:set var="state" value="WA" />
								 </c:when>
								 <c:when test="${state == '6'}">
								 	<c:set var="state" value="ACT" />
								 </c:when>
								 <c:when test="${state == '7'}">
								 	<c:set var="state" value="TAS" />
								 </c:when>
								 <c:when test="${state == '8'}">
								 	<c:set var="state" value="NT" />
								 </c:when>					 			 			 			 			 			 			 
							    <c:otherwise>
							       <c:set var="state" value="UNK" />
							    </c:otherwise>		
							</c:choose>
									
							<c:catch var="error2">
								<sql:update var="result2">
									INSERT INTO aggregator.fuel_sites
									(`SiteId`, `Name`, `State`, `PostCode`, `Suburb`, `Address`, `Brand`, `Lat`, `Long`) VALUES (?,?,?,?,?,?,?,?,?);
								  	<sql:param>${row.SiteId}</sql:param>
								  	<sql:param><x:out select="$res/Name" /></sql:param>
								  	<sql:param>${state}</sql:param>
								  	<sql:param><x:out select="$res/Postcode" /></sql:param>
								  	<sql:param><x:out select="$res/Suburb" /></sql:param>
								  	<sql:param><x:out select="$res/Address" /></sql:param>
								  	<sql:param><x:out select="$res/Brand" /></sql:param>
									<sql:param><x:out select="$res/Lat" /></sql:param>
									<sql:param><x:out select="$res/Long" /></sql:param>
								</sql:update>
							</c:catch>
							
							
							<%-- Capture the error and set the Status OR add to the count --%>
							<c:choose>
								<c:when test="${not empty error2}">
									<c:set var="errorPool" value="${errorPool} <error s='insert site'>${error2.rootCause}</error>" />
									<sql:update>
										UPDATE aggregator.fuel_updates SET Status = ?
										WHERE UpdateId = ?;
										<sql:param>501</sql:param>
										<sql:param>${updateId}</sql:param>
									</sql:update>											
								</c:when>
								<c:otherwise>
									<c:set var="siteCount" value="${siteCount +1}" />
								</c:otherwise>
							</c:choose>						
											
																 	
					</c:forEach>		
					
				</c:otherwise>
			</c:choose>			

			<%-- UPDATING THE LAT/LONG FOR SITES WHICH DON'T HAVE THEM YET --%>
			<c:catch var="error">
				<sql:query var="result">
					SELECT DISTINCT fuel_results.SiteId FROM aggregator.fuel_results
						LEFT JOIN aggregator.fuel_sites ON aggregator.fuel_results.SiteId = aggregator.fuel_sites.SiteId
					WHERE (aggregator.fuel_sites.Lat IS NULL OR aggregator.fuel_sites.Long IS NULL) AND fuel_results.UpdateId = ?;
					<sql:param>${updateId}</sql:param>
				</sql:query>
			</c:catch>

			<%-- Capture the error and set the Status OR add to the count --%>
			<c:choose>
				<c:when test="${not empty error}">
					<c:set var="errorPool" value="${errorPool} <error s='select sites'>${error.rootCause}</error>" />
				</c:when>
				<c:otherwise>
					<%-- FOR EACH ROW RESULT / UPDATE SOME NEW SQL --%>
					<c:forEach var="row" items="${result.rows}">

						<c:set var="xID" value="${row.SiteId}" scope="page" />
						<x:set select="$data//Result[SiteID=$pageScope:xID][1]" var="res" />

						<c:catch var="error2">
							<sql:update var="result2">
								UPDATE `aggregator`.`fuel_sites`
								SET `Lat`=?, `Long`=?
								WHERE `SiteId`=?;
								<sql:param><x:out select="$res/Lat" /></sql:param>
								<sql:param><x:out select="$res/Long" /></sql:param>
								<sql:param>${row.SiteId}</sql:param>
							</sql:update>
						</c:catch>

						<%-- Capture the error and set the Status --%>
						<c:if test="${not empty error2}">
							<c:set var="errorPool" value="${errorPool} <error s='update site lat/long'>${error2.rootCause}</error>" />
							<sql:update>
								UPDATE aggregator.fuel_updates SET Status = ?
								WHERE UpdateId = ?;
								<sql:param>502</sql:param>
								<sql:param>${updateId}</sql:param>
							</sql:update>
		</c:if>		
			
					</c:forEach>

				</c:otherwise>
			</c:choose>

		</c:if>

	</c:forTokens>	
</c:if>


<%-- CHECK FOR CONTINUED ERRORS AND SAVE THE XML FILE 
<c:if test="${empty errorPool}">

	<c:catch var="error">
		<c:set var="updateIdMax">_NEWROOTDIR_/WEB-INF/aggregator/fuel/downloads/stateSearchAllPrices_<fmt:formatNumber groupingUsed="false" type="number" minIntegerDigits="8" value="${updateId}" />.txt</c:set>
		<c:set var="newString" value="Hello World!!!" /> 
		${go:writeToFile(updateIdMax,newString)}
	</c:catch>

	<c:if test="${not empty error}">
		<c:set var="errorPool" value="${errorPool} <error f='write'>${error.rootCause}</error>" />
		<sql:update>
			UPDATE aggregator.fuel_updates SET Status = ?
			WHERE UpdateId = ?;
			<sql:param>500</sql:param>
			<sql:param>${updateId}</sql:param>
		</sql:update>		
	</c:if>			
	
</c:if>
--%>


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
	<newSites>${siteCount}</newSites>
	<c:if test="${not empty errorPool}">
		<errors>${errorPool}</errors>
	</c:if>
	<c:if test="${not empty errorSoftPool}">
		<errors type="soft">${errorSoftPool}</errors>
	</c:if>		
</data>

<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date,java.io.*,java.util.*,java.text.*,java.math.*, java.io.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.upload_postcode_relations')}" />

<%--
SERVICE PAGE THAT CAN BE RUN FROM MOTORMOUTH TO POPULATE POSTCODES
==================================================================


Process:
- Get all the current postcodes from the fuel database
-- Hit the service for each postcode (delay between each call)
-- Parse the XML and update each result to the DB
- Update the count

<c:set var="fuel" value="2,3" />
<c:set var="fuel" value="2,3,4,5,6,7,8,9" />
 --%>


<c:set var="url" value="https://partners.motormouth.com.au/Service.svc/PostcodeSearchAllPricesXml" />
<c:set var="fuel" value="2,3,4,5,6,7,8,9" />
<c:set var="errorPool" value='' />
<c:set var="errorSoftPool" value='' />
<c:set var="sqlCount">0</c:set>
<c:set var="fuelString" />


<sql:setDataSource dataSource="jdbc/ctm"/>



<%--
======================
MAIN CALL
----------------------
--%>

<%-- Get all the unique postcodes from the database  --%>	
<c:catch var="error">
	 <sql:query var="result">
		SELECT PostCode FROM aggregator.fuel_sites
		UNION SELECT PostCode FROM aggregator.fuel_postcodes WHERE `Type` = 'N'
		UNION SELECT PostCode FROM aggregator.suburb_search WHERE PostCode NOT in( SELECT  PostCode FROM aggregator.fuel_postcodes WHERE `Type` = 'R')
		ORDER BY PostCode;
	 </sql:query>
</c:catch>


<%-- Basic check for SQL call  --%>
<c:choose>
	<c:when test="${not empty error}">
		<c:set var="errorPool" value="${errorPool} <error s='select'>${error.rootCause}</error>" />
	</c:when>
	<c:when test="${empty result}">
		<c:set var="errorPool" value="${errorPool} <error s='select'>No selects possible</error>" />
	</c:when>
	<c:when test="${result.rowCount < 1}">
		<c:set var="errorPool" value="${errorPool} <error s='select'>No selects found</error>" />
	</c:when>
	<c:otherwise>
	
		<%-- Each PostCode: Import the data for the fuel types, make a large XML string and parse that --%>	
		<c:forEach var="row" items="${result.rows}" varStatus='idx'>
			<c:set var="postcode">${row.postcode}</c:set>
			<c:set var="inboundString" value='' />
						
				<c:set var="lastUrl">u = ${url}, p = ${postcode}, t = ${fuel}</c:set>
						
				<%-- IMPORT THE SERVICE CALL --%>
				<c:catch var="error">
					<c:import var="inbound" url="${url}">
						<c:param name="fuelTypes" value="${fuel}" />
						<c:param name="postcode" value="${postcode}" />
					</c:import>
					<c:set var="inboundString">${inboundString}${inbound}</c:set>
				</c:catch>			
				
				<%-- Normalise the XML fragments --%>
				<c:set var="inboundString"><data>${inboundString}</data></c:set>
				<x:parse xml="${inboundString}" var="data" />			
				
				<c:choose>
					<c:when test="${not empty error}">
						<c:set var="errorPool" value="${errorPool} <error x='import and parse'>${error.rootCause}</error>" />
					</c:when>
					<c:otherwise>
						<%-- Run the SQL update based on the results, capture any errors --%>
						<c:catch var="error">
						
							<x:if select="$data//ResultCode[.='0']">
							
								<%-- Build the postcode list, remove duplicate numbers and matches for the postcode itself + format the postcodes properly --%>
								<c:set var="postcodeList"><x:forEach select="$data//Postcode[not(.=following::Postcode)]" var="x" varStatus="loop"><x:if select="$x != $pageScope:postcode"><fmt:formatNumber pattern="0000"><x:out select="$x" /></fmt:formatNumber>,</x:if></x:forEach></c:set>
								<c:set var="postcodeList">${fn:substring(postcodeList, 0, fn:length(postcodeList)-1 )}</c:set>
								
								<%-- Print this line to your server to check it over --%>
								${logger.info('About to insert into postcode_relations. {},{}', log:kv("sqlCount" , sqlCount), log:kv("postcode", postcode), log:kv("postcodeList", postcodeList))}
								<% Thread.sleep(1000); %>
								
								<%-- SQL Update - if duplicate, only update the results --%>		
								<sql:update var="result">
									INSERT INTO aggregator.postcode_relations
								  	(PostcodeId, PostcodeList) VALUES (?,?)
								  	ON DUPLICATE KEY UPDATE PostcodeList = ?;	  	
								  	<sql:param>${postcode}</sql:param>
								  	<sql:param value="${postcodeList}" />
								  	<sql:param value="${postcodeList}" />
								</sql:update>
							
							</x:if>						
							
						</c:catch>
						
						<c:choose>
							<c:when test="${not empty error}">
								<c:set var="errorPool" value="${errorPool} <error s='insert'>${error.rootCause}</error>" />
							</c:when>
							<c:otherwise>
								<c:set var="sqlCount" value="${sqlCount +1}" />
							</c:otherwise>
						</c:choose>
						
					</c:otherwise>			
							
				</c:choose>
	
		</c:forEach>
	
	</c:otherwise>
</c:choose>



<%-- XML RESPONSE --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
	<inserted>${sqlCount}</inserted>
	<c:if test="${not empty errorPool}">
		<errors>${errorPool}</errors>
	</c:if>
	<c:if test="${not empty errorSoftPool}">
		<errors type="soft">${errorSoftPool}</errors>
	</c:if>
</data>
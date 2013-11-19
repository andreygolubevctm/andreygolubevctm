<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm" />

<go:log>TransID = ${param.ConfirmationID}</go:log>

<go:log>Load confirmation and Call Centre = ${callCentre}</go:log>

<%-- SQL call, make a different one to easily find a confirmation for Call Centre users --%>
<c:choose>
	<c:when test="${not empty callCentre}">
		<sql:query var="result">
			SELECT *
			FROM `confirmations`
			WHERE KeyID = ? OR TransID = ?
			LIMIT 1
			<sql:param value="${param.ConfirmationID}" />
			<sql:param value="${param.ConfirmationID}" />
		</sql:query>
	</c:when>
	<c:otherwise>
		<sql:query var="result">
			SELECT *
			FROM `confirmations`
			WHERE KeyID = ?
			LIMIT 1
			<sql:param value="${param.ConfirmationID}" />
		</sql:query>
	</c:otherwise>
</c:choose>


<%-- Validate the items for the vertical --%>
<c:set var="errors" value="" />
<c:choose>
	<c:when test="${empty result}">
		<c:set var="errors" value="No confirmation can be loaded" />
	</c:when>
	<c:when test="${result.rows[0]['Vertical'] != 'CTMH'}">
		<c:set var="errors" value="Confirmation is invalid and can not be loaded" />
	</c:when>
	<%-- //FIX: Add in a value to bust the time, i.e. it's way too old!!!!
	<c:when test="${not callCentre && time < returnTime}">
		<c:set var="errors" value="Confirmation page has expired" />
	</c:when>
	 --%>
</c:choose>

<go:log>Errors = ${errors}</go:log>

<c:choose>
	<c:when test="${not empty errors}">
		<c:set var="xmlData">
			<?xml version="1.0" encoding="UTF-8"?>
			<data>
				<status>Error</status>
				<message>${errors}</message>
			</data>
		</c:set>
	</c:when>
	<c:when test="${result.rows[0]['XMLdata'] == ''}">
		<c:set var="xmlData">
			<?xml version="1.0" encoding="UTF-8"?>
			<data>
				<status>Error</status>
				<message>No Data Found</message>
			</data>
		</c:set>
	</c:when>	
	<c:otherwise>
		<c:set var="xmlData">${result.rows[0]['XMLdata']}</c:set>
	</c:otherwise>
</c:choose>

${go:XMLtoJSON(xmlData)}
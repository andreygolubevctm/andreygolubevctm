<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:query var="result">
	SELECT DISTINCT fuel
	    FROM aggregator.vehicles
		WHERE year= ?
		AND   make= ?
		AND   model= ?
		AND   body= ?
		AND   trans= ?
		<sql:param>${param.car_year}</sql:param>
		<sql:param>${param.car_manufacturer}</sql:param>
		<sql:param>${param.car_model}</sql:param>
		<sql:param>${param.car_body}</sql:param>
		<sql:param>${param.car_transmition}</sql:param>
</sql:query>


<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
	<fuel value="">Please choose...</fuel>
	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">
		<c:choose>
			<c:when test="${row.fuel=='P'}">
				<fuel value="P">Petrol</fuel>
			</c:when>
			<c:when test="${row.fuel=='D'}">
				<fuel value="D">Diesel</fuel>
			</c:when>
			<c:when test="${row.fuel=='G'}">
				<fuel value="G">Gas</fuel>
			</c:when>
		</c:choose>
	</c:forEach>
</data>

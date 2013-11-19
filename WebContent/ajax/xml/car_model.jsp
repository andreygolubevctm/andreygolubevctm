<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>


<sql:query var="result">
	SELECT distinct(vehicle_models.model), vehicle_models.des 
	FROM vehicle_models 
	JOIN vehicles ON vehicles.model = vehicle_models.model 
	      AND vehicles.make = vehicle_models.make
	WHERE vehicles.year = ? and
		vehicles.make = ?
		  
	ORDER BY vehicle_models.des   	
	<sql:param>${param.car_year}</sql:param>
	<sql:param>${param.car_manufacturer}</sql:param>
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">
		<model modelCode="${row.model}">${row.des}</model>
	</c:forEach>
</data>	

<%--
<c:choose>
	<c:when test="${param.car_transmition=='M'}">
		<c:set var="trans" value="'M','S','D'"></c:set>
	</c:when>
	<c:when test="${param.car_transmition=='A'}">
		<c:set var="trans" value="'A','S'"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="trans" value="'S'"></c:set>
	</c:otherwise>
</c:choose>

<sql:query var="result">
	SELECT distinct(vehicle_models.model), vehicle_models.des 
	FROM vehicle_models 
	JOIN vehicles ON vehicles.model = vehicle_models.model 
	WHERE vehicles.year = "${param.car_year}" and
		  vehicles.make = "${param.car_manufacturer}" and
		  vehicles.fuel = "${param.car_fuel}" and
		  vehicles.trans in (${trans})
		  
	ORDER BY vehicle_models.des   	
</sql:query>
--%>
<%-- XML --%>
<%--
<?xml version="1.0" encoding="UTF-8"?>
<data>
	<c:forEach var="row" items="${result.rows}">
		<model modelCode="${row.model}">${row.des}</model>
	</c:forEach>
</data>	
--%>

<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm"/>


<sql:query var="result">
	SELECT DISTINCT(vehicle_models.model), vehicle_models.des
	    FROM aggregator.vehicle_models
            JOIN aggregator.vehicles ON vehicles.model = vehicle_models.model
	      AND vehicles.make = vehicle_models.make
	    WHERE vehicles.year = ?
		    AND vehicles.make = ?
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

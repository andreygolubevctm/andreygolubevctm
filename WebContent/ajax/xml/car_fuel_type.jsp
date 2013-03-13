<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	SELECT DISTINCT fuel FROM vehicles 
		WHERE year='${param.car_year}' 
		AND   make='${param.car_manufacturer}' 
		AND   model='${param.car_model}' 
		AND   body='${param.car_body}'
		AND   trans='${param.car_transmition}'
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

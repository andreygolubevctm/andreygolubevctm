<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	SELECT DISTINCT trans FROM vehicles 
		WHERE year='${param.car_year}' 
		AND   make='${param.car_manufacturer}' 
		AND   model='${param.car_model}'
		AND   body ='${param.car_body}'
</sql:query>


<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
	<trans value="">Please choose...</trans>
	<c:forEach var="row" items="${result.rows}">
		<c:choose>
			<c:when test="${row.trans=='M'}">
				<trans value="M">Manual</trans>
			</c:when>
			<c:when test="${row.trans=='A'}">
				<trans value="A">Automatic</trans>
			</c:when>
			<c:when test="${row.trans=='S'}">
				<trans value="S">Semi-Automatic</trans>
			</c:when>
		</c:choose>
	</c:forEach>
</data>	

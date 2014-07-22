<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:query var="result">
	SELECT DISTINCT trans
		FROM aggregator.vehicles
		WHERE year= ?
		AND   make= ?
		AND   model= ?
		AND   body = ?
		<sql:param value="${param.car_year}"/>
		<sql:param value="${param.car_manufacturer}"/>
		<sql:param value="${param.car_model}"/>
		<sql:param value="${param.car_body}"/>
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
			<c:when test="${row.trans=='R'}">
				<trans value="R">Reduction Gear</trans>
			</c:when>
		</c:choose>
	</c:forEach>
</data>	

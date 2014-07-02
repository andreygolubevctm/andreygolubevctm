<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<sql:query var="fuel_query">
	SELECT DISTINCT fuel FROM vehicles
		WHERE make= ?
		AND   model= ?
		AND   year= ?
		AND   body= ?
		AND   trans= ?
		union
		SELECT DISTINCT fuel FROM vehicles_nextyear
		WHERE make= ?
		AND   model= ?
		AND   year= ?
		AND   body= ?
		AND   trans= ?
		<sql:param value="${param.car_make}"/>
		<sql:param value="${param.car_model}"/>
		<sql:param value="${param.car_year}"/>
		<sql:param value="${param.car_body}"/>
		<sql:param value="${param.car_trans}"/>
		<sql:param value="${param.car_make}"/>
		<sql:param value="${param.car_model}"/>
		<sql:param value="${param.car_year}"/>
		<sql:param value="${param.car_body}"/>
		<sql:param value="${param.car_trans}"/>
</sql:query>

<%-- JSON --%>
<json:object>
	<json:array name="car_fuel" var="item" items="${fuel_query.rows}">
		<c:choose>
			<c:when test="${item.fuel=='P'}">
				<json:object>
					<json:property name="value" value="${item.fuel}"/>
					<json:property name="label" value="Petrol"/>
				</json:object>
			</c:when>
			<c:when test="${item.fuel=='D'}">
				<json:object>
					<json:property name="value" value="${item.fuel}"/>
					<json:property name="label" value="Diesel"/>
				</json:object>
			</c:when>
			<c:when test="${item.fuel=='G'}">
				<json:object>
					<json:property name="value" value="${item.fuel}"/>
					<json:property name="label" value="Gas"/>
				</json:object>
			</c:when>
			<c:when test="${item.fuel=='E'}">
				<json:object>
					<json:property name="value" value="${item.fuel}"/>
					<json:property name="label" value="Electric"/>
				</json:object>
			</c:when>
		</c:choose>
	</json:array>
</json:object>

<%-- JSON Result Example for car_body:4SED, car_model:380, car_make:MITS, car_year:2007 --%>
<%--
{"car_fuel": [{
	"value": "P",
	"label": "Petrol"
}]}
--%>
<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<sql:query var="body_query">
	SELECT distinct(vehicle_body.code), vehicle_body.des
	FROM vehicle_body
	JOIN vehicles ON vehicle_body.code = vehicles.body
	WHERE vehicles.make = ?
		AND vehicles.model = ?
		AND vehicles.year = ?
	union
	SELECT distinct(vehicle_body.code), vehicle_body.des
	FROM vehicle_body
	JOIN vehicles_nextyear ON vehicle_body.code = vehicles_nextyear.body
	WHERE vehicles_nextyear.make = ?
		AND vehicles_nextyear.model = ?
		AND vehicles_nextyear.year = ?

	<sql:param>${param.car_make}</sql:param>
	<sql:param>${param.car_model}</sql:param>
	<sql:param>${param.car_year}</sql:param>
	<sql:param>${param.car_make}</sql:param>
	<sql:param>${param.car_model}</sql:param>
	<sql:param>${param.car_year}</sql:param>

</sql:query>

<%-- JSON --%>
<json:object>
	<json:array name="car_body" var="item" items="${body_query.rows}">
		<json:object>
			<json:property name="value" value="${item.code}"/>
			<json:property name="label" value="${item.des}"/>
		</json:object>
	</json:array>
</json:object>

<%-- JSON Result Example for car_model:380, car_make:MITS , car_year:2007 --%>
<%--
{"car_body": [{
"value": "4SED",
"label": "4dr Sedan"
}]}
--%>
<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<sql:query var="year_query">
	SELECT distinct(vehicles.year)
	FROM vehicles
	WHERE make = ?
	AND model = ?
	ORDER BY vehicles.year DESC
	<sql:param>${param.car_make}</sql:param>
	<sql:param>${param.car_model}</sql:param>
</sql:query>

<%-- JSON --%>
<json:object>
	<json:array name="car_year" var="item" items="${year_query.rows}">
		<json:object>
			<json:property name="value" value="${item.year}"/>
			<json:property name="label" value="${item.year}"/><%-- Seems silly, but yes --%>
		</json:object>
	</json:array>
</json:object>

<%-- JSON Result Example for car_make:MITS , car_model:380 --%>
<%--
{"car_years": [
	{
		"value": "2005",
		"label": "2005"
	},
	{
		"value": "2006",
		"label": "2006"
	},
	{
		"value": "2007",
		"label": "2007"
	},
	{
		"value": "2008",
		"label": "2008"
	}
]}
--%>
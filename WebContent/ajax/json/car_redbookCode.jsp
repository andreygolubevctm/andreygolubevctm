<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<c:choose>
	<c:when test="${param.car_trans=='M'}">
		<c:set var="trans" value="'M','S','D'"></c:set>
	</c:when>
	<c:when test="${param.car_trans=='A'}">
		<c:set var="trans" value="'A','S'"></c:set>
	</c:when>
	<c:when test="${param.car_trans=='R'}">
		<c:set var="trans" value="'R'"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="trans" value="'S'"></c:set>
	</c:otherwise>
</c:choose>

<sql:query var="redbookCode_query">
	SELECT redbookCode, des, value
	FROM vehicles
	WHERE make = ?
		and	model = ?
		and year = ?
		and body = ?
		and trans in (${trans})
		and fuel = ?
	ORDER BY des
	<sql:param value="${param.car_make}"/>
	<sql:param value="${param.car_model}"/>
	<sql:param value="${param.car_year}"/>
	<sql:param value="${param.car_body}"/>
	<sql:param value="${param.car_fuel}"/>
</sql:query>

<go:log>${redbookCode_query.rows}</go:log>

<%-- JSON --%>
<json:object>
	<json:array name="car_redbookCode" var="item" items="${redbookCode_query.rows}">
		<json:object>
			<json:property name="value" value="${item.redbookCode}"/>
			<json:property name="rel" value="${item.value}"/>
			<json:property name="label" value="${item.des}"/>
		</json:object>
	</json:array>
</json:object>

<%-- JSON Result Example for car_fuel:P, car_trans:S, car_body:4SED, car_model:380, car_make:MITS, car_year:2007 --%>
<%--
{"car_redbookCode": [
	{
		"value": "HOLD08GV",
		"rel": 17500,
		"label": "Commodore 60th Anniversary 4dr Sedan  3.6mpi"
	},
	{
		"value": "HOLD08KX",
		"rel": 17250,
		"label": "Commodore 60th Anniversary 4dr Sedan  3.6mpi VE (Rel. March) 1622Kgs 175Kw"
	},
	{
		"value": "HOLD08KT",
		"rel": 16300,
		"label": "Commodore 60th Anniversary 4dr Sedan  3.6mpi VE (Rel. March) 1690Kgs 175Kw"
	},
	{
		"value": "HOLD08GU",
		"rel": 16650,
		"label": "Commodore 60th Anniversary 4dr Sedan  3.6mpi VE (Rel. March) 1690Kgs 180Kw"
	},
	{
		"value": "HOLD08LU",
		"rel": 16650,
		"label": "Commodore International 4dr Sedan  3.6mpi"
	},
	{
		"value": "HOLD08LT",
		"rel": 17550,
		"label": "Commodore Lumina 4dr Sedan  3.6mpi"
	},
	{
		"value": "HOLD08LS",
		"rel": 15700,
		"label": "Commodore Lumina 4dr Sedan  3.6mpi VE 1690Kgs 180Kw"
	},
	{
		"value": "HOLD08CL",
		"rel": 14500,
		"label": "Commodore Omega 4dr Sedan  3.6mpi"
	},
	{
		"value": "HOLD08KS",
		"rel": 15000,
		"label": "Commodore Omega 4dr Sedan  3.6mpi VE (Rel. March) 1690Kgs 175Kw"
	},
	{
		"value": "HOLD08GK",
		"rel": 15250,
		"label": "Commodore Omega 4dr Sedan  3.6mpi VE (Rel. March) 1690Kgs 180Kw"
	},
	{
		"value": "HOLD08KW",
		"rel": 16350,
		"label": "Commodore Omega 4dr Sedan  3.6mpi VE (Rel. March) 175Kw"
	},
	{
		"value": "HOLD08GL",
		"rel": 16700,
		"label": "Commodore Omega 4dr Sedan  3.6mpi VE (Rel. March) 180Kw"
	},
	{
		"value": "HOLD08CD",
		"rel": 12750,
		"label": "Commodore Omega 4dr Sedan  3.6mpi VE 1690Kgs 180Kw"
	},
	{
		"value": "HOLD08CP",
		"rel": 23800,
		"label": "Commodore Ss 4dr Sedan  6.0mpi  Semi-Auto"
	},
	{
		"value": "HOLD08GR",
		"rel": 26000,
		"label": "Commodore Ss 4dr Sedan  6.0mpi VE (Rel. March) 1785Kgs 270Kw Semi-Auto"
	},
	{
		"value": "HOLD08CR",
		"rel": 27400,
		"label": "Commodore Ss V 4dr Sedan  6.0mpi  Semi-Auto"
	},
	{
		"value": "HOLD08GT",
		"rel": 29650,
		"label": "Commodore Ss V 4dr Sedan  6.0mpi VE (Rel. March) 1805Kgs 270Kw Semi-Auto"
	},
	{
		"value": "HOLD08GX",
		"rel": 30550,
		"label": "Commodore Ss V 60th Anniversary 4dr Sedan  6.0mpi  Semi-Auto"
	},
	{
		"value": "HOLD08CN",
		"rel": 20000,
		"label": "Commodore Sv6 4dr Sedan  3.6mpi  Semi-Auto"
	},
	{
		"value": "HOLD08GP",
		"rel": 21350,
		"label": "Commodore Sv6 4dr Sedan  3.6mpi VE (Rel. March) 1735Kgs 195Kw Semi-Auto"
	}
]}
--%>
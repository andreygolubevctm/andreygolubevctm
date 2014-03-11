<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<sql:query var="trans_query">
	SELECT DISTINCT trans FROM vehicles
		WHERE make= ?
		AND   model= ?
		AND   year= ?
		AND   body = ?
		union
	SELECT DISTINCT trans FROM vehicles_nextyear
		WHERE make= ?
		AND   model= ?
		AND   year= ?
		AND   body = ?

		<sql:param value="${param.car_make}"/>
		<sql:param value="${param.car_model}"/>
		<sql:param value="${param.car_year}"/>
		<sql:param value="${param.car_body}"/>
		<sql:param value="${param.car_make}"/>
		<sql:param value="${param.car_model}"/>
		<sql:param value="${param.car_year}"/>
		<sql:param value="${param.car_body}"/>
</sql:query>

<%-- JSON --%>
<json:object>
	<json:array name="car_trans" var="item" items="${trans_query.rows}">
		<c:choose>
			<c:when test="${item.trans=='M'}">
				<json:object>
					<json:property name="value" value="${item.trans}"/>
					<json:property name="label" value="Manual"/>
				</json:object>
			</c:when>
			<c:when test="${item.trans=='A'}">
				<json:object>
					<json:property name="value" value="${item.trans}"/>
					<json:property name="label" value="Automatic"/>
				</json:object>
			</c:when>
			<c:when test="${item.trans=='S'}">
				<json:object>
					<json:property name="value" value="${item.trans}"/>
					<json:property name="label" value="Semi-Automatic"/>
				</json:object>
			</c:when>
			<c:when test="${item.trans=='R'}">
				<json:object>
					<json:property name="value" value="${item.trans}"/>
					<json:property name="label" value="Reduction Gear"/>
				</json:object>
			</c:when>
		</c:choose>
	</json:array>
</json:object>

<%-- JSON Result Example for car_body:4SED, car_model:380, car_make:MITS, car_year:2007 --%>
<%--
{"car_trans": [
	{
		"value": "M",
		"label": "Manual"
	},
	{
		"value": "S",
		"label": "Semi-Automatic"
	}
]}
--%>
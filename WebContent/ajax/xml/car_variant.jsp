<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>
<c:choose>
	<c:when test="${param.car_transmition=='M'}">
		<c:set var="trans" value="'M','S','D'"></c:set>
	</c:when>
	<c:when test="${param.car_transmition=='A'}">
		<c:set var="trans" value="'A','S'"></c:set>
	</c:when>
	<c:when test="${param.car_transmition=='R'}">
		<c:set var="trans" value="'R'"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="trans" value="'S'"></c:set>
	</c:otherwise>
</c:choose>

<sql:query var="result">

	SELECT redbookCode, des, value 
	FROM vehicles 
	WHERE year = ? 
		and make = ? 
		and fuel = ?
		and body = ? 
		and trans in (${trans}) 
		and	model = ? 
	                                            ORDER BY des
	<sql:param>${param.car_year}</sql:param>     
	<sql:param>${param.car_manufacturer}</sql:param>   
	<sql:param>${param.car_fuel}</sql:param>   
	<sql:param>${param.car_body}</sql:param>   
	<sql:param>${param.car_model}</sql:param>          
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">
		<car redbookCode="${row.redbookCode}" mktVal="${row.value}">${row.des}</car>
	</c:forEach>
	
</data>	


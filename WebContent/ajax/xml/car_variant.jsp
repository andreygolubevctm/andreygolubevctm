<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>
<c:choose>
	<c:when test="${param.car_transmition=='M'}">
		<c:set var="trans" value="'M','S','D'"></c:set>
	</c:when>
	<c:when test="${param.car_transmition=='A'}">
		<c:set var="trans" value="'A','S'"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="trans" value="'S'"></c:set>
	</c:otherwise>
</c:choose>

<sql:query var="result">

	SELECT redbookCode, des, value FROM vehicles WHERE year = "${param.car_year}" and
	                                            make = "${param.car_manufacturer}" and
	                                            fuel = "${param.car_fuel}" and
	                                            body = "${param.car_body}" and
	                                            trans in (${trans}) and	                                             
	                                            model = "${param.car_model}" 
	                                            ORDER BY des
	                                            
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">
		<car redbookCode="${row.redbookCode}" mktVal="${row.value}">${row.des}</car>
	</c:forEach>
	
</data>	


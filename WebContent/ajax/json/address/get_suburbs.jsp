<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator" />

<c:set var="location">${fn:trim(param.term)}</c:set>
<c:set var="callback">${fn:trim(param.callback)}</c:set>
<c:set var="fields">${fn:trim(param.fields)}</c:set>
<c:set var="callback_start"></c:set>
<c:set var="callback_end"></c:set>
<c:if test="${not empty callback}">
	<c:set var="callback_start">get_suburbs_callback(</c:set>
	<c:set var="callback_end">)</c:set>
</c:if>
<%-- Get the best instance of the Suburb --%>
<c:choose>
	<c:when test="${empty location}">
		<c:set var="result" value="" />
	</c:when>
	
	<c:otherwise>
		
		<%-- Crazy Way to test for a number --%>
		<c:catch var="number">
			<c:set var="temp"><fmt:formatNumber value="${location}" type="number" /></c:set>
		</c:catch>
		
		<%-- Grab the SQL for the result --%>
		<c:choose>
			<c:when test="${empty number and empty fields}">
				<sql:query var="result">
					SELECT postcode, state FROM `aggregator`.`suburb_search` WHERE postCode LIKE(?) GROUP BY postCode ORDER BY postCode LIMIT 8;
					<sql:param value="${location}%" />
				</sql:query>		
			</c:when>
			<c:otherwise>
				<c:if test="${empty fields}">
					<c:set var="fields" value="*" />
				</c:if>
				<sql:query var="result">
					SELECT ${fields} FROM `aggregator`.`suburb_search` WHERE suburb LIKE(?) OR postCode LIKE(?) ORDER BY suburb LIMIT 8;
					<sql:param value="${location}%" />
					<sql:param value="${location}%" />
				</sql:query>	
			</c:otherwise>
		</c:choose>
		
	</c:otherwise>	

</c:choose>

<c:catch>
	<%-- Export the results, even an empty JSON --%>
	<c:choose>
		<c:when test="${(empty result) || (result.rowCount == 0) }">[{"label":"We can't find a match. Please check your postcode/suburb","value":""}]</c:when>
		<%-- Build the JSON data for each row --%>
		<c:otherwise>${callback_start}[ <c:forEach var="row" varStatus="status" items="${result.rows}">"<c:out value='${row.suburb} ${row.postCode} ${row.state}' />"<c:if test="${!status.last}">, </c:if></c:forEach> ]${callback_end}</c:otherwise>
	</c:choose>
</c:catch>
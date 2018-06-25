<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}" />

<c:set var="location">${fn:trim(param.term)}</c:set>
<c:set var="callback">${fn:trim(param.callback)}</c:set>
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
		<c:catch var="error">
			<c:set var="number"><fmt:parseNumber value="${location}" type="number" integerOnly="true" /></c:set>
		</c:catch>
		<c:choose>
			<c:when test="${empty number}">
				<sql:query var="result">
					SELECT postcode, suburb, state FROM `aggregator`.`suburb_search`
					WHERE suburb LIKE ?
					ORDER BY suburb
					LIMIT 20;
					<sql:param value="${location}%" />
				</sql:query>
			</c:when>
			<c:when test="${fn:length(location) != 4}">
				<sql:query var="result">
					SELECT postcode, suburb, state FROM `aggregator`.`suburb_search`
					WHERE postCode LIKE ?
					ORDER BY postCode , suburb
					LIMIT 20;
					<sql:param value="${location}%" />
				</sql:query>
			</c:when>
			<c:otherwise>
				<sql:query var="result">
					SELECT postcode, suburb, state FROM `aggregator`.`suburb_search`
					WHERE postCode  = ?
					ORDER BY suburb
					<sql:param value="${location}" />
				</sql:query>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
<c:catch var="error">
	<%-- Export the results, even an empty JSON --%>
	<c:choose>
		<c:when test="${(empty result) || (result.rowCount == 0) }">[<%-- {"label":"We can't find a match. Please check your postcode/suburb","value":""} --%>]</c:when>
		<%-- Build the JSON data for each row --%>
		<c:otherwise>${callback_start}[ <c:forEach var="row" varStatus="status" items="${result.rows}">"<c:out value='${row.suburb} ${row.postCode} ${row.state}' escapeXml="false" />"<c:if test="${!status.last}">, </c:if></c:forEach> ]${callback_end}</c:otherwise>
	</c:choose>
</c:catch>
<c:if test="${error}">
	${logger.warn('Error returning suburb results. {}', log:kv('result',result), error)}
</c:if>
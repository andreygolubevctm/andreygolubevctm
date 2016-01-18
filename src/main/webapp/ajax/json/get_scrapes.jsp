<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC"/>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<sql:setDataSource dataSource="${datasource:getDataSource()}" />

<c:set var="type">${fn:trim(param.type)}</c:set>
<c:set var="code">${fn:trim(param.code)}</c:set>
<c:set var="group">${fn:trim(param.group)}</c:set>


<%-- <c:set var="type">carBrandScrapes</c:set>
<c:set var="code">BUDD-05-04</c:set>
<c:set var="group">car</c:set> --%>

<%-- SQL CALL --%>
<sql:query var="result">
	SELECT `description`
	FROM  aggregator.general
	WHERE `type` = ?
	AND `code` = ?
	<sql:param value="${type}" />
	<sql:param value="${code}" />
</sql:query>

<c:choose>
	<c:when test="${(empty result) || (result.rowCount == 0) }">
		{"count":0}
	</c:when>
	<c:otherwise>
		<c:set var="scrapeIds" value="${ fn:split(result.getRowsByIndex()[0][0], ',') }" />

		<c:set var="scrapeIdsList">
			<c:forEach var="id" varStatus="status" items="${scrapeIds}">${id}<c:if test="${!status.last}">, </c:if></c:forEach>
		</c:set>

		<sql:query var="result">
			SELECT *
			FROM `ctm`.`scrapes`
			WHERE `group` = ?
			AND (styleCodeId = ? OR stylecodeid = 0)
			AND `id` IN (
				<c:forEach var="id" varStatus="status" items="${scrapeIds}">
					?<c:if test="${!status.last}">,</c:if>
				</c:forEach>
			)
			ORDER BY `id`, styleCodeId DESC
			<sql:param value="${group}" />
			<sql:param value="${styleCodeId}" />
			<c:forEach var="id" varStatus="status" items="${scrapeIds}">
				<sql:param value="${id}" />
			</c:forEach>
		</sql:query>

		<c:choose>
			<c:when test="${(empty result) || (result.rowCount == 0) }">
				{"count":0}
			</c:when>
			<c:otherwise>
				{
					"count":"${result.rowCount}",
					"scrapes":[
						<c:forEach var="row" varStatus="status" items="${result.rows}">{"cssSelector":"${row.cssSelector}","html":"${go:replaceAll(row.html, '"', '\\\\"')}"}<c:if test="${!status.last}">, </c:if></c:forEach>
					]
				}
			</c:otherwise>
		</c:choose>

	</c:otherwise>
</c:choose>
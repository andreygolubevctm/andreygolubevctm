<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<sql:query var="result">
	SELECT houseNo, count(*) as unitCount, max(dpId) as dpId, min(unitNo) as minUnitNo
	FROM aggregator.street_number
	WHERE streetId = ?
	AND houseNo like ?
	GROUP BY houseNo
	ORDER BY 1 LIMIT 20
	<sql:param value="${param.streetId}" />
	<sql:param value="${param.search}%" />
</sql:query>

<json:array>
	<c:set var="searchLen" value="${fn:length(param.search)}" />
	<c:forEach var="row" items="${result.rows}" varStatus="status">

		<c:set var="i" value="${status.count-1}" />

		<json:object>
			<json:property name="dpId" value="${row.dpId}" />
			<json:property name="unitCount" value="${row.unitCount}" />
			<json:property name="minUnitNo" value="${row.minUnitNo}" />
			<json:property name="value" value="${row.houseNo}" />
			<json:property name="highlight" value="<b>${fn:substring(row.houseNo,0,searchLen)}</b>${fn:substring(row.houseNo,searchLen, 50)}" escapeXml="false" />
		</json:object>

		<%--
		<div val="${row.houseNo}"
			key="${row.houseNo}:${row.unitCount}:${row.dpId}"
			onmousedown="ajaxdrop_click('${param.fieldId}',${i});return false;"
			class="ajaxdrop"
			onmouseover="ajaxdrop_highlight('${param.fieldId}',${i});"
			idx="${i}">
			<b>${fn:substring(row.houseNo,0,searchLen)}</b>${fn:substring(row.houseNo,searchLen, 50)}
		</div>
		--%>
	</c:forEach>
</json:array>
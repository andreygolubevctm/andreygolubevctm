<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    
<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<sql:query var="result">
	SELECT houseNo, count(*) as unitCount, max(dpId) as dpId
	FROM aggregator.street_number
	WHERE streetId = ?
	AND houseNo like ?
	GROUP BY houseNo
	ORDER BY 1 LIMIT 20
	<sql:param value="${param.streetId}" />
	<sql:param value="${param.search}%" />
</sql:query>

<c:set var="searchLen" value="${fn:length(param.search)}" />
<c:forEach var="row" items="${result.rows}" varStatus="status">
	
	<c:set var="i" value="${status.count-1}" />
	<div val="${row.houseNo}" 
		key="${row.houseNo}:${row.unitCount}:${row.dpId}"
		 onmousedown="ajaxdrop_click('${param.fieldId}',${i});return false;"
		 class="ajaxdrop"
		 onmouseover="ajaxdrop_highlight('${param.fieldId}',${i});"
		 idx="${i}">
		<b>${fn:substring(row.houseNo,0,searchLen)}</b>${fn:substring(row.houseNo,searchLen, 50)}
	</div>
</c:forEach>

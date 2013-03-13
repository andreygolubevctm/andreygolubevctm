<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    
<sql:setDataSource dataSource="jdbc/test"/>
<go:log>${param.streetId}</go:log>

<sql:query var="result">
	SELECT houseNo, count(*) as unitCount
	FROM street_number  
	WHERE streetId = ${param.streetId}
	AND houseNo like '${param.search}%'
	GROUP BY houseNo
	ORDER BY 1 LIMIT 20
</sql:query>

<c:set var="searchLen" value="${fn:length(param.search)}" />
<c:forEach var="row" items="${result.rows}" varStatus="status">
	
	<c:set var="i" value="${status.count-1}" />
	<div val="${row.houseNo}" 
		 key="${row.houseNo}:${row.unitCount}"
		 onmousedown="ajaxdrop_click('${param.fieldId}',${i});return false;"
		 class="ajaxdrop"
		 onmouseover="ajaxdrop_highlight('${param.fieldId}',${i});"
		 idx="${i}">
		<b>${fn:substring(row.houseNo,0,searchLen)}</b>${fn:substring(row.houseNo,searchLen, 50)}
	</div>
</c:forEach>

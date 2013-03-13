<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    
<sql:setDataSource dataSource="jdbc/test"/>

<c:set var="houseNumber" value="${param.houseNo}" />

<sql:query var="result">
	SELECT unitNo 
	FROM street_number 
 	WHERE streetId = ${param.streetId}
	AND houseNo = "${houseNumber}"
	AND unitNo like '${param.search}%'
	ORDER BY 1 LIMIT 20
</sql:query>

<c:set var="searchLen" value="${fn:length(param.search)}" />
<c:forEach var="row" items="${result.rows}" varStatus="status">
	<c:set var="i" value="${status.count-1}" />
	
	<div val="${row.unitNo}" 
		 key="${row.unitNo}"
		 onmousedown="ajaxdrop_click('${param.fieldId}',${i});return false;"
		 class="ajaxdrop"
		 onmouseover="ajaxdrop_highlight('${param.fieldId}',${i});"
		 idx="${i}">
		<b>${fn:substring(row.unitNo,0,searchLen)}</b>${fn:substring(row.unitNo,searchLen, 50)}
	</div>
</c:forEach>

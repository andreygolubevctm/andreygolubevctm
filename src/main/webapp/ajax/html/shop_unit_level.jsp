<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    
<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<c:set var="houseNumber" value="${param.houseNo}" />
<c:set var="unitType" value="${param.unitType}" />
<c:set var="search" value="${param.search}"/>

<c:if test="${empty houseNumber}" >
	<c:set var="houseNumber" value="0" />
</c:if>

<c:set var="unitTypes">CO=Cottage,DU=Duplex,FA=Factory,HO=House,KI=Kiosk,L=Level,M=Maisonette,MA=Marine Berth,OF=Office,</c:set>
<c:set var="unitTypes">${unitTypes}PE=Penthouse,RE=Rear,RO=Room,SH=Shop,ST=Stall,SI=Site,SU=Suite,TO=Townhouse,UN=Unit,VI=Villa,WA=Ward</c:set>

<c:if test="${fn:contains(search, ' ') }" >
<c:forTokens items="${unitTypes}" delims="," var="unitVal">
	<c:set var="val" value="${fn:substringBefore(unitVal,'=')}" />
	<c:set var="des" value="${fn:substringAfter(unitVal,'=')}" />
	<c:choose>
		<c:when test="${fn:contains(param.search, des)}" >
			<c:set var="unitType" value="${val}" />
			<c:set var="search" value="${fn:replace(search, des, '')}" />
		</c:when>
		<c:when test="${fn:contains(param.search, val) }" >
			<c:set var="unitType" value="${val}" />
			<c:set var="search" value="${fn:replace(search, val, '')}" />
		</c:when>
	</c:choose>
</c:forTokens>
</c:if>
<c:set var="search" value="${go:replaceAll(search, ' ', '' )}"/>

<sql:query var="result">
	SELECT unitNo, unitType, dpId
	FROM aggregator.street_number
	WHERE streetId = ?
	AND houseNo = ?
	AND unitNo like ?
	<c:if test="${param.residentalAddress}">
		AND unitType NOT IN ('KI','SH', 'OF', 'ST')
	</c:if>
	<c:if test="${not empty unitType}">
	AND unitType like ?
	</c:if>
	ORDER BY 1 LIMIT 20
	<sql:param value="${param.streetId}" />
	<sql:param value="${houseNumber}" />
	<sql:param value="${search}%" />
	<c:if test="${not empty unitType}">
		<sql:param value="${unitType}" />
	</c:if>
</sql:query>


<c:set var="searchLen" value="${fn:length(param.search)}" />
<c:forEach var="row" items="${result.rows}" varStatus="status">
	<c:forTokens items="${unitTypes}" delims="," var="option">
		<c:set var="val" value="${fn:substringBefore(option,'=')}" />
		<c:if test="${val == row.unitType}" >
			<c:set var="unitType" value="${fn:substringAfter(option,'=')}" />
		</c:if>
	</c:forTokens>
	<c:set var="i" value="${status.count-1}" />
	
	<div val="${row.unitNo}" 
		key="${row.unitNo}:${row.unitType}:${row.dpId}"
		 onmousedown="ajaxdrop_click('${param.fieldId}',${i});return false;"
		 class="ajaxdrop"
		 onmouseover="ajaxdrop_highlight('${param.fieldId}',${i});"
		 idx="${i}">
		${unitType}&nbsp;<b>${fn:substring(row.unitNo,0,searchLen)}</b>${fn:substring(row.unitNo,searchLen, 50)}


	</div>
</c:forEach>

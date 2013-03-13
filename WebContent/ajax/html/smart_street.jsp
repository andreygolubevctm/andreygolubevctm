<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%
	System.out.println(request.getQueryString());
%>
<sql:setDataSource dataSource="jdbc/test"/>

<c:choose>
	<c:when test="${fn:length(param.houseNo)==0 && fn:length(param.unitNo)==0}">
		<c:set var="qry">
			SELECT streetId, street, suburb, state, postcode, suburbSeq
			FROM streets streets   
        	WHERE street like '${param.street}%' AND postCode = '${param.postCode}'
		</c:set>
		<c:set var="showHouseUnit" value="${false}" />
	</c:when>	
	<c:otherwise>
		<c:set var="showHouseUnit" value="${true}" />
		<c:set var="qry">
    		SELECT streets.streetId, street, suburb, state, postcode, suburbSeq, unitNo
			FROM streets streets       	
			JOIN street_number street_number 
			ON street_number.streetId = streets.streetId
			WHERE street like '${param.street}%' AND postCode = '${param.postCode}'
		</c:set>
		
		<c:if test="${fn:length(param.houseNo) != 0}">
			<c:set var="qry" value="${qry} AND houseNo = '${param.houseNo}'" />
		</c:if> 
		
		<c:choose>
			<c:when test="${fn:length(param.unitNo) != 0}">
				<c:set var="qry" value="${qry} AND unitNo = '${param.prefix}${param.unit}${param.suffix}'" />				
			</c:when>
			<c:otherwise>
				<c:set var="qry" value="${qry} GROUP BY houseNo, streetId" />
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
<c:set var="qry" value="${qry} ORDER BY 1 LIMIT 15" />

<go:log>${qry}</go:log>

<sql:query var="result" sql="${qry}" />

<c:if test="${fn:length(result.rows)==0}">
	<sql:query var="result">
		SELECT streetId, street, suburb, state, postcode, suburbSeq
		FROM streets streets   
		WHERE street like '${param.street}%'
		AND postCode = '${param.postCode}'
	</sql:query>
</c:if>

<c:set var="searchLen" value="${fn:length(param.street)}" />
<c:set var="i" value="0" />
<c:forEach var="row" items="${result.rows}" varStatus="status">
	<c:set var="i" value="${status.count-1}" />
	
	<c:set var="key" value="${row.suburbSeq}:${row.suburb}:${row.state}:${row.streetId}" />
	
	<c:if test="${showHouseUnit}">
		<c:set var="key" value="${key}:${param.houseNo}:${param.prefix}${param.unitNo}${param.suffix}" />
		
		<c:choose>
			<c:when test="${fn:length(param.unitNo) > 0 && fn:length(param.houseNo) > 0}">
				<c:set var="houseNumber" value="${row.unitNo} / ${param.houseNo} " />
			</c:when>				
			<c:when test="${fn:length(param.houseNo) > 0}">
				<c:set var="houseNumber" value="${param.houseNo} " />
			</c:when>
			<c:otherwise>
				<c:set var="houseNumber" value="" />
			</c:otherwise>
		</c:choose>
	</c:if>
	
	<div val="${row.street}" 
		 key="${key}"
		 onmousedown="ajaxdrop_click('${param.fieldId}',${i});return false;"
		 onmouseover="ajaxdrop_highlight('${param.fieldId}',${i});"
		 class="ajaxdrop"
		 idx="${i}">
		 <c:if test="${fn:length(row.street) > 1 && fn:substring(row.street,0,2) != '*p'}">
		 	<b>${houseNumber}${fn:substring(row.street,0,searchLen)}</b>${fn:substring(row.street,searchLen,50)}, ${row.suburb}&nbsp;${row.state}&nbsp;${row.postcode}
		 </c:if>
	</div>
</c:forEach>
<c:if test="${param.showUnable!=''}">
	<c:set var="i" value="${i+1}" />
	<div val="*NOTFOUND" 
		 key="*NOTFOUND"
		 onmousedown="ajaxdrop_click('${param.fieldId}',${i});return false;"
		 onmouseover="ajaxdrop_highlight('${param.fieldId}',${i});"
		 class="ajaxdrop"
		 idx="${i}">
		<b>Can't find your address? <u>Click Here.</u>&nbsp;</b>
	</div>
</c:if>
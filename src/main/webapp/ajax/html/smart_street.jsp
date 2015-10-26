<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<%--Sanitise params before using select --%>
<c:set var="unitNo" value="${fn:toUpperCase(param.unitNo)}" />
<c:set var="unitNo" value="${go:replaceAll( unitNo, '[^A-Z0-9- ]', '' )}"/>
<c:set var="houseNo" value="${fn:toUpperCase(param.houseNo)}" />
<c:set var="houseNo" value="${go:replaceAll( houseNo, '[^A-Z0-9-]', '' )}"/>
<c:set var="fieldId"><c:out value="${param.fieldId}" escapeXml="true" /></c:set>
<c:set var="fieldId" value="${go:jsEscape(fn:trim(fieldId))}" />

<c:set var="unitTypes">CO=Cottage,DU=Duplex,FA=Factory,HO=House,KI=Kiosk,L=Level,M=Maisonette,MA=Marine Berth,OF=Office,</c:set>
<c:set var="unitTypes">${unitTypes}PE=Penthouse,RE=Rear,RO=Room,SH=Shop,ST=Stall,SI=Site,SU=Suite,TO=Townhouse,UN=Unit,VI=Villa,WA=Ward</c:set>

<c:if test="${fn:contains(unitNo, ' ') }" >
<c:forTokens items="${unitTypes}" delims="," var="unitVal">
	<c:set var="val" value="${fn:substringBefore(unitVal,'=')}" />
	<c:set var="des" value="${fn:substringAfter(unitVal,'=')}" />
<c:choose>
			<c:when test="${fn:contains(unitNo, val) }" >
			<c:set var="unitType" value="${val}" />
				<c:set var="unitNo" value="${fn:replace(unitNo, val, '')}" />
		</c:when>
			<c:when test="${fn:contains(unitNo, des)}" >
			<c:set var="unitType" value="${val}" />
				<c:set var="unitNo" value="${fn:replace(unitNo, des, '')}" />
		</c:when>
	</c:choose>
</c:forTokens>
</c:if>
<c:set var="unitNo" value="${go:replaceAll( unitNo, ' ', '' )}"/>

<c:set var="postCode" value="${go:replaceAll( param.postCode, '[^0-9]', '' )}"/>

<c:set var="showHouseNumber" value="${fn:length(houseNo) != 0}" />
<c:set var="showUnitNumber" value="${fn:length(unitNo) != 0}" />
<c:set var="street" value="${param.street}"/>

<c:choose>
	<c:when test="${showHouseNumber && showUnitNumber}">
		<c:set var="qry">
				SELECT DISTINCT streets.streetId, street, suburb, state, postcode, suburbSeq, unitType, unitNo, houseNo , dpId
				FROM aggregator.streets streets
				JOIN aggregator.street_number street_number
			ON street_number.streetId = streets.streetId
				WHERE postCode = '${postCode}'
					<c:if test="${fn:length(street) > 0}" >
						AND street like (?)
					</c:if>
					<c:if test="${param.residentalAddress}">
						AND unitType NOT IN ('KI','SH','FA')
					</c:if>
				AND houseNo = '${houseNo}'
					AND unitNo = '${unitNo}'
					<c:if test="${not empty unitType}">
						AND unitType = '${unitType}'
					</c:if>
			ORDER BY street LIMIT 15;
		</c:set>
		<c:set var="showHouseUnit" value="true" />
	</c:when>
	<c:when test="${showHouseNumber && !showUnitNumber}">
		<c:set var="qry">
				SELECT DISTINCT streets.streetId, street, suburb, state, postcode, suburbSeq, min(unitNo) , houseNo, dpId
				FROM aggregator.streets streets
				JOIN aggregator.street_number street_number
			ON street_number.streetId = streets.streetId
				WHERE postCode = '${postCode}'
					<c:if test="${fn:length(street) > 0}" >
						AND street like (?)
					</c:if>
				AND houseNo = '${houseNo}'
				GROUP BY streets.streetId, houseNo
			ORDER BY street LIMIT 15;
		</c:set>
		<c:set var="showHouseUnit" value="true" />
			</c:when>
		<c:when test="${fn:length(street) > 0}">
		<c:set var="showHouseUnit" value="false" />
		<c:set var="qry">
			SELECT DISTINCT streets.streetId, street, suburb, state, postcode, suburbSeq
				FROM aggregator.streets streets
			WHERE street like (?)
				AND postCode = '${postCode}'
			ORDER BY street LIMIT 15;
		</c:set>
		</c:when>
		</c:choose>

	<c:if test="${fn:length(qry) > 0}">
<sql:query var="result" sql="${qry}" >
			<c:if test="${fn:length(street) > 0}" >
		<sql:param value="${street}%" />
			</c:if>
</sql:query>
	</c:if>

	<c:if test="${(fn:length(qry) == 0 || fn:length(result.rows) == 0) && showUnitNumber && showHouseNumber}">
	<sql:query var="result">
			SELECT streets.streetId, street, suburb, state, postcode, suburbSeq, houseNo, min(dpId)
				FROM aggregator.streets streets
				JOIN aggregator.street_number street_number
			ON street_number.streetId = streets.streetId
			WHERE houseNo = '${houseNo}'
				<c:if test="${fn:length(street) > 0}" >
					AND street like (?)
				</c:if>
			AND postCode = '${postCode}'
				GROUP BY streets.streetId, street, suburb, state, postcode, suburbSeq, houseNo
			ORDER BY street LIMIT 15;
			<c:if test="${fn:length(street) > 0}" >
			<sql:param value="${street}%" />
			</c:if>
	</sql:query>
	<c:set var="showUnitNumber" value="false" />
</c:if>

	<c:if test="${fn:length(street) > 0 && fn:length(result.rows)==0 && showHouseNumber}">
	<sql:query var="result">
		SELECT DISTINCT streetId, street, suburb, state, postcode, suburbSeq
			FROM aggregator.streets streets
		WHERE street like (?)
		AND postCode = '${postCode}'
		ORDER BY street LIMIT 15;
			<sql:param value="${street}%" />
	</sql:query>
	<c:set var="showHouseNumber" value="false" />
</c:if>

	<c:set var="searchLen" value="${fn:length(street)}" />
<c:set var="i" value="${0}" />
<c:forEach var="row" items="${result.rows}" varStatus="status">

		<c:set var="key">&quot;suburbSeq&quot; : &quot;${row.suburbSeq}&quot;, &quot;suburb&quot; : &quot;${row.suburb}&quot;, &quot;state&quot; : &quot;${row.state}&quot; , &quot;streetId&quot; : &quot;${row.streetId}&quot; </c:set>

		<c:choose>
		<c:when test="${showUnitNumber && showHouseNumber && row.unitNo != '0' && not empty  row.unitNo && row.houseNo != '0' && not empty row.houseNo}">
				<c:forTokens items="${unitTypes}" delims="," var="option">
					<c:set var="val" value="${fn:substringBefore(option,'=')}" />
					<c:if test="${val == row.unitType}" >
						<c:set var="unitTypePretty" value="${fn:substringAfter(option,'=')}&nbsp;" />
					</c:if>
				</c:forTokens>
				<c:set var="houseNumber" value="${row.unitNo} / ${row.houseNo} " />
				<c:set var="houseNo">${row.houseNo}</c:set>
				<c:set var="unitNo">${param.prefix}${row.unitNo}${param.suffix}</c:set>
				<c:set var="unitType">${row.unitType}</c:set>
				<c:set var="dpId" value="${row.dpId} " />
			</c:when>
			<c:when test="${row.unitNo != '0' && not empty  row.unitNo && (row.houseNo == '0' || empty row.houseNo)}">
				<c:set var="houseNumber" value="${row.unitNo} " />
				<c:set var="houseNo">${row.houseNo}</c:set>
				<c:set var="unitNo">${param.prefix}${row.unitNo}${param.suffix}</c:set>

				<c:forTokens items="${unitTypes}" delims="," var="option">
					<c:set var="val" value="${fn:substringBefore(option,'=')}" />
					<c:if test="${val == row.unitType}" >
						<c:set var="unitTypePretty" value="${fn:substringAfter(option,'=')}&nbsp;" />
					</c:if>
				</c:forTokens>

				<c:set var="unitType">${row.unitType}</c:set>
				<c:set var="dpId" value="${row.dpId} " />
			</c:when>
		<c:when test="${showHouseNumber && row.houseNo != '0' && not empty row.houseNo}">
				<c:set var="houseNo">${row.houseNo}</c:set>
				<c:set var="houseNumber" value="${row.houseNo} " />
				<c:set var="unitNo"></c:set>
				<c:set var="unitType"></c:set>
				<c:set var="dpId" value="${row.dpId} " />
			</c:when>
			<c:otherwise>
				<c:set var="houseNo"></c:set>
				<c:set var="houseNumber" value="" />
				<c:set var="unitNo"></c:set>
				<c:set var="unitType"></c:set>
				<c:set var="dpId" value="" />
			</c:otherwise>
		</c:choose>

		<c:if test="${empty unitNo}">

			<sql:query var="result">
				SELECT unitNo
				FROM aggregator.street_number
				WHERE streetId = ?
				AND houseNo = ?
				AND unitNo > 0
				LIMIT 1
				<sql:param value="${row.streetId}" />
				<sql:param value="${row.houseNo}" />
			</sql:query>

			<sql:query var="resultEmptyUnits">
				SELECT unitNo
				FROM aggregator.street_number
				WHERE streetId = ?
				AND houseNo = ?
				AND unitNo = 0
				LIMIT 1
				<sql:param value="${row.streetId}" />
				<sql:param value="${row.houseNo}" />
			</sql:query>

			<c:set var="hasUnits" >&quot;hasUnits&quot; : ${result.rowCount == 1} , </c:set>
			<c:set var="hasEmptyUnits">&quot;hasEmptyUnits&quot; : ${resultEmptyUnits.rowCount == 1} , </c:set>
		</c:if>
		<c:set var="emptyHouseNumberhasUnits" value="${false}" />
		<c:if test="${row.houseNo == '0' or empty row.houseNo}">
			<sql:query var="unitResults">
				SELECT streetId
				FROM aggregator.street_number
				WHERE StreetId = ?
				AND houseNo = '0'
				AND unitNo != '0'
				LIMIT 1;
				<sql:param value="${row.streetId}" />
			</sql:query>
			<c:set var="emptyHouseNumberhasUnits" value="${unitResults.rowCount > 0}" />
			
			<sql:query var="resultEmptyUnits">
				SELECT unitNo
				FROM aggregator.street_number
				WHERE streetId = ?
				AND houseNo = '0'
				AND unitNo = 0
				LIMIT 1
				<sql:param value="${row.streetId}" />
			</sql:query>
			<c:set var="hasEmptyUnits">&quot;hasEmptyUnits&quot; : ${resultEmptyUnits.rowCount == 1} , </c:set>
		</c:if>

		<c:set var="key">{${key},${hasUnits}${hasEmptyUnits}&quot;emptyHouseNumberhasUnits&quot;:${emptyHouseNumberhasUnits},&quot;houseNo&quot; : &quot;${houseNo}&quot; ,&quot;unitType&quot; : &quot;${unitType}&quot;,&quot;unitNo&quot; :&quot;${unitNo}&quot;, &quot;dpId&quot; : &quot;${dpId}&quot;}</c:set>

	<div val="${row.street}"
		key="${key}"
			onmousedown="ajaxdrop_click('${fieldId}',${i});return false;"
			onmouseover="ajaxdrop_highlight('${fieldId}',${i});"
		class="ajaxdrop"
		idx="${i}">
		<c:if test="${fn:length(row.street) > 1 && fn:substring(row.street,0,2) != '*p'}">
				${unitTypePretty}<b>${houseNumber}${fn:substring(row.street,0,searchLen)}</b>${fn:substring(row.street,searchLen,50)}, ${row.suburb}&nbsp;${row.state}&nbsp;${row.postcode}
		</c:if>
	</div>
	<c:set var="i" value="${status.count}" />
</c:forEach>
<c:if test="${param.showUnable!=''}">

	<div val="*NOTFOUND"
		key="*NOTFOUND"
		onmousedown="ajaxdrop_click('${fieldId}',${i});return false;"
		onmouseover="ajaxdrop_highlight('${fieldId}',${i});"
		class="ajaxdrop"
		idx="${i}">
		<b>Can't find your address? <u>Click Here.</u>&nbsp;</b>
	</div>
</c:if>
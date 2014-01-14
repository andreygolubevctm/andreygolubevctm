<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>

<c:set var="unitNo" value="${fn:toUpperCase(param.unitNo)}" />
<c:set var="unitNo" value="${go:replaceAll( unitNo, '[^A-Z0-9-]', '' )}"/>

<c:set var="houseNo" value="${fn:toUpperCase(param.houseNo)}" />
<c:set var="houseNo" value="${go:replaceAll( houseNo, '[^A-Z0-9-]', '' )}"/>

<c:set var="unitType" value="${go:replaceAll( param.unitType, '[^A-Z]', '' )}"/>


<c:if test="${empty houseNo}" >
	<c:set var="houseNo" value="0" />
</c:if>

<c:if test="${empty unitNo}" >
	<c:set var="unitNo" value="0" />
</c:if>

<c:choose>
	<c:when test="${not empty param.streetId}" >
		<sql:query var="result">
			SELECT sn.dpId, unitNo, sn.unitType, houseNo , street, suburb, state, s.postCode, s.streetId
			FROM streets  s
			JOIN street_number sn
			ON sn.streetId = s.streetId
			WHERE s.streetId = ?
			AND houseNo = ?
			AND unitNo = ?
			<c:if test="${not empty unitType && unitType != 'OT'}" >
				AND unitType = ?
			</c:if>
			LIMIT 1;
			<sql:param value="${param.streetId}" />
			<sql:param value="${houseNo}" />
			<sql:param value="${unitNo}" />
			<c:if test="${not empty unitType && unitType != 'OT'}" >
				<sql:param value="${param.unitType}" />
			</c:if>
		</sql:query>
	</c:when>
	<c:otherwise>
		<c:set var="postCode" value="${go:replaceAll( param.postCode, '[^0-9]', '' )}"/>
		<c:set var="suburbSequence" value="${param.suburbSequence}"/>
		<c:set var="street" value="${param.street}"/>

		<sql:query var="result">
			SELECT sn.dpId, unitNo, sn.unitType, houseNo , street, suburb, state, s.postCode, s.streetId
			FROM streets s
			JOIN street_number sn
			ON sn.streetId = s.streetId
			WHERE postCode = ?
			AND suburbSeq = ?
			AND ( street = ?
			OR street = ?)
			AND houseNo = ?
			AND unitNo = ?
			<c:if test="${unitNo != '0' && not empty unitType && unitType != 'OT'}" >
				AND unitType = '${unitType}'
			</c:if>
			LIMIT 1;
			<sql:param value="${postCode}" />
			<sql:param value="${suburbSequence}" />
			<sql:param value="${street}" />
			<sql:param value="${street}." />
			<sql:param value="${houseNo}" />
			<sql:param value="${unitNo}" />
		</sql:query>
	</c:otherwise>
</c:choose>

<%-- Export the JSON Results --%>
<c:choose>
	<c:when test="${result.rowCount > 0 }">
		<c:set var="hasUnits" value="${false}" />
		<c:if test="${empty result.rows[0].unitNo || result.rows[0].unitNo == 0}">
			<sql:query var="units">
					SELECT unitNo
					FROM street_number
					WHERE streetId = ?
					AND houseNo = ?
					AND unitNo > 0
					LIMIT 1
				<sql:param value="${result.rows[0].streetId}" />
				<sql:param value="${result.rows[0].houseNo}" />
			</sql:query>
			<c:set var="hasUnits" value="${units.rowCount == 1}" />
		</c:if>
		{
			"foundAddress"		 :true,
			"dpId"				 :${result.rows[0].dpId},
			<%-- TODO get full fullAddressLineOne once database column is added --%>
			"fullAddressLineOne" : "" ,
			<%-- TODO get full address once database column is added --%>
			"fullAddress" 		 : "",
			"houseNo"			 : "${result.rows[0].houseNo}",
			"unitNo"			 : "${result.rows[0].unitNo}",
			"hasUnits" 			 : ${hasUnits} ,
			"unitType"			 : "${result.rows[0].unitType}",
			"suburb"			 : "${result.rows[0].suburb}",
			"state"				 : "${result.rows[0].state}",
			"streetName"		 : "${result.rows[0].street}",
			"postCode"			 : "${result.rows[0].postCode}"
		}
	</c:when>
	<c:otherwise>
		{"foundAddress":false}
	</c:otherwise>
</c:choose>
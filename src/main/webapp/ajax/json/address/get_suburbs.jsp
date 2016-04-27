<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<sql:query var="result">
	SELECT suburb, count(street) as streetCount, suburbSeq, state, street
	FROM aggregator.streets
	WHERE postCode = ?
	GROUP by suburb
	ORDER by suburb
	<sql:param value="${param.postCode}" />
</sql:query>

<c:set var="searchLen" value="${fn:length(param.search)}" />
<c:set var="countPostBox" value="${0}" />
<c:set var="postBoxOnly" value="${false}" />
<json:object>
	<json:array name="suburbs">
		<c:forEach var="row" items="${result.rows}" varStatus="status">
			<c:choose>
				<c:when test="${row.street !='*postbox_only*' || row.streetCount > 1}">
					<json:object>
						<json:property name="des" value="${row.suburb}"/>
						<json:property name="id" value="${row.suburbSeq}"/>
					</json:object>
				</c:when>
				<c:otherwise>
					<c:if test="${!param.excludePostBoxes}">
						<json:object>
							<json:property name="des" value="${row.suburb}"/>
							<json:property name="id" value="${row.suburbSeq}"/>
						</json:object>
					</c:if>
					<c:set var="countPostBox" value="${countPostBox + 1}" />
				</c:otherwise>
			</c:choose>
			<c:if test="${status.last}">
				<c:set var="stateName" value="${row.state}" />
			</c:if>
		</c:forEach>
		<c:if test="${result.rowCount > 0 && countPostBox == result.rowCount}">
			<c:set var="postBoxOnly" value="${true}" />
		</c:if>
	</json:array>
	<json:property name="state" value="${stateName}"/>
	<json:property name="postBoxOnly" value="${postBoxOnly}"/>
</json:object>
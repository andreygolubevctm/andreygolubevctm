<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	SELECT suburb, count(street) as streetCount, suburbSeq, state, street
	FROM test.streets
	WHERE postCode = ?
	<c:if test="${param.excludePostBoxes}">
		and street !='*postbox_only*'
	</c:if>
	GROUP by suburb
	ORDER by suburb
	<sql:param value="${param.postCode}" />
</sql:query>

<c:set var="searchLen" value="${fn:length(param.search)}" />
<c:set var="postBoxOnly" value="${true}" />
{"suburbs":[
	<c:forEach var="row" items="${result.rows}" varStatus="status">
		<c:if test="${row.street !='*postbox_only*' || row.streetCount > 1}">
			<c:set var="postBoxOnly" value="${false}" />
		</c:if>
		{"des":"${row.suburb}","id":"${row.suburbSeq}"}
		<c:if test="${!status.last}">,</c:if>
		<c:if test="${status.last}">
			<c:set var="stateName" value="${row.state}" />
		</c:if>
	</c:forEach>
	],
	"state":"${stateName}",
	"postBoxOnly":${postBoxOnly}
}
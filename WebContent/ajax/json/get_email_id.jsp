<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<sql:setDataSource dataSource="jdbc/aggregator" />

<c:set var="email">${fn:trim(param.email)}</c:set>
<c:set var="source">${fn:trim(param.s)}</c:set>
<c:set var="marketing">${fn:trim(param.m)}</c:set>
<c:set var="oktocall">${fn:trim(param.o)}</c:set>
<c:set var="callback">${fn:trim(param.callback)}</c:set>
<c:set var="callback_start"></c:set>
<c:set var="callback_end"></c:set>

<c:choose>
	<c:when test="${empty email}">
		<c:set var="result" value="" />
	</c:when>

	<c:otherwise>
		<sql:query var="result">
			SELECT emailId FROM `aggregator`.`email_master` WHERE emailAddress = ? LIMIT 1;
			<sql:param value="${email}" />
		</sql:query>
<go:log>${result}</go:log>
		<c:if test="${(empty result) || (result.rowCount == 0) }">
			<sql:update>
					INSERT INTO `aggregator`.`email_master` (emailAddress,emailSource,firstName,lastName,createDate) VALUES (?, ?,'','', curdate())
					<sql:param value="${email}" />
					<sql:param value="${source}" />
			</sql:update>

			<sql:update>
					INSERT INTO `aggregator`.`email_properties` (emailAddress,propertyId,value) VALUES (?, 'leadFeed', 'N'),(?, 'marketing', ?),(?, 'okToCall', ?),(?, 'transactional', 'Y')
					<sql:param value="${email}" />
					<sql:param value="${email}" />
					<sql:param value="${marketing}" />
					<sql:param value="${email}" />
					<sql:param value="${oktocall}" />
					<sql:param value="${email}" />
			</sql:update>

			<sql:query var="result">
					SELECT emailId FROM `aggregator`.`email_master` WHERE emailAddress = ? LIMIT 1;
					<sql:param value="${email}" />
			</sql:query>
		</c:if>

	</c:otherwise>
</c:choose>

<c:catch>
	<%-- Export the results, even an empty JSON --%>
	<c:choose>
		<c:when test="${(empty result) || (result.rowCount == 0) }">{"emailId":"-1"}</c:when>
		<c:otherwise>${callback_start}<c:forEach var="row"
				varStatus="status" items="${result.rows}">{"emailId":"<c:out
					value='${row.emailId}' />"}</c:forEach>${callback_end}</c:otherwise>
	</c:choose>
</c:catch>
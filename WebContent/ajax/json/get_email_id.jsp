<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core_new:no_cache_header/>

<session:get settings="true"/>

<sql:setDataSource dataSource="jdbc/aggregator" />

<c:set var="email">${fn:trim(param.email)}</c:set>
<c:set var="brand">${pageSettings.getBrandCode()}</c:set>
<c:set var="vertical">${fn:trim(param.vertical)}</c:set>
<c:set var="hashedEmail"><security:hashed_email action="encrypt" email="${email}" brand="${brand}" /></c:set>
<c:set var="source" value="QUOTE" />
<c:set var="marketing">${fn:trim(param.m)}</c:set>
<c:set var="oktocall">${fn:trim(param.o)}</c:set>
<c:set var="callback">${fn:trim(param.callback)}</c:set>
<c:set var="callback_start"></c:set>
<c:set var="callback_end"></c:set>
<c:set var="transactionId"	value="${data.current.transactionId}" />

<c:choose>
	<c:when test="${empty email}">
		<c:set var="result" value="" />
	</c:when>

	<c:otherwise>
		<sql:query var="result">
			SELECT emailId FROM `aggregator`.`email_master` WHERE emailAddress = ? LIMIT 1;
			<sql:param value="${email}" />
		</sql:query>
		<go:log source="get_email_id_jsp">${result}</go:log>
		<c:if test="${(empty result) || (result.rowCount == 0) }">
			<sql:update>
					INSERT INTO `aggregator`.`email_master` (emailAddress,brand,vertical,source,firstName,lastName,createDate,transactionId,hashedEmail) VALUES (?, ?, ?, ?,'','', curdate(), ?, ?)
					<sql:param value="${email}" />
					<sql:param value="${brand}" />
					<sql:param value="${vertical}" />
					<sql:param value="${source}" />
					<sql:param value="${transactionId}" />
					<sql:param value="${hashedEmail}" />
			</sql:update>

			<c:set var="properties">marketing=${marketing},okToCall=${oktocall},transactional=Y,leadFeed=N</c:set>
			<agg:write_email_properties
				email="${email}"
				items="${properties}"
				brand="${fn:toLowerCase(brand)}"
				vertical="${fn:toLowerCase(vertical)}"
				stampComment="${source}" />

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
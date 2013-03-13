<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="result">
	SELECT *
	FROM ctm.message_entries
	WHERE `owner` = ?
	<sql:param value="${data.login.user.uid}" />
</sql:query>

<%-- HTML --%>
<c:forEach var="row" items="${result.rows}" varStatus="status">
	<div class="message-entries" data-id="${row.commsId}">
		<div class="title PR-${row.priority}" data-id="${row.commsId}">${row.title}</div>
		<c:if test="${not empty row.queue || not empty row.state}">
			<div class="Q-${row.queue} details">
				<span class="state">${row.state}</span>
				<span class="queue">${row.queue}</span>
				<c:if test="${not empty row.callBack}">
					<span class="callback">${row.callBack}</span>
				</c:if>
			</div>
		</c:if>
		<div class="text">${row.message}</div>
	</div>
	<c:set var="tempXpath" value="message/form${row.commsId}" />
	
	<c:set var="tempXML">
		<form${row.commsId}>
			<commsId>${row.commsId}</commsId>
			<parentId>${row.parentId}</parentId>
			<owner>${row.owner}</owner>
			<message>${row.message}</message>
			<title>${row.title}</title>
			<priority>${row.priority}</priority>
			<date>${row.date}</date>
			<time>${row.time}</time>
			<state>${row.state}</state>
			<queue>${row.queue}</queue>
			<rescheduleCount>${row.rescheduleCount}</rescheduleCount>
		</form${row.commsId}>
	</c:set>
	
	<go:setData dataVar="data" xpath="${tempXpath}" value="*DELETE" />	
	<go:setData dataVar="data" xpath="message" xml="${tempXML}" />
	<simples:message_form xpath="${tempXpath}" className="hidden" commsId="${row.commsId}" title="${row.title}" />
	
	<%-- BLANK VERSION --%>
	<simples:message_form xpath="message_form0" className="hidden blank" commsId="0" title="New Call-back" />
	
</c:forEach>
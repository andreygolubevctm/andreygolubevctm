<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="transactionId">
	<c:choose>
		<c:when test="${empty param.transactionid}">
			<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
			<c:set var="errorPool">${errorPool}{"error":"No transaction ID received."}</c:set>
		</c:when>
		<c:otherwise>${param.transactionid}</c:otherwise>
	</c:choose>
</c:set>

<go:log level="INFO" source="comments_add_jsp" >Add Comment TransactionId: ${transactionId}</go:log>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:if test="${not empty transactionId}">
	<%-- Find the rootId for the transaction Id
	TODO: this should be one statement
	--%>
	<c:catch var="error">	
		<sql:query var="rootid">
			SELECT agg.rootId FROM aggregator.transaction_header AS agg
			WHERE agg.TransactionId = ?
			<sql:param value="${transactionId}" />
		</sql:query>
		<c:if test="${not empty rootid and rootid.rowCount > 0}">
			<c:set var="rootId">${rootid.rows[0].rootId}</c:set>
		</c:if>
	</c:catch>
</c:if>

<go:log level="INFO" source="comments_add_jsp" >Add Comment RootId: ${rootId}</go:log>

<c:choose>
	<c:when test="${empty rootId}">
		<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
		<c:set var="errorPool">${errorPool}{"error":"Failed to locate rootId for transaction ${transactionId}"}</c:set>
	</c:when>
	<c:otherwise>
		<sql:setDataSource dataSource="jdbc/ctm"/>
		
		<c:set var="comment">
			<c:choose>
				<c:when test="${empty param.comment}">
					<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
					<c:set var="errorPool">${errorPool}{"error":"No comment text received."}</c:set>
				</c:when>
				<c:otherwise>${param.comment}</c:otherwise>
			</c:choose>
		</c:set>
		
		<c:set var="operatorId">
			<c:choose>
				<c:when test="${not empty param.userOverride}">online</c:when>
				<c:when test="${empty data.login.user.uid}">
					<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
					<c:set var="errorPool">${errorPool}{"error":"No operator ID received."}</c:set>
				</c:when>
				<c:otherwise>${data.login.user.uid}</c:otherwise>
			</c:choose>
		</c:set>
		
		<c:if test="${not empty comment and not empty operatorId}">
			<c:catch var="error">
				<sql:update>
					INSERT INTO ctm.quote_comments
					(commId, transactionId, operatorId, comment, createDate, createTime)
					VALUES (
						0, ${rootId}, ?, ?, CURRENT_DATE, CURRENT_TIME
					)
					<sql:param>${operatorId}</sql:param>
					<sql:param>${comment}</sql:param>
				</sql:update>
			</c:catch>
			
			<c:if test="${not empty error}">
				<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
				<c:set var="errorPool">${errorPool}{"error":"Failed to add comment: ${error.rootCause}"}</c:set>
				<go:log source="comments_add_jsp" level="ERROR" error="${error}">Failed to add comment</go:log>
			</c:if>
		</c:if>
	</c:otherwise>
</c:choose>
		
<%-- Return output as json --%>
<c:choose>
	<c:when test="${empty errorPool}">
		<c:import url="/ajax/json/comments_get.jsp?transactionid=${transactionId}" />
	</c:when>
	<c:otherwise>
		{[${errorPool}]}
		<go:log source="comments_add_jsp" level="INFO">{[${errorPool}]}</go:log>
	</c:otherwise>
</c:choose>
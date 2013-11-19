<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<go:setData dataVar="data" xpath="sqlresponse" value="*DELETE" />

<c:set var="transactionId">
	<c:if test="${not empty param.transactionid}">${param.transactionid}</c:if>
</c:set>

<go:log>GET COMMENTS: ${param} - ${transactionId}</go:log>

<c:choose>
	<%-- If no transaction id then just return empty values --%>
	<c:when test="${empty transactionId}">
		<go:setData dataVar="data" xpath="sqlresponse/transactionId" value="" />
		<go:setData dataVar="data" xpath="sqlresponse/comments" value="" />
		
		<%--<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
		<c:set var="errorPool">${errorPool}{"error":"No quote ID available to source comments."}</c:set>--%>
	</c:when>
	<c:otherwise>
		<go:log>TransID: ${transactionId}</go:log>
		
		<%-- Find the rootId for the transaction Id
		
			TODO: this should be one select statement e.g.

			SELECT com.commId, com.transactionId, com.operatorId, com.comment, com.createDate, com.createTime
			FROM ctm.quote_comments AS com, aggregator.transaction_header AS agg
			WHERE com.transactionId = agg.rootId
			AND agg.TransactionId = ?
			ORDER BY com.createDate DESC, com.createTime DESC
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
		
		<go:setData dataVar="data" xpath="sqlresponse/transactionId" value="${transactionId}" />	
		<go:setData dataVar="data" xpath="sqlresponse/comments" value="" />
		
		<c:choose>
			<c:when test="${empty rootId}">
				<c:set var="errorPool">${errorPool}{"error":"Failed to locate rootId for transaction ${transactionId}"}</c:set>
			</c:when>
			<c:otherwise>
				<sql:setDataSource dataSource="jdbc/ctm"/>
				
				<%-- Find all the comments for the transaction Id --%>
				<c:catch var="error">	
					<sql:query var="comments">
						SELECT com.commId, com.transactionId, com.operatorId, com.comment, com.createDate, com.createTime
						FROM ctm.quote_comments AS com
						WHERE com.transactionId = ${rootId}
						ORDER BY com.createDate DESC, com.createTime DESC
					</sql:query>
				</c:catch>
				
				<%-- Test for DB issue and handle - otherwise move on --%>
				<c:choose>
					<c:when test="${not empty error}">
						<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
						<c:set var="errorPool">${errorPool}{"error":"Failed to get comments: ${error.rootCause}"}</c:set>
					</c:when>
					<c:otherwise>	
					
						<%-- Add each comment to the sqlresponse --%>
						<c:set var="index" value="${0}" />
						<c:forEach var="row" items="${comments.rows}">
							<go:setData dataVar="data" xpath="sqlresponse/comments[${index}]/commId" value="${row.commId}" />
							<go:setData dataVar="data" xpath="sqlresponse/comments[${index}]/transactionId" value="${row.transactionId}" />
							<go:setData dataVar="data" xpath="sqlresponse/comments[${index}]/operatorId" value="${row.operatorId}" />
							<go:setData dataVar="data" xpath="sqlresponse/comments[${index}]/comment" value="${row.comment}" />
							<go:setData dataVar="data" xpath="sqlresponse/comments[${index}]/createDate" value="${row.createDate}" />
							<go:setData dataVar="data" xpath="sqlresponse/comments[${index}]/createTime" value="${row.createTime}" />
							<c:set var="index" value="${index + 1}" />
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
		
<%-- Return output as json --%>
<c:choose>
	<c:when test="${empty errorPool}">
		${go:XMLtoJSON(go:getEscapedXml(data['sqlresponse']))}
		<go:setData dataVar="data" xpath="sqlresponse" value="*DELETE" />	
	</c:when>
	<c:otherwise>
		{[${errorPool}]}
	</c:otherwise>
</c:choose>
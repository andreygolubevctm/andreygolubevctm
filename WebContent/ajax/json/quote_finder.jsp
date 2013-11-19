<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<go:setData dataVar="data" xpath="findQuotes" value="*DELETE" />

<go:log>Find Quote: ${param}</go:log>

<c:set var="errorPool" value="" />

<c:set var="emailResultLimit" value="${5}" />

<c:choose>
	<%-- Fail if missing either search terms or type --%>
	<c:when test="${empty param.term || empty param.type}">
		<c:set var="termError">
			<c:when test="${empty param.term}">No search term provided.</c:when>
		</c:set>
		<c:set var="typeError">
			<c:when test="${empty param.type or fn:contains('email,transactionid', param.type)}">Empty or invalid search type provided.</c:when>
		</c:set>
		<c:if test="${not empty termError}">
			<c:set var="errorPool">{"error":"${termError}"}</c:set>
		</c:if>
		<c:if test="${not empty typeError}">
			<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{"error":"${termError}"}</c:set>
		</c:if>
	</c:when>
	<%-- Otherwise let's start finding some quotes --%>
	<c:otherwise>
		<c:if test="${param.type eq 'transactionid'}">
			<c:catch var="error">
				<sql:query var="findquote">
					SELECT d.transactionId, d.xpath, d.textValue, h.rootId
					FROM aggregator.transaction_details AS d
					LEFT JOIN aggregator.transaction_header AS h
						ON h.TransactionId = d.transactionId
					WHERE h.rootId IS NOT NULL AND
						d.transactionId = ?;
					<sql:param value="${param.term}" />
				</sql:query>
			</c:catch>
		</c:if>
		<c:if test="${param.type eq 'email'}">
			<%-- I know this could have been done in 1 query but our mysql version doesn't
				allow use of LIMIT in a subquery - you'd think if you wanted to allow
				LIMIT anywhere it would be in a subquery... oh well --%>
			<c:catch var="error">

				<%-- Setting a MySQL cache date --%>
				<c:set var="startDate"><read:return_date addDays="-90" /></c:set>

				<%-- Getting a MySQL TransactionID limiter, which will be cached --%>
				<sql:query var="limitIdSQL">
					SELECT MIN(transactionId) AS id
					FROM aggregator.transaction_header
					WHERE startDate > '${startDate}';
				</sql:query>

				<c:set var="limitId" value="${limitIdSQL.rows[0]['id']}" />

				<%-- Get list of term matching transaction ids --%>
				<sql:query var="findquote">
					SELECT transactionId
					FROM aggregator.transaction_details
					WHERE textValue = ? AND transactionId > ${limitId}
					GROUP BY transactionId DESC
					LIMIT ?;
					<sql:param value="${param.term}" />
					<sql:param value="${emailResultLimit}" />
				</sql:query>
			</c:catch>

			<c:if test="${empty error and not empty findquote and findquote.rowCount > 0}">
				<%-- Put found transactions into a flat list and pull out the transactions --%>
				<c:set var="tranIds" value="" />
				<c:forEach var="row" items="${findquote.rows}">
					<c:set var="tranIds"><c:if test="${not empty tranIds}">${tranIds},</c:if>'${row.transactionId}'</c:set>
				</c:forEach>
				<go:log>${tranIds}</go:log>
				<c:catch var="error">
					<sql:query var="findquote">
						SELECT d.transactionId, d.xpath, d.textValue, h.rootId
						FROM aggregator.transaction_details AS d
						LEFT JOIN aggregator.transaction_header AS h
							ON h.TransactionId = d.transactionId
						WHERE h.rootId IS NOT NULL AND
							d.transactionId IN (${tranIds})
						ORDER BY d.transactionId DESC, d.sequenceNo ASC;
					</sql:query>
				</c:catch>
			</c:if>
		</c:if>

		<c:choose>
			<c:when test="${not empty error}">
				<c:set var="errorPool">{"error":"${error}"}</c:set>
			</c:when>
			<c:when test="${empty findquote or findquote.rowCount < 1}">
				<c:set var="errorPool">{"error":"No quotes found using '${param.term}'"}</c:set>
			</c:when>
			<c:otherwise>
				<%-- So we know we have results - let's add to the bucket. --%>
				<c:forEach var="row" items="${findquote.rows}">
					<c:choose>
						<c:when test="${fn:startsWith(row.xpath, 'health') or fn:startsWith(row.xpath, 'quote') or fn:startsWith(row.xpath, 'life') or fn:startsWith(row.xpath, 'ip') or fn:startsWith(row.xpath, 'utilities') or fn:startsWith(row.xpath, 'travel')}">
							<%-- Ideally this is where we massage the content into a human readable format
								but alas for now we'll just return the raw data --%>
							<go:setData dataVar="data" xpath="findQuotes/quotes[@id=${row.transactionId}]/${row.xpath}" value="${row.textValue}" />
						</c:when>
					</c:choose>
				</c:forEach>

			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<%-- Return output as json --%>
<c:choose>
	<c:when test="${empty errorPool}">
		${go:XMLtoJSON(go:getEscapedXml(data.findQuotes))}
		<go:setData dataVar="data" xpath="findQuotes" value="*DELETE" />
	</c:when>
	<c:otherwise>
		{errors:[${errorPool}]}
	</c:otherwise>
</c:choose>
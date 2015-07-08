<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="jdbc/ctm"/>

<go:setData dataVar="data" xpath="findQuotes" value="*DELETE" />

<go:log  level="INFO" >Find Quote: ${param}</go:log>

<c:set var="errorPool" value="" />

<c:set var="emailResultLimit" value="${5}" />

<c:set var="isOperator"><c:if test="${not empty authenticatedData['login/user/uid']}">${authenticatedData['login/user/uid']}</c:if></c:set>
<go:log>isOperator: ${isOperator}</go:log>

<c:choose>
	<c:when test="${empty isOperator}">
		<c:set var="errorPool">{"message":"login"}</c:set>
	</c:when>
	<c:otherwise>

		<c:choose>
			<%-- Fail if missing either search terms or type --%>
			<c:when test="${empty param.term}">
				<c:set var="errorPool">{"message":"No search term provided."}</c:set>
			</c:when>
			<c:when test="${empty param.type or !fn:contains('email,transactionid', param.type)}">
				<c:set var="errorPool">{"message":"Empty or invalid search type provided."}</c:set>
			</c:when>
			<%-- Otherwise let's start finding some quotes --%>

			<c:otherwise>
				<c:if test="${param.type eq 'transactionid'}">
					<c:catch var="error">

						<%-- Added extracting styleCodeId to allow setting branding off transaction --%>
						<sql:query var="findquote">
							SELECT 'HOT' as tableType , h.styleCodeId, d.transactionId, d.xpath, d.textValue, h.rootId
							FROM aggregator.transaction_details AS d
							LEFT JOIN aggregator.transaction_header AS h
								ON h.TransactionId = d.transactionId
							WHERE h.rootId IS NOT NULL AND
								d.transactionId = ?;
							<sql:param value="${param.term}" />
						</sql:query>
						<c:if test="${findquote.rowCount == 0}">
							<%-- Added extracting styleCodeId to allow setting branding off transaction --%>
							<sql:query var="findquote">
								SELECT 'COLD' as tableType , h.styleCodeId, d.transactionId, tf.fieldCode AS xpath, d.textValue, h.rootId
								FROM aggregator.transaction_details2_cold AS d
								JOIN aggregator.transaction_fields tf USING(fieldId)
								LEFT JOIN aggregator.transaction_header2_cold AS h
								ON h.TransactionId = d.transactionId
								WHERE h.rootId IS NOT NULL AND
								d.transactionId = ?;
								<sql:param value="${param.term}" />
							</sql:query>
						</c:if>
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
							WHERE startDate > '${startDate}'
							UNION ALL
							SELECT MIN(transactionId) AS id
							FROM aggregator.transaction_header2_cold
							WHERE transactionStartDateTime > '${startDate} 23:59:59';
						</sql:query>

						<c:set var="limitId">
							<c:choose>
								<c:when test="${not empty limitIdSQL.rows[1]['id']}">${limitIdSQL.rows[1]['id']}</c:when>
								<c:when test="${not empty limitIdSQL.rows[0]['id']}">${limitIdSQL.rows[0]['id']}</c:when>
								<c:otherwise>0</c:otherwise>
							</c:choose>
						</c:set>

						<%-- Get list of term matching transaction ids --%>
						<sql:query var="findquote">
							SELECT 'HOT' as tableType , transactionId
							FROM aggregator.transaction_details
							WHERE textValue = ? AND transactionId > ${limitId}
							GROUP BY transactionId DESC
							UNION ALL
							SELECT 'COLD' as tableType , transactionId
							FROM aggregator.transaction_details2_cold
							WHERE textValue = ? AND transactionId > ${limitId}
							GROUP BY transactionId DESC
							LIMIT ?;
							<sql:param value="${param.term}" />
							<sql:param value="${param.term}" />
							<sql:param value="${emailResultLimit}" />
						</sql:query>
					</c:catch>

					<c:if test="${empty error and not empty findquote and findquote.rowCount > 0}">
						<%-- Put found transactions into a flat list and pull out the transactions --%>
						<jsp:useBean id="searchService" class="com.ctm.services.simples.SimplesSearchService" scope="page" />
						${searchService.mapResults(findquote , true)}

						<go:log level="INFO">
							TRAN IDS Hot  = ${searchService.getHotTransactionIdsCsv()}
							TRAN IDS Cold = ${searchService.getColdTransactionIdsCsv()}
						</go:log>
						<c:catch var="error">
						<%-- Added extracting styleCodeId to allow setting branding off transaction --%>
							<sql:query var="findquote">
								<c:if test="${searchService.hasHotTransactions()}">
									SELECT h.styleCodeId, d.transactionId, d.xpath, d.textValue, h.rootId
									FROM aggregator.transaction_details AS d
									LEFT JOIN aggregator.transaction_header AS h
										ON h.TransactionId = d.transactionId
									WHERE h.rootId IS NOT NULL AND
										d.transactionId IN (${searchService.getHotTransactionIdsCsv()})
								</c:if>
								<c:if test="${searchService.hasHotTransactions() && searchService.hasColdTransactions()}">
									UNION ALL
								</c:if>
								<c:if test="${searchService.hasColdTransactions()}">
									SELECT h.styleCodeId, d.transactionId, tf.fieldCode AS xpath, d.textValue, h.rootId
									FROM aggregator.transaction_details2_cold AS d
									JOIN aggregator.transaction_fields tf USING(fieldId)
									LEFT JOIN aggregator.transaction_header2_cold AS h
										ON h.TransactionId = d.transactionId
									WHERE h.rootId IS NOT NULL AND
										d.transactionId IN (${searchService.getColdTransactionIdsCsv()})
									ORDER BY transactionId DESC, xpath ASC;
								</c:if>
							</sql:query>
						</c:catch>
					</c:if>
				</c:if>

				<c:choose>
					<c:when test="${not empty error}">
						<c:set var="errorPool">{"message":"A database error occurred finding quotes: ${error.rootCause}"}</c:set>
					</c:when>
					<c:when test="${empty findquote or findquote.rowCount < 1}">
						<c:set var="errorPool">{"message":"No quotes found using '${param.term}'"}</c:set>
					</c:when>
					<c:otherwise>
						<%-- So we know we have results - let's add to the bucket. --%>
						<c:forEach var="row" items="${findquote.rows}">

							<c:choose>
								<c:when test="${fn:startsWith(row.xpath, 'health') or fn:startsWith(row.xpath, 'quote') or fn:startsWith(row.xpath, 'life') or fn:startsWith(row.xpath, 'ip') or fn:startsWith(row.xpath, 'utilities') or fn:startsWith(row.xpath, 'travel') or fn:startsWith(row.xpath, 'home')}">
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
	</c:otherwise>
</c:choose>

<%-- Return output as json --%>
<c:choose>
	<c:when test="${empty errorPool}">
		${go:XMLtoJSON(go:getEscapedXml(data.findQuotes))}
		<go:setData dataVar="data" xpath="findQuotes" value="*DELETE" />
	</c:when>
	<c:otherwise>
		{"errors":[${errorPool}]}
	</c:otherwise>
</c:choose>
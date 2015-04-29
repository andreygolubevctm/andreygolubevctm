<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated  />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
<jsp:useBean id="searchService" class="com.ctm.services.simples.SimplesSearchService" scope="request" />

<sql:setDataSource dataSource="jdbc/aggregator"/>
<go:setData dataVar="data" xpath="search_results" value="*DELETE" />

<c:set var="searchPhrase" value="${fn:trim(param.search_terms)}" />

<go:log level="INFO">Search Quotes: ${searchPhrase}</go:log>

<c:set var="errorPool" value="" />


<%-- Store flag as to whether Simples Operator or Other --%>
<c:set var="isOperator"><c:if test="${not empty authenticatedData['login/user/uid']}">${authenticatedData['login/user/uid']}</c:if></c:set>

<c:choose>
	<%-- Operator Test --%>
	<c:when test="${empty isOperator}">
		<c:set var="errorPool">${errorPool}{"message":"login"}</c:set>
		<% response.setStatus(401); /* Unauthorised */ %>
	</c:when>

	<%-- Fail if no search terms provided --%>
	<c:when test="${empty searchPhrase}">
		<c:set var="errorPool">${errorPool}{"message":"No search terms provided."}</c:set>
	</c:when>

	<%-- Carry on with the Search --%>
	<c:otherwise>
		<%--
            THE MAIN SEARCH SERVICE
            =======================
            - Get the Related Transaction IDs (NEW PART - this cuts down on the code required)
            - Transform into usable data //FIX //REFINE, use a new SQL sequence and and XSL transform to properly create the downloadable content
            - Return the JSON set (from the crisp sheets, when they are available)
        --%>

		<%-- Catch as a number such that a number will be null; otherwise a string --%>
		<c:catch var="isNumber">
			<c:set var="x" value="${searchPhrase + 1}" />
		</c:catch>

		<%-- Test if pre-defined search term --%>
		<c:set var="simplesMode">
			<c:choose>
				<c:when test="${fn:substring(searchPhrase, 0, 2) == '04'}">MOBILE</c:when>
				<c:when test="${fn:substring(searchPhrase, 0, 1) == '0' || fn:substring(searchPhrase, 0, 1) == '+'}">PHONE</c:when>
				<c:when test="${isNumber == null}">TRANS</c:when>
				<c:when test="${fn:contains(searchPhrase, '@')}">EMAIL</c:when>
				<c:otherwise>NAME</c:otherwise>
			</c:choose>
		</c:set>

		<%-- Setting a MySQL cache date --%>
		<c:set var="startDate">
			<c:choose>
				<c:when test="${simplesMode eq 'TRANS'}">
					<read:return_date addDays="-91" />
				</c:when>
				<c:otherwise>
					<read:return_date addDays="-31" />
				</c:otherwise>
			</c:choose>
		</c:set>

		<%-- Getting a MySQL TransactionID limiter, which will be cached --%>
		<sql:query var="limitIdSQL">
			SELECT MIN(transactionId) AS id
			FROM aggregator.transaction_header
			WHERE startDate > ?
			<c:if test="${simplesMode eq 'TRANS'}">
				UNION ALL
				SELECT MIN(transactionId) AS id
				FROM aggregator.transaction_header2_cold
				WHERE transactionStartDateTime > ?
			</c:if>;
			<sql:param>${startDate}</sql:param>
			<c:if test="${simplesMode eq 'TRANS'}">
				<sql:param>${startDate}</sql:param>
			</c:if>
		</sql:query>
		<c:set var="limitId">
			<c:choose>
				<c:when test="${not empty limitIdSQL.rows[1]['id']}">${limitIdSQL.rows[1]['id']}</c:when>
				<c:when test="${not empty limitIdSQL.rows[0]['id']}">${limitIdSQL.rows[0]['id']}</c:when>
				<c:otherwise>0</c:otherwise>
			</c:choose>
		</c:set>

		<c:choose>
			<c:when test="${simplesMode eq 'MOBILE'}">
				<go:log level="INFO" >SIMPLES SEARCH: MOBILE MODE</go:log>
				<sql:query var="transactions">
					SELECT th.transactionID AS id, td.xpath
					FROM aggregator.transaction_details td
					JOIN aggregator.transaction_header th ON td.transactionId = th.transactionID
					AND th.productType = 'HEALTH'
					WHERE td.xpath IN(
					'health/application/mobile',
					'health/application/other',
					'health/contactDetails/contactNumber',
					'health/contactDetails/contactNumber/mobile'
					)
					AND td.textValue = ?
					GROUP BY th.transactionId DESC
					LIMIT 25;
					<sql:param value="${searchPhrase}" />
				</sql:query>
			</c:when>

			<c:when test="${simplesMode eq 'PHONE'}">
				<go:log level="INFO" >SIMPLES SEARCH: PHONE MODE</go:log>
				<sql:query var="transactions">
					SELECT th.transactionID AS id
					FROM aggregator.transaction_details td
					JOIN aggregator.transaction_header th ON td.transactionId = th.transactionID
					AND th.productType = 'HEALTH'
					WHERE td.xpath IN(
					'health/contactDetails/contactNumber',
					'health/contactDetails/contactNumber/other',
					'health/application/other'
					)
					AND td.textValue = ?
					GROUP BY th.transactionId DESC
					LIMIT 25;
					<sql:param value="${searchPhrase}" />
				</sql:query>
			</c:when>

			<c:when test="${simplesMode eq 'TRANS'}">
				<go:log level="INFO" >SIMPLES SEARCH: TRANSACTION ID NODE</go:log>
				<sql:query var="transactions">
					SELECT 'HOT' as tableType , transactionId AS id
					FROM aggregator.transaction_header
					WHERE transactionId > '${limitId}'
					AND productType = 'HEALTH'
					AND ? IN (rootId,TransactionID,PreviousId)
					UNION ALL
					SELECT 'COLD' as tableType , transactionId AS id
					FROM aggregator.transaction_header2_cold
					WHERE transactionId > '${limitId}'
					AND verticalId = 4
					AND ? IN (rootId,TransactionID,PreviousId);
					<sql:param value="${searchPhrase}" />
					<sql:param value="${searchPhrase}" />
				</sql:query>
			</c:when>

			<c:when test="${simplesMode eq 'EMAIL'}">
				<go:log level="INFO" >SIMPLES SEARCH: EMAIL MODE</go:log>
				<sql:query var="transactions">
					SELECT id FROM
					(
					(SELECT th.transactionId AS id
					FROM aggregator.transaction_header th
					WHERE th.productType = 'HEALTH'
					AND th.emailAddress = ?
					GROUP BY id DESC
					LIMIT 25)
					UNION ALL
					(SELECT th.transactionID AS id
					FROM aggregator.transaction_details td
					JOIN aggregator.transaction_header th ON td.transactionId = th.transactionID
					AND th.productType = 'HEALTH'
					WHERE td.xpath IN(
					'health/contactDetails/email',
					'health/application/email'
					)
					AND td.textValue = ?
					GROUP BY id DESC
					LIMIT 25)
					) AS results
					GROUP BY id DESC
					LIMIT 25;
					<sql:param value="${searchPhrase}" />
					<sql:param value="${searchPhrase}" />
				</sql:query>
			</c:when>

			<c:otherwise>
				<c:choose>
					<c:when test="${not empty fn:substringAfter(searchPhrase, ' ')}">
						<go:log level="INFO" >SIMPLES SEARCH: FULL NAME MODE</go:log>

						<c:set var="searchPhraseLastName" value="${fn:substringAfter(searchPhrase, ' ')}" />
						<c:set var="searchPhraseFirstName" value="${fn:substringBefore(searchPhrase, ' ')}" />

						<sql:query var="transactions">
							SELECT th.transactionId AS id
							FROM aggregator.transaction_details td
							JOIN aggregator.transaction_header th ON td.transactionId = th.transactionID
							AND th.productType = 'HEALTH'
							LEFT JOIN aggregator.transaction_details td2 ON td.transactionId = td2.transactionId
							AND td2.xpath IN('health/application/primary/surname','health/contactDetails/lastname')
							AND (
							(td.xpath = 'health/application/primary/firstname' AND td2.xpath = 'health/application/primary/surname')
							OR
							(td.xpath = 'health/contactDetails/firstname' AND td2.xpath = 'health/contactDetails/lastname')
							)
							WHERE td.xpath IN('health/contactDetails/name','health/application/primary/firstname','health/contactDetails/firstname')
							AND (
							(td.xpath = 'health/contactDetails/name' AND td.textValue LIKE(?))
							OR
							(td.xpath != 'health/contactDetails/name' AND td.textValue LIKE(?) AND td2.textValue LIKE(?))
							)
							GROUP BY th.transactionId DESC
							LIMIT 25;
							<sql:param>${searchPhraseFirstName}%${searchPhraseLastName}%</sql:param>
							<sql:param>${searchPhraseFirstName}%</sql:param>
							<sql:param>${searchPhraseLastName}%</sql:param>
						</sql:query>
					</c:when>
					<c:otherwise>
						<%-- SURNAME mode --%>
						<go:log level="INFO" >SIMPLES SEARCH: SURNAME MODE</go:log>

						<sql:query var="transactions">
							SELECT th.transactionId AS id
							FROM aggregator.transaction_details td
							JOIN aggregator.transaction_header th ON td.transactionId = th.transactionID
							AND th.productType = 'HEALTH'
							WHERE td.xpath IN(
							'health/contactDetails/name',
							'health/application/primary/surname',
							'health/contactDetails/lastname'
							)
							AND (
							(td.xpath = 'health/contactDetails/name' AND td.textValue LIKE ?)
							OR td.textValue LIKE ?
							)
							GROUP BY th.transactionId DESC
							LIMIT 25;
							<sql:param>%${searchPhrase}%</sql:param>
							<sql:param>${searchPhrase}%</sql:param>
						</sql:query>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>

		<%-- Refine the Transaction ID list with the necessary item --%>
		<c:choose>
			<c:when test="${empty errorPool && transactions.rowCount > 0}">
				<go:log level="INFO">
					simplesMode  = ${simplesMode}
				</go:log>
				${searchService.mapResults(transactions , simplesMode eq "TRANS")}

				<go:log level="INFO">
					TRAN IDS Hot  = ${searchService.getHotTransactionIdsCsv()}
					TRAN IDS Cold = ${searchService.getColdTransactionIdsCsv()}
				</go:log>

				<%-- Now consolidate the results ---%>
				<sql:query var="transactions">
					<c:if test="${searchService.hasHotTransactions()}">
						SELECT th.styleCodeId as styleCodeId, th.TransactionId AS id, th.rootId, th.EmailAddress AS email,
						th.StartDate AS quoteDate, th.StartTime AS quoteTime, th.ProductType AS productType,
						CASE
						-- If tran is not the latest then don't mark it as Failed (F)
						WHEN COALESCE(MAX(th2.transactionid),th.TransactionId) <> th.TransactionId
						THEN COALESCE(t1.type,1)
						ELSE COALESCE(t1.type,t2.type,1)
						END AS editable,
						COALESCE(MAX(th2.transactionid),th.TransactionId) AS latestID
						FROM aggregator.transaction_header th
						LEFT JOIN ctm.touches t1 ON (t1.transaction_Id > ?) AND (th.TransactionId = t1.transaction_id) AND (t1.type = 'C')
						LEFT JOIN ctm.touches t2 ON (t2.transaction_Id > ?) AND (th.TransactionId = t2.transaction_id) AND (t2.type = 'F')
						LEFT JOIN aggregator.transaction_header th2 ON th2.rootId = th.rootId
						WHERE th.TransactionId IN (${searchService.getHotTransactionIdsCsv()})
						AND th.transactionId > ?
						GROUP BY id
					</c:if>
					<c:if test="${searchService.hasHotTransactions() && searchService.hasColdTransactions()}">
						UNION ALL
					</c:if>
					<c:if test="${searchService.hasColdTransactions()}">
						SELECT th.styleCodeId as styleCodeId, th.TransactionId AS id, th.rootId, em.EmailAddress AS email,
						DATE(SUBSTR(th.transactionStartDateTime,1,10)) AS quoteDate, TIME(SUBSTR(th.transactionStartDateTime,12)) AS quoteTime,
						'HEALTH' AS productType,
						CASE
						-- If tran is not the latest then don't mark it as Failed (F)
						WHEN COALESCE(MAX(th2.transactionid),th.TransactionId) <> th.TransactionId
						THEN COALESCE(t1.type,1)
						ELSE COALESCE(t1.type,t2.type,1)
						END AS editable,
						COALESCE(MAX(th2.transactionid),th.TransactionId) AS latestID
						FROM aggregator.transaction_header2_cold th
						LEFT JOIN aggregator.transaction_emails te USING(transactionId)
						LEFT JOIN aggregator.email_master AS em ON em.emailId = te.emailId
						LEFT JOIN ctm.touches t1 ON (t1.transaction_Id > ?) AND (th.TransactionId = t1.transaction_id) AND (t1.type = 'C')
						LEFT JOIN ctm.touches t2 ON (t2.transaction_Id > ?) AND (th.TransactionId = t2.transaction_id) AND (t2.type = 'F')
						LEFT JOIN aggregator.transaction_header2_cold th2 ON th2.rootId = th.rootId
						WHERE th.TransactionId IN (${searchService.getColdTransactionIdsCsv()})
						AND th.transactionId > ?
						GROUP BY id
					</c:if>
					ORDER BY id DESC;
					<c:if test="${searchService.hasHotTransactions()}">
						<sql:param>${limitId}</sql:param>
						<sql:param>${limitId}</sql:param>
						<sql:param>${limitId}</sql:param>
					</c:if>
					<c:if test="${searchService.hasColdTransactions()}">
						<sql:param>${limitId}</sql:param>
						<sql:param>${limitId}</sql:param>
						<sql:param>${limitId}</sql:param>
					</c:if>
				</sql:query>
			</c:when>
			<c:otherwise>
				<c:set var="errorPool">${errorPool}{"message":"Pre-Qualifying search has found no results"}</c:set>
			</c:otherwise>
		</c:choose>
</c:otherwise>
</c:choose>

<%-- Now Check if we can continue with creating the search --%>
<c:if test="${empty errorPool && transactions.rowCount > 0}">

	<%--Store the transactionIds found in a comma delimited list --%>

	<go:log level="INFO">
		TranIds = ${searchService.getHotTransactionIdsCsv()}
		RowCount = ${transactions.rowCount}
	</go:log>

	<%-- Updating the data bucket --%>
	<c:forEach var="tid" items="${transactions.rows}">
		<%-- Inject base quote details the quote --%>

		<c:set var="brand" value="${applicationService.getBrandById(tid.styleCodeId)}" />

		<c:set var="quoteXml">
			<${fn:toLowerCase(tid.productType)}>
				<id>${tid.id}</id>
				<rootid>${tid.rootId}</rootid>
				<email>${tid.email}</email>
				<quoteBrandName><c:if test="${not empty brand}">${brand.getName()}</c:if></quoteBrandName>
				<quoteBrandId>${tid.styleCodeId}</quoteBrandId>
				<quoteDate><fmt:formatDate value="${tid.quoteDate}" pattern="dd/MM/yyyy" type="both"/></quoteDate>
				<quoteTime><fmt:formatDate value="${tid.quoteTime}" pattern="hh:mm a" type="time"/></quoteTime>
				<quoteType>${fn:toLowerCase(tid.productType)}</quoteType>
				<editable>${tid.editable}</editable>
			</${fn:toLowerCase(tid.productType)}>
		</c:set>
		<go:setData dataVar="data" xpath="search_results/quote[@id=${tid.id}]" xml="${quoteXml}" />

	</c:forEach>


	<%-- Now lets get the complete dataset for the transactions found --%>
	<c:catch var="error">
		<c:choose>
			<c:when test="${simplesMode eq 'TRANS'}">
				<sql:query var="results">
					<c:if test="${searchService.hasHotTransactions()}">
						SELECT details.transactionId, details.xpath,  details.productType, details.textValue
						FROM aggregator.health_transaction_details  AS details
						WHERE details.transactionId IN (${searchService.getHotTransactionIdsCsv()})
					</c:if>
					<c:if test="${searchService.hasHotTransactions() && searchService.hasColdTransactions()}">
						UNION ALL
					</c:if>
					<c:if test="${searchService.hasColdTransactions()}">
						SELECT details.transactionId, tf.fieldCode AS xpath,  'HEALTH' AS productType, details.textValue
						FROM aggregator.transaction_details2_cold  AS details
						JOIN aggregator.transaction_fields tf USING(fieldId)
						WHERE details.transactionId IN (${searchService.getColdTransactionIdsCsv()})
					</c:if>
					ORDER BY transactionId DESC;
				</sql:query>
			</c:when>
			<c:otherwise>
				<sql:query var="results">
					SELECT details.transactionId, details.xpath,  details.productType, details.textValue
					FROM aggregator.health_transaction_details  AS details
					WHERE details.transactionId IN (${searchService.getHotTransactionIdsCsv()})
					ORDER BY transactionId DESC;
				</sql:query>
			</c:otherwise>
		</c:choose>
	</c:catch>

	<%-- Test for DB issue and handle - otherwise move on --%>
	<c:choose>
		<c:when test="${not empty error}">
			<go:log level="ERROR" error="${error}">${error}</go:log>
			<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
			<c:set var="errorPool">${errorPool}{"message":"A database error occurred getting search results."}</c:set>
			<% response.setStatus(500); /* Internal Server Error */ %>
		</c:when>
		<c:when test="${not empty results and results.rowCount > 0}">

			<c:set var="group" value="" />

			<%-- No way to know if we'll have any health results so let's
				just retrieve health cover codes and descriptions --%>
			<sql:query var="health_cover">
				SELECT code, description FROM aggregator.general
				WHERE type = 'healthCvr'
				ORDER BY orderSeq;
			</sql:query>

			<%-- Retrieve health situation codes and descriptions --%>
			<sql:query var="health_situ">
				SELECT code, description FROM aggregator.general
				WHERE type = 'healthSitu'
				ORDER BY orderSeq;
			</sql:query>

			<%-- Inject all the new quote details found --%>
			<c:forEach var="row" items="${results.rows}" varStatus="status">
				<c:if test="${row.xpath != 'small-env'}">
					<c:if test="${empty group or row.transactionId != group}">
						<c:set var="group" value="${row.transactionId}" />
					</c:if>

					<go:setData dataVar="data" xpath="search_results/quote[@id=${row.transactionId}]/${row.xpath}" value="${row.textValue}" />

					<c:if test="${fn:toLowerCase(row.productType) eq 'health'}">
						<c:choose>
							<%-- Replace the health situation code with description --%>
							<c:when test="${row.xpath == 'health/situation/healthSitu' or row.xpath == 'health/benefits/healthSitu'  or row.xpath == 'health/benefits/benefits/healthSitu'}">
								<c:if test="${not empty health_situ && health_situ.rowCount > 0}">
									<c:forEach var="hs" items="${health_situ.rows}">
										<c:if test="${hs.code == row.textValue}">
											<go:setData dataVar="data" xpath="search_results/quote[@id=${row.transactionId}]/${row.xpath}" value="${hs.description}" />
										</c:if>
									</c:forEach>
								</c:if>
							</c:when>
							<%-- Replace the health cover codes with description --%>
							<c:when test="${row.xpath == 'health/situation/healthCvr'}">
								<c:if test="${not empty health_cover && health_cover.rowCount > 0}">
									<c:forEach var="hc" items="${health_cover.rows}">
										<c:if test="${hc.code == row.textValue}">
											<go:setData dataVar="data" xpath="search_results/quote[@id=${row.transactionId}]/${row.xpath}" value="${hc.description}" />
										</c:if>
									</c:forEach>
								</c:if>
							</c:when>
						</c:choose>
					</c:if>
				</c:if>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
			<c:set var="errorPool">${errorPool}{"message":"No content found for the quotes located in the search."}</c:set>
		</c:otherwise>
	</c:choose>

</c:if>

<%-- Return output as json --%>
<c:choose>
	<c:when test="${empty errorPool}">
		<c:import var="xslt" url="/WEB-INF/xslt/simples_search_results.xsl" />
		<c:set var="resultsXml">
			<x:transform doc="${go:getEscapedXml(data['search_results'])}" xslt="${xslt}" />
		</c:set>

		${go:XMLtoJSON(resultsXml)}
		<go:setData dataVar="data" xpath="search_results" value="*DELETE" />
	</c:when>
	<c:otherwise>
		{
		"errors": [${errorPool}],
		"searchPhrase": "${go:jsEscape(searchPhrase)}",
		"simplesMode": "${simplesMode}"
		}
	</c:otherwise>
</c:choose>
<go:setData dataVar="data" xpath="search_results" value="*DELETE" />
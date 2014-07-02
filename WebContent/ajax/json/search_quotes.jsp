<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated  />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" /> 

<sql:setDataSource dataSource="jdbc/aggregator"/>
<go:setData dataVar="data" xpath="search_results" value="*DELETE" />

<c:set var="searchPhrase" value="${fn:trim(param.search_terms)}" />

<go:log level="DEBUG">Search Quotes: ${searchPhrase}</go:log>
<c:set var="errorPool" value="" /> 


<%-- Store flag as to whether Simples Operator or Other --%>
<c:set var="isOperator"><c:if test="${not empty authenticatedData['login/user/uid']}">${authenticatedData['login/user/uid']}</c:if></c:set>

<c:choose>
	<%-- Operator Test --%>
	<c:when test="${empty isOperator}">
		<c:set var="errorPool">${errorPool}{"error":"login"}</c:set>
	</c:when>

			<%-- Fail if no search terms provided --%>
	<c:when test="${empty searchPhrase}">
				<c:set var="errorPool">${errorPool}{"error":"No search terms provided."}</c:set>
			</c:when>

	<%-- Carry on with the Search --%>
			<c:otherwise>
		<sql:transaction>
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
				WHERE startDate > ?;
				<sql:param>${startDate}</sql:param>
					</sql:query>

		<c:set var="limitId" value="${limitIdSQL.rows[0]['id']}" />

				<c:choose>
				<c:when test="${simplesMode eq 'MOBILE'}">
					<go:log level="INFO" >SIMPLES SEARCH: MOBILE MODE</go:log>
					<sql:query var="transactions">
						SELECT a.transactionID AS id
						FROM aggregator.transaction_header a
						LEFT OUTER JOIN aggregator.transaction_details b
							ON a.transactionId = b.transactionId AND b.xpath = 'health/application/mobile'
						LEFT OUTER JOIN aggregator.transaction_details c
							ON a.transactionId = c.transactionId AND c.xpath = 'health/application/other'
						LEFT OUTER JOIN aggregator.transaction_details d
							ON a.transactionId = d.transactionId AND d.xpath = 'health/contactDetails/contactNumber'
						LEFT OUTER JOIN aggregator.transaction_details mobileNumber
							ON a.transactionId = mobileNumber.transactionId AND mobileNumber.xpath = 'health/contactDetails/contactNumber/mobile'
						WHERE a.transactionId > '${limitId}'
						AND a.productType = 'HEALTH'
						AND ? IN (b.textValue,c.textValue,d.textValue)
						GROUP BY a.transactionId DESC
						LIMIT 25;
						<sql:param value="${searchPhrase}" />
					</sql:query>
					</c:when>

				<c:when test="${simplesMode eq 'PHONE'}">
					<go:log level="INFO" >SIMPLES SEARCH: PHONE MODE</go:log>
					<sql:query var="transactions">
						SELECT a.transactionID AS id, b.xpath, c.xpath, b.textValue, c.textValue
						FROM aggregator.transaction_header a
						LEFT OUTER JOIN aggregator.transaction_details b
							ON a.transactionId = b.transactionId AND b.xpath = 'health/contactDetails/contactNumber'
						LEFT OUTER JOIN aggregator.transaction_details otherNumber
							ON a.transactionId = otherNumber.transactionId AND otherNumber.xpath = 'health/contactDetails/contactNumber/other'
						LEFT OUTER JOIN aggregator.transaction_details c
							ON a.transactionId = c.transactionId AND c.xpath = 'health/application/other'
						WHERE a.transactionId > '${limitId}'
						AND a.productType = 'HEALTH'
						AND ? IN (b.textValue,c.textValue)
						GROUP BY a.transactionId DESC
						LIMIT 25;
						<sql:param value="${searchPhrase}" />
					</sql:query>
			</c:when>

				<c:when test="${simplesMode eq 'TRANS'}">
					<go:log level="INFO" >SIMPLES SEARCH: TRANSACTION ID NODE</go:log>
				<sql:query var="transactions">
					SELECT transactionId AS id
					FROM aggregator.transaction_header
					WHERE transactionId > '${limitId}'
					AND productType = 'HEALTH'
					AND ? IN (rootId,TransactionID,PreviousId)
					<sql:param value="${searchPhrase}" />
				</sql:query>
			</c:when>

				<c:when test="${simplesMode eq 'EMAIL'}">
					<go:log level="INFO" >SIMPLES SEARCH: EMAIL MODE</go:log>
					<sql:query var="transactions">
						SELECT a.transactionID AS id
						FROM aggregator.transaction_header a
						LEFT OUTER JOIN aggregator.transaction_details b
							ON a.transactionId = b.transactionId AND b.xpath = 'health/contactDetails/email'
						LEFT OUTER JOIN aggregator.transaction_details c
							ON a.transactionId = c.transactionId AND c.xpath = 'health/application/email'
						WHERE a.transactionId > '${limitId}'
						AND a.productType = 'HEALTH'
						AND ? IN (a.emailAddress, b.textValue,c.textValue)
						GROUP BY a.transactionId DESC
						LIMIT 25;
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
								SELECT a.transactionID AS id, b.textValue, e.textValue,d.textValue, f.textValue,c.textValue
								FROM aggregator.transaction_header a
								LEFT OUTER JOIN aggregator.transaction_details b
									ON a.transactionId = b.transactionId AND b.xpath = 'health/contactDetails/name'
								LEFT OUTER JOIN aggregator.transaction_details c
									ON a.transactionId = c.transactionId AND c.xpath = 'health/application/primary/surname'
								LEFT OUTER JOIN aggregator.transaction_details d
									ON a.transactionId = d.transactionId AND d.xpath = 'health/contactDetails/lastname'
								LEFT OUTER JOIN aggregator.transaction_details e
									ON a.transactionId = e.transactionId AND e.xpath = 'health/contactDetails/firstname'
								LEFT OUTER JOIN aggregator.transaction_details f
									ON a.transactionId = f.transactionId AND f.xpath = 'health/application/primary/firstname'
								WHERE a.transactionId > '${limitId}'
								AND a.productType = 'HEALTH'
								AND (
									b.textValue LIKE ?
									OR
									CONCAT_WS(e.textValue,d.textValue) LIKE ?
									OR
									CONCAT_WS(f.textValue,c.textValue) LIKE ?

								)
								GROUP BY a.transactionId DESC
								LIMIT 25;
								<sql:param>${searchPhraseFirstName}%${searchPhraseLastName}%</sql:param>
								<sql:param>${searchPhraseFirstName}%${searchPhraseLastName}%</sql:param>
								<sql:param>${searchPhraseFirstName}%${searchPhraseLastName}%</sql:param>
							</sql:query>
						</c:when>
						<c:otherwise>
							<%-- SURNAME mode --%>
							<go:log level="INFO" >SIMPLES SEARCH: SURNAME MODE</go:log>

							<sql:query var="transactions">
								SELECT a.transactionID AS id
								FROM aggregator.transaction_header a
								LEFT OUTER JOIN aggregator.transaction_details b
									ON a.transactionId = b.transactionId AND b.xpath = 'health/contactDetails/name'
								LEFT OUTER JOIN aggregator.transaction_details c
									ON a.transactionId = c.transactionId AND c.xpath = 'health/application/primary/surname'
								LEFT OUTER JOIN aggregator.transaction_details d
									ON a.transactionId = d.transactionId AND d.xpath = 'health/contactDetails/lastname'
								WHERE a.transactionId > '${limitId}'
								AND a.productType = 'HEALTH'
								AND (
									b.textValue LIKE ?
									OR
									c.textValue LIKE ?
									OR
									c.textValue LIKE ?
								)
								GROUP BY a.transactionId DESC
								LIMIT 25;
								<sql:param>%${searchPhrase}%</sql:param>
								<sql:param>${searchPhrase}%</sql:param>
								<sql:param>${searchPhrase}%</sql:param>
							</sql:query>
						</c:otherwise>
					</c:choose>
			</c:otherwise>
		</c:choose>

		<%-- Refine the Transaction ID list with the necessary item --%>
		<c:choose>
			<c:when test="${empty errorPool && (transactions.rowCount > 0 || not empty tranIds)}">

						<%--Store the transactionIds found in a comma delimited list --%>
				<c:if test="${empty tranIds && not empty transactions}">
						<c:set var="tranIds" value="" />
						<c:forEach var="tid" items="${transactions.rows}">
						<c:if test="${not empty tranIds}">
							<c:set var="tranIds" value="${tranIds}," />
						</c:if>
							<c:set var="tranIds" value="${tranIds}${tid.id}" />
						</c:forEach>
				</c:if>

				<go:log level="INFO">
				TRAN IDS = ${tranIds}
				</go:log>
<%--
				<go:log>
						SELECT th.styleCodeId as styleCodeId, th.TransactionId AS id, th.rootId, th.EmailAddress AS email, th.StartDate AS quoteDate, th.StartTime AS quoteTime, th.ProductType AS productType,
							CASE
								-- If tran is not the latest then don't mark it as Failed (F)
								WHEN COALESCE(MAX(th2.transactionid),th.TransactionId) <> th.TransactionId
								THEN COALESCE(t1.type,1)
								ELSE COALESCE(t1.type,t2.type,1)
								END AS editable,
							COALESCE(MAX(th2.transactionid),th.TransactionId) AS latestID
						FROM aggregator.transaction_header th
						LEFT JOIN ctm.touches t1 ON (t1.transaction_Id > ${limitId}) AND (th.TransactionId = t1.transaction_id) AND (t1.type = 'C')
						LEFT JOIN ctm.touches t2 ON (t2.transaction_Id > ${limitId}) AND (th.TransactionId = t2.transaction_id) AND (t2.type = 'F')
						LEFT JOIN aggregator.transaction_header th2 ON th2.rootId = th.rootId
					WHERE th.TransactionId IN (${tranIds})
						AND th.transactionId > ${limitId}
						GROUP BY id
						ORDER BY th.TransactionID DESC;
				</go:log>
--%>
				<%-- Now consolidate the results ---%>
				<sql:query var="transactions">
						SELECT th.styleCodeId as styleCodeId, th.TransactionId AS id, th.rootId, th.EmailAddress AS email, th.StartDate AS quoteDate, th.StartTime AS quoteTime, th.ProductType AS productType,
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
					WHERE th.TransactionId IN (${tranIds})
						AND th.transactionId > ?
						GROUP BY id
					ORDER BY th.TransactionID DESC;
						<sql:param>${limitId}</sql:param>
						<sql:param>${limitId}</sql:param>
						<sql:param>${limitId}</sql:param>
				</sql:query>
			</c:when>
			<c:otherwise>
				<c:set var="errorPool">${errorPool}{"error":"Pre-Qualifying search has found no results"}</c:set>
			</c:otherwise>
		</c:choose>
		</sql:transaction>
	</c:otherwise>

</c:choose>

<%-- Now Check if we can continue with creating the search --%>
<c:if test="${empty errorPool && transactions.rowCount > 0}">

	<%--Store the transactionIds found in a comma delimited list --%>

	<go:log level="INFO">
		TranIds = ${tranIds}
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
							<sql:query var="results">
								SELECT details.transactionId, details.xpath,  details.productType, details.textValue
								FROM aggregator.health_transaction_details  AS details
								WHERE details.transactionId IN (${tranIds})
								ORDER BY transactionId DESC;
							</sql:query>
						</c:catch>

						<%-- Test for DB issue and handle - otherwise move on --%>
						<c:choose>
							<c:when test="${not empty error}">
			<go:log level="ERROR" error="${error}">${error}</go:log>
								<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
								<c:set var="errorPool">${errorPool}{"error":"A database error occurred getting search results."}</c:set>
							</c:when>
							<c:when test="${not empty results and results.rowCount > 0}">

								<c:set var="group" value="" />

			<%-- No way to know if we'll have any health results so let's
									 just retrieve health cover codes and descriptions --%>
			<sql:transaction>
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
			</sql:transaction>

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
								<c:set var="errorPool">${errorPool}{"error":"No content found for the quotes located in the search."}</c:set>
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
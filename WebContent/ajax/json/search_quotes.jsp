<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<go:setData dataVar="data" xpath="search_results" value="*DELETE" />

<go:log>Search Quotes: ${param}</go:log>

<c:set var="errorPool" value="" /> 

<c:choose>
	<c:when test="${empty param.search_terms and not empty data.login.user.uid}">
		<c:set var="search_terms" value="${data.login.user.uid}" />
	</c:when>
	<c:otherwise>
		<c:set var="search_terms" value="${param.search_terms}" />
	</c:otherwise>
</c:choose>

<go:log>Search Terms: ${search_terms}</go:log>

<%-- Store flag as to whether Simples Operator or Other --%>
<c:set var="isOperator"><c:if test="${not empty data['login/user/uid']}">${data['login/user/uid']}</c:if></c:set>
<go:log>isOperator: ${isOperator}</go:log>

<c:choose>
	<c:when test="${not empty param.simples and empty isOperator}">
		<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
		<c:set var="errorPool">${errorPool}{"error":"login"}</c:set>
	</c:when>
	<c:otherwise>
		<c:choose>
			<%-- Fail if no search terms provided --%>
			<c:when test="${empty search_terms}">
				<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
				<c:set var="errorPool">${errorPool}{"error":"No search terms provided."}</c:set>
			</c:when>
			<c:otherwise>

				<%-- Build up lists to be used in search SQL --%>
				<c:set var="search_full_regexp" value="${search_terms}" />
				<c:set var="search_full_in" value="'${search_terms}'" />
				<c:set var="search_partial_regexp" value="" />
				<c:set var="search_partial_in" value="" />
				<c:forTokens var="term" items="${search_terms}" delims=" ">
					<c:if test="${not empty term}">
						<c:if test="${not empty search_partial_regexp}"><c:set var="search_partial_regexp">${search_partial_regexp}|</c:set></c:if>
						<c:set var="search_partial_regexp">${search_partial_regexp}${term}</c:set>			
						<c:if test="${not empty search_partial_in}"><c:set var="search_partial_in">${search_partial_in},</c:set></c:if>
						<c:set var="search_partial_in">${search_partial_in}LCASE('${term}')</c:set>
					</c:if>
				</c:forTokens>

				<go:log>Full IN: ${search_full_in}</go:log>
				<go:log>Full RegExp: ${search_full_regexp}</go:log>
				<go:log>Partial IN: ${search_partial_in}</go:log>
				<go:log>Partial RegExp: ${search_partial_regexp}</go:log>

				<%-- Execute the search and locate relevant transactions --%>	
				<c:catch var="error">
					<sql:query var="transactions">
						SELECT 
							header.TransactionId AS id,
							header.rootId AS rootId,
							header.ProductType AS productType,
							header.StartDate AS quoteDate, 
							header.StartTime AS quoteTime,
							header.EmailAddress AS email,
							header.editable AS editable,
							<%-- SEARCH WHOLE TERM --%>
							IF(LCASE(header.rootId) IN (${search_full_in}), 2, IF(LCASE(header.rootId) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS root_full_test,
							IF(LCASE(header.TransactionId) IN (${search_full_in}), 2, IF(LCASE(header.TransactionId) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS transaction_full_test,
							IF(LCASE(header.EmailAddress) IN (${search_full_in}), 2, IF(LCASE(header.EmailAddress) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS email1_full_test,
							IF(LCASE(details.quoteEmail) IN (${search_full_in}), 2, IF(LCASE(details.quoteEmail) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS email2_full_test,
							IF(LCASE(details.appEmail) IN (${search_full_in}), 2, IF(LCASE(details.appEmail) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS email3_full_test,
							IF(LCASE(details.quoteName) IN (${search_full_in}), 2, IF(LCASE(details.quoteName) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS name1_full_test,
							IF(LCASE(details.appName) IN (${search_full_in}), 2, IF(LCASE(details.appName) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS name2_full_test,
							IF(LCASE(details.quotePhone) IN (${search_full_in}), 2, IF(LCASE(details.quotePhone) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS phone1_full_test,
							IF(LCASE(details.appMobile) IN (${search_full_in}), 2, IF(LCASE(details.appMobile) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS phone2_full_test,
							IF(LCASE(details.appPhone) IN (${search_full_in}), 2, IF(LCASE(details.appPhone) REGEXP LCASE('${search_full_regexp}'), 1, 0)) AS phone3_full_test,
							<%-- SEARCH PARTIAL TERM --%>
							IF(LCASE(details.quoteName) IN (${search_partial_in}), 2, IF(LCASE(details.quoteName) REGEXP LCASE('${search_partial_regexp}'), 1, 0)) AS name1_partial_test,
							IF(LCASE(details.appName) IN (${search_partial_in}), 2, IF(LCASE(details.appName) REGEXP LCASE('${search_partial_regexp}'), 1, 0)) AS name2_partial_test
						FROM aggregator.health_search_transaction_header_inc_status AS header
						LEFT JOIN aggregator.email_master AS email
							ON header.EmailAddress = email.emailAddress
						LEFT JOIN aggregator.health_search_transaction_details AS details
							ON header.TransactionId = details.transactionId
						WHERE
							header.ProductType IN ('HEALTH','LIFE','IP') AND 
						(
							DATEDIFF(CURDATE(), header.StartDate) < 30 OR 
							header.editable = '0'
						) AND
						(
							<%-- WHERE WHOLE TERM --%>
							header.TransactionId IN (${search_full_in}) OR 
							header.TransactionId REGEXP LCASE('${search_full_regexp}') OR
							header.rootId IN (${search_full_in}) OR 
							header.rootId REGEXP LCASE('${search_full_regexp}') OR
							header.EmailAddress IN (${search_full_in}) OR 
							header.EmailAddress REGEXP LCASE('${search_full_regexp}') OR
							details.quoteName IN (${search_full_in}) OR
							details.quoteName REGEXP LCASE('${search_full_regexp}') OR
							details.appName IN (${search_full_in}) OR
							details.appName REGEXP LCASE('${search_full_regexp}') OR
							details.quoteEmail IN (${search_full_in}) OR
							details.quoteEmail REGEXP LCASE('${search_full_regexp}') OR
							details.appEmail IN (${search_full_in}) OR
							details.appEmail REGEXP LCASE('${search_full_regexp}') OR
							details.quotePhone IN (${search_full_in}) OR
							details.quotePhone REGEXP LCASE('${search_full_regexp}') OR
							details.appMobile IN (${search_full_in}) OR
							details.appMobile REGEXP LCASE('${search_full_regexp}') OR
							details.appPhone IN (${search_full_in}) OR
							details.appPhone REGEXP LCASE('${search_full_regexp}') OR
							<%-- SEARCH PARTIAL TERM --%>
							details.quoteName IN (${search_partial_in}) OR
							details.quoteName REGEXP LCASE('${search_partial_regexp}') OR
							details.appName IN (${search_partial_in}) OR
							details.appName REGEXP LCASE('${search_partial_regexp}')
						)
						GROUP BY header.transactionId
						HAVING  root_full_test > 0 OR transaction_full_test > 0 OR 
								email1_full_test > 0 OR email2_full_test > 0 OR email3_full_test > 0 OR 
								name1_full_test > 0 OR name2_full_test > 0 OR 				
								phone1_full_test > 0 OR phone2_full_test > 0 OR phone3_full_test > 0 OR 				
								name1_partial_test > 0 OR name2_partial_test > 0
						ORDER BY 
								header.rootId DESC,
								header.TransactionId DESC,
								CASE WHEN root_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN transaction_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN email1_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN email2_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN email3_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN name1_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN name2_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN phone1_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN phone2_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN phone3_full_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN email1_full_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN email2_full_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN email3_full_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN phone1_full_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN phone2_full_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN phone3_full_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN name1_full_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN name2_full_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN name1_partial_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN name2_partial_test = 2 THEN 1 ELSE 0 END DESC,
								CASE WHEN name1_partial_test = 1 THEN 1 ELSE 0 END DESC,
								CASE WHEN name2_partial_test = 1 THEN 1 ELSE 0 END DESC
						LIMIT 50;
					</sql:query>
				</c:catch>

				<%-- Test for DB issue and handle - otherwise move on --%>
				<c:choose>
					<c:when test="${not empty error}">
						<go:log>${error}</go:log>
						<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
						<c:set var="errorPool">${errorPool}{"error":"A database error occurred while attempting to search."}</c:set>
					</c:when>
					<c:when test="${not empty transactions and transactions.rowCount > 0}">

						<%--Store the transactionIds found in a comma delimited list --%>
						<c:set var="tranIds" value="" />

						<c:forEach var="tid" items="${transactions.rows}">
							<c:if test="${not empty tranIds}"><c:set var="tranIds" value="${tranIds}," /></c:if>
							<c:set var="tranIds" value="${tranIds}${tid.id}" />
						</c:forEach>

						<c:forEach var="tid" items="${transactions.rows}">
							<%-- Inject base quote details the quote --%>
							<c:set var="quoteXml">
								<${fn:toLowerCase(tid.productType)}>
									<id>${tid.id}</id>
									<rootid>${tid.rootId}</rootid>
									<email>${tid.email}</email>
									<quoteDate>${tid.quoteDate}</quoteDate>
									<quoteTime>${tid.quoteTime}</quoteTime>
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
								<go:log>${error}</go:log>
								<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
								<c:set var="errorPool">${errorPool}{"error":"A database error occurred getting search results."}</c:set>
							</c:when>
							<c:when test="${not empty results and results.rowCount > 0}">

								<c:set var="group" value="" />

								<%-- No way to know if we'll have any health results to let's
									 just retrieve health cover codes and descriptions --%>
								<sql:setDataSource dataSource="jdbc/test"/>
								<sql:query var="health_cover">
									SELECT * FROM test.health_cover;
								</sql:query>

								<%-- Retrieve health situation codes and descriptions --%>
								<sql:query var="health_situ">
									SELECT * FROM test.health_situation;
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
								<c:set var="errorPool">${errorPool}{"error":"No content found for the quotes located in the search."}</c:set>
							</c:otherwise>
						</c:choose>

					</c:when>
					<c:otherwise>
						<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
						<c:set var="errorPool">${errorPool}{"error":"No results found with the search terms provided."}</c:set>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>	
	</c:otherwise>
</c:choose>

<%-- Return output as json --%>
<c:choose>
	<c:when test="${empty errorPool}">
		${go:XMLtoJSON(go:getEscapedXml(data['search_results']))}
		<go:setData dataVar="data" xpath="search_results" value="*DELETE" />
	</c:when>
	<c:otherwise>
		{errors:[${errorPool}]}
	</c:otherwise>
</c:choose>
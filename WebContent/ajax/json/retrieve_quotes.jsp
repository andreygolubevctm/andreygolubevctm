<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%--
	retrieve_quotes.jsp
	
	Calls NTAGGTPQ to retrieve a list of previous quotes completed by the client as a JSON object.
	If no quotes are available or the password is incorrect, errors are returned in the JSON object
	
	@param email - The client's email address
	@param password - The client's password 
	 
--%>

<c:set var="parm" value="<data><email>${param.email}</email><password>${param.password}</password></data>" />
<go:setData dataVar="data" xpath="load/email" value="${param.email}" />
<go:log>DISC PARAMS: ${parm}</go:log>
<go:call pageId="AGGTPQ" wait="TRUE" xmlVar="${parm}" resultVar="quoteList" mode="P" style="CTM"/>

<go:setData dataVar="data" xpath="tmp" value="*DELETE" />
<go:setData dataVar="data" xpath="tmp" xml="${quoteList}" />
<sql:setDataSource dataSource="jdbc/aggregator"/>
<go:log>DISC QUOTELIST: ${quoteList}</go:log>
<go:log>XML at 1: ${data['tmp/previousQuotes']}</go:log>
<sql:query var="result">
	SELECT 
	emailAddress,
	emailPword
	FROM aggregator.email_master
	WHERE emailPword = ? and emailAddress = ?
	<sql:param>${param.password}</sql:param>
	<sql:param>${param.email}</sql:param>
</sql:query>

<c:choose>
	<c:when test="${not empty result and result.rowCount > 0}">
	
		<%-- If the quote list did not contain an error, get the email address --%>
		<c:if test="${not fn:contains(quoteList,'error')}">
			<go:setData dataVar="data" xpath="save/email" value="${param.email}" />
			<go:setData dataVar="data" xpath="save/password" value="${param.password}" />
		</c:if>
	
		<%-- Load in quotes from MySQL --%>
			
		<%--Find the latest transactionIds for the user --%>
		<sql:query var="transactions">
			SELECT DISTINCT th.TransactionId AS id, th.ProductType AS productType, 
			th.EmailAddress AS email, th.StartDate AS quoteDate, th.StartTime AS quoteTime
			FROM aggregator.transaction_header As th
			LEFT JOIN ctm.touches AS tch
				ON tch.transaction_id = th.TransactionId AND tch.type = 'S'
			WHERE EmailAddress = ? AND tch.type IS NOT NULL
			ORDER BY TransactionId DESC; 
			<sql:param>${param.email}</sql:param>
		</sql:query>
		
		<%-- Test for DB issue and handle - otherwise move on --%>
		<c:if test="${(not empty transactions) || (transactions.rowCount > 0) || (not empty transactions.rows[0].id)}">
			
			<%--Store the transactionIds found in comma delimetered list --%>
			<c:set var="tranIds" value="" />
			<c:forEach var="tid" items="${transactions.rows}">
				<c:if test="${not empty tranIds}"><c:set var="tranIds" value="${tranIds}," /></c:if>
				<c:set var="tranIds" value="${tranIds}${tid.id}" />
					
				<%-- Inject base quote details the quote --%>
				<c:set var="quoteXml">
					<${fn:toLowerCase(tid.productType)}>
						<id>${tid.id}</id>
						<email>${tid.email}</email>
						<quoteDate>${tid.quoteDate}</quoteDate>
						<quoteTime>${tid.quoteTime}</quoteTime>
						<quoteType>${fn:toLowerCase(tid.productType)}</quoteType>
					</${fn:toLowerCase(tid.productType)}>
				</c:set>
				<go:setData dataVar="data" xpath="tmp/previousQuotes/quote[@id=${tid.id}]" xml="${quoteXml}" />
			</c:forEach>
			
			<go:log>TranIDs: ${tranIds}</go:log>
			
			<%-- Get the details for each transaction found --%>
			<c:catch var="error">	
				<sql:query var="details">
					SELECT details.transactionId, 
					details.xpath, 
					header.ProductType AS productType, 
					details.textValue 
					FROM aggregator.transaction_details AS details
					RIGHT JOIN aggregator.transaction_header AS header
						ON details.transactionId = header.TransactionId
					WHERE details.transactionId IN (${tranIds}) 
					ORDER BY transactionId DESC, sequenceNo ASC;
		
				</sql:query>
			</c:catch>				
				 
			<%-- Test for DB issue and handle - otherwise move on --%>
			<c:if test="${empty error}">
				<c:set var="group" value="" />
						
				<%-- No way to know if we'll have any health results to let's
					 just retrieve health cover codes and descriptions --%>
				<sql:setDataSource dataSource="jdbc/test"/>
	
				<%-- Inject all the new quote details found --%>
				<c:forEach var="row" items="${details.rows}" varStatus="status">
					<c:if test="${row.xpath != 'small-env'}">
						<c:if test="${empty group or row.transactionId != group}">
							<c:set var="group" value="${row.transactionId}" />
						</c:if>
						
						<c:if test="${fn:startsWith(row.xpath, fn:toLowerCase(row.productType))}">
							<go:setData dataVar="data" xpath="tmp/previousQuotes/quote[@id=${row.transactionId}]/${row.xpath}" value="${row.textValue}" />
							
							<c:if test="${fn:toLowerCase(row.productType) eq 'health'}">
								<c:choose>
									<%-- Replace the health situation code with description --%>
									<c:when test="${row.xpath == 'health/situation/healthSitu' 
													or row.xpath == 'health/benefits/healthSitu'  
													or row.xpath == 'health/benefits/benefits/healthSitu'}">
													
										<sql:query var="health_situ">
											SELECT description FROM test.general 
											WHERE type = "healthSitu" 
											AND code='${row.textValue}'
											LIMIT 1
										</sql:query>
										<c:if test="${not empty health_situ && health_situ.rowCount > 0}">
											<go:setData dataVar="data" xpath="tmp/previousQuotes/quote[@id=${row.transactionId}]/${row.xpath}" value="${health_situ.rows[0].description}" />
										</c:if>
									</c:when>
									
									<%-- Replace the health cover codes with description --%>
									<c:when test="${row.xpath == 'health/situation/healthCvr' }">
									
										<sql:query var="health_cover">
											SELECT description FROM test.general 
											WHERE type = "healthCvr" 
											AND code='${row.textValue}'
											LIMIT 1
										</sql:query>
										<c:if test="${not empty health_cover && health_cover.rowCount > 0}">
											<go:setData dataVar="data" xpath="tmp/previousQuotes/quote[@id=${row.transactionId}]/${row.xpath}" value="${health_cover.rows[0].description}" />
										</c:if>
									</c:when>
								</c:choose>
							</c:if>
						</c:if>
					</c:if>
				</c:forEach>
				
				<%-- TODO: Do some xsl magic to order the quotes by date --%>
			</c:if>
		</c:if>
		<go:log>RETRIEVE QUOTES COMPILED: ${data.tmp}</go:log>
		
		<go:log>XML at 2: ${go:getEscapedXml(data['tmp/previousQuotes'])}</go:log>
		<%-- Return the results as json --%>
		${go:XMLtoJSON(go:getEscapedXml(data['tmp/previousQuotes']))}
		<go:setData dataVar="data" xpath="tmp" value="*DELETE" />
	
	</c:when>
	<c:otherwise>[{"error":"Failed to locate any quotes with those credentials"}]</c:otherwise>
</c:choose>
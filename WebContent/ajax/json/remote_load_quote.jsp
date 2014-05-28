<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" />

<%--
	load_quote.jsp

	Loads a previously completed quote, using the email address stored in data['current/email']
	This allows us to prevent people from being able to tamper with other peoples quotes, and this value
	can only be set by us server-side.

	@param action - Action to perform either "change" existing quote or "load" quote straight to results page


	TODO:
		- Change the program being called, or add parameter processing.
		- Add return codes/error message if it fails
		- Add code specifically to "load" to force jump to end
--%>


<%--
//REFINE:
- need to clean up go logs
- need to have better handling on DISC or MySQL based quotes
- need better handling for deleting the base xpath information (and better handling for save email etc.)
--%>

<go:log level="INFO" source="remote_load_quote_jsp" >LOAD QUOTE: ${param}</go:log>
<c:set var="id_for_access_check">
	<c:choose>
		<c:when test="${not empty param.id}">${param.id}</c:when>
		<c:when test="${not empty param.transactionId}">${param.transactionId}</c:when>
	</c:choose>
</c:set>

<c:set var="emailHash">
	<c:choose>
		<c:when test="${not empty param.hash}">${param.hash}</c:when>
	</c:choose>
</c:set>

<c:set var="quoteType" value="${param.vertical}" />

		<%-- First check owner of the quote --%>
		<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" tranid="${id_for_access_check}" /></c:set>
		<c:choose>
			<c:when test="${not empty proceedinator and proceedinator > 0}">
				<go:log source="remote_load_quote_jsp">PROCEEDINATOR PASSED</go:log>

				<c:set var="requestedTransaction" value="${id_for_access_check}" />

				<sql:setDataSource dataSource="jdbc/aggregator"/>

				<%-- 30/1/13: Increment TranID when 'ANYONE' opens a quote --%>
				<c:set var="id_handler" value="increment_tranId" />
				<c:if test="${param.action eq 'confirmation'}">
					<c:set var="id_handler" value="preserve_tranId" />
				</c:if>

				<c:set var="sandpit">
					<core:get_transaction_id quoteType="${quoteType}" id_handler="${id_handler}" transactionId="${requestedTransaction}"/>
				</c:set>

				<go:setData dataVar="data" xpath="previous/transactionId" value="${requestedTransaction}" />
				<%--<c:set var="requestedTransaction" value="${data.current.transactionId}" />--%>
				<go:log source="remote_load_quote_jsp" >TRAN ID NOW (data.current.transactionId): ${data.current.transactionId}</go:log>

				<go:log source="remote_load_quote_jsp" >========================================</go:log>
				<%-- Now we get back to basics and load the data for the requested transaction --%>
				<c:catch var="error">
			<%-- Added styleCodeId to link email_master --%>
			<%-- Added extracting styleCodeId to allow setting branding off transaction --%>
							<sql:query var="details">
								SELECT th.styleCodeId, td.transactionId, xpath, textValue
								FROM aggregator.transaction_details td
								INNER JOIN aggregator.transaction_header th ON td.transactionId = th.transactionId
				<c:choose>
					<c:when test="${param.vertical eq 'health' and not empty param.type and param.type eq 'bestprice' }">
					<%-- For Health Best Price confirm the email address matches the xpath rather than transaction_header
						as header value can be overwritten if save quote with different email address --%>
				INNER JOIN aggregator.transaction_details td2 ON td.transactionId = td2.transactionId AND td2.xpath = 'health/contactDetails/email'
				INNER JOIN aggregator.email_master em ON td2.textValue=em.emailAddress
					</c:when>
					<c:otherwise>
								INNER JOIN aggregator.email_master em ON th.emailAddress=em.emailAddress
					</c:otherwise>
				</c:choose>
								    AND  th.styleCodeId=em.styleCodeId
								WHERE th.transactionId = ?
								AND em.hashedEmail = ?
								ORDER BY sequenceNo ASC;
								<sql:param value="${requestedTransaction}" />
								<sql:param value="${emailHash}" />
							</sql:query>
				</c:catch>

				<c:choose>
					<c:when test="${not empty error}">
						<go:log level="ERROR" error="${error}">${error}</go:log>
						<c:set var="result"><result><error>Error loading quote data: ${error.rootCause}</error></result></c:set>
					</c:when>
			<c:when test="${details.rowCount eq 0}">
						<c:set var="result"><result><error>No transaction data exists for transaction [${requestedTransaction}] and hash [${emailHash}] combination.</error></result></c:set>
			</c:when>
					<c:otherwise>
					<go:log source="remote_load_quote_jsp" level="DEBUG">About to delete the vertical information for: ${quoteType} ${requestedTransaction}</go:log>

					<%-- //FIX: need to delete the bucket of information here --%>
					<go:setData dataVar="data" value="*DELETE" xpath="${quoteType}" />

					<c:forEach var="row" items="${details.rows}" varStatus="status">
							<c:set var="textVal">
								<c:choose>
									<c:when test="${fn:contains(row.textValue,'Please choose')}"></c:when>
									<c:otherwise>${row.textValue}</c:otherwise>
								</c:choose>
							</c:set>
							<go:setData dataVar="data" xpath="${row.xpath}" value="${textVal}" />
					</c:forEach>

				<%-- Set the current transaction id to the one passed so it is set as the prev tranId--%>
				<go:log source="remote_load_quote_jsp" >Setting data.current.transactionId back to ${requestedTransaction}</go:log>
				<go:setData dataVar="data" xpath="current/transactionId" value="${requestedTransaction}" />
				<go:log source="remote_load_quote_jsp">data[param.vertical].privacyoptin: ${data[param.vertical].privacyoptin}</go:log>
				<c:set var="result">
					<result>
						<c:choose>

								<%-- GET HEALTH RESULTS --%>
								<c:when test="${param.action=='load' and param.vertical eq 'health'}">
								<go:setData dataVar="data" xpath="userData/emailSent" value="true" />
									<destUrl>${param.vertical}_quote.jsp?action=load&amp;transactionId=${data.current.transactionId}#results</destUrl>
								</c:when>

						<%-- AMEND QUOTE --%>
						<c:when test="${param.action=='amend' || param.action=='start-again'}">
							<destUrl>${param.vertical}_quote.jsp?action=${param.action}&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- BACK TO START IF PRIVACYOPTIN HASN'T BEEN TICKED FOR OLD QUOTES --%>
						<c:when test="${(param.action=='latest' || param.action=='load') && data[param.vertical].privacyoptin!='Y'}">
							<destUrl>${param.vertical}_quote.jsp?action=start-again&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- GET TRAVEL MULTI-TRIP --%>
						<c:when test="${(param.action=='latest' || param.action=='load') && param.vertical=='travel' && param.type=='A'}">
							<c:if test="${not empty param.newDate and param.newDate != ''}">
								<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
							</c:if>
							<destUrl>travel_quote.jsp?type=A&amp;action=results&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- GET LATEST --%>
						<c:when test="${param.action=='latest' || param.action=='load'}">
							<c:if test="${not empty param.newDate and param.newDate != ''}">
								<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
							</c:if>
							<destUrl>${param.vertical}_quote.jsp?action=results&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- GET CONFIRMATION --%>
						<c:when test="${param.action=='confirmation'}">
							<destUrl>no url required for confirmation loading</destUrl>
						</c:when>

						<%-- ERROR --%>
						<c:otherwise>
							<error>INVALID_ACTION</error>
						</c:otherwise>
						</c:choose>
					</result>
				</c:set>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<go:log source="remote_load_quote_jsp" level="WARN">Proceedinator:${proceedinator}</go:log>
				<c:set var="result">
					<result><error>This quote has been reserved by another user. Please try again later.</error></result>
				</c:set>
			</c:otherwise>
		</c:choose>
<go:log>${result}</go:log>
<go:log source="remote_load_quote_jsp">End Load Quote</go:log>
<go:log source="remote_load_quote_jsp">LOAD RESULT: ${result}</go:log>
<%-- Return the results as json --%>
${go:XMLtoJSON(result)}
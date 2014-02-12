<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
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

<go:log  level="INFO" >LOAD QUOTE: ${param}</go:log>
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
				<go:log>TRAN ID NOW (data.current.transactionId): ${data.current.transactionId}</go:log>

				<go:log>========================================</go:log>
				<%-- Now we get back to basics and load the data for the requested transaction --%>

				<c:catch var="error">

							<sql:query var="details">
								SELECT td.transactionId, xpath, textValue
								FROM aggregator.transaction_details td
								INNER JOIN aggregator.transaction_header th ON td.transactionId = th.transactionId
								INNER JOIN aggregator.email_master em ON th.emailAddress=em.emailAddress
								WHERE th.transactionId = ?

								AND em.hashedEmail = ?
								ORDER BY sequenceNo ASC;
								<sql:param value="${requestedTransaction}" />
								<sql:param value="${emailHash}" />
							</sql:query>

					<go:log>About to delete the vertical information for: ${quoteType} ${requestedTransaction}</go:log>

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
				</c:catch>
				<c:if test="${not empty error}">
					<go:log level="ERROR" error="${error}">${error}</go:log>
				</c:if>

				<%-- Set the current transaction id to the one passed so it is set as the prev tranId--%>
				<go:log>Setting data.current.transactionId back to ${requestedTransaction}</go:log>
				<go:setData dataVar="data" xpath="current/transactionId" value="${requestedTransaction}" />
				<c:set var="result">
					<result>
						<c:choose>

						<%-- AMEND QUOTE --%>
						<c:when test="${param.action=='amend' || param.action=='start-again'}">
							<destUrl>${param.vertical}_quote.jsp?action=${param.action}&amp;transactionId=${data.current.transactionId}</destUrl>
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
			</c:when>
			<c:otherwise>
				<go:log>Proceedinator:${proceedinator}</go:log>
				<c:set var="result">
					<result><error>This quote has been reserved by another user. Please try again later.</error></result>
					<%-- //FIX: release this with the next largest batch of items.
					<result><error><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></error></result>
					--%>
				</c:set>
			</c:otherwise>
		</c:choose>

<go:log>End Load Quote</go:log>
<go:log>LOAD RESULT: ${result}</go:log>
<%-- Return the results as json --%>
${go:XMLtoJSON(result)}
<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" verticalCode="${param.vertical}" />
<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

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

<go:log level="DEBUG" source="remote_load_quote_jsp">LOAD QUOTE: ${param}</go:log>
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

<c:set var="xpathQuoteType">
	<c:choose>
		<c:when test="${quoteType eq 'car'}">quote</c:when>
		<c:otherwise>${quoteType}</c:otherwise>
	</c:choose>
</c:set>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" tranid="${id_for_access_check}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log level="INFO" source="remote_load_quote_jsp">PROCEEDINATOR PASSED for quoteType:${quoteType} tranId:${id_for_access_check}</go:log>

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
		<go:log level="INFO" source="remote_load_quote_jsp">TRAN ID NOW (data.current.transactionId): ${data.current.transactionId}</go:log>
		<%-- Now we get back to basics and load the data for the requested transaction --%>
		<jsp:useBean id="remoteLoadQuoteService" class="com.ctm.services.RemoteLoadQuoteService" scope="page" />

				<c:catch var="error">
			<c:set var="details" value="${remoteLoadQuoteService.getTransactionDetails(emailHash, quoteType, param.type, param.email, requestedTransaction, styleCodeId)}" />
				</c:catch>

				<c:choose>
					<c:when test="${not empty error}">
						<go:log level="ERROR" error="${error}">${error}</go:log>
						<c:set var="result"><result><error>Error loading quote data: ${error.rootCause}</error></result></c:set>
					</c:when>
			<c:when test="${empty details}">
						<c:set var="result"><result><error>No transaction data exists for transaction [${requestedTransaction}] and hash [${emailHash}] combination.</error></result></c:set>
			</c:when>
			<c:otherwise>
				<go:log level="DEBUG" source="remote_load_quote_jsp">About to delete the vertical information for: ${quoteType} ${requestedTransaction}</go:log>

				<%-- //FIX: need to delete the bucket of information here --%>
				<go:setData dataVar="data" value="*DELETE" xpath="${xpathQuoteType}" />

				<c:forEach var="detail" items="${details}" varStatus="status">
							<c:set var="textVal">
						<c:if test="${!fn:contains(detail.getTextValue(),'Please choose')}">${detail.getTextValue()}</c:if>
							</c:set>
					<go:setData dataVar="data" xpath="${detail.getXPath()}" value="${textVal}" />
					</c:forEach>

				<%-- Set the current transaction id to the one passed so it is set as the prev tranId--%>
				<go:log level="DEBUG" source="remote_load_quote_jsp">Setting data.current.transactionId back to ${requestedTransaction}</go:log>
				<go:log level="DEBUG" source="remote_load_quote_jsp">data[xpathQuoteType].privacyoptin: ${data[xpathQuoteType].privacyoptin}</go:log>

				<%-- Add CampaignId to the databucket if provided --%>
				<c:if test="${not empty param.campaignId}">
					<go:setData dataVar="data" xpath="${xpathQuoteType}/tracking/cid" value="${param.campaignId}" />
				</c:if>

				<c:set var="result">
					<result>
						<c:choose>

							<%-- GET HEALTH RESULTS --%>
							<c:when test="${param.action=='load' and quoteType eq 'health'}">
								<go:setData dataVar="data" xpath="userData/emailSent" value="true" />
								<c:choose>
									<c:when test="${not empty param.productId and param.productId != '' and not empty param.productTitle and param.productTitle != ''}">
										<destUrl>${quoteType}_quote.jsp?action=load&amp;transactionId=${data.current.transactionId}&amp;productId=${param.productId}&amp;productTitle=${param.productTitle}#results</destUrl>
									</c:when>
									<c:otherwise>
										<destUrl>${quoteType}_quote.jsp?action=load&amp;transactionId=${data.current.transactionId}#results</destUrl>
									</c:otherwise>
								</c:choose>
								</c:when>

						<%-- AMEND QUOTE --%>
						<c:when test="${param.action=='amend' || param.action=='start-again'}">
								<destUrl>${quoteType}_quote.jsp?action=${param.action}&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- BACK TO START IF PRIVACYOPTIN HASN'T BEEN TICKED FOR OLD QUOTES --%>
							<c:when test="${param.type != 'promotion' && (param.action=='latest' || param.action=='load') && data[xpathQuoteType].privacyoptin!='Y'}">
								<destUrl>${quoteType}_quote.jsp?action=start-again&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

							<%-- GET TRAVEL MULTI-TRIP --%>
							<c:when test="${(param.action=='latest' || param.action=='load') && quoteType=='travel' && param.type=='A'}">
								<c:if test="${not empty param.newDate and param.newDate != ''}">
									<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
								</c:if>

								<core:transaction touch="L" noResponse="true" />
								<destUrl>travel_quote.jsp?type=A&amp;action=latest&amp;transactionId=${data.current.transactionId}</destUrl>
								<go:setData dataVar="data" value="true" xpath="userData/emailSent"/>
						</c:when>

							<%-- EXPIRED COMMENCEMENT DATE --%>
							<c:when test="${param.action=='load' && not empty param.expired}">
								<go:setData dataVar="data" xpath="${xpathQuoteType}/options/commencementDate" value="${param.expired}" />
								<core:transaction touch="L" noResponse="true" />
								<c:set var="quotePagePrefix">
									<c:choose>
										<c:when test="${xpathQuoteType eq 'home'}">home_contents</c:when>
										<c:otherwise>${quoteType}</c:otherwise>
									</c:choose>
								</c:set>
								<c:set var="action">
								<c:choose>
										<c:when test="${param.type eq 'promotion'}">${param.type}</c:when>
										<c:otherwise>expired</c:otherwise>
								</c:choose>
								</c:set>
								<destUrl>${quotePagePrefix}_quote.jsp?action=${action}&amp;transactionId=${data.current.transactionId}</destUrl>
							</c:when>

							<%-- GET LATEST --%>
							<c:when test="${param.action=='latest' || param.action=='load'}">
								<c:if test="${not empty param.newDate and param.newDate != ''}">
									<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
								</c:if>

								<core:transaction touch="L" noResponse="true" />
								<destUrl>${quoteType}_quote.jsp?action=latest&amp;transactionId=${data.current.transactionId}</destUrl>
								<%-- Have only made this happen for travel --%>
								<c:if test="${quoteType eq 'travel'}">
									<go:setData dataVar="data" value="true" xpath="userData/emailSent"/>
								</c:if>
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
		<go:log level="WARN" source="remote_load_quote_jsp">Proceedinator:${proceedinator}</go:log>
				<c:set var="result">
					<result><error>This quote has been reserved by another user. Please try again later.</error></result>
				</c:set>
			</c:otherwise>
		</c:choose>
<go:log level="DEBUG" source="remote_load_quote_jsp">${result}</go:log>
<go:log level="DEBUG" source="remote_load_quote_jsp">End Load Quote</go:log>
<go:log level="DEBUG" source="remote_load_quote_jsp">LOAD RESULT: ${result}</go:log>
<%-- Return the results as json --%>
${go:XMLtoJSON(result)}
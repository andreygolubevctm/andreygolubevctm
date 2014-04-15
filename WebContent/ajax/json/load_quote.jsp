<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="${fn:toUpperCase(param.vertical)}" forceNew="true" authenticated="true" />

<%--
	load_quote.jsp

	Loads a previously completed quote, using the email address stored in data['current/email']
	This allows us to prevent people from being able to tamper with other peoples quotes, and this value
	can only be set by us server-side.

	@param action - Action to perform either "change" existing quote or "load" quote straight to results page


	TODO:
		- Change the program being called, or add parameter processing.
		- Add code specifically to "load" to force jump to end
--%>


<%--
//REFINE:
- need to clean up go logs
- need to have better handling on DISC or MySQL based quotes
- need better handling for deleting the base xpath information (and better handling for save email etc.)
--%>

<go:log source="load_quote_jsp" level="INFO" >LOAD QUOTE: ${param}</go:log>
<c:set var="id_for_access_check">
	<c:choose>
		<c:when test="${not empty param.transaction_id}">${param.transaction_id}</c:when>
		<c:when test="${not empty param.id}">${param.id}</c:when>
		<c:when test="${not empty param.transactionId}">${param.transactionId}</c:when>
	</c:choose>
</c:set>

<c:set var="quoteType" value="${param.vertical}" />

<%-- Store flag as to whether Simples Operator or Other --%>
<c:set var="isOperator"><c:if test="${not empty authenticatedData['login/user/uid']}">${authenticatedData['login/user/uid']}</c:if></c:set>
<go:log  level="INFO" >isOperator: ${isOperator}</go:log>

<c:choose>
	<c:when test="${not empty param.simples and empty isOperator}">
		<go:log  level="WARN" >Operator not logged in - force to login screen</go:log>
		<c:set var="result">
			<result><error>login</error></result>
		</c:set>
	</c:when>
	<c:when test="${empty isOperator and (empty authenticatedData.userData || empty authenticatedData.userData.authentication || !authenticatedData.userData.authentication.validCredentials)}">
		<go:log  level="WARN" >User not logged in - force to login screen</go:log>
		<c:set var="result">
			<result><error>login</error></result>
		</c:set>
	</c:when>
	<c:otherwise>
		<%-- First check owner of the quote --%>
		<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" tranid="${id_for_access_check}" /></c:set>
		<c:choose>
			<c:when test="${not empty proceedinator and proceedinator > 0}">
				<go:log  level="INFO" source="load_quote_jsp" >PROCEEDINATOR PASSED</go:log>

				<%-- Remove any old quote data --%>
				<go:setData dataVar="data" value="*DELETE" xpath="${param.vertical}" />

				<%-- Let's assign the param.id (transactionId) to a var we can manage (at least 'I' can manage) --%>
				<c:set var="requestedTransaction" value="${id_for_access_check}" />

				<%-- Call the iSeries program to fetch the quote details --%>
				<c:set var="parm">
					<c:choose>
						<%-- if Simples Operator set email to their UID otherwise use users email --%>
						<c:when test="${not empty isOperator}"><data><email>${isOperator}</email></data></c:when>
						<c:otherwise><data><email>${authenticatedData.userData.authentication.emailAddress}</email></data></c:otherwise>
					</c:choose>
				</c:set>
				<go:log  level="INFO" >requested TranID: ${requestedTransaction}</go:log>
				<go:log>params: ${param}</go:log>

				<sql:setDataSource dataSource="jdbc/aggregator"/>

				<%-- If is Simples Operator opening quote owned by a client then will need
					to duplicate the transaction and make the operator the owner --%>
				<%-- 30/1/13: Increment TranID when 'ANYONE' opens a quote --%>
				<c:set var="id_handler" value="increment_tranId" />
				<c:if test="${param.vertical == 'car' && param.action != 'amend'}">
					<c:set var="id_handler" value="preserve_tranId" />
				</c:if>

				<c:choose>
					<c:when test="${param.fromDisc}">
						<go:log  level="INFO" >Creating new transaction id</go:log>
						<go:setData dataVar="data" xpath="current/transactionId" value="*DELETE" />
						<c:set var="getTransactionID">
							<core:get_transaction_id  quoteType="${param.vertical}" />
						</c:set>
					</c:when>
					<c:otherwise>
						<c:set var="getTransactionID">
							<core:get_transaction_id
										quoteType="${param.vertical}"
										transactionId="${requestedTransaction}"
										id_handler="${id_handler}" />
						</c:set>
					</c:otherwise>
				</c:choose>
				<go:log  level="INFO" >TRAN ID NOW (data.current.transactionId): ${data.current.transactionId}</go:log>
				<%-- Now we get back to basics and load the data for the requested transaction --%>

				<c:set var="xpath" value="${quoteType}"/>
				<c:if test="${quoteType == 'car'}">
					<c:set var="xpath" value="quote"/>
				</c:if>
				<go:log level="INFO" >About to delete the vertical information for: ${quoteType}</go:log>
				<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />

						<c:catch var="error">
					<c:choose>
						<c:when test="${param.fromDisc}">
							<%--TODO: remove this once off Hybrid Mode --%>
							<go:log  level="INFO" >Loading AGGTXR for transID: ${requestedTransaction}</go:log>
							<%-- DISC requires the transId to be padded with zeros --%>
							<fmt:formatNumber pattern="000000000" value="${requestedTransaction}" var="requestedTransaction" />
							<go:call pageId="AGGTXR" resultVar="quoteXml" transactionId="${requestedTransaction}" xmlVar="parm" mode="P" />
							<go:log level="DEBUG">${quoteXml}</go:log>
							<%-- Remove the previous CAR data --%>
							<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
							<go:setData dataVar="data" xml="${quoteXml}" />
						</c:when>
						<c:when test="${not empty isOperator}">
							<sql:query var="details">
								SELECT td.transactionId, xpath, textValue
								FROM aggregator.transaction_details td
								WHERE td.transactionId = ?
								ORDER BY sequenceNo ASC;
								<sql:param value="${requestedTransaction}" />
							</sql:query>
						</c:when>
						<c:otherwise>
							<sql:query var="details">
								SELECT td.transactionId, xpath, textValue
								FROM aggregator.transaction_details td, aggregator.transaction_header th
								WHERE th.transactionId = ?
								AND td.transactionId = th.transactionId
								AND th.EmailAddress = ?
								ORDER BY sequenceNo ASC;
								<sql:param value="${requestedTransaction}" />
								<sql:param value="${authenticatedData.userData.authentication.emailAddress}" />
							</sql:query>
						</c:otherwise>
					</c:choose>

					<c:if test="${!param.fromDisc}">

							<c:forEach var="row" items="${details.rows}" varStatus="status">
								<c:set var="proceed">
									<c:choose>
										<c:when test="${fn:contains(row.xpath,'save/')}">${false}</c:when>
										<c:otherwise>${true}</c:otherwise>
									</c:choose>
								</c:set>
								<c:if test="${proceed}">
								<go:setData dataVar="data" xpath="${row.xpath}" value="*DELETE" />
									<c:set var="textVal">
										<c:choose>
											<c:when test="${fn:contains(row.textValue,'Please choose')}"></c:when>
											<c:otherwise>${row.textValue}</c:otherwise>
										</c:choose>
									</c:set>
								<c:choose>
									<%-- Handle legacy health quotes --%>
									<c:when test="${row.xpath == 'health/contactDetails/contactNumber'}">
										<c:choose>
											<c:when test="${fn:startsWith(textVal, '04')}">
												<go:setData dataVar="data" xpath="health/contactDetails/contactNumber/mobile" value="${textVal}" />
											</c:when>
											<c:otherwise>
												<go:setData dataVar="data" xpath="health/contactDetails/contactNumber/other" value="${textVal}" />
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
									<go:setData dataVar="data" xpath="${row.xpath}" value="${textVal}" />
									</c:otherwise>
								</c:choose>
								</c:if>
							</c:forEach>
					</c:if>
						</c:catch>

				<c:set var="result">
					<result>

						<c:set var="pageName" value="${param.vertical}_quote.jsp" />
						<c:if test="${param.vertical eq 'home'}">
							<c:set var="pageName" value="home_contents_quote.jsp" />
						</c:if>

						<c:choose>

						<c:when test="${not empty error}">
							<error><c:out value="${error}" /></error>
						</c:when>

						<c:when test="${empty data.current.transactionId}">
							<error>Transaction ID is empty. Your session may have been lost; please log in again.</error>
						</c:when>

						<%-- BACK TO START IF PRIVACYOPTIN HASN'T BEEN TICKED FOR OLD QUOTES (HEALTH)--%>
						<c:when test="${param.action=='amend' && param.vertical=='health' && data.health.privacyoptin!='Y'}">
							<core:transaction touch="L" noResponse="true" />
							<destUrl>${pageName}?action=start-again&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- AMEND QUOTE --%>
						<c:when test="${param.action=='amend' || param.action=='start-again'}">
							<core:transaction touch="L" noResponse="true" />
							<destUrl>${pageName}?action=${param.action}&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- BACK TO START IF PRIVACYOPTIN HASN'T BEEN TICKED FOR OLD QUOTES --%>
						<c:when test="${param.action=='latest' && data[xpath].privacyoptin!='Y'}">
							<core:transaction touch="L" noResponse="true" />
							<destUrl>${pageName}?action=start-again&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- GET LATEST --%>
						<c:when test="${param.action=='latest'}">
							<core:transaction touch="L" noResponse="true" />
							<%-- Was a new commencement date passed? --%>
							<c:if test="${not empty param.newDate and param.newDate != ''}">
								<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
							</c:if>
							<destUrl>${pageName}?action=latest&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>

						<%-- ERROR --%>
						<c:otherwise>
							<error>An invalid action was specified.</error>
						</c:otherwise>
						</c:choose>
					</result>
				</c:set>
			</c:when>
			<c:otherwise>
				<go:log  level="WARN" >Proceedinator:${proceedinator}</go:log>
				<c:set var="result">
					<result>
						<error>This quote has been reserved by another user. Please try again later.</error>
						<showToUser>true</showToUser>
					</result>
					<%-- //FIX: release this with the next largest batch of items.
					<result><error><core:access_get_reserved_msg isSimplesUser="${not empty authenticatedData.login.user.uid}" /></error></result>
					--%>
				</c:set>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
<go:log>### ${result}</go:log>
<%-- Log any errors --%>
<c:if test="${fn:contains(result, '<error>')}">
	<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
		<c:param name="transactionId" value="${data.current.transactionId}" />
		<c:param name="page" value="${pageContext.request.servletPath}" />
		<c:param name="message" value="LoadQuote error" />
		<c:param name="description" value="${result}" />
		<c:param name="data" value="action=${param.action} id_for_access_check=${id_for_access_check} quoteType=${quoteType} isOperator:${isOperator} fromDisc:${param.fromDisc}" />
	</c:import>

	<c:if test="${empty param.simples and empty isOperator and !fn:contains(result, '<showToUser>true')}">
		<c:set var="result"><result><error>An error occurred.</error></result></c:set>
	</c:if>
</c:if>

<go:log source="load_quote_jsp" >LOAD RESULT: ${result}</go:log>

<%-- Return the results as json --%>
${go:XMLtoJSON(result)}
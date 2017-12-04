<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.load_quote')}" />

<session:new verticalCode="${fn:toUpperCase(param.vertical)}" forceNew="true" authenticated="true" />
<jsp:useBean id="verticalSettings" class="com.ctm.web.core.model.settings.VerticalSettings" scope="page" />

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

<c:set var="styleCodeId" value="${pageSettings.getBrandId()}" />

${logger.debug('Begin LOAD QUOTE.',log:kv('param', param))}
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
${logger.info('Checking if user is authenticated. {},{}',log:kv('isOperator',isOperator ), log:kv('login/user/uid', authenticatedData['login/user/uid']))}

<c:choose>
	<c:when test="${not empty param.simples and empty isOperator}">
		${logger.warn('Operator not logged in - force to login screen. {},{}' , log:kv('simples',param.simples ) , log:kv('isOperator',isOperator ))}
		<c:set var="result">
			<result><error>login</error></result>
		</c:set>
	</c:when>
	<c:when test="${empty isOperator and (empty authenticatedData.userData || empty authenticatedData.userData.authentication || !authenticatedData.userData.authentication.validCredentials)}">
		${logger.warn('User not logged in - force to login screen {},{}', log:kv('isOperator',isOperator ), log:kv('userData',authenticatedData.userData ))}
		<c:set var="result">
			<result><error>login</error></result>
		</c:set>
	</c:when>
	<c:otherwise>
		<%-- First check owner of the quote --%>
		<c:set var="proceedinator"><core_v1:access_check quoteType="${quoteType}" tranid="${id_for_access_check}" /></c:set>
		<c:choose>
			<c:when test="${not empty proceedinator and proceedinator > 0}">
				${logger.debug('PROCEEDINATOR PASSED. {}', log:kv('proceedinator', proceedinator))}

				<%-- Remove any old quote data --%>
				<go:setData dataVar="data" value="*DELETE" xpath="${param.vertical}" />

				<%-- Let's assign the param.id (transactionId) to a var we can manage (at least 'I' can manage) --%>
				<c:set var="requestedTransaction" value="${id_for_access_check}" />

				<c:set var="parm">
					<c:choose>
						<%-- if Simples Operator set email to their UID otherwise use users email --%>
						<c:when test="${not empty isOperator}"><data><email>${isOperator}</email></data></c:when>
						<c:otherwise><data><email>${authenticatedData.userData.authentication.emailAddress}</email></data></c:otherwise>
					</c:choose>
				</c:set>
				${logger.info('About to load quote. {}, {}', log:kv('requestedTransaction',requestedTransaction), log:kv('user',parm))}
				${logger.debug('About to load quote. {}', log:kv('param',param))}

				<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

				<%-- If is Simples Operator opening quote owned by a client then will need
					to duplicate the transaction and make the operator the owner --%>
				<%-- 30/1/13: Increment TranID when 'ANYONE' opens a quote --%>
				<%-- 02/05/14: Increment TranID for CAR when retrieve quote [CAR-479]--%>
				<c:set var="id_handler" value="increment_tranId" />

				<c:choose>
					<c:when test="${param.fromDisc}">
						${logger.debug('Creating new transaction id')}
						<go:setData dataVar="data" xpath="current/transactionId" value="*DELETE" />
						<c:set var="getTransactionID">
							<core_v1:get_transaction_id  quoteType="${param.vertical}" />
						</c:set>
					</c:when>
					<c:otherwise>
						<c:set var="getTransactionID">
							<core_v1:get_transaction_id
										quoteType="${param.vertical}"
										transactionId="${requestedTransaction}"
										id_handler="${id_handler}" />
						</c:set>
					</c:otherwise>
				</c:choose>
				${logger.info('Transaction Id has been updated. {},{},{}', log:kv('requestedTransaction',requestedTransaction ), log:kv('currentTransactionId',data.current.transactionId ), log:kv('ip',id_handler ))}
				<%-- Now we get back to basics and load the data for the requested transaction --%>

				<c:set var="xpath" value="${quoteType}"/>
				<c:if test="${quoteType == 'car'}">
					<c:set var="xpath" value="quote"/>
				</c:if>
				<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />

						<c:catch var="error">
					<c:choose>
						<c:when test="${not empty isOperator}">
							<sql:query var="details">
								SELECT td.transactionId, xpath, textValue
								FROM aggregator.transaction_details td, aggregator.transaction_header th
								WHERE td.transactionId = ?
								AND td.transactionId = th.transactionId
								AND th.styleCodeId = ?
								ORDER BY xpath ASC;
								<sql:param value="${requestedTransaction}" />
								<sql:param value="${styleCodeId}" />
							</sql:query>
							<c:if test="${details.rowCount == 0}">
								<sql:query var="details">
								SELECT td2c.transactionId, tf.fieldCode AS xpath, td2c.textValue
								FROM aggregator.transaction_details2_cold td2c
									JOIN aggregator.transaction_header2_cold th2c USING(transactionId)
									JOIN aggregator.transaction_fields tf USING(fieldId)
								WHERE td2c.transactionId = ?
								AND th2c.styleCodeId = ?
								ORDER BY xpath ASC;
								<sql:param value="${requestedTransaction}" />
								<sql:param value="${styleCodeId}" />
							</sql:query>
							</c:if>
						</c:when>
						<c:otherwise>
							<sql:query var="details">
								SELECT td.transactionId, xpath, textValue
								FROM aggregator.transaction_details td, aggregator.transaction_header th
								WHERE th.transactionId = ?
								AND td.transactionId = th.transactionId
								AND th.styleCodeId = ?
								AND th.EmailAddress = ?
								UNION ALL
								SELECT td2c.transactionId, tf.fieldCode AS xpath, td2c.textValue
								FROM aggregator.transaction_details2_cold td2c
									JOIN aggregator.transaction_header2_cold th2c USING(transactionId)
									JOIN aggregator.transaction_fields tf USING(fieldId)
									JOIN aggregator.transaction_emails te USING(transactionId)
								WHERE td2c.transactionId = ?
								AND th2c.styleCodeId = ?
								AND ? =
									( SELECT emailAddress
									FROM aggregator.email_master
									WHERE emailId = te.emailId
									AND styleCodeId = 1
									)
								ORDER BY xpath ASC;
								<sql:param value="${requestedTransaction}" />
								<sql:param value="${styleCodeId}" />
								<sql:param value="${authenticatedData.userData.authentication.emailAddress}" />
								<sql:param value="${requestedTransaction}" />
								<sql:param value="${styleCodeId}" />
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


				<c:set var="vQuotetype">
					<c:choose>
						<c:when test="${quoteType eq 'car'}">
							quote
						</c:when>
						<c:otherwise>${quoteType}</c:otherwise>
					</c:choose>
				</c:set>
				<c:set var="jParam">
					<c:if test="${not empty data[vQuotetype]['currentJourney']}">
						&amp;j=${data[vQuotetype]['currentJourney']}
					</c:if>
				</c:set>

				<c:set var="result">
					<result>

						<c:set var="pageName" value="${verticalSettings.getHomePageJsp(param.vertical)}" />

						<c:choose>

						<c:when test="${not empty error}">
							<error><c:out value="${error}" /></error>
						</c:when>

						<c:when test="${empty data.current.transactionId}">
							<error>Transaction ID is empty. Your session may have been lost; please log in again.</error>
						</c:when>

						<%-- START AGAIN FRESH (NO PRELOAD) - USED TO GET THE PROPER QUOTE ENDPOINT --%>
						<c:when test="${param.action=='start-again-fresh'}">
							<destUrl>${pageName}?${jParam}</destUrl>
						</c:when>

						<%-- BACK TO START IF PRIVACYOPTIN HASN'T BEEN TICKED FOR OLD QUOTES (HEALTH)--%>
						<c:when test="${param.action=='amend' && param.vertical=='health' && data.health.privacyoptin!='Y'}">
							<core_v1:transaction touch="L" noResponse="true" />
							<c:choose>
								<c:when test="${not empty param.brandCode and fn:toLowerCase(param.brandCode) eq 'wfdd'}">
									<destUrl>${pageName}?action=start-again&amp;brandCode=${param.brandCode}&amp;transactionId=${data.current.transactionId}${jParam}</destUrl>
								</c:when>
								<c:otherwise>
									<destUrl>${pageName}?action=start-again&amp;transactionId=${data.current.transactionId}${jParam}</destUrl>
								</c:otherwise>
							</c:choose>
						</c:when>

						<%-- AMEND QUOTE --%>
						<c:when test="${param.action=='amend' || param.action=='start-again'}">
							<core_v1:transaction touch="L" noResponse="true" />
							<c:choose>
								<c:when test="${not empty param.brandCode and fn:toLowerCase(param.brandCode) eq 'wfdd'}">
									<destUrl>${pageName}?action=${param.action}&amp;brandCode=${param.brandCode}&amp;transactionId=${data.current.transactionId}${jParam}</destUrl>
								</c:when>
								<c:otherwise>
									<destUrl>${pageName}?action=${param.action}&amp;transactionId=${data.current.transactionId}${jParam}</destUrl>
								</c:otherwise>
							</c:choose>
						</c:when>

						<%-- BACK TO START IF PRIVACYOPTIN HASN'T BEEN TICKED FOR OLD QUOTES --%>
						<c:when test="${param.action=='latest' && data[xpath].privacyoptin!='Y'}">
							<core_v1:transaction touch="L" noResponse="true" />
							<%-- Was a new commencement date passed? --%>
							<c:if test="${not empty param.newDate and param.newDate != ''}">
								<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
							</c:if>
							<destUrl>${pageName}?action=start-again&amp;transactionId=${data.current.transactionId}${jParam}</destUrl>
						</c:when>

						<%-- GET LATEST --%>
						<c:when test="${param.action=='latest'}">
							<core_v1:transaction touch="L" noResponse="true" />
							<%-- Was a new commencement date passed? --%>
							<c:if test="${not empty param.newDate and param.newDate != ''}">
								<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
								<go:setData dataVar="data" xpath="home/startDate" value="${param.newDate}" />
							</c:if>
							<destUrl>${pageName}?action=latest&amp;transactionId=${data.current.transactionId}${jParam}</destUrl>
						</c:when>

						<%-- ERROR --%>
						<c:otherwise>
							<error>An invalid action was specified. ${param.action}</error>
						</c:otherwise>
						</c:choose>
					</result>
				</c:set>
			</c:when>
			<c:otherwise>
				${logger.warn('Proceedinator did not pass. {}',log:kv('proceedinator', proceedinator) )}
				<c:set var="reservedName" value="another user" />
				<c:set var="result">
					<result>
						<errorDetails>
							<reason>reserved</reason>
							<operator>another user</operator>
						</errorDetails>
						<c:choose>
							<c:when test="${param.vertical eq 'health'}">
								<error>Your quote is currently being reviewed by one of our health specialists. Please call <content:get key="callCentreNumber"/> to speak with us.</error>
							</c:when>
							<c:otherwise>
								<error>This quote has been reserved by another user. Please try again later.</error>
							</c:otherwise>
						</c:choose>
						<showToUser>true</showToUser>
					</result>
				</c:set>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
${logger.debug('Quote has been loaded. {}', log:kv('result', result))}
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

<%-- Return the results as json --%>
<c:choose>
	<c:when test="${param.dataFormat == 'xml'}">
		${result}
	</c:when>
	<c:otherwise>
		${go:XMLtoJSON(result)}
	</c:otherwise>
</c:choose>

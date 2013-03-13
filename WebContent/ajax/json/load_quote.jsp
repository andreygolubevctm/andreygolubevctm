<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
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
- need to have better handliong on DISC or MySQL based quotes
- need better handling for deleting the base xpath information (and better handling for save email etc.)
--%>

<go:log>LOAD QUOTE: ${param}</go:log>
<c:set var="id_for_access_check">
	<c:choose>
		<c:when test="${not empty param.id}">${param.id}</c:when>
		<c:when test="${not empty param.transactionId}">${param.transactionId}</c:when>
	</c:choose>
</c:set>

<c:set var="quoteType" value="${param.vertical}" />
		
<%-- Store flag as to whether Simples Operator or Other --%>
<c:set var="isOperator"><c:if test="${not empty data['login/user/uid']}">${data['login/user/uid']}</c:if></c:set>
<go:log>isOperator: ${isOperator}</go:log>	

<c:choose>
	<c:when test="${not empty param.simples and empty isOperator}">		
		<go:log>Operator not logged in - force to login screen</go:log>
		<c:set var="result">
			<result><error>login</error></result>
		</c:set>
	</c:when>
	<c:otherwise>	
		<%-- First check owner of the quote --%>
		<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" tranid="${id_for_access_check}" /></c:set>
		<c:choose>
			<c:when test="${not empty proceedinator and proceedinator > 0}">
				<go:log>PROCEEDINATOR PASSED</go:log>
		
				<go:log>LOAD ORIGINAL DELETE: ${data['quote']}</go:log>
				<%-- Remove any old quote data
				WE DON"T KNOW WHICH BUCKET WE ARE GETTING FROM
				<go:setData dataVar="data" value="*DELETE" xpath="quote" />
				 --%>
				
				<%-- Let's assign the param.id (transactionId) to a var we can manage (at least 'I' can manage) --%>
				<c:set var="requestedTransaction" value="${id_for_access_check}" />
					
				<%-- Call the iSeries program to fetch the quote details --%>
				<c:set var="parm">
					<c:choose>
						<%-- if Simples Operator set email to their UID otherwise use users email --%>
						<c:when test="${not empty isOperator}"><data><email>${isOperator}</email></data></c:when>
						<c:otherwise><data><email>${data['save/email']}</email></data></c:otherwise>
					</c:choose>
				</c:set>
				<go:log>requested TranID: ${requestedTransaction}</go:log>	
				<go:log>params: ${param}</go:log>	
				
				<sql:setDataSource dataSource="jdbc/aggregator"/>
				
				<%-- If is Simples Operator opening quote owned by a client then will need
					 to duplicate the transaction and make the operator the owner --%>
				<%-- 30/1/13: Increment TranID when 'ANYONE' opens a quote <c:if test="${not empty isOperator}"> --%>	
					<c:import var="getTransactionID" url="../json/get_transactionid.jsp?transactionId=${requestedTransaction}&id_handler=increment_tranId" />
					<c:set var="requestedTransaction" value="${data.current.transactionId}" />	
					<go:log>TRAN ID INCREMENTED TO: ${data.current.transactionId}</go:log>			
				<%--</c:if>--%>
				
				<go:log>========================================</go:log>
				<%-- Now we get back to basics and load the data for the requested transaction --%>
				<c:choose>
					<c:when test="${not empty quoteType}">
					    
						<c:catch var="error">
							<sql:query var="details">
								SELECT transactionId, xpath, textValue 
								FROM aggregator.transaction_details 
								WHERE transactionId = ${requestedTransaction} 
								ORDER BY sequenceNo ASC;
							</sql:query>
							
							<go:log>About to delete the vertical information for: ${quoteType}</go:log>
							
							<%-- //FIX: need to delete the bucket of information here --%>							
							<go:setData dataVar="data" value="*DELETE" xpath="${quoteType}" />
									
							<c:forEach var="row" items="${details.rows}" varStatus="status">
								<c:set var="proceed">
									<c:choose>
										<c:when test="${fn:contains(row.xpath,'save/')}">${false}</c:when>
										<c:otherwise>${true}</c:otherwise>
									</c:choose>
								</c:set>
								<c:if test="${proceed}">
									<c:set var="textVal">
										<c:choose>
											<c:when test="${fn:contains(row.textValue,'Please choose')}"></c:when>
											<c:otherwise>${row.textValue}</c:otherwise>
										</c:choose>
									</c:set>
									<go:setData dataVar="data" xpath="${row.xpath}" value="${textVal}" />
								</c:if>
							</c:forEach>
						</c:catch>
						<c:if test="${not empty error}">
							<go:log>${error}</go:log>
						</c:if>
					</c:when>
					<c:otherwise>
						<go:log>*** NO VERTICAL - MUST BE CAR ***</go:log>
						<go:log>${param}</go:log>
						<go:call pageId="AGGTXR" resultVar="quoteXml" transactionId="${requestedTransaction}" xmlVar="parm" mode="P" />
						<go:log>${quoteXml}</go:log>
						<%-- Remove the previous CAR data --%>
						<go:setData dataVar="data" value="*DELETE" xpath="quote" />
						<go:setData dataVar="data" xml="${quoteXml}" />
					</c:otherwise>
				</c:choose>
				
				<%-- Set the current transaction id to the one passed so it is set as the prev tranId--%>     
				<go:setData dataVar="data" xpath="current/transactionId" value="${requestedTransaction}" />
				
				<c:set var="result">
					<result>
						<c:choose>
						
						<%-- AMEND QUOTE --%>
						<c:when test="${param.action=='amend'}">
							<c:set var="ignore_me"><core:access_touch quoteType="${quoteType}" type="L" transaction_id="${data.current.transactionId}" /></c:set>
							<destUrl>${param.vertical}_quote.jsp?action=amend&amp;transactionId=${data.current.transactionId}</destUrl>
						</c:when>
						
						<%-- GET LATEST --%>
						<c:when test="${param.action=='latest'}">
							<c:set var="ignore_me"><core:access_touch quoteType="${quoteType}" type="L" transaction_id="${data.current.transactionId}" /></c:set>						
							<%-- Was a new commencement date passed? --%>
							<c:if test="${not empty param.newDate and param.newDate != ''}">
								<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
							</c:if>
							<destUrl>${param.vertical}_quote.jsp?action=latest&amp;transactionId=${data.current.transactionId}</destUrl>
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
	</c:otherwise>
</c:choose>

<go:log>End Load Quote</go:log>
<go:log>LOAD RESULT: ${result}</go:log>
<%-- Return the results as json --%>
${go:XMLtoJSON(result)}

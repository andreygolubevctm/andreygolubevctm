<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="errorPool" value="" /> 

<c:set var="quoteType" value="${param.quoteType}" />
<c:set var="emailCode" value="${param.emailCode}" />
<c:set var="vertical" value="${param.vertical}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${quoteType}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<sql:setDataSource dataSource="jdbc/aggregator"/>
		
		<c:set var="sessionid" value="${pageContext.session.id}" />
		<c:set var="ipaddress" value="${pageContext.request.remoteAddr}" />
		<c:set var="stylecode" value="CTM" />
		<c:set var="status" value="" />
		<c:set var="prodtyp" value="${quoteType}" />
		<c:set var="emailSource" value="${emailCode}" />
		<c:set var="firstName" value="" />
		<c:set var="lastName" value="" />
		<go:log>Email Source: ${emailSource}</go:log>
		<%-- Confirm whether Call Centre Operator or general user  --%>
		<c:set var="isOperator">
			<c:if test="${not empty data['login/user/uid']}">${data['login/user/uid']}</c:if>
		</c:set>
		
		<%-- Update email_master for ordinary users --%>
		<%-- Confirm we have the email address and password values  --%>
		<c:choose>
			<c:when test="${not empty param.save_password and param.save_password != ''}">
				<c:set var="emailAddress" value="${param.save_email}" />
				<c:set var="emailPassword" value="${param.save_password}" />
			</c:when>
			<c:when test="${not empty data.save.password}">
				<c:set var="emailAddress" value="${param.save_email}" />
				<c:set var="emailPassword" value="${data['save/password']}" />
			</c:when>
			<c:otherwise></c:otherwise>
		</c:choose>
		
		<%--Add save_email to the data bucket --%>
		<go:setData dataVar="data" xpath="${quoteType}/sendEmail" value="${param.save_email}" />
		
		<go:log>SAVE QUOTE: Email: ${emailAddress}, Password: ${emailPassword}, Params: ${param}</go:log>
		
		<c:choose>
			<c:when test="${empty emailAddress or empty emailPassword}">
				<c:set var="errorPool">{"error":"Insufficient credentials received to save the quote."}</c:set>
			</c:when>
			<c:otherwise>
				<%-- Add/Update the user record in email_master --%>	
				<c:catch var="error">	
					<sql:update var="result">
						INSERT INTO aggregator.email_master (emailAddress, emailPword, emailSource, firstName, lastName, createDate, changeDate)
						VALUES
						(?,?,?,?,?,Now(),Now())
						ON DUPLICATE KEY UPDATE 
							emailPword = '${emailPassword}',
							changeDate = Now();
						<sql:param value="${emailAddress}" />
						<sql:param value="${emailPassword}" />
						<sql:param value="${emailSource}" />			
						<sql:param value="${firstName}" />
						<sql:param value="${lastName}" />
					</sql:update>
				</c:catch>
					 
				 <%-- Test for DB issue and handle - otherwise move on --%>
				<c:choose>
					<c:when test="${not empty error}">
						<c:if test="${not empty errorPool}">
							<c:set var="errorPool">${errorPool},</c:set>
						</c:if>
						<go:log>Failed to add/update email_master: ${error.rootCause}</go:log>
						<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
					</c:when>
					<c:otherwise>
					
						<%-- Ensure the current transactionID is set --%>
						<c:set var="sandpit">
							<c:import var="getTransactionID" url="get_transactionid.jsp?id_handler=preserve_tranId" />
						</c:set>
						<c:set var="transID" value="${data.current.transactionId}" />
						 		
				 		<%--Update the transaction header record with the user current email address --%>
				 		<c:if test="${not empty emailAddress}">
							<c:catch var="error">	
								<sql:update var="result">
									UPDATE aggregator.transaction_header 
									SET EmailAddress = ?
									WHERE TransactionId = ?;
									<sql:param value="${emailAddress}" />
									<sql:param value="${transID}" />
								</sql:update>
							</c:catch>
							 
							<%-- Test for DB issue and handle - otherwise move on --%>
							<c:if test="${not empty error}">
								<c:if test="${not empty errorPool}">
									<c:set var="errorPool">${errorPool},</c:set>
								</c:if>
								<go:log>Failed to update transaction_header: ${error.rootCause}</go:log>
								<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
							</c:if><%-- Save the client values --%>
						</c:if>
						
						<%-- DELETE: clean the slate for the database table --%>
						<sql:update>
							DELETE FROM aggregator.transaction_details
							WHERE transactionId = '${transID}' AND sequenceNo > 0;
						</sql:update>
						
						<%-- INSERT/UPDATE: quote content in transaction_details --%>
						<c:set var="counter" value="${0}" />

						<c:forEach var="item" items="${param}" varStatus="status">
							<c:if test="${fn:startsWith(xpath, vertical) or fn:startsWith(xpath, 'simples')}">
								<c:set var="counter" value="${counter + 1}" />
								<c:set var="xpath" value="${go:xpathFromName(item.key)}" />
								<c:set var="rowVal" value="${item.value}" />
								
								<%-- //FIX: there should be no Please choose value for a blank item - need to see where that can come from... --%>
								<c:if test="${fn:startsWith(rowVal, 'Please choose')}">
									<c:set var="rowVal" value="" />
								</c:if>

								<%--FIXME: Need to be reviewed and replaced with something nicer --%>
								<c:choose>
									<c:when test="${fn:contains(xpath,'credit/number')}"></c:when>
									<c:when test="${fn:contains(xpath,'bank/number')}"></c:when>
									<c:when test="${fn:contains(xpath,'claim/number')}"></c:when>
									<c:when test="${fn:contains(xpath,'payment/details/type')}"></c:when>
									<c:when test="${xpath=='/operatorid'}"></c:when>
									<%-- If not prefix filtered, save the information --%>
									<c:otherwise>
										<sql:update>
									 		INSERT INTO aggregator.transaction_details 
									 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
									 		values (
									 			${transID},
									 			'${counter}',
									 			?,
									 			?,
									 			default,
									 			now()
									 		);
									 		<sql:param value="${xpath}" />									 		
									 		<sql:param value="${rowVal}" />									 		
										</sql:update>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:forEach>						
			
						<%--Add the operator to the list details - if exists --%>
						<c:if test="${not empty isOperator}">
							<sql:update>
						 		INSERT INTO aggregator.transaction_details 
						 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
						 		values (
						 			${transID},
						 			'${counter + 1}',
						 			'${vertical}/operatorId',
						 			'${isOperator}',
						 			default,
						 			now()
						 		);
							</sql:update>						 
						</c:if>
												
						<%-- Send off the Email response via json/send.jsp --%>
						<c:set var="emailResponse">
							<c:import url="send.jsp">
								<c:param name="mode" value="quote" />
							</c:import>
						</c:set>
						
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:set var="errorPool">{"error":"This quote has been reserved by another user. Please try again later." />"}</c:set>
	</c:otherwise>
</c:choose>

<%-- JSON RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		<go:log>SAVE ERRORS: ${errorPool}</go:log>
		{[${errorPool}]}
	</c:when>
	<c:otherwise>
		<c:set var="ignore_me"><core:access_touch quoteType="${quoteType}" type="S" transaction_id="${transID}" /></c:set>
		{"result":"OK","transactionId":"${transID}"}</c:otherwise>
</c:choose>
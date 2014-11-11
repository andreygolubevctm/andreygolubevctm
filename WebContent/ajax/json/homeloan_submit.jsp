<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="HOMELOAN" />

<%-- VARIABLES --%>
<c:set var="secret_key" value="kD0axgKXQ5HixuWsJ8-2BA" />
<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<c:set var="source" value="QUOTE" />
<c:set var="searchString" value='"responseData":' />

<%-- LOAD PARAMS INTO DATA --%>
<security:populateDataFromParams rootPath="${vertical}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/homeloan_submit.jsp" quoteType="${vertical}" />
</c:if>

<%-- REGISTER MARKETING OPTIN IF REQUIRED --%>
<c:if test="${not empty data.homeloan.enquiry.contact.email}">
	<c:set var="optin_mktg">
		<c:choose>
			<c:when test="${not empty data.homeloan.contact.optIn}">Y</c:when>
			<c:otherwise>N</c:otherwise>
		</c:choose>
	</c:set>
	<agg:write_email
		brand="${brand}"
		vertical="${vertical}"
		source="${source}"
		emailAddress="${data.homeloan.enquiry.contact.email}"
		emailPassword=""
		firstName="${data.homeloan.enquiry.contact.firstName}"
		lastName="${data.homeloan.enquiry.contact.lastName}"
		items="marketing=${optin_mktg}" />
</c:if>

<%-- RECORD PENDING/PROCESSING TOUCH --%>
<core:transaction touch="P" noResponse="true" />

<%-- Get the transaction ID (after recovery etc) --%>
<c:set var="tranId" value="${data['current/transactionId']}" />
<c:if test="${empty tranId}"><c:set var="tranId" value="0" /></c:if>



<%-- SUBMIT TO PARTNER --%>
<jsp:useBean id="appService" class="com.ctm.services.homeloan.HomeLoanOpportunityService" scope="page" />
<c:set var="submitResult" value="${appService.submitOpportunity(pageContext.getRequest())}" />
<c:if test="${not empty submitResult}"><go:log level="DEBUG" source="homeloan_submit">${submitResult.toString()}</go:log></c:if>



<c:choose>
	<c:when test="${empty submitResult}">
		<% response.setStatus(500); /* Internal Server Error */ %>
		<c:set var="json" value='{"info":{"transactionId":${tranId}}},"errors":[{"message":"submitOpportunity is empty"}]}' />
	</c:when>
	<c:when test='${!fn:contains(submitResult.toString(), searchString)}'>
		<% response.setStatus(500); /* Internal Server Error */ %>
		<%-- crappy hack to inject properties --%>
		<c:set var="json" value="${fn:substringAfter(submitResult.toString(), '{')}" />
		<c:set var="json" value='{"info":{"transactionId":${tranId}},${json}' />
	</c:when>
	<c:otherwise>
		<%-- CREATE CONFIRMATION KEY --%>
		<c:set var="confirmationkey" value="${pageContext.session.id}-${tranId}" />
		<go:setData dataVar="data" xpath="homeloan/confirmationkey" value="${confirmationkey}" />

		<%-- Check that confirmation not already written --%>
		<sql:setDataSource dataSource="jdbc/ctm"/>
		<sql:query var="conf_entry">
			SELECT KeyID FROM ctm.confirmations WHERE KeyID = ? AND TransID = ? LIMIT 1;
			<sql:param value="${confirmationkey}" />
			<sql:param value="${tranId}" />
		</sql:query>

		<c:choose>
			<%-- Already confirmed --%>
			<c:when test="${conf_entry.rowCount > 0}">
				<c:set var="json" value='{"confirmationkey":"${confirmationkey}"}' />
			</c:when>
			<c:otherwise>
				<c:catch var="error">
					<%-- Decrypt the AFG response --%>
					<c:set var="encyptedData" value='${submitResult.getString("responseData")}' />
					<c:set var="decryptedData"><go:AESEncryptDecrypt action="decrypt" key="${secret_key}" content="${encyptedData}" /></c:set>
					<go:log level="DEBUG" source="homeloan_submit">DECRYPTED DATA: ${decryptedData}</go:log>

					<%-- Parse the data --%>
					<c:set var="xmlData" value="<data>${go:JSONtoXML(decryptedData)}</data>" />
					<x:parse var="parsedXml" doc="${xmlData}" />

					<c:set var="flexOpportunityId"><x:out select="$parsedXml/data/flexOpportunityId" /></c:set>
					<c:set var="opportunityFirstName"><x:out select="$parsedXml/data/firstName" /></c:set>
					<c:set var="opportunityEmail"><x:out select="$parsedXml/data/emailAddress" /></c:set>

					<go:log level="DEBUG" source="homeloan_submit">OPPORTUNITY ID: ${flexOpportunityId}, FIRST NAME: ${opportunityFirstName}</go:log>
				</c:catch>

				<c:choose>
					<c:when test="${not empty error}">
						<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
							<c:param name="transactionId" value="${tranId}" />
							<c:param name="page" value="${pageContext.request.servletPath}" />
							<c:param name="message" value="Invalid data param received from AFG." />
							<c:param name="description" value="${error}" />
							<c:param name="data" value="confirmationId=${confirmationkey},data=${submitResult.toString()}" />
						</c:import>

						<% response.setStatus(500); /* Internal Server Error */ %>
						<c:set var="json" value='{"info":{"transactionId":${tranId}}},"errors":[{"message":"${error}"}]}' />
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${empty flexOpportunityId}">
								<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
									<c:param name="transactionId" value="${tranId}" />
									<c:param name="page" value="${pageContext.request.servletPath}" />
									<c:param name="message" value="Flex Opportunity ID property empty" />
									<c:param name="description" value="Flex Opportunity ID property missing in the data param received from AFG." />
									<c:param name="data" value="confirmationId=${confirmationkey},jsondata=${decryptedData},data=${submitResult.toString()}" />
								</c:import>

								<% response.setStatus(500); /* Internal Server Error */ %>
								<c:set var="json" value='{"info":{"transactionId":${tranId}}},"errors":[{"message":"flexOpportunityId was empty"}]}' />
							</c:when>
							<c:otherwise>
								<%-- Vars for the confirmation data to be saved --%>
								<c:set var="firstName" value="${opportunityFirstName}" />
								<c:set var="emailAddress" value="${opportunityEmail}" />
								<c:if test="${empty firstName}">
									<c:set var="firstName" value="${data['homeloan/enquiry/contact/firstName']}" />
								</c:if>
								<c:if test="${empty emailAddress}">
								<c:set var="emailAddress" value="${data['homeloan/enquiry/contact/email']}" />
								</c:if>
								<c:set var="situation" value="${data['homeloan/details/situation']}" />
								<c:set var="productId" value="${data['homeloan/product/id']}" />
								<c:set var="productLender" value="${data['homeloan/product/lender']}" />

								<c:set var="xmlData">
									<confirmation>
										<firstName><c:out value="${firstName}" /></firstName>
										<emailAddress><c:out value="${emailAddress}" /></emailAddress>
										<situation><c:out value="${situation}" /></situation>
										<flexOpportunityId><c:out value="${flexOpportunityId}" /></flexOpportunityId>
										<product>
											<id><c:out value="${productId}" /></id>
											<lender><c:out value="${productLender}" /></lender>
										</product>
									</confirmation>
								</c:set>

								<go:log level="DEBUG" source="homeloan_submit">WRITE CONFIRM: ${xmlData}</go:log>

								<%-- Write confirmation and C touch --%>
								<agg:write_confirmation transaction_id="${tranId}" confirmation_key="${confirmationkey}" vertical="${vertical}" xml_data="${xmlData}" />
								<agg:write_touch transaction_id="${tranId}" touch="C" />

								<go:log level="INFO" source="homeloan_submit">CONFIRMATION: transactionId:${tranId}, opportunityId:${flexOpportunityId}</go:log>

								<%-- crappy hack to inject properties --%>
								<c:set var="json" value="${fn:substringAfter(submitResult.toString(), '{')}" />
								<c:set var="json" value='{"confirmationkey":"${confirmationkey}",${json}' />
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<c:out value="${json}" escapeXml="false" />
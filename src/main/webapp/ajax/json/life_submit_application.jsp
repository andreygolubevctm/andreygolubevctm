<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" />
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />

<c:set var="vertical">${pageSettings.getVerticalCode()}</c:set>
<c:set var="continueOnValidationError" value="${false}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="life" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log  level="INFO" >PROCEEDINATOR PASSED</go:log>

		<%-- Processing --%>
		<core:transaction touch="P" noResponse="true" />

		<c:set var="tranId" value="${data.current.transactionId}" />
		
		<c:choose>
			<c:when test="${param.company eq 'ozicare'}">

				<c:set var="paramCompany"><c:out value="${param.company}" /></c:set>
				<go:setData dataVar="data" xpath="lead/company" value="${paramCompany}" />
				<c:set var="paramLeadNumber"><c:out value="${param.lead_number}" /></c:set>
				<go:setData dataVar="data" xpath="lead/leadNumber" value="${paramLeadNumber}" />
				<c:set var="paramPartnerBrand"><c:out value="${param.partnerBrand}" /></c:set>
				<go:setData dataVar="data" xpath="lead/brand" value="${paramPartnerBrand}" />

				<jsp:useBean id="AGISLeadFromRequest" class="com.ctm.services.life.AGISLeadFromRequest" scope="page" />
				<c:set var="leadResultStatus" value="${AGISLeadFromRequest.newPolicySold(pageContext.request, pageSettings, tranId)}" />

				<c:choose>
					<c:when test="${leadResultStatus eq 'OK'}">
						<go:setData dataVar="data" xpath="soap-response/results/success" value="true" />
						<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />
						
						<%-- Check if email already sent and who it was sent to --%>
						<sql:setDataSource dataSource="jdbc/ctm" />
						
						<c:catch var="error">
							<sql:query var="companies">
								SELECT textValue
								FROM aggregator.transaction_details
								WHERE transactionid = ?
								AND xpath LIKE "%/emailSentBy"
								LIMIT 1;
								<sql:param value="${tranId}" />
							</sql:query>
						</c:catch>

						<c:if test="${empty error}">
							<c:set var="companyName" value="" />
							<c:forEach var="company" items="${companies.rows}">
								<c:set var="companyName" value="${company.textValue}" />
							</c:forEach>

							<c:if test="${companyName ne 'ozicare'}">
								<%-- SEND AGIS EMAIL --%>
								<jsp:useBean id="emailService" class="com.ctm.services.email.EmailService" scope="page" />
								
								<%-- enums are not will handled in jsp --%>
								<% request.setAttribute("BEST_PRICE", com.ctm.model.email.EmailMode.BEST_PRICE); %>
								<c:catch var="error">
									${emailService.send(pageContext.request, BEST_PRICE, data.life.contactDetails.email, tranId)}
									<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/emailSentBy" value="ozicare" />
								</c:catch>
							</c:if>
						</c:if>
					</c:when>
					<c:otherwise>
						<go:setData dataVar="data" xpath="soap-response/results/success" value="false" />
						<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
	
				<go:setData dataVar="data" xpath="${vertical}/quoteAction" value="apply" />

				<c:set var="dataXml" value="${go:getEscapedXml(data[vertical])}" />

				<%-- Load the config for the contact lead sender --%>
				<c:import var="config" url="/WEB-INF/aggregator/life/config_contact_lead.xml" />

				<go:soapAggregator	config = "${config}"
									transactionId = "${tranId}"
									xml = "${dataXml}"
									var = "newQuoteResults"
									debugVar="debugXml"
									validationErrorsVar="validationErrors"
									continueOnValidationError="${true}"
									isValidVar="isValid"
									verticalCode="${fn:toUpperCase(vertical)}"
									configDbKey="quoteService"
									styleCodeId="${pageSettings.getBrandId()}"  />

				<%-- Record lead feed touch event --%>
				<jsp:useBean id="accessTouchService" class="com.ctm.services.AccessTouchService" scope="page" />
				<c:set var="touchResponse">${accessTouchService.recordTouchWithComment(data.current.transactionId, "C", "lifebroker")}</c:set>
				
				<x:parse xml="${newQuoteResults}" var="newQuoteResultsOutput" />
				<c:set var="apiReference"><x:out select="$newQuoteResultsOutput/results/client/reference" /></c:set>

				<%-- Build XML required for Life Broker request --%>
				<c:set var="requestXML">
					<applyrequest>
						<request xmlns="urn:Lifebroker.EnterpriseAPI">
							<api_reference><c:out value="${apiReference}" /></api_reference>
							<action><c:out value="${param.request_type}" /></action>
						<c:choose>
							<c:when test="${param.partner_quote eq 'Y'}">
								<client_product_id>
									<c:choose>
										<c:when test="${not empty param.client_product_id}">
											<c:out value="${param.client_product_id}" />
										</c:when>
										<c:otherwise>null</c:otherwise>
									</c:choose>
								</client_product_id>
								
								<c:if test="${not empty param.partner_product_id}">
									<partner_product_id><c:out value="${param.partner_product_id}" /></partner_product_id>
								</c:if>
							</c:when>
							<c:otherwise>
								<product_id><c:out value="${param.client_product_id}" /></product_id>
							</c:otherwise>
						</c:choose>
						</request>
					</applyrequest>
				</c:set>
		
				<%-- Load the config and send quotes to the aggregator gadget --%>
				<c:import var="config" url="/WEB-INF/aggregator/life/config_product_apply.xml" />
				<go:soapAggregator	config = "${config}"
									transactionId = "${tranId}"
									xml = "${requestXML}"
									var = "resultXml"
									debugVar="debugXml"
									verticalCode="${fn:toUpperCase(vertical)}"
									styleCodeId="${pageSettings.getBrandId()}"
									validationErrorsVar="validationErrors"
									continueOnValidationError="${continueOnValidationError}"
									isValidVar="isValid"  />	

				<c:choose>
					<c:when test="${isValid || continueOnValidationError}">
						<%-- Add the results to the current session data --%>
						<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
						<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />
						<go:setData dataVar="data" xpath="soap-response/results/selection/pds" value="*DELETE" />
				
						<go:log level="DEBUG" source="life_submit_application">${resultXml}</go:log>
						<go:log level="DEBUG" source="life_submit_application">${debugXml}</go:log>
					</c:when>
					<c:otherwise>
						<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="life_submit_application.jsp" />
					</c:otherwise>
				</c:choose>
				
			</c:otherwise>
		</c:choose>
		
		<go:setData dataVar="data" xpath="current/transactionId" value="${data.current.transactionId}" />
		<c:set var="writeQuoteResponse"><agg:write_quote productType="${fn:toUpperCase(vertical)}" rootPath="${vertical}" source="REQUEST-CALL" dataObject="${data[vertical]}" /></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error><core:access_get_reserved_msg isSimplesUser="${not empty authenticatedData.login.user.uid}" /></error>
		</c:set>
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('jsp:ajax.json.life_request_call')}" />

<c:set var="vertical"><c:out value="${param.vertical}" escapeXml="true" /></c:set>

<session:get settings="true" authenticated="true" verticalCode="${fn:toUpperCase(vertical)}" />

<%-- Clear data and load the params into data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<security:populateDataFromParams rootPath="${vertical}" />

<jsp:useBean id="accessTouchService" class="com.ctm.services.AccessTouchService" scope="page" />

<jsp:useBean id="lifeService" class="com.ctm.services.life.LifeService" scope="page" />
<c:set var="serviceResponse" value="${lifeService.contactLeadViaJSP(pageContext.request, data)}" />
<c:choose>
	<c:when test="${lifeService.isValid()}">

		<%-- First check owner of the quote --%>
		<c:set var="proceedinator"><core:access_check quoteType="${fn:toLowerCase(vertical)}" /></c:set>
		<c:choose>
			<c:when test="${not empty proceedinator and proceedinator > 0}">
				${logger.debug('PROCEEDINATOR PASSED. {}' , log:kv('proceedinator',proceedinator ))}

				<c:set var="tranId" value="${data.current.transactionId}" />

				<c:choose>
					<c:when test="${lifeService.isValid()}">
						<%-- Save client data --%>
						<c:choose>
							<c:when test="${not empty param.company and param.company eq 'ozicare'}">

								<c:set var="paramCompany"><c:out value="${param.company}" /></c:set>
								<go:setData dataVar="data" xpath="lead/company" value="${paramCompany}" />
								<c:set var="paramLeadNumber"><c:out value="${param.lead_number}" /></c:set>
								<go:setData dataVar="data" xpath="lead/leadNumber" value="${paramLeadNumber}" />
								<c:set var="paramPartnerBrand"><c:out value="${param.partnerBrand}" /></c:set>
								<go:setData dataVar="data" xpath="lead/brand" value="${paramPartnerBrand}" />

								<jsp:useBean id="AGISLeadFromRequest" class="com.ctm.services.life.AGISLeadFromRequest" scope="page" />
								<c:set var="leadResultStatus" value="${AGISLeadFromRequest.newLeadFeed(pageContext.request, pageSettings, data.current.transactionId)}" />

								<c:if test="${leadResultStatus eq 'OK'}">
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
								</c:if>

								<go:setData dataVar="data" xpath="soap-response" xml="<results><success>${leadResultStatus eq 'OK'}</success><client><reference>${leadResultStatus}</reference></client></results>" />
							</c:when>
							<c:otherwise>
								<%-- Load the config and send quotes to the aggregator gadget --%>
								<c:import var="config" url="/WEB-INF/aggregator/life/config_contact_lead.xml" />

								<go:setData dataVar="data" xpath="${vertical}/quoteAction" value="call" />

								<go:soapAggregator	config = "${config}"
													transactionId = "${tranId}"
													xml = "${go:getEscapedXml(data[fn:toLowerCase(vertical)])}"
													var = "resultXml"
													debugVar="debugXml"
													verticalCode="${fn:toUpperCase(vertical)}"
													configDbKey="quoteService"
													styleCodeId="${pageSettings.getBrandId()}"  />

								<%-- Add the results to the current session data --%>
								<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

								<%-- Record lead feed touch event --%>
								<c:set var="touchResponse">${accessTouchService.recordTouchWithComment(tranId, "CB", "lifebroker")}</c:set>
							</c:otherwise>
						</c:choose>

						<go:setData dataVar="data" xpath="current/transactionId" value="${data.current.transactionId}" />
						<c:set var="writeQuoteResponse"><agg:write_quote productType="${fn:toUpperCase(vertical)}" rootPath="${vertical}" source="REQUEST-CALL" dataObject="${data[vertical]}" /></c:set>
					</c:when>
					<c:otherwise>
						<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="life_quote_results.jsp"/>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<c:set var="resultXml">
					<error><core:access_get_reserved_msg isSimplesUser="${not empty authenticatedData.login.user.uid}" /></error>
				</c:set>
				<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
			</c:otherwise>
		</c:choose>
		${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
	</c:when>
	<c:otherwise>
		${serviceResponse}
	</c:otherwise>
</c:choose>

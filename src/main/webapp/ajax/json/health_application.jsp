<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.health_application')}" />

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="health" />

<%-- Adjust the base rebate using multiplier - this is to ensure the rebate applicable to the
					commencement date is sent to the provider --%>
<c:set var="effectiveDate" value="${data.health.payment.details.start}"/>
<jsp:useBean id="changeOverRebatesService" class="com.ctm.web.simples.services.ChangeOverRebatesService" />
<c:set var="changeOverRebates" value="${changeOverRebatesService.getChangeOverRebate(effectiveDate)}"/>
<c:set var="rebate_multiplier_previous" value="${changeOverRebates.getPreviousMultiplier()}"/>
<c:set var="rebate_multiplier_current" value="${changeOverRebates.getCurrentMultiplier()}"/>
<c:set var="rebate_multiplier_future" value="${changeOverRebates.getFutureMultiplier()}"/>

<jsp:useBean id="healthApplicationService" class="com.ctm.web.health.services.HealthApplicationService" scope="page" />
<c:set var="validationResponse" value="${healthApplicationService.setUpApplication(data, pageContext.request, changeOverRebates.getEffectiveStart())}" />

<jsp:useBean id="healthLeadService" class="com.ctm.web.health.services.HealthLeadService" scope="page" />

<c:set var="tranId" value="${data.current.transactionId}" />
<c:set var="productId" value="${fn:substringAfter(param.health_application_productId,'HEALTH-')}" />
<c:set var="productCode" value="${param.health_application_productName}" />
<c:set var="continueOnAggregatorValidationError" value="${true}" />

<jsp:useBean id="accessTouchService" class="com.ctm.web.core.services.AccessTouchService" scope="page" />
<c:set var="touch_count"><core_v1:access_count touch="P" /></c:set>

<c:choose>
	<%--
	token can only be invalid for ONLINE.
	If invalid send the user to the pending page and let the call centre sort out
	TODO: move this over to HealthApplicationService
	--%>
	<c:when test="${!healthApplicationService.validToken}">
		<health_v1:set_to_pending errorMessage="Token is not valid." resultJson="${healthApplicationService.createTokenValidationFailedResponse(data.current.transactionId,pageContext.session.id)}"  transactionId="${resultXml}" productId="${productId}" productCode="${productCode}"/>
	</c:when>
	<%-- only output validation errors if call centre --%>
	<c:when test="${!healthApplicationService.valid && callCentre}">
		${validationResponse}
	</c:when>
	<%-- set to pending if online and validation fails --%>
	<c:when test="${!healthApplicationService.valid && !callCentre}">
		<c:set var="resultXml"><result><success>false</success><errors></c:set>
		<c:forEach var="validationError"  items="${healthApplicationService.getValidationErrors()}">
			<c:set var="resultXml">${resultXml}<error><code>${validationError.message}</code><original>${validationError.elementXpath}</original></error></c:set>
		</c:forEach>
		<c:set var="resultXml">${resultXml}</errors></result></c:set>
		<health_v1:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}" transactionId="${tranId}" productId="${productId}" productCode="${productCode}" />
	</c:when>
	<%-- check the if ONLINE user submitted more than 5 times [HLT-1092] --%>
	<c:when test="${empty callCentre and not empty touch_count and touch_count > 5}">
		<c:set var="errorMessage" value="You have attempted to submit this join more than 5 times." />
		<core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
		${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "submission")}

		<c:if test="${not empty data['health/privacyoptin'] and data['health/privacyoptin'] eq 'Y'}">
			${healthLeadService.sendLead(4, data, pageContext.getRequest(), 'PENDING')}
		</c:if>

	</c:when>
	<%-- check the latest touch, to make sure a join is not already actively in progress [HLT-1092] --%>
	<c:when test="${accessTouchService.isBeingSubmitted(tranId)}">
		<c:set var="errorMessage" value="Your application is still being submitted. Please wait." />
		<core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
		${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "submission")}
</c:when>
	<c:otherwise>
<%-- Save client data; use outcome to know if this transaction is already confirmed --%>
<c:set var="ct_outcome"><core_v1:transaction touch="P" /></c:set>
${logger.info('Application has been set to pending. {}', log:kv('productId', productId))}

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<c:choose>
	<c:when test="${ct_outcome == 'C'}">
		<c:set var="errorMessage" value="Quote has already been submitted and confirmed." />
		<core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" />
		${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "confirmed")}
	</c:when>

	<c:when test="${ct_outcome == 'V' or ct_outcome == 'I'}">
		<c:set var="errorMessage" value="Important details are missing from your session. Your session may have expired." />
		<core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" />
		${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "transaction")}
	</c:when>

	<c:when test="${not empty ct_outcome}">
		<c:set var="errorMessage" value="Application submit error. Code=${ct_outcome}" />
		<core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" />
		${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "")}
	</c:when>

	<c:otherwise>

<%-- Get the fund specific data --%>

		<sql:transaction>
<%-- Get the hospital Cover name --%>
<%-- Get the extras Cover name --%>
<sql:query var="prodRes">
				SELECT
					concat(pp1.Text,'') as hospitalCoverName,
					concat(pp2.Text,'') as extrasCoverName
				FROM ctm.product_properties pp1
				LEFT JOIN ctm.product_properties as pp2
					ON pp1.productid = pp2.productid
					AND pp2.propertyId = 'extrasCoverName'
					WHERE
						pp1.productid = ?
						AND pp1.propertyId = 'hospitalCoverName'
				LIMIT 1;
	<sql:param value="${productId}" />
</sql:query>
<c:if test="${prodRes.rowCount != 0 }">
				<go:setData dataVar="data" xpath="health/fundData/hospitalCoverName" value="${prodRes.rows[0].hospitalCoverName}" />
				<go:setData dataVar="data" xpath="health/fundData/extrasCoverName" value="${prodRes.rows[0].extrasCoverName}" />
</c:if>

<%-- Get the excess --%>
<sql:query var="prodRes">
	SELECT Text FROM product_properties WHERE productid=? AND propertyId = 'excess' LIMIT 1
	<sql:param value="${productId}" />
</sql:query>
<c:if test="${prodRes.rowCount != 0 }">
	<go:setData dataVar="data" xpath="health/fundData/excess" value="${prodRes.rows[0].text}" />
</c:if>

<%-- Get the Fund productId --%>
<sql:query var="prodRes">
	SELECT Text FROM product_properties WHERE productid=? AND (propertyId = 'fundCode' OR propertyId = 'productID') AND sequenceNo =1 LIMIT 1
	<sql:param value="${productId}" />
</sql:query>
<c:if test="${prodRes.rowCount != 0 }">
	<go:setData dataVar="data" xpath="health/fundData/fundCode" value="${prodRes.rows[0].text}" />
</c:if>

<%-- Get the fund's code/name (e.g. hcf) --%>
<sql:query var="prodRes">
			SELECT lower(prov.Text) as Text, prov.ProviderId FROM provider_properties prov
	JOIN product_master prod on prov.providerId = prod.providerId
	where prod.productid=?
	AND prov.propertyId = 'FundCode' LIMIT 1
	<sql:param value="${productId}" />
</sql:query>
<c:if test="${prodRes.rowCount != 0 }">
	<c:set var="fund" value="${prodRes.rows[0].Text}" />
</c:if>
		</sql:transaction>

		${logger.debug('Queried product properties. {},{}', log:kv('fund', fund), log:kv('productId', productId))}

		<%-- This will be deleted once health application is moved to it's own service --%>
		<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
		<c:set var="configUrl">/WEB-INF/aggregator/health_application/${fund}/config.xml</c:set>

		<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, configUrl)}" />
		<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['health'])}"
					var = "resultXml"
				debugVar="debugXml"
				validationErrorsVar="validationErrors"
						continueOnValidationError="${continueOnAggregatorValidationError}"
						isValidVar="isValid"
						verticalCode="HEALTH"
						configDbKey="appService"
				   sendCorrelationId="true"
						styleCodeId="${pageSettings.getBrandId()}"
						/>
		<c:choose>
					<c:when test="${isValid || continueOnAggregatorValidationError}">
						<c:if test="${!isValid}">
							<c:forEach var="validationError"  items="${validationErrors}">
								<error:non_fatal_error origin="health_application.jsp"
											errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
							</c:forEach>
							${healthLeadService.sendLead(4, data, pageContext.request, 'PENDING')}
						</c:if>
<%-- //FIX: turn this back on when you are ready!!!!
<%-- Write to the stats database
<agg_v1:write_stats tranId="${tranId}" debugXml="${debugXml}" />
--%>


<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="app-response" value="*DELETE" />
<go:setData dataVar="data" xpath="app-response" xml="${resultXml}" />

		<x:parse doc="${resultXml}" var="resultOBJ" />
			<c:set var="errorMessage" value="" />

		<%-- Check for internal or provider errors and record the failed submission and add comments to the quote for call centre staff --%>
		<x:if select="count($resultOBJ//*[local-name()='errors']/error) > 0 or local-name($resultOBJ)='error'">
				<x:forEach select="$resultOBJ//*[local-name()='errors']/error" var="error" varStatus="pos">
					<c:if test="${not empty errorMessage}">
					<c:set var="errorMessage" value="${errorMessage}; " />
					</c:if>
				<c:set var="errorMessage">${errorMessage}[${pos.count}] <x:out select="$error/text" /></c:set>
				</x:forEach>

			<c:if test="${empty errorMessage}">
				<x:if select="local-name($resultOBJ)='error'">
					<c:set var="errorMessage"><x:out select="$resultOBJ//message" /> (Please report to CTM IT before continuing)</c:set>
			</x:if>
			</c:if>

		<%-- Collate fund error messages, add fail touch and add quote comment --%>
			<c:if test="${not empty errorMessage}">
			    <health_v1:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}" transactionId="${tranId}" productId="${productId}" productCode="${productCode}" />
				${healthLeadService.sendLead(4, data, pageContext.request, 'PENDING')}
			</c:if>
		</x:if>

		<%-- Set transaction to confirmed if application was successful --%>
		<x:choose>
			<x:when select="$resultOBJ//*[local-name()='success'] = 'true'">
				<core_v1:transaction touch="C" noResponse="true" productId="${productId}"/>
				${healthLeadService.sendLead(4, data, pageContext.request, 'SOLD')}

						<c:set var="ignore">
								<jsp:useBean id="joinService" class="com.ctm.web.core.confirmation.services.JoinService" scope="page" />
						${joinService.writeJoin(tranId,productId,productCode)}
						</c:set>

								<c:set var="allowedErrors" value="" />
								<c:catch var="writeAllowableErrorsException">
									<%-- Check any allowable errors and save to the database --%>
									<x:set var="allowAbleErrorCount" select="count($resultOBJ//*[local-name()='allowedErrors']/error)" />
									<c:if test="${allowAbleErrorCount > 0}">
										<x:forEach select="$resultOBJ//*[local-name()='allowedErrors']/error" var="error" varStatus="pos">
											<c:set var="allowedErrors">${allowedErrors}<x:out select="$error/code" /></c:set>
											<c:if test="${status.count < allowAbleErrorCount - 1}">
												<c:set var="allowedErrors">${allowedErrors},</c:set>
											</c:if>
										</x:forEach>
										<jsp:useBean id="healthTransactionDao" class="com.ctm.web.health.dao.HealthTransactionDao" scope="page" />
										${healthTransactionDao.writeAllowableErrors(tranId , allowedErrors)}
									</c:if>
								</c:catch>
								<c:if test="${not empty writeAllowableErrorsException}">
									${logger.warn('Exception thrown writing allowable errors. {}', log:kv('resultOBJ', $resultOBJ), writeAllowableErrorsException)}
									<error:non_fatal_error origin="health_application.jsp"
											errorMessage="failed to writeAllowableErrors tranId:${tranId} allowedErrors:${allowedErrors}" errorCode="DATABASE" />
								</c:if>

								<%-- Save confirmation record/snapshot --%>
								<c:import var="saveConfirmation" url="/ajax/write/save_health_confirmation.jsp">
									<c:param name="policyNo"><x:out select="$resultOBJ//*[local-name()='policyNo']" /></c:param>
									<c:param name="startDate" value="${data['health/payment/details/start']}" />
									<c:param name="frequency" value="${data['health/payment/details/frequency']}" />
									<c:param name="bccEmail"><x:out select="$resultOBJ//*[local-name()='bccEmail']" /></c:param>
								</c:import>

				<%-- Check outcome was ok --%>
				<x:parse doc="${saveConfirmation}" var="saveConfirmationXml" />
				<x:choose>
					<x:when select="$saveConfirmationXml/response/status = 'OK'">
						<c:set var="confirmationID"><x:out select="$saveConfirmationXml/response/confirmationID" /></c:set>
					</x:when>
					<x:otherwise></x:otherwise>
				</x:choose>
				${logger.info('Transaction has been set to confirmed. {}', log:kv('confirmationID',confirmationID ))}
				<c:set var="confirmationID"><confirmationID><c:out value="${confirmationID}" /></confirmationID></result></c:set>
				<c:set var="resultXml" value="${fn:replace(resultXml, '</result>', confirmationID)}" />
								${go:XMLtoJSON(resultXml)}
			</x:when>
			<%-- Was not successful --%>
							<%-- If no fail has been recorded yet --%>
			<x:otherwise>
				<c:choose>
					<%-- if online user record a join --%>
					<c:when test="${empty callCentre && empty errorMessage}">
						<health_v1:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}" transactionId="${tranId}" productId="${productId}" productCode="${productCode}" resultJson="${healthApplicationService.createFailedResponse(tranId, pageContext.session.id)}" />
						${healthLeadService.sendLead(4, data, pageContext.request, 'PENDING')}
					</c:when>
					<%-- else just record a failure --%>
					<c:when test="${empty errorMessage}">
						<core_v1:transaction touch="F" comment="Application success=false" noResponse="true" productId="${productId}"/>
						<c:set var="resultJson" >${go:XMLtoJSON(resultXml)}</c:set>
						${healthApplicationService.createResponse(data.current.transactionId, resultJson)}
					</c:when>
				</c:choose>
			</x:otherwise>
		</x:choose>
		${logger.trace('Health application complete. {},{}', log:kv('resultXml', resultXml),log:kv( 'debugXml', debugXml))}
			</c:when>
			<c:otherwise>
						<c:choose>
							<c:when test="${empty callCentre }">
								<c:set var="resultXml"><result><success>false</success><errors></c:set>
								<c:forEach var="validationError"  items="${validationErrors}">
									<c:set var="resultXml">${resultXml}<error><code>${validationError.message}</code><original>${validationError.elementXpath}</original></error></c:set>
								</c:forEach>
								<c:set var="resultXml">${resultXml}</errors></result></c:set>
								<health_v1:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}" transactionId="${tranId}" productId="${productId}" productCode="${productCode}" />
							</c:when>
							<c:otherwise>
				<agg_v1:outputValidationFailureJSON validationErrors="${validationErrors}" origin="health_application.jsp" />
	</c:otherwise>
		</c:choose>
	</c:otherwise>
		</c:choose>
	</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.life_quote_result')}" />

<session:get settings="true" authenticated="true" verticalCode="${fn:trim(fn:toUpperCase(param.vertical))}" />

<%-- Load the params into data --%>
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<security:populateDataFromParams rootPath="${vertical}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/life_quote_results.jsp" quoteType="${vertical}" />
</c:if>

${logger.info('Call to Results - Start', log:kv('transactionId',data.current.transactionId))}

<jsp:useBean id="lifeService" class="com.ctm.web.life.services.LifeService" scope="page" />
<c:set var="serviceResponse" value="${lifeService.contactLeadViaJSP(pageContext.request, data)}" />

<c:choose>
	<c:when test="${lifeService.isValid()}">
		${logger.info('Call to Results - Life Service IS Valid', log:kv('transactionId',data.current.transactionId), log:kv('serviceResponse',serviceResponse))}
		<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>
		<c:set var="continueOnValidationError" value="${false}" />

		<%-- First check owner of the quote --%>
		<c:set var="proceedinator"><core_v1:access_check quoteType="${vertical}" /></c:set>
		<c:choose>
			<c:when test="${not empty proceedinator and proceedinator > 0}">
				${logger.info('Call to Results - Proceedinator Passed', log:kv('transactionId',data.current.transactionId))}
				${logger.debug('PROCEEDINATOR PASSED')}

				<%-- add external testing ip address checking and loading correct config and send quotes --%>

				<c:set var="tranId" value="${data.current.transactionId}" />
				<go:setData dataVar="data" xpath="${vertical}/transactionId" value="${tranId}" />
				<%-- Save client data --%>
				<core_v1:transaction touch="R" noResponse="true" />
				<%-- add external testing ip address checking and loading correct config and send quotes --%>
				<c:set var="tranId" value="${data.current.transactionId}" />
				<go:setData dataVar="data" xpath="${vertical}/transactionId" value="${tranId}" />
				
				<c:if test="${vertical eq 'ip'}">
					<go:setData dataVar="data" xpath="${vertical}/sendRealData" value="true" />
				</c:if>
				
				<%-- Load the config and send quotes to the aggregator gadget --%>
				<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
				<c:set var="configUrl">/WEB-INF/aggregator/life/config_results_${vertical}.xml</c:set>

				<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, configUrl)}" />

				<c:set var="dataXml" value="${go:getEscapedXml(data[vertical])}" />
				<go:soapAggregator	config = "${config}"
									  transactionId = "${tranId}"
									  xml = "${dataXml}"
									  var = "resultXml"
									  debugVar="debugXml"
									  validationErrorsVar="validationErrors"
									  continueOnValidationError="${continueOnValidationError}"
									  isValidVar="isValid"
									  verticalCode="${fn:toUpperCase(vertical)}"
									  configDbKey="quoteService"
									  styleCodeId="${pageSettings.getBrandId()}"  />

				<%-- Check response status returned by the service --%>
				<x:parse xml="${resultXml}" var="successStatus" />
				<x:choose>
					<x:when select="$successStatus//results//success">
						<c:set var="successStatus"><x:out select="$successStatus/results/success" /></c:set>
					</x:when>
					<x:otherwise>
						<c:set var="successStatus" value="false" />
					</x:otherwise>
				</x:choose>
				<c:choose>
					<%-- Check the server side for validation --%>
					<c:when test="${isValid || continueOnValidationError}">
						${logger.info('Call to Results - Response Passed Initial Test', log:kv('transactionId',data.current.transactionId),log:kv('outboundXml',dataXml),log:kv('inboundXml',resultXml))}
						<%-- Check response status returned by the service --%>
						<x:parse xml="${resultXml}" var="successStatus" />
						<x:choose>
							<x:when select="$successStatus//results//success">
								<c:set var="successStatus"><x:out select="$successStatus/results/success" /></c:set>
								<c:if test="${!isValid}">
									${logger.warn('Call to Results - Invalid Soap Response', log:kv('transactionId',data.current.transactionId),log:kv('outboundXml',dataXml),log:kv('inboundXml',resultXml),log:kv('validationErrors',validationErrors))}
									<c:forEach var="validationError"  items="${validationErrors}">
										<error:non_fatal_error origin="life_quote_results.jsp"
															   errorMessage="message:${validationError.message} elementXpath:${validationError.elementXpath} elements:${validationError.elements}" errorCode="VALIDATION" />
									</c:forEach>
								</c:if>

								<%-- Write to the stats database --%>
								<c:set var="ignore">
									<life_v1:get_soap_response_stats debugXml="${debugXml}" />
									<agg_v1:write_stats rootPath="${vertical}" tranId="${tranId}" />
								</c:set>

								<c:if test="${isValid}">
									${logger.info('Call to Results - Successful Soap Response', log:kv('transactionId',data.current.transactionId),log:kv('outboundXml',dataXml),log:kv('inboundXml',resultXml))}
								</c:if>

								<%-- Add the results to the current session data --%>
								<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
								<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
								<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />
								${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
							</x:when>
							<x:otherwise>
								${logger.info('Call to Results - Failed Soap Response', log:kv('transactionId',data.current.transactionId),log:kv('outboundXml',dataXml),log:kv('inboundXml',resultXml))}
								<%-- LifeBroker returned failed SOAP response --%>
								<go:setData dataVar="data" xpath="current/transactionId" value="${tranId}" />
								<error:fatal_error page="ajax/json/life_quote_results.jsp" failedData="${data}" fatal="1" transactionId="${tranId}" description="LifeBroker SOAP call returned status 'false'" message="LifeBroker SOAP call returned status 'false'" />
								${go:XMLtoJSON("<results><success>false</success></results>")}
							</x:otherwise>
						</x:choose>
					</c:when>
					<c:otherwise>
						${logger.warn('Call to Results - Response Failed Initial Test', log:kv('transactionId',data.current.transactionId),log:kv('outboundXml',dataXml),log:kv('inboundXml',resultXml),log:kv('validationErrors',validationErrors))}
						<agg_v1:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="life_quote_results.jsp"/>
					</c:otherwise>
				</c:choose>

				<%-- COMPETITION APPLICATION START --%>
				<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
				<c:set var="optedInForCompKey">${vertical}/contactDetails/competition/optin</c:set>
				<c:set var="optedInForComp" value="${data[optedInForCompKey] == 'Y' }" />

				<c:if test="${competitionEnabledSetting eq 'Y' and not callCentre and optedInForComp}">
					<c:set var="competitionId"><content:get key="competitionId"/></c:set>
					<c:set var="competition_emailKey">${vertical}/contactDetails/email</c:set>
					<c:set var="competition_firstnameKey">${vertical}/primary/firstName</c:set>
					<c:set var="competition_lastnameKey">${vertical}/primary/lastname</c:set>
					<c:set var="competition_phoneKey">${vertical}/contactDetails/contactNumber</c:set>
					<c:import var="response" url="/ajax/write/competition_entry.jsp">
						<c:param name="secret">F982336B6A298CDBFCECBE719645C</c:param>
						<c:param name="competitionId" value="${competitionId}" />
						<c:param name="competition_email" value="${fn:trim(data[competition_emailKey])}" />
						<c:param name="competition_firstname" value="${fn:trim(data[competition_firstnameKey])}" />
						<c:param name="competition_lastname" value="${fn:trim(data[competition_lastnameKey])}" />
						<c:param name="competition_phone" value="${data[competition_phoneKey]}" />
						<c:param name="transactionId" value="${tranId}" />
					</c:import>
					${logger.warn('Call to Results - Competition Entry', log:kv('transactionId',data.current.transactionId),log:kv('competitionResponse',response))}
				</c:if>
				<%-- COMPETITION APPLICATION END --%>
			</c:when>
			<c:otherwise>
				<c:set var="resultXml">
					<error><core_v1:access_get_reserved_msg isSimplesUser="${not empty authenticatedData.login.user.uid}" /></error>
				</c:set>
				${logger.warn('Call to Results - Proceedinator Failed', log:kv('transactionId',data.current.transactionId), log:kv('resultXml',resultXml))}
				<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
				${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		${logger.info('Call to Results - Life Service is NOT Valid', log:kv('transactionId',data.current.transactionId), log:kv('serviceResponse',serviceResponse))}
		${serviceResponse}
	</c:otherwise>
</c:choose>

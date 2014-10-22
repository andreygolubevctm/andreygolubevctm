<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="${fn:trim(fn:toUpperCase(param.vertical))}" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<c:set var="continueOnValidationError" value="${true}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${vertical}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log source="life_quote_results_jsp" level="INFO" >PROCEEDINATOR PASSED</go:log>

		<%-- Load the params into data --%>
		<security:populateDataFromParams rootPath="${vertical}" />


		<%-- RECOVER: if things have gone pear shaped --%>
		<c:if test="${empty data.current.transactionId}">
			<error:recover origin="ajax/json/life_quote_results.jsp" quoteType="${vertical}" />
		</c:if>

		<%-- Save client data --%>
		<core:transaction touch="R" noResponse="true" />

		<%-- add external testing ip address checking and loading correct config and send quotes --%>

		<c:set var="tranId" value="${data.current.transactionId}" />
		<go:setData dataVar="data" xpath="${vertical}/transactionId" value="${tranId}" />

		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:import var="config" url="/WEB-INF/aggregator/life/config_results_${vertical}.xml" />

		<c:set var="dataXml" value="${go:getEscapedXml(data[vertical])}" />
		<go:soapAggregator config = "${config}"
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
			<%-- LifeBroker returned failed SOAP response --%>
			<c:when test="${successStatus == false}">
				<go:setData dataVar="data" xpath="current/transactionId" value="${tranId}" />
				<error:fatal_error page="ajax/json/life_quote_results.jsp" failedData="${data}" fatal="1" transactionId="${tranId}" description="LifeBroker SOAP call returned status 'false'" message="LifeBroker SOAP call returned status 'false'" />
				${go:XMLtoJSON("<results><success>false</success></results>")}
			</c:when>
			<%-- Check the server side for validation --%>
			<c:when test="${isValid || continueOnValidationError}">
				<c:if test="${!isValid}">
					<c:forEach var="validationError"  items="${validationErrors}">
						<error:non_fatal_error origin="life_quote_results.jsp"
											errorMessage="message:${validationError.message} elementXpath:${validationError.elementXpath} elements:${validationError.elements}" errorCode="VALIDATION" />
					</c:forEach>
				</c:if>

		<%-- Write to the stats database --%>
		<c:set var="ignore">
			<life:get_soap_response_stats debugXml="${debugXml}" />
			<agg:write_stats rootPath="${vertical}" tranId="${tranId}" />
		</c:set>

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />

				<go:log source="life_quote_results_jsp" level="TRACE">${resultXml}</go:log>
				<go:log source="life_quote_results_jsp" level="TRACE">${debugXml}</go:log>
				${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
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
		${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
	</c:otherwise>
</c:choose>

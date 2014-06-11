<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core_new:no_cache_header/>

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true" />

<jsp:useBean id="soapdata" class="com.disc_au.web.go.Data" scope="request" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="health" /></c:set>
<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<c:set var="continueOnValidationError" value="${true}" />

		<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="health" />


<%-- Test and or Increment ID if required --%>
<c:choose>
	<%-- RECOVER: if things have gone pear shaped --%>
	<c:when test="${empty data.current.transactionId}">
		<error:recover origin="ajax/json/health_quote_results.jsp" quoteType="health" />
	</c:when>
	<%--
	This is now getting triggered by the new Results.js code which adds the querystring params.
	Increment is already done in core:transaction below.

	<c:when test="${param.health_incrementTransactionId}">
		<c:set var="id_return">
			<core:get_transaction_id quoteType="health" id_handler="increment_tranId" />
		</c:set>
	</c:when>
	--%>
	<c:otherwise>
		<%-- All is good --%>
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log level="INFO" source="health_quote_results_jsp" >PROCEEDINATOR PASSED</go:log>

		<%-- COMPETITION START --%>
		<c:if test="${data['health/contactDetails/competition/optin'] == 'Y'}">
			<go:log level="INFO" source="health_quote_results_jsp" >GRUB: Opt-in ticked</go:log>
			<c:choose>
					<c:when test="${not empty data['health/contactDetails/contactNumber/mobile']}">
						<c:set var="contactPhone" value="${data['health/contactDetails/contactNumber/mobile']}"/>
					</c:when>
					<c:otherwise>
						<c:set var="contactPhone" value="${data['health/contactDetails/contactNumber/other']}"/>
					</c:otherwise>
			</c:choose>
			<c:set var="concat" value="${fn:trim(data['health/contactDetails/name'])}::${fn:trim(data['health/contactDetails/email'])}::${fn:trim(contactPhone)}" />
			<go:log source="health_quote_results_jsp">GRUB: concat: ${concat}</go:log>
			<c:if test="${concat != '::::' and data['health/contactDetails/competition/previous'] != concat}">
				<go:log source="health_quote_results_jsp">GRUB: Send in the entry!</go:log>

				<c:set var="firstname" value="${fn:trim(data['health/contactDetails/name'])}" />
				<c:set var="lastname" value="" />
				<c:if test="${fn:contains(firstname, ' ')}">
					<c:set var="firstname" value="${fn:substringBefore(firstname, ' ')}" />
					<c:set var="lastname" value="${fn:substringAfter(fn:trim(data['health/contactDetails/name']), ' ')}" />
		</c:if>

				<jsp:useBean id="date" class="java.util.Date" />
				<fmt:formatDate value="${date}" pattern="yyyyMMddHHmm" var="datetime" />

				<c:import var="response" url="/ajax/write/october_promo.jsp">
					<c:param name="secret">
						<c:choose>
							<%-- November comp starts at 9am Nov 1st. --%>
							<c:when test="${datetime < 201311010900}">498j984j983j4f</c:when>
							<c:otherwise>879n5b5435fgxz</c:otherwise>
						</c:choose>
					</c:param>
					<c:param name="competition_email" value="${fn:trim(data['health/contactDetails/email'])}" />
					<c:param name="competition_firstname" value="${firstname}" />
					<c:param name="competition_lastname" value="${lastname}" />
					<c:param name="competition_phone" value="${contactPhone}" />
				</c:import>
				<go:log source="health_quote_results_jsp">GRUB: response: ${response}</go:log>
			</c:if>
		</c:if>
		<%-- COMPETITION END --%>

		<%-- Save client data --%>
		<c:choose>
			<c:when test="${param.health_showAll == 'N'}">
				<core:transaction touch="Q" noResponse="true" />
			</c:when>
			<c:otherwise>
				<core:transaction touch="R" noResponse="true" />
			</c:otherwise>
		</c:choose>

		<%-- Collect the tranIDs after they've potentially been incremented --%>
		<go:setData dataVar="data" xpath="health/transactionId" value="${data.current.transactionId}" />
		<c:set var="tranId" value="${data.current.transactionId}" />

		<%-- Removed specific email writing operations from here as they're handled in core:transaction above --%>

		<c:import var="config" url="/WEB-INF/aggregator/health/config_ALL.xml" />

		<%-- Load the config and send quotes to the aggregator gadget --%>
		<go:soapAggregator config = "${config}"
			transactionId = "${tranId}"
			xml = "${go:getEscapedXml(data['health'])}"
			var = "resultXml"
			debugVar="debugXml"
			validationErrorsVar="validationErrors"
			continueOnValidationError="${continueOnValidationError}"
			isValidVar="isValid" />

		<c:if test="${isValid || continueOnValidationError}">
			<c:if test="${!isValid}">
				<c:forEach var="validationError"  items="${validationErrors}">
					<error:non_fatal_error origin="health_quote_results.jsp"
								errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
				</c:forEach>
			</c:if>

			<agg:write_stats rootPath="health" tranId="${data.text['current/transactionId']}" debugXml="${debugXml}" />

			<%-- Add the results to the current session data --%>
		
			<go:setData dataVar="soapdata" xpath="soap-response" value="*DELETE" />
			<go:setData dataVar="soapdata" xml="${resultXml}" />
			
			<%-- Add the results only if there is one version --%>
			<go:setData dataVar="data" xpath="healthConfirmation" value="*DELETE"/>
			<go:setData dataVar="data" xpath="confirmation/health" value="*DELETE"/>
			
			<c:if test="${data.health.showAll == 'N' && data.health.onResultsPage != 'Y'}">
				<%-- condition if soap-response does not match our criteria, we need to call the product data fresh --%>
				<c:import var="transferXml" url="/WEB-INF/xslt/healthConfirmation.xsl"/>
				<c:set var="priceXML">
					<x:transform doc="${resultXml}" xslt="${transferXml}" />
				</c:set>

				<c:set var="priceXML" value="<![CDATA[${go:XMLtoJSON(priceXML)}]]>" />

				<c:set var="priceXML" value="${fn:replace(priceXML,'\"price\":{', '')}" />
				<c:set var="priceXML" value="${fn:replace(priceXML,'}}]]>', '}]]>')}" />

				<go:setData dataVar="data" xpath="confirmation/health" value="${priceXML}" />
			</c:if>
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error>
				<errorType></errorType>
				<message><core:access_get_reserved_msg isSimplesUser="${not empty authenticatedData.login.user.uid}" /></message>
				<transactionId>${data.current.transactionId}</transactionId>
				<errorDetails>
					<errorType></errorType>
				</errorDetails>
			</error>
		</c:set>
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${isValid || continueOnValidationError}" >
		${go:XMLtoJSON(go:getEscapedXml(soapdata['soap-response/results']))}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="health_quote_results.jsp"/>
	</c:otherwise>
</c:choose>
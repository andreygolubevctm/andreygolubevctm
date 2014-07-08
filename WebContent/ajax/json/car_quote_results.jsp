<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="CAR" />

<jsp:useBean id="soapdata" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="continueOnValidationError" value="${true}" />

<%--
	car_quote_results.jsp

	Main workhorse for writing quotes and getting prices.
	It does the following:
	 - Gets a new transaction id (passing the old one if it exists so we can link the old and new quotes)
	 - Calls NTAGGTIC to write the client's data in AGGDTL detail file (and create the AGMHDR header record)   
	 - Initialises the SOAP Aggregator gadget
	 - Passes the client information to the SOAP Aggregator gadget to fetch prices 
	 - Calls AGGTRS to write the initial stats (passing the SOAP response data)
	 - Returns the SOAP response to the page as a JSON object

	@param quote_*	- Full car quote values
	
 --%>
 
 
<c:choose>
	<c:when test="${not empty param.action and param.action == 'latest'}">
		<c:set var="writeQuoteOverride" value="N" />
	</c:when>
	<c:when test="${not empty param.action and param.action == 'change_excess'}">
		<go:setData dataVar="data" xpath="quote/excess" value="${param.quote_excess}" />
		<c:set var="writeQuoteOverride" value="Y" />
	</c:when>
	<c:otherwise>
	<%-- Set data from the form and call AGGTIC to write the client data to tables --%>
	<%-- Note, we do not wait for it to return - this is a "fire and forget" request --%>
		<security:populateDataFromParams rootPath="quote" />
		<c:set var="writeQuoteOverride" value="" />
	</c:otherwise>
</c:choose>

<%-- CAR-333 check if the streetNum is blank and force to 0 to fix AGIS returning empty data --%>
<c:if test="${empty data.quote.riskAddress.streetNum && empty data.quote.riskAddress.houseNoSel}">
	<go:setData dataVar="data" xpath="quote/riskAddress/streetNum" value="0" />
</c:if>

<%-- Driver Options needs a default value when it is hidden due to the youngest driver being under 21 --%>
<c:if test="${empty data.quote.options.driverOption}">
	<go:setData dataVar="data" xpath="quote/options/driverOption" value="3" />
</c:if>

<%-- set items a comma separated list of values in value=description format --%>
<c:set var="items">CarInsurance = CarInsurance,okToCall = ${data.quote.contact.oktocall},marketing = ${data.quote.contact.marketing}</c:set>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/car_quote_results.jsp" quoteType="car" />
</c:if>
			
<%-- Save data --%>
<core:transaction touch="R" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

<%-- Fetch and store the transaction id --%>
<c:set var="tranId" value="${data['current/transactionId']}" />

<go:setData dataVar="data" xpath="quote/transactionId" value="${tranId}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/get_prices/config.xml" />

<go:soapAggregator config = "${config}"
					transactionId = "${data.text['current/transactionId']}" 
					xml = "${go:getEscapedXml(data['quote'])}" 
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					continueOnValidationError="${continueOnValidationError}"
					isValidVar="isValid" />

<c:choose>
	<c:when test="${isValid || continueOnValidationError}" >
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="car_quote_results.jsp"
							errorMessage="message:${validationError.message} elementXpath:${validationError.elementXpath} elements:${validationError.elements}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>

<%-- Add the results to the current session data --%>
<go:setData dataVar="soapdata" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="soapdata" xpath="soap-response" xml="${resultXml}" />

<c:import var="transferXml" url="/WEB-INF/xslt/AGGTRS.xsl"/>
<c:set var="stats">
	<x:transform xml="${debugXml}" xslt="${transferXml}">
		<x:param name="excess" value="${data['quote/excess']}" />
	</x:transform>
</c:set>

<%-- Write to the stats database --%>
<agg:write_stats rootPath="car" tranId="${tranId}" debugXml="${stats}" />

<go:log source="car_quote_results.jsp" >RESULTS ${resultXml}</go:log>
<go:log source="car_quote_results.jsp" >TRANSFER ${stats}</go:log>
<%-- Return the results as json --%>

<c:forEach var="result" items="${soapdata['soap-response/results/result']}" varStatus='vs'>
	<x:parse doc="${go:getEscapedXml(result)}" var="resultXml" />
	<c:set var="productId"><x:out select="$resultXml/result/@productId" /></c:set>
	<c:set var="excess"><x:out select="$resultXml/result/excess/total" /></c:set>
			<c:set var="baseExcess"><x:out select="$resultXml/result/excess/base" /></c:set>
	<c:set var="kms"><x:out select="$resultXml/result/headline/kms" /></c:set>
	<c:set var="terms"><x:out select="$resultXml/result/headline/terms" /></c:set>

	<sql:query var="featureResult">
		SELECT general.description, features.description, features.field_value
				FROM aggregator.features
					INNER JOIN aggregator.general ON general.code = features.code
			WHERE features.productId = ?
			ORDER BY general.orderSeq
		<sql:param>${productId}</sql:param>
	</sql:query>

	<c:set var="features">
		<compareFeatures>
			<features featureId="Excess" desc="Excess" value="$${excess}" extra="" />
			<c:forEach var="feature" items="${featureResult.rowsByIndex}" varStatus='status'>

				<c:set var="value">${feature[2]}</c:set>
				<c:set var="extra">${fn:escapeXml(feature[1])}</c:set>

				<c:if test="${fn:contains(feature[2], '[xx,xxx]')}">
					<c:set var="value">${ fn:replace(feature[2], '[xx,xxx]', kms) }</c:set>
				</c:if>

				<c:if test="${value == 'S'}">
					<c:set var="value">${feature[1]}</c:set>
					<c:set var="extra">${terms}</c:set>
				</c:if>

				<features featureId="${feature[0]}" desc="${feature[0]}" value="${fn:escapeXml(value)}" extra="${extra}" />
			</c:forEach>
		</compareFeatures>
	</c:set>
	<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${features}" />

			<c:if test="${not empty baseExcess and baseExcess != '600'}">
				<go:setData dataVar="data" xpath="quote/baseExcess" value="${baseExcess}" />
			</c:if>

</c:forEach>

		<go:setData dataVar="soapdata" xpath="soap-response/results/info/transactionId" value="${tranId}" />

<%-- Write result details to the database for potential later use when sending emails etc... FYI - NEVER STORE PREMIUM IN THE DATABASE FOR CAR VERTICAL --%>
<agg:write_result_details transactionId="${tranId}" recordXPaths="productDes,excess/total,headline/name,quoteUrl,telNo,openingHours,leadNo"/>

${go:XMLtoJSON(go:getEscapedXml(soapdata['soap-response/results']))}
		</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="car_quote_results.jsp"/>
	</c:otherwise>
</c:choose>
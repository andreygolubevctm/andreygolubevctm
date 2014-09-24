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
<c:set var="okToCall"><%-- Input now a checkbox rather than Y/N --%>
	<c:choose>
		<c:when test="${not empty data.quote.contact.oktocall}">${data.quote.contact.oktocall}</c:when>
		<c:otherwise>N</c:otherwise>
	</c:choose>
</c:set>
<c:set var="items">CarInsurance = CarInsurance,okToCall = ${okToCall},marketing = ${data.quote.contact.marketing}</c:set>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/car_quote_results.jsp" quoteType="car" />
</c:if>
			
<%-- Save data --%>
<core:transaction touch="R" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

<%-- Fetch and store the transaction id --%>
<c:set var="tranId" value="${data['current/transactionId']}" />

<go:setData dataVar="data" xpath="quote/transactionId" value="${tranId}" />



<go:soapAggregator 	config = ""
 					configDbKey="carQuoteService"
					verticalCode="CAR"
					styleCodeId="${pageSettings.getBrandId()}"
					transactionId = "${data.text['current/transactionId']}" 
					xml = "${go:getEscapedXml(data['quote'])}" 
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					continueOnValidationError="${continueOnValidationError}"
					isValidVar="isValid" />

<c:choose>
	<c:when test="${isValid || continueOnValidationError}" >
		<c:if test="${!isValid}"><go:setData dataVar="data" xpath="quote/testD" value="${data.current.transactionId}" />
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="car_quote_results.jsp" transactionId="${data.current.transactionId}"
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
		<agg:write_stats rootPath="quote" tranId="${tranId}" debugXml="${stats}" />

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
				SELECT general.description, features.description, features.field_value, features.code
				FROM aggregator.features
					INNER JOIN aggregator.general ON general.code = features.code
			WHERE features.productId = ?
			ORDER BY general.orderSeq
		<sql:param>${productId}</sql:param>
	</sql:query>

			<c:set var="featuresXml">
				<features>
					<excess desc="Excess" value="$${excess}" extra="" />

					<%-- Conditions --%>
					<x:if select="count($resultXml/result/conditions/condition) > 0">
						<x:choose>
							<%-- Multiple conditions --%>
							<x:when select="count($resultXml/result/conditions/condition) > 1">
								<c:set var="conditions">
									<x:forEach select="$resultXml/result/conditions/condition" var="condition">
										<x:out select="$condition" />

										<%-- Append a fullstop --%>
										<x:if select="substring($condition, string-length($condition)) != '.'"><c:out value="." /></x:if>

										<c:out value=" " />
									</x:forEach>
								</c:set>
							</x:when>
							<%-- Single condition --%>
							<x:otherwise>
								<c:set var="conditions"><x:out select="$resultXml/result/conditions/condition" /></c:set>
							</x:otherwise>
						</x:choose>

						<c:if test="${fn:length(fn:trim(conditions)) > 0}">
							<conditions value="${fn:trim(conditions)}" extra="" />
						</c:if>
					</x:if>

					<%-- Loop through all the database features --%>
			<c:forEach var="feature" items="${featureResult.rowsByIndex}" varStatus='status'>

						<c:set var="label">${feature[0]}</c:set>
						<c:set var="extra">${fn:escapeXml(feature[1])}</c:set>
				<c:set var="value">${feature[2]}</c:set>
						<c:set var="code">${feature[3]}</c:set>

						<c:if test="${fn:contains(value, '[xx,xxx]')}">
							<c:set var="value">${ fn:replace(value, '[xx,xxx]', kms) }</c:set>
				</c:if>

				<c:if test="${value == 'S'}">
					<c:set var="value">${feature[1]}</c:set>
					<c:set var="extra">${terms}</c:set>
				</c:if>

						<c:if test="${code ne ''}">
						<${code} value="${fn:escapeXml(value)}" extra="${extra}" />
						</c:if>
			</c:forEach>
				</features>
	</c:set>
			<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${featuresXml}" />

			<c:if test="${not empty baseExcess and baseExcess != '600'}">
				<go:setData dataVar="data" xpath="quote/baseExcess" value="${baseExcess}" />
			</c:if>

</c:forEach>

		<go:setData dataVar="soapdata" xpath="soap-response/results/info/transactionId" value="${tranId}" />

<%-- Write result details to the database for potential later use when sending emails etc... FYI - NEVER STORE PREMIUM IN THE DATABASE FOR CAR VERTICAL --%>
		<agg:write_result_details transactionId="${tranId}" recordXPaths="productDes,excess/total,headline/name,quoteUrl,telNo,openingHours,leadNo,brandCode" sessionXPaths="headline/lumpSumTotal"/>

${go:XMLtoJSON(go:getEscapedXml(soapdata['soap-response/results']))}

		<%-- COMPETITION APPLICATION START --%>
		<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
		<c:set var="optedInForComp" value="${data['quote/contact/competition/optin'] == 'Y' }" />
		<c:if test="${competitionEnabledSetting eq 'Y' and not callCentre and optedInForComp}">
			<c:choose>
				<c:when test="${not empty data['quote/contact/phone']}">
					<c:set var="contactPhone" value="${data['quote/contact/phone']}"/>
		</c:when>
			</c:choose>

			<c:import var="response" url="/ajax/write/competition_entry.jsp">
				<c:param name="secret">Ja1337c0Bru1z2</c:param>
				<c:param name="competition_email" value="${fn:trim(data['quote/contact/email'])}" />
				<c:param name="competition_firstname" value="${fn:trim(data['quote/drivers/regular/firstname'])}" />
				<c:param name="competition_lastname" value="${fn:trim(data['quote/drivers/regular/surname'])}" />
				<c:param name="competition_phone" value="${contactPhone}" />
			</c:import>
		</c:if>
		<%-- COMPETITION APPLICATION END --%>
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="car_quote_results.jsp"/>
	</c:otherwise>
</c:choose>
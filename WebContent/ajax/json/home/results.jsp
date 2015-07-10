<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="verticalCode" value="HOME" />

<session:get settings="true" authenticated="true" verticalCode="${verticalCode}" />

<jsp:useBean id="soapdata" class="com.disc_au.web.go.Data" scope="request" />
<jsp:useBean id="sessionError" class="java.util.ArrayList" scope="request" />

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="continueOnValidationError" value="${false}" />

<c:set var="vertical" value="home" />
<c:set var="touch" value="R" />
<c:set var="valid" value="true" />

<jsp:useBean id="homeService" class="com.ctm.services.home.HomeService" scope="page" />
<c:set var="serviceRespone" value="${homeService.validate(pageContext.request, data)}" />

<%--
	home/results.jsp

	Main workhorse for writing quotes and getting prices.
	It does the following:
	- Gets a new transaction id (passing the old one if it exists so we can link the old and new quotes)
	- Initialises the SOAP Aggregator gadget
	- Passes the client information to the SOAP Aggregator gadget to fetch prices
	- Returns the SOAP response to the page as a JSON object

	@param quote_*	- Full home quote values

--%>

<c:choose>
	<c:when test="${not empty param.action and param.action == 'latest'}">
		<c:set var="writeQuoteOverride" value="N" />
	</c:when>
	<c:when test="${not empty param.action and param.action == 'change_excess'}">
	<c:if test="${sessionDataService.getClientSessionTimeout(pageContext.request) <= 0}">
		<c:set var="valid" value="false" />
	</c:if>
		<go:setData dataVar="data" xpath="${vertical}/homeExcess" value="${param.building_excess}" />
		<go:setData dataVar="data" xpath="${vertical}/contentsExcess" value="${param.contents_excess}" />

		<go:log source="home_results">UPDATING EXCESS: HOME:${param.building_excess} CONTENTS: ${param.contents_excess}</go:log>

		<c:set var="writeQuoteOverride" value="Y" />
		<c:set var="touch" value="Q" />
	</c:when>
	<c:otherwise>
		<security:populateDataFromParams rootPath="${vertical}" />
		<c:set var="writeQuoteOverride" value="" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${valid == false}">
		<agg:outputValidationFailureJSON validationErrors="${sessionError}"  origin="home/results_jsp"/>
	</c:when>
	<c:when test="${!homeService.isValid()}">
		${serviceRespone}
	</c:when>
	<c:otherwise>
		<c:if test="${empty data.home.property.address.streetNum && empty data.home.property.address.houseNoSel}">
	<go:setData dataVar="data" xpath="${vertical}/property/address/streetNum" value="0" />
		</c:if>

		<%-- RECOVER: if things have gone pear shaped --%>
		<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/home/results.jsp" quoteType="${vertical}" />
		</c:if>

		<%-- <go:setData dataVar="data" xpath="${vertical}" value="*DELETE" /> --%>
		<go:setData dataVar="data" value="*PARAMS" />

		<go:setData dataVar="data" xpath="${vertical}/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="${vertical}/clientUserAgent" value="${header['User-Agent']}" />

		<%-- Fix the commencement date if prior to the current date --%>
		<c:set var="sanitisedCommencementDate">
			<agg:sanitiseCommencementDate commencementDate="${data.home.startDate}" dateFormat="dd/MM/yyyy" />
		</c:set>
		<c:if test="${sanitisedCommencementDate ne data.home.startDate}">
			<go:setData dataVar="data" xpath="${vertical}/startDate" value="${sanitisedCommencementDate}" />
			<c:set var="commencementDateUpdated" value="true" />
		</c:if>

		<go:log level="DEBUG" source="home_results">CURRENT DATA = ${data.home}</go:log>

		<%-- Save client data --%>
		<core:transaction touch="${touch}" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

		<%-- Fetch and store the transaction id --%>
		<c:set var="tranId" value="${data['current/transactionId']}" />
		<go:setData dataVar="data" xpath="${vertical}/transactionId" value="${data['current/transactionId']}" />

		<go:soapAggregator 	config = ""
							styleCodeId="${pageSettings.getBrandId()}"
							verticalCode="${verticalCode}"
							configDbKey="homeQuoteService"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['home'])}"
					var = "resultXml"
							authToken = "${param.home_authToken}"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
							continueOnValidationError="${continueOnValidationError}" />

		<c:choose>
	<c:when test="${isValid || continueOnValidationError}" >
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="home/results.jsp"
						errorMessage="message:${validationError.message} elementXpath:${validationError.elementXpath} elements:${validationError.elements}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>

		<c:import var="transferXml" url="/WEB-INF/xslt/AGGTRS_home.xsl"/>

		<c:set var="stats">
			<x:transform xml="${debugXml}" xslt="${transferXml}">
				<x:param name="homeExcess" value="${data['home/baseHomeExcess']}" />
				<x:param name="contentsExcess" value="${data['home/baseContentsExcess']}" />
			</x:transform>
		</c:set>

		<%-- Write to the stats database --%>
		<agg:write_stats rootPath="${vertical}" tranId="${tranId}" debugXml="${stats}"/>

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="soapdata" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="soapdata" xpath="soap-response" xml="${resultXml}" />
		<go:setData dataVar="soapdata" xpath="soap-response/results/transactionId" value="${tranId}" />
		<go:setData dataVar="soapdata" xpath="soap-response/results/info/transactionId" value="${tranId}" />

				<%-- !!IMPORTANT!! - ensure the trackingKey is passed back with results --%>
				<go:setData dataVar="soapdata" xpath="soap-response/results/info/trackingKey" value="${data.home.trackingKey}" />

				<c:if test="${not empty commencementDateUpdated}">
					<go:setData dataVar="soapdata" xpath="soap-response/results/events/COMMENCEMENT_DATE_UPDATED" value="${data.home.startDate}" />
				</c:if>

				<%--Calculate the end valid date for these quotes --%>
				<c:set var="validateDate">
					<agg:email_valid_date dateFormat="dd MMMMM yyyy" />
				</c:set>

				<%-- Construct the best price lead info - only if opted in for call --%>
				<c:set var="okToCall"><%-- Input now a checkbox rather than Y/N --%>
					<c:choose>
						<c:when test="${not empty data.home.policyHolder.oktocall}">${data.home.policyHolder.oktocall}</c:when>
						<c:otherwise>N</c:otherwise>
					</c:choose>
				</c:set>
				<c:set var="fullName" value="${fn:trim(data.home.policyHolder.firstName)}${' '}${fn:trim(data.home.policyHolder.lastName)}" />
				<c:set var="leadFeedData">
				<%-- Build as concatenated string to reduce number of joins to pull data out --%>
				<leadfeedinfo><c:if test="${okToCall eq 'Y'}">${fn:trim(fullName)}</c:if>||<c:if test="${okToCall eq 'Y'}">${data.home.policyHolder.phone}</c:if>||<c:if test="${okToCall eq 'Y'}">${data.home.property.address.dpId}</c:if>||<c:if test="${okToCall eq 'Y'}">${data.home.property.address.state}</c:if></leadfeedinfo>
				</c:set>

				<c:forEach var="result" items="${soapdata['soap-response/results/result']}" varStatus='vs'>

					<%-- Add the quote valid date to result --%>
					<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${validateDate}" />

					<%-- Add best price lead feed fields to result --%>
					<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${leadFeedData}" />

					<x:parse doc="${go:getEscapedXml(result)}" var="resultXml" />
					<c:set var="productId"><x:out select="$resultXml/result/@productId" /></c:set>

			<c:set var="homeExcess"><x:out select="$resultXml/result/HHB/excess/amount" /></c:set>
			<c:set var="contentsExcess"><x:out select="$resultXml/result/HHC/excess/amount" /></c:set>
			<c:set var="terms"><x:out select="$resultXml/result/headline/terms" /></c:set>
					<c:set var="offer"><x:out select="$resultXml/result/headline/offer" /></c:set>

			<c:set var="productName"><x:out select="$resultXml/result/headline/name" /></c:set>

					<%-- Set flag to indicate this is a Hollard product. --%>
					<c:set var="brandCode"><x:out select="$resultXml/result/brandCode" /></c:set>
					<c:set var="isHollard">
			<c:choose>
							<c:when test="${brandCode eq 'WOOL' or brandCode eq 'REIN'}">${true}</c:when>
							<c:otherwise>${false}</c:otherwise>
						</c:choose>
					</c:set>

					<c:choose>
				<c:when test="${not empty homeExcess and not empty contentsExcess}">
					<c:set var="quoteType">HHZ</c:set>
					<c:set var="coverType">Home &amp; Contents</c:set>
				</c:when>
				<c:when test="${not empty homeExcess}">
					<c:set var="quoteType">HHB</c:set>
					<c:set var="coverType">Home</c:set>
				</c:when>
				<c:when test="${not empty contentsExcess}">
					<c:set var="quoteType">HHC</c:set>
					<c:set var="coverType">Contents</c:set>
				</c:when>
			</c:choose>

			<c:set var="homeProductId">${productId}-${quoteType}</c:set>

					<sql:query var="featureResult">
						SELECT general.description, features.description, features.field_value, features.code
						FROM aggregator.features
							INNER JOIN aggregator.general ON general.code = features.code
							WHERE features.productId = ?
							ORDER BY general.orderSeq
						<sql:param>${homeProductId}</sql:param>
					</sql:query>

					<%-- Add homeProductId to resultset to use for tracking --%>
					<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="<trackingProductId>${homeProductId}</trackingProductId>" />

					<%-- OLD style features (decommission this once we no longer need to support non-AMS vertical) --%>
					<c:set var="features">
						<compareFeatures>
							<c:if test="${not empty homeExcess}">
								<features featureId="homeExcess" desc="Home Excess" value="$${homeExcess}" extra="" />
							</c:if>
							<c:if test="${not empty contentsExcess}">
								<features featureId="contentsExcess" desc="Contents Excess" value="$${contentsExcess}" extra="" />
							</c:if>

					<features featureId="coverType" desc="Cover Type" value="${coverType}" extra="" />
					<features featureId="product" desc="Product" value="${productName}" extra="" />

					<c:forEach var="feature" items="${featureResult.rowsByIndex}" varStatus='status'>

						<c:set var="value">${feature[2]}</c:set>
						<c:set var="extra">${fn:escapeXml(feature[1])}</c:set>

								<c:choose>
									<c:when test="${value == 'S' and isHollard eq false}">
							<c:set var="value">${feature[1]}</c:set>
							<c:set var="extra">${terms}</c:set>
									</c:when>
									<%-- Special Offer content for Hollard is taken from the service --%>
									<c:when test="${value == 'S' and isHollard eq true}">
										<c:set var="value"><x:out select="$resultXml/result/feature" /></c:set>
										<c:set var="extra"><x:out select="$resultXml/result/terms" /></c:set>
									</c:when>
								</c:choose>

						<features featureId="${feature[0]}" desc="${feature[0]}" value="${fn:escapeXml(value)}" extra="${extra}" />

					</c:forEach>

							<c:if test="${isHollard eq true}">
								<features featureId="${feature[0]}" desc="${feature[0]}" value="${fn:escapeXml(value)}" extra="${extra}" />
							</c:if>
				</compareFeatures>
			</c:set>
			<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${features}" />

					<%-- NEW style features --%>
					<c:set var="featuresXml">
						<features>
							<homeExcess desc="Home Excess" value="$${homeExcess}" extra="" />
							<contentsExcess desc="Contents Excess" value="$${contentsExcess}" extra="" />

							<cvrTyp desc="Cover Type" value="${coverType}" extra="" />
							<product desc="Product" value="${productName}" extra="" />

							<%-- Loop through all the database features --%>
							<c:forEach var="feature" items="${featureResult.rowsByIndex}" varStatus='status'>

								<c:set var="label">${feature[0]}</c:set>
								<c:set var="extra">${fn:escapeXml(feature[1])}</c:set>
								<c:set var="value">${feature[2]}</c:set>
								<c:set var="code">${feature[3]}</c:set>

								<c:if test="${value == 'S'}">
									<c:choose>
										<c:when test="${fn:contains(productId, 'BUDD')}">
											<c:set var="value">${feature[1]}</c:set>
										</c:when>
										<c:otherwise>
									<c:set var="value">${offer}</c:set>
										</c:otherwise>
									</c:choose>
									<c:set var="extra">${terms}</c:set>
								</c:if>

								<c:if test="${code ne ''}">
								<${code} value="${fn:escapeXml(value)}" extra="${extra}" />
								</c:if>
							</c:forEach>
						</features>
					</c:set>
					<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${featuresXml}" />

				</c:forEach>

				<%--
					Write result details to the database for potential later use when sending emails etc...
					Note: premium data can not be stored in the DB, placed in session instead
				--%>
				<agg:write_result_details transactionId="${tranId}" recordXPaths="leadfeedinfo,validateDate/display,validateDate/normal,productId,productDes,des,HHB/excess/amount,HHC/excess/amount,headline/name,quoteUrl,telNo,openingHours,leadNo,brandCode" sessionXPaths="price/annual/total" baseXmlNode="soap-response/results/result" />

		${go:XMLtoJSON(go:getEscapedXml(soapdata['soap-response/results']))}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="home/results_jsp"/>
	</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
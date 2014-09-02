<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="HOME" />

<jsp:useBean id="soapdata" class="com.disc_au.web.go.Data" scope="request" />
<jsp:useBean id="sessionError" class="java.util.ArrayList" scope="request" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="continueOnValidationError" value="${true}" />

<c:set var="vertical" value="home" />
<c:set var="touch" value="R" />
<c:set var="valid" value="true" />

<%--
	home/results.jsp

	Main workhorse for writing quotes and getting prices.
	It does the following:
	- Gets a new transaction id (passing the old one if it exists so we can link the old and new quotes)
	- Calls NTAGGTIC to write the client's data in AGGDTL detail file (and create the AGMHDR header record)
	- Initialises the SOAP Aggregator gadget
	- Passes the client information to the SOAP Aggregator gadget to fetch prices
	- Calls AGGTRS to write the initial stats (passing the SOAP response data)
	- Returns the SOAP response to the page as a JSON object

	@param quote_*	- Full home quote values

--%>

<c:choose>
	<c:when test="${not empty param.action and param.action == 'latest'}">
		<c:set var="writeQuoteOverride" value="N" />
	</c:when>
	<c:when test="${not empty param.action and param.action == 'change_excess'}">
	<c:if test="${empty data.session}">
		<c:set var="valid" value="false" />
	</c:if>
		<go:setData dataVar="data" xpath="${vertical}/homeExcess" value="${param.building_excess}" />
		<go:setData dataVar="data" xpath="${vertical}/contentsExcess" value="${param.contents_excess}" />

		<go:log>UPDATING EXCESS: HOME:${param.building_excess} CONTENTS: ${param.contents_excess}</go:log>

		<c:set var="writeQuoteOverride" value="Y" />
		<c:set var="touch" value="Q" />
	</c:when>
	<c:otherwise>
		<%-- Set data from the form and call AGGTIC to write the client data to tables --%>
		<%-- Note, we do not wait for it to return - this is a "fire and forget" request --%>
		<security:populateDataFromParams rootPath="${vertical}" />
		<c:set var="writeQuoteOverride" value="" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${valid == false}">
		<agg:outputValidationFailureJSON validationErrors="${sessionError}"  origin="home/results_jsp"/>
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

		<go:log>CURRENT DATA = ${data.home}</go:log>

		<%-- Save client data --%>
		<core:transaction touch="${touch}" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

		<%-- Fetch and store the transaction id --%>
		<c:set var="tranId" value="${data['current/transactionId']}" />
		<go:setData dataVar="data" xpath="${vertical}/transactionId" value="${data['current/transactionId']}" />


		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:import var="config" url="/WEB-INF/aggregator/home/config_results.xml" />
		<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['home'])}"
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					continueOnValidationError="${continueOnValidationError}"
		/>

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

		<c:forEach var="result" items="${soapdata['soap-response/results/result']}" varStatus='vs'>
			<x:parse doc="${go:getEscapedXml(result)}" var="resultXml" />
			<c:set var="productId"><x:out select="$resultXml/result/@productId" /></c:set>

			<c:set var="homeExcess"><x:out select="$resultXml/result/HHB/excess/amount" /></c:set>
			<c:set var="contentsExcess"><x:out select="$resultXml/result/HHC/excess/amount" /></c:set>
			<c:set var="terms"><x:out select="$resultXml/result/headline/terms" /></c:set>

			<c:set var="productName"><x:out select="$resultXml/result/headline/name" /></c:set>

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
				SELECT general.description, features.description, features.field_value
				FROM aggregator.features
					INNER JOIN aggregator.general ON general.code = features.code
					WHERE features.productId = ?
					ORDER BY general.orderSeq
				<sql:param>${homeProductId}</sql:param>
			</sql:query>

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

						<c:if test="${value == 'S'}">
							<c:set var="value">${feature[1]}</c:set>
							<c:set var="extra">${terms}</c:set>
						</c:if>

						<features featureId="${feature[0]}" desc="${feature[0]}" value="${fn:escapeXml(value)}" extra="${extra}" />
					</c:forEach>
				</compareFeatures>
			</c:set>
			<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${features}" />

		</c:forEach>

<%--
			Write result details to the database for potential later use when sending emails etc... 
			Note: premium data can not be stored in the DB, placed in session instead
--%>
 		<agg:write_result_details transactionId="${tranId}" recordXPaths="productDes,des,HHB/excess/amount,HHC/excess/amount,headline/name,quoteUrl,telNo,openingHours,leadNo,brandCode" sessionXPaths="price/annual/total"/> 

		${go:XMLtoJSON(go:getEscapedXml(soapdata['soap-response/results']))}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="home/results_jsp"/>
	</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
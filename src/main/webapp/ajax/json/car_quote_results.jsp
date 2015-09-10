<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="CAR" />

<jsp:useBean id="soapdata" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="continueOnValidationError" value="${false}" />

<%--
	car_quote_results.jsp

	Main workhorse for writing quotes and getting prices.
	It does the following:
	- Gets a new transaction id (passing the old one if it exists so we can link the old and new quotes)
	- Initialises the SOAP Aggregator gadget
	- Passes the client information to the SOAP Aggregator gadget to fetch prices
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
<c:set var="marketing" value="${data.quote.contact.marketing}" />
<c:set var="items">CarInsurance = CarInsurance,okToCall = ${okToCall},marketing = ${marketing}</c:set>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/car_quote_results.jsp" quoteType="car" />
</c:if>

<%-- Fix the commencement date if prior to the current date --%>
<c:set var="sanitisedCommencementDate">
	<agg:sanitiseCommencementDate commencementDate="${data.quote.options.commencementDate}" dateFormat="dd/MM/yyyy" />
</c:set>
<c:if test="${sanitisedCommencementDate ne data.quote.options.commencementDate}">
	<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${sanitisedCommencementDate}" />
	<c:set var="commencementDateUpdated" value="true" />
</c:if>

<%-- Save data --%>
<core:transaction touch="R" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

<%-- Fetch and store the transaction id --%>
<c:set var="tranId" value="${data['current/transactionId']}" />

<go:setData dataVar="data" xpath="quote/transactionId" value="${tranId}" />

<%-- Add accessorie descriptions to databucket --%>

<jsp:useBean id="carService" class="com.ctm.services.car.CarVehicleSelectionService" scope="request"/>
<c:set var="accListResult" value="${carService.getVehicleNonStandardMappings()}"/>

<c:set var="accsList" value="${data['quote/accs/*']}"/>

<c:catch var="error">
	<%-- This will fail if only a single accessory --%>
	<c:forEach var="accs" items="${accsList}">
		<c:set var="accDesc" value=""/>
		<x:parse doc="${go:getEscapedXml(accs)}" var="accsXML" />
		<c:set var="accsPath"><x:out select="name($accsXML/*)" /></c:set>
		<c:set var="accsCode"><x:out select="$accsXML/*/sel" /></c:set>
		<c:if test="${fn:contains(accsCode, '&amp;')}">
			<c:set var="accsCode" value="${fn:replace(accsCode,'&amp;','&')}" />
		</c:if>
		<c:forEach items="${accListResult}" var="accList" varStatus="status">
			<c:if test="${accList.code == accsCode and accList.underwriter == 'HOLL'}">
				<c:set var="accHOLLDesc" value="${accList.des }"/>
			</c:if>
			<c:if test="${accList.code == accsCode and accList.underwriter == 'AGIS'}">
				<c:set var="accAGISDesc" value="${accList.des }"/>
			</c:if>
		</c:forEach>
		<go:setData dataVar="data" xpath="quote/accs/${accsPath}/desc/HOLL" value="${accHOLLDesc}" />
		<go:setData dataVar="data" xpath="quote/accs/${accsPath}/desc/AGIS" value="${accAGISDesc}" />
	</c:forEach>
</c:catch>

<%-- If single accessory failed above then simply parse the object rather than iterating over it --%>
<c:if test="${not empty error}">
	<c:set var="accs" value="${accsList}" />
	<c:set var="accDesc" value=""/>
	<x:parse doc="${go:getEscapedXml(accs)}" var="accsXML" />
	<c:set var="accsPath"><x:out select="name($accsXML/*)" /></c:set>
	<c:set var="accsCode"><x:out select="$accsXML/*/sel" /></c:set>
	<c:if test="${fn:contains(accsCode, '&amp;')}">
		<c:set var="accsCode" value="${fn:replace(accsCode,'&amp;','&')}" />
	</c:if>
	<c:forEach items="${accListResult}" var="accList" varStatus="status">
		<c:if test="${accList.code == accsCode and accList.underwriter == 'HOLL'}">
			<c:set var="accHOLLDesc" value="${accList.des }"/>
		</c:if>
		<c:if test="${accList.code == accsCode and accList.underwriter == 'AGIS'}">
			<c:set var="accAGISDesc" value="${accList.des }"/>
		</c:if>
	</c:forEach>
	<go:setData dataVar="data" xpath="quote/accs/${accsPath}/desc/HOLL" value="${accHOLLDesc}" />
	<go:setData dataVar="data" xpath="quote/accs/${accsPath}/desc/AGIS" value="${accAGISDesc}" />
</c:if>

<%-- Accessories End --%>

<jsp:useBean id="carValidationService" class="com.ctm.services.car.CarService" scope="page" />
<c:set var="serviceRespone" value="${carValidationService.validate(pageContext.request, data)}" />

<c:choose>
	<c:when test="${!carValidationService.isValid()}">
		${serviceRespone}
	</c:when>
	<c:otherwise>
		<go:soapAggregator 	config = ""
							  configDbKey="carQuoteService"
							  verticalCode="CAR"
							  styleCodeId="${pageSettings.getBrandId()}"
							  transactionId = "${data.text['current/transactionId']}"
							  xml = "${go:getEscapedXml(data['quote'])}"
							  var = "resultXml"
							  authToken = "${param.quote_filter_authToken}"
							  debugVar="debugXml"
							  validationErrorsVar="validationErrors"
							  continueOnValidationError="${continueOnValidationError}"
							  isValidVar="isValid" />

		<c:set var="styleCodeId" value="${pageSettings.getBrandId()}" />
		<%--<c:if test="${styleCodeId == 8}">
			<c:set var="insuranceTypeId" value="8" />
			<c:set var="choosiCustomerFirstName" value="${data.quote.drivers.regular.firstname}" />
			<c:set var="choosiCustomerLastName" value="${data.quote.drivers.regular.surname}" />
			<c:set var="choosiCustomerEmail" value="${data.quote.contact.email}" />
			<c:set var="choosiCustomerPhone" value="${data.quote.contact.phoneinput}" />
			<c:set var="choosiCustomerCallOptIn" value="${okToCall}" />
			<c:set var="choosiCustomerMarketingOptIn" value="${marketing}" />
			<jsp:useBean id="ChoosiLeadFeedService" class="com.ctm.services.leadfeed.ChoosiLeadFeedService" scope="application" />
			${ChoosiLeadFeedService.setChoosiLeadFeed(insuranceTypeId, choosiCustomerFirstName, choosiCustomerEmail, choosiCustomerPhone, choosiCustomerCallOptIn, choosiCustomerMarketingOptIn, choosiCustomerLastName)}
		</c:if>--%>

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

				<go:log source="car_quote_results_jsp" level="DEBUG" >${tranId}: RESULTS ${resultXml}</go:log>
				<go:log source="car_quote_results_jsp" >${tranId}: TRANSFER ${stats}</go:log>
				<%-- Return the results as json --%>

				<%-- Calculate the end valid date for these quotes --%>
				<c:set var="validateDate">
					<agg:email_valid_date dateFormat="dd MMMMM yyyy" />
				</c:set>

				<%-- Construct the best price lead info - only if opted in for call --%>
				<c:set var="fullName" value="${fn:trim(data.quote.drivers.regular.firstname)}${' '}${fn:trim(data.quote.drivers.regular.surname)}" />
				<c:set var="leadFeedData">
					<%-- Build as concatenated string to reduce number of joins to pull data out --%>
					<leadfeedinfo><c:if test="${not empty okToCall and okToCall eq 'Y'}">${fn:trim(fullName)}</c:if>||<c:if test="${not empty okToCall and okToCall eq 'Y'}">${data.quote.contact.phone}</c:if>||<c:if test="${not empty okToCall and okToCall eq 'Y'}">${data.quote.vehicle.redbookCode}</c:if>||<c:if test="${not empty okToCall and okToCall eq 'Y'}">${data.quote.riskAddress.state}</c:if></leadfeedinfo>
				</c:set>

				<c:set var="isSingleResult" value="false" />
				<c:if test="${not(fn:startsWith(soapdata['soap-response/results/result'], '[')) and not(empty soapdata['soap-response/results/result'])}">
					<c:set var="isSingleResult" value="true" />
				</c:if>

				<c:choose>
					<c:when test="${isSingleResult eq 'true'}">
						<c:set var="xmlAsArray" value="[${soapdata['soap-response/results/result']}]" />
					</c:when>
					<c:otherwise>
						<c:set var="xmlAsArray" value="${soapdata['soap-response/results/result']}" />
					</c:otherwise>
				</c:choose>

				<c:forEach var="result" items="${xmlAsArray}" varStatus='vs'>

					<%-- Add the quote valid date to result --%>
					<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${validateDate}" />

					<%-- Add best price lead feed fields to result --%>
					<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${leadFeedData}" />

					<x:parse doc="${go:getEscapedXml(result)}" var="resultXml" />
					<c:set var="productId"><x:out select="$resultXml/result/@productId" /></c:set>
					<c:set var="serviceRef"><x:out select="$resultXml/result/@service" /></c:set>
					<c:set var="excess"><x:out select="$resultXml/result/excess/total" /></c:set>
					<c:set var="baseExcess"><x:out select="$resultXml/result/excess/base" /></c:set>
					<c:set var="kms"><x:out select="$resultXml/result/headline/kms" /></c:set>
					<c:set var="terms"><x:out select="$resultXml/result/headline/terms" /></c:set>

					<%-- Set flag to indicate this is a Hollard product. --%>
					<c:set var="brandCode"><x:out select="$resultXml/result/brandCode" /></c:set>
					<c:set var="isHollard">
						<c:choose>
							<c:when test="${brandCode eq 'WOOL' or brandCode eq 'REIN'}">${true}</c:when>
							<c:otherwise>${false}</c:otherwise>
						</c:choose>
					</c:set>

					<%-- Knockout REAL when driver is Male, under 21 and REIN-01-02 (Comprehensive) --%>
					<c:if test="${brandCode eq 'REIN' and productId eq 'REIN-01-02'}">
						<jsp:useBean id="dateUtils" class="com.ctm.utils.common.utils.DateUtils" scope="request" />
						<c:set var="regDob" value="${data.quote.drivers.regular.dob}" />
						<c:set var="yngDob" value="${data.quote.drivers.young.dob}" />
						<c:if test="${(data.quote.drivers.regular.gender eq 'M' && dateUtils.getAgeFromDOBStr(regDob) < 21) || (not empty yngDob && data.quote.drivers.young.gender eq 'M' && dateUtils.getAgeFromDOBStr(yngDob) < 21)}">
							<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]/available" value="N" />
						</c:if>
					</c:if>

					<%-- Set flag to indicate this is an Auto & General product. --%>
					<c:set var="isAutoGeneral">
						<c:choose>
							<c:when test="${fn:startsWith(serviceRef, 'AGIS_')}">${true}</c:when>
							<c:otherwise>${false}</c:otherwise>
						</c:choose>
					</c:set>

					<fmt:parseNumber var="excessAsNum" type="number" value="${excess}" />
					<fmt:parseNumber var="dataBaseExcessAsNum" type="number" value="${data.quote.baseExcess}" />
					<fmt:parseNumber var="dataExcessAsNum" type="number" value="${data.quote.excess}" />

					<%-- Knock out results if excess is invalid for search --%>

					<%-- TEMP COMMENT OUT CODE TO ALLOW NXI TESTING
					<c:if test="${available eq 'Y' and ((empty data.quote.excess and excessAsNum > dataBaseExcessAsNum) || (not empty data.quote.excess and excessAsNum > dataExcessAsNum))}">
						<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="<available>N</available>" />
						<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]/headline" xml="<lumpSumTotal>9999999999</lumpSumTotal>" />
						<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]/onlinePrice" xml="<lumpSumTotal></lumpSumTotal>" />
						<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]/offlinePrice" xml="<lumpSumTotal></lumpSumTotal>" />

						<go:setData dataVar="soapdata" xpath="soap-response/results/info" xml="<excessKnockouts>true</excessKnockouts>" />
					</c:if>
					--%>

					<sql:query var="featureResult">
						SELECT features.description, features.description, features.field_value, features.code
						FROM aggregator.features as features
						WHERE features.productId = ?
						<sql:param>${productId}</sql:param>
					</sql:query>

					<%-- from get_scrapes.jsp --%>
					<sql:query var="scrapesIdResult">
						SELECT `description`
						FROM  aggregator.general
						WHERE `type` = 'carBrandScrapes'
						AND `code` = ?
						<sql:param value="${productId}" />
					</sql:query>

					<c:set var="scrapeIds" value="${ fn:split(scrapesIdResult.getRowsByIndex()[0][0], ',') }" />

					<c:set var="scrapeIdsList">
						<c:forEach var="id" varStatus="status" items="${scrapeIds}">${id}<c:if test="${!status.last}">, </c:if></c:forEach>
					</c:set>

					<sql:query var="scrapesResult">
						SELECT *
						FROM `ctm`.`scrapes`
						WHERE `group` = 'car'
						AND cssSelector in ('#inclusions', '#extras', '#benefits')
						AND (styleCodeId = ? OR stylecodeid = 0)
						AND `id` IN (
						<c:forEach var="id" varStatus="status" items="${scrapeIds}">
							?<c:if test="${!status.last}">,</c:if>
						</c:forEach>
						)
						ORDER BY `id`, styleCodeId DESC
						<sql:param value="${pageSettings.getBrandId()}" />
						<c:forEach var="id" varStatus="status" items="${scrapeIds}">
							<sql:param value="${id}" />
						</c:forEach>
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

												<c:out value="<br/>" />
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

								<c:choose>
									<%-- Replace product name with service value for features view --%>
									<c:when test="${code == 'product' and isHollard eq true}">
										<c:set var="value"><x:out select="$resultXml/result/headline/name" /></c:set>
									</c:when>
									<%-- Replace special with service value for features view --%>
									<c:when test="${value == 'S' and isHollard eq true}">
										<c:set var="value"><x:out select="$resultXml/result/headline/feature" /></c:set>
										<c:set var="extra">${terms}</c:set>
									</c:when>
									<%-- Ensure offer and offer terms comes from service except for
										non-autogeneral products where offer comes from db --%>
									<c:when test="${value == 'S'}">
										<c:choose>
											<c:when test="${isAutoGeneral eq true}">
												<c:set var="value"><x:out select="$resultXml/result/headline/feature" escapeXml="false" /></c:set>
											</c:when>
											<c:otherwise>
												<c:set var="value">${feature[1]}</c:set>
											</c:otherwise>
										</c:choose>
										<c:set var="extra">${terms}</c:set>
									</c:when>
								</c:choose>

								<c:if test="${code ne ''}">
									<${code} value="${fn:escapeXml(value)}" extra="${extra}" />
								</c:if>
							</c:forEach>

								<%-- Loop through all the database scrapes --%>
							<c:forEach var="scrapes" items="${scrapesResult.rows}" varStatus='status'>

								<c:set var="code">${fn:replace(scrapes.cssSelector, '#', '')}</c:set>
								<c:set var="value">${go:replaceAll(scrapes.html, '"', '\\\\"')}</c:set>

								<${code} value="${fn:escapeXml(value)}" extra="" />
							</c:forEach>

						</features>
					</c:set>
					<go:setData dataVar="soapdata" xpath="soap-response/results/result[${vs.index}]" xml="${featuresXml}" />

					<c:if test="${not empty baseExcess and baseExcess != '600'}">
						<go:setData dataVar="data" xpath="quote/baseExcess" value="${baseExcess}" />
					</c:if>

				</c:forEach>

				<go:setData dataVar="soapdata" xpath="soap-response/results/info/transactionId" value="${tranId}" />

				<%-- !!IMPORTANT!! - ensure the trackingKey is passed back with results --%>
				<go:setData dataVar="soapdata" xpath="soap-response/results/info/trackingKey" value="${data.quote.trackingKey}" />

				<c:if test="${not empty commencementDateUpdated}">
					<go:setData dataVar="soapdata" xpath="soap-response/results/events/COMMENCEMENT_DATE_UPDATED" value="${data.quote.options.commencementDate}" />
				</c:if>

				<%-- This condition exists because there is a problem with the forEach trying to iterate when there is only a single item.
					This is in place for NXS specific views. The reason we don't need to write_result_details is because if no one chooses to quote
					nothing is written, and this issue only occurs when a single providers shows (which only happens when AI does not quot. (three products turn into one.)) --%>
				<c:choose>
					<c:when test="${isSingleResult eq 'true'}">
						${go:XMLtoJSON(soapdata['soap-response/results'])}
					</c:when>
					<c:otherwise>
						<%-- Write result details to the database for potential later use when sending emails etc... FYI - NEVER STORE PREMIUM IN THE DATABASE FOR CAR VERTICAL --%>
						<agg:write_result_details transactionId="${tranId}" recordXPaths="leadfeedinfo,validateDate/display,validateDate/normal,productId,productDes,excess/total,headline/name,quoteUrl,telNo,openingHours,leadNo,brandCode" sessionXPaths="headline/lumpSumTotal" baseXmlNode="soap-response/results/result" />
						${go:XMLtoJSON(go:getEscapedXml(soapdata['soap-response/results']))}
					</c:otherwise>
				</c:choose>

			</c:when>
			<c:otherwise>
				<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="car_quote_results_jsp"/>
			</c:otherwise>
		</c:choose>

		<%-- COMPETITION APPLICATION START --%>
		<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
		<c:set var="optedInForComp" value="${data['quote/contact/competition/optin'] == 'Y' }" />
		<c:if test="${competitionEnabledSetting eq 'Y' and not callCentre and optedInForComp}">
			<c:set var="competitionId"><content:get key="competitionId"/></c:set>
			<c:choose>
				<c:when test="${not empty data['quote/contact/phone']}">
					<c:set var="contactPhone" value="${data['quote/contact/phone']}"/>
				</c:when>
			</c:choose>

			<c:import var="response" url="/ajax/write/competition_entry.jsp">
				<c:param name="secret">Ja1337c0Bru1z2</c:param>
				<c:param name="competitionId" value="${competitionId}" />
				<c:param name="competition_email" value="${fn:trim(data['quote/contact/email'])}" />
				<c:param name="competition_firstname" value="${fn:trim(data['quote/drivers/regular/firstname'])}" />
				<c:param name="competition_lastname" value="${fn:trim(data['quote/drivers/regular/surname'])}" />
				<c:param name="competition_phone" value="${contactPhone}" />
				<c:param name="transactionId" value="${tranId}" />
			</c:import>
		</c:if>
	</c:otherwise>
</c:choose>
<%-- COMPETITION APPLICATION END --%>

<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="health" />

<c:set var="continueOnValidationError" value="${true}" />

<%-- Save client data; use outcome to know if this transaction is already confirmed --%>
<c:set var="ct_outcome"><core:transaction touch="P" /></c:set>

<c:set var="tranId" value="${data.current.transactionId}" />

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- FIX frequency value to legacy so outbound soap messages work --%>
<c:set var="freq">
	<c:choose>
		<c:when test="${data['health/payment/details/frequency'] == 'annually'}">A</c:when>
		<c:when test="${data['health/payment/details/frequency'] == 'halfyearly'}">H</c:when>
		<c:when test="${data['health/payment/details/frequency'] == 'quarterly'}">Q</c:when>
		<c:when test="${data['health/payment/details/frequency'] == 'monthly'}">M</c:when>
		<c:when test="${data['health/payment/details/frequency'] == 'fortnightly'}">F</c:when>
		<c:when test="${data['health/payment/details/frequency'] == 'weekly'}">W</c:when>
	</c:choose>
</c:set>
<go:setData dataVar="data" xpath="health/payment/details/frequency" value="${freq}" />

<c:choose>
	<c:when test="${ct_outcome == 'C'}">
		<c:set var="errorMessage" value="Quote has already been submitted and confirmed." />
		<core:transaction touch="F" comment="${errorMessage}" noResponse="true" />
		{ "error": { "type":"confirmed", "message":"${errorMessage}" } }
	</c:when>

	<c:when test="${ct_outcome == 'V' or ct_outcome == 'I'}">
		<c:set var="errorMessage" value="Important details are missing from your session. Your session may have expired." />
		<core:transaction touch="F" comment="${errorMessage}" noResponse="true" />
		{ "error": { "type":"transaction", "message":"${errorMessage}" } }
	</c:when>

	<c:when test="${not empty ct_outcome}">
		<c:set var="errorMessage" value="Application submit error. Code=${ct_outcome}" />
		<core:transaction touch="F" comment="${errorMessage}" noResponse="true" />
		{ "error": { "type":"", "message":"${errorMessage}" } }
	</c:when>

	<c:otherwise>
		<%-- Adjust the base rebate using multiplier - this is to ensure the rebate applicable to the
			commencement date is sent to the provider --%>
		<health:changeover_rebates effective_date="${data.health.payment.details.start}" />
		<go:setData dataVar="data" xpath="health/rebate" value="${data.health.rebate * rebate_multiplier_current}" />

<%-- Get the fund specific data --%>
<c:set var="productId" value="${fn:substringAfter(param.health_application_productId,'HEALTH-')}" />
		<go:log level="INFO" source="health_application_jsp">Product Id = ${productId}</go:log>

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

		<go:log level="INFO" source="health_application_jsp" >Fund=${fund}</go:log>
		<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/health_application/${fund}/config.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}" 
					xml = "${go:getEscapedXml(data['health'])}" 
					var = "resultXml"
				debugVar="debugXml"
				validationErrorsVar="validationErrors"
				continueOnValidationError="${continueOnValidationError}"
				isValidVar="isValid" />
		<c:choose>
			<c:when test="${isValid || continueOnValidationError}">
				<c:if test="${!isValid}">
					<c:forEach var="validationError"  items="${validationErrors}">
						<error:non_fatal_error origin="health_application.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
					</c:forEach>
				</c:if>
<%-- //FIX: turn this back on when you are ready!!!! 
<%-- Write to the stats database 
<agg:write_stats tranId="${tranId}" debugXml="${debugXml}" />
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
				<c:set var="errorMessage" value="Application failed: ${errorMessage}" />
			<core:transaction touch="F" comment="${errorMessage}" noResponse="true" />

				<%-- Application unsuccessful, provide PendingID --%>
				<c:set var="pendingID">${pageContext.session.id}-${tranId}</c:set>
				<c:set var="pendingXml"><pendingID>${pendingID}</pendingID></result></c:set>
				<c:set var="resultXml" value="${fn:replace(resultXml, '</result>', pendingXml)}" />
				<go:setData dataVar="data" xpath="health/pendingID" value="${pendingID}" />

				<%-- Save to store error and pendingID --%>
				<c:set var="sandbox">
					<agg:write_quote rootPath="health" productType="HEALTH" triggeredsave="pending" triggeredsavereason="Pending: ${errorMessage}" />
				</c:set>

			<%-- Flag that this is being done by a call centre operator --%>
			<c:if test="${not empty callCentre}">
				<c:set var="resultXml" value="${fn:replace(resultXml, '</result>', '<callcentre>true</callcentre></result>')}" />
			</c:if>
		</c:if>
		</x:if>

		<%-- Set transaction to confirmed if application was successful --%>
		<x:choose>
			<x:when select="$resultOBJ//*[local-name()='success'] = 'true'">
				<core:transaction touch="C" noResponse="true" />

				<%-- Save confirmation record/snapshot --%>
				<c:import var="saveConfirmation" url="/ajax/write/save_health_confirmation.jsp">
					<c:param name="policyNo"><x:out select="$resultOBJ//*[local-name()='policyNo']" /></c:param>
					<c:param name="startDate" value="${data['health/payment/details/start']}" />
					<c:param name="frequency" value="${data['health/payment/details/frequency']}" />
				</c:import>

				<%-- Check outcome was ok --%>
				<x:parse doc="${saveConfirmation}" var="saveConfirmationXml" />
				<x:choose>
					<x:when select="$saveConfirmationXml/response/status = 'OK'">
						<c:set var="confirmationID"><x:out select="$saveConfirmationXml/response/confirmationID" /></c:set>
					</x:when>
					<x:otherwise></x:otherwise>
				</x:choose>
						<go:log level="INFO" source="health_application_jsp" >Saved confirmationID: ${confirmationID}</go:log>
				<c:set var="confirmationID"><confirmationID><c:out value="${confirmationID}" /></confirmationID></result></c:set>
				<c:set var="resultXml" value="${fn:replace(resultXml, '</result>', confirmationID)}" />
			</x:when>
			<%-- Was not successful --%>
			<x:otherwise>
				<%-- If no fail has been recorded yet --%>
				<c:if test="${empty errorMessage}">
					<core:transaction touch="F" comment="Application success=false" noResponse="true" />
				</c:if>
			</x:otherwise>
		</x:choose>

				<go:log source="health_application_jsp" level="DEBUG">${resultXml}</go:log>
				<go:log level="TRACE" source="health_application_jsp">${debugXml}</go:log>

		${go:XMLtoJSON(resultXml)}
			</c:when>
			<c:otherwise>
				<agg:outputValidationFailureJSON validationErrors="${validationErrors}" origin="health_application.jsp" />
	</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
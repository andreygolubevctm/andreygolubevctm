<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="UTILITIES" />

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="utilities" />

<c:set var="continueOnValidationError" value="${true}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/utilities_submit_lead.jsp" quoteType="utilities" />
</c:if>

<%-- Save client data: ***FIX: before using this a 'C' status needs to be identified.
<core:transaction touch="A" noResponse="true" />
--%>

<agg:write_email
	brand="CTM"
	vertical="UTILITIES"
	source="QUOTE"
	emailAddress="${data['utilities/leadFeed/email']}"
	firstName="${data['utilities/leadFeed/firstName']}"
	lastName="${data['utilities/leadFeed/lastName']}"
	items="marketing=Y,okToCall=Y" />

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="${ sessionScope.userIP }" />

<go:log level="INFO" source="utilities_submit_application">Utilities Tran Id = ${data['current/transactionId']}</go:log>
<c:set var="tranId" value="${data['current/transactionId']}" />

<jsp:useBean id="leadfeedService" class="com.ctm.services.utilities.UtilitiesLeadfeedService" scope="page" />

<c:set var="model" value="${leadfeedService.mapParametersToModel(pageContext.getRequest())}" />
<c:set var="submitResult" value="${leadfeedService.submit(pageContext.getRequest(), model)}" />
<c:if test="${not empty submitResult}"><go:log level="DEBUG" source="utilities_submit">${submitResult.toString()}</go:log></c:if>


<c:choose>
	<c:when test="${isValid || continueOnValidationError}">
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="utilities_submit_application.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>

		<%-- //FIX: turn this back on when you are ready!!!!
		<%-- Write to the stats database
		<agg:write_stats tranId="${tranId}" debugXml="${debugXml}" />
		--%>
		<c:set var="xmlData" value="<data>${go:JSONtoXML(submitResult)}</data>" />
		<x:parse var="parsedXml" doc="${xmlData}" />
<go:log>${xmlData}</go:log>
		<c:set var="uniqueId"><x:out select="$parsedXml/data/unique_id" /></c:set>
		<go:setData dataVar="data" xpath="utilities/leadFeed/confirmationId" value="${uniqueId}" />

		<core:transaction touch="P" noResponse="true" />

		<c:set var="confirmationkey" value="${pageContext.session.id}-${tranId}" />
		<go:setData dataVar="data" xpath="utilities/confirmationkey" value="${confirmationkey}" />

		<agg:write_confirmation transaction_id="${tranId}" confirmation_key="${confirmationkey}" vertical="${vertical}" xml_data="${xmlData}" />
		<agg:write_touch touch="C" transaction_id="${tranId}" />

		${submitResults}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="utilities_submit_application.jsp"/>
	</c:otherwise>
</c:choose>
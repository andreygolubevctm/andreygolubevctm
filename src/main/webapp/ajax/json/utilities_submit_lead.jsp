<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="UTILITIES" />
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.utilities_submit_lead')}" />

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

${logger.debug('Utilities Tran Id. {}',log:kv('current/transactionId',data['current/transactionId'] ))}
<c:set var="tranId" value="${data['current/transactionId']}" />

<jsp:useBean id="leadfeedService" class="com.ctm.web.utilities.services.UtilitiesLeadfeedService" scope="page" />

<c:set var="model" value="${leadfeedService.mapParametersToModel(pageContext.getRequest())}" />
<c:set var="submitResult" value="${leadfeedService.submit(pageContext.getRequest(), model)}" />
${logger.debug('Submitted lead feed. {}',log:kv('submitResult', submitResult))}

<c:choose>
	<c:when test="${isValid || continueOnValidationError}">
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="utilities_submit_application.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>
		<c:set var="xmlData" value="<data>${go:JSONtoXML(submitResult)}</data>" />
		<x:parse var="parsedXml" doc="${xmlData}" />
		${logger.debug('Parsed result to xml. {}',log:kv('xmlData',xmlData ))}
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
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="${fn:toUpperCase(vertical)}" />

<jsp:useBean id="lifeService" class="com.ctm.services.life.LifeService" scope="page" />
<c:set var="serviceResponse" value="${lifeService.contactLead(pageContext.request)}" />

<c:set var="vertical"><c:out value="${param.vertical}" escapeXml="true" /></c:set>
<c:set var="proceedinator"><core:access_check quoteType="${fn:toLowerCase(vertical)}" /></c:set>
<c:choose>
	<c:when test="${lifeService.isValid() and not empty proceedinator and proceedinator > 0}">
		<go:log  level="INFO" >PROCEEDINATOR PASSED</go:log>

		<c:choose>
			<c:when test="${param.softLead eq 'true'}">
				<security:populateDataFromParams rootPath="${vertical}" />
				<core:transaction touch="CDC" noResponse="true" />
				<c:set var="resultXml">
					<results><success>true</success></results>
				</c:set>
				<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
			</c:when>
			<c:otherwise>
				<%-- Load the params into data --%>
				<security:populateDataFromParams rootPath="${vertical}" />
		
				<c:set var="tranId" value="${data.current.transactionId}" />

				<go:setData dataVar="data" xpath="${vertical}/quoteAction" value="start" />

				<%-- Load the config and send quotes to the aggregator gadget --%>
				<c:import var="config" url="/WEB-INF/aggregator/life/config_contact_lead.xml" />
				<go:soapAggregator 	config = "${config}"
									transactionId = "${tranId}"
									xml = "${go:getEscapedXml(data[fn:toLowerCase(vertical)])}"
									var = "resultXml"
									debugVar="debugXml"
									verticalCode="${fn:toUpperCase(vertical)}"
									configDbKey="quoteService"
									styleCodeId="${pageSettings.getBrandId()}"
									/>
		
				<%-- Add the results to the current session data --%>
				<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
				<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		
				<go:log level="DEBUG" source="life_contact_lead">${resultXml}</go:log>
				<go:log level="DEBUG" source="life_contact_lead">${debugXml}</go:log>
		
				<%-- Save client data --%>
				<c:set var="clientRef">${data["soap-response/results/client/reference"]}</c:set>
				<c:if test="${not empty clientRef}">
					<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/api/reference" value="${clientRef}" />
				</c:if>

				<jsp:useBean id="accessTouchService" class="com.ctm.services.AccessTouchService" scope="request" />
				<agg:write_quote productType="${fn:toUpperCase(vertical)}" rootPath="${vertical}" source="REQUEST-CALL" dataObject="${data}" />
				<c:set var="touchResponse">${accessTouchService.recordTouchWithComment(tranId, "LF", "lifebroker")}</c:set>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<results><success>false</success><message>${serviceResponse}</message></results>
		</c:set>
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
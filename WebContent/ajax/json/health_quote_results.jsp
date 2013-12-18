<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="health" /></c:set>
<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

		<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="health" />


<%-- Test and or Increment ID if required --%>
<c:choose>
	<%-- RECOVER: if things have gone pear shaped --%>
	<c:when test="${empty data.current.transactionId}">
		<error:recover origin="ajax/json/health_quote_results.jsp" quoteType="health" />
	</c:when>
	<c:when test="${param.health_incrementTransactionId}">
		<c:set var="id_return">
			<core:get_transaction_id quoteType="health" id_handler="increment_tranId" />
		</c:set>
	</c:when>
	<c:otherwise>
		<%-- All is good --%>
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<go:setData dataVar="data" xpath="health/transactionId" value="${data.current.transactionId}" />
		<go:setData dataVar="data" xpath="health/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="health/clientUserAgent" value="${clientUserAgent}" />
		
		<c:set var="tranId" value="${data.current.transactionId}" />

		<%-- COMPETITION START --%>
		<c:if test="${data['health/contactDetails/competition/optin'] == 'Y'}">
			<go:log>GRUB: Opt-in ticked</go:log>
			<c:choose>
					<c:when test="${not empty data['health/contactDetails/contactNumber/mobile']}">
						<c:set var="contactPhone" value="${data['health/contactDetails/contactNumber/mobile']}"/>
					</c:when>
					<c:otherwise>
						<c:set var="contactPhone" value="${data['health/contactDetails/contactNumber/other']}"/>
					</c:otherwise>
			</c:choose>
			<c:set var="concat" value="${fn:trim(data['health/contactDetails/name'])}::${fn:trim(data['health/contactDetails/email'])}::${fn:trim(contactPhone)}" />
			<go:log>GRUB: concat: ${concat}</go:log>
			<c:if test="${concat != '::' and data['health/contactDetails/competition/previous'] != concat}">
				<go:log>GRUB: Send in the entry!</go:log>

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
				<go:log>GRUB: response: ${response}</go:log>
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

		<%-- If new email entered and different to the previous then opt-out the old email --%>

		<%-- Check list of previous emails and opt-out any that don't match the official email --%>
		<c:if test="${(empty data.health.contactDetails.email && not empty data.health.contactDetails.previousemails) or (not empty data.health.contactDetails.email and not empty data.health.contactDetails.previousemails and data.health.contactDetails.email ne data.health.contactDetails.previousemails)}">
			<c:forTokens items="${data.health.contactDetails.previousemails}" delims="," var="email">
				<c:if test="${data.health.contactDetails.email ne email}">
					<agg:write_email
						brand="CTM"
						vertical="HEALTH"
						source="QUOTE"
						emailAddress="${email}"
						firstName="${data.health.contactDetails.name}"
						lastName=""
						items="okToCall=N,marketing=N" />
				</c:if>
			</c:forTokens>
		</c:if>

		<%-- Save Email Data --%>
		<c:if test="${not empty data.health.contactDetails.email}">
			<agg:write_email
				brand="CTM"
				vertical="HEALTH"
				source="QUOTE"
				emailAddress="${data.health.contactDetails.email}"
				firstName="${data.health.contactDetails.name}"
				lastName=""
				items="okToCall=${data.health.contactDetails.call},marketing=${data.health.contactDetails.optin}" />
				<%-- Optin for marketing is now when universal optin selected before results page --%>
		</c:if>

		<c:import var="config" url="/WEB-INF/aggregator/health/config_ALL.xml" />

		<%-- Load the config and send quotes to the aggregator gadget --%>
		<go:soapAggregator config = "${config}"
							transactionId = "${tranId}" 
							xml = "${go:getEscapedXml(data['health'])}" 
							var = "resultXml"
							debugVar="debugXml" />
							
		<%-- //FIX: turn this back on when you are ready!!!! 
		<%-- Write to the stats database 
		--%>
		<agg:write_stats rootPath="health" tranId="${data.text['current/transactionId']}" debugXml="${debugXml}" />

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

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
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error>
				<message><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></message>
				<transactionId>${data.current.transactionId}</transactionId>
			</error>
		</c:set>
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(resultXml)}
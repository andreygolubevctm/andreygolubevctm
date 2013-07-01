<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Load the params into data --%>
<go:setData dataVar="data" xpath="health" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />
<go:setData dataVar="data" xpath="health/clientIpAddress" value="${pageContext.request.remoteAddr}" />

<%-- Save client data --%>
<agg:write_quote productType="HEALTH" rootPath="health"/>

<%-- Save Email Data --%>
<c:if test="${not empty data.health.application.optInEmail}">
	<c:set var="marketing">
		<c:choose>
			<c:when test="${empty data.health.application.optInEmail}">N</c:when>
			<c:otherwise>${data.health.application.optInEmail}</c:otherwise>
		</c:choose>
	</c:set>
	<agg:write_email
		brand="CTM"
		vertical="HEALTH"
		source="QUOTE"
		emailAddress="${data.health.application.email}"
		firstName="${data.health.application.primary.firstName}"
		lastName="${data.health.application.primary.surname}"
		items="marketing=${marketing},okToCall=${data.health.contactDetails.call}" />
</c:if>

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="<%=request.getRemoteAddr()%>" />

<c:set var="tranId" value="${data.current.transactionId}" />

<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="confirmationResult">
	SELECT *
	FROM ctm.touches t
	WHERE t.transaction_id = ?
	and type = 'C'
	<sql:param value="${tranId}" />
</sql:query>

<c:choose>
	<c:when test="${confirmationResult.rowCount == 0 }">
<%-- Get the fund specific data --%>
<c:set var="productId" value="${fn:substringAfter(param.health_application_productId,'HEALTH-')}" />
<go:log>Product Id = ${productId}</go:log>

<%-- Get the hospital Cover name --%>
<sql:query var="prodRes">
	SELECT Text FROM product_properties WHERE productid=? AND propertyId = 'hospitalCoverName' LIMIT 1
	<sql:param value="${productId}" />
</sql:query>
<c:if test="${prodRes.rowCount != 0 }">
	<go:setData dataVar="data" xpath="health/fundData/hospitalCoverName" value="${prodRes.rows[0].text}" />
</c:if>

<%-- Get the extras Cover name --%>
<sql:query var="prodRes">
	SELECT Text FROM product_properties WHERE productid=? AND propertyId = 'extrasCoverName' LIMIT 1
	<sql:param value="${productId}" />
</sql:query>
<c:if test="${prodRes.rowCount != 0 }">
	<go:setData dataVar="data" xpath="health/fundData/extrasCoverName" value="${prodRes.rows[0].text}" />
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

<go:log>Fund=${fund}</go:log>

<c:import var="config" url="/WEB-INF/aggregator/health_application/${fund}/config.xml" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}" 
					xml = "${go:getEscapedXml(data['health'])}" 
					var = "resultXml"
					debugVar="debugXml" />
					
<%-- //FIX: turn this back on when you are ready!!!! 
<%-- Write to the stats database 
<agg:write_stats tranId="${tranId}" debugXml="${debugXml}" />
--%>


<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="app-response" value="*DELETE" />
<go:setData dataVar="data" xpath="app-response" xml="${resultXml}" />
		<%-- Check for internal or provider errors and record the failed submission
		-- and add comments to the quote for call centre staff
		--%>
		<x:parse doc="${resultXml}" var="resultOBJ" />
		<c:if test="${prodRes.rowCount != 0 }">
			<c:set var="errorMessage" value="" />
			<%-- Collate fund error messages, add fail touch and add quote comment --%>
			<x:if select="$resultOBJ//*[local-name()='errors'] != ''">
				<x:forEach select="$resultOBJ//*[local-name()='errors']/error" var="error" varStatus="pos">
					<c:if test="${not empty errorMessage}">
						<c:set var="errorMessage" value="${errorMessage}<br/>" />
					</c:if>
					<c:set var="errorMessage">${errorMessage}${pos.count}] <x:out select="$error/text" /></c:set>
				</x:forEach>
			</x:if>

			<c:if test="${not empty errorMessage}">
				<c:set var="errorMessage" value="Application Submission Failed:<br />${errorMessage}" />
				<c:import var="ignoreme" url="/ajax/json/access_touch.jsp?quoteType=health&touchtype=F&comment=${errorMessage}" />
			</c:if>
		</c:if>

<go:log>${resultXml}</go:log>
<go:log>${debugXml}</go:log>

		<%-- set transaction to confirmed if application was successful --%>
		<x:if select="$resultOBJ//*[local-name()='success'] = 'true'">
			<c:import var="ignoreme" url="/ajax/json/access_touch.jsp?quoteType=health&touchtype=C" />
		</x:if>

		${go:XMLtoJSON(resultXml)}
	</c:when>
	<c:otherwise>
		<c:set var="errorMessage" value="Application has already been submitted" />
		<c:import var="ignoreme" url="/ajax/json/access_touch.jsp?quoteType=health&touchtype=F&comment=${errorMessage}" />
		{ "result": { "error": { "type": "confirmed", "message": "${errorMessage}" } }}
	</c:otherwise>
</c:choose>
<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="health" /></c:set>
<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>
		<%-- Load the params into data --%>
		<go:setData dataVar="data" xpath="health" value="*DELETE" />
		<go:setData dataVar="data" value="*PARAMS" />

		<go:setData dataVar="data" xpath="health/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="health/clientUserAgent" value="${clientUserAgent}" />
		
		<c:if test="${not empty param.increment_tranId}">
			<c:import var="getTransactionID" url="../json/get_transactionid.jsp?id_handler=increment_tranId" />
		</c:if>

		<%-- Save client data --%>
		<agg:write_quote productType="HEALTH" rootPath="health"/>

		<%-- Save Email Data --%>
		<c:if test="${not empty data.health.contactDetails.email}">
			<agg:write_email
				brand="CTM"
				vertical="HEALTH"
				source="QUOTE"
				emailAddress="${data.health.contactDetails.email}"
				firstName="${data.health.contactDetails.firstName}"
				lastName="${data.health.contactDetails.lastname}"
				items="okToCall=${data.health.contactDetails.call}" />
				<%-- NB. marketing optin occurs at the application phase --%>
		</c:if>

		<%-- add external testing ip address checking and loading correct config and send quotes --%>
		<c:set var="clientIp" value="<%=request.getRemoteAddr()%>" />

		<c:set var="tranId" value="${data.current.transactionId}" />

		<c:set var="gmf" value="203.153.239.89" />
		<c:set var="hcf" value="202.68.174.227" />
		<c:set var="nib" value="127.0.0.1" />
		<c:set var="gmh" value="127.0.0.1" />
		<c:set var="auf" value="127.0.0.1" />
		<c:set var="wfd" value="127.0.0.1" />


		<c:set var="teresa" value="192.168.11.36" />
		<c:set var="alex" value="192.168.12.132" />
		<c:set var="alexx" value="127.0.0.1" />
		<c:set var="teresax" value="127.0.0.1" />

		<c:set var="configName">
			<c:choose>
				<c:when test="${clientIp == gmf or clientIp==alex}">GMF</c:when>
				<c:when test="${clientIp == hcf or clientIp==alex}">HCF</c:when>
				<c:when test="${clientIp == nib or clientIp==alex}">NIB</c:when>	
				<c:when test="${clientIp == gmh or clientIp==alex}">GMH</c:when>	
				<c:when test="${clientIp == auf or clientIp==alex}">AUF</c:when>	
				<c:when test="${clientIp == wfd or clientIp==alex}">WFD</c:when>	
				<c:when test="${fn:startsWith(clientIp,'192.168.')}">ALL</c:when>
				<c:otherwise>ALL</c:otherwise>
			</c:choose>
		</c:set>
		<go:log>IP=${clientIp} Config=${configName}</go:log>
		<c:import var="config" url="/WEB-INF/aggregator/health/config_${configName}.xml" />


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
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

		<%-- Add the results only if there is one version --%>
		<go:setData dataVar="data" xpath="healthConfirmation" value="*DELETE"/>
		<go:setData dataVar="data" xpath="confirmation/health" value="*DELETE"/>
		
		<c:if test="${data.health.showAll == 'N'}">
				
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
		
		<c:choose>
			<c:when test="${not empty param.ignoretouch}"><%-- NO TOUCH REQUIRED --%></c:when>
			<c:otherwise>
		<c:set var="ignore_me"><core:access_touch quoteType="health" type="R" transaction_id="${data.current.transactionId}" /></c:set>
			</c:otherwise>
		</c:choose>
		
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></error>
		</c:set>
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(resultXml)}
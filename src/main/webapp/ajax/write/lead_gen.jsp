<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date"/>

<sql:setDataSource dataSource="${datasource:getDataSource()}" />

<core_new:no_cache_header />

<c:set var="token"><c:out value="${param.token}" escapeXml="true" /></c:set>

<c:set var="partner"><c:out value="${fn:toUpperCase(param.partner)}" escapeXml="true" /></c:set>
<c:set var="productType"><c:out value="${fn:toUpperCase(param.productType)}" escapeXml="true" /></c:set>
<c:set var="firstName"><c:out value="${param.firstName}" escapeXml="true" /></c:set>
<c:set var="lastName"><c:out value="${param.lastName}" escapeXml="true" /></c:set>
<c:set var="age"><c:out value="${param.age}" escapeXml="true" /></c:set>
<c:set var="state"><c:out value="${param.state}" escapeXml="true" /></c:set>
<c:set var="contactTime"><c:out value="${param.contactTime}" escapeXml="true" /></c:set>

<c:set var="email"><c:out value="${param.email}" escapeXml="true" /></c:set>
<c:set var="emailOptIn" value="N" />
<c:if test="${not empty param.emailOptIn and param.emailOptIn eq 'true'}">
	<c:set var="emailOptIn" value="Y" />
</c:if>

<c:set var="telephone"><c:out value="${param.telephone}" escapeXml="true" /></c:set>
<c:set var="telephoneOptIn" value="N" />
<c:if test="${not empty param.telephoneOptIn and param.telephoneOptIn eq 'true'}">
	<c:set var="telephoneOptIn" value="Y" />
</c:if>

<c:set var="output" value="" />

<c:set var="continueScript" value="${true}" />

<%-- Check if we are receiving the data via POST --%>
<c:if test="${pageContext.request.method != 'POST'}">
	<c:set var="continueScript" value="${false}" />
	<c:set var="errorMsg" value="Requests should be made via POST" />
</c:if>

<%-- Check we've received TOKEN, PARTNER, PRODUCTTYPE (+ other required fields) before continuing --%>
<c:if test="${continueScript && (empty token || empty productType || empty partner || empty age || empty telephone || telephoneOptIn eq 'N')}">
	<c:set var="continueScript" value="${false}" />
	<c:set var="errorMsg" value="A required input is missing" />
</c:if>

<%-- No younglings or immortals --%>
<c:if test="${continueScript && (age < 18 || age > 120)}">
	<c:set var="continueScript" value="${false}" />
	<c:set var="errorMsg" value="Applicants must be between 18 and 120" />
</c:if>

<%-- Create a new session --%>
<c:if test="${continueScript}">
	<c:catch var="sessionError">
		<session:new verticalCode="${productType}" />
	</c:catch>
	
	<c:if test="${not empty sessionError}">
		<c:set var="continueScript" value="${false}" />
		<c:set var="errorMsg" value="There was an error creating the session" />
	</c:if>
</c:if>

<%-- If the script isn't meant to continue past this point, we won't have a session initialised --%>
<c:if test="${continueScript eq false}">
	<c:set var="noSession" value="${true}" />
</c:if>

<%-- Check the supplied PARTNER and PRODUCTTYPE are assigned to the given TOKEN --%>
<c:if test="${continueScript}">
	<sql:query var="tokenData">
		SELECT `startDate`, `endDate`, `campaignId`
		FROM `ctm`.`tokens`
		JOIN `vertical_master` ON `vertical_master`.`verticalId` = `tokens`.`verticalId`
		WHERE `token` = ?
		AND `partner` = ?
		AND `verticalCode` = ?
		<sql:param value="${token}" />
		<sql:param value="${partner}" />
		<sql:param value="${productType}" />
	</sql:query>
	
	<c:choose>
		<c:when test="${not empty tokenData and tokenData.rowCount > 0}">		
			<c:set var="campaignId" value="${tokenData.rows[0]['campaignId']}" />
			<c:set var="startDate">${tokenData.rows[0]['startDate']}</c:set>
			<c:set var="endDate" value="${tokenData.rows[0]['endDate']}" />
			<fmt:formatDate pattern="yyyy-MM-dd" var="currentDate" value="${now}" />
		</c:when>
		<c:otherwise>
			<c:set var="continueScript" value="${false}" />
			<c:set var="errorMsg" value="The specified token could not be found" />
		</c:otherwise>
	</c:choose>
</c:if>

<%-- Check the token is active within the given date range --%>
<c:if test="${continueScript}">
	<c:if test="${startDate > currentDate || endDate < currentDate}">
		<c:set var="errorMsg" value="The specified token is no longer active" />
		<c:set var="continueScript" value="${false}" />
	</c:if>
</c:if>

<%-- Get the data and store it as a transaction --%>
<c:if test="${continueScript}">
	<c:catch var="error">
		<c:set var="xpath">${pageSettings.getVerticalCode()}</c:set>
		
		<c:if test="${not empty telephone}">
			<%-- Remove non-numeric characters --%>
			<c:set var="telephone">${go:replaceAll(telephone, "([^\\d.])", '')}</c:set>
			<%-- Replace country code and extra leading 0s --%>
			<c:set var="telephone">${go:replaceAll(telephone, "^(0{1,})?61(0{1,})?", '0')}</c:set>
			
			<%-- Check phone number length --%>
			<c:if test="${fn:length(telephone) != 10}">
				<c:set var="output">{ success: false, message: "The supplied phone number is not formatted correctly. Phone numbers should be 10 digits if a country code is not included. Valid phone number formats: +61 7 3000 0000, 07 3000 0000, 0400 000 000" }</c:set>
			</c:if>
			
			<c:set var="telephoneType" value="landline" />
			<c:if test="${fn:startsWith(telephone, '04')}">
				<c:set var="telephoneType" value="mobile" />
			</c:if>
		</c:if>
		
		<c:choose>
			<c:when test="${productType eq 'HEALTH'}">
				<c:set var="xpath">${pageSettings.getVerticalCode()}</c:set>
			
				<c:if test="${not empty firstName}">
					<go:setData dataVar="data" xpath="${xpath}/contactDetails/name" value="${firstName}" />
					<go:setData dataVar="data" xpath="${xpath}/application/primary/firstname" value="${firstName}" />
				</c:if>
				
				<c:if test="${not empty lastName}">
					<go:setData dataVar="data" xpath="${xpath}/application/primary/surname" value="${lastName}" />
				</c:if>
				
				<c:if test="${not empty email}">
					<go:setData dataVar="data" xpath="${xpath}/contactDetails/email" value="${email}" />
					<go:setData dataVar="data" xpath="${xpath}/application/email" value="${email}" />
				</c:if>
				
				<c:if test="${not empty age}">
					<go:setData dataVar="data" xpath="${xpath}/marketing/age" value="${age}" />
				</c:if>
				
				<c:if test="${not empty telephone}">
					<c:choose>
						<c:when test="${telephoneType eq 'mobile'}">
							<go:setData dataVar="data" xpath="${xpath}/application/mobileinput" value="${telephone}" />
							<go:setData dataVar="data" xpath="${xpath}/application/mobile" value="${telephone}" />
							<go:setData dataVar="data" xpath="${xpath}/contactDetails/contactNumber/mobileinput" value="${telephone}" />
							<go:setData dataVar="data" xpath="${xpath}/contactDetails/contactNumber/mobile" value="${telephone}" />
						</c:when>
						<c:otherwise>
							<go:setData dataVar="data" xpath="${xpath}/application/otherinput" value="${telephone}" />
							<go:setData dataVar="data" xpath="${xpath}/application/other" value="${telephone}" />
							<go:setData dataVar="data" xpath="${xpath}/contactDetails/contactNumber/otherinput" value="${telephone}" />
							<go:setData dataVar="data" xpath="${xpath}/contactDetails/contactNumber/other" value="${telephone}" />
						</c:otherwise>
					</c:choose>
				</c:if>
				
				<go:setData dataVar="data" xpath="${xpath}/contactDetails/optin" value="${emailOptIn eq 'Y' or telephoneOptIn eq 'Y' ? 'Y' : 'N'}" />
				
				<go:setData dataVar="data" xpath="${xpath}/contactDetails/optInEmail" value="${emailOptIn}" />
				
				<go:setData dataVar="data" xpath="${xpath}/privacyOptin" value="Y" />
				
				<go:setData dataVar="data" xpath="${xpath}/contactDetails/call" value="${telephoneOptIn}" />
				
				<c:if test="${telephoneOptIn eq 'Y'}">
					<go:setData dataVar="data" xpath="${xpath}/callmeback/optin" value="${telephoneOptIn}" />
					<go:setData dataVar="data" xpath="${xpath}/callmeback/name" value="${firstName} ${lastName}" />
					<go:setData dataVar="data" xpath="${xpath}/callmeback/phoneinput" value="${telephone}" />
				</c:if>
				
				<go:setData dataVar="data" xpath="${xpath}/marketing/partner" value="${partner}" />

				<c:if test="${not empty campaignId}">
					<go:setData dataVar="data" xpath="${xpath}/marketing/campaignId" value="${campaignId}" />
				</c:if>
				
				<c:if test="${not empty state}">
					<go:setData dataVar="data" xpath="${xpath}/situation/state" value="${state}" />
					<go:setData dataVar="data" xpath="${xpath}/application/address/state" value="${state}" />
				</c:if>
				
				<%--
				<c:if test="${not empty contactTime}">
					 HEALTH doesn't use this... It's just a placeholder for when we copy the code to add more verticals to this.
				</c:if>
				--%>
			</c:when>
		</c:choose>
		
		<c:if test="${not empty contactTime}">
			<go:setData dataVar="data" xpath="${xpath}/callmeback/timeOfDay" value="${contactTime}" />
		</c:if>
		
		<core:transaction touch="N" />
		
		<c:if test="${telephoneOptIn eq 'Y' and not empty contactTime}">
			<c:import url="/ajax/write/request_callback.jsp">
				<c:param value="${data.current.transactionId}" name="transactionId" />
				<c:param value="${fn:toLowerCase(productType)}" name="quoteType"/>
				<c:param value="leadGen" name="source" />
			</c:import>
		</c:if>
		
		<agg:write_quote rootPath="${fn:toLowerCase(productType)}" productType="${productType}" />
		
		<c:if test="${empty output}">
			<c:set var="output">{ success: true }</c:set>
		</c:if>
	</c:catch>
	
	<c:if test="${not empty error}">
		<c:set var="errorMsg" value="There was an error writing the transaction to the database" />
		<c:set var="continueScript" value="${false}" />
	</c:if>
</c:if>

<c:if test="${continueScript eq false}">
	<%-- Set to GENERIC vertical if we aren't supplied a product type --%>
	<c:if test="${not empty noSession}">
		<settings:setVertical verticalCode="GENERIC" />
	</c:if>	

	<error:fatal_error description="${errorMsg}" message="${errorMsg}" page="ajax/write/lead_gen.jsp" failedData="${data}" fatal="1" transactionId="${data.current.transactionId}"></error:fatal_error>
	<c:set var="output">{ success: false, message: "${errorMsg}" }</c:set>
</c:if>

${output}
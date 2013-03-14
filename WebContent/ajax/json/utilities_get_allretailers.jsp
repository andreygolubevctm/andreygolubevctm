<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<go:setData dataVar="data" xpath="temp_providers" value="*DELETE" />

<c:set var="postcode" value="${param.postcode}" />
<c:set var="state" value="${param.state}" />
<c:set var="packagetype" value="${param.packagetype}" />
<c:set var="selected" value="${param.selected}" />

<c:set var="response">
<results>
	<result>OK</result>
	<c:if test="${packagetype eq 'EG' or packagetype eq 'E'}">
	<electricity>
		<providers id="0">
			<provider>
				<ProviderId></ProviderId>
				<RetailerId></RetailerId>
				<RetailerCode></RetailerCode>
				<Name>Please Choose...</Name>
			</provider>
		</providers>
	</electricity>
	</c:if>
	<c:if test="${packagetype eq 'EG' or packagetype eq 'G'}">
	<gas>
		<providers id="0">
			<provider>
				<ProviderId></ProviderId>
				<RetailerId></RetailerId>
				<RetailerCode></RetailerCode>
				<Name>Please Choose...</Name>
			</provider>
		</providers>
	</gas>
	</c:if>
</results>
</c:set>

<go:setData dataVar="data" xpath="temp_providers" xml="${response}" />
	
<c:set var="getFromLocal" value="${true}" />

<c:catch var="error">
	<c:set var="retailers">
		<go:scrape url="${data['settings/switchwise-web-service']}/AllRetailers/" sourceEncoding="UTF-8" username="webtest" password="web#1test" />
	</c:set>
	
	<c:if test="${not empty retailers}">
		<c:set var="retailers" value="${fn:replace(retailers, ' xmlns=\"http://switchwise.com.au/\"','')}" />
		<c:set var="retailers" value="${fn:replace(retailers, ' xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"','')}" />
		<c:set var="retailers" value="<results>${fn:replace(retailers, ' i:nil=\"true\"','')}</results>" />
		<x:parse doc="${retailers}" var="retailersOBJ" />		
		<x:set var="retailerNode" select="$retailersOBJ//*[local-name()='ArrayOfRetailer']/*" />
		<c:set var="electricityCount" value="${1}" />
		<c:set var="gasCount" value="${1}" />
		<x:forEach select="$retailerNode" var="retailer">
			<c:set var="Name"><x:out select="$retailer/Name" /></c:set>
			<c:set var="Code"><x:out select="$retailer/Code" /></c:set>
			<c:set var="RetailerID"><x:out select="$retailer/RetailerID" /></c:set>
			<c:set var="plansXML">
				<utilities:utilities_get_providerplans postcode="${postcode}" providerid="${RetailerID}"></utilities:utilities_get_providerplans>
			</c:set>
			
			<c:if test="${not empty plansXML}">	
			
				<c:set var="getFromLocal" value="${false}" />
				
				<c:set var="tmp">
					<provider>
						<ProviderId>${RetailerID}</ProviderId>
						<RetailerId>${RetailerID}</RetailerId>
						<RetailerCode>${Code}</RetailerCode>
						<Name>${fn:escapeXml(Name)}</Name>
					</provider>
				</c:set>
					
				<x:parse doc="${plansXML}" var="plansOBJ" />		
				<x:if select="$plansOBJ//*[local-name()='Electricity']/plan != ''">
					<go:setData dataVar="data" xpath="temp_providers/results/electricity/providers[@id=${electricityCount}]" xml="${tmp}" />
					<c:set var="electricityCount" value="${electricityCount + 1}" />
				</x:if>	
				<x:if select="$plansOBJ//*[local-name()='Gas']/plan != ''">
					<go:setData dataVar="data" xpath="temp_providers/results/gas/providers[@id=${gasCount}]" xml="${tmp}" />
					<c:set var="gasCount" value="${gasCount + 1}" />
				</x:if>
			</c:if>
		</x:forEach>
	</c:if>
</c:catch>

<c:if test="${not empty error}">
	<c:set var="getFromLocal" value="${true}" />
</c:if>

<c:if test="${getFromLocal eq true}">

	<go:setData dataVar="data" xpath="temp_providers" value="*DELETE" />
	<go:setData dataVar="data" xpath="temp_providers" xml="${response}" />
	
	<go:log>BEFORE: ${data['temp_providers/results']}</go:log>

	<sql:setDataSource dataSource="jdbc/ctm"/>
	
	<c:if test="${packagetype eq 'EG' or packagetype eq 'E'}">
		<sql:query var="getERetailers">
			SELECT DISTINCT ProviderId, Name, RetailerId, RetailerCode, State, EffectiveStart, EffectiveEnd 
			FROM ctm.utilities_active_providers
			WHERE State = ? AND ClassType = ?
			ORDER BY Name ASC;
			<sql:param value="${state}" />
			<sql:param value="Electricity" />
		</sql:query>
	</c:if>
	
	<c:if test="${packagetype eq 'EG' or packagetype eq 'G' }">
		<sql:query var="getGRetailers">
			SELECT DISTINCT ProviderId, Name, RetailerId, RetailerCode, State, EffectiveStart, EffectiveEnd 
			FROM ctm.utilities_active_providers
			WHERE State = ? AND ClassType = ?
			ORDER BY Name ASC;
			<sql:param value="${state}" />
			<sql:param value="Gas" />
		</sql:query>
	</c:if>
	
	<c:if test="${packagetype eq 'EG' or packagetype eq 'E'}">
		<c:set var="electricityCount" value="${1}" />
		<c:forEach var="retailer" items="${getERetailers.rows}" varStatus="row">
			<c:set var="eTmp">
				<provider>
					<ProviderId>${retailer.ProviderId}</ProviderId>
					<RetailerId>${retailer.RetailerId}</RetailerId>
					<RetailerCode>${retailer.RetailerCode}</RetailerCode>
					<Name>${fn:escapeXml(retailer.Name)}</Name>
				</provider>
			</c:set>
			<go:setData dataVar="data" xpath="temp_providers/results/electricity/providers[@id=${electricityCount}]" xml="${eTmp}" />
			<c:set var="electricityCount" value="${electricityCount + 1}" />
		</c:forEach>
	</c:if>
	
	<c:if test="${packagetype eq 'EG' or packagetype eq 'G'}">
		<c:set var="gasCount" value="${1}" />
		<c:forEach var="retailer" items="${getGRetailers.rows}" varStatus="row">
			<c:set var="gTmp">
				<provider>
					<ProviderId>${retailer.ProviderId}</ProviderId>
					<RetailerId>${retailer.RetailerId}</RetailerId>
					<RetailerCode>${retailer.RetailerCode}</RetailerCode>
					<Name>${fn:escapeXml(retailer.Name)}</Name>
				</provider>
			</c:set>
			<go:setData dataVar="data" xpath="temp_providers/results/gas/providers[@id=${gasCount}]" xml="${gTmp}" />
			<c:set var="gasCount" value="${gasCount + 1}" />
		</c:forEach>
	</c:if>
</c:if>

<go:log>Providers: ${go:getEscapedXml(data['temp_providers/results'])}</go:log>
${go:XMLtoJSON(go:getEscapedXml(data['temp_providers/results']))}

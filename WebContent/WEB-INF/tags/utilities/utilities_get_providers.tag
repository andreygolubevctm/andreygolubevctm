<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Displays a list of Switchwise providers."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:catch var="error">
	<sql:query var="providers">
		SELECT pm.ProviderId AS ourProviderId, pm.Name AS providerName, pp1.Text AS providerId, pp2.Text AS providerCode
		FROM ctm.provider_master AS pm 
		INNER JOIN ctm.provider_properties AS pp1 ON pp1.ProviderId = pm.ProviderId AND pp1.PropertyId = 'SwitchwiseId'
		INNER JOIN ctm.provider_properties AS pp2 ON pp2.ProviderId = pm.ProviderId AND pp2.PropertyId = 'SwitchwiseCode'
		WHERE pm.ProviderId IS NOT NULL
		ORDER BY pm.Name ASC;
	</sql:query>
</c:catch>							 

<c:choose>
	<c:when test="${not empty error}">
		<go:log>GET PROVIDERS: ${error}</go:log>
	</c:when>
	<c:when test="${not empty providers and providers.rowCount > 0}">
<?xml version="1.0" encoding="UTF-8"?>
<providers>
<c:forEach var="provider" items="${providers.rows}">
	<row>
		<ourProviderId>${provider.ourProviderId}</ourProviderId>
		<providerName>${fn:escapeXml(provider.providerName)}</providerName>
		<providerId>${provider.providerId}</providerId>
		<providerCode>${provider.providerCode}</providerCode>
	</row>
</c:forEach>
</providers>
	</c:when>
	<c:otherwise>
		<go:log>GET PROVIDERS: no providers found...</go:log>
	</c:otherwise>
</c:choose>
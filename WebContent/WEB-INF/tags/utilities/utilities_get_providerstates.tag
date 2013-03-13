<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Displays a list of states for a given provider (code)."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="providerCode" required="true" description="The unique switchwise code for the provider."%>

<c:set var="useCache" value="${true}" />

<c:choose>
	<c:when test="${useCache eq true}">
		<c:set var="statesXML">
			<ArrayOfstring xmlns="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
				<string>QLD</string>
				<string>NSW</string>
				<string>ACT</string>
				<string>VIC</string>
				<string>TAS</string>
				<string>SA</string>
				<string>WA</string>
				<string>NT</string>
			</ArrayOfstring>
		</c:set>
	</c:when>
	<c:otherwise>
		<go:import var="statesXML" url="http://websvcpreprod.switchwise.com.au/switchwise1_4_8/SwitchwiseSearchService.svc/RetailerState/${providerCode}" />
	</c:otherwise>
</c:choose>
${statesXML}
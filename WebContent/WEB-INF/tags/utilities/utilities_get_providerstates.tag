<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Displays a list of states for a given provider (code)."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="providerCode" required="true" description="The unique switchwise code for the provider."%>

<c:set var="useCache" value="${false}" />

<c:import var="config" url="/WEB-INF/aggregator/utilities/config_settings.xml" />
<x:parse doc="${config}" var="configOBJ" />		
<c:set var="sw_url"><x:out select="$configOBJ//*[local-name()='url']" /></c:set>
<c:set var="sw_user"><x:out select="$configOBJ//*[local-name()='user']" /></c:set>
<c:set var="sw_pwd"><x:out select="$configOBJ//*[local-name()='pwd']" /></c:set>

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
		<c:set var="statesXML">
			<go:scrape url="${sw_url}/RetailerState/${providerCode}" sourceEncoding="UTF-8" username="${sw_user}" password="${sw_pwd}" />
		</c:set>
	</c:otherwise>
</c:choose>
${statesXML}
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Displays a list of Switchwise providers."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:catch var="error">

	<c:import var="config" url="/WEB-INF/aggregator/utilities/config_settings.xml" />
	<x:parse doc="${config}" var="configOBJ" />

	<c:set var="sw_url"><x:out select="$configOBJ//*[local-name()='url']" /></c:set>
	<c:set var="sw_user"><x:out select="$configOBJ//*[local-name()='user']" /></c:set>
	<c:set var="sw_pwd"><x:out select="$configOBJ//*[local-name()='pwd']" /></c:set>

	<c:set var="retailers">
		<go:scrape url="${sw_url}/AllRetailers/" sourceEncoding="UTF-8" username="${sw_user}" password="${sw_pwd}" />
	</c:set>

	<c:if test="${not empty retailers}">
		<c:set var="retailers" value="${fn:replace(retailers, ' xmlns=\"http://switchwise.com.au/\"','')}" />
		<c:set var="retailers" value="${fn:replace(retailers, ' xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"','')}" />
		<c:set var="retailers" value="<results>${fn:replace(retailers, ' i:nil=\"true\"','')}</results>" />

		<x:parse doc="${retailers}" var="retailersOBJ" />
		<x:set var="retailerNode" select="$retailersOBJ//*[local-name()='arrayofretailer']/*" />

		<c:set var="providerCount" value="${0}" />
		<x:forEach select="$retailerNode" var="retailer">

			<c:set var="Name"><x:out select="$retailer/name" /></c:set>
			<c:set var="Code"><x:out select="$retailer/code" /></c:set>
			<c:set var="RetailerID"><x:out select="$retailer/retailerid" /></c:set>

			<c:set var="tmp">
				<provider>
					<id>${RetailerID}</id>
					<code>${Code}</code>
					<name>${fn:escapeXml(Name)}</name>
				</provider>
			</c:set>

			<go:setData dataVar="data" xpath="tempproviders/providers[@id=${providerCount}]" xml="${tmp}" />
			<c:set var="providerCount" value="${providerCount + 1}" />

		</x:forEach>
	</c:if>
</c:catch>

<c:choose>
	<c:when test="${not empty error}">
		<go:log>GET PROVIDERS: ${error.rootCause}</go:log>
	</c:when>
	<c:when test="${not empty data.tempproviders}">
${data.tempproviders}
	</c:when>
	<c:otherwise>
		<go:log>GET PROVIDERS: no providers found...</go:log>
	</c:otherwise>
</c:choose>
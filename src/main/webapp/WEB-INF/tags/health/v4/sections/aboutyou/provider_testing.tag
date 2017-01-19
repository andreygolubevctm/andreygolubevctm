<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Provides a method for external providers to test their prices only, without affecting production or future users"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" scope="application" />

<c:set var="logger" value="${log:getLogger('tag.health.provider_testing')}" />

<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- NOTE: a List of Provider Keys can be found in aggregator/health/phio_outbound --%>

<%-- Make sure we're in a proper environment to test this --%>
<c:set var="remoteaddr" value="${ipAddressHandler.getIPAddress(pageContext.request)}" />
${logger.debug('Checking environment. {},{}', log:kv('ENVIRONMENT', environmentService.getEnvironmentAsString()), log:kv('remoteaddr', remoteaddr))}
<c:if test="${environmentService.getEnvironmentAsString() == 'localhost' || environmentService.getEnvironmentAsString() == 'NXI' || environmentService.getEnvironmentAsString() == 'NXS' || environmentService.getEnvironmentAsString() == 'NXQ'}">

	<c:choose>
		<c:when test="${empty param.providerKey}">
			<c:if test="${fn:startsWith(remoteaddr,'192.168.') or fn:startsWith(remoteaddr,'0:0:0:') or fn:startsWith(remoteaddr,'127.0.0.1')}">

				<form_v3:fieldset_columns>
					<jsp:attribute name="rightColumn">
					</jsp:attribute>
					<jsp:body>
						<form_v2:fieldset legend="Provider Testing">

							<c:set var="fieldXpath" value="${xpath}/situation/singleProvider" />
							<form_v4:row label="Provider" fieldXpath="${fieldXpath}">
								<field_v1:provider_select productCategories="HEALTH" xpath="${fieldXpath}" />
							</form_v4:row>
							<form_v4:row label="ProductName" fieldXpath="${xpath}/productTitleSearch">
								<field_v2:input required="false" className="form-control" title="Product Name" xpath="${xpath}/productTitleSearch" />
							</form_v4:row>

						</form_v2:fieldset>
					</jsp:body>
				</form_v3:fieldset_columns>

			</c:if>
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${not empty param.providerKey}">
					<c:set var="providerKey"><c:out value="${param.providerKey}" escapeXml="true" /></c:set>
				</c:when>
				<c:otherwise>
					<c:set var="providerKey" value="-1" />
				</c:otherwise>
			</c:choose>

			<field_v1:hidden xpath="${xpath}/situation/providerKey" constantValue="${providerKey}"/>
		</c:otherwise>
	</c:choose>

	<%-- This is separate and always available to internal and external --%>
	<form_v3:fieldset_columns>
		<jsp:attribute name="rightColumn">
		</jsp:attribute>
		<jsp:body>
			<form_v2:fieldset legend="">
				<c:set var="fieldXpath" value="${xpath}/searchDate" />
				<form_v4:row label="Application/Cover Date" fieldXpath="${fieldXpath}">
					<field_v2:calendar validateMinMax="false" xpath="${fieldXpath}" required="false" title="searchDate" startView="0" nonLegacy="true"/>
					For testing future product searches
				</form_v4:row>
				<c:set var="fieldXpath" value="${xpath}/searchResults" />
				<form_v4:row label="Number of results" subLabel="Test sublabel styles" fieldXpath="${fieldXpath}" helpId="22">
					<field_v2:count_select max="36" xpath="${fieldXpath}" min="12" title="Number of Results" required="false" step="12"/>
				</form_v4:row>
			</form_v2:fieldset>
		</jsp:body>
	</form_v3:fieldset_columns>

</c:if>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Provides a method for external providers to test their prices only, without affecting production or future users"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('/health/provider_testing.tag')}" />

<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- NOTE: a List of Provider Keys can be found in aggregator/health/phio_outbound --%>

<%-- Make sure we're in a proper environment to test this --%>
${logger.debug('Checking environment. {},{}', log:kv('ENVIRONMENT', environmentService.getEnvironmentAsString()), log:kv('remoteaddr', pageContext.request.remoteAddr))}
<c:if test="${environmentService.getEnvironmentAsString() == 'localhost' || environmentService.getEnvironmentAsString() == 'NXI'  || environmentService.getEnvironmentAsString() == 'NXS'}">

	<c:choose>
		<c:when test="${empty param.providerKey}">
			<c:if test="${fn:startsWith(pageContext.request.remoteAddr,'192.168.') or fn:startsWith(pageContext.request.remoteAddr,'0:0:0:') or fn:startsWith(pageContext.request.remoteAddr,'127.0.0.1')}">

				<form_new:fieldset_columns>
					<jsp:attribute name="rightColumn">
					</jsp:attribute>
					<jsp:body>
						<form_new:fieldset legend="Provider Testing">

							<c:set var="fieldXpath" value="${xpath}/situation/singleProvider" />
							<form_new:row label="Provider" fieldXpath="${fieldXpath}">
								<field:provider_select productCategories="HEALTH" xpath="${fieldXpath}" />
							</form_new:row>
							<form_new:row label="ProductName" fieldXpath="${xpath}/productTitleSearch">
								<field_new:input required="false" className="form-control" title="Product Name" xpath="${xpath}/productTitleSearch" />
							</form_new:row>
							<c:set var="fieldXpath" value="${xpath}/searchResults" />
							<form_new:row label="Number of results" fieldXpath="${fieldXpath}">
								<field_new:count_select max="36" xpath="${fieldXpath}" min="12" title="Number of Results" required="false" step="12"/>
							</form_new:row>

						</form_new:fieldset>
					</jsp:body>
				</form_new:fieldset_columns>

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

			<field:hidden xpath="${xpath}/situation/providerKey" constantValue="${providerKey}"/>
		</c:otherwise>
	</c:choose>

	<%-- This is separate and always available to internal and external --%>
	<form_new:fieldset_columns>
		<jsp:attribute name="rightColumn">
		</jsp:attribute>
		<jsp:body>
			<form_new:fieldset legend="">
				<c:set var="fieldXpath" value="${xpath}/searchDate" />
				<form_new:row label="Application/Cover Date" fieldXpath="${fieldXpath}">
					<field_new:calendar validateMinMax="false" xpath="${fieldXpath}" required="false" title="searchDate" startView="0" nonLegacy="true"/>
					For testing future product searches
				</form_new:row>
			</form_new:fieldset>
		</jsp:body>
	</form_new:fieldset_columns>

</c:if>
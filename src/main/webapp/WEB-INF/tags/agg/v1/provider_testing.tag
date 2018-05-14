<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Provides a method for external providers to test their prices only, without affecting production or future users"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" scope="application" />

<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="displayFullWidth" required="false"	 rtexprvalue="true"	 description="Determine's whether or not to display the provider testing fields as full width" %>
<%@ attribute name="keyLabel" required="false" rtexprvalue="false" description="Label to override the default being 'providerKey'" %>
<%@ attribute name="filterProperty" required="false" rtexprvalue="false" description="Label to override the default filter property being 'singleProvider'" %>
<%@ attribute name="hideSelector" required="false" rtexprvalue="true" description="True/False Flag to hide the provider selector" %>

<%-- VARIABLES --%>
<c:if test="${empty keyLabel}">
	<c:set var="keyLabel" value="providerKey" />
</c:if>
<c:if test="${empty filterProperty}">
	<c:set var="filterProperty" value="singleProvider" />
</c:if>
<c:if test="${empty hideSelector}">
	<c:set var="hideSelector" value="${false}" />
</c:if>
<%-- Make sure we're in a proper environment to test this --%>
<c:choose>
	<c:when test="${empty param[keyLabel] && (environmentService.getEnvironmentAsString() == 'localhost' || environmentService.getEnvironmentAsString() == 'NXI')}">
		<c:if test="${fn:startsWith(ipAddressHandler.getIPAddress(pageContext.request),'192.168.') or fn:startsWith(ipAddressHandler.getIPAddress(pageContext.request),'10.4') or fn:startsWith(ipAddressHandler.getIPAddress(pageContext.request),'0:0:0:') or ipAddressHandler.getIPAddress(pageContext.request) == '127.0.0.1'}">
			<c:if test="${hideSelector eq false}">
				<form_v2:fieldset_columns displayFullWidth="${false}">
					<jsp:attribute name="rightColumn">
					</jsp:attribute>
					<jsp:body>
						<form_v2:fieldset legend="Provider Testing">
							<c:set var="fieldXpath" value="${xpath}/filter/${filterProperty}" />
							<form_v2:row label="Provider" fieldXpath="${fieldXpath}">
								<field_v1:provider_select productCategories="${pageSettings.getVerticalCode()}" xpath="${fieldXpath}" />
							</form_v2:row>
						</form_v2:fieldset>
					</jsp:body>
				</form_v2:fieldset_columns>
			</c:if>
		</c:if>
	</c:when>
	<c:when test="${(not empty param[keyLabel] && (environmentService.getEnvironmentAsString() == 'localhost' || environmentService.getEnvironmentAsString() == 'NXI')) || environmentService.getEnvironmentAsString() == 'NXS'}">
		<c:set var="providerKey"><c:out value="${param[keyLabel]}" escapeXml="true" /></c:set>
		<jsp:useBean id="providerService" class="com.ctm.web.core.services.ProviderService" />
		<c:choose>
			<c:when test="${not empty providerKey && ((keyLabel ne 'authToken' && providerService.providerKeyExists(providerKey)) or (providerService.authTokenExists(providerKey)))}">
				<field_v1:hidden xpath="${xpath}/filter/${keyLabel}" constantValue="${providerKey}"/>
			</c:when>
			<c:otherwise>
				<agg_v1:provider_testing_key_required />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise><%-- NOTHING TO DO --%></c:otherwise>
</c:choose>
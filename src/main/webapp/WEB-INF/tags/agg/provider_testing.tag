<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Provides a method for external providers to test their prices only, without affecting production or future users"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

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
	<c:when test="${empty param[keyLabel] && (environmentService.getEnvironmentAsString() == 'localhost' || environmentService.getEnvironmentAsString() == 'NXI'  || environmentService.getEnvironmentAsString() == 'NXQ')}">
		<c:if test="${fn:startsWith(pageContext.request.remoteAddr,'192.168.') or fn:startsWith(pageContext.request.remoteAddr,'0:0:0:') or pageContext.request.remoteAddr == '127.0.0.1'}">
			<c:if test="${hideSelector eq false}">
				<form_new:fieldset_columns displayFullWidth="${displayFullWidth}">
					<jsp:attribute name="rightColumn">
					</jsp:attribute>
					<jsp:body>
						<form_new:fieldset legend="Provider Testing">
							<c:set var="fieldXpath" value="${xpath}/filter/${filterProperty}" />
							<form_new:row label="Provider" fieldXpath="${fieldXpath}">
								<field:provider_select productCategories="${pageSettings.getVerticalCode()}" xpath="${fieldXpath}" />
							</form_new:row>
						</form_new:fieldset>
					</jsp:body>
				</form_new:fieldset_columns>
			</c:if>
		</c:if>
	</c:when>
	<c:when test="${not empty param[keyLabel] || environmentService.getEnvironmentAsString() == 'NXS'}">
		<c:set var="providerKey"><c:out value="${param[keyLabel]}" escapeXml="true" /></c:set>
		<jsp:useBean id="providerService" class="com.ctm.services.ProviderService" />
		<c:choose>
			<c:when test="${not empty providerKey && ((keyLabel ne 'authToken' && providerService.providerKeyExists(providerKey)) or (providerService.authTokenExists(providerKey)))}">
				<field:hidden xpath="${xpath}/filter/${keyLabel}" constantValue="${providerKey}"/>
			</c:when>
			<c:otherwise>
				<agg:provider_testing_key_required />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise><%-- NOTHING TO DO --%></c:otherwise>
</c:choose>
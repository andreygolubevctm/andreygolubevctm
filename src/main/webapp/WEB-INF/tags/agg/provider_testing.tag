<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Provides a method for external providers to test their prices only, without affecting production or future users"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="displayFullWidth" required="false"	 rtexprvalue="true"	 description="Determine's whether or not to display the provider testing fields as full width" %>

<%-- Make sure we're in a proper environment to test this --%>
<c:choose>
	<c:when test="${environmentService.getEnvironmentAsString() == 'localhost' || environmentService.getEnvironmentAsString() == 'NXI'  || environmentService.getEnvironmentAsString() == 'NXQ'}">
		<c:if test="${fn:startsWith(pageContext.request.remoteAddr,'192.168.') or fn:startsWith(pageContext.request.remoteAddr,'0:0:0:') or pageContext.request.remoteAddr == '127.0.0.1'}">
			<form_new:fieldset_columns displayFullWidth="${displayFullWidth}">
				<jsp:attribute name="rightColumn">
				</jsp:attribute>
				<jsp:body>
					<form_new:fieldset legend="Provider Testing">
						<c:set var="fieldXpath" value="${xpath}/filter/singleProvider" />
						<form_new:row label="Provider" fieldXpath="${fieldXpath}">
							<field:provider_select productCategories="${pageSettings.getVerticalCode()}" xpath="${fieldXpath}" />
						</form_new:row>
					</form_new:fieldset>
				</jsp:body>
			</form_new:fieldset_columns>
		</c:if>
	</c:when>
	<c:when test="${environmentService.getEnvironmentAsString() == 'NXS'}">
		<c:set var="providerKey"><c:out value="${param.providerKey}" escapeXml="true" /></c:set>
		<jsp:useBean id="providerService" class="com.ctm.services.ProviderService" />
		<c:choose>
			<c:when test="${not empty providerKey && providerService.providerKeyExists(providerKey)}">
				<field:hidden xpath="${xpath}/filter/providerKey" constantValue="${providerKey}"/>
			</c:when>
			<c:otherwise>
				<agg:provider_testing_key_required />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise><%-- NOTHING TO DO --%></c:otherwise>
</c:choose>
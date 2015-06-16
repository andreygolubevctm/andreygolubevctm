<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Provides a method for external providers to test their prices only, without affecting production or future users"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="displayFullWidth" required="false"	 rtexprvalue="true"	 description="Determine's whether or not to display the provider testing fields as full width" %>
<%@ attribute name="showExpectedCoverDate" required="false"	 rtexprvalue="true"	 description="Toggles the Expected Cover Date dropdown" %>
<%@ attribute name="showNumberofResults" required="false"	 rtexprvalue="true"	 description="Toggles the Number of Resuklts dropdown" %>


<%-- NOTE: a List of Provider Keys can be found in aggregator/health/phio_outbound for health --%>

<%-- Make sure we're in a proper environment to test this --%>
<c:if test="${environmentService.getEnvironmentAsString() == 'localhost' || environmentService.getEnvironmentAsString() == 'NXI'  || environmentService.getEnvironmentAsString() == 'NXS'  || environmentService.getEnvironmentAsString() == 'NXQ'}">
	<c:choose>
		<c:when test="${empty param.providerKey}">
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

						<c:if test="${showNumberofResults ne false}">
							<c:set var="fieldXpath" value="${xpath}/searchResults" />
							<form_new:row label="Number of results" fieldXpath="${fieldXpath}">
								<field_new:count_select max="36" xpath="${fieldXpath}" min="12" title="Number of Results" required="false" step="12"/>
							</form_new:row>
						</c:if>
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
			<field:hidden xpath="${xpath}/filter/providerKey" constantValue="${providerKey}"/>
		</c:otherwise>
	</c:choose>


	<%-- This is separate and always available to internal and external --%>
	<c:if test="${showExpectedCoverDate ne false}">
		<form_new:fieldset_columns displayFullWidth="${displayFullWidth}">
			<jsp:attribute name="rightColumn">
			</jsp:attribute>
			<jsp:body>

			<form_new:fieldset legend="">
				<c:set var="fieldXpath" value="${xpath}/searchDate" />
				<form_new:row label="Application Date" fieldXpath="${fieldXpath}">
					<field:payment_day xpath="${fieldXpath}" title="searchDate" required="false" days="90" exclude="32" buffer="0"/>
					For testing future product searches
				</form_new:row>
			</form_new:fieldset>
				</jsp:body>
		</form_new:fieldset_columns>
	</c:if>
</c:if>
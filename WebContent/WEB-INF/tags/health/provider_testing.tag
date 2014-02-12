<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Provides a method for external providers to test their prices only, without affecting production or future users"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- NOTE: a List of Provider Keys can be found in aggregator/health/phio_outbound --%>

<%-- Make sure we're in a proper environment to test this --%>
<c:if test="${data.settings['environment'] == 'localhost' || data.settings['environment'] == 'NXI'  || data.settings['environment'] == 'NXS'}">
	<c:choose>
		<c:when test="${empty param.providerKey and (fn:startsWith(pageContext.request.remoteAddr,'192.168.') or fn:startsWith(pageContext.request.remoteAddr,'0:0:0:'))}">
			<form:row label="Provider">
				<field:provider_select productCategories="HEALTH" xpath="${xpath}/situation/singleProvider" />
			</form:row>
			<form:row label="Number of results">
				<field:count_select max="36" xpath="${xpath}/searchResults" min="12" title="Number of Results" required="false" step="12"/>
			</form:row>
			<form:row label="Expected Cover Date">
				<field:payment_day xpath="${xpath}/searchDate" title="searchDate" required="false" days="90" />
				For testing future searches
			</form:row>
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
</c:if>
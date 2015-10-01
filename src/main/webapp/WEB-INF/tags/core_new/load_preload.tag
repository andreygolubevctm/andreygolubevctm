<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Preloading form data." %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('tag.core_new.load_preload')}" />

<c:if test="${empty param.action && not empty param.preload && not fn:contains(param.preload, '/') &&  not fn:contains(param.preload, '/\') }">
	<c:set var="verticalCode" value="${pageSettings.verticalCode}" />
	<c:choose>
		<c:when test="${param.preload eq 'true'}">
			<c:import url="test_data/${fn:toLowerCase(verticalCode)}/form.xml" var="xmlDoc" />
		</c:when>
		<c:when test="${param.preload eq 'amt' and verticalCode eq 'travel'}">
			<c:import url="test_data/${fn:toLowerCase(verticalCode)}/formAMT.xml" var="xmlDoc" />
		</c:when>
		<c:otherwise>
			<c:catch var="error">
				<c:import url="test_data/${verticalCode}/application.xml" var="xmlDoc" />
			</c:catch>
			<c:if test="${error}">
				${logger.warn('Failed to import url. {}', log:kv('verticalCode', verticalCode), error)}
			</c:if>
		</c:otherwise>
	</c:choose>

	<go:setData dataVar="data" xml="${xmlDoc}" />

</c:if>


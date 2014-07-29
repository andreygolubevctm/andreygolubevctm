<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Preloading form data." %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${empty param.action && not empty param.preload && not fn:contains(param.preload, '/') &&  not fn:contains(param.preload, '/\') }">

	<c:choose>
		<c:when test="${param.preload ne 'true'}">
			<c:catch var="error">
				<c:import url="test_data/${pageSettings.getVerticalCode()}/application.xml" var="xmlDoc" />
			</c:catch>
			<c:if test="${not empty error}">
				<c:redirect url="${pageContext.request.requestURL}" />
			</c:if>
		</c:when>
		<c:otherwise>
			<c:import url="test_data/${fn:toLowerCase(pageSettings.getVerticalCode())}/form.xml" var="xmlDoc" />
		</c:otherwise>
	</c:choose>

	<go:setData dataVar="data" xml="${xmlDoc}" />

</c:if>


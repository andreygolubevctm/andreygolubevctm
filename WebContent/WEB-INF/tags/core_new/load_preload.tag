<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Preloading form data." %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="${pageSettings.vertical}" />
</c:if>

<c:if test="${empty param.action && not empty param.preload }">

	<c:choose>
		<c:when test="${param.preload ne 'true'}">
			<c:import url="test_data/${pageSettings.vertical}/${param.preload}.xml" var="xmlDoc" />
		</c:when>
		<c:otherwise>
			<c:import url="test_data/${pageSettings.vertical}/form.xml" var="xmlDoc" />
		</c:otherwise>
	</c:choose>

	<go:setData dataVar="data" xml="${xmlDoc}" />

</c:if>


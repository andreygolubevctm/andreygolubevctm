<%@tag import="java.util.ArrayList"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_new:no_cache_header/>

<session:get settings="true"/>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<c:set var="brand" value="${pageSettings.getBrandCode()}" />

<c:choose>
	<c:when test="${not empty vertical and not empty brand}">
		<c:choose>
			<c:when test="${vertical eq 'health'}">
				<c:if test="${not empty data.health.contactDetails.email}">
					<agg:email_send brand="${fn:toUpperCase(brand)}" vertical="${vertical}" email="${data.health.contactDetails.email}" mode="bestprice" tmpl="${vertical}" />
				</c:if>
			</c:when>

			<c:otherwise><%-- ignore --%></c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise></c:otherwise>
</c:choose>
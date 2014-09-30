<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="scrapeId" required="false"	rtexprvalue="true"	description="id for scapes table defaults to 133" %>
<%@ attribute name="includeCopyRight" required="false"	rtexprvalue="true"	description="boolean to display the ctm copyright notice defaults to true" %>

<c:if test="${empty includeCopyRight}">
	<c:set var="includeCopyRight" value="${true}" />
</c:if>

<%-- HTML --%>
<agg:footer_outer includeCopyRight="${includeCopyRight}">
	<c:choose>
		<c:when test="${empty scrapeId}">
			<p>
				<content:get key="footerTextStart"/><content:get key="footerParticipatingSuppliers"/><content:get key="footerTextEnd"/>
			</p>
		</c:when>
		<c:otherwise>
			<form:scrape id="${scrapeId}" />
		</c:otherwise>
	</c:choose>
</agg:footer_outer>


<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="includeCopyRight" required="false"	rtexprvalue="true"	description="boolean to display the ctm copyright notice defaults to true" %>

<c:if test="${empty includeCopyRight}">
	<c:set var="includeCopyRight" value="${true}" />
</c:if>

<%-- HTML --%>
<footer id="footer" class="clearfix">
	<div class="container">
		<div data-poweredby="footer">&nbsp;</div>
		<content:get key="footerSecurityBadge" />
		<jsp:doBody />
	</div>
</footer>

<c:if test="${includeCopyRight}">
	<%-- Copyright notice --%>
	<c:choose>
		<c:when test="${pageSettings.getVerticalCode() eq 'health'}">
			<agg_v2:copyright_notice />
		</c:when>
		<c:otherwise>
			<agg_v1:copyright_notice />
		</c:otherwise>
	</c:choose>
</c:if>
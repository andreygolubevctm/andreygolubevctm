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
	<agg:copyright_notice />
</c:if>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="includeCopyRight" required="false"	rtexprvalue="true"	description="boolean to display the ctm copyright notice defaults to true" %>

<c:if test="${empty includeCopyRight}">
	<c:set var="includeCopyRight" value="${true}" />
</c:if>

<%-- HTML --%>
<div id="footer" class="clearfix">
	<div class="container">
		<quote:mcafee/>
		<jsp:doBody />
	</div>
</div>

<c:if test="${includeCopyRight}">
	<%-- Copyright notice --%>
	<agg:copyright_notice />
</c:if>
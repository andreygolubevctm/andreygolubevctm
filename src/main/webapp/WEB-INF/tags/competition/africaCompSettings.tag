<%@ tag description="Africa Safari Competition Settings"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="africaComp" scope="application" value="${false}" />
<c:set var="africaCompDB"><content:get key="africaComp" /></c:set>
<c:if test="${pageSettings.getBrandCode() eq 'ctm' && africaCompDB eq 'Y'}">
    <c:set var="africaComp" scope="application" value="${true}"/>
</c:if>
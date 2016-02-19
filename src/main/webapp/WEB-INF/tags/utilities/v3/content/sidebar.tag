<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="excludeContent" required="false" rtexprvalue="true" description="Anything that needs excluding on this slide" %>

<div class="yourDetailsSnapshotContainer"></div>

<c:set var="sidebarContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "snapshot")}' />

<c:set var="snapshotTitle" value="" />
<c:set var="snapshotContent" value="" />

<c:forEach items="${sidebarContent.getSupplementary()}" var="item" >
    <c:if test="${fn:contains(item.getSupplementaryKey(), 'Title') and not fn:contains(excludeContent, item.getSupplementaryKey())}">
        <c:set var="snapshotTitle" value="${item.getSupplementaryValue()}" />
    </c:if>

    <c:if test="${fn:contains(item.getSupplementaryKey(), 'Content') and not fn:contains(excludeContent, item.getSupplementaryKey())}">
        <c:set var="snapshotContent" value="${item.getSupplementaryValue()}" />
    </c:if>

    <c:if test="${not empty snapshotContent and not empty snapshotTitle}">
        <utilities_v3_content:snapshot title="${snapshotTitle}" content="${snapshotContent}" />
        <c:set var="snapshotTitle" value="" />
        <c:set var="snapshotContent" value="" />
    </c:if>

</c:forEach>
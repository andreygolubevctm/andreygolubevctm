<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="yourDetailsSnapshotContainer"></div>

<c:set var="sidebarContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "snapshot")}' />

<c:set var="snapshotTitle" value="" />
<c:set var="snapshotContent" value="" />

<c:forEach items="${sidebarContent.getSupplementary()}" var="item" >
    <c:if test="${fn:contains(item.getSupplementaryKey(), 'Title')}">
        <c:set var="snapshotTitle" value="${item.getSupplementaryValue()}" />
    </c:if>

    <c:if test="${fn:contains(item.getSupplementaryKey(), 'Content')}">
        <c:set var="snapshotContent" value="${item.getSupplementaryValue()}" />
    </c:if>

    <c:if test="${not empty snapshotContent and not empty snapshotTitle}">
        <utilities_v3_content:snapshot title="${snapshotTitle}" content="${snapshotContent}" />
        <c:set var="snapshotTitle" value="" />
        <c:set var="snapshotContent" value="" />
    </c:if>

</c:forEach>
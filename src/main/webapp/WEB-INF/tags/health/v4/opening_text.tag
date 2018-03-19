<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Opening text for different devices"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--Mobile--%>
<c:set var="mobileOpen247Text">
    <content:get key="open247Text" suppKey="mobile"/>
</c:set>

<c:set var="mobileOpenText" scope="application">
    <c:choose>
        <c:when test="${mobileOpen247Text ne ''}">
            ${mobileOpen247Text}
        </c:when>
        <c:otherwise>
            <content:get key="openDefaultText" suppKey="mobile"/>
        </c:otherwise>
    </c:choose>
</c:set>

<%--Tablet--%>
<c:set var="tabletOpen247Text">
    <content:get key="open247Text" suppKey="tablet"/>
</c:set>

<c:set var="tabletOpenText" scope="application">
    <c:choose>
        <c:when test="${tabletOpen247Text ne ''}">
            ${tabletOpen247Text}
        </c:when>
        <c:otherwise>
            <content:get key="openDefaultText" suppKey="tablet"/>
        </c:otherwise>
    </c:choose>
</c:set>

<%--Desktop--%>
<c:set var="desktopOpen247Text">
    <content:get key="open247Text" suppKey="desktop"/>
</c:set>

<c:set var="desktopOpenText" scope="application">
    <c:choose>
        <c:when test="${desktopOpen247Text ne ''}">
            ${desktopOpen247Text}
        </c:when>
        <c:otherwise>
            <content:get key="openDefaultText" suppKey="desktop"/>
        </c:otherwise>
    </c:choose>
</c:set>
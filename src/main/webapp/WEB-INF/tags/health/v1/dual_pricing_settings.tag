<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="simplesDPActive"><content:get key="simplesDPActive" /></c:set>
<c:set var="simplesDPActive">
    <c:choose>
        <c:when test="${simplesDPActive eq 'Y'}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>
</c:set>

<c:set var="onlineDPActive"><content:get key="onlineDPActive" /></c:set>
<c:set var="onlineDPActive">
    <c:choose>
        <c:when test="${onlineDPActive eq 'Y'}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>
</c:set>

<c:set var="isDualPriceActive" scope="application">
    <c:choose>
        <c:when test="${(not empty callCentre and simplesDPActive eq true) or (empty callCentre and onlineDPActive eq true)}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>
</c:set>

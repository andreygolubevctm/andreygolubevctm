<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="simplesPyrrActive"><content:get key="simplesPyrrActive" /></c:set>
<c:set var="simplesPyrrActive">
    <c:choose>
        <c:when test="${simplesPyrrActive eq 'Y'}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>
</c:set>

<c:set var="onlinePyrrActive"><content:get key="onlinePyrrActive" /></c:set>
<c:set var="onlinePyrrActive">
    <c:choose>
        <c:when test="${onlinePyrrActive eq 'Y'}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>
</c:set>

<c:set var="isPyrrActive" scope="application">
    <c:choose>
        <c:when test="${(not empty callCentre and simplesPyrrActive eq true) or (empty callCentre and onlinePyrrActive eq true)}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>
</c:set>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="leadCaptureActive"><content:get key="leadCaptureActive" /></c:set>
<c:set var="leadCaptureActive" scope="application">
    <c:choose>
        <c:when test="${leadCaptureActive eq 'Y'}">true</c:when>
        <c:otherwise>false</c:otherwise>
    </c:choose>
</c:set>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpathHouseholdDetails" 	required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:choose>
    <c:when test="${not empty param.utility_location}">
        <div id="showLocation" data-show="false"></div>
        <c:set var="param_location">
            <c:out value="${param.utility_location}" escapeXml="true"/>
        </c:set>
    </c:when>
    <c:otherwise>
        <div id="showLocation" data-show="true"></div>
    </c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${not empty param.utility_compareto}">
        <div id="showCompareTo" data-show="false"></div>
        <c:set var="param_compareto">
            <c:out value="${param.utility_compareto}" escapeXml="true"/>
        </c:set>
    </c:when>
    <c:otherwise>
        <div id="showCompareTo" data-show="true"></div>
    </c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${not empty param.utility_movingin}">
        <div id="showMovingIn" data-show="false"></div>
        <c:set var="param_movingin">
            <c:out value="${param.utility_movingin}" escapeXml="true"/>
        </c:set>
    </c:when>
    <c:otherwise>
        <div id="showMovingIn" data-show="true"></div>
    </c:otherwise>
</c:choose>


<go:setData dataVar="data" xpath="${xpathHouseholdDetails}/location" value="${param_location}"/>
<go:setData dataVar="data" xpath="${xpathHouseholdDetails}/whatToCompare" value="${param_compareto}"/>
<go:setData dataVar="data" xpath="${xpathHouseholdDetails}/movingIn" value="${param_movingin}"/>

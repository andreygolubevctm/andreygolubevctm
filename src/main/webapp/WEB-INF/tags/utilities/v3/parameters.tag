<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpathHouseholdDetails" 	required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<!-- If you want to hide the fields when using query string just set data-show to false -->
<!-- at the moment the requirement of hiding the text fields when coming from the widget has been relaxed See Deans comment on UTL-388
So data will always be shown. However if we ever want to hide the fields on the widget the when condition will yield to data-show='false' -->
<c:choose>
    <c:when test="${not empty param.utility_location}">
        <div id="showLocation" data-show="true"></div>
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
        <div id="showCompareTo" data-show="true"></div>
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
        <div id="showMovingIn" data-show="true"></div>
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

<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="key" required="true" rtexprvalue="true" description="For DB lookup of content" %>

<c:set var="isTrackingEnabled">
    <content:get key="trackingEnabled" />
</c:set>

<c:if test="${not empty isTrackingEnabled and isTrackingEnabled eq true}">
    <%-- Variables --%>
    <c:set var="trackingItems" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), key)}' />

    <c:set var="PHGHandoverClick">
        <url>
            <content:get key="${key}" />
        </url>
        <partnerValues>
        <c:forEach items="${trackingItems.getSupplementary()}" var="partnerCodes" >
            <${partnerCodes.getSupplementaryKey()}>
                ${partnerCodes.getSupplementaryValue()}
            </${partnerCodes.getSupplementaryKey()}>

        </c:forEach>
        </partnerValues>
    </c:set>

    <%-- Return the results as json --%>
    ${go:XMLtoJSON(PHGHandoverClick)}
</c:if>
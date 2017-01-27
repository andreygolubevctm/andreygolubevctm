<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Credit Card Handover" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" scope="request" />
<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/" />

<div class="row handover-container journeyEngineSlide active">

    <%-- Also do A touch --%>
    <core_v1:transaction touch="A" noResponse="true" writeQuoteOverride="Y" productId="${productID}" />
    <div id="loading">
        <img src="${assetUrl}brand/${pageSettings.getBrandCode()}/graphics/spinner-burp.gif" alt="Loading" />
        <h4>Please hold while we securely transfer you to <c:out value="${productBrand}" />...</h4>
        <noscript><a href="${productHandoverUrl}">Click here to continue if you are not redirected within 5 seconds</a></noscript>
    </div>

</div>

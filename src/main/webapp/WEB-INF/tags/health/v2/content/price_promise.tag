<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="pricePromise" scope="request"><content:get key="healthPricePromise"/></c:set>

<c:if test="${not empty pricePromise}">
    <div class="sidebar-box pricePromiseBox">
        <div class="price-promise">
            <div class="pricePromiseLogoBlue"></div>
            <h4>Price match guarantee</h4>
            <c:out value="${pricePromise}" escapeXml="False" />
        </div>
    </div>
</c:if>
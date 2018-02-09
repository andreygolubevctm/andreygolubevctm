<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price promise iframe widget"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="iframeUrl"><content:get key="pricePromiseURL"/></c:set>

<c:if test="${pageSettings.getSetting('pricePromiseEnabled') eq 'Y' and iframeUrl ne ''}">
    <div class="price-promise-container hidden">
        <iframe src="${iframeUrl}" frameborder="0"></iframe>
    </div>
</c:if>
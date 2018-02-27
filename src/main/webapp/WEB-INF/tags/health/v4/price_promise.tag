<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price promise iframe widget"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="step" required="true" rtexprvalue="true" description="Journey Step" %>

<c:set var="iframeUrl"><content:get key="pricePromiseURL"/></c:set>

<c:if test="${pageSettings.getSetting('pricePromiseEnabled') eq 'Y' and iframeUrl ne ''}">
    <div class="price-promise-container hidden">
        <iframe frameborder="0" scrolling="no" data-src="${iframeUrl}" data-step="${step}"></iframe>
    </div>
</c:if>
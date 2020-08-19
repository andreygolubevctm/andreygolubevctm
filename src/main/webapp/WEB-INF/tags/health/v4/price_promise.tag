<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price promise iframe widget"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="step" required="true" rtexprvalue="true" description="Journey Step" %>
<%@ attribute name="dismissible" required="false" rtexprvalue="true" description="Is the price promise dismissible" %>

<c:set var="iframeUrl"><content:get key="pricePromiseURL"/></c:set>
<c:set var="iframeUrlNew"><content:get key="pricePromiseURLNew"/></c:set>

<c:if test="${pageSettings.getSetting('pricePromiseEnabled') eq 'Y' and iframeUrl ne ''}">
    <div class="price-promise-container" data-dismissible="${dismissible}">
        <c:if test="${dismissible}">
            <div class="price-promise-close">
                <span class="icon icon-cross"></span>
            </div>
        </c:if>
        <iframe frameborder="0" scrolling="no" data-src="${iframeUrlNew}" data-step="${step}"></iframe>
    </div>
</c:if>

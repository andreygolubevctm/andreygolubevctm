<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="More Info Price Promise"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${pageSettings.getSetting('pricePromiseEnabled') eq 'Y'}">
    <div class="productExtraInfoItem">
        <div class="moreInfoPricePromise">
            <object type="image/svg+xml" data="assets/brand/ctm/images/price_promise/pricepromise_logo.svg" height="97" width="97"></object>
        </div>
        <div class="extraInfoItemText">
            <p>Buy health insurance with us, and if you find the same policy cheaper elsewhere, we'll give you 110% of the difference for the first year. <a href="https://www.comparethemarket.com.au/wp-content/uploads/2018/04/Best-Price-Promise-terms-and-conditions.pdf" target="_blank">T&C's apply</a></p>
        </div>
    </div>
</c:if>

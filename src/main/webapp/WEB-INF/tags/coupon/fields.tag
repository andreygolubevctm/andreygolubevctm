<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 	required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<jsp:useBean id="couponService" class="com.ctm.web.core.coupon.services.CouponService" />

<c:set var="couponChannelCode">
	<c:choose>
		<c:when test="${callCentre}">C</c:when>
		<c:otherwise>O</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${couponService.canShowCouponField(pageContext.getRequest(), couponChannelCode)}">

    <c:choose>
        <c:when test="${callCentre}">
            <form_v2:row fieldXpath="${xpath}/coupon/code" label="If you have a promo code, enter it here" className="coupon-input-group">
                <div class="coupon-error-container hidden"><label></label></div>
                <field_v2:input type="password" xpath="${xpath}/coupon/code" title="Promo Code" required="false" className="coupon-code-field" />
                <field_v1:hidden xpath="${xpath}/coupon/id" className="coupon-id-field" />
            </form_v2:row>
            <form_v2:row className="coupon-success-container hidden" />
        </c:when>
        <c:otherwise>
            <field_v1:hidden xpath="${xpath}/coupon/code" className="coupon-code-field" />
            <field_v1:hidden xpath="${xpath}/coupon/id" className="coupon-id-field" />
        </c:otherwise>
    </c:choose>

    <form_v2:row className="coupon-optin-group hidden">
        <field_v2:checkbox xpath="${xpath}/coupon/optin" value="Y" required="true" label="${true}" title="" className="coupon-optin-field" errorMsg="Please agree to the Terms &amp; Conditions" />
    </form_v2:row>
</c:if>
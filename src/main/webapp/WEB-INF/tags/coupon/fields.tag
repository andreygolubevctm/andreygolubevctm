<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 	required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<jsp:useBean id="couponService" class="com.ctm.services.coupon.CouponService" />

<c:set var="couponChannelCode">
	<c:choose>
		<c:when test="${callCentre}">C</c:when>
		<c:otherwise>O</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${couponService.canShowCouponField(pageContext.getRequest(), couponChannelCode)}">

	<form_new:row fieldXpath="${xpath}/coupon/code" label="If you have a promo code, enter it here" className="coupon-input-group">
		<div class="coupon-error-container hidden"><label></label></div>
		<field_new:input xpath="${xpath}/coupon/code" title="Promo Code" required="false" className="coupon-code-field" />
		<field:hidden xpath="${xpath}/coupon/id" className="coupon-id-field" />
	</form_new:row>

	<form_new:row className="coupon-success-container hidden" />

	<form_new:row className="coupon-optin-group hidden">
		<field_new:checkbox xpath="${xpath}/coupon/optin" value="Y" required="true" label="${true}" title="" className="coupon-optin-field" errorMsg="Please agree to the Terms &amp; Conditions" />
	</form_new:row>

</c:if>
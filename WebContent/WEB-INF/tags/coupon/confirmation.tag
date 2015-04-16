<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="transactionId" 	required="true"	 rtexprvalue="true"	 description="transactionId to get confirmation html" %>

<jsp:useBean id="couponService" class="com.ctm.services.coupon.CouponService" />

<c:out value="${couponService.getCouponForConfirmation(transactionId)}" escapeXml="false" />
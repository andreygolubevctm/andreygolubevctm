<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for the fees."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/filter/features" />

<%-- HTML --%>
<div class="homeloan-filter-features">
	<field_new:checkbox xpath="${xpath}/redraw" value="redraw"
				title="Redraw"
				required="false"
				label="true" />
	<field_new:checkbox xpath="${xpath}/offset" value="offset"
				title="Offset"
				required="false"
				label="true" />
	<field_new:checkbox xpath="${xpath}/bpay" value="bpay"
				title="BPay"
				required="false"
				label="true" />
	<field_new:checkbox xpath="${xpath}/onlineBanking" value="onlineBanking"
				title="Online Banking"
				required="false"
				label="true" />
	<field_new:checkbox xpath="${xpath}/extraRepayments" value="extraRepayments"
				title="Extra Repayments"
				required="false"
				label="true" />
</div>

<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- LIST OUT ALL QUESTIONS FIRST --%>
<c:set var="openingQuestion"><content:get key="voucherFirstQuestionCopy" /></c:set>
<c:set var="fieldXpath" value="${xpath}/available" />
<div id="healthVouchers">
	<form_v3:row label="${openingQuestion}" fieldXpath="${fieldXpath}" className="healthVoucherAvailableRow">
		<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="voucher available" required="true" />
	</form_v3:row>
	<div class="voucherIsAvailable">
		<c:set var="fieldXpath" value="${xpath}/type" />
		<form_v3:row label="Voucher type?" fieldXpath="${fieldXpath}" className="healthVoucherTypeRow">
			<field_v2:general_select xpath="${fieldXpath}" type="healthVoucherTypes" required="true" title="the type of voucher" />
		</form_v3:row>
		<div class="voucher mando">
			<coupon:fields xpath="health" />
		</div>
		<div class="voucher other">
			<health_v2:voucher xpath="${xpath}" />
		</div>
	</div>
</div>
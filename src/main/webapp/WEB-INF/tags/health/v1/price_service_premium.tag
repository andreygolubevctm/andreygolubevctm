<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="membership"			required="true"	rtexprvalue="true"	description="membership type eg couple"  %>
<%@ attribute name="grossPrm" 			required="true" 	rtexprvalue="true"	description="gross premium (before discount)" %>
<%@ attribute name="prm" 				required="true" 	rtexprvalue="true"	description="base premium (may or may not have discount)" %>
<%@ attribute name="loading" 			required="true" 	rtexprvalue="true"	description="loading percentage" %>
<%@ attribute name="rebate" 			required="true" 	rtexprvalue="true"	description="rebate percentage" %>
<%@ attribute name="lhc" 				required="true"		rtexprvalue="true"	description="lhc" %>

<jsp:useBean id="premiumCalculator" class="com.ctm.web.health.price.PremiumCalculator" scope="request" />
${premiumCalculator.setLhc(lhc)}
${premiumCalculator.setLoading(loading)}
${premiumCalculator.setMembership(membership)}
${premiumCalculator.setBasePremium(prm)}
${premiumCalculator.setGrossPremium(grossPrm)}
${premiumCalculator.setRebate(rebate)}

<c:set var="loadingAmount" value="${premiumCalculator.getLoadingAmountDecimal()}" />
<c:set var="rebateAmount" value="${premiumCalculator.getRebateAmountDecimal()}" />
<c:set var="premiumWithRebateAndLHC" value="${premiumCalculator.getPremiumWithRebateAndLHCDecimal()}" />
<c:set var="lhcFreeValue" value="${premiumCalculator.getLHCFreeValueDecimal()}" />
<c:set var="baseAndLHC"><c:out value="${premiumCalculator.getBaseAndLHC()}" /></c:set>
<c:set var="discountAmount"><c:out value="${premiumCalculator.getDiscountValue()}" /></c:set>
<c:set var="discountPercentage"><c:out value="${premiumCalculator.getDiscountPercentage()}" /></c:set>

<c:choose>
    <c:when test="${premiumCalculator.getDiscountValue() > 0}">
        <c:set var="isDiscounted">Y</c:set>
    </c:when>
    <c:otherwise>
        <c:set var="isDiscounted">N</c:set>
    </c:otherwise>
</c:choose>

<c:set var="formattedRebate"><c:out value="${go:formatCurrencyPrecise(rebateAmount, true, true )}"  /></c:set>
<c:set var="formattedLoading"><c:out value="${go:formatCurrencyPrecise(loadingAmount, true, true)}" /></c:set>
<c:set var="formattedPremiumWithRebateAndLHC"><c:out value="${go:formatCurrencyPrecise(premiumWithRebateAndLHC, true, true )}" /></c:set>
<c:set var="formattedLhcFreeCurrency"><c:out value="${go:formatCurrencyPrecise(lhcFreeValue, true, true )}"  /></c:set>

<c:set var="pricing">Includes rebate of ${formattedRebate} &amp; LHC loading of ${formattedLoading}</c:set>
<c:set var="lhcfreetext">${formattedLhcFreeCurrency}</c:set>
<c:set var="lhcfreepricing">+ ${formattedLoading} LHC inc ${formattedRebate} Government Rebate</c:set>

<discounted>${isDiscounted}</discounted>
<discountAmount>${go:formatCurrency(discountAmount, true, true)}</discountAmount>
<discountPercentage>${discountPercentage}</discountPercentage>
<text>${formattedPremiumWithRebateAndLHC}</text>
<value>${go:formatCurrencyPrecise(premiumWithRebateAndLHC, false, false)}</value>
<pricing>${pricing}</pricing>
<lhcfreetext>${lhcfreetext}</lhcfreetext>
<lhcfreevalue>${go:formatCurrencyPrecise(lhcFreeValue, false, false)}</lhcfreevalue>
<lhcfreepricing>${lhcfreepricing}</lhcfreepricing>
<hospitalValue>${go:formatCurrency(lhc, false, false)}</hospitalValue>
<rebate>${rebate}</rebate>
<rebateValue>${formattedRebate}</rebateValue>
<lhcPercentage>${loading}</lhcPercentage>
<lhc>${formattedLoading}</lhc>
<base>${go:formatCurrency(prm, true, true)}</base>
<baseAndLHC>${go:formatCurrencyPrecise(baseAndLHC, true, true)}</baseAndLHC>
<grossPremium>${go:formatCurrency(grossPrm, true, true)}</grossPremium>
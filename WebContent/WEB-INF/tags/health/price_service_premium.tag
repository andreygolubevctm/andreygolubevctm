<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="membership"			required="true"	rtexprvalue="true"	description="membership type eg couple"  %>
<%@ attribute name="discount" 			required="true" 	rtexprvalue="true"	description="discount" %>
<%@ attribute name="star" 				required="true" 	rtexprvalue="true"	description="star" %>
<%@ attribute name="prm" 				required="true" 	rtexprvalue="true"	description="prm" %>
<%@ attribute name="loading" 			required="true" 	rtexprvalue="true"	description="loading" %>
<%@ attribute name="rebate" 			required="true" 	rtexprvalue="true"	description="rebate" %>
<%@ attribute name="lhc" 				required="true"		rtexprvalue="true"	description="lhc" %>

<jsp:useBean id="premiumCalculator" class="com.disc_au.price.health.PremiumCalculator" scope="request" />
${premiumCalculator.setLhc(lhc)}
${premiumCalculator.setLoading(loading)}
${premiumCalculator.setMembership(membership)}
${premiumCalculator.setBasePremium(prm)}
${premiumCalculator.setRebate(rebate)}

<c:set var="loadingAmount" value="${premiumCalculator.getLoadingAmount()}" />
<c:set var="rebateAmount" value="${premiumCalculator.getRebateAmount()}" />
<c:set var="premiumWithRebateAndLHC" value="${premiumCalculator.getPremiumWithRebateAndLHC()}" />
<c:set var="lhcFreeValue" value="${premiumCalculator.getLHCFreeValue()}" />
<c:set var="baseAndLHC"><c:out value="${premiumCalculator.getBaseAndLHC()}" /></c:set>

<c:set var="formattedRebate"><c:out value="${go:formatCurrency(rebateAmount, true, true )}"  /></c:set>
<c:set var="formattedLoading"><c:out value="${go:formatCurrency(loadingAmount, true, true)}" /></c:set>
<c:set var="formattedPremiumWithRebateAndLHC"><c:out value="${go:formatCurrency(premiumWithRebateAndLHC, true, true )}" /></c:set>
<c:set var="formattedLhcFreeCurrency"><c:out value="${go:formatCurrency(lhcFreeValue, true, true )}"  /></c:set>

<c:set var="discountText">${star}${formattedPremiumWithRebateAndLHC}</c:set>
<c:set var="pricing">Includes rebate of ${formattedRebate} &amp; LHC loading of ${formattedLoading}</c:set>
<c:set var="lhcfreetext">${star}${formattedLhcFreeCurrency}</c:set>
<c:set var="lhcfreepricing">+ ${formattedLoading} LHC inc ${formattedRebate} Government Rebate</c:set>

<discounted>${discount}</discounted>
<text>${discountText}</text>
<value>${go:formatCurrency(premiumWithRebateAndLHC, false, false)}</value>
<pricing>${pricing}</pricing>
<lhcfreetext>${lhcfreetext}</lhcfreetext>
<lhcfreevalue>${go:formatCurrency(lhcFreeValue, false, false)}</lhcfreevalue>
<lhcfreepricing>${lhcfreepricing}</lhcfreepricing>
<hospitalValue>${go:formatCurrency(lhc, false, false)}</hospitalValue>
<rebate>${rebate}</rebate>
<rebateValue>${formattedRebate}</rebateValue>
<lhc>${go:formatCurrency(loadingAmount, false, false)}</lhc>
<base>${go:formatCurrency(prm, true, true)}</base>
<baseAndLHC>${go:formatCurrency(baseAndLHC, true, true)}</baseAndLHC>
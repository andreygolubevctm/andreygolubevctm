<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="membership"			required="true"	rtexprvalue="true"	description="memebersip type eg couple"  %>
<%@ attribute name="discount" 			required="true" 	rtexprvalue="true"	description="discount" %>
<%@ attribute name="star" 				required="true" 	rtexprvalue="true"	description="star" %>
<%@ attribute name="prm" 				required="true" 	rtexprvalue="true"	description="prm" %>
<%@ attribute name="rebateCalc" 		required="true" 	rtexprvalue="true"	description="rebateCalc" %>
<%@ attribute name="loading" 			required="true" 	rtexprvalue="true"	description="loading" %>
<%@ attribute name="rebate" 			required="true" 	rtexprvalue="true"	description="rebate" %>
<%@ attribute name="healthRebate" 			required="true"		rtexprvalue="true"	description="healthRebate" %>
<%@ attribute name="lhc" 				required="true"		rtexprvalue="true"	description="lhc" %>
<%@ attribute name="active_fund"		required="false"	rtexprvalue="true"	description="active_fund" %>
<%@ attribute name="includeSpecialCase" required="false"	rtexprvalue="true"	description="includeSpecialCase"  %>


<c:set value="${lhc + 0}" var="lhc" />
<c:set value="${loading + 0}" var="loading" />
<jsp:useBean id="premiumCalculator" class="com.disc_au.price.health.PremiumCalculator" scope="request" />
${premiumCalculator.setLhc(lhc)}
${premiumCalculator.setLoading(loading)}
${premiumCalculator.setMembership(membership)}

<c:set var="loadingAmount" value="${premiumCalculator.getLoadingAmount()}" />

<c:set var="healthRebate" value="${healthRebate + 0.0}" />
<c:set var="prm" value="${prm + 0.0}" />
<c:set var="rebateCalc" value="${rebateCalc + 0.0}" />

<c:set var="formattedRebate"><c:out value="${go:formatCurrency(healthRebate, true, true )}"  /></c:set>
<c:set var="formattedLoading"><c:out value="${go:formatCurrency(loadingAmount,true, true)}" /></c:set>
<c:set var="formattedValueLoadingCurrency"><c:out value="${go:formatCurrency((prm * rebateCalc) + loadingAmount , true ,true )}" /></c:set>
<c:set var="formattedValueCurrency"><c:out value="${go:formatCurrency(prm * rebateCalc, true, true )}"  /></c:set>

<c:set var="discountText">${star}${formattedValueLoadingCurrency}</c:set>
<c:set var="value"><c:out value="${go:formatCurrency((prm * rebateCalc) + loadingAmount, false , false)}" /></c:set>
<c:set var="pricing">Includes rebate of ${formattedRebate}<c:out value="<br>" escapeXml="true" />&amp; LHC loading of ${formattedLoading}</c:set>
<c:set var="lhcfreetext">${star}${formattedValueCurrency}</c:set>
<c:set var="lhcfreevalue"><c:out value="${go:formatCurrency(prm * rebateCalc, false , false)}" /></c:set>
<c:set var="lhcfreepricing">plus LHC of ${formattedLoading} and including<c:out value="<br>" escapeXml="true" />${formattedRebate} Government Rebate.</c:set>
<c:set var="hospitalValue"><c:out value="${go:formatCurrency((lhc * rebateCalc) + loadingAmount, false, false)}"  /></c:set>
<c:set var="rebateValue">${formattedRebate}</c:set>
<c:set var="lhc"><c:out value="${go:formatCurrency(loadingAmount, false, false)}" /></c:set>

<c:choose>
	<c:when test="${active_fund eq 'THF'}">
		<c:set var="specialcase">true</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="specialcase">false</c:set>
	</c:otherwise>
</c:choose>

<discounted>${discount}</discounted>
<text>${discountText}</text>
<value>${value}</value>
<pricing>${pricing}</pricing>
<lhcfreetext>${lhcfreetext}</lhcfreetext>
<lhcfreevalue>${lhcfreevalue}</lhcfreevalue>
<lhcfreepricing>${lhcfreepricing}</lhcfreepricing>
<hospitalValue>${hospitalValue}</hospitalValue>
<rebate>${rebate}</rebate>
<rebateValue>${rebateValue}</rebateValue>
<lhc>${lhc}</lhc>
<c:if test="${includeSpecialCase}">
<specialcase>${specialcase}</specialcase>
</c:if>
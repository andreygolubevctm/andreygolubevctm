<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--TODO: why can't this be done client side?
	We'd like to keep these formulas hidden from competitors
--%>

<jsp:useBean id="now" class="java.util.Date"/>

<%--
Lifetime Health Cover and Rebate Discount Calculator
	- Family or single
	- Dependants > 1
	- Base Rebate on Income (tier)
	- Age adjustment (average age if 2)
	- Loading adjustment (average loading if 2 (calculated individually) )
	- Return results as JSON

	NOTE: premium calculation = premium + ( (premium * loading%) - (premium * rebate*) );
--%>

<%-- Variables --%>
<fmt:formatDate var="nowMonth" value="${now}" pattern="MM"/>

<c:set var="cover"><c:out value="${param.cover}" escapeXml="true" /></c:set>
<c:set var="cover" value="${go:jsEscape(fn:trim(cover))}" />

<c:set var="income" value="${fn:trim(param.income)}" />
	<%-- Note: set partner details with family check later --%>
	<fmt:formatNumber var="primaryDobYear" value="${fn:substring(fn:trim(param.primary_dob), 6, 12)+0}" pattern="####" minIntegerDigits="4" />
	<fmt:formatNumber var="primaryDobMonth" value="${fn:substring(fn:trim(param.primary_dob), 3, 5)+0}" pattern="##" minIntegerDigits="2" />
	<fmt:formatNumber var="primaryDobDay" value="${fn:substring(fn:trim(param.primary_dob), 0, 2)+0}" pattern="##" minIntegerDigits="2" />
	<c:set var="primaryAge"><field:age dob="${fn:trim(param.primary_dob)}" /></c:set>

<%--
----------
COVER TYPE
**********
--%>
<c:choose>
	<c:when test="${cover == 'SM'}">
		<c:set var="cover" value="singles" />
	</c:when>
	<c:when test="${cover == 'SF'}">
		<c:set var="cover" value="singles" />
	</c:when>
	<c:when test="${cover == 'S'}">
		<c:set var="cover" value="singles" />
	</c:when>
	<c:when test="${cover == 'SPF'}">
		<c:set var="cover" value="singlefamily" />
	</c:when>
	<c:when test="${cover == 'F' || cover == 'C' }">
		<c:set var="cover" value="families" />
		<c:if test="${not empty param.partner_dob}">
			<fmt:formatNumber var="partnerDobYear" value="${fn:substring(fn:trim(param.partner_dob), 6, 12)+0}" pattern="####" minIntegerDigits="4" />
			<fmt:formatNumber var="partnerDobMonth" value="${fn:substring(fn:trim(param.partner_dob), 3, 5)+0}" pattern="##" minIntegerDigits="2" />
			<fmt:formatNumber var="partnerDobDay" value="${fn:substring(fn:trim(param.partner_dob), 0, 2)+0}" pattern="##" minIntegerDigits="2" />
			<c:set var="partnerAge"><field:age dob="${fn:trim(param.partner_dob)}" /></c:set>
		</c:if>
	</c:when>
</c:choose>


<%--
------------
REBATE TABLE - replaced by direct tier call
************
--%>
<c:choose>
	<%-- Chosen not to use the rebate, so make it 0 --%>
	<c:when test="${param.rebate_choice == 'N'}">
		<c:set var="rebate" value="0" />
		<c:set var="income" value="-1" />
	</c:when>
	<%-- Tier 0 (no change) --%>
	<c:when test="${income == 0}">
		<c:set var="rebate" value="30" />
	</c:when>
	<%-- Tier 1 --%>
	<c:when test="${income == 1}">
		<c:set var="rebate" value="20" />
	</c:when>
	<%-- Tier 2 --%>
	<c:when test="${income == 2}">
		<c:set var="rebate" value="10" />
	</c:when>
	<%-- Tier 3 --%>
	<c:when test="${income == 3}">
		<c:set var="rebate" value="0" />
	</c:when>
</c:choose>


<%--
--------------
AGE ADJUSTMENT - if rebate not 0 (Take the OLDEST person and use their age)
**************
--%>
<c:set var="rebateBonus" value="${0}" />

<c:choose>
	<c:when test="${partnerAge+0 >= primaryAge+0}">
		<fmt:parseNumber var="age" value="${partnerAge}"/>
	</c:when>
	<c:otherwise>
		<fmt:parseNumber var="age" value="${primaryAge}"/>
	</c:otherwise>
</c:choose>

<%-- CALC: age adjustment --%>
<c:choose>
	<c:when test="${age >= 65 && age <= 69}">
		<c:set var="rebateBonus" value="${5}" />
	</c:when>
	<c:when test="${age >= 70}">
		<c:set var="rebateBonus" value="${10}" />
	</c:when>
</c:choose>

<c:if test="${not empty rebate && rebate > 0}">
	<c:set var="rebate" value="${rebate + rebateBonus}" />
</c:if>


<%--
*************
GOV Rebate Factor - Calculate new rebate based on rebate multiplier variables
-------------
--%>

<jsp:useBean id="changeOverRebatesService" class="com.ctm.web.simples.services.ChangeOverRebatesService" />
<c:set var="changeOverRebates" value="${changeOverRebatesService.getChangeOverRebate(null)}"/>
<c:set var="rebate_multiplier_current" value="${changeOverRebates.getCurrentMultiplier()}"/>
<c:set var="rebate_multiplier_future" value="${changeOverRebates.getFutureMultiplier()}"/>

<c:set var="rebateChangeover">
	<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="3" value="${rebate * rebate_multiplier_future}" />
</c:set>
<c:set var="rebate">
	<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="3" value="${rebate * rebate_multiplier_current}" />
</c:set>

<%--
*************
LOADING (LHC) - Calculate Loading LHC adjustment (Average individual results for 2 Adults)
-------------
--%>


<%-- Calculate loading primary: a manual value overrides the need for calc --%>
<c:choose>
	<c:when test="${param.primary_loading_manual == 'undefined' || empty param.primary_loading_manual}">
		<%-- calc the rebate --%>
		<c:choose>
			<c:when test="${(param.primary_loading == 'Y' && param.primary_current == 'Y' ) || ( (primaryDobYear < 1934) || (primaryDobYear == 1934 && primaryDobMonth < 7) || (primaryDobYear == 1934 && primaryDobMonth == 7 && primaryDobDay == 1) )}">
				<c:set var="primary_loading_rate" value="${0}" />
			</c:when>
			<c:otherwise>

				<%-- Age Adjustment, only need to pay the LHC on the next July after your Birthday --%>
				<c:set var="primaryAdjustment" value="0" />
				<c:set var="primaryBirthdayAchieved"><field:birthday dob="${fn:trim(param.primary_dob)}" /></c:set>

				<c:choose>
					<c:when test="${primaryAge == 31 && primaryDobMonth  == 7 && primaryDobDay == 1}">
						<c:set var="primaryAdjustment" value="-1" /> <%-- This is an exception to the algorithm --%>
					</c:when>
					<c:when test="${primaryDobMonth < 7 || (primaryDobMonth == 7 && primaryDobDay == 1)}">
						<c:if test="${primaryBirthdayAchieved == 'true' && nowMonth < 7}">
							<c:set var="primaryAdjustment" value="-1" />
						</c:if>
					</c:when>
					<c:otherwise>
						<c:if test="${primaryBirthdayAchieved == 'true'}">
							<c:set var="primaryAdjustment" value="-1" />
						</c:if>
						<c:if test="${primaryBirthdayAchieved == 'false' && nowMonth < 7}">
							<c:set var="primaryAdjustment" value="-1" />
						</c:if>
					</c:otherwise>
				</c:choose>
				<fmt:formatNumber var="primary_loading_rate" value="${(primaryAge - 30 + primaryAdjustment) * 2}" />
			</c:otherwise>
		</c:choose>
		<c:set var="primary_loading_cae" value="${primary_loading_rate}" />
		<%-- max rate rule --%>
		<c:if test="${primary_loading_rate > 70}">
			<c:set var="primary_loading_rate" value="${70}" />
		</c:if>
		<%-- min rate rule --%>
		<c:if test="${primary_loading_rate < 0}">
			<c:set var="primary_loading_rate" value="${0}" />
			<c:set var="primary_loading_cae" value="${0}" />
		</c:if>
		<c:set var="primary_loading_rate" value="${primary_loading_rate}" />
	</c:when>
	<c:otherwise>
		<fmt:formatNumber var="primary_loading_rate" value="${param.primary_loading_manual}" maxFractionDigits="0" />
		<c:set var="primary_loading_cae" value="${primary_loading_rate}" />
	</c:otherwise>
</c:choose>

<c:set var="loading" value="${primary_loading_rate}" />

<%-- Calculate loading partner: a manual value overrides the need for calc --%>
<c:if test="${not empty partnerAge && cover == 'families'}">
	<c:choose>
		<c:when test="${param.partner_loading_manual == 'undefined' || empty param.partner_loading_manual}">
				<%-- Calc the partner rate --%>
				<c:choose>
					<c:when test="${(param.partner_loading == 'Y' && param.partner_current == 'Y' ) || ( (partnerDobYear < 1934) || (partnerDobYear == 1934 && partnerDobMonth < 7) || (partnerDobYear == 1934 && partnerDobMonth == 7 && partnerDobDay == 1) )}">
						<c:set var="partner_loading_rate" value="${0}" />
					</c:when>
					<c:otherwise>

						<%-- Age Adjustment, only need to pay the LHC on the next July after your Birthday --%>
						<c:set var="partnerAdjustment" value="0" />
						<c:set var="partnerBirthdayAchieved"><field:birthday dob="${fn:trim(param.partner_dob)}" /></c:set>

						<c:choose>
							<c:when test="${partnerAge == 31 && partnerDobMonth  == 7 && partnerDobDay == 1}">
								<c:set var="partnerAdjustment" value="-1" /> <%-- This is an exception to the algorithm --%>
							</c:when>
							<c:when test="${partnerDobMonth < 7 || (partnerDobMonth == 7 && partnerDobDay == 1)}">
								<c:if test="${partnerBirthdayAchieved == 'true' && nowMonth < 7}">
									<c:set var="partnerAdjustment" value="-1" />
								</c:if>
							</c:when>
							<c:otherwise>
								<c:if test="${partnerBirthdayAchieved == 'true'}">
									<c:set var="partnerAdjustment" value="-1" />
								</c:if>
								<c:if test="${partnerBirthdayAchieved == 'false' && nowMonth < 7}">
									<c:set var="partnerAdjustment" value="-1" />
								</c:if>
							</c:otherwise>
						</c:choose>

						<fmt:formatNumber var="partner_loading_rate" value="${(partnerAge - 30 + partnerAdjustment) * 2}" />
					</c:otherwise>
				</c:choose>
				<c:set var="partner_loading_cae" value="${partner_loading_rate}" />
				<%-- max rate rule --%>
				<c:if test="${partner_loading_rate > 70}">
					<c:set var="partner_loading_rate" value="${70}" />
				</c:if>
				<%-- min rate rule --%>
				<c:if test="${partner_loading_rate < 0}">
					<c:set var="partner_loading_rate" value="${0}" />
					<c:set var="partner_loading_cae" value="${0}" />
				</c:if>
		</c:when>
		<c:otherwise>
			<fmt:formatNumber var="partner_loading_rate" value="${param.partner_loading_manual}" maxFractionDigits="0" />
			<c:set var="partner_loading_cae" value="${partner_loading_rate}" />
		</c:otherwise>
	</c:choose>
	<fmt:formatNumber var="loading" value="${(primary_loading_rate + partner_loading_rate) / 2}" maxFractionDigits="0" />
</c:if>

<%--
Certified Age of Entry: Defaults to 30.
--%>
<c:set var="primaryCAE"><fmt:formatNumber value="${30 + (primary_loading_cae / 2)}" maxFractionDigits="0" /></c:set>
<c:set var="partnerCAE"><fmt:formatNumber value="${30 + (partner_loading_cae / 2)}" maxFractionDigits="0" /></c:set>

<c:choose>
	<c:when test="${not empty cover && empty income && not empty primaryAge}">
		<%-- Only retrieve loading --%>
		<c:set var="response">{ "status":"ok", "loading":"${loading}", "partnerLoading":"${partner_loading_rate}", "primaryLoading":"${primary_loading_rate}", "type":"${cover}", "primaryAge":"${primaryAge}", "primaryCAE":"${primaryCAE}","partnerCAE":"${partnerCAE}" }</c:set>
	</c:when>
	<c:when test="${empty rebate || empty cover || empty income || empty primaryAge}">
		<c:set var="response">{ "status":"error", "message":"missing required information", "ageBonus":"${rebateBonus}"  }</c:set>
	</c:when>
		<%-- retrieve loading and rebate --%>
	<c:otherwise>
		<c:set var="response">{ "status":"ok", "rebate":"${rebate}", "rebateChangeover":"${rebateChangeover}", "loading":"${loading}", "partnerLoading":"${partner_loading_rate}", "primaryLoading":"${primary_loading_rate}", "type":"${cover}", "tier":"${income}", "ageBonus":"${rebateBonus}", "primaryAge":"${primaryAge}", "primaryCAE":"${primaryCAE}","partnerCAE":"${partnerCAE}" }</c:set>
	</c:otherwise>
</c:choose>

${response}
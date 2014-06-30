<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="baseSingleRebateText" >Under $90,000</c:set>
<c:set var="tier1SingleRebateText" >$90,001-$105,000</c:set>
<c:set var="tier2SingleRebateText" >$105,001-$140,000</c:set>
<c:set var="tier3SingleRebateText" >Over $140,001</c:set>

<c:set var="baseFamilyRebateText" >Under $180,000</c:set>
<c:set var="tier1FamilyRebateText" >$180,001-$210,000</c:set>
<c:set var="tier2FamilyRebateText" >$210,001-$280,000</c:set>
<c:set var="tier3FamilyRebateText" >Over $280,001</c:set>


<%-- Include this tag to add required rebate multiplier variables to the request --%>
<health:changeover_rebates />

<%-- Format the range of rebates for use in various places - either a whole percent or the adjusted percent to 3 decimal places --%>
<c:set var="rebate_value_40" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${40 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>40</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_35" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${35 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>35</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_30" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${30 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>30</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_25" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${25 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>25</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_20" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${20 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>20</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_15" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${15 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>15</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_10" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${10 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>10</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div id="rebates-info-dialog" data-title="Information about the Government Rebate">
	<div class="col-sm-12">
		<h3>What is the Australian Government Rebate?</h3>
		<p>The health insurance rebate exists to provide financial assistance to those who need help with the cost of their health insurance premium.
		It is currently means-tested and tiered according to taxable income and the age of the oldest person covered by the policy.</p>
		<p>Currently, if you take out private health insurance and Lifetime health cover loading has been applied to your
		premium and you meet the eligibility criteria for an Australian Government Rebate, you will receive the full rebate on the premium and the Lifetime
		health cover loading.</p>

		<h3>How does the Australian Government Rebate affect you?</h3>


		<div class="table-responsive">
			<table>
				<thead>
					<tr>
						<th>Type of Member</th>
						<th>No Tier</th>
						<th>Tier 1</th>
						<th>Tier 2</th>
						<th>Tier 3</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Singles</td>
						<td>${baseSingleRebateText}</td>
						<td>${tier1SingleRebateText}</td>
						<td>${tier2SingleRebateText}</td>
						<td>${tier3SingleRebateText}</td>
					</tr>
					<tr>
						<td>Families</td>
						<td>${baseFamilyRebateText}</td>
						<td>${tier1FamilyRebateText}</td>
						<td>${tier2FamilyRebateText}</td>
						<td>${tier3FamilyRebateText}</td>
					</tr>
				</tbody>
			</table>
	</div>

	<p>This includes single parent families.</p>
	<p>The income thresholds are adjusted for families with more than one child, being increased by $1,500 for every dependent child after the first.</p>

	<h3>Claiming the Health Insurance Rebate</h3>

	<p>The health insurance rebate can be claimed in one of three ways:</p>
	<ol>
		<li>Deduct the cost of the rebate directly from your health insurance premium.</li>
		<li>Claim the rebate on your tax return.</li>
		<li>Claim the rebate from your local Medicare office.</li>
	</ol>
	<p>The easiest and most popular method of claiming is to deduct the rebate directly from your health insurance premium, which is an option you can select on your health insurance policy application.</p>
	<p>If you claim a rebate and find at the end of the financial year that it was incorrect for whatever reason,
	the Australian Tax Office will simply correct the amount either overpaid or owing to you after your tax return has been completed.
	There is no penalty for making a rebate claim that turns out to have been incorrect.</p>

	<h3>What is the Medicare Levy Surcharge?</h3>
	<p>The Medicare Levy Surcharge is an extra tax levied on higher income earners who don't hold hospital cover. The purpose of the Surcharge is to encourage more people to take out private health insurance and ease the burden on the public health care system.</p>

	<h3>How much is the Medicare Levy Surcharge?</h3>
	<p>The Medicare Levy Surcharge is dependent on your taxable income.</p>

	<h3>2014-2015 Medicare Levy Surcharge for singles</h3>
	<div class="table-responsive">
		<table>
			<thead>
				<tr>
					<th>Income threshold</th>
					<th>Medicare Levy Surcharge</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>${baseSingleRebateText}</td>
					<td>0.00%</td>
				</tr>
				<tr>
					<td>${tier1SingleRebateText}</td>
					<td>1.00%</td>
				</tr>
				<tr>
					<td>${tier2SingleRebateText}</td>
					<td>1.25%</td>
				</tr>
				<tr>
					<td>${tier3SingleRebateText}</td>
					<td>1.50%</td>
				</tr>
			</tbody>
		</table>
	</div>

	<h3>2014-2015 Medicare Levy Surcharge for couples and families</h3>
	<div class="table-responsive">
		<table>
			<thead>
				<tr>
					<th>Income threshold</th>
					<th>Medicare Levy Surcharge</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>${baseFamilyRebateText}</td>
					<td>0.00%</td>
				</tr>
				<tr>
					<td>${tier1FamilyRebateText}</td>
					<td>1.00%</td>
				</tr>
				<tr>
					<td>${tier2FamilyRebateText}</td>
					<td>1.25%</td>
				</tr>
				<tr>
					<td>${tier3FamilyRebateText}</td>
					<td>1.50%</td>
				</tr>
			</tbody>
		</table>
	</div>

	<p>This includes single parent families.</p>
	<p>The income thresholds are adjusted for families with more than one child, being increased by $1,500 for every dependent child after the first.</p>

	<h3>Can I avoid the Medicare Levy Surcharge?</h3>
	<p>You can avoid paying the additional tax simply by taking out eligible private hospital cover. In order to be eligible, your hospital cover must be with a registered Australian health fund (all of our participating health funds are registered) and have an excess or co-payment no greater than $500 for singles policies or $1,000 for couples or family policies.</p>

	<h3>Additional considerations</h3>

	<h5>Medicare Levy Surcharge vs Medicare Levy</h5>
	<p>The Medicare Levy is a 2.0% tax that is paid by most taxpayers and is different to the Medicare Levy Surcharge, as it is not dependent on holding hospital cover. The Surcharge is an additional tax that can be avoided by taking out hospital cover.</p>

	<h5>Extras cover will not exempt you from the Medicare Levy Surcharge</h5>

	<p>You must ensure that you have hospital cover in order to be exempt from paying the surcharge, as extras cover is not enough.</p>
	</div>
</div>

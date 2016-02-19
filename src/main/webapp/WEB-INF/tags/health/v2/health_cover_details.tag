<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Private Health Cover details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="financialYearUtils" class="com.ctm.web.health.utils.FinancialYearUtils" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Financial year --%>
<c:set var="financialYearStart" value="${financialYearUtils.getFinancialYearStart()}" />
<c:set var="financialYearEnd" value="${financialYearUtils.getFinancialYearEnd()}" />

<%-- Calculate the year for continuous cover - changes on 1st July each year --%>
<c:set var="continuousCoverYear" value="${financialYearUtils.getContinuousCoverYear()}" />

<%-- Hidden fields --%>
<div class="healthDetailsHiddenFields">
	<field_v1:hidden xpath="${xpath}/primary/healthCoverLoading" noId="true" />
	<field_v1:hidden xpath="${xpath}/primary/lhc" noId="true" />
	<field_v1:hidden xpath="${xpath}/partner/dob" noId="true" />
	<field_v1:hidden xpath="${xpath}/partner/cover" noId="true" />
	<field_v1:hidden xpath="${xpath}/partner/healthCoverLoading" noId="true" />
	<field_v1:hidden xpath="${xpath}/partner/lhc" noId="true" />
	<field_v1:hidden xpath="${xpath}/dependants" noId="true" />
	<field_v1:hidden xpath="${xpath}/incomeBasedOn" noId="true" />
	<field_v1:hidden xpath="${xpath}/income" noId="true" />
	<field_v1:hidden xpath="${xpath}/rebate" noId="true" />
	<field_v1:hidden xpath="${xpath}/incomelabel" noId="true" />
</div>

<%-- COVER DETAILS TEMPLATE --%>
<script id="health-cover-details-template" type="text/html">

	<form id="${name}-selection" class="health-cover_details">

		<h1>Re-calculating your premium</h1>
		<p>Before we can continue with your application, we need to confirm some details that may affect your premium.</p>

		<form_v2:fieldset legend="Lifetime Health Cover (LHC) Loading" className="lhc-group">

			<p>The Federal Government may apply a LHC loading to your premium if you have not held continuous private hospital cover since turning 31. <span class="lhc-question">Please answer the questions below to work out if LHC applies to you.</span> <a href="http://www.privatehealth.gov.au/healthinsurance/incentivessurcharges/lifetimehealthcover.htm" target="_blank">Find out more</a></p>

			<c:set var="fieldXpath" value="${xpath}/primary/healthCoverLoading" />
			<form_v2:row label="Have you had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following your 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-primary" className="health-your_details-opt-group" helpId="239">
				<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your health cover loading" required="true" id="${name}_health_cover_loading" className="loading"/>
			</form_v2:row>

			<c:if test="${callCentre}">
				<c:set var="fieldXpath" value="${xpath}/primary/lhc" />
				<form_v2:row label="Applicant's LHC" fieldXpath="${fieldXpath}" helpId="287">
					<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Applicant's LHC" required="false" id="${name}_primary_lhc" maxLength="2" className="primary-lhc"/>
				</form_v2:row>
			</c:if>

			<div id="partner-health-cover">
				<c:set var="fieldXpath" value="${xpath}/partner/dob" />
				<form_v2:row label="Your partner's date of birth" fieldXpath="${fieldXpath}">
					<field_v2:person_dob xpath="${fieldXpath}" title="partner's" required="true" ageMin="16" ageMax="120" />
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/partner/cover" />
				<form_v2:row label="Does your partner currently hold private health insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" id="${name}_partner_health_cover"/>
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/partner/healthCoverLoading" />
				<form_v2:row label="Has your partner had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following their 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-partner" className="health-your_details-opt-group" helpId="239">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading"/>
				</form_v2:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/partner/lhc" />
					<form_v2:row label="Partner's LHC" fieldXpath="${fieldXpath}">
						<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
					</form_v2:row>
				</c:if>
			</div>
		</form_v2:fieldset>
		<simples:dialogue id="26" vertical="health" mandatory="true" />


		<form_v2:fieldset legend="Australian Government Rebate" className="rebate-group">
			<p>Please answer the questions below to determine if you are eligible to receive a Federal Government rebate to reduce the cost of your policy. <a href="http://www.privatehealth.gov.au/healthinsurance/incentivessurcharges/insurancerebate.htm" target="_blank">Find out more</a></p>

			<c:set var="fieldXpath" value="${xpath}/dependants" />
			<form_v2:row label="How many dependent children do you have?" fieldXpath="${fieldXpath}" helpId="241" className="health_cover_details_dependants">
				<field_v2:count_select xpath="${fieldXpath}" max="12" min="1" title="number of dependants" required="true"  className="${name}_health_cover_dependants dependants"/>
			</form_v2:row>

			<c:if test="${callCentre}">
				<c:set var="fieldXpath" value="${xpath}/incomeBasedOn" />
				<form_v2:row label="I wish to calculate my rebate based on" fieldXpath="${fieldXpath}" helpId="288" className="health_cover_details_incomeBasedOn" id="${name}_incomeBase">
					<field_v2:array_radio items="S=Single income,H=Household income" style="group" xpath="${fieldXpath}" title="income based on" required="true"  />
				</form_v2:row>
			</c:if>

			<c:set var="fieldXpath" value="${xpath}/income" />
			<form_v2:row label="What is the estimated taxable income for your household for the financial year 1st July ${financialYearStart} to 30 June ${financialYearEnd}?" fieldXpath="${fieldXpath}" id="${name}_tier">
				<field_v2:array_select xpath="${fieldXpath}" title="your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_cover_details_income"/>
				<span class="fieldrow_legend" id="${name}_incomeMessage"></span>
			</form_v2:row>

			<c:set var="fieldXpath" value="${xpath}/rebate" />
			<form_v2:row label="Would you like to receive the rebate as?" fieldXpath="${fieldXpath}" helpId="240" className="health_cover_details_rebate">
				<field_v2:array_radio items="Y=Discount on premium,N=Part of tax refund" style="group" xpath="${fieldXpath}" title="your private health cover rebate" required="true" id="${name}_health_cover_rebate" className="rebate btn-group-wrap"/>
			</form_v2:row>

		</form_v2:fieldset>
		<simples:dialogue id="37" vertical="health" mandatory="true" className="hidden" />
	</form>

</script>

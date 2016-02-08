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

<form_v2:fieldset_columns sideHidden="true">
	<jsp:attribute name="rightColumn">

	</jsp:attribute>
	<jsp:body>
		<form_v2:fieldset legend="Your Details" className="primary">
			<c:set var="fieldXpath" value="${xpath}/primary/dob" />
			<form_v2:row label="Your date of birth" fieldXpath="${fieldXpath}" className="health-your_details-dob-group">
				<field_v2:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
			</form_v2:row>

			<c:set var="fieldXpath" value="${xpath}/primary/cover" />
			<form_v2:row label="Do you currently hold private health insurance?" fieldXpath="${fieldXpath}" id="${name}_primaryCover">
				<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_health_cover"/>
			</form_v2:row>

			<c:set var="fieldXpath" value="${xpath}/primary/healthCoverLoading" />
			<form_v3:row label="Have you had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following your 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-primary" className="health-your_details-opt-group" helpId="239">
				<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your health cover loading" required="true" id="${name}_health_cover_loading" className="loading"/>
			</form_v3:row>

			<c:if test="${callCentre}">
				<c:set var="fieldXpath" value="${xpath}/primary/lhc" />
				<form_v2:row label="Applicant's LHC" fieldXpath="${fieldXpath}" helpId="287">
					<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Applicant's LHC" required="false" id="${name}_primary_lhc" maxLength="2" className="primary-lhc"/>
				</form_v2:row>
			</c:if>
		</form_v2:fieldset>

		<form_v2:fieldset id="partner-health-cover" legend="Your Partner's Details" className="partner">
			<c:set var="fieldXpath" value="${xpath}/partner/dob" />
			<form_v3:row label="Your partner's date of birth" fieldXpath="${fieldXpath}">
				<field_v2:person_dob xpath="${fieldXpath}" title="partner's" required="true" ageMin="16" ageMax="120" />
			</form_v3:row>

			<c:set var="fieldXpath" value="${xpath}/partner/cover" />
			<form_v3:row label="Does your partner currently hold private health insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover">
				<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_partner_health_cover"/>
			</form_v3:row>

			<c:set var="fieldXpath" value="${xpath}/partner/healthCoverLoading" />
			<form_v3:row label="Has your partner had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following their 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-partner" className="health-your_details-opt-group" helpId="239">
				<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading"/>
			</form_v3:row>

			<c:if test="${callCentre}">
				<c:set var="fieldXpath" value="${xpath}/partner/lhc" />
				<form_v2:row label="Partner's LHC" fieldXpath="${fieldXpath}">
					<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
				</form_v2:row>
			</c:if>
		</form_v2:fieldset>
		<simples:dialogue id="26" vertical="health" mandatory="true" />
		<form_v2:fieldset legend="Rebate">
			<c:set var="fieldXpath" value="${xpath}/dependants" />
			<form_v3:row label="How many dependent children do you have?" fieldXpath="${fieldXpath}" helpId="241" className="health_cover_details_dependants">
				<field_v2:count_select xpath="${fieldXpath}" max="12" min="1" title="number of dependants" required="true"  className="${name}_health_cover_dependants dependants"/>
			</form_v3:row>

			<c:if test="${callCentre}">
				<c:set var="fieldXpath" value="${xpath}/incomeBasedOn" />
				<form_v2:row label="I wish to calculate my rebate based on" fieldXpath="${fieldXpath}" helpId="288" className="health_cover_details_incomeBasedOn" id="${name}_incomeBase">
					<field_v2:array_radio items="S=Single income,H=Household income" style="group" xpath="${fieldXpath}" title="income based on" required="true"  />
				</form_v2:row>
			</c:if>

			<c:set var="fieldXpath" value="${xpath}/income" />
			<form_v3:row label="What is the estimated taxable income for your household for the financial year 1st July ${financialYearStart} to 30 June ${financialYearEnd}?" fieldXpath="${fieldXpath}" id="${name}_tier">
				<field_v2:array_select xpath="${fieldXpath}" title="your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_cover_details_income"/>
				<span class="fieldrow_legend" id="${name}_incomeMessage"></span>
				<c:set var="income_label_xpath" value="${xpath}/incomelabel" />
				<input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />
			</form_v3:row>

			<c:set var="fieldXpath" value="${xpath}/rebate" />
			<form_v3:row label="Would you like to receive the rebate as?" fieldXpath="${fieldXpath}" helpId="240" className="health_cover_details_rebate">
				<field_v2:array_radio items="Y=Discount on premium,N=Part of tax refund" style="group" xpath="${fieldXpath}" title="your private health cover rebate" required="true" id="${name}_health_cover_rebate" className="rebate"/>
			</form_v3:row>

			<%-- Override set in splittest_helper tag --%>
			<c:if test="${showOptInOnSlide3 eq false}">
				<c:set var="termsAndConditions">
					<%-- PLEASE NOTE THAT THE MENTION OF COMPARE THE MARKET IN THE TEXT BELOW IS ON PURPOSE --%>
					I understand <content:optin key="brandDisplayName" useSpan="true"/> compares health insurance policies from a range of
					<a href='<content:get key="participatingSuppliersLink"/>' target='_blank'>participating suppliers</a>.
					By providing my contact details I agree that <content:optin useSpan="true" content="comparethemarket.com.au"/> may contact me, during the Call Centre <a href="javascript:;" data-toggle="dialog" data-content="#view_all_hours" data-dialog-hash-id="view_all_hours" data-title="Call Centre Hours" data-cache="true">opening hours</a>, about the services they provide.
					I confirm that I have read the <form_v1:link_privacy_statement />.
				</c:set>

				<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
				<form_v3:row className="health-contact-details-optin-group" hideHelpIconCol="true">
					<field_v2:checkbox
							xpath="${pageSettings.getVerticalCode()}/contactDetails/optin"
							value="Y"
							className="validate"
							required="true"
							label="${true}"
							title="${termsAndConditions}"
							errorMsg="Please agree to the Terms &amp; Conditions" />
				</form_v3:row>
			</c:if>

		</form_v2:fieldset>
		<simples:dialogue id="37" vertical="health" mandatory="true" className="hidden" />
	</jsp:body>
</form_v2:fieldset_columns>
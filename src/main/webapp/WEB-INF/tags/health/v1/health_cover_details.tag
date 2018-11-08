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

<%-- HTML --%>


<div id="${name}-selection" class="health-cover_details">

	<form_v2:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<ui:bubble variant="help">
				<h4>Lifetime Health Cover Loading</h4>
				<p>The Government may charge a levy known as the <strong>Lifetime Health Cover</strong> (LHC) loading.</p>
				<p>The levy is based on a number of factors including your age and the number of years you have held private health cover.</p>
				<p>By filling in these details, we can work out what your LHC loading will be when you are comparing health insurance quotes.</p>
				<p>This is confirmed by your previous health fund if required.</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>
			<form_v2:fieldset legend="Your Details" className="primary">
				<c:set var="fieldXpath" value="${xpath}/primary/dob" />
				<form_v2:row label="Your date of birth" fieldXpath="${fieldXpath}" className="health-your_details-dob-group">
					<field_v2:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
				</form_v2:row>

				<%--
				Please note the purpose of this question is to capture if the user currently has any form of private health cover ('Y' == (Private Hospital || Extras Only), 'N'= (None))
				this is done for marketing purposes and so that the information can be passed on to the new provider.

				unfortunatly this field is mislabeled and does not map to the field with the same label in the v4 journey
				--%>
				<c:set var="fieldXpath" value="${xpath}/primary/cover" />
				<form_v2:row label="Do you currently hold private health insurance?" fieldXpath="${fieldXpath}" id="${name}_primaryCover">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_health_cover"/>
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/primary/healthCoverLoading" />
				<form_v2:row label="Have you had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following your 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-primary" className="health-your_details-opt-group" helpId="239">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your health cover loading" required="true" id="${name}_health_cover_loading" className="loading"/>
				</form_v2:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/primary/lhc" />
					<form_v2:row label="Applicant's LHC" fieldXpath="${fieldXpath}" helpId="287" id="primaryLHCRow">
						<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Applicant's LHC" required="false" id="${name}_primary_lhc" maxLength="2" className="primary-lhc"/>
					</form_v2:row>
				</c:if>
			</form_v2:fieldset>

			<form_v2:fieldset id="partner-health-cover" legend="Your Partner's Details" className="partner">
				<c:set var="fieldXpath" value="${xpath}/partner/dob" />
				<form_v2:row label="Your partner's date of birth" fieldXpath="${fieldXpath}" id="${name}_partner_dob">
					<field_v2:person_dob xpath="${fieldXpath}" title="partner's" required="true" ageMin="16" ageMax="120" />
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/partner/cover" />
				<form_v2:row label="Does your partner currently hold private health insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_partner_health_cover"/>
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/partner/healthCoverLoading" />
				<form_v2:row label="Has your partner had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following their 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-partner" className="health-your_details-opt-group" helpId="239">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading"/>
				</form_v2:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/partner/lhc" />
					<form_v2:row label="Partner's LHC" fieldXpath="${fieldXpath}" id="partnerLHCRow">
						<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
					</form_v2:row>
				</c:if>
			</form_v2:fieldset>
				<simples:dialogue id="26" vertical="health" mandatory="true" />
		</jsp:body>

	</form_v2:fieldset_columns>



	<form_v2:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<ui:bubble variant="help">
				<h4>The Australian Government Rebate</h4>
				<p><strong>The Australian Government</strong> offers rebates on private health insurance for those who meet a set criteria.</p>
				<p>The rebates offered depend on your household's taxable income, the number of dependants you have and your age.</p>
				<p>For more information on the Government Rebate please <a data-toggle="dialog" data-content="ajax/html/health_info_rebates.jsp" data-cache="true" data-dialog-hash-id="rebates" data-supertag-method="trackCustomPage" data-supertag-value="Rebates Info Dialog" href="ajax/html/health_info_rebates.jsp" target="_blank">click here</a>.</p>
			</ui:bubble>

			<ui:bubble variant="help">
				<h4>Medicare Levy Surcharge</h4>
				<p>The Medicare Levy Surcharge is a tax the Government charges people who earn over certain income thresholds and don't have private hospital cover.</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>
			<form_v2:fieldset legend="Rebate">
				<c:set var="fieldXpath" value="${xpath}/rebate" />
				<form_v2:row label="Do you want to reduce your premium by applying your rebate?" fieldXpath="${fieldXpath}" helpId="240" className="health_cover_details_rebate">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover rebate" required="true" id="${name}_health_cover_rebate" className="rebate"/>
				</form_v2:row>

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
					<c:set var="income_label_xpath" value="${xpath}/incomelabel" />
					<input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />
				</form_v2:row>

			</form_v2:fieldset>
				<simples:dialogue id="37" vertical="health" mandatory="true" />
			</jsp:body>

		</form_v2:fieldset_columns>

</div>

<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Private Health Cover details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="date" class="java.util.Date" />


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="month"><fmt:formatDate value="${date}" pattern="M" /></c:set>
<c:set var="year"><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<%-- Financial year --%>
<c:choose>
	<c:when test="${month < 7}">
		<c:set var="financialYearStart">${year - 1}</c:set>
		<c:set var="financialYearEnd">${year}</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="financialYearStart">${year}</c:set>
		<c:set var="financialYearEnd">${year + 1}</c:set>
	</c:otherwise>
</c:choose>

<%-- Calculate the year for continuous cover - changes on 1st July each year --%>
<c:set var="continuousCoverYear">
	<c:choose>
		<c:when test="${month < 7}">${year - 11}</c:when>
		<c:otherwise>${year - 10}</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>


<div id="${name}-selection" class="health-cover_details">

	<form_new:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<ui:bubble variant="help">
				<h4>Lifetime Hospital Cover Loading</h4>
				<p>The Government may charge a levy known as the <strong>Lifetime Health Cover</strong> (LHC) loading.</p>
				<p>The levy is based on a number of factors including your age and the number of years you have held private health cover.</p>
				<p>By filling in these details, we can work out what your LHC loading will be when you are comparing health insurance quotes.</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>
			<form_new:fieldset legend="Your Details" className="primary">
				<c:set var="fieldXpath" value="${xpath}/primary/dob" />
				<form_new:row label="Your date of birth" fieldXpath="${fieldXpath}" className="health-your_details-dob-group">
					<field_new:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
				</form_new:row>

				<c:set var="fieldXpath" value="${xpath}/primary/cover" />
				<form_new:row label="Do you currently hold private health insurance?" fieldXpath="${fieldXpath}" id="${name}_primaryCover">
					<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_health_cover"/>
				</form_new:row>

				<c:set var="fieldXpath" value="${xpath}/primary/healthCoverLoading" />
				<form_new:row label="Have you had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following your 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-primary" className="health-your_details-opt-group" helpId="239">
					<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your health cover loading" required="true" id="${name}_health_cover_loading" className="loading"/>
				</form_new:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/primary/lhc" />
					<form_new:row label="Applicant's LHC" fieldXpath="${fieldXpath}" helpId="287">
						<field:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Applicant's LHC" required="false" id="${name}_primary_lhc" maxLength="2" className="primary-lhc"/>
					</form_new:row>
				</c:if>
			</form_new:fieldset>

			<form_new:fieldset id="partner-health-cover" legend="Your Partner's Details" className="partner">
				<c:set var="fieldXpath" value="${xpath}/partner/dob" />
				<form_new:row label="Your partner's date of birth" fieldXpath="${fieldXpath}">
					<field_new:person_dob xpath="${fieldXpath}" title="partner's" required="true" ageMin="16" ageMax="120" />
				</form_new:row>

				<c:set var="fieldXpath" value="${xpath}/partner/cover" />
				<form_new:row label="Does your partner currently hold private health insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover">
					<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_partner_health_cover"/>
				</form_new:row>

				<c:set var="fieldXpath" value="${xpath}/partner/healthCoverLoading" />
				<form_new:row label="Has your partner had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following their 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-partner" className="health-your_details-opt-group" helpId="239">
					<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading"/>
				</form_new:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/partner/lhc" />
					<form_new:row label="Partner's LHC" fieldXpath="${fieldXpath}">
						<field:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
					</form_new:row>
				</c:if>
			</form_new:fieldset>
		</jsp:body>

	</form_new:fieldset_columns>



	<form_new:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<ui:bubble variant="help">
				<h4>The Australian Government Rebate</h4>
				<p><strong>The Australian Government</strong> offers rebates on private health insurance for those who meet a set criteria.</p>
				<p>The rebates offered depend on your household's taxable income, the number of dependants you have and your age.</p>
				<p>For more information on the Government Rebate please <a data-toggle="dialog" data-content="ajax/html/health_info_rebates.jsp" data-cache="true" data-dialog-hash-id="rebates" data-supertag-method="trackCustomPage" data-supertag-value="Rebates Info Dialog" href="ajax/html/health_info_rebates.jsp" target="_blank">click here</a>.</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>
			<form_new:fieldset legend="Rebate">
				<c:set var="fieldXpath" value="${xpath}/rebate" />
				<form_new:row label="Do you want to reduce your premium by applying your rebate?" fieldXpath="${fieldXpath}" helpId="240" className="health_cover_details_rebate">
					<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover rebate" required="true" id="${name}_health_cover_rebate" className="rebate"/>
				</form_new:row>

				<c:set var="fieldXpath" value="${xpath}/dependants" />
				<form_new:row label="How many dependent children do you have?" fieldXpath="${fieldXpath}" helpId="241" className="health_cover_details_dependants">
					<field_new:count_select xpath="${fieldXpath}" max="12" min="1" title="number of dependants" required="true"  className="${name}_health_cover_dependants dependants"/>
				</form_new:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/incomeBasedOn" />
					<form_new:row label="I wish to calculate my rebate based on" fieldXpath="${fieldXpath}" helpId="288" className="health_cover_details_incomeBasedOn" id="${name}_incomeBase">
						<field_new:array_radio items="S=Single income,H=Household income" style="group" xpath="${fieldXpath}" title="income based on" required="true"  />
					</form_new:row>
				</c:if>

				<c:set var="fieldXpath" value="${xpath}/income" />
				<form_new:row label="What is the estimated taxable income for your household for the financial year 1st July ${financialYearStart} to 30 June ${financialYearEnd}?" fieldXpath="${fieldXpath}" id="${name}_tier">
					<field_new:array_select xpath="${fieldXpath}" title="your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_cover_details_income"/>
					<span class="fieldrow_legend" id="${name}_incomeMessage"></span>
					<c:set var="income_label_xpath" value="${xpath}/incomelabel" />
					<input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />
				</form_new:row>

			</form_new:fieldset>
		</jsp:body>

	</form_new:fieldset_columns>



	<%-- The rebates calculator --%>
	<c:if test="${not empty callCentre}">
		<form_new:fieldset_columns sideHidden="true">

			<jsp:attribute name="rightColumn">
			</jsp:attribute>

			<jsp:body>
				<simples:dialogue id="26" vertical="health" mandatory="true" />
			</jsp:body>

		</form_new:fieldset_columns>
	</c:if>

</div>

<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Grouping together of dependantren"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="financialYearUtils" class="com.ctm.web.health.utils.FinancialYearUtils" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- Financial year --%>
<c:set var="financialYearStart" value="${financialYearUtils.getFinancialYearStart()}" />
<c:set var="financialYearEnd" value="${financialYearUtils.getFinancialYearEnd()}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-dependants">

    <form_v4:fieldset legend="Your Dependants' Details" >

        <%-- the funds's dependants details definition dynamically inserted here - currently defined in the fund specific healthFunds_ file --%>
        <p class="definition"></p>

        <div id="${name}_threshold" class="text-danger">

            <p>
                You have not added any dependants but have selected a cover type that requires them.
            </p>
            <p>
                If you do not wish to add any dependants, you can search for suitable policies by <a href="javascript:;" data-slide-control="start">changing your cover type</a>.
            </p>
            <p>
                <strong>If you wish to continue, please add your dependants now.</strong>
            </p>

            <field_v1:hidden required="true" validationRule="validateMinDependants" validationParam="{'prefix':'${name}'}" validationMessage="A dependant is required." defaultValue="" xpath="${xpath}/dependantrequired" />
        </div>

        <health_v4_application:dependant_details_template xpath="${xpath}/dependant" />

        <form_v4:row id="dependents_list_options">
            <a href="javascript:void(0);" class="add-new-dependent btn btn-form" title="Add new dependant">Add New Dependant</a>
        </form_v4:row>

        <%-- If the user changes the amount of dependants here, we will need to re-confirm their selection --%>
        <div class="health-dependants-tier" style="display:none">

            <form_v4:row>
                <h5>When completed, confirm your new income tier</h5>
            </form_v4:row>

            <c:set var="fieldXpath" value="${xpath}/income" />
            <form_v4:row fieldXpath="${fieldXpath}" label="What is the estimated taxable income for your household for the financial year 1st July ${financialYearStart} to 30 June ${financialYearEnd}?" id="${name}_tier">
                <field_v2:array_radio xpath="${fieldXpath}"  title="Please enter your household income" required="true" items="0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" style="radio-as-checkbox" wrapCopyInSpan="true" outerWrapperClassName="col-xs-12 col-sm-6" className="income health_dependants_details_income radio-as-checkbox"/>
                <span class="fieldrow_legend" id="${name}_incomeMessage"></span>
            </form_v4:row>
        </div>

    </form_v4:fieldset>

</div>
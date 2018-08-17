<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Checkbox to apply the rebate to lower the premium"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/rebate" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate application" quoteChar="\"" /></c:set>
<form_v4:row label="Apply the Australian Government Rebate to lower my upfront premium?" fieldXpath="${fieldXpath}" id="${name}_rebate_field_row" helpId="240" className="lhcRebateCalcTrigger hidden">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="validate" id="${name}_rebate" additionalLabelAttributes="${analyticsAttr}" additionalAttributes=" data-attach='true'"/>
</form_v4:row>

<c:set var="fieldXpath" value="${xpath}/dependants" />
<form_v2:row label="How many dependents do you have?" id="${name}_dependants_field_row" className="lhcRebateCalcTrigger">
	<field_v2:count_select xpath="${fieldXpath}" max="12" min="1" placeHolder="Please choose..." title="number of dependants" required="true" className="${name}_health_cover_dependants dependants" />
</form_v2:row>

<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate income level" quoteChar="\"" /></c:set>
<c:set var="fieldXpath" value="${xpath}/income" />

<form_v4:row label="<span data-situation='single'>What is your taxable income?</span><span class='hidden' data-situation='hasPartner'>What is your, and your partners combined taxable income?</span><br /><span class='label-sub-text'>We need this figure to calculate your health insurance rebate.</span>" id="${name}_income_field_row" className="lhcRebateCalcTrigger" smRowOverride="6">
	<field_v2:array_radio xpath="${fieldXpath}" title="your household income" required="true" items="0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" style="radio-as-checkbox" wrapCopyInSpan="true" outerWrapperClassName="col-xs-12 col-sm-6" className="income health_cover_details_income radio-as-checkbox" additionalAttributes="${analyticsAttr} data-attach=true" />
	<c:set var="income_label_xpath" value="${xpath}/incomelabel" />
	<div id="rebateLabel"><span></span></div>
	<div class="fieldrow_legend" id="health_healthCover_tier_row_legend">Depending on your taxable income, you may be eligible for a government discount on your premium.</div>
</form_v4:row>

<input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />
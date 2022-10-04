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
<form_v2:row hideRowBorder="true" label="How many dependants do you have?" id="${name}_dependants_field_row" className="lhcRebateCalcTrigger healthCover_dependants_field_row">
	<field_v2:count_select xpath="${fieldXpath}" max="12" min="1" placeHolder="Please choose..." title="number of dependants" required="true" className="${name}_health_cover_dependants dependants" />
</form_v2:row>

<c:set var="fieldXpath" value="${xpath}/adultDependants" />
<form_v4:row hideRowBorder="true" label="Are any dependants aged 21 or older and not studying full time?" fieldXpath="${fieldXpath}" id="${name}_dependants_adult_row" className="healthCover_dependants_field_row">
	<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="Adult Dependant" required="true" className="${name}_dependants_adult" id="${name}_dependants_adult"/>
</form_v4:row>

<div class="form-group row fieldrow clear healthCover_dependants_field_row">
	<div class="col-sm-12 col-xs-12 row-content">
		<div class="adult-depedendants-support-container hidden" id="adult-depedendants-support-container" >
			<div class="adult-depedendants-support-content" id="adult-depedendants-support-content">
				<div class="adult-depedendants-support-text" id="adult-depedendants-support-text">
					<span class="adult-dependants-header"><img class="adult-dependants-lightbulb"  src="brand/ctm/images/icons/lightbulb.svg" /><strong>Adult dependant</strong></span>
					<p id="adult-depedendants-support-p" class="adult-depedendants-support-p"><span class="adult-dependants-descr">Eligible dependents from age 21 to 31 can be included on your family cover. However, rules do vary from fund to fund. Depending on your circumstances, this will come at little to no additional cost. Our health insurance experts can help you find the right cover for your family. </span><span class="adult-dependants-call">If you need a hand, give us a call on <a href="tel:1800 777 712"><strong><u>1800 777 712</u></strong></a></span></p>
				</div>
				<div id="adult-dependants-support-img" class="adult-dependants-support-img">
					<img src="brand/ctm/images/sergei_excited_final_render.svg"/>
				</div>
			</div>
		</div>
	</div>
</div>
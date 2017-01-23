<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Checkbox to apply the rebate to lower the premium"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate application" quoteChar="\"" /></c:set>
<div class="form-group fieldrow">
	<div class="col-xs-12">
		<field_v2:checkbox
				xpath="${xpath}/rebateCheckbox"
				value="Y"
				className="validate"
				required="false"
				label="${true}"
				title="Apply the Australian Government Rebate to lower my upfront premium <a href='javscript:;' data-content='helpid:240' data-toggle='popover'>more info</a>"
				additionalLabelAttributes="${analyticsAttr} data-ignore='true'"
		/>

		<field_v1:hidden xpath="${xpath}/rebate" defaultValue="N" />
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate income level" quoteChar="\"" /></c:set>
		<div class="income_container hidden">
			<div class="rebate-label" id="rebateLabel">
				<span></span> <a href="javascript:;" class="editTier">EDIT</a>
			</div>
			<div class="selectedRebate" id="selectedRebateText"></div>

			<c:set var="fieldXpath" value="${xpath}/dependants" />
			<field_v2:count_select xpath="${fieldXpath}" max="12" min="1" placeHolder="Please choose the number of dependents" title="number of dependants" required="true" hideElement="${true}" className="${name}_health_cover_dependants dependants" defaultValue="2" />

			<c:set var="fieldXpath" value="${xpath}/income" />
			<field_v2:array_select xpath="${fieldXpath}" title="your household income" required="true" items="=Please choose your household income||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" hideElement="${true}" className="income health_cover_details_income" extraDataAttributes="${analyticsAttr} data-attach=true" />
			<c:set var="income_label_xpath" value="${xpath}/incomelabel" />
			<div class="fieldrow_legend" id="health_healthCover_tier_row_legend"></div>
			<input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />
		</div>
	</div>
</div>
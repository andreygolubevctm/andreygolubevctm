<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filters group" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<%--
	This tag has corresponding module: framework/modules/js/vertical/verticalFilters.js

	INSTRUCTIONS:
		- Each filter needs a filter wrapper
		- The wrapper needs an attribute 'data-filter-type' so the module knows how to read the filter's value e.g. 'radio' for a radio group
		- The wrapper needs an ID so values can be restored on a Cancel.

	EXAMPLE:
		<div id="myFilter" data-filter-type="select">
			<select>...</select>
		</div>
--%>
<div class="dropdown-container" id="filters-container"></div>
<core:js_template id="filters-template">
	<form class="filters-component">
		<div class="scrollable filters clearfix">
			<div class="heading col-sm-12">
				<h5>Filter your results by choosing from the following:</h5>
			</div>

			<%-- Loan Details --%>
			<div class="col-md-6 filter">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Loan Amount</label></div>
					</div>
					<div id="filter-loan-amount" data-filter-type="text" data-filter-serverside="true" class="col-sm-3">
						<field_new:currency xpath="${xpath}/filter/loanDetails/loanAmount" title="Loan Amount" decimal="${false}" required="false"  pattern="[0-9]*" />
					</div>

					<div class="filter-label col-sm-2">
						<div><label>Loan Term</label></div>
					</div>
					<div id="filter-loan-term" data-filter-type="select" data-filter-serverside="true" class="col-sm-4">
						<field_new:array_select xpath="${xpath}/filter/results/loanTerm" title="Loan Term" items="30=30 years,25=25 years,20=20 years,15=15 years,10=10 years,5=5 years" required="false" />
					</div>
				</div>
			</div>


			<%-- Interest Rate Type --%>
			<div class="col-md-6 filter">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Interest Rate Type</label></div>
					</div>
					<div id="filter-interest-rate-type" data-filter-type="radio" data-filter-serverside="true" class="col-sm-9">
					<field_new:array_radio xpath="${xpath}/filter/loanDetails/interestRate" required="true" items="P=Principal & Interest,I=Interest Only" title="${title} the interest payment type" />
					</div>
				</div>
			</div>
			<div style="clear:both;"></div>
			<%-- Repayment Frequency --%>
			<div class="col-md-6 filter">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Repayment Options*</label></div>
					</div>
					<div id="filter-repaymentFrequency" data-filter-type="radio" data-filter-serverside="true" class="col-sm-9">
						<field_new:array_radio xpath="${xpath}/filter/results/repaymentFrequency" title="Repayments" items="weekly=Weekly,fortnightly=Fortnightly,monthly=Monthly" required="false" />
					</div>
				</div>
			</div>

			<%-- Fees --%>
			<div class="col-md-6 filter">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Fees</label></div>
					</div>
					<div id="filter-fees" data-filter-type="checkbox" data-filter-serverside="true" class="col-sm-9 col-md-8">
						<homeloan:filter_fees />
					</div>
				</div>
			</div>

			<%-- Loan Type --%>
			<div class="col-md-6 filter">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Loan Type</label></div>
					</div>
					<div id="filter-loan-type" data-filter-type="checkbox" data-filter-serverside="true" class="col-sm-9">
						<homeloan:filter_loan_type />
					</div>
				</div>
			</div>

			<%-- Features --%>
			<div class="col-md-6 filter disclaimer-negative-margin">
				<div class="row">
					<div class="filter-label col-sm-3">
						<div><label>Features</label></div>
					</div>
					<div id="filter-features" data-filter-type="checkbox" data-filter-serverside="true" class="col-sm-9 col-md-8">
						<homeloan:filter_features />
					</div>
				</div>
			</div>
		<%-- TO BE REMOVED ONCE SERVICE RETURNS PROPER REPAYMENT AMOUNTS. --%>
		<div class="col-xs-12 col-md-6">

		</div>
		</div><%-- /scrollable --%>

		<div class="footer row">
			<div class="col-xs-12 col-sm-8">
				<p class="small">* <content:get key="repaymentFrequencyDisclaimer"/></p>
			</div>
			<div class="col-xs-4">
				<button type="button" class="btn btn-cancel popover-mode">Cancel</button>
				<button type="button" class="btn btn-save popover-mode">Save changes</button>
			</div>
		</div>

	</form>
</core:js_template>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Homeloan Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core:js_template id="snapshot-template">
	{{ var template = $("#provider-logo-template").html(); }}
	{{ var companyLogo = _.template(template); }}
	{{ companyLogo = companyLogo(obj); }}

	{{ var template = $("#monthly-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var monthlyPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#interest-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var interestTemplate = htmlTemplate(obj); }}

	{{ var template = $("#interest-comparison-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var interestComparisonTemplate = htmlTemplate(obj); }}

	<div>
	<form_new:fieldset legend="Your Home Loan Product">
		<%-- Header --%>
		<div class="row snapshot-product-header">
			<div class="col-sm-5 col-md-4 col=lg-3 logoContainer">{{= companyLogo}}</div>
			<div class="col-xs-7 col-md-8 col=lg-9"><h4>{{= obj.lender}}</h4>{{= obj.name}}
			</div>
		</div>
		<%-- Benefits --%>
		<div class="row priceMode">
			<div class="col-xs-12">
			{{= monthlyPriceTemplate }}
			</div>
			<div class="col-sm-6 col-xs-12">
				{{= interestTemplate }}
			</div>
			<div class="col-sm-6 col-xs-12">
				{{= interestComparisonTemplate }}
			</div>
			<div class="col-sm-6 col-xs-12 snapshot-rates">

				<h5>Fees</h5>
				{{ if(typeof obj.formatted.appFees !== 'undefined') { }}
				Application fee &nbsp;
				{{=obj.formatted.appFees}}<br>
				{{ } }}
				{{ if(typeof obj.formatted.ongoingFees !== 'undefined') { }}
				Ongoing fee &nbsp;
				{{=obj.formatted.ongoingFees}}<br>
				{{ } }}
				{{ if(typeof obj.formatted.settlFees !== 'undefined') { }}
				Settlement fee &nbsp;
				{{=obj.formatted.settlFees}}<br>
				{{ } }}
<h5>Features</h5>
				{{ if(typeof obj.bpay !== 'undefined') { }}
				{{ if(obj.bpay === 'Y') { }}
				BPay available<br>
				{{ } }}
				{{ } }}
				{{ if(typeof obj.internet !== 'undefined') { }}
				{{ if(obj.internet === 'Y') { }}
				Internet banking<br>
				{{ } }}
				{{ } }}
				{{ if(typeof obj.redraw !== 'undefined') { }}
				{{ if(obj.redraw === 'Y') { }}
				Redraw facility available<br>
				{{ } }}
				{{ } }}
				{{ if(typeof obj.offset !== 'undefined') { }}
				{{ if(obj.offset === 'Y') { }}
				Offset account available<br>
				{{ } }}
				{{ } }}
				{{ if(typeof obj.extra !== 'undefined') { }}
				{{ if(obj.extra === 'Y') { }}
				Extra repayments allowed<br>
				{{ } }}
				{{ } }}
				{{ if(typeof obj.constrct !== 'undefined') { }}
				{{ if(obj.constrct === 'Y') { }}
				Construction loan available<br>
				{{ } }}
				{{ } }}
				{{ if(typeof obj.split !== 'undefined') { }}
				{{ if(obj.split === 'Y') { }}
				Split loan available<br>
				{{ } }}
				{{ } }}
			</div>
			<div class="col-sm-6 col-xs-12 snapshot-frequency">
				<h5>Payment Frequency</h5>
				{{ if(typeof obj.monthly !== 'undefined') { }}
				{{ if(obj.monthly === 'Y') { }}
				Monthly<br>
				{{ } }}
				{{ } }}
				{{ if(typeof obj.fortni !== 'undefined') { }}
				{{ if(obj.fortni === 'Y') { }}
				Fortnightly<br>
				{{ } }}
				{{ } }}
				{{ if(typeof obj.weekly !== 'undefined') { }}
				{{ if(obj.weekly === 'Y') { }}
				Weekly<br>
				{{ } }}
				{{ } }}
			</div>
		</div>
		</form_new:fieldset>
	</div>
	<div class="comparison-rate-disclaimer">
		<h6 class="small">Comparison rate disclaimer</h6>
		<p class="small">*Comparison rates shown are based on the home loan details you have entered which include loan amount and term of loan or on a secured loan of $150,000 over the term of 25 years for advertisements. WARNING: This comparison rate is true only for the examples given and may not include all fees and charges. Different terms, fees or other loan amounts might result in a different comparison rate.</p>
	</div>
</core:js_template>


<form_new:fieldset legend="Snapshot of Your Details" className="quoteSnapshot">
	<div class="row snapshot">
		<div class="col-sm-12 snapshot-title">
			<span data-source="#homeloan_enquiry_contact_firstName" data-alternate-source="#homeloan_contact_firstName" ></span>
			<span data-source="#homeloan_enquiry_contact_lastName" data-alternate-source="#homeloan_contact_lastName"></span>
		</div>
		<div class="col-sm-12">
			<p data-source="#homeloan_details_location"></p>
		</div>
		<div class="col-sm-12">
			<p class="snapshotGoal"></p>
		</div>
	</div>
</form_new:fieldset>
<div class="product-snapshot"></div>
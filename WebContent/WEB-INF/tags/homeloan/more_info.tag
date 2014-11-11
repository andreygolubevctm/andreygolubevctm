<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<core:js_template id="more-info-template">

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


	<div class="displayNone more-info-content">
		<%-- Header --%>
		<div class="row headerBar">
			<div class="col-xs-12">
				<div class="col-xs-4 col-sm-2 logoContainer">{{= companyLogo}}</div>
				<div class="col-xs-8 col-sm-10"><h2>{{= obj.lender}}</h2>{{= obj.name}}</div>
			</div>
		</div>

		<div class="row">
			<div class="col-sm-4 col-xs-12 pull-right priceMode">
				<div class="col-xs-6 col-sm-12">
					{{= monthlyPriceTemplate }}
				</div>
				<div class="col-xs-6 col-sm-12">
					{{= interestTemplate }}
				</div>
				<div class="col-xs-6 col-sm-12">
					{{= interestComparisonTemplate }}
				</div>
				<div class="col-xs-12">
					<a href="javascript:;" class="btn btn-cta btn-block btn-apply" data-productid="{{= obj.id }}">Enquire Now</a>
				</div>
			</div>

			<div class="col-sm-4 col-xs-6">
				<h5>Rates</h5>
				{{ if(typeof obj.formatted.intrRate !== 'undefined') { }}
				Interest rate &nbsp;
				{{=obj.formatted.intrRate}}<br>
				{{ } }}
				{{ if(typeof obj.formatted.comparRate !== 'undefined') { }}
				Comparison rate* &nbsp;
				{{=obj.formatted.comparRate}}<br>
				{{ } }}

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
			<div class="col-sm-4 col-xs-6">
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
		</div>
		<div class="row"><div class="col-md-12 disclaimer"><small>*Comparison rates shown are based on the home loan details you have entered which include loan amount and term of loan or on a secured loan of $150,000 over the term of 25 years for advertisements. WARNING: This comparison rate is true only for the examples given and may not include all fees and charges. Different terms, fees or other loan amounts might result in a different comparison rate.
</small></div></div>
	</div>
</core:js_template>


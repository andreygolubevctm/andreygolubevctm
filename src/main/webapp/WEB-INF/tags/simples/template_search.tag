<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-search" type="text/html">

<div class="simples-search-modal">
	<div id="simples-search-modal-header" class="row">
		<div class="col-xs-4">
			<h2>Search quotes</h2>
		</div>
		<div class="col-xs-8 text-right">
			<form class="simples-search form-inline" role="search">
				<div class="form-group">
					<input type="text" name="keywords" class="form-control input-sm" value="{{= obj.keywords }}">
				</div>
				<button type="submit" class="btn btn-default btn-sm">Search</button>
			</form>
		</div>
	</div>

	<div class="search-quotes">
		<%-- Header. These col sizes should match the results below. --%>
		<%--
		<div class="search-quotes-header row bg-success">
			<div class="col-xs-2">Brand</div>
			<div class="col-xs-2">Date/time</div>
			<div class="col-xs-6">Details</div>
			<div class="col-xs-2">Options</div>
		</div>
		--%>

		<%-- Results --%>
		<div class="search-quotes-results">
			{{ if (typeof errorMessage !== 'undefined' && errorMessage.length > 0) { }}
				<div class="alert alert-danger">{{= errorMessage }}</div>
			{{ } }}

			<%-- If results is a straight string, output it as-is --%>
			{{ if (typeof results === 'string') { }}
				{{= results }}
			{{ } else if (_.isArray(results)) { }}

				{{ _.each(results, function(result, index) { }}
					<div class="search-quotes-result-row row"
							data-vertical="{{= result.quoteType }}"
							data-brandid="{{= result.quoteBrandId }}"
							data-id="{{= result.id }}"
							data-index="{{= index }}"
							data-editable="{{= result.editable }}"
						>
						<div class="col-xs-2">
							<div>{{= result.quoteBrandName }}</div>
							<div>{{= result.quoteType }}</div>
						</div>
						<div class="col-xs-2">
							<ul class="list-unstyled">
								<li>{{= result.id }}</li>
								<li>({{= result.rootid }})</li>
								<li>{{= result.quoteDate }}</li>
								<li>{{= result.quoteTime }}</li>
							</ul>
						</div>
						<div class="col-xs-6">

							{{ if (result.editable === 'C') { }}<span class="pull-left label label-success">SOLD</span>{{ } }}
							{{ if (result.editable === 'F') { }}<span class="pull-left label label-primary">PENDING</span>{{ } }}
							<%-- {{ if (result.editable === '1') { }}<span class="pull-left label label-info">AVAILABLE</span>{{ } }} --%>

							{{ if (result.quoteType === 'health') { }}
								<h3>{{= result.contacts.name }}</h3>

								{{ if (result.applicationEmail !== '') { }}
									<div class="text-info">{{= result.applicationEmail }}</div>
								{{ } else if (result.contacts.yourDtlsEmail !== '') { }}
									<div class="text-info">{{= result.contacts.yourDtlsEmail }}</div>
								{{ } }}

								{{ if (result.contacts.primary.dob !== '') { }}
									<div class="text-info">{{= result.contacts.primary.dob }}</div>
								{{ } else if (result.contacts.primary.yourDtlsDob !== '') { }}
									<div class="text-info">{{= result.contacts.primary.yourDtlsDob }}</div>
								{{ } }}

								{{ if (result.resultData.address !== '') { }}
									<div class="text-info">{{= result.resultData.address }}</div>
								{{ } else if (result.resultData.location !== '') { }}
									<div class="text-info">{{= result.resultData.location }}</div>
								{{ } }}

								<ul class="core-properties list-unstyled small">
									{{ if (result.policyNo !== '') { }}
									<li><strong>Policy No:</strong> <span class="label label-success">{{= result.policyNo }}</span></li>
									{{ } }}
									<li><strong>Situation:</strong> {{= result.resultData.situation }}</li>
									{{ if (result.resultData.income !== '') { }}<li><strong>Income:</strong> {{= result.resultData.income }}</li>{{ } }}
									<li><strong>Dependants:</strong> {{= result.resultData.dependants }}</li>
									<li class="{{= meerkat.modules.benefitsNameConverter.checkIfClinicalCategories(result.resultData.hospitalBenefitsSource) ? 'selected-benefits-info-'+result.id : '' }}">
										<strong>Selected benefits:</strong> ({{= result.resultData.benefitCount }}) {{= meerkat.modules.benefitsNameConverter.sortNames(result.resultData.benefits, result.resultData.benefitTypes) }}</li>
								</ul>
								{{ if( meerkat.modules.benefitsNameConverter.checkIfClinicalCategories(result.resultData.hospitalBenefitsSource)) { }}
								<div class="clinical-benefits-info-{{= result.id }} hidden">
									<div class="line-separator"></div>
									<ul class="core-properties list-unstyled-clinical small">
										<li class="li-bottom-space"><strong>Product type:</strong> {{= meerkat.modules.benefitsNameConverter.covertProductType(result.resultData.coverType) }}</li>
										<li class="li-bottom-space"><strong>Reason:</strong> {{= meerkat.modules.benefitsNameConverter.convertReason(result.resultData.benefitsReason) }}</li>
										<li class="li-bottom-space"><strong>Hospital quick selects:</strong> {{= meerkat.modules.benefitsNameConverter.convertHospital(result.resultData.benefitsQuickSelectHospital) }}</li>
										<li class="li-bottom-space"><strong>Extras quick selects:</strong> {{= meerkat.modules.benefitsNameConverter.convertExtras(result.resultData.benefitsQuickSelectExtras) }}</li>
										<li class="li-bottom-space"><strong>Selected benefits:</strong> ({{= result.resultData.benefitCount }}) {{= meerkat.modules.benefitsNameConverter.sortNames(result.resultData.benefits, result.resultData.benefitTypes) }}</li>
									</ul>
								</div>
								{{ } }}
							{{ } }}

						</div>
						<div class="col-xs-2">
							{{ if (result.editable === 'C') { }}
								<%-- Confirmed, can no longer edit --%>
							{{ } else { }}
								<a class="btn btn-sm btn-save btn-cta needs-loadsafe needs-baseurl" data-action="amend" href="simples/loadQuote.jsp?brandId={{= result.quoteBrandId }}&verticalCode={{= result.quoteType }}&transactionId={{= result.id }}&action=amend">Amend quote <span class="icon icon-arrow-right"></span></a>
							{{ } }}
							<button class="btn btn-sm btn-cancel" data-action="moreinfo">More details</button>
							<%-- <button class="btn btn-sm btn-cancel" data-action="comments">Comments</button> --%>
						</div>
					</div>
				{{ }) }}

			{{ } }}

		</div>
	</div>
</div>

</script>

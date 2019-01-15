<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="resultsHeadersBg">
</div>

<agg_v2_results:results vertical="${pageSettings.getVerticalCode()}">
	<travel:more_info />

<%-- RESULTS TABLE --%>
	<div class="container">
		<div class="row coverLevelTabs visible-xs">
			<div class="currentTabsContainer"></div>
		</div>
	</div>

	<div class="bridgingContainer"></div>
	<div class="resultsContainer v2 results-columns-sm-3 results-columns-md-3 results-columns-lg-3">

		<div class="travelResultsDisclaimerHeader"></div>

		<div class="featuresHeaders featuresElements">
			<div class="result headers">

				<div class="resultInsert">
				</div>

			</div>

			<%-- Feature headers --%>
			<div class="featuresList featuresTemplateComponent">

			</div>
		</div>


		<div class="resultsOverflow">
			<div class="results-table">
				<core_v2:show_more_quotes_button />
			</div>
		</div>

		<core_v1:clear />

		<div class="featuresFooterPusher"></div>
	</div>


<%-- DEFAULT RESULT ROW --%>
<core_v1:js_template id="result-template">
	{{ var productTitle = (typeof obj.des !== 'undefined') ? obj.des : 'Unknown product name'; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}
    {{ var hasSpecialOffer = !_.isEmpty(obj.offer) && _.isObject(obj.offer) && !_.isEmpty(obj.offer.copy) && !_.isEmpty(obj.offer.terms) }}
	{{ var isTripType = meerkat.modules.tripType.exists(); }}
	{{ var tripTypes = meerkat.modules.tripType.get(); }}
	{{ var tripTypeClass = isTripType ? "trip-type-container" : ""; }}
	{{ var specialOfferClass = !isTripType && hasSpecialOffer ? "specialOffer" : ""; }}

	<div class="result-row available result_{{= obj.productId }}"
		 data-productId="{{= obj.productId }}"
		 data-available="Y"
	>
		<div class="result">
			<div class="resultInsert priceMode">
				<%-- START SM and Greater --%>
				<div class="row column-banded-row vertical-center-row {{= tripTypeClass }} hidden-xs">
					<div class="col-sm-2 col-lg-1">
						<div>{{= logo }}</div>
					</div>

					<div class="col-lg-3 visible-lg productTitle {{= tripTypeClass }} {{= specialOfferClass}}">
						{{ if(!isTripType && hasSpecialOffer) { }}
						<div class="innertube">
						{{ } }}
							<div><span>{{= productTitle }}</span></div>
								<travel:results_triptype_icons />
							{{ if (!isTripType && hasSpecialOffer) { }}
							<div class="promotion hidden-sm">
								<span class="icon icon-tag"></span> {{= obj.offer.copy }}
								<a class="small hidden-xs offerTerms" href="javascript:;">Offer terms</a>
								<div class="offerTerms-content hidden">{{= obj.offer.terms }}</div>
							</div>
							{{ } }}
						{{ if(!isTripType && hasSpecialOffer) { }}
						</div>
						{{ } }}
					</div>

                   	<div class="col-sm-2 col-lg-1 excessAmount">
						<div><span>
							{{ if(obj.info.excess === 'Nil') { }}
								{{= '$0' }}
							{{ } else if ((obj.info.excess.indexOf('$') < 0) && (obj.info.excess.indexOf(".") >= 0) ) { }}
								{{= '$' + obj.info.excess.substring(0, obj.info.excess.indexOf(".")) }}
							{{ } else if (obj.info.excess.indexOf('$') < 0 ) { }}
								{{= '$' + obj.info.excess }}
							{{ } else if (obj.info.excess.indexOf(".") >= 0 ) { }}
								{{= obj.info.excess.substring(0, obj.info.excess.indexOf(".")) }}
							{{ } else { }}
								{{= obj.info.excess }}
							{{ } }}
						</span></div>
					</div>
					<div class="col-sm-2 col-lg-1 medicalAmount">
						<div><span>{{= obj.info.medical }}</span></div>
					</div>
					<div class="col-sm-2 col-lg-1 cdxfeeAmount">
						<div><span>{{= obj.info.cxdfee }}</span></div>
					</div>
					<div class="col-sm-2 col-lg-1 luggageAmount">
						<div><span>{{= obj.info.luggage }}</span></div>
					</div>

					<div class="col-sm-2 col-lg-2 priceAmount">
						<div><span>{{= obj.priceText }}</span></div>
					</div>
					<div class="col-sm-12 hidden-lg productTitle {{= specialOfferClass}}">
						<div>
							<span>{{= productTitle }}</span>
							<travel:results_triptype_icons />
						</div>
						{{ if (!isTripType && hasSpecialOffer) { }}
						<div class="promotion">
							<span class="icon icon-tag"></span> {{= obj.offer.copy }}
							<a class="small hidden-xs offerTerms" href="javascript:;">Offer terms</a>
							<div class="offerTerms-content hidden">{{= obj.offer.terms }}</div>
						</div>
						{{ } }}
					</div>

					<div class="col-sm-12 col-lg-2 cta">
						<div class="row">
							<div class="col-sm-4 col-sm-push-8 col-lg-push-0 col-lg-12 buyNow">
								<a class="btn btn-primary btn-block btn-apply" href="javascript:;" data-productId="{{= obj.productId }}">
								<span>Continue to Insurer</span> <span class="icon icon-arrow-right" /></a>
							</div>
							<div class="col-sm-4 col-sm-pull-4 col-lg-pull-0 col-lg-6 moreInfo">
								<a href="javascript:;" class="btn-more-info" data-available="{{= obj.available }}" data-productId="{{= obj.productId }}">More Info</a>
							</div>
							<div class="col-sm-4 col-sm-pull-4 col-lg-pull-0 col-lg-6 PDS">
								<a href="{{=obj.subTitle}}" target="_blank" class="showDoc">PDS</a>
							</div>
						</div>
					</div>
				</div><%-- END SM and Greater --%>

				<%-- START XS Top Row --%>
				<div class="row visible-xs">
					<div class="col-xs-3 logoContainer">
						{{= logo }}
					</div>
					<div class="col-xs-9">
						<div class="row">
							<div class="priceExcessContainer clearfix">
								<div class="productTitle singleProductTitle">
									{{= productTitle }}
								</div>
								<div class="clearfix topContainer">
									<div class="col-xs-6 priceContainer">
										<span class="priceAmount">
											{{= obj.priceText }}

										</span>
										<span class="priceTitle">Price</span>
									</div>
									<div class="col-xs-6 gotoContainer">
										<a class="btn btn-primary btn-block btn-apply" href="javascript:;" data-productId="{{= obj.productId }}">
											<span>Go to Insurer</span> <span class="icon icon-arrow-right" />
										</a>
									</div>
								</div>
								<div class="clearfix btmContainer">
									<div class="col-xs-6 excessContainer">
										<span class="excessAmount">{{= obj.info.excess }}</span>
										<span class="excessTitle">Excess</span>
									</div>
									<div class="col-xs-6 text-center infoContainer">
											<a href="javascript:;">More Info <span class="icon icon-angle-right" /></a>
									</div>
								</div>
							</div>
						</div>
					</div><%-- /col-xs-10 --%>
					<div class="col-xs-12 multiProductTitle">
						<div class="productTitle">
						{{= productTitle }}
						</div>
					</div>
					<%-- mainBenefitsContainer used to be here --%>
				</div><%-- END XS Top Row --%>

			</div><%-- /resultInsert --%>
			<div class="{{= tripTypeClass}} visible-xs">
				<travel:results_triptype_icons />
			</div>
			<%-- START XS Bottom Row --%>
			<div class="row container visible-xs mainBenefitsContainer clearfix">
				<div class="row mainBenefitsHeading">
					<div class="col-xs-4 medicalTitle">
						O.S.Medical
					</div>
					<div class="col-xs-4 cdxfeeTitle">
						Cancellation
					</div>
					<div class="col-xs-4 luggageTitle">
						Luggage
					</div>
				</div>
				<div class="row mainBenefitsPricing">
					<div class="col-xs-4 medicalAmount">
						{{= obj.info.medical }}
					</div>
					<div class="col-xs-4 cdxfeeAmount">
						{{= obj.info.cxdfee }}
					</div>
					<div class="col-xs-4 luggageAmount">
						{{= obj.info.luggage }}
					</div>
				</div>
			</div><%-- /mainBenefitsContainer --%>
		</div>
		<%-- END XS Bottom Row --%>

		<%-- Feature list, defaults to a spinner --%>
		<div class="featuresList featuresElements">

		</div>

	</div>
</core_v1:js_template>

<%-- FEATURE TEMPLATE --%>
	<core_v1:js_template id="feature-template"></core_v1:js_template>

<%-- UNAVAILABLE ROW --%>
<core_v1:js_template id="unavailable-template">
	{{ var productTitle = (typeof obj.headline !== 'undefined' && typeof obj.headline.name !== 'undefined') ? obj.headline.name : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.headline !== 'undefined' && typeof obj.headline.des !== 'undefined') ? obj.headline.des : 'Unknown product name'; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	<div class="result-row unavailable result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="N">
		<div class="result">
			<div class="unavailable featuresMode">
				<div class="productSummary results">
				</div>
			</div>

			<div class="unavailable priceMode">
				<div class="row">
					<div class="col-xs-2 col-sm-8 col-md-6">
						{{= logo }}

						<h2 class="hidden-xs">{{= productTitle }}</h2>

						<p class="description hidden-xs">{{= productDescription }}</p>
					</div>
					<div class="col-xs-10 col-sm-4 col-md-6">
						<p class="specialConditions">We're sorry but these providers did not return a quote:</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- UNAVAILABLE COMBINED ROW --%>
<core_v1:js_template id="unavailable-combined-template">
	<div class="result-row result_unavailable_combined notfiltered" data-available="N" style="display:block" data-position="{{= obj.length }}" data-sort="{{= obj.length }}">
		<div class="result">
			<div class="unavailable featuresMode">
				<div class="productSummary results clearfix">

				</div>
			</div>

			<div class="unavailable priceMode center clearfix">
				<p>Some of our partners did not return quotes. This might be due to commercial reasons (for example, based on the information you provided,<br>they may have decided not to offer certain products to you) or because of technical issues.</p>
				<div class="clearfix"></div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- ERROR ROW --%>
<core_v1:js_template id="error-template">
	{{ var productTitle = (typeof obj.headline !== 'undefined' && typeof obj.headline.name !== 'undefined') ? obj.headline.name : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.headline !== 'undefined' && typeof obj.headline.des !== 'undefined') ? obj.headline.des : 'Unknown product name'; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	<div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="E">
		<div class="result">
			<div class="resultInsert featuresMode">
				<div class="productSummary results">

				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-2 col-sm-8 col-md-6">
						<div class="companyLogo"><img src="assets/graphics/logos/results/{{= obj.productId }}_w.png" /></div>

						<h2 class="hidden-xs">{{= productTitle }}</h2>

						<p class="description hidden-xs">{{= productDescription }}</p>
					</div>
					<div class="col-xs-10 col-sm-4 col-md-6">
						<p class="specialConditions">We're sorry but these providers did not return a quote:</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>
<%-- BLOCKED QUOTES --%>
<div class="hidden">
	<agg_v2:no_quotes id="blocked-ip-address"/>
</div>

<%-- NO RESULTS --%>
<div class="hidden">
	<agg_v2:no_quotes id="no-results-content"/>
</div>

<div class="hidden">
	<div id="invalid-date">
		<div class="col-xs-12 modal-invalid-date-content">
			<h2 style="text-align: center; margin-bottom: 4rem;">It looks like your original departure date has already arrived.</h2>
		</div>
		<div class="modal-closebar">
			<a href="javascript:;" class="btn btn-close-dialog btn-close-more-info"><span class="icon icon-cross"></span></a>
		</div>
		<div class="col-sm-offset-3 col-xs-12 col-sm-6 col-md-6">
			<a href="javascript:;" class="btn btn-block btn-secondary btn-close-dialog">Click here to enter new travel dates</a>
		</div>
	</div>
</div>

<%-- FETCH ERROR --%>
<div class="resultsFetchError displayNone">
	Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later</a>.
</div>

<%-- Logo template --%>
<core_v1:js_template id="provider-logo-template">
	{{ var img = 'default_w'; }}
	{{ if (obj.hasOwnProperty('serviceName') && obj.serviceName.length > 1) img = obj.serviceName; }}
	<div class="travelCompanyLogo logo_{{= img }}"></div>
</core_v1:js_template>

</agg_v2_results:results>

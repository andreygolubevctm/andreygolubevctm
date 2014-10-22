<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ attribute name="policyType" 	required="true"	 rtexprvalue="true"	 description="Defines if this is a single or AMT" %>

<%-- <car:results_filterbar_xs /> --%>


<div class="resultsHeadersBg">
</div>

<agg_new_results:results vertical="${pageSettings.getVerticalCode()}">

	<travel_new:more_info />

<%-- RESULTS TABLE --%>
	<div class="bridgingContainer"></div>
	<div class="resultsContainer v2 results-columns-sm-3 results-columns-md-3 results-columns-lg-3" policytype="${policyType}">
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
			<div class="results-table"></div>
		</div>

		<core:clear />

		<div class="featuresFooterPusher"></div>
	</div>

<%-- DEFAULT RESULT ROW --%>
<core:js_template id="result-template">
	{{ var productTitle = (typeof obj.des !== 'undefined') ? obj.des : 'Unknown product name'; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}


	<div class="result-row available result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="Y">
		<div class="result">
			<div class="resultInsert priceMode">
				<%-- START SM and Greater --%>
				<div class="row column-banded-row vertical-center-row hidden-xs">
					<div class="col-sm-2 col-lg-1">
						<div>{{= logo }}</div>
					</div>
					<div class="col-lg-3 visible-lg productTitle">
						<div><span>{{= productTitle }}</span></div>
					</div>
					<div class="col-sm-2 col-lg-1 excessAmount">
						<div><span>{{= obj.info.excess.text }}</span></div>
					</div>
					<div class="col-sm-2 col-lg-1 medicalAmount">
						<div><span>{{= obj.info.medical.text }}</span></div>
					</div>
					<div class="col-sm-2 col-lg-1 cdxfeeAmount">
						<div><span>{{= obj.info.cxdfee.text }}</span></div>
					</div>
					<div class="col-sm-2 col-lg-1 luggageAmount">
						<div><span>{{= obj.info.luggage.text }}</span></div>
					</div>
					<div class="col-sm-2 col-lg-2 priceAmount">
						<div><span>{{= obj.priceText }}</span></div>
					</div>
					<div class="col-sm-12 hidden-lg productTitle">
						<div><span>{{= productTitle }}</span></div>
					</div>
					<div class="col-sm-12 col-lg-2 cta">
						<div class="row">
							<div class="col-sm-4 col-sm-push-8 col-lg-push-0 col-lg-12 buyNow">
								<a class="btn btn-primary btn-block btn-apply" href="javascript:;" data-productId="{{= obj.productId }}">Buy Now <span class="icon icon-arrow-right" /></a>
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
								<c:if test="${policyType == 'S'}">
									<div class="productTitle">
										{{= productTitle }}
									</div>
								</c:if>
								<div class="col-xs-6 priceContainer">
									<span class="priceAmount">
										{{= obj.priceText }}
										
									</span>
									<span class="priceTitle">Price</span>						 
								</div>
								<div class="col-xs-6 excessContainer">
									<span class="excessAmount">{{= obj.info.excess.text }}</span>
									<span class="excessTitle">Excess</span>
								</div>
							</div>
						</div>
					</div><%-- /col-xs-10 --%>
					<c:if test="${policyType == 'A'}">
						<div class="col-xs-12">
							<div class="productTitle">
							{{= productTitle }}
							</div>
						</div>
					</c:if>
					<%-- mainBenefitsContainer used to be here --%>
				</div><%-- END XS Top Row --%>

			</div><%-- /resultInsert --%>
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
						{{= obj.info.medical.text }}
					</div>
					<div class="col-xs-4 cdxfeeAmount">
						{{= obj.info.cxdfee.text }}
					</div>
					<div class="col-xs-4 luggageAmount">
						{{= obj.info.luggage.text }}
					</div>
				</div>
			</div><%-- /mainBenefitsContainer --%>
		</div>
		<%-- END XS Bottom Row --%>

		<%-- Feature list, defaults to a spinner --%>
		<div class="featuresList featuresElements">
			<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/><%-- #WHITELABEL CX --%>
		</div>

	</div>
</core:js_template>

<%-- FEATURE TEMPLATE --%>
	<div id="feature-template" style="display:none;" class="featuresTemplateComponent">

	</div>

<%-- UNAVAILABLE ROW --%>
<core:js_template id="unavailable-template">
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
</core:js_template>

<%-- UNAVAILABLE COMBINED ROW --%>
<core:js_template id="unavailable-combined-template">
{{ var template = $("#provider-logo-template").html(); }}
{{ var logo = _.template(template); }}
{{ var logos = ''; }}
{{ _.each(obj, function(result) { }}
{{	if (result.available !== 'Y') { }}
{{		logos += logo(result); }}
{{	} }}
{{ }) }}
	<div class="result-row result_unavailable_combined notfiltered" data-available="N" style="display:block" data-position="{{= obj.length }}" data-sort="{{= obj.length }}">
		<div class="result">
			<div class="unavailable featuresMode">
				<div class="productSummary results clearfix">
					
				</div>
			</div>

			<div class="unavailable priceMode clearfix">
				<p>We're sorry but these providers did not return a quote:</p>
				{{= logos }}
				<div class="clearfix"></div>
			</div>
		</div>
	</div>
</core:js_template>

<%-- ERROR ROW --%>
<core:js_template id="error-template">
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
						<div class="companyLogo"><img src="common/images/logos/results/{{= obj.productId }}_w.png" /></div>

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
</core:js_template>

<%-- NO RESULTS --%>
<div class="hidden">
	<agg_new_results:results_none />
</div>

<%-- FETCH ERROR --%>
<div class="resultsFetchError displayNone">
	Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later</a>.
</div>

<%-- Logo template --%>
<core:js_template id="provider-logo-template">
	{{ var img = 'default_w'; }}
	{{ if (obj.hasOwnProperty('productId') && obj.productId.length > 1) img = obj.productId.substring(0, obj.productId.indexOf('-')); }}
	<div class="travelCompanyLogo logo_{{= img }}"></div>
</core:js_template>

<%-- Prompt --%>
<div data-spy="affix" class="hidden-xs container morePromptContainer">
	<span class="morePromptCell">
		<a href="javascript:;" class="morePromptLink"><span class="icon icon-angle-down"></span>Scroll to view more quotes<span class="icon icon-angle-down"></span></a>
	</span>
</div>

</agg_new_results:results>
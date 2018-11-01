<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Car price mode templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="excess-price-template">
    <div class="excess-container">
        <div class="excess">
            <div class="excessAmount">{{= '$' }}{{= obj.excess }}</div>
            <div class="excessTitle">Excess</div>
        </div>

        <a href="javascript:;" class="link-more-info" data-productId="{{= obj.productId }}">View all excesses</a>
    </div>
</core_v1:js_template>

<core_v1:js_template id="compare-basket-price-item-template">
    {{ var tFrequency = Results.getFrequency(); }}
    {{ var tDisplayMode = Results.getDisplayMode(); }}
    {{ var monthlyHidden = tFrequency == 'monthly' ? '' : 'displayNone'; }}
    {{ var annualHidden = tFrequency == 'annual' ? '' : 'displayNone'; }}

    {{ for(var i = 0; i < products.length; i++) { }}
    {{ var img = products[i].productId.substring(0, products[i].productId.indexOf('-')); }}
    <li class="compare-item">
  		<div class="compareContainer">
  			<div class="logoPriceContainer">
  				<span class="companyLogo logo_{{= img }}" title="{{= products[i].name }}"></span>
  				<span class="price">
  					<span class="frequency annual annually {{= annualHidden }}">
  						{{= '$' }}{{= products[i].price.annualPremiumFormatted }}
  					</span>
  					<span class="frequency monthly {{= monthlyHidden }}">
  						{{= '$' }}{{= products[i].price.monthlyPremium.toFixed(2) }}
  					</span>
  				</span>
  				</div>
  		<div class="productName">
  			<span>
  				{{= products[i].productName }}
  			</span>
  		</div>
  	</div>
  	<div class="remove-compare" data-productId="{{= products[i].productId }}" title="Remove from shortlist">
  		<span class="icon icon-cross"></span>
  	</div>
  	</li>
  	{{ } }}
</core_v1:js_template>

<!-- Compare view from quick price view. -->
<core_v1:js_template id="compare-basket-price-template">

	{{ var template = $("#compare-basket-price-item-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var comparedItems = htmlTemplate(obj); }}

	<ul class="nav navbar-nav">

		{{= comparedItems }}
		{{ for(var i = 3; i > comparedResultsCount; i--) { }}
			<li class="compare-item-placeholder">
				Select a product above to compare
			</li>
		{{ } }}

		<li class="navbar-right">
		{{ if(comparedResultsCount > 1) { }}
			<a href="javascript:void(0);" class="compareBtn enter-compare-mode compare-list" ${navBtnAnalAttribute}>Start Comparing <span class="icon icon-angle-right"></span></a>
		{{ } else { }}
			<span class="compareBtn" ${navBtnAnalAttribute}>Start Comparing <span class="icon icon-angle-right"></span></span>
		{{ } }}
		</li>
	</ul>

</core_v1:js_template>

<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="HnC price mode templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="excess-price-template">
    {{ var className = ''; }}
    {{ if (obj.contentsExcess !== null && obj.contentsExcess.amount !== '' && obj.homeExcess !== null && obj.homeExcess.amount !== '') { }}
        {{ className = ' has-both-excess'; }}
    {{ } }}

    <div class="excess-container{{= className }}">
        {{ if (obj.homeExcess !== null && obj.homeExcess.amount !== '') { }}
            <div class="excess">
                <div class="excessAmount">{{= obj.homeExcess.amountFormatted }}</div>
                {{ if(meerkat.site.isLandlord) { }}
                    <div class="excessTitle">Building<br /> excess</div>
                {{ } else { }}
                    <div class="excessTitle">Home<br /> excess</div>
                {{ } }}
                
            </div>
        {{ } }}

        {{ if (obj.contentsExcess !== null && obj.contentsExcess.amount !== '') { }}
            <div class="excess">
                <div class="excessAmount excessContents">{{= obj.contentsExcess.amountFormatted }}</div>
                <div class="excessTitle">Contents<br /> excess</div>
            </div>
        {{ } }}

        <a href="javascript:;" class="link-more-info" data-productId="{{= obj.productId }}">Additional Excesses Applicable</a>
    </div>
</core_v1:js_template>

<core_v1:js_template id="compare-basket-price-item-template">
    {{ var tFrequency = Results.getFrequency(); }}
    {{ var tDisplayMode = Results.getDisplayMode(); }}
    {{ var monthlyHidden = tFrequency == 'monthly' ? '' : 'displayNone'; }}
    {{ var annualHidden = tFrequency == 'annual' ? '' : 'displayNone'; }}

    {{ for(var i = 0; i < products.length; i++) { }}
    {{ var img = products[i].brandCode; }}
    {{ if ((typeof img === 'undefined' || img === '') && products[i].hasOwnProperty('productId') && products[i].productId.length > 1) img = products[i].productId.substring(0, products[i].productId.indexOf('-')); }}

    <li class="compare-item">
  		<div class="compareContainer">
  			<div class="logoPriceContainer">
  				<span class="companyLogo logo_{{= img }}" title="{{= products[i].name }}"></span>
  				<span class="price">
  					<span class="frequency annual annually {{= annualHidden }}">
  						{{= '$' }}{{= products[i].price.annualPremiumFormatted }}
  					</span>
					<c:if test="${not empty products[i].price.monthlyPremium}">
						<span class="frequency monthly {{= monthlyHidden }}">
  						{{= '$' }}{{= products[i].price.monthlyPremium.toFixed(2) }}
  						</span>
					</c:if>
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
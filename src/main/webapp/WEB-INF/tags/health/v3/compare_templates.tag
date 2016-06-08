<core_v1:js_template id="compare-basket-features-template">
    <div class="compare-basket compareCheckbox">
        {{ if(comparedResultsCount === 0) { }}
        <p>
            Click the <input type="checkbox" class="compare-tick" checked disabled><label></label> &nbsp; to add up to <span class="compare-max-count-label">{{= maxAllowable }} products</span> to
            your shortlist.
        </p>
        {{ } else { }}

        {{ var template = $("#compare-basket-features-item-template").html(); }}
        {{ var htmlTemplate = _.template(template); }}
        {{ var comparedItems = htmlTemplate(obj); }}

        <h3>Your shortlist</h3>
        <ul class="compareCheckbox compared-products-list">

            {{= comparedItems }}

            {{ if(comparedResultsCount < maxAllowable && isCompareOpen === false) { }}
            {{ template = $("#compare-basket-features-placeholder-template").html(); }}
            {{ htmlTemplate = _.template(template); }}
            {{ var placeholderItem = htmlTemplate(); }}
            {{ for(var m = 0; m < maxAllowable-comparedResultsCount; m++) { }}
            {{= placeholderItem }}
            {{ } }}
            {{ } }}
        </ul>
        {{ if (comparedResultsCount > 1) { }}
        <div class="compareButtonsContainer">
            {{ if(meerkat.modules.compare.isCompareOpen() === true) { }}
            <a class="btn btn-features-compare clear-compare btn-block" href="javascript:;">Clear Shortlist<span class="icon icon-arrow-right"></span></a>
            {{ } else { }}
            <a class="btn btn-features-compare enter-compare-mode btn-block" href="javascript:;">Compare<span class="icon icon-arrow-right"></span></a>
            {{ } }}
        </div>
        {{ } }}
        {{ } }}
    </div>
</core_v1:js_template>

<%-- COMPARE BAR ITEM --%>
<script id="compare-basket-features-item-template" type="text/html">
    {{ var tFrequency = Results.getFrequency(); }}
    {{ var displayNone = 'displayNone'; }}
    {{ var weeklyHidden = tFrequency == 'weekly' ? '' : displayNone; }}
    {{ var fortnightlyHidden = tFrequency == 'fortnightly' ? '' : displayNone; }}
    {{ var monthlyHidden = tFrequency == 'monthly' ? '' : displayNone; }}
    {{ var quarterlyHidden = tFrequency == 'quarterly' ? '' : displayNone; }}
    {{ var halfyearlyHidden = tFrequency == 'halfyearly' ? '' : displayNone; }}
    {{ var annuallyHidden = tFrequency == 'annually' ? '' : displayNone; }}

    {{ for(var i = 0; i < obj.products.length; i++) { }}
    {{var prod = products[i]; }}
    <li>

			<span class="active-product">
				<input type="checkbox" class="compare-tick checked" data-productId="{{= prod.productId }}" id="features_compareTick_{{= prod.productId }}" checked/>
				<label for="features_compareTick_{{= prod.productId }}"></label>
			</span>

        <span class="name">{{= prod.info.providerName }}</span>
			<span class="price">
				<span class="frequency annual annually {{= annuallyHidden }}">
					{{= prod.premium.annually.lhcfreetext }}
				</span>
				<span class="frequency halfyearly {{= halfyearlyHidden }}">
					{{= prod.premium.halfyearly.lhcfreetext }}
				</span>
				<span class="frequency quarterly {{= quarterlyHidden }}">
					{{= prod.premium.quarterly.lhcfreetext }}
				</span>
				<span class="frequency monthly {{= monthlyHidden }}">
					{{= prod.premium.monthly.lhcfreetext }}
				</span>
				<span class="frequency fortnightly {{= fortnightlyHidden }}">
					{{= prod.premium.fortnightly.lhcfreetext }}
				</span>
				<span class="frequency weekly {{= weeklyHidden }}">
					{{= prod.premium.weekly.lhcfreetext }}
				</span>
			</span>
    </li>
    {{ } }}
</script>

<script id="compare-basket-features-placeholder-template" type="text/html">
    <li class="compare-placeholder">
			<span class="active-product">
				<input type="checkbox" class="compare-tick" disabled/>
				<label></label>
			</span>
        <span class="name">select another product</span>
    </li>
</script>
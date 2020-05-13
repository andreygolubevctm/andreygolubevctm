<%@ tag description="The Results Special Offers/Discounts/Restricted Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="results-product-additional-features-template">
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ var structure = module.parseAdditionalFeatures(obj); }}
    {{ var content = module.getAdditionalFeaturesContent(obj, structure, 0);}}
    {{ var canDisplaySpecialFeatures = module.checkIfCanDisplaySpecialFeatures(structure)}}
    <div class="product-additional-features features-1 content isMultiRow" data-featureId="888889">
        {{ if (canDisplaySpecialFeatures){ }}
            <span class="feature-item-offer">ADDITIONAL FEATURES:</span>
        {{ } }}
        {{= content }}
        <div class="clearfix"></div>
    </div>
</core_v1:js_template>
<core_v1:js_template id="results-product-additional-features-popover-template">
    <div class="feature-item item-popover">
        <span class="icon {{= obj.className }}"
              data-title="{{= obj.title }}"
              data-toggle="popover"
              data-adjust-y="5"
              data-trigger="mouseenter click"
              data-my="top center"
              data-at="bottom center"
              data-content="#content{{= obj.id }}-{{= obj.productId}}"
              data-class="specialFeature"></span>
    </div>
    <div class="hidden" id="content{{= obj.id }}-{{= obj.productId}}">{{= obj.text }}</div>
</core_v1:js_template>
<core_v1:js_template id="results-product-additional-features-inline-template">
    {{ if(obj.id === 'restrictedFund') { }}
        <span class="icon {{= obj.className }}"></span>
    {{ } }}
    {{ if(obj.text) { }}
    <div class="feature-item">
        <div class="feature-item-text">
            <div class="offer-text">
                {{= obj.text }}
            </div>
        </div>
    </div>
    {{ } }}
</core_v1:js_template>

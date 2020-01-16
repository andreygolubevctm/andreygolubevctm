<%@ tag description="The Results Special Offers/Discounts/Restricted Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="results-product-special-features-template">
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ var structure = module.parseSpecialFeatures(obj); }}
    {{ var content = module.getSpecialFeaturesContent(obj, structure, 2);}}
    {{ var canDisplaySpecialFeatures = module.checkIfCanDisplaySpecialFeatures(structure)}}
    <%-- TODO: once we figured out how to display more than 2 icons, change this back to normal featrueCount--%>
    {{ var featureCount = module.getAvailableFeatureCount(structure) >= 2 ? 2 : 1; }}
    <div class="product-special-features features-1 content isMultiRow" data-featureId="888888">
        {{ if (canDisplaySpecialFeatures){ }}
            <span class="feature-item-offer">SPECIAL OFFER:</span>
        {{ } }}
        {{= content }}
        <div class="clearfix"></div>
    </div>
</core_v1:js_template>
<core_v1:js_template id="results-product-special-features-popover-template">
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
<core_v1:js_template id="results-product-special-features-inline-template">
    {{ if(obj.id === 'restrictedFund') { }}
        <span class="icon {{= obj.className }}"></span>
    {{ } }}
    {{ if(obj.text) { }}
    <div class="feature-item">
        <div class="feature-item-text">
            <span class="icon-star"/>
            <div class="offer-text">
                {{= obj.text }}
            </div>
        </div>
    </div>
    {{ } }}
</core_v1:js_template>

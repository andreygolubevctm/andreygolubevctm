<%@ tag description="The Results Special Offers/Discounts/Restricted Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="results-product-special-features-template">
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ var structure = module.parseSpecialFeatures(obj); var content = module.getSpecialFeaturesContent(obj, structure, 2); }}
    <%-- TODO: once we figured out how to display more than 2 icons, change this back to normal featrueCount--%>
    {{ var featureCount = module.getAvailableFeatureCount(structure) >= 2 ? 2 : 1; }}
    <div class="product-special-features features-{{= featureCount }} content isMultiRow" data-featureId="888888">
        {{= content }}
        <div class="clearfix"></div>
    </div>
</core_v1:js_template>
<core_v1:js_template id="results-product-special-features-popover-template">
    <div class="feature-item item-popover">
        <span class="icon {{= obj.className }}" data-title="{{= obj.title }}" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center"
              data-at="bottom center" data-content="#content{{= obj.id }}-{{= obj.productId}}" data-class="specialFeature"></span>
    </div>
    <div class="hidden" id="content{{= obj.id }}-{{= obj.productId}}">{{= obj.text }}</div>
</core_v1:js_template>
<core_v1:js_template id="results-product-special-features-inline-template">
    <div class="feature-item">
        <span class="icon {{= obj.className }}"></span>
        <div class="feature-item-text">{{= obj.text }}</div>
    </div>
</core_v1:js_template>
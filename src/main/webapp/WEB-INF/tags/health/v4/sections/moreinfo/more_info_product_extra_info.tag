<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
{{ var addToColumns = function(type, text) { }}
{{    if (!text || text.length === 0) return; }}
{{    if (ind % 2 === 0) { }}
{{        leftCol.push({type: type, text: text}); }}
{{    } else { }}
{{        rightCol.push({type: type, text: text}); }}
{{    } }}
{{    ind++; }}
{{ } }}

{{ var getProductProperty = function(path) { }}
{{    return path.reduce((p, x) => (p && p[x]) ? p[x] : null, product); }}
{{ } }}

{{ var leftCol = []; var rightCol = []; var ind = 1;}}
{{ addToColumns('Offer', getProductProperty(['promo', 'promoText'])); }}
{{ addToColumns('Discount', getProductProperty(['promo', 'discountText'])); }}
{{ addToColumns('Reward', getProductProperty(['awardScheme', 'text'])); }}
{{ addToColumns('Other', getProductProperty(['custom', 'info', 'content', 'results', 'header', 'text'])); }}

<div class="col-xs-12">
    <div class="moreInfoProductSummaryRow">
        <div class="moreInfoProductSummaryColumn">
            <health_v4_moreinfo:more_info_price_promise />

            {{ for (var i = 0; i < leftCol.length; i++) { }}
            <div class="productExtraInfoItem">
                <div class="extraInfoItemType">
                    {{= leftCol[i].type }}
                </div>
                <div class="extraInfoItemText">
                    <p>{{= leftCol[i].text }}</p>
                </div>
            </div>
            {{ } }}
        </div>
        <div class="moreInfoProductSummaryColumn">
            {{ for (var i = 0; i < rightCol.length; i++) { }}
            <div class="productExtraInfoItem">
                <div class="extraInfoItemType">
                    {{= rightCol[i].type }}
                </div>
                <div class="extraInfoItemText">
                    <p>{{= rightCol[i].text }}</p>
                </div>
            </div>
            {{ } }}
        </div>
    </div>
</div>

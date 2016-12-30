<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var noOfCols= 4; }}

{{ if (promo.promoText == '') { }}
    {{ noOfCols--; }}
{{ } }}

{{ if (promo.discountText == '') { }}
    {{ noOfCols--; }}
{{ } }}

{{ var colWidth = 12 / noOfCols; }}

<!-- Product extra info -->
<div class="row productExtraInfo">
    {{ if (promo.promoText !== ''){ }}
    <div class="col-xs-{{= colWidth }} promoText">{{= promo.promoText }}</div>
    {{ } }}
    <div class="col-xs-{{= colWidth }}">Buy online to get a to text</div>
    {{ if (promo.discountText !== ''){ }}
    <div class="col-xs-{{= colWidth }} discountText">{{= promo.discountText }}</div>
    {{ } }}
    <div class="col-xs-{{= colWidth }}">Restricted fund product text</div>
</div>
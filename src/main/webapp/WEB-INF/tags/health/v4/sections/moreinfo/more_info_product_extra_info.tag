<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var noOfCols= 3; }}

{{ if (promo.promoText == '') { }}
    {{ noOfCols--; }}
{{ } }}

{{ if (promo.discountText == '') { }}
    {{ noOfCols--; }}
{{ } }}

{{ if (info.restrictedFund == 'Y'){ }}
    {{ noOfCols--; }}
{{ } }}

{{ var colWidth = 12 / noOfCols; }}

<!-- Product extra info -->
<div class="row productExtraInfo">
    {{ if (promo.promoText !== ''){ }}
    <div class="col-xs-{{= colWidth }} promoText">{{= promo.promoText }}</div>
    {{ } }}
    {{ if (promo.discountText !== ''){ }}
    <div class="col-xs-{{= colWidth }} discountText">{{= promo.discountText }}</div>
    {{ } }}
    {{ if (info.restrictedFund == 'Y'){ }}
    <div class="col-xs-{{= colWidth }}">Restricted fund</div>
    {{ } }}
</div>
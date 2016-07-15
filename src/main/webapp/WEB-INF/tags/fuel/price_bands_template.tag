<%@ tag description="Fuel Price Bands" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="price-band-template">
    <p>Price bands based on <strong id="fuel-map-location">{{= obj.cityName }}</strong> prices</p>
    {{ if(obj.error) { }}
    <p>
        <span class="circle hidden-xs "><span class="icon"></span> </span>
        <span class="fuel-price">price unavailable</span>
    </p>
    {{ } else { }}
    {{ _.each(obj.bands, function(band) { }}
    <div class="fuel-band fuel-band-{{= band.id}}">
        <span class="circle hidden-xs"><span class="icon icon-vert-fuel"></span> </span>
        <span class="fuel-price">
            {{ if (!band.toPrice){ }}
            &le; {{= band.fromPrice}}
            {{ } else if (!band.fromPrice){ }}
            &ge; {{= band.toPrice}}
            {{ } else { }}
            {{= band.fromPrice }} - {{= band.toPrice }}
            {{ } }}
        </span>
    </div>
    {{ }); }}
    <div class="fuel-band hidden-xs">
        <span class="circle "><span class="icon"></span> </span>
        <span class="fuel-price">price unavailable</span>
    </div>
    {{ } }}
    <div id="provider-disclaimer" class="short-disclaimer hidden-xs">
        <p><span class="supplier">Data supplied by Motormouth</span></p>
    </div>
</core_v1:js_template>
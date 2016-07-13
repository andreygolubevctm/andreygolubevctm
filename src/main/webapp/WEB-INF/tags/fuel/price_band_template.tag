<%@ tag description="Fuel Price Bands" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="price-band-template">
    {{ if(obj.error) { }}
    <p>Price bands are not available for this location.</p>
    {{ } else { }}
    <p>Price bands based on <strong id="fuel-map-location">{{= obj.cityName }}</strong> prices</p>
    {{ _.each(obj.bands, function(band) { }}
    <div class="fuel-band fuel-band-{{= band.id}}">
        <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
        <span class="fuel-price">
            {{ if (!band.toPrice){ }}
            ≤ {{= band.fromPrice}}
            {{ } else if (!band.fromPrice){ }}
            ≥ {{= band.toPrice}}
            {{ } else { }}
            {{= band.fromPrice }} - {{= band.toPrice }}
            {{ } }}
        </span>
    </div>
    {{ }); }}
    <div class="fuel-band">
        <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
        <span class="fuel-price">price unavailable</span>
    </div>
    {{ } }}
    <div id="provider-disclaimer" class="short-disclaimer">
        <p><span class="supplier">Data supplied by Motormouth</span></p>
    </div>
</core_v1:js_template>